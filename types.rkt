#lang sweet-exp racket

require racket/match

provide
  struct-out entity
  struct-out vec2
  struct-out ecs-system
  v+
  v*
  set-vec2!

struct ecs-system
  entities pre every post

struct vec2
  x y
  #:prefab
  #:mutable

define {v1 v+ v2}
  vec2
    {(vec2-x v1) + (vec2-x v2)}
    {(vec2-y v1) + (vec2-y v2)}

define {fs v* sn}
  match (cons fs sn)
    (cons (? vec2? vec-a) (? vec2? vec-b))
      vec2
        {(vec2-x vec-a) * (vec2-x vec-b)}
        {(vec2-y vec-a) * (vec2-y vec-b)}
    (cons (? number? multiplier) (? vec2? vec))
      {(vec2 multiplier multiplier) v* vec}
    (cons (? vec2? vec) (? number? multiplier))
      {multiplier v* vec}

define (set-vec2! last-v cur-v)
  set-vec2-x! last-v (vec2-x cur-v)
  set-vec2-y! last-v (vec2-y cur-v)

struct entity
  image position size
  #:prefab
  #:mutable
