#lang racket/base

(require syntax/parse/define
         (for-syntax racket/base))

(provide define-safe-case
         define-safe-case+symbols)


(module+ test
  (require rackunit))

;; A little case DSL that accepts only a fixed set of symbols
;; and raises an exception on typos (at compile time or at runtime).
(define-syntax-parse-rule (define-safe-case caser (sym ...))
  #:with ooo #'(... ...)
  (define-syntax-parse-rule (caser stage:expr [(~and condition ((~or (~datum sym) ...) ooo)) body ooo] ooo)
    (let ([stage* stage])
      (case stage*
        [condition body ooo] ooo
        [else
         (define syms '(sym ...))
         (if (memq stage* syms)
           (error 'caser "Unknown case for ~a: ~a" 'caser stage*)
           (error 'caser "Invalid case for ~a: ~a\n valid cases: ~a" 'caser stage* syms))]))))

;; Same as `define-safe-case` but also binds the list of symbols to the `syms` id.
(define-syntax-parse-rule (define-safe-case+symbols caser syms (sym ...))
  (begin
    (define syms '(sym ...))
    (define-safe-case caser (sym ...))))


(module+ test

  (define-safe-case+symbols my-case my-syms (a b c))
  (check-equal? my-syms '(a b c))
  (check-equal? (my-case 'a [(a b) 'ab] [(c) 'c]) 'ab)
  (check-equal? (my-case 'b [(a b) 'ab] [(c) 'c]) 'ab)
  (check-equal? (my-case 'c [(a b) 'ab] [(c) 'c]) 'c)
  #; ; This case must fail at expansion time
  (my-case 'a
           [(a b c d) 'hey])
  ;; This case fails at runtime
  (check-exn exn:fail? (λ () (my-case 'd
                                      [(a b c) 'hey])))
  (check-exn exn:fail? (λ () (my-case 'c
                                      [(a b) 'hey])))
  )
