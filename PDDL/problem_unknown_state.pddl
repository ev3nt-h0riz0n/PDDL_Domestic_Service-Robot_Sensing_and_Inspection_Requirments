(define (problem problem_unknown_state)
    (:domain robot-sensing-inspecting)

    (:objects
        walleye - robot
        fridge counter trash - location
        banana strawberry - fruit
        milk - liquid
        fruit_smoothie - meal
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
        (ingredient-at strawberry fridge)
        (not (is-fresh strawberry))
        (is-fresh banana)
        (is-fresh milk)
    )

    (:goal
        (smoothie-prepared fruit_smoothie)
    )

    (:metric minimize (total-cost))


)   