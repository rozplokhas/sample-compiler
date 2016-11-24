module Expr : sig 

    val eval : Env.t -> Language.Expr.t -> Value.t

end = struct

    open Language.Expr

    let rec eval env = function
    | Const    n          -> Value.of_int    n
    | StrConst s          -> Value.of_string s
    | Var      x          -> Env.find_var x env
    | Binop   (s, xe, ye) ->
        let x = Value.to_int @@ eval env xe in
        let y = Value.to_int @@ eval env ye in
        Value.of_int @@ Util.BinOpEval.fun_of_string s x y
    | Funcall (f, arges)  ->
        let args = List.map (eval env) arges in
        (Env.find_fun f env) args (Env.local env)

end


module Stmt : sig

    val eval : Env.t -> Language.Stmt.t -> Value.t option * Env.t

end = struct

    open Language.Stmt

    let rec eval env = function
    | Skip               -> None, env
    | Seq (l, r)         ->
        let lr, env = eval env l in
        (
            match lr with
            | None   -> eval env r
            | Some _ -> lr, env
        )
    | Assign (x, e)      -> None, Env.add_var x (Expr.eval env e) env
    | If (e, st, sf)     ->
        if Value.to_int (Expr.eval env e) <> 0
            then eval env st
            else eval env sf
    | While (e, s)       ->
        if Value.to_int (Expr.eval env e) <> 0
           then eval env (Seq (s, While (e, s)))
           else None, env
    | Repeat (s, e)      ->
        let r, env = eval env s in
        (
            match r with
            | None ->
                if Value.to_int (Expr.eval env e) = 0
                    then eval env (Repeat (s, e))
                    else None, env 
            | Some _ -> r, env
        )
    | Funcall (f, arges) ->
        let _ = Expr.eval env (Language.Expr.Funcall (f, arges))
        in None, env
    | Return e           -> Some (Expr.eval env e), env

end


module Prog : sig

    val interpret : Language.Prog.t -> unit

end = struct

    let fun_of_fundef : Language.Prog.fundef -> (Value.t list -> Env.t -> Value.t) =
        let rec add_args names vals env =
            match names, vals with
            | [], []       -> env
            | n::ns, v::vs -> Env.add_var n v (add_args ns vs env)
            | _            -> failwith "Wrong number of arguments"
        in fun (_, argnames, body) ->
            (fun args env ->
                match Stmt.eval (add_args argnames args env) body with
                | Some r, _ -> r
                | None  , _ -> failwith "Function must return a value"
            )

    let interpret (fundefs, stmt) =
        let funs = List.map (fun (f, _, _) as fdef -> f, fun_of_fundef fdef) fundefs @ BuiltIns.list
        in
        let start_env = List.fold_left
                            (fun env (fname, f) -> Env.add_fun fname f env)
                            Env.empty
                            funs
        in
        match Stmt.eval start_env stmt with
        | None  , _ -> ()
        | Some _, _ -> failwith "Return from global code"

end
