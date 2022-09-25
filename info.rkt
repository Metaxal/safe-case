#lang info
(define collection "safe-case")
(define deps '("base"))
(define build-deps '("sandbox-lib"
                     "scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/safe-case.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(laurent))
(define license '(Apache-2.0 OR MIT))
