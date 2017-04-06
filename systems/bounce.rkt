#lang sweet-exp racket

require
  prefix-in scran:   scran
  racket-game/macros
  racket-game/types
  racket-game/components

provide add-sys!

define (every e ent vel)
  define*
    size         $ entity-size ent
    top-left     $ entity-position ent
    bottom-right $ {size v+ top-left}
    left         $ vec2-x top-left
    right        $ vec2-x bottom-right
    top          $ vec2-y top-left
    bottom       $ vec2-y bottom-right
    out-mul
      vec2
        if {{left < 0} or {right > 640}} ;; HACK
          -1
          1
        if {{top < 0} or {bottom > 480}} ;; HACK
          -1
          1

  set-vec2! vel {out-mul v* vel}

define (add-sys! c w)
  scran:system! c w
    list cmp-entity cmp-velocity
    #:every (λ args (apply every args))
