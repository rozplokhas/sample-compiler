type opnd = R of int | RR of int | S of int | M of string | L of int

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
| X86Add   of opnd * opnd
| X86Sub   of opnd * opnd
| X86Mul   of opnd * opnd
| X86Mov   of opnd * opnd
| X86Xchg  of opnd * opnd
| X86Xor   of opnd * opnd
| X86Cmp   of opnd * opnd
| X86Or    of opnd * opnd
| X86And   of opnd * opnd
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

let cmps = [
    "<=", "le";
    "<" , "l" ;
    "==", "e" ;
    "!=", "ne";
    ">" , "g" ;
    ">=", "ge"
]

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
  | (S n)::_                        -> env#allocate (n+2); S (n+1)
  | (R n)::_ when n < num_of_regs-1 -> R (n+1)
  | _                               -> env#allocate 1; S 0

module Show =
  struct

    let opnd = function
    | R  i -> x86regs.(i)
    | RR i -> x86_reserved_regs.(i)
    | S  i -> Printf.sprintf "-%d(%%ebp)" (i * word_size)
    | M  x -> x
    | L  i -> Printf.sprintf "$%d" i

    let instr = function
    | X86Add   (s1, s2)   -> Printf.sprintf "\taddl\t%s,\t%s"  (opnd s1) (opnd s2)
    | X86Sub   (s1, s2)   -> Printf.sprintf "\tsubl\t%s,\t%s"  (opnd s1) (opnd s2)
    | X86Mul   (s1, s2)   -> Printf.sprintf "\timull\t%s,\t%s" (opnd s1) (opnd s2)
    | X86Mov   (s1, s2)   -> Printf.sprintf "\tmovl\t%s,\t%s"  (opnd s1) (opnd s2)
    | X86Xchg  (s1, s2)   -> Printf.sprintf "\txchg\t%s,\t%s"  (opnd s1) (opnd s2)
    | X86Xor   (s1, s2)   -> Printf.sprintf "\txorl\t%s,\t%s"  (opnd s1) (opnd s2)
    | X86Cmp   (s1, s2)   -> Printf.sprintf "\tcmp\t%s,\t%s"   (opnd s1) (opnd s2)
    | X86Or    (s1, s2)   -> Printf.sprintf "\torl\t%s,\t%s"   (opnd s1) (opnd s2)
    | X86And   (s1, s2)   -> Printf.sprintf "\tandl\t%s,\t%s"  (opnd s1) (opnd s2)
    | X86Push   s         -> Printf.sprintf "\tpushl\t%s"      (opnd s )
    | X86Pop    s         -> Printf.sprintf "\tpopl\t%s"       (opnd s )
    | X86Div    s         -> Printf.sprintf "\tidiv\t%s"       (opnd s )
    | X86Ret              -> "\tret"
    | X86Cdq              -> "\tcdq"
    | X86Call   p         -> Printf.sprintf "\tcall\t%s" p
    | X86Jmp    p         -> Printf.sprintf "\tjmp\t%s"  p
    | X86Jmpz   p         -> Printf.sprintf "\tjz\t%s"   p
    | X86Label  p         -> Printf.sprintf "%s:"        p
    | X86Set   (cmp, reg) -> Printf.sprintf "\tset%s\t%%%s" cmp reg
    
  end

module Compile =
  struct

    open StackMachine

    let stack_program env code =
      let rec compile stack code =
        match code with
	| []       -> []
	| i::code' ->
	    let (stack', x86code) =
              let safe_prefix (src, dest) =
                match src, dest with
                | S _, S _ | S _, M _ | M _, S _ -> RR 0, [X86Mov (src, RR 0)]  
                | _                              -> src, []
              in
              let div_code (src, dest) = [X86Xchg (eax, dest);
                                          X86Cdq; X86Div src;
                                          X86Xchg (eax, dest)] in
              match i with
              | S_READ        -> ([eax], [X86Call "read"])
              | S_WRITE       -> ([], [X86Push (R 0);
                                       X86Call "write";
                                       X86Pop (R 0)])
              | S_PUSH n      ->
		  let s = allocate env stack in
		  (s::stack, [X86Mov (L n, s)])
              | S_LD x        ->
		  env#local x;
		  let s = allocate env stack in
                  let src, pref = safe_prefix (M x, s) in 
		  (s::stack, pref @ [X86Mov (src, s)])
              | S_ST x        ->
	          env#local x;
		  let s::stack' = stack in
                  let src, pref = safe_prefix (s, M x) in
		  (stack', pref @ [X86Mov (src, M x)])
	      | S_BINOP "+"   ->
                  let y::x::stack' = stack in
                  let src, pref = safe_prefix (y, x) in
                  (x::stack', pref @ [X86Add (src, x)])
              | S_BINOP "-"   ->
                  let y::x::stack' = stack in
                  let src, pref = safe_prefix (y, x) in
                  (x::stack', pref @ [X86Sub (src, x)])
              | S_BINOP "*"   ->
                  let y::x::stack' = stack in
                  (match x with
                   | S _ -> x::stack', [X86Mov (x, RR 0);
                                        X86Mul (y, RR 0);
                                        X86Mov (RR 0, x)]
                   | _   -> x::stack', [X86Mul (y, x)])
              | S_BINOP "/"   ->
                  let y::x::stack' = stack in
                  (x::stack', div_code (y, x))
              | S_BINOP "%"   ->
                  let y::x::stack' = stack in
                  (x::stack', div_code (y, x) @ [X86Mov (edx, x)])
              | S_BINOP c when List.mem c (fst @@ List.split cmps) ->
                  let y::x::stack' = stack in
                  let op = List.assoc c cmps in
                  (x::stack', [X86Mov  (x,   RR 0);
                               X86Mov  (eax, x   );
                               X86Xor  (eax, eax );
                               X86Cmp  (y,   RR 0);
                               X86Set  (op,  "al");
                               X86Xchg (eax, x   )])
              | S_BINOP "!!"  ->
                  let y::x::stack' = stack in
                  (x::stack', [X86Mov  (x,    RR 0);
                               X86Mov  (eax,  x   );
                               X86Or   (y,    RR 0);
                               X86Xor  (eax,  eax );
                               X86Cmp  (L 0,  RR 0);
                               X86Set  ("ne", "al");
                               X86Xchg (eax,  x   )])
              | S_BINOP "&&"  ->
                  let y::x::stack' = stack in
                  (x::stack', [X86Mov  (x,    RR 0);
                               X86Mov  (eax,  x   );
                               X86Xor  (eax,  eax );
                               X86Cmp  (L 0,  y   );
                               X86Set  ("ne", "al");
                               X86Mov  (eax,  y   );
                               X86Xor  (eax,  eax );
                               X86Cmp  (L 0,  RR 0);
                               X86Set  ("ne", "al");
                               X86And  (y,    eax );
                               X86Xchg (eax,  x   )])
              | S_JMP   p     -> (stack, [X86Jmp   p])
              | S_JMPZ  p     ->
                 let x::stack' = stack in
                 (stack', [X86Cmp (L 0, x); X86Jmpz p])
              | S_LABEL p     -> (stack, [X86Label p])
	    in
	    x86code @ compile stack' code'
      in
      let del_nop = List.filter (fun i -> i <> X86Mov (eax, eax) && i <> X86Xchg (eax, eax))
      in
      del_nop @@ compile [] code

  end

let compile stmt =
  let env = new x86env in
  let code = Compile.stack_program env @@ StackMachine.Compile.stmt stmt in
  let asm  = Buffer.create 1024 in
  let (!!) s = Buffer.add_string asm s in
  let (!)  s = !!s; !!"\n" in
  !"\t.text";
  List.iter (fun x ->
      !(Printf.sprintf "\t.comm\t%s,\t%d,\t%d" x word_size word_size))
    env#local_vars;
  !"\t.globl\tmain";
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
  !"main:";
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
  ignore (Sys.command (Printf.sprintf "gcc -m32 -o %s $RC_RUNTIME/runtime.o %s.s" name name))
