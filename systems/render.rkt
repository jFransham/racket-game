#lang sweet-exp racket

require
  prefix-in allegro: allegro
  prefix-in scran:   scran
  racket-game/macros
  racket-game/types
  racket-game/components
  racket-game/memoize

provide add-sys!

define*
  screen-color $ allegro:map-rgb-f 1.0 1.0 1.0
  text-color   $ allegro:map-rgb-f 0.0 0.0 0.0
  font
    lazy $ allegro:load-font "/usr/share/fonts/TTF/DejaVuSans.ttf" 12 0

;; TODO: Remove pre/post from render system (so that multiple systems can
;;       render)

define/memoized/persistent (load-image path)
  allegro:load-bitmap path

define intstr
  compose number->string inexact->exact

define (pre ctx)
  allegro:clear-to-color screen-color

define (each ctx e ent img)
  let ([p (entity-position ent)])
    allegro:draw-bitmap
      load-image $ bitmap-image-path img
      vec2-x p
      vec2-y p
      0

define (post ctx)
  define fps $ round (/ ctx)
  when (not (infinite? fps))
    allegro:draw-text (force font) text-color 0.0 0.0 'AlignLeft (intstr fps)
  (allegro:flip-display)

define (add-sys! c w)
  scran:system! c w
    list cmp-entity cmp-image
    ;; This is to allow hot-loading
    #:pre   (λ args (apply pre  args))
    #:each  (λ args (apply each args))
    #:post  (λ args (apply post args))
