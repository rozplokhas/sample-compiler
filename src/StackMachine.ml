type instr =
| S_PUSH            of int
| S_SPUSH           of string
| S_LD              of string
| S_ST              of string
| S_BINOP           of string
| S_JMP             of string
| S_JMPZ            of string
| S_LABEL           of string
| S_CALL            of string * int              (* function label, number of arguments *)
| S_RET
| S_DROP
| S_FUN_START       of string list * string list (* arguments and local variables names *)
| S_MAIN_START      of string list               (* inner variables names               *)
| S_TRY_BLOCK_START of string                    (* handler label                       *)
| S_TRY_BLOCK_END
| S_THROW           of int                       (* identifier for x86                  *)
| S_HANDLER_START                                (* signal for x86                      *)



module Interpreter : sig

    val run : instr list -> unit

end = struct

    let rec jump_to_label name = function
    | (_, S_LABEL l)::tl when l = name -> tl 
    | _::tl                            -> jump_to_label name tl
    | []                               -> failwith @@ "Unknown label '" ^ name ^ "'"

    let rec jump_to_line_no n code =
        match n, code with
        | 0, _     -> code
        | n, _::tl -> jump_to_line_no (n - 1) tl
        | _, []    -> failwith @@ "Wrong line number " ^ string_of_int n

    let run full_code =
        let full_code = Util.number_elements_fst full_code in
        let rec run_rest ((stack, env_stack, handlers_stack) as conf) code =
            let curr_env, env_stack = Util.pop_one env_stack in
            match code with
            | []                  -> ()
            | (line_no, i)::code' ->
                let transmit (stack', env') = run_rest (stack', env'::env_stack, handlers_stack) code'
                in  
                match i with
                | S_PUSH  n                 ->
                    transmit (Value.of_int    n :: stack, curr_env)
                | S_SPUSH s                 ->
                    transmit (Value.of_string s :: stack, curr_env)
                | S_LD    x                 ->
                    transmit (Env.find_var x curr_env :: stack, curr_env)
                | S_ST    x                 ->
                    let y, stack' = Util.pop_one stack in
                    transmit (stack', Env.add_var x y curr_env)
                | S_BINOP s                 ->
                    let y, x, stack' = Util.pop_two stack in
                    let r = Util.BinOpEval.fun_of_string s (Value.to_int x) (Value.to_int y) in
                    transmit (Value.of_int r :: stack', curr_env)
                | S_JMP   l                 -> run_rest conf (jump_to_label l full_code)
                | S_JMPZ  l                 ->
                    let x, stack' = Util.pop_one stack in
                    let conf' = (stack', curr_env::env_stack, handlers_stack) in
                    if Value.to_int x = 0
                        then run_rest conf' (jump_to_label l full_code)
                        else transmit (stack', curr_env)
                | S_LABEL _                 -> transmit (stack, curr_env)
                | S_CALL (f, n)             ->
                    let fun_start = try Some (jump_to_label f full_code) with Failure _ -> None in
                    (
                        match fun_start with
                        | Some code -> run_rest (Value.of_int (line_no+1) :: stack, curr_env::env_stack, handlers_stack) code
                        | None ->
                            let args, stack' = Util.split_stack n stack in
                            let res = (List.assoc f BuiltIns.list) (List.rev args) (Env.local curr_env) in
                            transmit (res::stack', curr_env)

                    )
                | S_RET                     ->
                    let res, ret_addr, stack' = Util.pop_two stack in
                    run_rest (res::stack', env_stack, handlers_stack) (jump_to_line_no (Value.to_int ret_addr) full_code)
                | S_DROP                    ->
                    let _, stack' = Util.pop_one stack in
                    transmit (stack', curr_env)
                | S_FUN_START (args, _)     ->
                    let rec add_args args stack env =
                        match args, stack with
                        | [],          _             -> env, stack
                        | name::args', value::stack' -> add_args args' stack' (Env.add_var name value env)
                        | _                          -> failwith "Wrong number of arguments"
                    in
                    let addr, stack = Util.pop_one stack in
                    let fun_env, stack' = add_args (List.rev args) stack (Env.local curr_env) in
                    run_rest (addr::stack', fun_env::curr_env::env_stack, handlers_stack) code'
                | S_MAIN_START _            -> failwith "More than one starting point"
                | S_TRY_BLOCK_START handler ->
                    run_rest (stack, curr_env::env_stack, (handler, List.length stack, List.length env_stack)::handlers_stack) code'
                | S_TRY_BLOCK_END           ->
                    let _, handlers_stack' = Util.pop_one handlers_stack
                    in run_rest (stack, curr_env::env_stack, handlers_stack') code'
                | S_THROW _                 ->
                    let exc, stack = Util.pop_one stack                                                                  in
                    let (handler, stack_state, env_stack_state), handlers_stack' = Util.pop_one handlers_stack           in
                    let _, stack'     = Util.split_stack (List.length stack - stack_state)          stack                in
                    let _, env_stack' = Util.split_stack (List.length env_stack - env_stack_state) (curr_env::env_stack) in
                    run_rest (exc::stack', env_stack', handlers_stack') (jump_to_label handler full_code)
                | S_HANDLER_START           ->  transmit (stack, curr_env)
        in
        run_rest ([], [Env.empty], []) (jump_to_label "main" full_code)
    
end



module Compile : sig

    val prog : Language.Prog.t -> instr list

end = struct

    module StringSet = Set.Make (String)

    open Language.Expr
    open Language.Stmt

    let fun_name_prefix = "fun_"

    let rec expr fun_names = 
        let expr' e = expr fun_names e in
        function
        | Var                    x             -> [S_LD    x]
        | Const                  n             -> [S_PUSH  n]
        | Array                 (boxed, elems) -> let len = List.length elems
                                                  in [S_PUSH (if boxed then 2 else 1)]   @
                                                     [S_PUSH len]                        @ 
                                                      List.concat (List.map expr' elems) @ 
                                                     [S_CALL ("arrcreate", len + 2)]
        | StrConst               s             -> [S_SPUSH s]
        | Binop                 (s, x, y)      -> expr' x   @ expr' y   @ [S_BINOP s]
        | GetElement            (arr, ind)     -> expr' arr @ expr' ind @ [S_CALL ("arrget", 2)]
        | Language.Expr.Funcall (f, arges)     -> List.concat (List.map expr' arges) @ [S_CALL ((if StringSet.mem f fun_names 
                                                                                                    then fun_name_prefix^f
                                                                                                    else f), 
                                                                                                List.length arges)]
        | Object                 _             -> assert false (* doesn't exist after unsugaring *)

    let label_counter = ref 0
    let get_and_inc r = let i = !r in r := i + 1; i

    let rec stmt : StringSet.t -> Language.Stmt.t -> instr list * instr list = fun fun_names ->
        let expr' e = expr fun_names e in
        let stmt' e = stmt fun_names e in
        let just_code code = code, [] in
        (* let (<|>) xp yp = let (x1, x2), (y1, y2) = xp, yp in x1 @ y1, x2 @ y2 in *)  
        function
        | Skip                             -> just_code @@ []
        | Assign     (x, e)                -> just_code @@ expr' e @ [S_ST x]
        | SetElement (x, inds, value)      ->
            let ind_num = List.length inds
            in just_code @@
                [S_PUSH (List.length inds)       ;
                 S_LD    x                       ] @
                 expr'   value                     @
                 List.concat (List.map expr' inds) @
                [S_CALL ("arrset", ind_num + 3)  ;
                 S_DROP                          ]
        | Seq        (l, r)                -> 
            let lc, lh = stmt' l in
            let rc, rh = stmt' r in
            lc @ rc, lh @ rh
        | If         (e, st, sf)           ->
            let stc, sth = stmt' st in
            let sfc, sfh = stmt' sf in
            let no = string_of_int (get_and_inc label_counter) in
            ( expr' e              @
             [S_JMPZ  ("else"^no)] @
              stc                  @
             [S_JMP   ("fin"^no) ;
              S_LABEL ("else"^no)] @
              sfc                  @
             [S_LABEL ("fin"^no) ],
            sth @ sfh)
        | While      (e, s)                ->
            let sc, sh = stmt' s                               in
            let no = string_of_int (get_and_inc label_counter) in
            ([S_LABEL ("start"^no)] @
              expr' e               @
             [S_JMPZ  ("fin"^no)  ] @
              sc                    @
             [S_JMP   ("start"^no);
              S_LABEL ("fin"^no)  ],
            sh)
        | Repeat     (s, e)                ->
            let sc, sh = stmt' s in
            let no = string_of_int (get_and_inc label_counter) in
            ([S_LABEL ("start"^no)] @
              sc                    @
              expr' e               @
             [S_JMPZ  ("start"^no)],
            sh)
        | Language.Stmt.Funcall (f, arges) -> just_code @@ expr' (Language.Expr.Funcall (f, arges)) @ [S_DROP]
        | Return      e                    -> just_code @@ expr' e @ [S_RET]
        | Throw       e                    -> just_code @@ expr' e @ [S_THROW (get_and_inc label_counter)]
        | TryCatch   (code, x, handler)    ->
            let code_c,    code_h    = stmt' code                 in
            let handler_c, handler_h = stmt' handler              in
            let no = string_of_int (get_and_inc label_counter) in
            ([S_TRY_BLOCK_START ("handler_"^no)] @
              code_c                             @
             [S_TRY_BLOCK_END                    ;
              S_LABEL ("after_try_"^no)]         ,
              code_h                             @
             [S_LABEL ("handler_"^no)            ;
              S_HANDLER_START                    ;
              S_ST x]                            @
              handler_c                          @
             [S_JMP ("after_try_"^no)]           @
              handler_h) 
        | Case        _                    -> assert false
        | TryWith     _                    -> assert false (* don't exist after unsugaring *)

    let prog (fdefs, main) =
        let pair_concat     (a,b) = a @ b                                              in
        let fun_names = StringSet.of_list @@ List.map (fun (name, _, _) -> name) fdefs in
        let global_c, global_h = stmt fun_names main                                   in
        List.concat (List.map (fun ((name, argnames, body) as fdef) -> 
                                    [S_LABEL     (fun_name_prefix^name)             ; 
                                     S_FUN_START (argnames, FunInfo.local_vars fdef)] @
                                     pair_concat (stmt fun_names body)                             
                              )
                              fdefs) @
        [S_MAIN_START (FunInfo.local_vars ("", [], main))] @
         global_h                                          @
        [S_LABEL "main"]                                   @
         global_c
end
