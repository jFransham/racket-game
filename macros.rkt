#lang sweet-exp racket

provide
  define*
  define-print*

define-syntax (define* stx)
  datum->syntax
    stx
    cons
      'begin
      map
        λ (x) `(define ,@x)
        cdr $ syntax->datum stx

define-syntax (define-print* stx)
  let*
    \\
      dtm         $ cdr (syntax->datum stx)
      inner-print $ car dtm
      defs        $ cdr dtm
    datum->syntax
      stx
      cons
        'begin
        map
          λ (x)
            `(begin
              (define ,@x)
              (,inner-print "Creating ~a\n" ',(car x)))
          defs

