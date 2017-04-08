#lang sweet-exp racket

require
  prefix-in scran: scran
  prefix-in render:      racket-game/systems/render
  prefix-in physics:     racket-game/systems/physics
  prefix-in bounce:      racket-game/systems/bounce
  prefix-in repl:        racket-game/systems/repl
  racket-game/reloadable-helpers
  racket-game/types

provide
  add-systems!
  get-systems
  struct-out sys

struct sys
  repl physics bounce render
  #:prefab

define (add-systems! c w)
  apply
    sys
    map (λ (f) (f c w))
      list
        repl:add-sys!
        physics:add-sys!
        bounce:add-sys!
        render:add-sys!

define (get-systems s)
  list
    sys-repl        s
    sys-physics     s
    sys-bounce      s
    sys-render      s
