#lang sweet-exp racket

require
  racket/flonum
  racket-game/types
  racket-game/macros

provide
  v+
  v*
  norm
  set-vec2!

define (vlen-squared v)
  define*
    x (vec2-x v)
    y (vec2-y v)
  {{x fl* x} + {y fl* y}}

define vlen (compose sqrt vlen-squared)

define (norm v)
  {v v* (/ (vlen v))}

define {v1 v+ v2}
  vec2
    {(vec2-x v1) fl+ (vec2-x v2)}
    {(vec2-y v1) fl+ (vec2-y v2)}

define {fs v* sn}
  match (cons fs sn)
    (cons (? vec2? vec-a) (? vec2? vec-b))
      vec2
        {(vec2-x vec-a) fl* (vec2-x vec-b)}
        {(vec2-y vec-a) fl* (vec2-y vec-b)}
    (cons (? number? multiplier) (? vec2? vec))
      {(vec2 multiplier multiplier) v* vec}
    (cons (? vec2? vec) (? number? multiplier))
      {multiplier v* vec}
