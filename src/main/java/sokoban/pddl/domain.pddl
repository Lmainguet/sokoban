(define (domain robot-monde)
  (:requirements :strips :typing)

  (:types robot box wall cell)

  (:predicates
    (at-robot ?c - cell)
    (at-box ?b - box ?c - cell)
    (wall ?c - cell)
    (goal ?c - cell)
    (adjacent ?c1 - cell ?c2 - cell)
    (free ?c - cell)
    (dir-up ?from ?to)
    (dir-down ?from ?to)
    (dir-left ?from ?to)
    (dir-right ?from ?to)
  )

  (:action move
    :parameters (?r - robot ?from - cell ?to - cell)
    :precondition (and
      (at-robot ?from)
      (adjacent ?from ?to)
      (free ?to)
    )
    :effect (and
      (at-robot ?to)
      (free ?from)
      (not (at-robot ?from))
      (not (free ?to))
    )
  )
  ;;le robot est adjacent à la boîte
  ;;la boîte est adjacente à la destination
  (:action push-up
    :parameters (?r - robot ?b - box ?down - cell ?boxcell - cell ?up - cell)
    :precondition (and
      (at-robot ?down)
      (at-box ?b ?boxcell)
      (dir-up ?down ?boxcell)
      (dir-up ?boxcell ?up)
      (free ?up)
    )
    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?up)
      (free ?down)
      (not (at-robot ?down))
      (not (at-box ?b ?boxcell))
      (not (free ?up))
    )
  )

  (:action push-down
    :parameters (?r - robot ?b - box ?up - cell ?boxcell - cell ?down - cell)
    :precondition (and
      (at-robot ?up)
      (at-box ?b ?boxcell)
      (dir-down ?up ?boxcell)
      (dir-down ?boxcell ?down)
      (free ?down)
    )
    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?down)
      (free ?up)
      (not (at-robot ?up))
      (not (at-box ?b ?boxcell))
      (not (free ?down))
    )
  )

  (:action push-right
    :parameters (?r - robot ?b - box ?left - cell ?boxcell - cell ?right - cell)
    :precondition (and
      (at-robot ?left)
      (at-box ?b ?boxcell)
      (dir-right ?left ?boxcell)
      (dir-right ?boxcell ?right)
      (free ?right)
    )
    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?right)
      (free ?left)
      (not (at-robot ?left))
      (not (at-box ?b ?boxcell))
      (not (free ?right))
    )
  )

  (:action push-left
    :parameters (?r - robot ?b - box ?right - cell ?boxcell - cell ?left - cell)
    :precondition (and
      (at-robot ?right)
      (at-box ?b ?boxcell)
      (dir-left ?right ?boxcell)
      (dir-left ?boxcell ?left)
      (free ?left)
    )
    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?left)
      (free ?right)
      (not (at-robot ?right))
      (not (at-box ?b ?boxcell))
      (not (free ?left))
    )
  )
)
