let pop_one = function
    | x::xs -> x, xs
    | []    -> failwith "Fail: stack is empty"

let pop_two = function
    | x::y::xs -> x, y, xs
    | _        -> failwith "Fail: stack is empty"
