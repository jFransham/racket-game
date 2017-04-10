#lang sweet-exp racket

require
  prefix-in scran:   scran
  reloadable
  racket-game/macros
  racket-game/types
  racket-game/vec2
  racket-game/components
  racket-game/repl-imports

provide add-sys!

define current-lambda (make-parameter void)

define port
  make-persistent-state 'repl-port
    λ () $ random 65400 65500

define server
  make-persistent-state 'repl-server
    λ ()
      lazy
        fprintf (current-output-port) "Listening on port ~a~n" (port)
        tcp-listen (port) 4 #f "127.0.0.1"

define (pre ctx)
  define srv (force (server))
  when (tcp-accept-ready? srv)
    let-values ([(in out) (tcp-accept srv)])
      parameterize
        \\
          current-namespace   (namespace-anchor->namespace namespace-anchor)
          current-input-port  in
          current-output-port out
        with-handlers
          \\
            exn? displayln
          current-lambda (eval (read))
        close-input-port in
        close-output-port out

define (each ctx e ent vel)
  (current-lambda) ctx e ent vel

define (post ctx)
  current-lambda void

define (add-sys! c w)
  scran:system! c w
    list cmp-entity cmp-velocity
    #:pre  (λ args (apply pre args))
    #:each (λ args (apply each args))
    #:post (λ args (apply post args))
