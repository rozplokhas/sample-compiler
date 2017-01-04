type t =
| Int    of int
| String of bytes
| Array  of t array

let of_int    n = Int n

let of_string s = String s

let of_array  a = Array a

let to_int = (function
| Int n -> n
| _     -> failwith "Value must be int")

let to_string = (function
| String s -> s
| _        -> failwith "Value must be string")

let to_array = (function
| Array a -> a
| _       -> failwith "Value must be array")
