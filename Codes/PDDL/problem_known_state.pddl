(define (problem problem_known_state)
    (:domain robot-sensing-inspecting)

    (:objects
        WallE - robot
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

        (robot-at WallE counter)
        (hand-empty WallE)

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