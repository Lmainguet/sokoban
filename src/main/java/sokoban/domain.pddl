(define (domain sokoban)
  (:requirements :strips :typing :conditional-effects)

  (:types box position)

  (:predicates
    (at-player ?p - position)
    (at-box ?b - box ?p - position)
    (free ?p - position)
    (goal ?p - position)
    (not-goal ?p - position)
    (solved ?b - box)
    (adjacent ?from - position ?to - position)
    (straight ?from - position ?middle - position ?to - position)
  )

  (:action move
    :parameters (?from - position ?to - position)
    :precondition (and
      (at-player ?from)
      (free ?to)
      (adjacent ?from ?to)
    )
    :effect (and
      (not (at-player ?from))
      (at-player ?to)
      (not (free ?to))
      (free ?from)
    )
  )

  (:action push
    :parameters (?from - position ?box-position - position ?to - position ?box - box)
    :precondition (and
      (at-player ?from)
      (at-box ?box ?box-position)
      (free ?to)
      (straight ?from ?box-position ?to)
    )
    :effect (and
      (not (at-player ?from))
      (at-player ?box-position)
      (not (at-box ?box ?box-position))
      (at-box ?box ?to)
      (free ?from)
      (not (free ?to))
      (when (goal ?to)
        (solved ?box))
      (when (and (goal ?box-position) (not-goal ?to))
        (not (solved ?box)))
    )
  )
)
