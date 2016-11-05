module StringMap = Map.Make (String)

type t = int StringMap.t * (int list -> t -> int * t) StringMap.t * int list * int list

let with_input inp                            = (StringMap.empty, StringMap.empty, inp, [])
let local               (_,  fm, inp,   outp) = (StringMap.empty, fm, inp, outp)
let add_var    x   v    (vm, fm, inp,   outp) = (StringMap.add x v vm, fm, inp, outp)
let add_fun    x   f    (vm, fm, inp,   outp) = (vm, StringMap.add x f fm, inp, outp)
let find_var   x        (vm, _,  inp,   outp) = StringMap.find x vm
let find_fun   x        (_ , fm, inp,   outp) = StringMap.find x fm
let read_int            (vm, fm, inp,   outp) = match inp with
                                                | i::is -> i, (vm, fm, is, outp)
                                                | []    -> failwith "Error in 'read_int': input is empty"
let write_int  i        (vm, fm, inp,   outp) = (vm, fm, inp, i::outp)
let get_input           (_,  _,  inp,   _   ) = inp
let get_output          (_,  _,  _,     outp) = outp
let update_io  inp outp (vm, fm, _,     _   ) = (vm, fm, inp, outp)
