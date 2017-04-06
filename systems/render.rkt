#lang sweet-exp racket

require
  prefix-in allegro: allegro
  prefix-in scran:   scran
  racket-game/macros
  racket-game/types
  racket-game/components

provide add-sys!

define*
  screen-color $ allegro:map-rgb-f 1.0 1.0 1.0
  text-color   $ allegro:map-rgb-f 0.0 0.0 0.0

;; TODO: Remove pre/post from render system (so that multiple systems can
;;       render)

define (pre)
  allegro:clear-to-color screen-color

define (every e ent)
  let ([p (entity-position ent)])
    allegro:draw-bitmap
      entity-image ent
      vec2-x p
      vec2-y p
      0

define (post)
  (allegro:flip-display)

define (add-sys! c w)
  scran:system! c w
    list cmp-entity
    #:pre   (λ () (pre))
    #:every (λ (e ent) (every e ent))
    #:post  (λ () (post))
