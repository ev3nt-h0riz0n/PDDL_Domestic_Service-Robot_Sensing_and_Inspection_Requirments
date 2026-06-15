(define (domain robot-sensing-inspecting)
    (:requirements :strips :typing :negative-preconditions :action-costs)
    
    (:types
        location
        robot
        meal
        ingredient
        fruit liquid - ingredient
    )
    
    (:functions
        (total-cost)
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
        (in-bowl ?i - ingredient)
        (is-fresh ?i - ingredient)
        (inspected ?i - ingredient)
        (smoothie-prepared ?m - meal)
    )
    
    (:action move
        :parameters (?r - robot ?from ?to - location)
        :precondition (robot-at ?r ?from)
        :effect (and
            (not (robot-at ?r ?from))
            (robot-at ?r ?to)
            (increase (total-cost) 5)
        )    
    )

    (:action open-fridge
        :parameters (?r - robot ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (fridge-zone ?l)
            (not (fridge-open))
            (hand-empty ?r)
        )
        :effect (and
            (fridge-open)
            (increase (total-cost) 2)
        )
    )

    (:action close-fridge
        :parameters (?r - robot ?l - location)
        :precondition (and
            (robot-at ?r ?l)
            (fridge-zone ?l)
            (fridge-open)
            (hand-empty ?r)
        )
        :effect (and
            (not (fridge-open))
            (increase (total-cost) 2)
        )
    )

    (:action take-ingredient
        :parameters (?r - robot ?i - ingredient ?l - location)
        :precondition (and
            (fridge-open)
            (ingredient-at ?i ?l)
            (robot-at ?r ?l)
            (fridge-zone ?l)
            (hand-empty ?r)
        )
        :effect (and
            (not (hand-empty ?r))
            (holding ?r ?i)
            (not (ingredient-at ?i ?l))
            (increase (total-cost) 1)
        )
    )

    (:action scan-mold
        :parameters (?r - robot ?f - fruit)
        :precondition (and
            (not (inspected ?f))
            (holding ?r ?f)
        )
        :effect (and
            (inspected ?f)
            (increase (total-cost) 3)
        )
    )

    (:action smell-spoil
        :parameters (?r - robot ?lq - liquid)
        :precondition (and
            (holding ?r ?lq)
            (not (inspected ?lq))
        )
        :effect (and
            (inspected ?lq)
            (increase (total-cost) 4)
        )
    )

    (:action put-in-bowl
        :parameters (?r - robot ?i - ingredient ?l - location)
        :precondition (and
            (inspected ?i)
            (is-fresh ?i)
            (counter-zone ?l)
            (robot-at ?r ?l)
            (holding ?r ?i)
        )
        :effect (and
            (in-bowl ?i)
            (not (holding ?r ?i))
            (hand-empty ?r)
            (increase (total-cost) 1)
        )
    )

    (:action throw-away
        :parameters (?r - robot ?l - location ?i - ingredient)
        :precondition (and
            (robot-at ?r ?l)
            (trash-zone ?l)
            (inspected ?i)
            (not (is-fresh ?i))
            (holding ?r ?i)
        )
        :effect (and
            (not (holding ?r ?i))
            (hand-empty ?r)
            (ingredient-at ?i ?l)
            (increase (total-cost) 1)
        )
    )

    (:action blend-smoothie
        :parameters (?r - robot ?l - location ?m - meal ?f - fruit ?lq - liquid)
        :precondition (and
            (robot-at ?r ?l)
            (counter-zone ?l)
            (not (fridge-open))
            (in-bowl ?f)
            (in-bowl ?lq)
        )
        :effect (and
            (smoothie-prepared ?m)
            (increase (total-cost) 10)
        )
    )
)
