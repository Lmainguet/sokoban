(define (domain robot-monde)

  (:requirements :strips :typing)

  (:types
    robot
    box
    cell
  )

  (:predicates

    ;; Position du robot
    (at-robot ?c - cell)

    ;; Position d'une boîte
    (at-box ?b - box ?c - cell)

    ;; Mur
    (wall ?c - cell)

    ;; Objectif
    (goal ?c - cell)

    ;; Case libre pour une boîte
    (free ?c - cell)

    ;; Une boîte occupe actuellement un objectif
    (box-on-goal ?c - cell)

    ;; Adjacence
    (adjacent ?c1 - cell ?c2 - cell)

    ;; Directions
    (dir-up ?from - cell ?to - cell)
    (dir-down ?from - cell ?to - cell)
    (dir-left ?from - cell ?to - cell)
    (dir-right ?from - cell ?to - cell)
  )


  ;; ============================================================
  ;; DEPLACEMENT DU ROBOT
  ;; ============================================================

  (:action move

    :parameters (
      ?r - robot
      ?from - cell
      ?to - cell
    )

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


  ;; ============================================================
  ;; PUSH UP
  ;; ============================================================

  ;; Boîte qui n'est PAS sur un objectif
  ;; -> destination qui n'est PAS un objectif

  (:action push-up

    :parameters (
      ?r - robot
      ?b - box
      ?down - cell
      ?boxcell - cell
      ?up - cell
    )

    :precondition (and
      (at-robot ?down)
      (at-box ?b ?boxcell)

      (dir-up ?down ?boxcell)
      (dir-up ?boxcell ?up)

      (free ?up)

      (not (box-on-goal ?boxcell))
      (not (goal ?up))
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


  ;; Boîte NON objectif -> objectif
  (:action push-up-to-goal

    :parameters (
      ?r - robot
      ?b - box
      ?down - cell
      ?boxcell - cell
      ?up - cell
    )

    :precondition (and
      (at-robot ?down)
      (at-box ?b ?boxcell)

      (dir-up ?down ?boxcell)
      (dir-up ?boxcell ?up)

      (free ?up)

      (not (box-on-goal ?boxcell))
      (goal ?up)
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?up)
      (box-on-goal ?up)

      (free ?down)

      (not (at-robot ?down))
      (not (at-box ?b ?boxcell))
      (not (free ?up))
    )
  )


  ;; Boîte sur objectif -> case NON objectif
  (:action push-up-from-goal

    :parameters (
      ?r - robot
      ?b - box
      ?down - cell
      ?boxcell - cell
      ?up - cell
    )

    :precondition (and
      (at-robot ?down)
      (at-box ?b ?boxcell)

      (dir-up ?down ?boxcell)
      (dir-up ?boxcell ?up)

      (free ?up)

      (box-on-goal ?boxcell)
      (not (goal ?up))
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?up)

      (free ?down)

      (not (box-on-goal ?boxcell))
      (not (at-robot ?down))
      (not (at-box ?b ?boxcell))
      (not (free ?up))
    )
  )


  ;; Boîte objectif -> objectif
  (:action push-up-goal-to-goal

    :parameters (
      ?r - robot
      ?b - box
      ?down - cell
      ?boxcell - cell
      ?up - cell
    )

    :precondition (and
      (at-robot ?down)
      (at-box ?b ?boxcell)

      (dir-up ?down ?boxcell)
      (dir-up ?boxcell ?up)

      (free ?up)

      (box-on-goal ?boxcell)
      (goal ?up)
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?up)
      (box-on-goal ?up)

      (free ?down)

      (not (box-on-goal ?boxcell))
      (not (at-robot ?down))
      (not (at-box ?b ?boxcell))
      (not (free ?up))
    )
  )


  ;; ============================================================
  ;; PUSH DOWN
  ;; ============================================================

  (:action push-down

    :parameters (
      ?r - robot
      ?b - box
      ?up - cell
      ?boxcell - cell
      ?down - cell
    )

    :precondition (and
      (at-robot ?up)
      (at-box ?b ?boxcell)

      (dir-down ?up ?boxcell)
      (dir-down ?boxcell ?down)

      (free ?down)

      (not (box-on-goal ?boxcell))
      (not (goal ?down))
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


  (:action push-down-to-goal

    :parameters (
      ?r - robot
      ?b - box
      ?up - cell
      ?boxcell - cell
      ?down - cell
    )

    :precondition (and
      (at-robot ?up)
      (at-box ?b ?boxcell)

      (dir-down ?up ?boxcell)
      (dir-down ?boxcell ?down)

      (free ?down)

      (not (box-on-goal ?boxcell))
      (goal ?down)
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?down)
      (box-on-goal ?down)

      (free ?up)

      (not (at-robot ?up))
      (not (at-box ?b ?boxcell))
      (not (free ?down))
    )
  )


  (:action push-down-from-goal

    :parameters (
      ?r - robot
      ?b - box
      ?up - cell
      ?boxcell - cell
      ?down - cell
    )

    :precondition (and
      (at-robot ?up)
      (at-box ?b ?boxcell)

      (dir-down ?up ?boxcell)
      (dir-down ?boxcell ?down)

      (free ?down)

      (box-on-goal ?boxcell)
      (not (goal ?down))
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?down)

      (free ?up)

      (not (box-on-goal ?boxcell))
      (not (at-robot ?up))
      (not (at-box ?b ?boxcell))
      (not (free ?down))
    )
  )


  (:action push-down-goal-to-goal

    :parameters (
      ?r - robot
      ?b - box
      ?up - cell
      ?boxcell - cell
      ?down - cell
    )

    :precondition (and
      (at-robot ?up)
      (at-box ?b ?boxcell)

      (dir-down ?up ?boxcell)
      (dir-down ?boxcell ?down)

      (free ?down)

      (box-on-goal ?boxcell)
      (goal ?down)
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?down)
      (box-on-goal ?down)

      (free ?up)

      (not (box-on-goal ?boxcell))
      (not (at-robot ?up))
      (not (at-box ?b ?boxcell))
      (not (free ?down))
    )
  )


  ;; ============================================================
  ;; PUSH RIGHT
  ;; ============================================================

  (:action push-right

    :parameters (
      ?r - robot
      ?b - box
      ?left - cell
      ?boxcell - cell
      ?right - cell
    )

    :precondition (and
      (at-robot ?left)
      (at-box ?b ?boxcell)

      (dir-right ?left ?boxcell)
      (dir-right ?boxcell ?right)

      (free ?right)

      (not (box-on-goal ?boxcell))
      (not (goal ?right))
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


  (:action push-right-to-goal

    :parameters (
      ?r - robot
      ?b - box
      ?left - cell
      ?boxcell - cell
      ?right - cell
    )

    :precondition (and
      (at-robot ?left)
      (at-box ?b ?boxcell)

      (dir-right ?left ?boxcell)
      (dir-right ?boxcell ?right)

      (free ?right)

      (not (box-on-goal ?boxcell))
      (goal ?right)
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?right)
      (box-on-goal ?right)

      (free ?left)

      (not (at-robot ?left))
      (not (at-box ?b ?boxcell))
      (not (free ?right))
    )
  )


  (:action push-right-from-goal

    :parameters (
      ?r - robot
      ?b - box
      ?left - cell
      ?boxcell - cell
      ?right - cell
    )

    :precondition (and
      (at-robot ?left)
      (at-box ?b ?boxcell)

      (dir-right ?left ?boxcell)
      (dir-right ?boxcell ?right)

      (free ?right)

      (box-on-goal ?boxcell)
      (not (goal ?right))
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?right)

      (free ?left)

      (not (box-on-goal ?boxcell))
      (not (at-robot ?left))
      (not (at-box ?b ?boxcell))
      (not (free ?right))
    )
  )


  (:action push-right-goal-to-goal

    :parameters (
      ?r - robot
      ?b - box
      ?left - cell
      ?boxcell - cell
      ?right - cell
    )

    :precondition (and
      (at-robot ?left)
      (at-box ?b ?boxcell)

      (dir-right ?left ?boxcell)
      (dir-right ?boxcell ?right)

      (free ?right)

      (box-on-goal ?boxcell)
      (goal ?right)
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?right)
      (box-on-goal ?right)

      (free ?left)

      (not (box-on-goal ?boxcell))
      (not (at-robot ?left))
      (not (at-box ?b ?boxcell))
      (not (free ?right))
    )
  )


  ;; ============================================================
  ;; PUSH LEFT
  ;; ============================================================

  (:action push-left

    :parameters (
      ?r - robot
      ?b - box
      ?right - cell
      ?boxcell - cell
      ?left - cell
    )

    :precondition (and
      (at-robot ?right)
      (at-box ?b ?boxcell)

      (dir-left ?right ?boxcell)
      (dir-left ?boxcell ?left)

      (free ?left)

      (not (box-on-goal ?boxcell))
      (not (goal ?left))
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


  (:action push-left-to-goal

    :parameters (
      ?r - robot
      ?b - box
      ?right - cell
      ?boxcell - cell
      ?left - cell
    )

    :precondition (and
      (at-robot ?right)
      (at-box ?b ?boxcell)

      (dir-left ?right ?boxcell)
      (dir-left ?boxcell ?left)

      (free ?left)

      (not (box-on-goal ?boxcell))
      (goal ?left)
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?left)
      (box-on-goal ?left)

      (free ?right)

      (not (at-robot ?right))
      (not (at-box ?b ?boxcell))
      (not (free ?left))
    )
  )


  (:action push-left-from-goal

    :parameters (
      ?r - robot
      ?b - box
      ?right - cell
      ?boxcell - cell
      ?left - cell
    )

    :precondition (and
      (at-robot ?right)
      (at-box ?b ?boxcell)

      (dir-left ?right ?boxcell)
      (dir-left ?boxcell ?left)

      (free ?left)

      (box-on-goal ?boxcell)
      (not (goal ?left))
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?left)

      (free ?right)

      (not (box-on-goal ?boxcell))
      (not (at-robot ?right))
      (not (at-box ?b ?boxcell))
      (not (free ?left))
    )
  )


  (:action push-left-goal-to-goal

    :parameters (
      ?r - robot
      ?b - box
      ?right - cell
      ?boxcell - cell
      ?left - cell
    )

    :precondition (and
      (at-robot ?right)
      (at-box ?b ?boxcell)

      (dir-left ?right ?boxcell)
      (dir-left ?boxcell ?left)

      (free ?left)

      (box-on-goal ?boxcell)
      (goal ?left)
    )

    :effect (and
      (at-robot ?boxcell)
      (at-box ?b ?left)
      (box-on-goal ?left)

      (free ?right)

      (not (box-on-goal ?boxcell))
      (not (at-robot ?right))
      (not (at-box ?b ?boxcell))
      (not (free ?left))
    )
  )

)