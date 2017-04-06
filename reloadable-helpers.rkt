#lang sweet-exp racket

require reloadable

provide
  make-reloadable
  make-reloadable-val

define (make-reloadable name mod)
  define entry-point
    make-reloadable-entry-point name mod
  (reload!)
  reloadable-entry-point->procedure entry-point

define (make-reloadable-val name mod)
  define entry-point
    make-reloadable-entry-point name mod
  (reload!)
  reloadable-entry-point-value entry-point

