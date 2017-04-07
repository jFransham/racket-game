#lang sweet-exp racket

require
  racket/flonum
  racket-game/types
  racket-game/macros

provide
  v+
  v*
  set-vec2!

define (vlen v)
  define*
    x (vec2-x v)
    y (vec2-y v)
  {{x fl* x} + {y fl* y}}

define (norm v)
  {v v* {1 / (vlen v)}}

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

define (set-vec2! last-v cur-v)
  set-vec2-x! last-v (vec2-x cur-v)
  set-vec2-y! last-v (vec2-y cur-v)

