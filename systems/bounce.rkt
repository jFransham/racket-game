#lang sweet-exp racket

require
  prefix-in scran:   scran
  racket-game/macros
  racket-game/types
  racket-game/vec2
  racket-game/components

provide add-sys!

define (every dt e ent vel)
  define*
    size         $ entity-size ent
    top-left     $ entity-position ent
    bottom-right $ {size v+ top-left}
    left         $ vec2-x top-left
    right        $ vec2-x bottom-right
    top          $ vec2-y top-left
    bottom       $ vec2-y bottom-right
    xvel         $ vec2-x vel
    yvel         $ vec2-y vel
    xspeed       $ abs xvel
    yspeed       $ abs yvel
    new-speed
      vec2
        cond
          {left < 0}
            xspeed
          {right > 640}
            - xspeed
          else
            xvel
        cond
          {top < 0}
            yspeed
          {bottom > 480}
            - yspeed
          else
            yvel
  set-vec2! vel new-speed

define (add-sys! c w)
  scran:system! c w
    list cmp-entity cmp-velocity
    #:every (λ args (apply every args))
