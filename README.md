A custom implementation of Utility AI framework. 

## Parts of Utility AI Framework
+ __UTILBrain__ -> serves as the "brain" of the utility ai where it updates its UTILAction children to generate their action scores, and then determines the action node with the best action score.
+ __UTILAction__ -> nodes that contains the action logic. Has UTILScorers as children nodes to provide consideration scores for the action node to generate its action score.
+ __UTILScorer__ -> abstract class that contains an abstract method for updating scores, and provides a method for obtaining its score.
+ __UTILAggregate__ -> extends from UTILScorer, aggregates scores from its children of UTILScorers.
+ __UTILConsideration__ -> extends from UTILScorer, formulates its consideration score from its source by either using a response curve or a custom response function.

## Demo
Included is a demo about a survivor stranded on an island. The survivor's goals are to maintain the firewood crackling by supplying it with wood, satisfy hunger by foraging for food, and restore energy by sleeping. The survivor, when performing actions, is locked into a specific goal until either its targeted score is satisfied, or the survivor ran out of energy and needs to sleep near the firewood.
---
![utility](https://github.com/user-attachments/assets/e3a788c9-6dca-4eae-b7fa-cf24b0c9c42a)
---
![utility2](https://github.com/user-attachments/assets/17fef2e2-d26e-4063-a0d3-a1f62df24ac4)
---
![utility3](https://github.com/user-attachments/assets/6de1c695-bdca-474b-a3e1-9450abb982b7)
---

