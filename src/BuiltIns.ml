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

let write_cont args env =
    let i = MatchList.match_with_one args in
    Printf.printf "%d" (Value.to_int i);
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

let str_write_cont args env =
    let sv = MatchList.match_with_one args         in
    let s  = Bytes.to_string @@ Value.to_string sv in
    Printf.printf "%s" s;
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

let arrcreate args env =
    match args with
    | t::n::elems -> Value.of_array (Value.to_int t) @@ Array.of_list elems
    | _           -> MatchList.fail ()

let arrget args env =
    let av, iv = MatchList.match_with_two args      in
    let a,  i  = Value.to_array av, Value.to_int iv in
    Array.get a i

let arrset args env =
    let rec set_element arv indices value =
        let arr = Value.to_array arv in 
        match indices with
        | [index] -> Array.set arr index value
        | _ -> let indices, last_ind = Util.nip_last indices
               in set_element (Array.get arr last_ind) indices value
    in
    match args with
    | n::arr::value::indices -> let indices = List.map Value.to_int indices
                                in set_element arr indices value;
                                Value.of_int 0
    | _ -> MatchList.fail () 

let arrlen args env =
    let av = MatchList.match_with_one args in
    let a  = Value.to_array av             in
    Value.of_int @@ Array.length a

let arrmake args env =
    let nv, v = MatchList.match_with_two args in
    let n     = Value.to_int nv               in
    Value.of_array 1 (Array.make n v)

let arrtag args env =
    let av = MatchList.match_with_one args in
    Value.of_int @@ Value.tag av

let list : (string * (Value.t list -> Env.t -> Value.t)) list =
    ["read"          , read          ;
     "write"         , write         ;
     "write_cont"    , write_cont    ;
     "str_read"      , str_read      ;
     "str_write"     , str_write     ;
     "str_write_cont", str_write_cont;
     "str_make"      , str_make      ;
     "str_set"       , str_set       ;
     "str_get"       , str_get       ;
     "str_dup"       , str_dup       ;
     "str_cat"       , str_cat       ;
     "str_cmp"       , str_cmp       ;
     "str_len"       , str_len       ;
     "str_sub"       , str_sub       ;
     "arrcreate"     , arrcreate     ;
     "arrget"        , arrget        ;
     "arrset"        , arrset        ;
     "arrlen"        , arrlen        ;
     "arrmake"       , arrmake       ;
     "Arrmake"       , arrmake       ;
     "arrtag"        , arrtag        ]
