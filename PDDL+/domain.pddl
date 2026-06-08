(define (domain robot-sensing-optimized)
    (:requirements :strips :typing :negative-preconditions :fluents :continuous-effects :time)
    
    (:types 
        robot 
        location 
        meal 
        ingredient - object
        fruit liquid - ingredient
    )
    
    (:predicates
        (robot-at ?r - robot ?l - location)
        (ingredient-at ?i - ingredient ?l - location)
        (holding ?r - robot ?i - ingredient)
        (hand-empty ?r - robot)
        (fridge-open)
        (fridge-zone ?l - location)
        (counter-zone ?l - location)
        (trash-zone ?l - location)
        (table-zone ?l - location)
        (in-bowl ?i - ingredient)
        (is-fresh ?i - ingredient)
        (inspected ?i - ingredient)
        (smoothie-prepared ?m - meal)

        ;; Flags for processes
        (moving-now ?r - robot ?l - location)
        (opening-fridge-now ?r - robot)
        (closing-fridge-now ?r - robot)
        (taking-now ?r - robot ?i - ingredient)
        (putting-down-now ?r - robot)
        (scanning-now ?r - robot ?i - ingredient)
        (smelling-now ?r - robot ?i - ingredient)
        (putting-in-bowl-now ?r - robot ?i - ingredient)
        (throwing-away-now ?r - robot ?i - ingredient)
        (blending-now ?r - robot ?m - meal)
        (busy ?r - robot)
    )

    (:functions
        (temperature ?l - location)
        (spoilage-level ?i - ingredient)
        (action-timer ?r - robot)
        (total-cost)
    )

    ;; ================= MOVING ===================
    (:action move
        :parameters (?r - robot ?from ?to - location)
        :precondition
        (and
            (robot-at ?r ?from)
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (moving-now ?r ?to)
            (not (robot-at ?r ?from))
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process move-process
        :parameters (?r - robot ?l - location)
        :precondition
        (moving-now ?r ?l)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-move
        :parameters (?r - robot ?to - location)
        :precondition
        (and
            (moving-now ?r ?to)
            (>= (action-timer ?r) 5.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (moving-now ?r ?to))
            (robot-at ?r ?to)
            (increase (total-cost) 5)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; ================== OPENING FRIDGE ==================
    (:action open-fridge
        :parameters (?r - robot ?l - location)
        :precondition
        (and
            (robot-at ?r ?l)
            (fridge-zone ?l)
            (not (fridge-open))
            (hand-empty ?r)
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (opening-fridge-now ?r)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process open-fridge-process
        :parameters (?r - robot)
        :precondition
        (opening-fridge-now ?r)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-open-fridge
        :parameters (?r - robot)
        :precondition
        (and
            (opening-fridge-now ?r)
            (>= (action-timer ?r) 2.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (opening-fridge-now ?r))
            (fridge-open)
            (increase (total-cost) 2)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; ================= CLOSING FRIDGE =================
    (:action close-fridge
        :parameters (?r - robot ?l - location)
        :precondition
        (and
            (robot-at ?r ?l)
            (fridge-zone ?l)
            (fridge-open)
            (hand-empty ?r)
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (closing-fridge-now ?r)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process closing-fridge-process
        :parameters (?r - robot)
        :precondition
        (closing-fridge-now ?r)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-close-fridge
        :parameters (?r - robot)
        :precondition
        (and
            (closing-fridge-now ?r)
            (>= (action-timer ?r) 2.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (closing-fridge-now ?r))
            (not (fridge-open))
            (increase (total-cost) 2)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; ======================= TAKING ========================
    (:action take
        :parameters (?r - robot ?i - ingredient ?l - location)
        :precondition
        (and
            (fridge-open)
            (ingredient-at ?i ?l)
            (robot-at ?r ?l)
            (fridge-zone ?l)
            (hand-empty ?r)
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (taking-now ?r ?i)
            (not (ingredient-at ?i ?l))
            (not (hand-empty ?r))
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process take-process
        :parameters (?r - robot ?i - ingredient)
        :precondition
        (taking-now ?r ?i)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-take
        :parameters (?r - robot ?i - ingredient)
        :precondition
        (and
            (taking-now ?r ?i)
            (>= (action-timer ?r) 1.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (taking-now ?r ?i))
            (holding ?r ?i)
            (increase (total-cost) 1)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; =========================== PUTTING DOWN ========================
    (:action put-down
        :parameters (?r - robot ?i - ingredient ?l - location)
        :precondition
        (and
            (robot-at ?r ?l)
            (table-zone ?l)
            (holding ?r ?i)
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (putting-down-now ?r)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process putting-down-process
        :parameters (?r - robot)
        :precondition
        (putting-down-now ?r)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-put-down
        :parameters (?r - robot ?i - ingredient ?l - location)
        :precondition
        (and
            (putting-down-now ?r)
            (>= (action-timer ?r) 1.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (putting-down-now ?r))
            (not (holding ?r ?i))
            (hand-empty ?r)
            (ingredient-at ?i ?l)
            (increase (total-cost) 1)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; ========================= INSPECTION ===========================
    ;; Scan mold
    (:action scan-mold
        :parameters (?r - robot ?f - fruit)
        :precondition
        (and
            (holding ?r ?f)
            (not (inspected ?f))
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (scanning-now ?r ?f)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process scan-process
        :parameters (?r - robot ?f - fruit)
        :precondition
        (scanning-now ?r ?f)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-scan-mold
        :parameters (?r - robot ?f - fruit)
        :precondition
        (and
            (scanning-now ?r ?f)
            (>= (action-timer ?r) 3.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (scanning-now ?r ?f))
            (inspected ?f)
            (increase (total-cost) 3)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; smell spoil
    (:action smell-spoil
        :parameters (?r - robot ?lq - liquid)
        :precondition
        (and
            (holding ?r ?lq)
            (not (inspected ?lq))
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (smelling-now ?r ?lq)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process smell-process
        :parameters (?r - robot ?lq - liquid)
        :precondition
        (smelling-now ?r ?lq)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-smell-spoil
        :parameters (?r - robot ?lq - liquid)
        :precondition
        (and
            (smelling-now ?r ?lq)
            (>= (action-timer ?r) 4.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (smelling-now ?r ?lq))
            (inspected ?lq)
            (increase (total-cost) 4)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; ================== PUTTING INTO A BOWL ==================
    (:action put-in-bowl
        :parameters (?r - robot ?i - ingredient ?l - location)
        :precondition
        (and
            (inspected ?i)
            (is-fresh ?i)
            (counter-zone ?l)
            (robot-at ?r ?l)
            (holding ?r ?i)
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (putting-in-bowl-now ?r ?i)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process bowl-process
        :parameters (?r - robot ?i - ingredient)
        :precondition
        (putting-in-bowl-now ?r ?i)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-put-in-bowl
        :parameters (?r - robot ?i - ingredient)
        :precondition
        (and
            (putting-in-bowl-now ?r ?i)
            (>= (action-timer ?r) 1.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (putting-in-bowl-now ?r ?i))
            (not (holding ?r ?i))
            (hand-empty ?r)
            (in-bowl ?i)
            (increase (total-cost) 1)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; ==================== THROWING AWAY ======================
    (:action throw-away
        :parameters (?r - robot ?l - location ?i - ingredient)
        :precondition
        (and
            (robot-at ?r ?l)
            (trash-zone ?l)
            (inspected ?i)
            (not (is-fresh ?i))
            (holding ?r ?i)
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (throwing-away-now ?r ?i)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process throwing-away-process
        :parameters (?r - robot ?i - ingredient)
        :precondition
        (throwing-away-now ?r ?i)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-throw-away
        :parameters (?r - robot ?l - location ?i - ingredient)
        :precondition
        (and
            (throwing-away-now ?r ?i)
            (>= (action-timer ?r) 1.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (throwing-away-now ?r ?i))
            (not (holding ?r ?i))
            (hand-empty ?r)
            (ingredient-at ?i ?l)
            (increase (total-cost) 1)
            (assign (action-timer ?r) 0.0)
        )
    )

    ;; ===================== BLENDING ===========================
    (:action blend
        :parameters (?r - robot ?l - location ?m - meal ?f - fruit ?lq - liquid)
        :precondition
        (and
            (robot-at ?r ?l)
            (counter-zone ?l)
            (not (fridge-open))
            (in-bowl ?f)
            (in-bowl ?lq)
            (not (busy ?r))
        )
        :effect
        (and
            (busy ?r)
            (blending-now ?r ?m)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process blend-process
        :parameters (?r - robot ?m - meal)
        :precondition
        (blending-now ?r ?m)
        :effect
        (increase (action-timer ?r) (* #t 1.0))
    )

    (:event end-blend
        :parameters (?r - robot ?m - meal)
        :precondition
        (and
            (blending-now ?r ?m)
            (>= (action-timer ?r) 10.0)
        )
        :effect
        (and
            (not (busy ?r))
            (not (blending-now ?r ?m))
            (smoothie-prepared ?m)
            (increase (total-cost) 10)
            (assign (action-timer ?r) 0.0)
        )
    )

    (:process spoilage
        :parameters (?i - ingredient ?l - location)
        :precondition
        (and
            (is-fresh ?i)
            (ingredient-at ?i ?l)
            (not (fridge-zone ?l))
            (not (in-bowl ?i))
        )
        :effect
        (increase (spoilage-level ?i) (* #t 0.05))
    )

    (:event food-spoils
        :parameters (?i - ingredient)
        :precondition
        (and
            (is-fresh ?i)
            (> (spoilage-level ?i) 10.0)
        )
        :effect
        (not (is-fresh ?i))
    )
)