;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname tag2-schleifen) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Liste umdrehen
(: rev ((list-of %a) -> (list-of %a)))

(check-expect (rev (list 1 2 3 4))
              (list 4 3 2 1))

(define rev
  (lambda (list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       (append
        (rev ; 4 3 2
         (rest list)) ; 2 3 4
        (cons (first list) empty) ; 1
       )))))

; Eine natürliche Zahl ist eins der folgenden:
; - 0
; - der Nachfolger einer natürlichen Zahl ("+1")

(: repeat (natural %element -> (list-of %element)))

(check-expect (repeat 10 "foo")
              (list "foo" "foo" "foo" "foo" "foo"
                     "foo" "foo" "foo" "foo" "foo"))

(define repeat
  (lambda (n element)
    (cond
      ((zero? n) empty)
      ((positive? n)
       (cons element (repeat (- n 1) element))))))