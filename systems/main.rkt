#lang sweet-exp racket

require
  prefix-in scran: scran
  prefix-in render:  racket-game/systems/render
  prefix-in physics: racket-game/systems/physics
  prefix-in bounce:  racket-game/systems/bounce
  prefix-in repl:    racket-game/systems/repl
  racket-game/reloadable-helpers
  racket-game/types

provide
  add-systems!
  struct-out sys

struct sys
  render physics bounce
  #:prefab

define (add-systems! c w)
  sys
    render:add-sys! c w
    physics:add-sys! c w
    bounce:add-sys! c w
