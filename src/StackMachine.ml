type instr =
| S_READ
| S_WRITE
| S_PUSH       of int
| S_LD         of string
| S_ST         of string
| S_BINOP      of string
| S_JMP        of string
| S_JMPZ       of string
| S_LABEL      of string
| S_CALL       of string * int
| S_RET
| S_DROP
| S_FUN_START  of string list * string list * string  (* arguments and local variables names, function end label *)
| S_FUN_END
| S_MAIN_START of string list                         (* inner variables names                                   *)

module Interpreter : sig

    val run : int list -> instr list -> int list

end = struct

    let rec jump_to_label name = function
    | (_, S_LABEL l)::tl when l = name -> tl 
    | _::tl                            -> jump_to_label name tl
    | []                               -> failwith @@ "Unknown label '" ^ name ^ "'"

    let rec jump_to_main = function
    | (_, S_MAIN_START _)::tl -> tl
    | _::tl                  -> jump_to_main tl
    | []                     -> failwith @@ "Starting point not found"

    let rec jump_to_line_no n code =
        match n, code with
        | 0, _     -> code
        | n, _::tl -> jump_to_line_no (n - 1) tl
        | _, []    -> failwith @@ "Wrong line number " ^ string_of_int n

    let run input full_code =
        let full_code = Util.number_elements_fst full_code
        in
        let rec run_rest ((stack, env_stack) as conf) code =
            let curr_env, env_stack = Util.pop_one env_stack in
            match code with
            | []                  -> List.rev @@ Env.get_output curr_env
            | (line_no, i)::code' ->
                let transmit (stack', env') = run_rest (stack', env'::env_stack) code'
                in  
                match i with
                | S_READ                   ->
                    let y, env = Env.read_int curr_env in
                    transmit (y::stack, env)
                | S_WRITE                  ->
                    let y, stack' = Util.pop_one stack in
                    transmit (stack', Env.write_int y curr_env)
                | S_PUSH  n                ->
                    transmit (n::stack, curr_env)
                | S_LD    x                ->
                    transmit (Env.find_var x curr_env :: stack, curr_env)
                | S_ST    x                ->
                    let y, stack' = Util.pop_one stack in
                    transmit (stack', Env.add_var x y curr_env)
                | S_BINOP s                ->
                    let y, x, stack' = Util.pop_two stack in
                    let r = Util.BinOpEval.fun_of_string s x y in
                    transmit (r::stack', curr_env)
                | S_JMP   l                -> run_rest conf (jump_to_label l full_code)
                | S_JMPZ  l                ->
                    let x, stack' = Util.pop_one stack in
                    let conf' = (stack', curr_env::env_stack) in
                    if x = 0
                        then run_rest conf' (jump_to_label l full_code)
                        else transmit (stack', curr_env)
                | S_LABEL _                -> transmit (stack, curr_env)
                | S_CALL (f, _)            -> run_rest ((line_no+1)::stack, curr_env::env_stack) (jump_to_label f full_code)
                | S_RET                    ->
                    let res, ret_addr, stack' = Util.pop_two stack     in
                    let old_env, env_stack'   = Util.pop_one env_stack in
                    let updated_old_env = Env.update_io (Env.get_input curr_env) (Env.get_output curr_env) old_env in  
                    run_rest (res::stack', updated_old_env::env_stack') (jump_to_line_no ret_addr full_code)
                | S_DROP                   ->
                    let _, stack' = Util.pop_one stack in
                    transmit (stack', curr_env)
                | S_FUN_START (args, _, _) ->
                    let rec add_args args stack env =
                        match args, stack with
                        | [],          _             -> env, stack
                        | name::args', value::stack' -> add_args args' stack' (Env.add_var name value env)
                        | _                          -> failwith "Wrong number of arguments"
                    in
                    let addr, stack = Util.pop_one stack in
                    let fun_env, stack' = add_args (List.rev args) stack (Env.local curr_env) in
                    run_rest (addr::stack', fun_env::curr_env::env_stack) code'
                | S_MAIN_START _            -> failwith "More than one starting points"
                | S_FUN_END                -> failwith "Function must return a value"
        in
        run_rest ([], [Env.with_input input]) (jump_to_main full_code)
    
end

module Compile : sig

    val prog : Language.Prog.t -> instr list

end = struct

    module FuncMap = Map.Make (String)

    open Language.Expr
    open Language.Stmt

    let fun_name_prefix = "fun_"
    let fun_end_prefix  = "end_"

    let rec expr = function
    | Var                    x         -> [S_LD   x]
    | Const                  n         -> [S_PUSH n]
    | Binop                 (s, x, y)  -> expr x @ expr y @ [S_BINOP s]
    | Language.Expr.Funcall (f, arges) -> List.concat (List.map expr arges) @ [S_CALL (fun_name_prefix^f, List.length arges)]

    let label_counter = ref 0
    let get_and_inc r = let i = !r in r := i + 1; i

    let rec stmt = function
    | Skip                             -> []
    | Assign (x, e)                    -> expr e @ [S_ST x]
    | Read    x                        -> [S_READ; S_ST x]
    | Write   e                        -> expr e @ [S_WRITE]
    | Seq    (l, r)                    -> stmt l @ stmt r
    | If     (e, st, sf)               ->
        let no = string_of_int (get_and_inc label_counter)
        in expr e               @
          [S_JMPZ  ("else"^no)] @
           stmt st              @
          [S_JMP   ("fin"^no) ;
           S_LABEL ("else"^no)] @
           stmt sf              @
          [S_LABEL ("fin"^no) ]
    | While  (e, s)                    ->
        let no = string_of_int (get_and_inc label_counter)
        in [S_LABEL ("start"^no)] @
            expr e                @
           [S_JMPZ  ("fin"^no)  ] @
            stmt s                @
           [S_JMP   ("start"^no);
            S_LABEL ("fin"^no)  ]
    | Repeat (s, e)                     ->
        let no = string_of_int (get_and_inc label_counter)
        in [S_LABEL ("start"^no)] @
            stmt s                @
            expr e                @
           [S_JMPZ  ("start"^no)]
    | Language.Stmt.Funcall (f, arges) -> expr (Language.Expr.Funcall (f, arges)) @ [S_DROP]
    | Return   e                       -> expr e @ [S_RET]

    let prog (fdefs, main) =
        List.concat (List.map (fun ((name, argnames, body) as fdef) -> 
                                    [S_LABEL     (fun_name_prefix^name)   ; 
                                     S_FUN_START (argnames               , 
                                                  FunInfo.local_vars fdef, 
                                                  fun_end_prefix^name    )] @
                                     stmt body                              @
                                    [S_LABEL     (fun_end_prefix^name)    ;
                                     S_FUN_END                            ]
                              )
                              fdefs) @
        [S_MAIN_START (FunInfo.local_vars ("", [], main))] @
        stmt main
end
