#lang sweet-exp racket

require racket/match

provide
  struct-out entity
  struct-out vec2
  struct-out ecs-system

struct ecs-system
  entities pre every post

struct vec2
  x y
  #:prefab
  #:mutable

struct entity
  image position size
  #:prefab
  #:mutable
