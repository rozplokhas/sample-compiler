type opnd =
| R  of int     (* register                                                 *)
| RR of int     (* reserved register                                        *)
| S  of int     (* stack                                                    *)
| M  of string  (* global variable                                          *)
| C  of int     (* constant                                                 *)
| A  of int     (* argment                                                  *)
| L  of int     (* local variable                                           *)
| AS of int     (* slot for argument                                        *)

let x86regs = [|
    "%eax"; 
    "%ebx"; 
    "%ecx";
    "%esi"; 
    "%edi"
|]

let x86_reserved_regs = [|
    "%edx";
    "%esp";
    "%ebp"
|]

let num_of_regs = Array.length x86regs
let word_size = 4

let eax = R  0
let ebx = R  1
let ecx = R  2
let edx = RR 0
let esi = R  3
let edi = R  4
let esp = RR 1
let ebp = RR 2

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
| Lazy     of (unit -> instr list)

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



class mem_allocator =
    object(self)
        val    allocated   = ref 0
        method allocate n  = allocated := max n !allocated
        method allocated   = !allocated
    end

let allocate allocator stack =
    match stack with
    | []                              -> R 0
    | (S n)::_                        -> allocator#allocate (n + 2); S (n + 1)
    | (R n)::_ when n < num_of_regs-1 -> R (n + 1)
    | _                               -> allocator#allocate 1; S 0



module Show = struct

    let opnd = function
    | R  i -> x86regs.(i)
    | RR i -> x86_reserved_regs.(i)
    | S  i -> Printf.sprintf "%d(%%esp)" ((i + 1) * word_size)
    | M  x -> x
    | C  i -> Printf.sprintf "$%d" i
    | A  i -> Printf.sprintf "%d(%%ebp)" ((i + 3) * word_size)
    | L  i -> Printf.sprintf "-%d(%%ebp)" (i      * word_size)
    | AS i -> Printf.sprintf "-%d(%%esp)" (i      * word_size)


    let rec instr = function
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
    | Lazy      _           -> failwith "Unable to print lazy instruction"
        
end



module X86Env : sig 

    type t

    val global        : t

    val local         : string list -> string list -> string -> t

    val allocator     : t -> mem_allocator

    val end_label     : t -> string 

    val opnd_by_ident : t -> string -> opnd

    val prologue      : t -> unit -> instr list

    val epilogue      : t -> unit -> instr list

end = struct
    
    type t = bool * mem_allocator * (string * int) list * (string * int) list * string

    let global = (true, new mem_allocator, [], [], "")

    let local args local_vars end_label = (false, new mem_allocator, Util.number_elements_snd args, 
                                                                     Util.number_elements_snd local_vars,
                                                                     end_label                          )

    let allocator (_, al, _, _, _ ) = al

    let end_label (_,  _, _, _, el) = el

    let opnd_by_ident (is_global, _, args, local_vars, _) x =
        if is_global
            then M x
            else 
                try
                    try
                        A (List.assoc x args)
                    with
                    Not_found -> L (List.assoc x local_vars)
                with
                Not_found -> failwith @@ "Unknown variable " ^ x

    let prologue (_, allocator, _, local_vars, _) () =
        let frame_size = (allocator#allocated + List.length local_vars) * word_size
        in if frame_size = 0
            then []
            else [X86Push ebp               ;
                  movl    esp            ebp;
                  subl    (C frame_size) ebp]

    let epilogue (is_global, allocator, _, local_vars, _) () =
        let frame_size = (allocator#allocated + List.length local_vars) * word_size
        in 
        (if frame_size = 0 then []             else [movl ebp esp; X86Pop ebp]) @
        (if is_global      then [xorl eax eax] else []                        ) @
        [X86Ret]

end



module Compile : sig

    val stack_program : StackMachine.instr list -> instr list

end = struct

    open StackMachine

    let safe_prefix src dest =
        let memory = function
        | S _ | M _ | A _ | L _ | AS _ -> true
        | _                            -> false
        in if memory src && memory dest
            then RR 0, [movl src (RR 0)]  
            else src, []

    let bin_op_code x y op =
        let div_code src dest = [xchg   eax dest;
                                 X86Cdq       ;
                                 X86Div src   ;
                                 xchg   eax dest]
        in
        let del_nop = List.filter (fun i -> i <> movl eax eax && i <> xchg eax eax)
        in
        (
            match op with
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
            | _                  -> failwith @@ "Unsupported binary opration '" ^ op ^ "'"
        )


    let stack_program code =
        let rec compile env stack code =
            match code with
            | []       -> (X86Env.epilogue env ())
            | i::code' ->
                let continue stack' x86code = x86code @ compile env stack' code'
                in match i with
                | S_READ             -> continue [eax] [X86Call "read"]
                | S_WRITE            -> continue [] [X86Push (R 0)  ;
                                                  X86Call "write";
                                                  X86Pop (R 0)   ]
                | S_PUSH       n     ->
                    let s = allocate (X86Env.allocator env) stack in
                    continue (s::stack) [movl (C n) s]
                | S_LD         id    ->
                    let x = X86Env.opnd_by_ident env id in
                    let s = allocate (X86Env.allocator env) stack in
                    let src, pref = safe_prefix x s in 
                    continue (s::stack) (pref @ [movl src s])
                | S_ST         id    ->
                    let x = X86Env.opnd_by_ident env id in
                    let s, stack' = Util.pop_one stack in
                    let src, pref = safe_prefix s x in
                    continue stack' (pref @ [movl src x])
                | S_BINOP      op    ->
                    let y, x, stack' = Util.pop_two stack in
                    continue (x::stack') (bin_op_code x y op)
                | S_JMP        p     -> continue stack [X86Jmp p]
                | S_JMPZ       p     ->
                    let x, stack' = Util.pop_one stack in
                    continue stack' [cmp (C 0) x; X86Jmpz p]
                | S_LABEL      p     -> continue stack [X86Label p]
                | S_CALL      (p, n) ->
                    let rev_args, stack' = Util.split_stack n stack in
                    let rec filled_regs = match stack' with
                                          | (S _) :: tl -> List.map (fun (i, _) -> R i) @@ Util.number_elements_fst @@ Array.to_list x86regs
                                          | _           -> stack'
                    in
                    let saves = List.concat @@
                                    List.map (fun (opnd, i) ->
                                                let src, pref = safe_prefix opnd (AS i)
                                                in pref @ [movl src (AS i)] 
                                             ) @@ 
                                             Util.number_elements_snd (filled_regs @ rev_args)
                    in
                    let s = allocate (X86Env.allocator env) stack' in
                    continue (s::stack') (
                                            saves          @
                                           [X86Call p    ;
                                            movl    eax s] @
                                           (List.map (fun r -> X86Pop r) (List.rev filled_regs))
                                         )
                | S_RET              -> 
                    let end_label = X86Env.end_label env
                    in if end_label = ""
                        then failwith "Return from global code"
                        else continue stack [X86Jmp end_label]
                | S_DROP             ->
                    let _, stack' = Util.pop_one stack
                    in continue stack' []
                | S_FUN_START (args, local_vars, end_label) ->
                    let env = X86Env.local args local_vars end_label in
                    [Lazy (X86Env.prologue env)] @ compile env [] code'
                | S_FUN_END          -> continue stack (X86Env.epilogue env ())
                | S_MAIN_START _     ->
                    let env = X86Env.global in
                    [X86Label "main"; Lazy (X86Env.prologue env)] @ compile env [] code'
        in
        compile X86Env.global [] code

end



let rec forse = function
| []           -> []
| Lazy f :: is -> f () @ forse is
| i      :: is -> i   :: forse is



let compile prog =
    let sm_code = StackMachine.Compile.prog prog in
    let inner_vars =
        List.fold_left (fun res i -> 
                            match i with
                            | StackMachine.S_MAIN_START ivs -> ivs
                            | _ -> res
                        ) 
                        [] 
                        sm_code
    in
    let code = Compile.stack_program sm_code in
    let code = forse code                    in
    let asm  = Buffer.create 1024            in
    let (!!) s = Buffer.add_string asm s     in
    let (!)  s = !!s; !!"\n"                 in
    !"\t.text";
    List.iter (fun x ->
                !(Printf.sprintf "\t.comm\t%s,\t%d,\t%d" x word_size word_size)
              )
              inner_vars;
    !"\t.globl\tmain";
    List.iter (fun i -> !(Show.instr i)) code;
    Buffer.contents asm



let build prog name =
    let outf = open_out (Printf.sprintf "%s.s" name) in
    Printf.fprintf outf "%s" (compile prog);
    close_out outf;
    match Sys.command (Printf.sprintf "gcc -m32 -o %s $RC_RUNTIME/runtime.o %s.s" name name) with
    | 0 -> ()
    | _ -> failwith "gcc failed with non-zero exit code"
