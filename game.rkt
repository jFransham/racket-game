#lang curly-fn sweet-exp racket

require
  prefix-in allegro: allegro
  prefix-in scran:   scran
  reloadable
  racket-game/systems/main
  racket-game/components
  racket-game/macros
  racket-game/types

provide run-game

define*
  screen-w     $ 640
  screen-h     $ 480
  fps          $ 60
  debug?       $ #t

  allegro      $ make-persistent-state 'allegro
                  allegro:install-system
  image-addon  $ make-persistent-state 'image-addon
                  allegro:init-image-addon
  font-addon   $ make-persistent-state 'font-addon
                  allegro:init-font-addon
  ttf-addon    $ make-persistent-state 'ttf-addon
                  allegro:init-ttf-addon
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
  image        $ allegro:load-bitmap "/home/jef/Pictures/baby.png"

define (tick [dt #f])
  displayln dt
  scran:system-execute (world) (sys-physics (systems)) dt
  scran:system-execute (world) (sys-bounce (systems))
  scran:system-execute (world) (sys-render (systems))

define (loop [last-time 0.0] [cur-time #f] [redraw? #f])
  when {redraw? and cur-time}
    tick {cur-time - last-time}

  define event $ allegro:wait-for-event (event-queue)
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
          case keycode
            (Escape)
              displayln "Quitting!"
              exit 0
            else
              loop last-time cur-time redraw?
        else
          loop last-time cur-time redraw?
    (allegro:TimerEvent type source timestamp count error)
      loop {cur-time or 0.0} timestamp #t
    else
      loop last-time cur-time redraw?
  loop last-time cur-time redraw?

define (run-game)
  scran:entity! (world)
    list
      cmp-entity (components)
      entity image (vec2 0.0 0.0) (vec2 272.0 272.0)
    list
      cmp-velocity (components)
      vec2 100.0 100.0
  allegro:run loop
