(define (domain robot-sensing-inspecting)
    (:requirements :strips :typing :negative-preconditions :action-costs :time :durative-actions :fluents)
    
    (:types
        location
        robot
        meal
        ingredient
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
        (in-bowl ?i - ingredient)
        (is-fresh ?i - ingredient)
        (inspected ?i - ingredient)
        (smoothie-prepared ?m - meal)
    )

    (:functions
        (temperature ?l - location)
        (spoilage-level ?i - ingredient)
    )
    
    (:durative-action move
        :parameters (?r - robot ?from ?to - location)
        :duration (= ?duration 5)
        :condition (at start (robot-at ?r ?from))
        :effect (and
            (at start (not (robot-at ?r ?from)))
            (at end (robot-at ?r ?to))
        )    
    )

    (:durative-action open-fridge
        :parameters (?r - robot ?l - location)
        :duration (= ?duration 2)
        :condition (and
            (over all (robot-at ?r ?l))
            (over all (fridge-zone ?l))
            (at start (not (fridge-open)))
            (at start (hand-empty ?r))
        )
        :effect (and
            (at end (fridge-open))
        )
    )

    (:durative-action close-fridge
        :parameters (?r - robot ?l - location)
        :duration (= ?duration 2)
        :condition (and
            (over all (robot-at ?r ?l))
            (over all (fridge-zone ?l))
            (at start (fridge-open))
            (at start (hand-empty ?r))
        )
        :effect (and
            (at end (not (fridge-open)))
        )
    )

    (:durative-action take-ingredient
        :parameters (?r - robot ?i - ingredient ?l - location)
        :duration (= ?duration 1)
        :condition (and
            (over all (fridge-open))
            (at start (ingredient-at ?i ?l))
            (over all (robot-at ?r ?l))
            (over all (fridge-zone ?l))
            (at start (hand-empty ?r))
        )
        :effect (and
            (at start (not (hand-empty ?r)))
            (at start (holding ?r ?i))
            (at start (not (ingredient-at ?i ?l)))
        )
    )

    (:durative-action scan-mold
        :parameters (?r - robot ?f - fruit)
        :duration (= ?duration 3)
        :condition (and
            (at start (not (inspected ?f)))
            (over all (holding ?r ?f))
        )
        :effect (and
            (at end (inspected ?f))
        )
    )

    (:durative-action smell-spoil
        :parameters (?r - robot ?lq - liquid)
        :duration (= ?duration 4)
        :condition (and
            (over all (holding ?r ?lq))
            (at start (not (inspected ?lq)))
        )
        :effect (and
            (at end (inspected ?lq))
        )
    )

    (:durative-action put-in-bowl
        :parameters (?r - robot ?i - ingredient ?l - location)
        :duration (= ?duration 1)
        :condition (and
            (at start (inspected ?i))
            (over all (is-fresh ?i))
            (over all (counter-zone ?l))
            (over all (robot-at ?r ?l))
            (at start (holding ?r ?i))
        )
        :effect (and
            (at end (in-bowl ?i))
            (at end (not (holding ?r ?i)))
            (at end (hand-empty ?r))
        )
    )

    (:durative-action throw-away
        :parameters (?r - robot ?l - location ?i - ingredient)
        :duration (= ?duration 1)
        :condition (and
            (over all (robot-at ?r ?l))
            (over all (trash-zone ?l))
            (at start (inspected ?i))
            (at end (not (is-fresh ?i)))
            (at start (holding ?r ?i))
        )
        :effect (and
            (at end (not (holding ?r ?i)))
            (at end (hand-empty ?r))
            (at end (ingredient-at ?i ?l))
        )
    )

    (:durative-action blend-smoothie
        :parameters (?r - robot ?l - location ?m - meal ?f - fruit ?lq - liquid)
        :duration (= ?duration 20)
        :condition (and
            (over all (robot-at ?r ?l)) 
            (over all (counter-zone ?l)) 
            (over all (not (fridge-open)))
            (over all (in-bowl ?f))
            (over all (in-bowl ?lq))
        )
        :effect (and
            (at end (smoothie-prepared ?m))
            (at end (not (in-bowl ?f)))
            (at end (not (in-bowl ?lq)))
        )
    )

    (:durative-action put-on-counter
        :parameters  (?r - robot ?i - ingredient ?l - location)
        :duration (= ?duration 1)
        :condition (and 
            (over all (robot-at ?r ?l))
            (over all (counter-zone ?l))
            (at start (holding ?r ?i))
        )
        :effect (and
            (at end (not (holding ?r ?i)))
            (at end (hand-empty ?r))
            (at end (ingredient-at ?i ?l))
        )
    )

    (:durative-action pick-from-counter
        :parameters (?r - robot ?i - ingredient ?l - location)
        :duration (= ?duration 1)
        :condition (and
            (over all (robot-at ?r ?l))
            (over all (counter-zone ?l))
            (at start (ingredient-at ?i ?l))
            (at start (hand-empty ?r))
        )
        :effect (and 
            (at start (not (ingredient-at ?i ?l)))
            (at start (holding ?r ?i))
            (at start (not (hand-empty ?r)))
        )
    )
    (:process fridge-warming
        :parameters ()
        :precondition (fridge-open)
        :effect (and
            (increase (temperature fridge) (* #t (* 0.1 (- (temperature counter) (temperature fridge))))) ;; t(0.1 * (22.0 - temperature)
        )
    )
    (:process fridge-cooling
        :parameters ()
        :precondition (and
            (not (fridge-open))
            (> (temperature fridge) 4.0)
        )
        :effect (and
            (decrease (temperature fridge) (* #t (* 0.04 (- (temperature fridge) 4.0))))) ;; t(0.04 * (temperature - 4.0)
    )

    (:process spoilage-at-location
        :parameters (?i - ingredient ?l - location)
        :precondition (and
            (ingredient-at ?i ?l)
            (not (in-bowl ?i))
        )
        :effect (and
            (increase (spoilage-level ?i) (* #t (* 0.008 (* (+ (temperature ?l) 1.0) (+ (temperature ?l) 1.0))))) ;; t(0.008 * (temperature +1)^2)
        )
    )

    (:process spoilage-in-hand
        :parameters (?r - robot ?i - ingredient)
        :precondition (and
            (holding ?r ?i)
            (not (in-bowl ?i))
        )
        :effect (and
            (increase (spoilage-level ?i) (* #t (* 0.008 (* (+ (temperature counter) 1.0) (+ (temperature counter) 1.0))))) 
        )
    )

    (:event food-spoils
        :parameters (?i - ingredient)
        :precondition (and
            (is-fresh ?i)
            (>= (spoilage-level ?i) 100.0)    
        )
        :effect (and
            (not (is-fresh ?i))
        )
    )
)
