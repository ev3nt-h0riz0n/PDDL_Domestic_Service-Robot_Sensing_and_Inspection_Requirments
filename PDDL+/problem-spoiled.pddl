(define (problem problem-spoiled)
    (:domain robot-sensing-inspecting)
    
    (:objects
        WallE - robot
        fridge counter table trash - location
        apple-smoothie - meal
        apple1 apple2 - fruit
        milk - liquid
    )
    
    (:init
        (robot-at WallE counter)
        (hand-empty WallE)
        (ingredient-at apple2 fridge)        
        (ingredient-at apple1 fridge)
        (ingredient-at milk fridge)

        (is-fresh apple2)        
        (is-fresh apple1)
        (is-fresh milk)
        
        (fridge-zone fridge)
        (counter-zone counter)
        (trash-zone trash)
        (table-zone table)
        
        ;; Ustawiamy spoilage-level blisko granicy (10.0), 
        ;; żeby podczas wykonywania akcji (np. przenoszenia) 
        ;; proces spoilage przekroczył 10.0
        (= (spoilage-level apple2) 8.0)
        (= (spoilage-level apple1) 2.0) 
        (= (spoilage-level milk) 0.0)
        
        (= (action-timer WallE) 0.0)
        (= (total-cost) 0)
    )
    
    (:goal
        (and
            (inspected apple1)
            (inspected apple2)
            (inspected milk)
            (smoothie-prepared apple-smoothie)
        )
    )
    
    (:metric minimize (total-cost))
)