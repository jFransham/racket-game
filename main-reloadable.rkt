#lang sweet-exp racket

require
  reloadable
  racket-game/reloadable-helpers

define main
  (make-reloadable 'run-game "game.rkt")

(main)
