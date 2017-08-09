(load "@lib/http.l" "@lib/xhtml.l" "@lib/form.l" "@lib/adm.l" "blake2.l" "lib.l" "board.l")
(setq *Salt (16 . "$6$@1$"))
(setq *Blob "blob/")
### PAGES ###

(de index-page ()
   (html 0 "Bottom of the Bench" "milligram.css" NIL
      (<div> "container"
         (<div> "row center"
            (<h1> "column" "Bottom of the Bench") )
         (<hr>)
         (<div> "row center"
            (<div> "column"
               (<h3> NIL "Boards")
               (<ul> NIL
                  (for B *Boards
                     (<li> NIL (<href> B (pack "!board?" B))) ) ) )
            (<div> "column"
               (<h3> NIL "Announcements")
               (<p> NIL "Deader than ever.") ) ) ) ) )

#(allowed NIL "!index-page" "board" "!board" "!thread" "thread" "milligram.css"
#   "milligram.css.map" "!newThread" "@lib/form.js" "*Get" "*Form" "*Evt" "*Gui" "*Menu"
#   "*Tab" "*ID" "*Got" "!jsForm")

### RUN ###

(de main ()
   (pool "threads" *Dbs) )

(de go ()
   (rollback)
   (server (or (format (sys "PORT")) 8080) "!index-page"))
