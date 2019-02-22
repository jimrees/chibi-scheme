;; color.scm -- colored output
;; Copyright (c) 2006-2017 Alex Shinn.  All rights reserved.
;; BSD-style license: http://synthcode.com/license.txt

;; Uses state variables color-hue color-bold? color-underline?
;; Assumes defaults for those variables are all #f

(define (color->ansi x)
  (case x
    ((bold) "1")
    ((dark) "2")
    ((underline) "4")
    ((underline-off) "24")
    ((black) "30")
    ((red) "31")
    ((green) "32")
    ((yellow) "33")
    ((blue) "34")
    ((magenta) "35")
    ((cyan) "36")
    ((white) "37")
    (else "0")))

(define (ansi-escape color)
  (each (integer->char 27) "[" (color->ansi color) "m"))

(define (colored colorkey args)
  (fn ((old-hue color-hue))
    (if (eqv? old-hue colorkey)
        (each-in-list args)
        (each (ansi-escape colorkey)
              (with ((color-hue colorkey)) (each-in-list args))
              (if old-hue
                  (ansi-escape old-hue)
                  (fn ((underline? color-underline?)
                       (bold? color-bold?))
                    (each (ansi-escape 'reset)
                          (if underline? (ansi-escape 'underline) nothing)
                          (if bold? (ansi-escape 'bold) nothing))))))))

(define (as-red . args) (colored 'red args))
(define (as-blue . args) (colored 'blue args))
(define (as-green . args) (colored 'green args))
(define (as-cyan . args) (colored 'cyan args))
(define (as-yellow . args) (colored 'yellow args))
(define (as-magenta . args) (colored 'magenta args))
(define (as-white . args) (colored 'white args))
(define (as-black . args) (colored 'black args))

(define (as-bold . args)
  (fn ((old-bold color-bold?))
    (if old-bold
        (each-in-list args)
        (each (ansi-escape 'bold)
              (with ((color-bold? #t)) (each-in-list args))
              (ansi-escape 'reset)
              (fn ((hue color-hue)
                   (underline? color-underline?))
                (each
                 (if hue (ansi-escape hue) nothing)
                 (if underline? (ansi-escape 'underline) nothing)))))))

(define (as-underline . args)
  (fn ((old-underline color-underline?))
    (if old-underline
        (each-in-list args)
        (each (ansi-escape 'underline)
              (with ((color-underline? #t)) (each-in-list args))
              (ansi-escape 'underline-off)))))
