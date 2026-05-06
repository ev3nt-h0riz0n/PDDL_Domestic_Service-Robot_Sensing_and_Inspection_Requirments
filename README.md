# Assignment D2-V9: Domestic Service Robot - Sensing and Inspection Requirments.
Given assignment is a project from the "AI in Robotics 2" course at the University of Genoa. The project involves creating an action plan in PDDL and PDDL+.

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
