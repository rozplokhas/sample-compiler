type i =
| S_READ
| S_WRITE
| S_PUSH  of int
| S_LD    of string
| S_ST    of string
| S_BINOP of string
| S_JMP   of string
| S_JMPC  of string * string
| S_LABEL of string

module Interpreter =
  struct

    let run input full_code =
      let rec run' ((state, stack, input, output) as conf) code =
	match code with
	| []       -> output
	| i::code' ->
	   let transmit conf' = run' conf' code' in
           let rec jump label = function
             | (S_LABEL l)::tl when l = label -> tl 
             | i::tl                          -> jump label tl
           in
           match i with
              | S_READ    ->
		  let y::input' = input in
		  transmit (state, y::stack, input', output)
              | S_WRITE   ->
		  let y::stack' = stack in
		  transmit (state, stack', input, output @ [y])
              | S_PUSH n  ->
		  transmit (state, n::stack, input, output)
              | S_LD x    ->
		  transmit (state, (List.assoc x state)::stack, input, output)
              | S_ST x    ->
		  let y::stack' = stack in
		  transmit ((x, y)::state, stack', input, output)
              | S_BINOP s ->
                  let y::x::stack' = stack in
                  let r = Interpreter.BinOpEval.fun_of_string s x y in
                  transmit (state, r::stack', input, output)
              | S_JMP l   -> run' conf (jump l full_code)
              | S_JMPC (c, l) when c = "z" || c = "nz" ->
                 let x::stack' = stack in
                 let conf' = (state, stack', input, output) in
                 if c = "z" && x = 0 || c = "nz" && x <> 0
                 then run' conf' (jump l full_code)
                 else transmit conf'
              | S_LABEL _ -> transmit conf
      in
      run' ([], [], input, []) full_code
	
  end

let label_counter = ref 0
let get_and_inc r = let i = !r in r := i + 1; i

module Compile =
  struct

    open Language.Expr
    open Language.Stmt

    let rec expr = function
    | Var    x        -> [S_LD   x]
    | Const  n        -> [S_PUSH n]
    | Binop (s, x, y) -> expr x @ expr y @ [S_BINOP s]

    let rec stmt = function
    | Skip               -> []
    | Assign (x, e)      -> expr e @ [S_ST x]
    | Read    x          -> [S_READ; S_ST x]
    | Write   e          -> expr e @ [S_WRITE]
    | Seq    (l, r)      -> stmt l @ stmt r
    | If     (e, st, sf) ->
       let no = string_of_int (get_and_inc label_counter)
       in expr e                    @
         [S_JMPC  ("nz", "then"^no);
          S_JMP   ("else"^no);
          S_LABEL ("then"^no)]      @
          stmt st                   @
         [S_JMP   ("fin"^no);
          S_LABEL ("else"^no)]      @
          stmt sf                   @
         [S_LABEL ("fin"^no)]
    | While (e, s)       ->
       let no = string_of_int (get_and_inc label_counter)
       in [S_LABEL ("start"^no)]    @
           expr e                   @
          [S_JMPC  ("z", "fin"^no)] @
           stmt s                   @
          [S_JMP   ("start"^no);
           S_LABEL ("fin"^no)]
                
             

  end
