(de hashString (Str)
   (blake2b_hex (mapcar char (chop Str))) )

(de numStr? (C)
   (<= "0" C "9") )

### HTML ###

(de <center> (Attr . Prg)
   (tag 'center Attr 2 Prg)
   (prinl) )
