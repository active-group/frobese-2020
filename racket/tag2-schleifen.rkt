;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname tag2-schleifen) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Liste umdrehen
(: rev ((list-of %a) -> (list-of %a)))

(check-expect (rev (list 1 2 3 4))
              (list 4 3 2 1))

#;(define rev
  (lambda (list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       (my-append
        (rev ; 4 3 2
         (rest list)) ; 2 3 4
        (cons (first list) empty) ; 1
       )))))


(define rev
  (lambda (list0)
    ; Schleifeninvariante:
    ; Beziehung zwischen list0, list, result
    ; result enthält die gesehenen Elemente aus list0 vor list in umgekehrter Reihenfolge
    (define loop
      (lambda (list result)
        (cond
          ((empty? list) result)
          ((cons? list)
           ; Aufruf von rev* hat keinen Kontext => iterativer Berechnungsprozeß
           ; tail call
           ; "proper tail calls": tail calls verbrauchen keinen Speicher auf dem "Stack"
           ; endrekursiver Aufruf
           (loop (rest list)
                 (cons (first list) result))))))
    
    (loop list0 empty)))

(define rev*
  (lambda (list result)
    (cond
      ((empty? list) result)
      ((cons? list)
       ; Aufruf von rev* hat keinen Kontext => iterativer Berechnungsprozeß
       ; tail call
       ; "proper tail calls": tail calls verbrauchen keinen Speicher auf dem "Stack"
       ; endrekursiver Aufruf
       (rev* (rest list) (cons (first list) result))))))

; 4 + 3 + 2 + 1
; 1 + 2 + 3 + ...+ (n - 1) + n
; (n * (n - 1)) / 2

(check-expect (my-append (list 1 2 3) (list 4 5 6))
              (list 1 2 3 4 5 6))

#;(define my-append
  (lambda (list1 list2)
    (cond
      ((empty? list1) list2)
      ((cons? list1)
       (cons (first list1) ; Kontext
             (my-append (rest list1) list2))))))

(check-property
 (for-all ((a (list-of natural))
           (b (list-of natural))
           (c (list-of natural)))
   (expect (my-append (my-append a b) c)
           (my-append a (my-append b c)))))

(define my-append
  (lambda (list1-init list2)

    (define loop
      ; result enthält vorn an list2 drangehängt
      ; die gesehenen Elemente von list1-init vor list1
      (lambda (list1 result)
        (cond
          ((empty? list1) result)
          ((cons? list1)
           (loop (rest list1)
                 (cons (first list1) result))))))

    (loop (rev list1-init) list2)))



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


; (Lineare) Algebra
; Gruppen
; Eine Gruppe ist eine Menge M mit zwei Operationen
; (: o (M M -> M))
; (: inv (M -> M))
; und einem neutralen Element n
; (o m (inv m)) = n

; Halbgruppe
; Assoziativgesetz:
; (o (o a b) c) = (o a (o b c))

; Halbgruppe + neutrales Element: Monoid

; neutrales Element n bezüglich der Addition der reellen Zahlen:
; x + n = n + x = x
; (a + b) + c = a + (b + c)
; neutrales Element n bezüglich der Multiplikation der reellen Zahlen:
; x * n = n * x = x


(check-property
 (for-all ((x natural))
   (and (= (+ x 0) x)
        (= (+ 0 x) x))))


(check-property
 (for-all ((a rational)
           (b rational)
           (c rational))
   (= (+ (+ a b) c)
      (+ a (+ b c)))))

(define a #i-4.0)
(define b #i0.6666666666666666)
(define c #i0.6666666666666667)

(+ (+ a b) c)
(+ a (+ b c))