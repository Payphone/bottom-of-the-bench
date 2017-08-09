(de hashString (Str)
   (blake2b_hex (mapcar char (chop Str))) )

(de numStr? (C)
   (<= "0" C "9") )
