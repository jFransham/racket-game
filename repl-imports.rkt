#lang sweet-exp racket

require
  prefix-in allegro: allegro
  racket-game/macros
  racket-game/types
  racket-game/vec2

provide namespace-anchor

define (for-entity id f)
  λ (ctx e . args)
    if {e eqv? id}
      apply f ctx e args
      (void)

define (set-velocity! new-vel)
  λ (ctx e ent vel)
    set-vec2! vel new-vel

define-namespace-anchor namespace-anchor
