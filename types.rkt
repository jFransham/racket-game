#lang sweet-exp racket

require racket/match

provide
  struct-out entity
  struct-out vec2
  struct-out bitmap
  struct-out ecs-system
  set-bitmap!
  set-entity!
  set-vec2!

struct ecs-system
  entities pre every post

struct vec2
  x y
  #:prefab
  #:mutable

struct entity
  position size
  #:prefab
  #:mutable

struct bitmap (image-path)
  #:prefab
  #:mutable

define (set-bitmap! o n)
  set-bitmap-image-path! o (bitmap-image-path n)

define (set-entity! o n)
  set-entity-position! o (entity-position n)
  set-entity-size!     o (entity-size     n)

define (set-vec2! o n)
  set-vec2-x! o (vec2-x n)
  set-vec2-y! o (vec2-y n)
