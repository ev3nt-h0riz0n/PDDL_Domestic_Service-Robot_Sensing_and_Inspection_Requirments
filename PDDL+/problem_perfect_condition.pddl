(define (problem smoothie-prep-01)
    (:domain robot-sensing-optimized)
    
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
        
        ;; Rozmieszczenie składników
        (ingredient-at apple fridge)
        (ingredient-at milk fridge)
        
        ;; Właściwości składników
        (is-fresh apple)
        (is-fresh milk)
        
        ;; Konfiguracja stref
        (fridge-zone fridge)
        (counter-zone counter)
        (trash-zone trash)
        (table-zone table)
        
        ;; Inicjalizacja funkcji
        (= (temperature fridge) 5.0)
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