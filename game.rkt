#lang curly-fn sweet-exp racket

require
  prefix-in allegro: allegro
  prefix-in scran:   scran
  reloadable
  racket-game/systems/main
  racket-game/components
  racket-game/macros
  racket-game/types
  racket-game/vec2

provide run-game

void
  make-persistent-state 'allegro     allegro:install-system
  make-persistent-state 'image-addon allegro:init-image-addon
  make-persistent-state 'font-addon  allegro:init-font-addon
  make-persistent-state 'ttf-addon   allegro:init-ttf-addon

define*
  screen-w     $ 640
  screen-h     $ 480
  fps          $ 60
  debug?       $ #t

  keyboard     $ make-persistent-state 'keyboard
                  allegro:install-keyboard
  mouse        $ make-persistent-state 'mouse
                  allegro:install-mouse
  screen       $ make-persistent-state 'main-display
                  λ () (allegro:create-display screen-w screen-h)
  timer        $ make-persistent-state 'main-timer
                  λ ()
                    let ([timer (allegro:create-timer (/ 1.0 fps))])
                      allegro:start-timer timer
                      timer
  event-queue  $ make-persistent-state 'main-event-queue
                  λ ()
                    let ([queue (allegro:create-event-queue)])
                      allegro:register-event-source queue
                        allegro:get-timer-event-source (timer)
                      allegro:register-event-source queue
                        (allegro:get-keyboard-event-source)
                      queue

  world        $ make-persistent-state 'main-world
                  scran:default-world
  components   $ make-persistent-state 'main-components
                   λ ()
                    add-components! (world)
  systems      $ make-persistent-state 'main-systems
                   λ ()
                    add-systems! (components) (world)
  image        $ "/home/jef/Pictures/baby.png"
  should-load? $ make-persistent-state 'main-should-load
                   λ ()
                    #f
  should-save? $ make-persistent-state 'main-should-sav
                   λ ()
                    #f


define (deserialize)
  define state
    with-input-from-file "current-state.rkt"
      λ () (eval (read) (make-base-namespace))
  scran:reset-all-systems! (world)
  for ([ent-set state])
    apply scran:entity! (world) ent-set
  should-load? #f

define (serialize)
  define entities
    hash-map (scran:world-entities (world))
      λ (k v)
        hash-map v cons

  with-output-to-file "current-state.rkt"
    λ () (print entities)
    #:exists 'replace
  should-save? #f

define (tick dt)
  when (should-load?) (deserialize)
  when (should-save?) (serialize)
  for ([s (get-systems (systems))])
    scran:system-execute (world) s dt

define (loop last-time cur-time)
  tick {cur-time - last-time}
  get-event cur-time

define (get-event [last-time 0.0] [cur-time #f])
  if {cur-time and (allegro:is-event-queue-empty (event-queue))}
    loop last-time cur-time
    let
      \\
        event $ allegro:wait-for-event (event-queue)
        next  $ λ ([t cur-time]) (get-event last-time t)
      match event
        (allegro:KeyboardEvent
          type
          source
          timestamp
          display
          keycode
          unicode
          modifiers
          repeat)
          match type
            'KeyChar
              begin
                case keycode
                  (Escape)
                    displayln "Quitting!"
                    exit 0
                  (L)
                    should-load? #t
                  (S)
                    should-save? #t
                (next)
            else
              (next)
        (allegro:TimerEvent type source timestamp count error)
          next timestamp
        else
          (next)

define (fl-random mn mx)
  define rand-range {mx - mn}
  {mn + {(random) * rand-range}}

define (run-game)
  define*
    ent-size $ 272.0
    max-x    $ {screen-w - ent-size}
    max-y    $ {screen-h - ent-size}

  for ([i (in-range 0 0)])
    scran:entity! (world)
      list
        cmp-entity (components)
        entity
          vec2
            fl-random 0.0 max-x
            fl-random 0.0 max-y
          vec2
            ent-size
            ent-size
      list
        cmp-velocity (components)
        {130.0 v* (norm (vec2 (fl-random -1 1) (fl-random -1 1)))}
      list
        cmp-image (components)
        bitmap image
  allegro:run get-event
