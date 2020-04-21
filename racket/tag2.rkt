;; Die ersten drei Zeilen dieser Datei wurden von DrRacket eingefügt. Sie enthalten Metadaten
;; über die Sprachebene dieser Datei in einer Form, die DrRacket verarbeiten kann.
#reader(lib "beginner-reader.rkt" "deinprogramm" "sdp")((modname tag2) (read-case-sensitive #f) (teachpacks ()) (deinprogramm-settings #(#f write repeating-decimal #f #t none explicit #f ())))
; Eine leere Liste besteht aus... ? nix
(define-record-functions empty-list
  make-empty-list
  empty?)

; Eine nicht-leere Liste besteht aus
; - einer Zahl ("Kopf" der Liste)
; - eine weitere Liste der restlichen Zahlen
; (: cons-of-integers signature)
(: cons-of (signature -> signature))
(define-record-functions (cons-of element) ; Abstraktion über element
  ; (lambda (element) ...)
  cons
  cons?
  (first element)
  (rest (list-of element)))

; Signaturvariable: fängt mit % an, kein Lambda notwendig
(: cons (%element (list-of %element) -> (cons-of %element)))

; cons -> constitute = construct / constitute (?)

; Eine Liste von Zahlen ist eins der folgenden
; - eine leere Liste
; - eine nicht-leere Liste (von Zahlen)
(: list-of (signature -> signature))
(define list-of
  (lambda (element)
    (signature (mixed empty-list
                      (cons-of element)))))

(define list-of-integers
  (signature (list-of integer)))

(define empty (make-empty-list))

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