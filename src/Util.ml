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

let pop_one = function
    | x::xs -> x, xs
    | []    -> failwith "Fail: stack is empty"

let pop_two = function
    | x::y::xs -> x, y, xs
    | _        -> failwith "Fail: stack is empty"
