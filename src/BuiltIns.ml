module MatchList = struct

    let fail () = failwith "Wrong number of arguments"

    let match_with_zero = function
    | [] -> ()
    | _  -> fail ()

    let match_with_one = function
    | [x] -> x
    | _   -> fail ()

    let match_with_two  = function
    | [x; y] -> x, y
    | _      -> fail ()

    let match_with_three = function
    | [x; y; z] -> x, y, z
    | _         -> fail ()

end

let read args env =
    let _ = MatchList.match_with_zero args in
    Printf.printf "> ";
    Value.of_int @@ read_int ()

let write args env =
    let i = MatchList.match_with_one args in
    Printf.printf "%d\n" (Value.to_int i);
    Value.of_int 0

let str_read args env =
    let _ = MatchList.match_with_zero args in
    Printf.printf "> ";
    Value.of_string @@ Bytes.of_string @@ read_line ()

let str_write args env =
    let sv = MatchList.match_with_one args         in
    let s  = Bytes.to_string @@ Value.to_string sv in
    Printf.printf "%s\n" s;
    Value.of_int 0

let str_make args env =
    let nv, cv = MatchList.match_with_two args                in
    let n,  c  = Value.to_int nv, Char.chr @@ Value.to_int cv in
    Value.of_string (Bytes.make n c)

let str_set args env =
    let sv, iv, cv = MatchList.match_with_three args                                  in
    let s,  i,  c  = Value.to_string sv, Value.to_int iv, Char.chr @@ Value.to_int cv in
    Bytes.set s i c; Value.of_string s

let str_get args env =
    let sv, iv = MatchList.match_with_two args       in
    let s,  i  = Value.to_string sv, Value.to_int iv in
    Value.of_int @@ Char.code (Bytes.get s i)

let str_dup args env =
    let sv = MatchList.match_with_one args in
    let s  = Value.to_string sv            in
    Value.of_string @@ Bytes.init (Bytes.length s) (fun i -> Bytes.get s i)

let str_cat args env =
    let sv1, sv2 = MatchList.match_with_two args            in
    let s1,  s2  = Value.to_string sv1, Value.to_string sv2 in
    Value.of_string @@ Bytes.cat s1 s2

let str_cmp args env =
    let sv1, sv2 = MatchList.match_with_two args            in
    let s1,  s2  = Value.to_string sv1, Value.to_string sv2 in
    Value.of_int @@ Bytes.compare s1 s2

let str_len args env =
    let sv = MatchList.match_with_one args in
    let s  = Value.to_string sv            in
    Value.of_int @@ Bytes.length s

let str_sub args env =
    let sv, iv, lv = MatchList.match_with_three args                      in
    let s,  i,  l  = Value.to_string sv, Value.to_int iv, Value.to_int lv in
    Value.of_string (Bytes.sub s i l)


let list : (string * (Value.t list -> Env.t -> Value.t)) list =
    ["read"     , read     ;
     "write"    , write    ;
     "str_read" , str_read ;
     "str_write", str_write;
     "str_make" , str_make ;
     "str_set"  , str_set  ;
     "str_get"  , str_get  ;
     "str_dup"  , str_dup  ;
     "str_cat"  , str_cat  ;
     "str_cmp"  , str_cmp  ;
     "str_len"  , str_len  ;
     "str_sub"  , str_sub  ]
