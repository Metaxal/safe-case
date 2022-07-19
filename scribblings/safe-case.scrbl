#lang scribble/manual
@(require (for-label safe-case
                     racket/base)
          safe-case
          racket/sandbox
          racket/runtime-path
          scribble/example)

@(define-runtime-path compile-error-img "../img/safe-case-compile-error.png")

@title{safe-case}
@author{Laurent Orseau}

License: MIT or Apache 2.0 at your option.
@defmodule[safe-case]

@racket[define-safe-case] is for those who like @racket[case] but fear uncaught typos.


@(define my-eval
   (parameterize ([sandbox-output 'string]
                  [sandbox-error-output 'string]
                  [sandbox-memory-limit 50])
     (make-evaluator 'racket/base '(require safe-case))))
@examples[
 #:eval my-eval
 (define-safe-case my-case (a b c))
 (code:comment "Works just like case:")
 (my-case 'b
   [(a) 'a]
   [(b c) 'b-or-c])
 (code:comment "Compile-time error:")
 (code:comment "(The docs don't render this well, see below for a DrRacket screenshot)")
 (eval:error
  (my-case 'a
    [(a_typo) 'a]
    [(b) 'b]))
 (code:comment "Runtime error:")
 (eval:error
  (my-case 'a_typo
    [(a) 'a]
    [(b) 'b]))
 (code:comment "Valid argument, but not included in the list:")
 (eval:error
  (my-case 'c
    [(a) 'a]
    [(b) 'b]))]

Example of a compilation error within DrRacket:
@image[compile-error-img]

@defform[(define-safe-case caser (sym ...))]{
Binds @racket[caser] to a form similar to @racket[case] but with tighter safety checks
 to minimize the risk of uncaught typos.}

@defform[(define-safe-case+symbols caser symbols (sym ...))]{
Like @racket[define-safe-case] but also binds @racket[symbols] to
the list of symbols.
@examples[
 #:eval my-eval
 (define-safe-case+symbols my-safe-case my-symbols (a b c))
 (my-safe-case 'a
  [(a) (list 'my-symbols: my-symbols)])]

This form combines well in particular with @racket[define-global:category],
from the @racket[global] package, to read arguments from the command line.
}

