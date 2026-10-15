(define (problem pd01)
  (:domain robot-monde)

  (:objects
    r1 - robot
    b1 b2 b3 b4 b5 - box
    c1 c2 c3 c4 c5 c6 c7 c8 c9
    c10 c11 c12 c13 c14 c15 c16 c17 c18
    c19 c20 c21 c22 c23 c24 c25 c26 c27
    c28 c29 c30 c31 c32 c33 c34 c35 c36
    c37 c38 c39 c40 c41 c42 c43 c44 c45
    c46 c47 c48 c49 c50 c51 c52 c53 c54
    c55 c56 c57 c58 c59 c60 c61 c62 c63
    c64 c65 c66 c67 c68 c69 c70 c71 c72
    c73 c74 c75 c76 c77 c78 c79 c80 c81 - cell
  )

  (:init
    ;; Robot
    (at-robot c38)

    ;; Boîtes
    (at-box b1 c39)
    (at-box b2 c41)
    (at-box b3 c49)
    (at-box b4 c50)
    (at-box b5 c57)

    ;; Objectifs
    (goal c32)
    (goal c39)
    (goal c41)
    (goal c50)
    (goal c57)

    ;; Murs
    (wall c1) (wall c2) (wall c3) (wall c4) (wall c5) (wall c6) (wall c7) (wall c8) (wall c9)
    (wall c10)(wall c11)(wall c12)                    (wall c15)(wall c16)(wall c17)(wall c18)
    (wall c19)(wall c20)(wall c21)                    (wall c24)(wall c25)(wall c26)(wall c27)
    (wall c28) (wall c29)                             (wall c33)(wall c34)(wall c35)(wall c36)
    (wall c37)                                        (wall c42)(wall c43)(wall c44)(wall c45)
    (wall c46)           (wall c48)                            (wall c52)(wall c53) (wall c54)
    (wall c55)                                                                      (wall c63)
    (wall c64) (wall c65) (wall c66) (wall c67)                                     (wall c72)
    (wall c73)(wall c74)(wall c75)(wall c76)(wall c77)(wall c78)(wall c79)(wall c80)(wall c81)

    ;; Cases libres
    (free c13) (free c14)
    (free c22) (free c23)
    (free c30) (free c31) (free c32)
    (free c38)(free c40)
    (free c47) (free c51)
    (free c56)(free c58)(free c59)(free c60)(free c61)(free c62)
    (free c68) (free c69) (free c70) (free c71)

    ;; Adjacence
    (dir-right c1 c2) (dir-left c2 c1)
    (dir-right c2 c3) (dir-left c3 c2)
    (dir-right c3 c4) (dir-left c4 c3)
    (dir-right c4 c5) (dir-left c5 c4)
    (dir-right c5 c6) (dir-left c6 c5)
    (dir-right c6 c7) (dir-left c7 c6)
    (dir-right c7 c8) (dir-left c8 c7)
    (dir-right c8 c9) (dir-left c9 c8)


    (dir-right c10 c11) (dir-left c11 c10)
    (dir-right c11 c12) (dir-left c12 c11)
    (dir-right c12 c13) (dir-left c13 c12)
    (dir-right c13 c14) (dir-left c14 c13)
    (dir-right c14 c15) (dir-left c15 c14)
    (dir-right c15 c16) (dir-left c16 c15)
    (dir-right c16 c17) (dir-left c17 c16)
    (dir-right c17 c18) (dir-left c18 c17)


    (dir-right c19 c20) (dir-left c20 c19)
    (dir-right c20 c21) (dir-left c21 c20)
    (dir-right c21 c22) (dir-left c22 c21)
    (dir-right c22 c23) (dir-left c23 c22)
    (dir-right c23 c24) (dir-left c24 c23)
    (dir-right c24 c25) (dir-left c25 c24)
    (dir-right c25 c26) (dir-left c26 c25)
    (dir-right c26 c27) (dir-left c27 c26)


    (dir-right c28 c29) (dir-left c29 c28)
    (dir-right c29 c30) (dir-left c30 c29)
    (dir-right c30 c31) (dir-left c31 c30)
    (dir-right c31 c32) (dir-left c32 c31)
    (dir-right c32 c33) (dir-left c33 c32)
    (dir-right c33 c34) (dir-left c34 c33)
    (dir-right c34 c35) (dir-left c35 c34)
    (dir-right c35 c36) (dir-left c36 c35)


    (dir-right c37 c38) (dir-left c38 c37)
    (dir-right c38 c39) (dir-left c39 c38)
    (dir-right c39 c40) (dir-left c40 c39)
    (dir-right c40 c41) (dir-left c41 c40)
    (dir-right c41 c42) (dir-left c42 c41)
    (dir-right c42 c43) (dir-left c43 c42)
    (dir-right c43 c44) (dir-left c44 c43)
    (dir-right c44 c45) (dir-left c45 c44)


    (dir-right c46 c47) (dir-left c47 c46)
    (dir-right c47 c48) (dir-left c48 c47)
    (dir-right c48 c49) (dir-left c49 c48)
    (dir-right c49 c50) (dir-left c50 c49)
    (dir-right c50 c51) (dir-left c51 c50)
    (dir-right c51 c52) (dir-left c52 c51)
    (dir-right c52 c53) (dir-left c53 c52)
    (dir-right c53 c54) (dir-left c54 c53)


    (dir-right c55 c56) (dir-left c56 c55)
    (dir-right c56 c57) (dir-left c57 c56)
    (dir-right c57 c58) (dir-left c58 c57)
    (dir-right c58 c59) (dir-left c59 c58)
    (dir-right c59 c60) (dir-left c60 c59)
    (dir-right c60 c61) (dir-left c61 c60)
    (dir-right c61 c62) (dir-left c62 c61)
    (dir-right c62 c63) (dir-left c63 c62)


    (dir-right c64 c65) (dir-left c65 c64)
    (dir-right c65 c66) (dir-left c66 c65)
    (dir-right c66 c67) (dir-left c67 c66)
    (dir-right c67 c68) (dir-left c68 c67)
    (dir-right c68 c69) (dir-left c69 c68)
    (dir-right c69 c70) (dir-left c70 c69)
    (dir-right c70 c71) (dir-left c71 c70)
    (dir-right c71 c72) (dir-left c72 c71)


    (dir-right c73 c74) (dir-left c74 c73)
    (dir-right c74 c75) (dir-left c75 c74)
    (dir-right c75 c76) (dir-left c76 c75)
    (dir-right c76 c77) (dir-left c77 c76)
    (dir-right c77 c78) (dir-left c78 c77)
    (dir-right c78 c79) (dir-left c79 c78)
    (dir-right c79 c80) (dir-left c80 c79)
    (dir-right c80 c81) (dir-left c81 c80)


    ;; verticale 
    (dir-down c1 c10) (dir-up c10 c1)
    (dir-down c10 c19) (dir-up c19 c10)
    (dir-down c19 c28) (dir-up c28 c19)
    (dir-down c28 c37) (dir-up c37 c28)
    (dir-down c37 c46) (dir-up c46 c37)
    (dir-down c46 c55) (dir-up c55 c46)
    (dir-down c55 c64) (dir-up c64 c55)
    (dir-down c64 c73) (dir-up c73 c64)


    (dir-down c2 c11) (dir-up c11 c2)
    (dir-down c11 c20) (dir-up c20 c11)
    (dir-down c20 c29) (dir-up c29 c20)
    (dir-down c29 c38) (dir-up c38 c29)
    (dir-down c38 c47) (dir-up c47 c38)
    (dir-down c47 c56) (dir-up c56 c47)
    (dir-down c56 c65) (dir-up c65 c56)
    (dir-down c65 c74) (dir-up c74 c65)

    (dir-down c3 c12) (dir-up c12 c3)
    (dir-down c12 c21) (dir-up c21 c12)
    (dir-down c21 c30) (dir-up c30 c21)
    (dir-down c30 c39) (dir-up c39 c30)
    (dir-down c39 c48) (dir-up c48 c39)
    (dir-down c48 c57) (dir-up c57 c48)
    (dir-down c57 c66) (dir-up c66 c57)
    (dir-down c66 c75) (dir-up c75 c66)

    (dir-down c4 c13) (dir-up c13 c4)
    (dir-down c13 c22) (dir-up c22 c13)
    (dir-down c22 c31) (dir-up c31 c22)
    (dir-down c31 c40) (dir-up c40 c31)
    (dir-down c40 c49) (dir-up c49 c40)
    (dir-down c49 c58) (dir-up c58 c49)
    (dir-down c58 c67) (dir-up c67 c58)
    (dir-down c67 c76) (dir-up c76 c67)

    (dir-down c5 c14) (dir-up c14 c5)
    (dir-down c14 c23) (dir-up c23 c14)
    (dir-down c23 c32) (dir-up c32 c23)
    (dir-down c32 c41) (dir-up c41 c32)
    (dir-down c41 c50) (dir-up c50 c41)
    (dir-down c50 c59) (dir-up c59 c50)
    (dir-down c59 c68) (dir-up c68 c59)
    (dir-down c68 c77) (dir-up c77 c68)

    (dir-down c6 c15) (dir-up c15 c6)
    (dir-down c15 c24) (dir-up c24 c15)
    (dir-down c24 c33) (dir-up c33 c24)
    (dir-down c33 c42) (dir-up c42 c33)
    (dir-down c42 c51) (dir-up c51 c42)
    (dir-down c51 c60) (dir-up c60 c51)
    (dir-down c60 c69) (dir-up c69 c60)
    (dir-down c69 c78) (dir-up c78 c69)

    (dir-down c7 c16) (dir-up c16 c7)
    (dir-down c16 c25) (dir-up c25 c16)
    (dir-down c25 c34) (dir-up c34 c25)
    (dir-down c34 c43) (dir-up c43 c34)
    (dir-down c43 c52) (dir-up c52 c43)
    (dir-down c52 c61) (dir-up c61 c52)
    (dir-down c61 c70) (dir-up c70 c61)
    (dir-down c70 c79) (dir-up c79 c70)


    (dir-down c8 c17) (dir-up c17 c8)
    (dir-down c17 c26) (dir-up c26 c17)
    (dir-down c26 c35) (dir-up c35 c26)
    (dir-down c35 c44) (dir-up c44 c35)
    (dir-down c44 c53) (dir-up c53 c44)
    (dir-down c53 c62) (dir-up c62 c53)
    (dir-down c62 c71) (dir-up c71 c62)
    (dir-down c71 c80) (dir-up c80 c71)


    (dir-down c9 c18) (dir-up c18 c9)
    (dir-down c18 c27) (dir-up c27 c18)
    (dir-down c27 c36) (dir-up c36 c27)
    (dir-down c36 c45) (dir-up c45 c36)
    (dir-down c45 c54) (dir-up c54 c45)
    (dir-down c54 c63) (dir-up c63 c54)
    (dir-down c63 c72) (dir-up c72 c63)
    (dir-down c72 c81) (dir-up c81 c72)
  )


  (:goal (and
    (at-box b1 c39)
    (at-box b2 c41)
    (at-box b3 c32)
    (at-box b4 c50)
    (at-box b5 c57)
  ))
)
