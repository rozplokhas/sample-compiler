type t

val empty    : t
val local    : t -> t
val add_var  : string -> Value.t                        -> t -> t
val add_fun  : string -> (Value.t list -> t -> Value.t) -> t -> t
val find_var : string -> t -> Value.t
val find_fun : string -> t -> (Value.t list -> t -> Value.t)
