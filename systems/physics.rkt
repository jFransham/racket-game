#lang sweet-exp racket

require
  prefix-in scran:   scran
  racket-game/macros
  racket-game/types
  racket-game/components

provide add-sys!

define (every dt e ent vel)
  set-entity-position! ent
    {(entity-position ent) v+ {dt v* vel}}

define (add-sys! c w)
  scran:system! c w
    list cmp-entity cmp-velocity
    #:every (λ args (apply every args))
