## Known state problem output

(move walleye counter fridge) </br>
(open-fridge walleye fridge) </br>
(take-ingredient walleye milk fridge) </br>
(move walleye fridge counter) </br>
(put-in-bowl walleye milk counter)</br>
(move walleye counter fridge)</br>
(take-ingredient walleye banana fridge)</br>
(move walleye fridge counter)</br>
(put-in-bowl walleye banana counter)</br>
(move walleye counter fridge)</br>
(close-fridge walleye fridge)</br>
(move walleye fridge counter)</br>
(blend-smoothie walleye counter banana_smoothie banana milk)</br>

## Unknown state problem output - inspecting rotten food not forced

(move walleye counter fridge)</br>
(open-fridge walleye fridge)</br>
(take-ingredient walleye milk fridge)</br>
(smell-spoil walleye milk)</br>
(move walleye fridge counter)</br>
(put-in-bowl walleye milk counter)</br>
(move walleye counter fridge)</br>
(take-ingredient walleye banana fridge)</br>
(scan-mold walleye banana)</br>
(move walleye fridge counter)</br>
(put-in-bowl walleye banana counter)</br>
(move walleye counter fridge)</br>
(close-fridge walleye fridge)</br>
(move walleye fridge counter)</br>
(blend-smoothie walleye counter fruit_smoothie banana milk)</br>

## Unknown state problem output - inspecting rotten food forced

(move walleye counter fridge)</br>
(open-fridge walleye fridge)</br>
(take-ingredient walleye strawberry fridge)</br>
(move walleye fridge trash)</br>
(scan-mold walleye strawberry)</br>
(throw-away walleye trash strawberry)</br>
(move walleye trash fridge)</br>
(take-ingredient walleye milk fridge)</br>
(smell-spoil walleye milk)</br>
(move walleye fridge counter)</br>
(put-in-bowl walleye milk counter)</br>
(move walleye counter fridge)</br>
(take-ingredient walleye banana fridge)</br>
(scan-mold walleye banana)</br>
(move walleye fridge counter)</br>
(put-in-bowl walleye banana counter)</br>
(move walleye counter fridge)</br>
(close-fridge walleye fridge)</br>
(move walleye fridge counter)</br>
(blend-smoothie walleye counter fruit_smoothie banana milk)</br>

## Discussion
This section evaluates the Q1 Basic PDDL model based on the generated plans for the three scenarios (Known State, Unknown State - Not Forced, and Unknown State - Forced). It analyzes how the model handles uncertainty and addresses the project's guidelines.

### 1. Adherence to Modelling Guidelines

The generated plans prove that the domain successfully fulfills all three assignment guidelines:
* **Explicit Inspection Actions:** The sensing actions (`smell-spoil` and `scan-mold`) are modeled as separate operators with their own costs. They must be executed before the robot can use any ingredient.
* **Approximating Partial Knowledge:** By separating the objective reality (`is-fresh`) from the robot's knowledge (`inspected`), I simulated an unknown environment. The robot remains "blind" to the freshness of the ingredients until it scans them.
* **Inspection Affecting Planning Decisions:** This is clearly visible in the **Forced Unknown State** plan. When the robot inspects the rotten strawberry, it detects the defect and changes its strategy from meal preparation to a transit and execution of the `throw-away` action.

### 2. Analysis of Generated Plans

* **Scenario 1 (Known State):** Since the ingredients are already marked as `inspected` in the initial state, the optimization algorithm completely skips the sensing actions to minimize costs. The robot takes the shortest path to prepare the meal.
* **Scenario 2 (Unknown State - Not Forced):** Without initial knowledge, the robot is forced to inspect the ingredients. Because a fresh alternative (the banana) is available, the planner is opportunistic—it completely ignores the rotten strawberry to avoid unnecessary movement and potential risks.
* **Scenario 3 (Unknown State - Forced):** Forcing the disposal of the strawberry shows the full safety logic of the domain. The robot collects the fruit, scans it, detects the issue, and disposes of it in the trash. Once its hand is empty again, it switches to the backup plan (using the banana and milk).

### 3. Limitations of Classical PDDL for Uncertainty

While the Q1 model successfully forces a safe sequence of actions, the experiment highlights major limitations of classical PDDL when dealing with uncertainty:

1.  **The All-Knowing Planner Paradox:** In classical PDDL, the solver has full access to the problem file before generating the plan. The planner already "knows" the strawberry is rotten from the start. True online discovery is impossible; the robot merely simulates the process of gaining knowledge to satisfy pre-conditions.
2.  **Deterministic Outcomes:** Classical PDDL cannot model probabilistic sensing (e.g., a sensor with a 90% accuracy rate). The outcome of an inspection must be hardcoded and 100% predictable in the initial state.
3.  **Static World (No Continuous Time):** In Plans 2 and 3, the robot opens the fridge at the beginning, leaves it open (`fridge-open`) while moving to the counter to pour milk, and closes it only at the very end. In classical PDDL, time does not pass continuously, so keeping the fridge open has no negative consequences. This is highly unrealistic for a domestic environment.

For these reasons it seems convinient to switch from classical PDDL to PDDL+ to introduce continuous processes and instantaneous event. It will allow to implement real environment dynamics.