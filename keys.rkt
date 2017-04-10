#lang sweet-exp racket

require
  racket-game/types

provide
  make-keys

define (make-keys last-keys cur-keys)
  keys
    cur-keys
    {cur-keys  set-subtract last-keys}
    {last-keys set-subtract cur-keys}
