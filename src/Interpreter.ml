module BinOpEval : sig

    val fun_of_string : string -> int -> int -> int

end = struct

    let intf_of_boolf : (int -> int -> bool) -> int -> int -> int =
        fun op x y -> if op x y then 1 else 0

    let fun_of_string s = List.assoc s
        [
            "+",  ( +   );
            "-",  ( -   );
            "*",  ( *   );
            "/",  ( /   );
            "%",  ( mod );
            "<",  intf_of_boolf ( <  );
            "<=", intf_of_boolf ( <= );
            ">",  intf_of_boolf ( >  );
            ">=", intf_of_boolf ( >= );
            "==", intf_of_boolf ( =  );
            "!=", intf_of_boolf ( <> );
            "&&", intf_of_boolf (fun x y -> x <> 0 && y <> 0);
            "!!", intf_of_boolf (fun x y -> x <> 0 || y <> 0)
        ]

end


module Env : sig

    type t

    val with_input : int list -> t
    val local      : t -> t
    val add_var    : string -> int                        -> t -> t
    val add_fun    : string -> (int list -> t -> int * t) -> t -> t
    val find_var   : string -> t -> int
    val find_fun   : string -> t -> (int list -> t -> int * t)
    val read_int   : t -> int * t
    val write_int  : int -> t -> t
    val get_input  : t -> int list
    val get_output : t -> int list
    val update_io  : int list -> int list -> t -> t

end = struct

    module StringMap = Map.Make (String)

    type t = int StringMap.t * (int list -> t -> int * t) StringMap.t * int list * int list

    let with_input inp                            = (StringMap.empty, StringMap.empty, inp, [])
    let local               (_,  fm, inp,   outp) = (StringMap.empty, fm, inp, outp)
    let add_var    x   v    (vm, fm, inp,   outp) = (StringMap.add x v vm, fm, inp, outp)
    let add_fun    x   f    (vm, fm, inp,   outp) = (vm, StringMap.add x f fm, inp, outp)
    let find_var   x        (vm, _,  inp,   outp) = StringMap.find x vm
    let find_fun   x        (_ , fm, inp,   outp) = StringMap.find x fm
    let read_int            (vm, fm, i::is, outp) = i, (vm, fm, is, outp)
    let write_int  i        (vm, fm, inp,   outp) = (vm, fm, inp, i::outp)
    let get_input           (_,  _,  inp,   _   ) = inp
    let get_output          (_,  _,  _,     outp) = outp
    let update_io  inp outp (vm, fm, _,     _   ) = (vm, fm, inp, outp)

end


module Expr = struct

    open Language.Expr

    let rec eval env = function
    | Const   n          -> n, env
    | Var     x          -> Env.find_var x env, env
    | Binop  (s, xe, ye) ->
        let x, env = eval env xe in
        let y, env = eval env ye in
        BinOpEval.fun_of_string s x y, env
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
        in fun (_, argnames, body) ->
            (fun args env ->
                let Some r, env = Stmt.eval (add_args argnames args env) body
                in r, env
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
