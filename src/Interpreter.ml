module BinOpEval : sig

  val fun_of_string : string -> int -> int -> int

end = struct

  let intf_of_boolf : (int -> int -> bool) -> int -> int -> int =
    fun op x y -> if op x y then 1 else 0

  let fun_of_string s = List.assoc s
    ["+",  ( +   );
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
     "!!", intf_of_boolf (fun x y -> x <> 0 || y <> 0)]

end 

  
module Expr =
  struct
    open Language.Expr
                                                            
    let rec eval state = function
    | Const  n -> n
    | Var    x -> state x
    | Binop  (s, x, y) -> BinOpEval.fun_of_string s (eval state x) (eval state y)
  end
  
module Stmt =
  struct

    open Language.Stmt

    let eval input stmt =
      let rec eval' ((state, input, output) as c) stmt =
	let state' x = List.assoc x state in
	match stmt with
	| Skip          -> c
	| Seq    (l, r) -> eval' (eval' c l) r
	| Assign (x, e) -> ((x, Expr.eval state' e) :: state, input, output)
	| Write   e     -> (state, input, output @ [Expr.eval state' e])
	| Read    x     ->
	    let y::input' = input in
	    ((x, y) :: state, input', output)
      in
      let (_, _, result) = eval' ([], input, []) stmt in
      result

  end
