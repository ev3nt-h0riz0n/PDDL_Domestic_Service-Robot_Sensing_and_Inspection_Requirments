(define (problem problem_perfect_condition)
    (:domain robot-sensing-inspecting)
    
    (:objects
        WallE - robot
        fridge counter trash - location
        stawberry-smoothie - meal
        strawberry - fruit
        milk - liquid
    )
    
    (:init

        (robot-at WallE counter)
        (hand-empty WallE)
        (fridge-zone fridge)
        (counter-zone counter)
        (trash-zone trash)

        (ingredient-at milk fridge)
        (ingredient-at strawberry counter)

        (is-fresh milk)
        (is-fresh strawberry)

        (= (temperature counter) 22.0)  
        (= (temperature trash) 22.0)
        (= (temperature fridge) 4.0)  

        (= (spoilage-level milk) 0.0)
        (= (spoilage-level strawberry) 0.0)
    )
    
    (:goal
        (and
            (smoothie-prepared stawberry-smoothie)
            (not (fridge-open))
            (robot-at WallE counter)
        )
    )
)