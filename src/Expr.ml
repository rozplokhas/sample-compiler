type expr =
  | Const    of int
  | Var      of string
  | BinOp    of string * expr * expr
  | EFunCall of string * expr list

module State : sig
  type t
  type fun_res = 
    | Running of t
    | None
    | Num of int
  val empty       : t
  val add_var     : string -> int                   -> t -> t
  val add_fun     : string -> (int list -> fun_res) -> t -> t
  val find_var    : string -> t -> int
  val find_fun    : string -> t -> (int list -> fun_res)
end = struct
  module StringMap = Map.Make (String)
                            
  type t =
    int StringMap.t * (int list -> fun_res) StringMap.t
  and
  fun_res =
    | Running of t
    | None
    | Num of int
               
  let empty                 = (StringMap.empty, StringMap.empty)
  let add_var  x v (vm, fm) = (StringMap.add x v vm, fm)
  let add_fun  x f (vm, fm) = (vm, StringMap.add x f fm)
  let find_var x   (vm, _ ) = StringMap.find x vm
  let find_fun x   (_ , fm) = StringMap.find x fm
end
       
let rec eval state expr =
  let eval' = eval state in
  match expr with
  | Const n                -> n
  | Var x                  -> State.find_var x state
  | EFunCall (fname, args) ->
     let State.Num r = State.find_fun fname state @@ List.map eval' args
     in r
  | BinOp ("+",  x, y)     -> eval' x +    eval' y
  | BinOp ("-",  x, y)     -> eval' x -    eval' y
  | BinOp ("*",  x, y)     -> eval' x *    eval' y   
  | BinOp ("/",  x, y)     -> eval' x /    eval' y
  | BinOp ("%",  x, y)     -> eval' x mod  eval' y
  | BinOp ("&&", x, y)     -> eval' x land eval' y
  | BinOp ("||", x, y)     -> eval' x lor  eval' y
  | BinOp ("==", x, y)     -> if eval' x =  eval' y then 1 else 0
  | BinOp ("!=", x, y)     -> if eval' x != eval' y then 1 else 0
  | BinOp ("<=", x, y)     -> if eval' x <= eval' y then 1 else 0
  | BinOp ("<",  x, y)     -> if eval' x <  eval' y then 1 else 0
  | BinOp (">=", x, y)     -> if eval' x >= eval' y then 1 else 0
  | BinOp (">",  x, y)     -> if eval' x >  eval' y then 1 else 0
                              
type stmt =
  | Skip
  | Read     of string
  | Write    of expr
  | Assign   of string * expr
  | Seq      of stmt   * stmt
  | If       of expr   * stmt
  | While    of expr   * stmt
  | FunDef   of string * string list * stmt
  | SFunCall of string * expr   list
  | Ret      of expr
  | RetNone

let run : stmt -> unit = fun stmt ->
  let rec run' : State.t -> stmt -> State.fun_res = fun state -> function
  | Skip                       -> State.Running state
  | Read x                     ->
     let n = print_string "> "; int_of_string (read_line ())
     in State.Running (State.add_var x n state)
  | Write   e                  -> print_endline @@ string_of_int @@ eval state e;
                                  State.Running state
  | Assign (x , e )            -> State.Running (State.add_var x (eval state e) state)
  | Seq    (s1, s2)            ->
     begin match run' state s1 with
     | State.Running s -> run' s s2
     | res             -> res
     end
  | If    (e, s)               -> if eval state e != 0
                                  then run' state s
                                  else State.Running state
  | While (e, s)               ->
     let is_running = function
     | State.Running _ -> true
     | _               -> false
     in
     let get_st (State.Running s) = s in
     let res = ref (State.Running state) in
     while is_running !res && eval (get_st !res) e != 0 do
       res := run' (get_st !res) s  
     done; !res
  | FunDef  (name, args, body) ->
     let rec zip xs ys = match xs, ys with
       | [], []       -> []
       | x::xs, y::ys -> (x, y)::(zip xs ys)
     in
     let func : int list -> State.fun_res = fun vals ->
       let st_of_args = List.fold_right (fun (x, v) s -> State.add_var x v s) (zip args vals) State.empty
       in run' st_of_args body
     in
     Running (State.add_fun name func state)
  | SFunCall (fname, args)      -> State.find_fun fname state @@
                                    List.map (eval state) args; State.Running state
  | Ret      e                 -> State.Num (eval state e)
  | RetNone                    -> State.None
  in
  let State.Running _ = run' State.empty stmt in ()
    
type instr =
  | S_READ
  | S_WRITE
  | S_PUSH   of int
  | S_LD     of string
  | S_ST     of string
  | S_BIN_OP of string
  | S_IF     of instr list
  | S_WHILE  of instr list * instr list

let rec compile_expr expr =
  match expr with
  | Var    x         -> [S_LD   x]
  | Const  n         -> [S_PUSH n]
  | BinOp (op, l, r) -> compile_expr l @ compile_expr r @ [S_BIN_OP op]

let rec compile_stmt stmt =
  match stmt with
  | Skip          -> []
  | Assign (x, e) -> compile_expr e @ [S_ST x]
  | Read    x     -> [S_READ; S_ST x]
  | Write   e     -> compile_expr e @ [S_WRITE]
  | Seq    (l, r) -> compile_stmt l @ compile_stmt r
  | If     (t, s) -> compile_expr t @ [S_IF (compile_stmt s)]
  | While  (t, s) -> [S_WHILE (compile_expr t, compile_stmt s)]

let x86regs = [|"%eax"; "%ebx"; "%ecx"; "%esi"; "%edi"|]
let x86regs_reserved = [|"%edx"|]
let num_of_regs = Array.length x86regs
let word_size = 4

type opnd = R of int | RR of int | S of int | M of string | L of int

let allocate env stack =
  match stack with
  | []                              -> R 0
  | (S n)::_                        -> env#allocate (n+1); S (n+1)
  | (R n)::_ when n < num_of_regs-1 -> R (n+1)
  | _                               -> S 0

type x86instr =
  | X86Add   of opnd * opnd
  | X86Sub   of opnd * opnd
  | X86Mul   of opnd * opnd
  | X86And   of opnd * opnd
  | X86Or    of opnd * opnd
  | X86Mov   of opnd * opnd
  | X86Cmp   of opnd * opnd
  | X86Xchg  of opnd * opnd
  | X86Div   of opnd
  | X86Push  of opnd
  | X86Pop   of opnd
  | X86Call  of string
  | X86Jmp   of string
  | X86Je    of string
  | X86Jne   of string
  | X86Jl    of string
  | X86Jle   of string
  | X86Jg    of string
  | X86Jge   of string
  | X86Label of string
  | X86Cdq
  | X86Ret

module S = Set.Make (String)

class x86env =
  object(self)
    val    local_vars = ref S.empty
    method local x    = local_vars := S.add x !local_vars
    method local_vars = S.elements !local_vars

    val    allocated  = ref 0
    method allocate n = allocated := max n !allocated
    method allocated  = !allocated

    val    counter     = ref 0
    method get_counter = let v = !counter in counter := v + 1; v
  end

let slot : opnd -> string = function
  | (R  i) -> x86regs.(i)
  | (RR i) -> x86regs_reserved.(i)
  | (S  i) -> Printf.sprintf "-%d(%%ebp)" (i * word_size)
  | (M  x) -> x
  | (L  i) -> Printf.sprintf "$%d" i
let x86print : x86instr -> string = function
  | X86Add  (s1, s2) -> Printf.sprintf "\taddl\t%s,\t%s"  (slot s1) (slot s2)
  | X86Sub  (s1, s2) -> Printf.sprintf "\tsubl\t%s,\t%s"  (slot s1) (slot s2)
  | X86Mul  (s1, s2) -> Printf.sprintf "\timull\t%s,\t%s" (slot s1) (slot s2)
  | X86And  (s1, s2) -> Printf.sprintf "\tand\t%s,\t%s"   (slot s1) (slot s2)
  | X86Or   (s1, s2) -> Printf.sprintf "\tor\t%s,\t%s"    (slot s1) (slot s2)
  | X86Mov  (s1, s2) -> Printf.sprintf "\tmovl\t%s,\t%s"  (slot s1) (slot s2)
  | X86Cmp  (s1, s2) -> Printf.sprintf "\tcmp\t%s,\t%s"   (slot s1) (slot s2)
  | X86Xchg (s1, s2) -> Printf.sprintf "\txchg\t%s,\t%s"  (slot s1) (slot s2)
  | X86Div   s       -> Printf.sprintf "\tidivl\t%s"      (slot s )
  | X86Push  s       -> Printf.sprintf "\tpushl\t%s"      (slot s )
  | X86Pop   s       -> Printf.sprintf "\tpopl\t%s"       (slot s )
  | X86Call  p       -> Printf.sprintf "\tcall\t%s"        p
  | X86Jmp   p       -> Printf.sprintf "\tjmp\t%s"         p
  | X86Je    p       -> Printf.sprintf "\tje\t%s"          p
  | X86Jne   p       -> Printf.sprintf "\tjne\t%s"         p
  | X86Jl    p       -> Printf.sprintf "\tjl\t%s"          p
  | X86Jle   p       -> Printf.sprintf "\tjle\t%s"         p
  | X86Jg    p       -> Printf.sprintf "\tjg\t%s"          p
  | X86Jge   p       -> Printf.sprintf "\tjge\t%s"         p
  | X86Label p       -> Printf.sprintf "%s:"               p
  | X86Cdq           -> "\tcdq"
  | X86Ret           -> "\tret"

let x86compile : x86env -> instr list -> x86instr list = fun env code ->
  let rec x86compile' stack code =
    match code with
    | []       -> []
    | i::code' ->
       let (stack', x86code) =
         let safe_op cons x y =
           match x, y with
           | (S _, S _) | (S _, M _) | (M _, S _) -> [X86Mov (x, RR 0); cons (RR 0) y]
           | _                                    -> [cons x y]
         in
         let simple_op stack cons =
           let x::y::stack' = stack in
           (y::stack', safe_op cons x y)
         in
         let cmpr stack cons =
           let x::y::stack' = stack in
           let s = string_of_int env#get_counter in
           let tr  = "true" ^ s in
           let fin = "fin"  ^ s in
           (y::stack', (safe_op (fun x y -> X86Cmp (x, y)) x y) @
                         [cons tr; X86Mov (L 0, y); X86Jmp fin;
                          X86Label tr; X86Mov (L 1, y); X86Label fin])
         in
         match i with
         | S_READ               -> ([R 0], [X86Call "read"])
         | S_WRITE              -> ([], [X86Push (R 0); X86Call "write"; X86Pop (R 0)])
         | S_PUSH n             ->
           let s = allocate env stack in
           (s::stack, [X86Mov (L n, s)])
         | S_LD x               ->
           env#local x;
           let s = allocate env stack in
           (s::stack, safe_op (fun x y -> X86Mov (x, y)) (M x) s)
         | S_ST x               ->
           env#local x;
           let s::stack' = stack in
           (stack', safe_op (fun x y -> X86Mov (x, y)) s (M x))
         | S_BIN_OP "+"         -> simple_op stack (fun x y -> X86Add (x, y))
         | S_BIN_OP "-"         -> simple_op stack (fun x y -> X86Sub (x, y))
         | S_BIN_OP "&&"        -> simple_op stack (fun x y -> X86And (x, y))
         | S_BIN_OP "||"        -> simple_op stack (fun x y -> X86Or  (x, y))
         | S_BIN_OP "=="        -> cmpr      stack (fun x   -> X86Je   x    )
         | S_BIN_OP "!="        -> cmpr      stack (fun x   -> X86Jne  x    )
         | S_BIN_OP "<"         -> cmpr      stack (fun x   -> X86Jl   x    )
         | S_BIN_OP "<="        -> cmpr      stack (fun x   -> X86Jle  x    )
         | S_BIN_OP ">"         -> cmpr      stack (fun x   -> X86Jg   x    )
         | S_BIN_OP ">="        -> cmpr      stack (fun x   -> X86Jge  x    )
         | S_BIN_OP "*"         ->
            let x::y::stack' = stack in
            begin match x, y with
              | (S _, S _) -> (y::stack', [X86Mov (x, RR 0); X86Mul (y, RR 0); X86Mov (RR 0, y)])
              | _          -> (y::stack', [X86Mul (x, y)])
            end
         | S_BIN_OP "/"         ->
           let x::y::stack' = stack in
           (y::stack', [X86Xchg (y, R 0); X86Cdq; X86Div x; X86Xchg (y, R 0)])
         | S_BIN_OP "%"         ->
           let x::y::stack' = stack in
           (y::stack', [X86Xchg (y, R 0); X86Cdq; X86Div x; X86Xchg (y, R 0); X86Mov (RR 0, y)])
         | S_IF is              ->
            let fin = "fin" ^ string_of_int env#get_counter in
            ([], [X86Cmp (L 0, R 0); X86Je fin] @ x86compile' [] is @ [X86Label fin])
         | S_WHILE (t_is, s_is) ->
            let s = string_of_int env#get_counter in
            let st  = "start" ^ s in
            let fin = "fin"   ^ s in
            ([], [X86Label st]                   @
                  x86compile' [] t_is            @
                  [X86Cmp (L 0, R 0); X86Je fin] @
                  x86compile' [] s_is            @
                  [X86Jmp st; X86Label fin])      
       in
       x86code @ x86compile' stack' code'
  in
  x86compile' [] code

let genasm stmt =
  let env = new x86env in
  let code = x86compile env @@ compile_stmt stmt in
  let asm = Buffer.create 1024 in
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
  List.iter (fun i -> !(x86print i)) code;
  epilogue();
  !"\txorl\t%eax,\t%eax";
  !"\tret";

  Buffer.contents asm

let interpret : stmt -> unit = run
      
let build stmt name =
  let outf = open_out (Printf.sprintf "%s.s" name) in
  Printf.fprintf outf "%s" (genasm stmt);
  close_out outf;
  Sys.command (Printf.sprintf "gcc -m32 -o %s ../runtime/runtime.o %s.s" name name)

