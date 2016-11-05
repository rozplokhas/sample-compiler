type instr =
| S_READ
| S_WRITE
| S_PUSH  of int
| S_LD    of string
| S_ST    of string
| S_BINOP of string
| S_JMP   of string
| S_JMPZ  of string
| S_LABEL of string
| S_CALL  of string * string list
| S_RET
| S_END
| S_DROP

module Interpreter = struct

    let run input full_code =
        let rec number_lines start_n = function
        | []    -> []
        | i::is -> (start_n, i) :: number_lines (start_n + 1) is
        in
        let full_code = number_lines 0 full_code
        in
        let rec run' ((env, stack, env_stack) as conf) code =
            match code with
            | []                  -> List.rev @@ Env.get_output env
            | (line_no, i)::code' ->
                let transmit (env', stack') = run' (env', stack', env_stack) code' in
                let rec jump_to_name name = function
                    | (_, S_LABEL l)::tl when l = name -> tl 
                    | _::tl                            -> jump_to_name name tl
                    | []                               -> failwith @@ "Fail: unknown label '" ^ name ^ "'"
                in
                let rec jump_to_line_no n code =
                    match n, code with
                    | 0, _     -> code
                    | n, _::tl -> jump_to_line_no (n - 1) tl
                    | _, []    -> failwith @@ "Fail: wrong line number " ^ string_of_int n
                in  
                match i with
                | S_READ           ->
                    let y, env = Env.read_int env in
                    transmit (env, y::stack)
                | S_WRITE          ->
                    let y, stack' = Util.pop_one stack in
                    transmit (Env.write_int y env, stack')
                | S_PUSH  n        ->
                    transmit (env, n::stack)
                | S_LD    x        ->
                    transmit (env, Env.find_var x env :: stack)
                | S_ST    x        ->
                    let y, stack' = Util.pop_one stack in
                    transmit (Env.add_var x y env, stack')
                | S_BINOP s        ->
                    let y, x, stack' = Util.pop_two stack in
                    let r = Interpreter.BinOpEval.fun_of_string s x y in
                    transmit (env, r::stack')
                | S_JMP   l        -> run' conf (jump_to_name l full_code)
                | S_JMPZ  l        ->
                    let x, stack' = Util.pop_one stack in
                    let conf' = (env, stack', env_stack) in
                    if x = 0
                        then run' conf' (jump_to_name l full_code)
                        else transmit (env, stack')
                | S_LABEL _        -> transmit (env, stack)
                | S_CALL (f, args) ->
                    let rec add_args args stack env =
                        match args, stack with
                        | [],          _             -> env, stack
                        | name::args', value::stack' -> add_args args' stack' (Env.add_var name value env)
                        | _                          -> failwith "Fail: wrong number of arguments"
                    in
                    let fun_env, stack' = add_args (List.rev args) stack (Env.local env) in
                    run' (fun_env, (line_no+1)::stack', env::env_stack) (jump_to_name f full_code)
                | S_RET            ->
                    let res, ret_addr, stack' = Util.pop_two stack     in
                    let old_env, env_stack'   = Util.pop_one env_stack in
                    let env' = Env.update_io (Env.get_input env) (Env.get_output env) old_env in  
                    run' (env', res::stack', env_stack') (jump_to_line_no ret_addr full_code)
                | S_END            -> List.rev @@ Env.get_output env
                | S_DROP           ->
                    let _, stack' = Util.pop_one stack in
                    transmit (env, stack')
        in
        run' (Env.with_input input, [], []) full_code
    
end

let label_counter = ref 0
let get_and_inc r = let i = !r in r := i + 1; i

module Compile = struct

    module FuncMap = Map.Make (String)

    open Language.Expr
    open Language.Stmt

    let rec expr f_argnames = 
        let expr' x = expr f_argnames x
        in function
        | Var      x                       -> [S_LD   x]
        | Const    n                       -> [S_PUSH n]
        | Binop   (s, x, y)                -> expr' x @ expr' y @ [S_BINOP s]
        | Language.Expr.Funcall (f, arges) -> List.concat (List.map expr' arges) @ [S_CALL ("_"^f, FuncMap.find f f_argnames)]

    let rec stmt f_argnames = 
        let stmt' x = stmt f_argnames x in
        let expr' x = expr f_argnames x in
        function
        | Skip                             -> []
        | Assign (x, e)                    -> expr' e @ [S_ST x]
        | Read    x                        -> [S_READ; S_ST x]
        | Write   e                        -> expr' e @ [S_WRITE]
        | Seq    (l, r)                    -> stmt' l @ stmt' r
        | If     (e, st, sf)               ->
            let no = string_of_int (get_and_inc label_counter)
            in expr' e              @
              [S_JMPZ  ("else"^no)] @
               stmt' st             @
              [S_JMP   ("fin"^no) ;
               S_LABEL ("else"^no)] @
               stmt' sf             @
              [S_LABEL ("fin"^no) ]
        | While (e, s)                     ->
            let no = string_of_int (get_and_inc label_counter)
            in [S_LABEL ("start"^no)] @
                expr' e               @
               [S_JMPZ  ("fin"^no)  ] @
                stmt' s               @
               [S_JMP   ("start"^no);
                S_LABEL ("fin"^no)  ]
        | Language.Stmt.Funcall (f, arges) -> expr' (Language.Expr.Funcall (f, arges)) @ [S_DROP]
        | Return e                         -> expr' e @ [S_RET]

    let prog (fdefs, main) =
        let f_argnames = List.fold_left (fun fm (name, argnames, _) -> FuncMap.add name argnames fm) FuncMap.empty fdefs
        in stmt f_argnames main @ [S_END] @ 
                List.concat (List.map (fun (name, _, body) -> [S_LABEL ("_"^name)] @ stmt f_argnames body) fdefs)
end
