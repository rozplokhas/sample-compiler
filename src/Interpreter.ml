module Expr = struct

    open Language.Expr

    let rec eval env = function
    | Const   n          -> n, env
    | Var     x          -> Env.find_var x env, env
    | Binop  (s, xe, ye) ->
        let x, env = eval env xe in
        let y, env = eval env ye in
        Util.BinOpEval.fun_of_string s x y, env
    | Funcall (f, arges) ->
        let args, env = List.fold_left
                            (fun (acc, env) arge -> let arg, env = eval env arge in (acc @ [arg], env))
                            ([], env)
                            arges
        in
        let r, fun_env = (Env.find_fun f env) args (Env.local env)
        in  r, Env.update_io (Env.get_input fun_env) (Env.get_output fun_env) env

end


module Stmt = struct

    open Language.Stmt

    let rec eval env = function
    | Skip              -> None, env
    | Seq (l, r)        ->
        let lr, env = eval env l in
        (
            match lr with
            | None   -> eval env r
            | Some _ -> lr, env
        )
    | Assign (x, e)     ->
        let v, env = Expr.eval env e
        in None, Env.add_var x v env
    | Write e            ->
        let i, env = Expr.eval env e
        in None, Env.write_int i env
    | Read x             ->
        let i, env = Env.read_int env
        in None, Env.add_var x i env
    | If (e, st, sf)     ->
        let b, env = Expr.eval env e
        in if b <> 0
           then eval env st
           else eval env sf
    | While (e, s)       ->
        let b, env = Expr.eval env e
        in if b <> 0
           then eval env (Seq (s, While (e, s)))
           else None, env
    | Repeat (s, e)      ->
        let r, env = eval env s in
        (
            match r with
            | None ->
                let b, env = Expr.eval env e
                in if b = 0
                    then eval env (Repeat (s, e))
                    else None, env 
            | Some _ -> r, env
        )
    | Funcall (f, arges) ->
        let _, env = Expr.eval env (Language.Expr.Funcall (f, arges))
        in None, env
    | Return e           ->
        let r, env = Expr.eval env e
        in Some r, env

end


module Prog : sig

    val interpret : int list -> Language.Prog.t -> int list

end = struct

    let fun_of_fundef : Language.Prog.fundef -> (int list -> Env.t -> int * Env.t) =
        let rec add_args names vals env =
            match names, vals with
            | [], []       -> env
            | n::ns, v::vs -> Env.add_var n v (add_args ns vs env)
            | _            -> failwith "Fail: wrong number of arguments"
        in fun (_, argnames, body) ->
            (fun args env ->
                match Stmt.eval (add_args argnames args env) body with
                | Some r, env -> r, env
                | None,   _   -> failwith "Fail: function must return a value"
            )

    let interpret input (fundefs, stmt) =
        let start_env = List.fold_left
                            (fun env ((f, _, _) as fdef) -> Env.add_fun f (fun_of_fundef fdef) env)
                            (Env.with_input input)
                            fundefs
        in
        let _, res_env = Stmt.eval start_env stmt in
        List.rev @@ Env.get_output res_env

end
