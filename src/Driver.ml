open Ostap

let parse infile =
    let s = Util.read infile in
    Util.parse
        (object
            inherit Matcher.t s
            inherit Util.Lexers.ident ["skip" ; "if"   ; "then"  ; "elif"; "else"  ; 
                                       "fi"   ; "while"; "do"    ; "od"  ; "repeat"; 
                                       "until"; "for"  ; "return"; "fun" ; "begin" ; 
                                       "end"  ; "case" ; "of"    ; "esac"; "throw" ;
                                       "try"  ; "with" ; "yrt"                     ] s
            inherit Util.Lexers.decimal s
            inherit Util.Lexers.string  s
            inherit Util.Lexers.char    s
            inherit Util.Lexers.skip [
                Matcher.Skip.whitespaces " \t\n";
                Matcher.Skip.lineComment "--";
                Matcher.Skip. nestedComment "(*" "*)"
            ] s
        end)
        (ostap (!(Language.Prog.parse) -EOF))

exception InvalidFlag

let main = ()
    try
        let mode, filename =
            match Sys.argv.(1) with
            | "-i" -> `Int, Sys.argv.(2)
            | "-s" -> `SM,  Sys.argv.(2)
            | "-o" -> `X86, Sys.argv.(2)
            | _ -> raise InvalidFlag
        in
        match parse filename with
        | `Ok prog ->
            (   
                let prog = SyntaxSugar.unsugar prog in
                match mode with
                | `X86 ->
                    let basename = Filename.chop_suffix filename ".expr" in
                    X86.build prog basename
                | `SM  -> StackMachine.Interpreter.run (StackMachine.Compile.prog prog)
                | `Int -> Interpreter.Prog.interpret prog
            )
        | `Fail er -> Printf.eprintf "%s" er
    with
    | InvalidFlag ->
        Printf.printf "Usage: rc.byte <command> <name.expr>\n";
        Printf.printf "  <command> should be one of: -i, -s, -o\n"
