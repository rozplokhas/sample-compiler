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

let pop_one = (function
| x::xs -> x, xs
| []    -> failwith "Stack is empty")

let pop_two = (function
| x::y::xs -> x, y, xs
| _        -> failwith "Stack is empty")

let number_elements_fst lst =
    let rec number_from start_n = function
    | []      -> []
    | x :: xs -> (start_n, x) :: number_from (start_n + 1) xs
    in
    number_from 0 lst

let number_elements_snd lst =
    let rec number_from start_n = function
    | []      -> []
    | x :: xs -> (x, start_n) :: number_from (start_n + 1) xs
    in
    number_from 0 lst

let rec split_stack n lst =
    match n, lst with
    | 0, _     -> [], lst
    | n, x::xs -> let l, r = split_stack (n - 1) xs in x::l, r
    | _        -> failwith "Stack is empty"

let rec nip_last = (function
| []    -> failwith "List is empty"
| [x]   -> [], x
| x::xs -> let xs', last = nip_last xs in x::xs', last)
