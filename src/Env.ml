module StringMap = Map.Make (String)

type t = Value.t StringMap.t * (Value.t list -> t -> Value.t) StringMap.t

let empty                 = (StringMap.empty,      StringMap.empty     )
let local        (_,  fm) = (StringMap.empty,      fm                  )
let add_var  x v (vm, fm) = (StringMap.add x v vm, fm                  )
let add_fun  x f (vm, fm) = (vm,                   StringMap.add x f fm)
let find_var x   (vm, _ ) = try StringMap.find x vm with Not_found -> failwith @@ "Unknown variable '" ^ x ^ "'"
let find_fun x   (_ , fm) = try StringMap.find x fm with Not_found -> failwith @@ "Unknown function '" ^ x ^ "'"
