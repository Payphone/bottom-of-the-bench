### CLASSES ###

(class +Box +Entity)
(rel number (+Need +Key +Number))
(rel name (+Sn +Idx +String))
(rel comment (+Sn +Idx +String))
(rel date (+Ref +Date))
(rel time (+Ref +Time))
(rel pass (+Ref +String))
(rel salt (+Ref +String))


(de deleteButton (@Box)
#   (let (@password (cadr (assoc (get @Box 'number) *Cookies)))
#      (when @password
#         (action
#            (form NIL
#               (gui '(+Style +Button +Tiny) "delete" "[Delete]"
#                  (fill
#                     '(and
#                         (= @password
#                            (hashString (pack (get '@Box 'salt) (get '@Box 'pass))) )
   #                         (lose!> '@Box) ) ) ) ) ) ) ) )
   )

## REPLY ##
(class +Reply +Box)
(rel thread (+Joint) replies (+Thread))
(rel replies (+List +Joint) inquiries (+Reply))
(rel inquiries (+List +Joint) replies (+Reply))

(dm display> ()
   (<div> "reply"
      (<div> "container"
         (<div> "head"
            (<span> "name" (prin (: name)))
            (<span> "date" (prin (dat$ (: date) "-")))
            (<span> "replyNumber" (prin "No. " (: number)))
            (deleteButton This) )
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
(rel replies (+List +Joint) thread (+Reply))
(rel subject (+Sn +Idx +String))
(rel board (+Sn +Idx +String))

(dm display> ()
   (<div> "thread"
      (<div> "container"
         (<div> "head"
            (<span> "subject"
               (<href> (: subject) (pack "!thread?+" (: number))) )
            (<span> "name" (prin (: name)))
            (<span> "date" (prin (dat$ (: date) "-")))
            (<span> "threadNumber" (prin "No. " (: number)))
            (deleteButton This) )
         (<span> "comment" (prin (: comment)))  ) )
   (--) )

(dm displayPreview> ()
   (<div> "thread"
      (<div> "container"
         (<div> "head"
            (<span> "subject"
               (<href> (: subject) (pack "!thread?+" (: number))) )
            (<span> "name" (prin (: name)))
            (<span> "date" (prin (dat$ (: date) "-")))
            (<span> "number"
               (<href> (pack "No. " (: number))
                  (pack "/!thread?+" (: number)) ) )
            (deleteButton This) )
         (<p> "comment" (prin (: comment)))
         (<div> "row"
            (<small> NIL (prin (length (: replies))) " Replies "
               (<href> "[View Thread]" (pack "!thread?+" (: number))) ) ) ) )
      (<div> "replies"
         (for R (reverse (head 5 (: replies)))
            (display> R) ) ) )

(dm displayCatalog> ()
   (<div> "thread float-left"
      (<div> "container"
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
