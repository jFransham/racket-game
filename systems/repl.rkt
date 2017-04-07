#lang sweet-exp racket

require
  prefix-in scran:   scran
  reloadable
  racket-game/macros
  racket-game/types
  racket-game/vec2
  racket-game/components

provide add-sys!

define port 65415

define server
  make-persistent-state 'repl-server
    λ () $ tcp-listen port 4 #f "127.0.0.1"

define (every dt e ent vel)
  when (tcp-accept-ready? (server))
    let-values ([(in out) (tcp-accept server)])
      parameterize
        \\
          current-namespace   (make-base-namespace)
          current-input-port  in
          current-output-port out
        ((eval (read in)) dt e ent vel)

define (add-sys! c w)
  scran:system! c w
    list cmp-entity cmp-velocity
    #:every (λ args (apply every args))
