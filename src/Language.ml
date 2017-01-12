open Ostap 
open Matcher

let var_name_prefix = "var_"

module Expr = struct

    type t =
    | Const      of int
    | StrConst   of string
    | Array      of bool * t list
    | Object     of string * t list
    | Var        of string
    | Binop      of string * t * t
    | Funcall    of string * t list
    | GetElement of t * t

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
          n:DECIMAL                                      { Const n                                         }
        | s:STRING                                       { StrConst (String.sub s 1 (String.length s - 2)) }
        | ch:CHAR                                        { Const (Char.code ch)                            }
        | "true"                                         { Const 1                                         }
        | "false"                                        { Const 0                                         }
        | "[" es:!(Util.list0 parse) "]"                 { Array  (false, es)                              }
        | "{" es:!(Util.list0 parse) "}"                 { Array  (true,  es)                              }
        | "`" cons:IDENT "(" es:!(Util.list0 parse) ")"  { Object (cons,  es)                              }
        | i:IDENT args:(-"(" !(Util.list0 parse) -")")? indices:(-"[" parse -"]")*
            {
                List.fold_left  (fun e i -> GetElement (e, i))
                                (
                                    match args with
                                    | None      -> Var (var_name_prefix ^ i)
                                    | Some args -> Funcall (i, args)
                                )
                                indices
            }
        | -"(" parse -")"
    )

end


module Stmt = struct

    type t =
    | Skip
    | Assign     of string * Expr.t
    | SetElement of string * Expr.t list * Expr.t
    | Seq        of t * t
    | If         of Expr.t * t * t
    | While      of Expr.t * t
    | Repeat     of t * Expr.t
    | Funcall    of string * Expr.t list
    | Return     of Expr.t
    | Throw      of Expr.t
    | TryCatch   of t * string * t
    | Case       of Expr.t * (string * string list * t) list * t option
    | TryWith    of t * (string * string list * t) list * t option 

    ostap (
        parse: s:simple d:(-";" parse)? { match d with None -> s | Some d -> Seq (s, d) };

        simple:
              x:IDENT res:(  indices:(-"[" !(Expr.parse) -"]")* ":=" e:!(Expr.parse)
                                {
                                    match indices with 
                                    | [] -> Assign (var_name_prefix ^ x, e) 
                                    | _  -> SetElement (var_name_prefix ^ x, indices, e)
                                }
                          | "(" args:!(Util.list0 Expr.parse) ")"
                                { Funcall (x, args) }
                          )                                         
                { res }
            | %"skip"                                                                                    { Skip                                }
            |      %"if" e:!(Expr.parse) %"then" s:parse
              els:(%"elif" !(Expr.parse) %"then"   parse)*
               el:(%"else"                         parse)?
                   %"fi"
                {
                    List.fold_right (fun (e, s) acc -> If (e, s, acc))
                                    ((e, s)::els)
                                    (match el with None -> Skip | Some d -> d)
                }
            | %"while" e:!(Expr.parse) %"do" s:parse %"od"                                               { While  (e,  s)                      }
            | %"repeat" s:parse %"until" e:!(Expr.parse)                                                 { Repeat (s,  e)                      }
            | %"for" s1:parse "," e:!(Expr.parse) "," s2:parse
              %"do" s:parse %"od"                                                                        { Seq    (s1, While (e, Seq (s, s2))) }
            | %"return" e:!(Expr.parse)                                                                  { Return e                            }
            | %"throw"  e:!(Expr.parse)                                                                  { Throw e                             }
            | %"case" temp:!(Expr.parse) %"of" vs:(-"|" pattern)* wild:(-"|" -"_" -"->" parse)? %"esac"  { Case (temp, vs, wild)               }
            | %"try" code:parse %"with" vs:(-"|" pattern)* wild:(-"|" -"_" -"->" parse)? %"yrt"          { TryWith (code, vs, wild)            };

        pattern: -"`" IDENT -"(" !(Util.list0 var) -")" -"->" parse;

        var : IDENT
    )

end

module Prog = struct

    type fundef = string * string list * Stmt.t
  
    type t = fundef list * Stmt.t

    ostap (
        parse: def* !(Stmt.parse);

        def: %"fun" name:IDENT "(" args:!(Util.list0 arg) ")" %"begin" body:!(Stmt.parse) %"end"
            { name, List.map (fun a -> var_name_prefix ^ a) args, body };

        arg  : IDENT
    )

end
