open Ostap
open Matcher
open Expr

let list_of_option_list = function
  | None    -> []
  | Some xs -> xs
    
ostap (
    expr: ori;

    ori:
      l:andi    suf:("||" r:andi)*
                    { List.fold_left (fun l (op, r) -> BinOp ("||", l, r)) l suf };
    
    andi:
      l:boolean suf:("&&" r:boolean)*
                    { List.fold_left (fun l (op, r) -> BinOp ("&&", l, r)) l suf };
    
    boolean:
      l:addi op:("=="|"!="|"<="|"<"|">="|">") r:addi { let (s, _) = op in BinOp (s, l, r) }
    | "true"                                         { Const 1 }
    | "false"                                        { Const 0 }
    |  addi;
    
    addi:
      l:multi suf:(op:("+"|"-") r:multi)*
                    { List.fold_left (fun l ((op, _), r) -> BinOp (op, l, r)) l suf };
    
    multi:
      l:primary suf:(op:("*"|"/"|"%") r:primary)*
                    { List.fold_left (fun l ((op, _), r) -> BinOp (op, l, r)) l suf };
      
    primary:
      c:DECIMAL                          { Const c                           }
    | p:fcall                            { let (n, a) = p in EFunCall (n, a) }
    | x:IDENT                            { Var   x                           }
    | -"(" expr -")";

    fcall:
      fname:IDENT "(" args:expr_seq? ")" { (fname, list_of_option_list args) };

    expr_seq: pref:(expr -",")* r:expr   { pref @ [r] } 
)

ostap (
    stmt:
      s1:simple ";" s2:stmt                                     { Seq    (s1, s2)                                }
    | simple;

    simple:
      %"read"  "(" name:IDENT ")"                               { Read    name                                   }
    | %"write" "(" e:expr     ")"                               { Write   e                                      }
    | %"skip"                                                   { Skip                                           }
    | x:IDENT ":=" e:expr                                       { Assign (x , e)                                 }
    | %"if" "(" e:expr ")" "{" s:stmt "}"                       { If     (e , s)                                 }
    | %"while" "(" e:expr ")" "{" s:stmt "}"                    { While  (e , s)                                 }
    | p:fcall                                                   { let (n, a) = p in SFunCall (n, a)              }
    | %"def" fname:IDENT "(" args:id_seq? ")" "{" body:stmt "}" { FunDef (fname, list_of_option_list args, body) }
    | %"return" e:expr                                          { Ret e                                          }
    | %"return"                                                 { RetNone                                        };

    id_seq: pref:(IDENT -",")* r:IDENT                          { pref @ [r]                                     }
)

let parse infile =
  let s = Util.read infile in
  Util.parse
    (object
       inherit Matcher.t s
       inherit Util.Lexers.ident ["read"; "write"; "skip"; "true"; "false"; "if"; "while"; "def"; "return"] s
       inherit Util.Lexers.decimal s
       inherit Util.Lexers.skip [
	 Matcher.Skip.whitespaces " \t\n";
	 Matcher.Skip.lineComment "--";
	 Matcher.Skip. nestedComment "(*" "*)"
       ] s
     end
    )
    (ostap (stmt -EOF))
