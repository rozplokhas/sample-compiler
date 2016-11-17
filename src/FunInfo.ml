open Language.Stmt

module S = Set.Make (String)

let local_vars : Language.Prog.fundef -> string list = fun (_, args, body) ->
    let arg_set = S.of_list args in
    let check_and_add x var_set = if S.mem x var_set || S.mem x arg_set then var_set else S.add x var_set
    in
    let rec add_vars_from_stmt acc = function
    | Assign (x, _ )     -> check_and_add x acc
    | While  (_, s )
    | Repeat (s, _ )     -> add_vars_from_stmt acc s
    | If     (_, s1, s2)
    | Seq    (   s1, s2) -> add_vars_from_stmt (add_vars_from_stmt acc s1) s2
    | _                  -> acc
    in
    S.elements @@ add_vars_from_stmt S.empty body
