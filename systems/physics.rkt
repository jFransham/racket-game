#lang sweet-exp racket

require
  prefix-in scran:   scran
  racket-game/macros
  racket-game/types
  racket-game/vec2
  racket-game/components

provide add-sys!

define (all ctx l)
  void

define (each dt e ent vel)
  set-entity-position! ent
    {(entity-position ent) v+ {dt v* vel}}

define (add-sys! c w)
  scran:system! c w
    list cmp-entity cmp-velocity
    #:each (λ args (apply each args))
    #:all  (λ args (apply all args))
