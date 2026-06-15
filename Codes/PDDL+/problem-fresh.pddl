(define (problem problem-fresh)
    (:domain robot-sensing-inspecting)
    
    (:objects
        WallE - robot
        fridge counter table trash - location
        apple-smoothie - meal
        apple - fruit
        milk - liquid
    )
    
    (:init
        (robot-at WallE counter)
        (hand-empty WallE)
        
        (ingredient-at apple fridge)
        (ingredient-at milk fridge)
        
        (is-fresh apple)
        (is-fresh milk)
        
        (fridge-zone fridge)
        (counter-zone counter)
        (trash-zone trash)
        (table-zone table)
        
        (= (spoilage-level apple) 0.0)
        (= (spoilage-level milk) 0.0)
        (= (action-timer WallE) 0.0)
        (= (total-cost) 0)
    )
    
    (:goal
        (and
            (smoothie-prepared apple-smoothie)
        )
    )
    
    (:metric minimize (total-cost))
)