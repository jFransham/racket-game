#lang sweet-exp racket

require
  prefix-in scran: scran
  racket/contract
  racket-game/types

provide
  struct-out cmp
  add-components!

struct cmp
  entity velocity image
  #:prefab

define (c-update/identity entity val)
  val

define c/entity
  invariant-assertion
    -> scran:entity? entity? entity?
    c-update/identity

define c/image
  invariant-assertion
    -> scran:entity? bitmap? bitmap?
    c-update/identity

define c/velocity
  invariant-assertion
    -> scran:entity? vec2? vec2?
    c-update/identity

define (add-components! world)
  cmp
    scran:component! world c/entity
    scran:component! world c/velocity
    scran:component! world c/image
