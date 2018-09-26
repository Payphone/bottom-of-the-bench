#### classes.l

### CLASSES ###

## BOX ##

(class +Box +Entity)
(rel number (+Need +Key +Number))
(rel name (+Sn +Idx +String))
(rel comment (+Sn +Idx +String))
(rel date (+Ref +Date))
(rel time (+Ref +Time))
(rel pass (+Ref +String))
(rel salt (+Ref +String))


## (de deleteButton (@Box)
##    (let (@password (cadr (assoc (get @Box 'number) *Cookies)))
##       (when @password
##          (action
##             (form NIL
##                (gui '(+Style +Button +Tiny) "delete" "[Delete]"
##                   (fill
##                      '(and
##                          (= @password
##                             (hashString (pack (get '@Box 'salt) (get '@Box 'pass))) )
##                          (lose!> '@Box) ) ) ) ) ) ) ) )


## REPLY ##

(class +Reply +Box)
(rel thread (+Joint) replies (+Thread))

(dm display> ()
   (<div> "reply"
      (<div> "post"
         (<div> "head"
            (<span> "name" (prin (: name)))
            (<span> "date" (prin (dat$ (: date) "-")))
            (<span> "replyNumber" (prin "No. " (: number))))
         (<p> "comment" (prin (: comment) ) )
         (if (: replies)
            (<div> "replies"
               (<small> NIL "Replies ")
               (for R (: replies)
                  (<href> (pack ">>" (get R 'number))
                     (pack "!reply?+" (get R 'number)) ) ) ) ) ) )
   (--) )

## THREAD ##

(class +Thread +Box)
(rel subject (+Sn +Idx +String))
(rel board (+Sn +Idx +String))
(rel replies (+List +Joint) thread (+Reply))

(dm display> ()
   (<div> "thread"
      (<div> "post"
         (<div> "head"
            (<span> "subject"
               (<href> (: subject) (pack "!thread?+" (: number))) )
            (<span> "name" (prin (: name)))
            (<span> "date" (prin (dat$ (: date) "-")))
            (<span> "threadNumber" (prin "No. " (: number))))
         (<p> "comment" (prin (: comment)))
         (<div> "row"
            (<small> NIL (prin (length (: replies))) " Replies ") ) ) )
   (--) )

(dm displayPreview> ()
   (<div> "thread"
      (<div> "post"
         (<div> "head"
            (<span> "subject"
               (<href> (: subject) (pack "!thread?+" (: number))) )
            (<span> "name" (prin (: name)))
            (<span> "date" (prin (dat$ (: date) "-")))
            (<span> "number"
               (<href> (pack "No. " (: number))
                  (pack "/!thread?+" (: number)) ) ))
         (<p> "comment" (prin (: comment)))
         (<div> "row"
            (<small> NIL (prin (length (: replies))) " Replies "
               (<href> "[View Thread]" (pack "!thread?+" (: number))) ) ) ) )
      (<div> "replies"
         (for R (reverse (head 3 (: replies)))
            (display> R) ) ) )

(dm displayCatalog> ()
   (<div> "thread"
      (<div> "post"
         (<div> "row head"
            (<span> "subject"
               (<href> (: subject) (pack "!thread?+" (: number))) )
            (<span> "name" (prin (: name)))
            (<span> "date" (prin (dat$ (: date) "-")))
            (<span> "number"
               (<href> (pack "No. " (: number))
                  (pack "!thread?+" (: number)) ) ) )
         (<p> "comment" (prin (: comment)))
         (<div> "row"
            (<small> NIL (prin (length (: replies))) " Replies "
               (<href> "[View Thread]" (pack "!thread?+" (: number))) ) ) ) ) )

(dm lastUpdate> ()
   (with (car (: replies))
      (list (: date) (: time))) )

## TIMESTAMP ##

(class +Timestmap)
(rel date (+Ref +Date))
(rel time (+Ref +Time))

(dm compare> )
