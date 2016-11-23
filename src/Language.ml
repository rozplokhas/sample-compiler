open Ostap 
open Matcher

module Expr = struct

    type t =
    | Const   of Value.t
    | Var     of string
    | Binop   of string * t * t
    | Funcall of string * t list

    ostap (
        parse:
            !(Ostap.Util.expr
                (fun x -> x)
                (Array.map (fun (a, s) -> a,
                                List.map  (fun s -> ostap(- $(s)), (fun x y -> Binop (s, x, y))) s)
                           [|
                                `Lefta, ["!!"];
                                `Lefta, ["&&"];
                                `Nona , ["=="; "!="; "<="; "<"; ">="; ">"];
                                `Lefta, ["+" ; "-"];
                                `Lefta, ["*" ; "/"; "%"];
                           |]
                )
                primary);

        primary:
          n:DECIMAL  { Const (Value.of_int n)                                         }
        | s:STRING   { Const (Value.of_string (String.sub s 1 (String.length s - 2))) }
        | ch:CHAR    { Const (Value.of_int @@ Char.code ch)                           }
        | "true"     { Const (Value.of_int 1)                                         }
        | "false"    { Const (Value.of_int 0)                                         }
        | i:IDENT args:(-"(" !(Util.list0 parse) -")")?
            {
                match args with
                | None      -> Var i
                | Some args -> Funcall (i, args)
            }
        | -"(" parse -")"
    )

end


module Stmt = struct

    type t =
    | Skip
    | Assign  of string * Expr.t
    | Seq     of t * t
    | If      of Expr.t * t * t
    | While   of Expr.t * t
    | Repeat  of t * Expr.t
    | Funcall of string * Expr.t list
    | Return  of Expr.t

    ostap (
        parse: s:simple d:(-";" parse)? { match d with None -> s | Some d -> Seq (s, d) };

        simple:
              x:IDENT s:(":=" e:!(Expr.parse)                           { Assign  (x, e)    }
                        | args:(-"(" !(Util.list0 Expr.parse) -")")     { Funcall (x, args) }
                        )                                           { s                                   }
            | %"skip"                                               { Skip                                }
            |      %"if" e:!(Expr.parse) %"then" s:parse
              els:(%"elif" !(Expr.parse) %"then"   parse)*
               el:(%"else"                         parse)?
                   %"fi"
                {
                    List.fold_right (fun (e, s) acc -> If (e, s, acc))
                                    ((e, s)::els)
                                    (match el with None -> Skip | Some d -> d)
                }
            | %"while" e:!(Expr.parse) %"do" s:parse %"od"          { While  (e,  s)                      }
            | %"repeat" s:parse %"until" e:!(Expr.parse)            { Repeat (s,  e)                      }
            | %"for" s1:parse "," e:!(Expr.parse) "," s2:parse
              %"do" s:parse %"od"                                   { Seq    (s1, While (e, Seq (s, s2))) }
            | %"return" e:!(Expr.parse)                             { Return e                            }
    )

end

module Prog = struct

    type fundef = string * string list * Stmt.t
  
    type t = fundef list * Stmt.t

    ostap (
        parse: def* !(Stmt.parse);

        def: %"fun" IDENT -"(" !(Util.list0 arg) -")" %"begin" !(Stmt.parse) %"end";

        arg  : IDENT
    )

end
