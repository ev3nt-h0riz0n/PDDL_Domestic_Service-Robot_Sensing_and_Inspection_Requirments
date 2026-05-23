(define (problem problem_known_state)
    (:domain robot-sensing-inspecting)

    (:objects
        walleye - robot
        fridge counter trash - location
        banana - fruit
        milk - liquid
        banana_smoothie - meal
    )
    (:init
        (= (total-cost) 0)

        (fridge-zone fridge)
        (counter-zone counter)
        (trash-zone trash)

        (robot-at walleye counter)
        (hand-empty walleye)
        (not (fridge-open))

        (ingredient-at banana fridge)
        (ingredient-at milk fridge)
        (is-fresh banana)
        (is-fresh milk)
        (inspected banana)
        (inspected milk)
    )

    (:goal
        (smoothie-prepared banana_smoothie)
    )

    (:metric minimize (total-cost))


)   