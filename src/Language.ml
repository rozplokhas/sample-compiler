open Ostap 
open Matcher

module Expr =
  struct

    type t =
    | Const of int
    | Var   of string
    | Binop of string * t * t

    ostap (
      parse:
          l:andi suf:("!!" andi)* {
          List.fold_left (fun l (op, r) -> Binop ("!!", l, r)) l suf
        }
      | andi;

      andi:
          l:compi suf:("&&" compi)* {
          List.fold_left (fun l (op, r) -> Binop ("&&", l, r)) l suf
        }
      | compi;
      
      compi:
        l:addi suf:(("<=" | "<" | "==" | "!=" | ">=" | ">") addi)* {
           List.fold_left (fun l (op, r) -> Binop (Token.repr op, l, r)) l suf
        }
      | addi;

      addi:
        l:mulli suf:(("+" | "-") mulli)* {
          List.fold_left (fun l (op, r) -> Binop (Token.repr op, l, r)) l suf
        }
      | mulli;

      mulli:
        l:primary suf:(("*" | "/" | "%") primary)* {
           List.fold_left (fun l (op, r) -> Binop (Token.repr op, l, r)) l suf
        }
      | primary;

      primary:
        n:DECIMAL {Const n}
      | x:IDENT   {Var   x}
      | -"(" parse -")"
    )

  end

module Stmt =
  struct

    type t =
    | Skip
    | Read   of string
    | Write  of Expr.t
    | Assign of string * Expr.t
    | Seq    of t * t
    | If     of Expr.t * t * t
    | While  of Expr.t * t 

    ostap (
      parse: s:simple d:(-";" parse)? {
	match d with None -> s | Some d -> Seq (s, d)
      };
      
      simple:
        x:IDENT ":=" e:!(Expr.parse)                                  {Assign (x, e)}
      | %"read"  "(" x:IDENT ")"                                      {Read x}
      | %"write" "(" e:!(Expr.parse) ")"                              {Write e}
      | %"skip"                                                       {Skip}
      |        %"if"  e:!(Expr.parse)   %"then" s:parse
        els:(-(%"elif") !(Expr.parse) -(%"then")  parse)*
         el:(-(%"else")                           parse)?
               %"fi"
                            {List.fold_right (fun (e, s) acc -> If (e, s, acc))
                                             ((e, s)::els)
                                             (match el with None -> Skip | Some d -> d)                
                            }
      | %"while" e:!(Expr.parse) %"do" s:parse %"od"                  {While (e, s)}
      | %"repeat" s:parse %"until" e:!(Expr.parse)                    {Seq   (s, While (Binop ("==", e, Const 0), s))}
      | %"for" s1:parse "," e:!(Expr.parse) "," s2:parse
              %"do" s:parse %"od"                                     {Seq   (s1, While (e, Seq (s, s2)))}
    )

  end
