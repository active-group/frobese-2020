;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "vanilla-reader.rkt" "deinprogramm" "sdp")((modname tag2) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Ein Gürteltier hat folgende Eigenschaften
; - lebendig oder tot
; - Gewicht in g

(define-record-functions dillo
  make-dillo
  dillo?
  (dillo-alive? boolean)
  (dillo-weight natural))

(: make-dillo (boolean natural -> dillo))
(: dillo-alive? (dillo -> boolean))
(: dillo-weight (dillo -> natural))

(: dillo? (any -> boolean))


(define dillo1 (make-dillo #t 20000)) ; Gürteltier, lebendig, 20 kg
(define dillo2 (make-dillo #f 15000)) ; Gürteltier, tot, 15 kg

; Überfahre ein Gürteltier!
(: run-over-dillo (dillo -> dillo))
(check-expect (run-over-dillo dillo1)
              (make-dillo #f 20000))
(check-expect (run-over-dillo dillo2)
              dillo2)

#;(define run-over-dillo
  (lambda (dillo)
    (if (dillo-alive? dillo)
        (make-dillo #f (dillo-weight))
        dillo)))

(define run-over-dillo
  (lambda (dillo)
    (make-dillo #f (dillo-weight dillo))))

;;; ÜBUNG Weiteres Tier: Gewicht und Funktion die es überfährt

; Ein Papagei hat folgende Eigenschaften
; - Gewicht in Gramm
; - Einen Satz, den er sagt

(define-record-functions parrot
  make-parrot
  parrot?
  (parrot-weight natural)
  (parrot-sentence string))

(define parrot1
  (make-parrot 2000 "Mein Schatz!!"))  ; Piratenpapagei, 2 kg

(define parrot2
  (make-parrot 4000 "Ich grüße Sie!")) ; höflicher Papagei, 4 kg

; Überfahre einen Papagei
(: run-over-parrot (parrot -> parrot))
(check-expect (run-over-parrot parrot1)
              (make-parrot 2000 ""))
(check-expect (run-over-parrot parrot2)
              (make-parrot 4000 ""))

(define run-over-parrot
  (lambda (parrot)
    (make-parrot (parrot-weight parrot) "")))

;;; nicht getestet!!!
(define parrot-alive?
  (lambda (parrot)
    (not (string=? "" (parrot-sentence parrot)))))


;;; GEMISCHTEN DATEN
; Wir wollen Tiere überfahren!

; Ein Tier ist eins der folgenden
; - Gürteltier
; - Papagei
; "Ist eins der folgenden" -> gemischte Daten

(define animal
  (signature (mixed dillo parrot)))

; Wir wollen Tiere überfahren!
; Überfährt ein Tier
(: run-over-animal (animal -> animal))
(check-expect (run-over-animal dillo1)
              (make-dillo #f 20000))
(check-expect (run-over-animal parrot1)
              (make-parrot 2000 ""))
(check-expect (run-over-animal dillo1)
              (run-over-dillo dillo1))

(define run-over-animal
  (lambda (animal)
    (cond
      ((dillo? animal) (run-over-dillo animal))
      ((parrot? animal) (run-over-parrot animal)))))

;;; ÜBUNG animal-alive? Gibt an, ob ein Tier am Leben ist oder nicht
(: animal-alive? (animal -> boolean))
(check-expect (animal-alive? dillo1) #t)
(check-expect (animal-alive? dillo2) #f)
(check-expect (animal-alive? parrot1) #t)
(check-expect (animal-alive? (make-parrot 2000 "")) #f)

(define animal-alive?
  (lambda (animal)
    (cond
      ((dillo? animal)  (dillo-alive? animal))
      ((parrot? animal) (parrot-alive? animal)))))


; Eine leere Liste besteht aus... ? nix
#;(define-record-functions empty-list
  make-empty-list
  empty?)

; Eine nicht-leere Liste besteht aus
; - einer Zahl ("Kopf" der Liste)
; - eine weitere Liste der restlichen Zahlen
; (: cons-of-integers signature)
#;(: cons-of (signature -> signature))
#;(define-record-functions (cons-of element) ; Abstraktion über element
  ; (lambda (element) ...)
  cons
  cons?
  (first element)
  (rest (list-of element)))


#|
(define-record cons-of
  (lambda (element)
    cons
    cons?
    (first element)
    (rest (list-of element))))

(: cons (lambda (element) (element (list-of element) -> (cons-of element))))

(: extract-list (lambda (element) ((element -> boolean) (list-of element) -> (list-of element))))
|#


; Signaturvariable: fängt mit % an, kein Lambda notwendig
#;(: cons (%element (list-of %element) -> (cons-of %element)))

; cons -> constitute = construct / constitute (?)

; Eine Liste von Zahlen ist eins der folgenden
; - eine leere Liste
; - eine nicht-leere Liste (von Zahlen)
#;(: list-of (signature -> signature))
#;(define list-of
  (lambda (element)
    (signature (mixed empty-list
                      (cons-of element)))))

(define list-of-integers
  (signature (list-of integer)))

#;(define empty (make-empty-list))

(define liste1 (cons 3 empty))
(define liste2 (cons 1 (cons 5 empty)))
(define liste3 (cons 3 liste2))

; Addiere alle Zahlen der Liste auf!
(: list-sum ((list-of integer) -> integer))
(check-expect (list-sum liste1) 3)
(check-expect (list-sum liste3) 9)
(check-expect (list-sum empty) 0)

(define list-sum
  (lambda (liste)
    (cond
      ((empty? liste) 0)
      ((cons? liste) (+ (first liste)
                        (list-sum (rest liste)))))))


;;;; ÜBUNG: Schreibe ein Programm, das eine Liste aufmultipliziert!

; Multipliziert alle Zahlen einer Liste miteinander
(: list-mult (list-of-integers -> integer))
(check-expect (list-mult liste1) 3)
(check-expect (list-mult liste3) 15)
(check-error (list-mult empty))

(define list-mult-helper
  (lambda (liste)
    (cond
      ((empty? liste) 1)
      ((cons? liste) (* (first liste)
                        (list-mult-helper (rest liste)))))))

(define list-mult
  (lambda (liste)
    (if (empty? liste)
        (violation "Leere Liste")
        (list-mult-helper liste))))

; Alle Elemente einer Liste multiplizieren
(: list-product (list-of-integers -> integer))

(check-expect (list-product liste3) 15)

(define list-product
  (lambda (liste)
    (cond
      ((empty? liste) 1) ; neutrales Element
      ((cons? liste) (* (first liste)
                        (list-product (rest liste)) ; Produkt des Rests der Liste
                        )))))

; Alle geraden Elemente aus einer Liste extrahieren
(: list-evens (list-of-integers -> list-of-integers))

(check-expect (list-evens (cons 1 (cons 2 (cons 5 (cons 6 (cons 9 empty))))))
              (cons 2 (cons 6 empty)))


(define list-evens
  (lambda (list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       (define f (first list))
       (define r (list-evens (rest list)))
       (if (even? f)
           (cons f r)
           r)))))

; Alle ungeraden Elemente aus einer Liste extrahieren
(: list-odds (list-of-integers -> list-of-integers))

(check-expect (list-odds (cons 1 (cons 2 (cons 5 (cons 6 (cons 9 empty))))))
              (cons 1 (cons 5 (cons 9 empty))))

(define list-odds
  (lambda (list)
    (cond
      ((empty? list) list)
      ((cons? list)
       (define f (first list))
       (define r (list-odds (rest list)))
       (if (odd? f)
           (cons f r)
           r)))))

; Java
; public interface Stream<T> <- Lambda
; Stream<T> 	filter(Predicate<? super T> predicate)

; Alle Elemente einer Liste extrahieren, die ein bestimmtes Kriterium erfüllen
; Kriterium repräsentiert als *Prädikat*
(: list-extract ((%element -> boolean) (list-of %element) -> (list-of %element)))

(: blist1 (list-of boolean))
(define blist1 (cons #t (cons #f empty)))

(: slist1 (list-of string))
(define slist1 (cons "foo" (cons "bar" empty)))

(check-expect (list-extract even? (cons 1 (cons 2 (cons 5 (cons 6 (cons 9 empty))))))
              (cons 2 (cons 6 empty)))
(check-expect (list-extract odd? (cons 1 (cons 2 (cons 5 (cons 6 (cons 9 empty))))))
              (cons 1 (cons 5 (cons 9 empty))))

(define list-extract
  (lambda (p? list)
    (cond
      ((empty? list) list)
      ((cons? list)
       (define f (first list))
       (define r (list-extract p? (rest list)))
       (if (p? f)
           (cons f r)
           r)))))

(: dillo-list1 (list-of dillo))
(define dillo-list1 (list dillo1 dillo2))

(: dillo-alive? (dillo -> boolean))
; (list-extract dillo-alive? dillo-list1)

(define highway (list dillo1 parrot1 dillo2 parrot2))

(: dillo? (any -> boolean))

; (list-extract dillo? highway)

; eingebaut als filter

; Alle Tiere einer Liste überfahren
(: run-over-animals ((list-of animal) -> (list-of animal)))

(check-expect (run-over-animals (list dillo1 parrot1 dillo2 parrot2))
              (list (run-over-animal dillo1)
                    (run-over-animal parrot1)
                    (run-over-animal dillo2)
                    (run-over-animal parrot2)))

(define run-over-animals
  (lambda (list)
    (cond
      ((empty? list) empty)
      ((cons? list)
       (cons (run-over-animal (first list))
             (run-over-animals (rest list)))))))






   