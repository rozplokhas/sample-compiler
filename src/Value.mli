type t

val of_int    : int -> t
val of_string : bytes -> t
val of_array  : int -> t array -> t
val to_int    : t -> int
val to_string : t -> bytes
val to_array  : t -> t array
val tag       : t -> int
