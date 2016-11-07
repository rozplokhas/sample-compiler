type opnd =
| R  of int    (* register          *)
| RR of int    (* reserved register *)
| S  of int    (* stack             *)
| M  of string (* global variable   *)
| C  of int    (* constant          *)
| A  of int    (* argment           *)
| L  of int    (* local variable    *)

let x86regs = [|
    "%eax"; 
    "%ebx"; 
    "%ecx"; 
    "%esi"; 
    "%edi"
|]

let x86_reserved_regs = [|
    "%edx"
|]

let num_of_regs = Array.length x86regs
let word_size = 4

let eax = R  0
let ebx = R  1
let ecx = R  2
let edx = RR 0
let esi = R  3
let edi = R  4

type instr =
| X86Binop of string * opnd * opnd
| X86Push  of opnd
| X86Pop   of opnd
| X86Div   of opnd
| X86Ret
| X86Cdq
| X86Call  of string
| X86Jmp   of string
| X86Jmpz  of string
| X86Label of string
| X86Set   of string * string

let addl  x y = X86Binop ("addl",  x, y)
let subl  x y = X86Binop ("subl",  x, y)
let imull x y = X86Binop ("imull", x, y)
let movl  x y = X86Binop ("movl",  x, y)
let xchg  x y = X86Binop ("xchg",  x, y)
let xorl  x y = X86Binop ("xorl",  x, y)
let cmp   x y = X86Binop ("cmp",   x, y)
let orl   x y = X86Binop ("orl",   x, y)
let andl  x y = X86Binop ("andl",  x, y)
let set   f r = X86Set   (f, r)

let cmps = [
    "<=", "le";
    "<" , "l" ;
    "==", "e" ;
    "!=", "ne";
    ">" , "g" ;
    ">=", "ge"
]
                         
let is_cmp_op      op = List.mem op (fst @@ List.split cmps)
let cmp_op_by_sign s  = List.assoc s cmps 

module S = Set.Make (String)

class x86env =
    object(self)
        val    local_vars = ref S.empty
        method local x    = local_vars := S.add x !local_vars
        method local_vars = S.elements !local_vars

        val    allocated  = ref 0
        method allocate n = allocated := max n !allocated
        method allocated  = !allocated
    end

let allocate env stack =
    match stack with
    | []                              -> R 0
    | (S n)::_                        -> env#allocate (n + 2); S (n + 1)
    | (R n)::_ when n < num_of_regs-1 -> R (n + 1)
    | _                               -> env#allocate 1; S 0

module Show = struct

    let opnd = function
        | R  i -> x86regs.(i)
        | RR i -> x86_reserved_regs.(i)
        | S  i -> Printf.sprintf "-%d(%%ebp)" (i * word_size)
        | M  x -> x
        | C  i -> Printf.sprintf "$%d" i


    let instr = function
        | X86Binop (op, s1, s2) -> Printf.sprintf "\t%s\t%s,\t%s" op (opnd s1) (opnd s2)
        | X86Push   s           -> Printf.sprintf "\tpushl\t%s" (opnd s)
        | X86Pop    s           -> Printf.sprintf "\tpopl\t%s"  (opnd s)
        | X86Div    s           -> Printf.sprintf "\tidiv\t%s"  (opnd s)
        | X86Ret                -> "\tret"
        | X86Cdq                -> "\tcdq"
        | X86Call   p           -> Printf.sprintf "\tcall\t%s" p
        | X86Jmp    p           -> Printf.sprintf "\tjmp\t%s"  p
        | X86Jmpz   p           -> Printf.sprintf "\tjz\t%s"   p
        | X86Label  p           -> Printf.sprintf "%s:"        p
        | X86Set   (cmp, reg)   -> Printf.sprintf "\tset%s\t%%%s" cmp reg
        
end

module Compile : sig

    val stack_program : x86env -> StackMachine.instr list -> instr list

end = struct

        open StackMachine

        let safe_prefix src dest =
            match src, dest with
            | S _, S _ | S _, M _ | M _, S _ -> RR 0, [movl src (RR 0)]  
            | _                              -> src, []
    
        let bin_op_code x y op =
            let div_code src dest = [xchg eax dest;
                                     X86Cdq       ;
                                     X86Div src   ;
                                     xchg eax dest]
            in
            let del_nop = List.filter (fun i -> i <> movl eax eax && i <> xchg eax eax)
            in
            (match op with
                | "+"                -> let src, pref = safe_prefix y x in pref @ [addl src x]
                | "-"                -> let src, pref = safe_prefix y x in pref @ [subl src x]
                | "*"                ->
                     (match x with
                        | S _ -> [movl  x      (RR 0);
                                  imull y      (RR 0);
                                  movl  (RR 0)  x    ]
                        | _   -> [imull y x])
                | "/"                -> div_code y x
                | "%"                -> div_code y x @ [movl edx x]
                | c when is_cmp_op c ->
                    let op = cmp_op_by_sign c in
                    del_nop [movl x  (RR 0);
                             movl eax x    ;
                             xorl eax eax  ;
                             cmp  y  (RR 0);
                             set  op "al"  ;
                             xchg eax x    ]    
                | "!!"               ->
                     del_nop [movl x    (RR 0);
                              movl eax   x    ;
                              orl  y    (RR 0);
                              xorl eax   eax  ;
                              cmp (C 0) (RR 0);
                              set  "ne" "al"  ;
                              xchg eax   x    ]
                | "&&"               ->
                     del_nop [movl x    (RR 0);
                              movl eax   x    ;
                              xorl eax   eax  ;
                              cmp (C 0)  y    ;
                              set  "ne"  "al" ;
                              movl eax   y    ;
                              xorl eax   eax  ;
                              cmp (C 0) (RR 0);
                              set  "ne"  "al" ;
                              andl y     eax  ;
                              xchg eax   x    ]
                | _                  -> failwith @@ "Fail: unsupported binary opration '" ^ op ^ "'"
            )


        let stack_program env code =
            let rec compile stack code =
                match code with
                | []       -> []
                | i::code' ->
                    let (stack', x86code) =
                        match i with
                        | S_READ        -> ([eax], [X86Call "_read"])
                        | S_WRITE       -> ([], [X86Push (R 0);
                                                 X86Call "_write";
                                                 X86Pop (R 0)])
                        | S_PUSH n      ->
                            let s = allocate env stack in
                            (s::stack, [movl (C n) s])
                        | S_LD x        ->
                            env#local x;
                            let s = allocate env stack in
                            let src, pref = safe_prefix (M x) s in 
                            (s::stack, pref @ [movl src s])
                        | S_ST x        ->
                            env#local x;
                            let s, stack' = Util.pop_one stack in (***)
                            let src, pref = safe_prefix s (M x) in
                            (stack', pref @ [movl src (M x)])
                        | S_BINOP op    ->
                            let y, x, stack' = Util.pop_two stack in
                            (x::stack', bin_op_code x y op)
                        | S_JMP   p     -> (stack, [X86Jmp   p])
                        | S_JMPZ  p     ->
                            let x, stack' = Util.pop_one stack in
                            (stack', [cmp (C 0) x; X86Jmpz p])
                        | S_LABEL p     -> (stack, [X86Label p])
                        | _             -> failwith "Unsupported op"
                    in
                    x86code @ compile stack' code'
            in
            compile [] code

end

let compile prog =
    let env = new x86env in
    let code = Compile.stack_program env @@ StackMachine.Compile.prog prog in
    let asm  = Buffer.create 1024 in
    let (!!) s = Buffer.add_string asm s in
    let (!)  s = !!s; !!"\n" in
    !"\t.text";
    List.iter (fun x ->
            !(Printf.sprintf "\t.comm\t%s,\t%d,\t%d" x word_size word_size))
        env#local_vars;
    !"\t.globl\t_main";
    let prologue, epilogue =
        if env#allocated = 0
        then (fun () -> ()), (fun () -> ())
        else
            (fun () ->
                !"\tpushl\t%ebp";
                !"\tmovl\t%esp,\t%ebp";
                !(Printf.sprintf "\tsubl\t$%d,\t%%esp" (env#allocated * word_size))
            ),
            (fun () ->
                !"\tmovl\t%ebp,\t%esp";
                !"\tpopl\t%ebp"
            )
    in
    !"_main:";
    prologue();
    List.iter (fun i -> !(Show.instr i)) code;
    epilogue();
    !"\txorl\t%eax,\t%eax";
    !"\tret";
    Buffer.contents asm

let build stmt name =
    let outf = open_out (Printf.sprintf "%s.s" name) in
    Printf.fprintf outf "%s" (compile stmt);
    close_out outf;
    match Sys.command (Printf.sprintf "gcc -m32 -o %s $RC_RUNTIME/runtime.o %s.s" name name) with
    | 0 -> ()
    | _ -> failwith "gcc failed with non-zero exit code"
