#lang sweet-exp racket

require reloadable

provide
  define/memoized
  define/memoized/persistent

;; replace define with a memoized version
define-syntax define/memoized
  syntax-rules ()
    [_ (f args ...) bodies ...]
      define f
        ;; store the cache as a hash of args => result
        let ([results (make-hash)])
          ;; need to do this to capture both the names and the values
          λ (args ...)
            ((λ vals
                ;; if we haven't calculated it before, do so now
                (when (not (hash-has-key? results vals))
                  (hash-set! results vals (begin bodies ...)))
                ;; return the cached result
                (hash-ref results vals))
              args ...)

;; replace define with a memoized version
define-syntax define/memoized/persistent
  syntax-rules ()
    [_ (f args ...) bodies ...]
      define f
        ;; store the cache as a hash of args => result
        let ([results (make-persistent-state 'f make-hash)])
          ;; need to do this to capture both the names and the values
          λ (args ...)
            ((λ vals
                ;; if we haven't calculated it before, do so now
                (when (not (hash-has-key? (results) vals))
                  (hash-set! (results) vals (begin bodies ...)))
                ;; return the cached result
                (hash-ref (results) vals))
              args ...)
