#lang sweet-exp racket

require
  prefix-in scran: scran
  prefix-in render:      racket-game/systems/render
  prefix-in physics:     racket-game/systems/physics
  prefix-in bounce:      racket-game/systems/bounce
  prefix-in repl:        racket-game/systems/repl
  racket-game/memoize
  racket-game/reloadable-helpers
  racket-game/types

provide
  add-systems!
  get-systems
  struct-out sys

struct sys
  physics bounce render repl
  #:prefab

define (add-systems! c w [debug #f])
  apply
    sys
    map (λ (f) {f and (f c w)})
      list
        physics:add-sys!
        bounce:add-sys!
        render:add-sys!
        {debug and repl:add-sys!}

define/memoized (get-systems s)
  filter
    identity
    list
      sys-physics     s
      sys-bounce      s
      sys-render      s
      sys-repl        s
