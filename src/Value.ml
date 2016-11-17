type t =
| Int   of int
| String of bytes

let of_int n    = Int n

let of_string s = String s

let to_string = function
| String s -> s
| _        -> failwith "Value must be string"

let to_int = function
| Int n -> n
| _     -> failwith "Value must be int"
