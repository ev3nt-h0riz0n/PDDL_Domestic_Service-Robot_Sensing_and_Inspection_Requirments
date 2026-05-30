# Assignment D2-V9: Domestic Service Robot - Sensing and Inspection Requirments.
Given assignment is a project from the "AI in Robotics 2" course at the University of Genoa. The project involves creating an action plan in PDDL and PDDL+.

# Overview
This project models kitchen area that contains three main zones:
* fridge zone,
* trash zone,
* counter zone.

<img src="images/img.jpg" alt="Kitchen illustration">

Autonomous one-hand robot was created to work as a kitchen assistant. His main objective is preparing a smoothie. To do so, it needs to find one fresh fruit and, one fresh milk and place it inside a blender bowl. The robot is equipped with vision system and eNose. He is capable of inspecting fruits to detect mold and sniff a milk to detect spoilage.

# Q1 - PDDL

## Domain
The domain logic for Q1 is implemented using Classical PDDL with action costs. It focuses on the symbolic, discrete state transitions required for the kitchen robot to successfully execute its tasks, while laying the foundational logic for future PDDL+.

### Predicates
* `(robot-at ?r - robot ?l - location)` – Tracks the localized position of the robot in the kitchen.
* `(ingredient-at ?i - ingredient ?l - location)` – Represents ingredient placement.
* `(holding ?r - robot ?i - ingredient)` – Indicates which item is currently in robot's hand. 
* `(hand-empty ?r - robot)` – Indicates whether robot's hand is occupied.
* `(fridge-open)` – Controls the global state of the fridge door (logic for future PDDL+)
* `(in-bowl ?i - ingredient)` – Identifies ingredients that have been successfully placed in the blender bowl.
* `(inspected ?i - ingredient)` – Marks whether an ingredient has undergone an inspection.
* `(is-fresh ?i - ingredient)` – Represents freshness status of an ingredient.
* `(smoothie-prepared ?m - meal)` – The main objectiv state.
* Spatial categorizers: `(fridge-zone ?l)`, `(counter-zone ?l)`, `(trash-zone ?l)` used to strictly map abstract actions to geometric realities.

### Numeric function
* `(total-cost)` – A global scalar accumulated with every executed action. Used to optimize robot actions.

### Actions

1. `move` (Cost: 5): Navigates the robot between kitchen zones.
2. `open-fridge` / `close-fridge` (Cost: 2): Changes fridge state. Requires a free manipulator.
3. `take-ingredient` (Cost: 1): Grabs an item from a specific location. Requires the fridge door to be open if the ingredient resides in the fridge zone, and a free manipulator.
4. `scan-mold` (Cost: 3) / `smell-spoil` (Cost: 4): Specialized sensing actions. They are heavily constrained by types: `scan-mold` can only be performed on a `fruit` object using the vision system, while `smell-spoil` can only target a `liquid` object using the eNose. Both actions require the robot to actively hold the item.
5. `put-in-bowl` (Cost: 1): Transfers a fresh and inspected ingredient into the blender.
6. `throw-away` (Cost: 1): If the inspection reveals that the food is not fresh, this action allows the robot to drop the unfresh ingredient into the trash.
7. `blend-smoothie` (Cost: 10): The final action. It can only execute if the fridge is fully closed and fresh fruit and fresh milk are inside the bowl.

## Problems and plans

To analyze how the robot handles initial knowledge, sensing constraints, and failure recovery, three test scenarios were created:

* `problem_known_state`: Simulates a fully calibrated, deterministic environment. Both `banana` and `milk` are predefined as `is-fresh` and `inspected`. In this example it is seen that robot skips every inspecting action.
* `problem_unknown_state`: Introduces a true task-planning challenge. Ingredients are placed inside the fridge, but they lack the `(inspected)` predicate. The fridge contains a fresh `banana`, fresh `milk`, and an uninspected `strawberry`. Crucially, the `strawberry` is intentionally left out of the `is-fresh` initialization list, meaning it is implicitly rotten due to the Closed World Assumption (CWA).
* `problem_unknown_state_forced`: Uses the same initial state as the unknown scenario but adds a hard constraint to the `(:goal)` state: ` (ingredient-at strawberry trash)`. This forces the planner to explicitly handle and recover from a food contamination event rather than simply choosing an optimal alternative.

### Known state problem output

(move WallE counter fridge) </br>
(open-fridge WallE fridge) </br>
(take-ingredient WallE milk fridge) </br>
(move WallE fridge counter) </br>
(put-in-bowl WallE milk counter)</br>
(move WallE counter fridge)</br>
(take-ingredient WallE banana fridge)</br>
(move WallE fridge counter)</br>
(put-in-bowl WallE banana counter)</br>
(move WallE counter fridge)</br>
(close-fridge WallE fridge)</br>
(move WallE fridge counter)</br>
(blend-smoothie WallE counter banana_smoothie banana milk)</br>

### Unknown state problem output - inspecting rotten food not forced

(move WallE counter fridge)</br>
(open-fridge WallE fridge)</br>
(take-ingredient WallE milk fridge)</br>
(smell-spoil WallE milk)</br>
(move WallE fridge counter)</br>
(put-in-bowl WallE milk counter)</br>
(move WallE counter fridge)</br>
(take-ingredient WallE banana fridge)</br>
(scan-mold WallE banana)</br>
(move WallE fridge counter)</br>
(put-in-bowl WallE banana counter)</br>
(move WallE counter fridge)</br>
(close-fridge WallE fridge)</br>
(move WallE fridge counter)</br>
(blend-smoothie WallE counter fruit_smoothie banana milk)</br>

### Unknown state problem output - inspecting rotten food forced

(move WallE counter fridge)</br>
(open-fridge WallE fridge)</br>
(take-ingredient WallE strawberry fridge)</br>
(move WallE fridge trash)</br>
(scan-mold WallE strawberry)</br>
(throw-away WallE trash strawberry)</br>
(move WallE trash fridge)</br>
(take-ingredient WallE milk fridge)</br>
(smell-spoil WallE milk)</br>
(move WallE fridge counter)</br>
(put-in-bowl WallE milk counter)</br>
(move WallE counter fridge)</br>
(take-ingredient WallE banana fridge)</br>
(scan-mold WallE banana)</br>
(move WallE fridge counter)</br>
(put-in-bowl WallE banana counter)</br>
(move WallE counter fridge)</br>
(close-fridge WallE fridge)</br>
(move WallE fridge counter)</br>
(blend-smoothie WallE counter fruit_smoothie banana milk)</br>


## Discussion
This section evaluates the Q1 Basic PDDL model based on the generated plans for the three scenarios (Known State, Unknown State - Not Forced, and Unknown State - Forced). It analyzes how the model handles uncertainty and addresses the project's guidelines.

### 1. Adherence to Modelling Guidelines

The generated plans prove that the domain successfully fulfills all three assignment guidelines:
* Explicit Inspection Actions: The sensing actions (`smell-spoil` and `scan-mold`) are modeled as separate operators with their own costs. They must be executed before the robot can use any ingredient.
* Approximating Partial Knowledge: By separating the objective reality (`is-fresh`) from the robot's knowledge (`inspected`), I simulated an unknown environment. The robot remains "blind" to the freshness of the ingredients until it scans them.
* Inspection Affecting Planning Decisions: This is clearly visible in the Forced Unknown State plan. When the robot inspects the rotten strawberry, it detects the defect and changes its strategy from meal preparation to a transit and execution of the `throw-away` action.

### 2. Limitations of Classical PDDL for Uncertainty

While the Q1 model successfully forces a safe sequence of actions, the experiment highlights major limitations of classical PDDL when dealing with uncertainty:

1.  The All-Knowing Planner Paradox: In classical PDDL, the solver has full access to the problem file before generating the plan. The planner already "knows" the strawberry is rotten from the start. True online discovery is impossible; the robot merely simulates the process of gaining knowledge to satisfy pre-conditions.
2.  Deterministic Outcomes: Classical PDDL cannot model probabilistic sensing (e.g., a sensor with a 90% accuracy rate). The outcome of an inspection must be hardcoded and 100% predictable in the initial state.
3.  Static World (No Continuous Time): In Plans 2 and 3, the robot opens the fridge at the beginning, leaves it open (`fridge-open`) while moving to the counter to pour milk, and closes it only at the very end. In classical PDDL, time does not pass continuously, so keeping the fridge open has no negative consequences. This is highly unrealistic for a domestic environment.

For these reasons it seems convinient to switch from classical PDDL to PDDL+ to introduce continuous processes and instantaneous event. It will allow to implement real environment dynamics.





# Assignment content

## Scenario
The robot must prepare a meal, but the state of some ingredients is unknown
(e.g., whether milk is fresh or spoiled). The robot must inspect ingredients
before use.
Inspection actions reveal the state of an object.

## Modelling Guidelines
<ul>
  <li>Represent inspection explicitly as an action.</li>
  <li>Avoid assuming full knowledge of the environment.</li>
  <li>Ensure that inspection affects planning decisions</li>
</ul>

## Q1 - Basic PDDL Model
It is mandatory to 
<ul>
  <li> Approximate sensing using explicit predicates </li>
  <li> Provide: one problem with known states, one requiring inspection predicates </li>
  <li> Provide: valid plans </li>
</ul>

## Q2 - PDDL+ Model
It is mandatory to
<ul>
  <li> Introduce a process modelling ingredient degradation over time. </li>
  <li> Introduce an event representing state change (e.g. spoilage)</li>
  <li> Show how sensing interacts with dynamic changes </li>
</ul>

## Discussion
Discuss given aspects:
<ul>
  <li> limitations of classical PDDL for uncertainty </li>
  <li> interaction between sensing and dynamics </li>
</ul>
