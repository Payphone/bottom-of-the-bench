(load "classes.l")

(default *Boards '("prog" "off" "meta"))

# The only HTML control characters that really matter are '<' and '&'
(de sanitizeInput (Str)
   (pack (replace (replace (chop Str) "<" "&lt;") "&" "&amp;")) )

(de occurences (Str Search)
   (let (Count 0 Str (chop Str) Search (chop Search))
      (while Str
         (if (fully '((C) (= C (pop 'Str))) Search)
            (inc 'Count) ) )
      Count ) )

#(de replaceCodeTags (Str)
#   (let Str (chop Str)
#      (make
#         (let Char (pop 'Str)
#            (unless (or (= C))(pop Str)) ) ) ))

(de linkInquiries (Str Lst)
   (if (car Lst)
      (with @
         (linkInquiries
            (replaceString
               Str
               (pack ">>" (: number))
               (pipe
                  (prin
                     (<href> (pack ">>" (: number))
                        (pack "!reply?+" (: number)) ) )
                  (till NIL T) ) )
            (cdr Lst) ) )
      Str ) )

(de navBar ()
   (<div> "navigation"
      (<href> "Home" "")
      (for B *Boards
         (prin " / ")
         (<href> B (pack "!board?" B)) )
      (prin " / ") )
   (--) )

(de list-banners (Directory)
   (let files NIL
      (in (list 'ls Directory)
         (until (eof)
            (let file (line)
               (if (= (tail 4 file) `'(chop ".png"))
                  (push 'files file) ) ) ) )
      files ) )

(de random-banner ()
   (let banners (list-banners "banners")
      (pack (car (nth banners (rand 1 (length banners))))) ) )

(de boardHeader (Board)
   (<div> "center"
      (<img> (pack "banners/" (random-banner)) NIL NIL 300 100) )
   (<div> "row center"
      (<h3> "column"
         (<href> "New Thread" (pack "!newThread?" Board)) )
      (<h1> "column boardName"
         (prin Board) )
      (<h3> "column"
         (<href> "Catalog" (pack "!catalog?" Board)) ) )
   (<hr>) )

(de board (Board)
   (html 0 "Bottom of the Bench" "milligram.css" NIL
      (navBar)
      (<div> "container"
         (boardHeader Board)
         (<div> "threads"
            (for Tr (collect 'board '+Thread Board)
               (displayPreview> Tr)
               (<hr>) ) ) ) ) )

(de catalog (Board)
   (html 0 "Bottom of the Bench" "milligram.css" NIL
      (navBar)
      (<div> "container"
         (boardHeader Board)
         (<div> "threads"
            (for Tr (collect 'board '+Thread Board)
               (displayCatalog> Tr) ) ) ) ) )

(de thread (ThreadNumber)
   # Oddly enough using 'db' instead of 'collect' here results in replies being
   # treated as threads.
   (ifn (car (collect 'number '+Thread ThreadNumber))
      (http404)
      (with @
         (app)
         (action
            (html 0 (: subject) "milligram.css" NIL
               (navBar)
               (<div> "container"
                  (boardHeader (: board))
                  (display> This)
                  (for R (reverse (: replies))
                     (display> R) )
                  (<hr>)
                  (replyForm ThreadNumber) ) ) ) ) ) )

(de replyForm (@ThreadNumber)
   (form NIL
      (gui 'name '(+Init +TextField) "Anonymous" 10 "Name")
      (gui 'comment '(+TextField) 15 1 "Comment")
      (gui 'pass '(+Init +TextField) (randpw 12) 10 "Password" )
      (gui '(+Button) "submit"
         (fill
            '(let (postNumber (genKey 'number '+Box))
                (and
                   (new! '(+Reply)
                      'number postNumber
                      'thread (db 'number '+Box @ThreadNumber)
                      'name (val> (: home name))
                      'comment (sanitizeInput (val> (: home comment)))
                      'date (date)
                      'time (time)
                      'pass (hashString (val> (: home pass)))
                      'salt (salt) )
                   (cookie postNumber (hashString (val> (: home pass))) )
                   (url (pack "!thread?+" @ThreadNumber)) ) ) ) ) ) )

(de reply (Number)
   (ifn (car (collect 'number '+Reply Number))
      (http404)
      (with @
         (html 0 (pack "Reply #" (: number)) "milligram.css" NIL
            (boardHeader (get (: thread) 'board))
            (display> This) ) ) ) )

# Looking for references in the format '>>[POST NUMBER]'
# Even though we're only returning the number, its existence must be verified by
# running it through collect.
(de findInquiries (Text)
   (make
      (pipe
         (prin Text)
         (until (not (from ">>"))
            (chain
               (collect 'number '+Reply
                  (car
                     (str
                        (pack
                           (filter numStr? (till '(" " "^J" ">"))) ]

(de newThread (Board)
   (app)
   (action
      (html 0 "New Thread" "milligram.css" NIL
         (navBar)
         (<div> "container"
            (<h1> NIL "New Thread")
            (form NIL
               (gui 'name '(+Init +TextField) "Anonymous" 10 "Name" )
               (gui 'subject '(+TextField) 10 "Subject")
               (gui 'comment '(+TextField) 10 20 "Comment")
               (<br>)
               (gui 'board '(+Init +TextField) Board *Boards "Board")
               (gui 'pass '(+Init +TextField) (randpw 12) 10
                  "Password" )
               (gui '(+Button) "Submit"
                  '(ifn (fully '((@F)  (val> (macro (: home @F))))
                           '(name subject comment board) )
                      (alert NIL
                         (<div> "notify error" "All fields must be filled out.") )
                      (let (postNumber (genKey 'number '+Box))
                         (prog
                            (cookie postNumber (hashString (val> (: home pass))))
                            (new! '(+Thread)
                               'number postNumber
                               'board (val> (: home board))
                               'name (val> (: home name))
                               'subject (val> (: home subject))
                               'comment (sanitizeInput
                                           (val> (: home comment)) ) 
                               'date (date)
                               'time (time)
                               'pass (hashString (val> (: home pass)))
                               'salt (salt) )
                            (url (pack "!thread?+" postNumber)) ) ) ) ) ) ) ) ) )
