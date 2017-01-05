open Language.Expr
open Language.Stmt

module Env : sig

    type t

    val empty    : t

    val cons_no  : t -> string -> int * t

    val fresh_no : t -> int * t

end = struct

    module SMap = Map.Make (String)

    type t = int SMap.t * int

    let empty = SMap.empty, 0

    let cons_no (map, i) cons =
        try SMap.find cons map, (map, i)
        with Not_found -> let fresh_n = SMap.cardinal map + 1 
                          in fresh_n, (SMap.add cons fresh_n map, i)

    let fresh_no (map, i) = i, (map, i + 1)

end

let fold_unsugar : Env.t -> 'a list -> (Env.t -> 'a -> 'a * Env.t) -> 'a list * Env.t = fun init_env xs unsugar ->
    List.fold_right (fun x (upd_xs, env) -> let x', env' = unsugar env x
                                            in x'::upd_xs, env')
                     xs
                    ([], init_env)

let rec expr_unsugar : Env.t -> Language.Expr.t -> Language.Expr.t * Env.t = fun env ->
    function
    | Object  (cons,  es) -> 
        let no, env = Env.cons_no env cons in
        let es, env = fold_unsugar env es expr_unsugar in
        Funcall ("arrcreate", (Const no)::(Const (List.length es))::es), env
    | Array   (boxed, es) ->
        let es, env = fold_unsugar env es expr_unsugar
        in Array (boxed, es), env
    | Binop   (s, xe, ye) ->
        let xe, env = expr_unsugar env xe in
        let ye, env = expr_unsugar env ye in
        Binop (s, xe, ye), env
    | Funcall (f, arges)  ->
        let arges, env = fold_unsugar env arges expr_unsugar
        in Funcall (f, arges), env
    | GetElement (ae, ie) ->
        let ae, env = expr_unsugar env ae in
        let ie, env = expr_unsugar env ie in
        GetElement (ae, ie), env
    | e                   -> e, env

let rec stmt_unsugar : Env.t -> Language.Stmt.t -> Language.Stmt.t * Env.t = fun env ->
    function
    | Skip -> Skip, env
    | Assign     (x, e) ->
        let e, env = expr_unsugar env e
        in Assign (x, e), env
    | SetElement (x, inds, e) ->
        let e, env = expr_unsugar env e in
        let inds, env = fold_unsugar env inds expr_unsugar in
        SetElement (x, inds, e), env
    | Seq (l, r) ->
        let l, env = stmt_unsugar env l in
        let r, env = stmt_unsugar env r in
        Seq (l, r), env
    | If (e, t, f) ->
        let e, env = expr_unsugar env e in
        let t, env = stmt_unsugar env t in
        let f, env = stmt_unsugar env f in
        If (e, t, f), env
    | While (e, s) ->
        let e, env = expr_unsugar env e in
        let s, env = stmt_unsugar env s in
        While (e, s), env
    | Repeat (s, e) ->
        let s, env = stmt_unsugar env s in
        let e, env = expr_unsugar env e in
        Repeat (s, e), env
    | Funcall (f, arges) ->
        let arges, env = fold_unsugar env arges expr_unsugar
        in Funcall (f, arges), env
    | Return e ->
        let e, env = expr_unsugar env e in
        Return e, env
    | Case (temp, handlers) ->
        let var_no, env = Env.fresh_no env in
        let temp_name = "supp_case_temp_" ^ string_of_int var_no in
        let tag_name  = "supp_case_tag_"  ^ string_of_int var_no in
        let temp, env = expr_unsugar env temp in
        let init = Seq (Assign (temp_name, temp), Assign (tag_name, Funcall ("arrtag", [Var temp_name]))) in
        let switch, env = List.fold_right 
                            (fun (cons, names, s) (acc, env) ->
                                let no, env = Env.cons_no  env cons in
                                let s, env  = stmt_unsugar env s    in
                                let bindings, _ = List.fold_left (fun (acc, i) x -> 
                                                                    Seq (acc, Assign (Language.var_name_prefix ^ x, GetElement (Var temp_name, Const i))), 
                                                                    i + 1
                                                                 ) 
                                                                 (Skip, 0) 
                                                                 names
                                in
                                If (Binop ("==", Var tag_name, Const no), Seq (bindings, s), acc), env
                            )
                            handlers
                            (Skip, env)
        in
        Seq (init, switch), env

let fundef_unsugar : Env.t -> Language.Prog.fundef -> Language.Prog.fundef * Env.t = fun env (name, args, body) -> 
    let body, env = stmt_unsugar env body
    in (name, args, body), env

let unsugar : Language.Prog.t -> Language.Prog.t = fun (fundefs, main) ->
    let fundefs, env = fold_unsugar Env.empty fundefs fundef_unsugar in
    let main, _ = stmt_unsugar env main in
    (fundefs, main)
