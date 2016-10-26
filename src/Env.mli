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
