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

let write args env =
    let i = MatchList.match_with_one args in
    Printf.printf "%d\n" (Value.to_int i);
    Value.of_int 0

let read args env =
    let _ = MatchList.match_with_zero args in
    Printf.printf "> ";
    Value.of_int @@ read_int ()

let str_write args env =
    let sv = MatchList.match_with_one args         in
    let s  = Bytes.to_string @@ Value.to_string sv in
    Printf.printf "%s\n" s;
    Value.of_int 0

let str_read args env =
    let _ = MatchList.match_with_zero args in
    Printf.printf "> ";
    Value.of_string @@ Bytes.of_string @@ read_line ()

let strmake args env =
    let nv, cv = MatchList.match_with_two args                in
    let n,  c  = Value.to_int nv, Char.chr @@ Value.to_int cv in
    Value.of_string (Bytes.make n c)

let strset args env =
    let sv, iv, cv = MatchList.match_with_three args                                  in
    let s,  i,  c  = Value.to_string sv, Value.to_int iv, Char.chr @@ Value.to_int cv in
    Bytes.set s i c; Value.of_string s

let strget args env =
    let sv, iv = MatchList.match_with_two args       in
    let s,  i  = Value.to_string sv, Value.to_int iv in
    Value.of_int @@ Char.code (Bytes.get s i)

let strdup args env =
    let sv = MatchList.match_with_one args in
    let s  = Value.to_string sv            in
    Value.of_string @@ Bytes.init (Bytes.length s) (fun i -> Bytes.get s i)

let strcat args env =
    let sv1, sv2 = MatchList.match_with_two args            in
    let s1,  s2  = Value.to_string sv1, Value.to_string sv2 in
    Value.of_string @@ Bytes.cat s1 s2

let strcmp args env =
    let sv1, sv2 = MatchList.match_with_two args            in
    let s1,  s2  = Value.to_string sv1, Value.to_string sv2 in
    Value.of_int @@ Bytes.compare s1 s2

let strlen args env =
    let sv = MatchList.match_with_one args in
    let s  = Value.to_string sv            in
    Value.of_int @@ Bytes.length s

let strsub args env =
    let sv, iv, lv = MatchList.match_with_three args                      in
    let s,  i,  l  = Value.to_string sv, Value.to_int iv, Value.to_int lv in
    Value.of_string (Bytes.sub s i l)


let list : (string * (Value.t list -> Env.t -> Value.t)) list =
    ["read"     , read     ;
     "write"    , write    ;
     "str_read" , str_read ;
     "str_write", str_write;
     "strmake"  , strmake  ;
     "strset"   , strset   ;
     "strget"   , strget   ;
     "strdup"   , strdup   ;
     "strcat"   , strcat   ;
     "strcmp"   , strcmp   ;
     "strlen"   , strlen   ;
     "strsub"   , strsub   ]
