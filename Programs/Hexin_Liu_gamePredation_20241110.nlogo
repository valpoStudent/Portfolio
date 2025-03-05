; Code based on the codes from peers (including Ms. Anders)

; Code based on Railsbeck's and Grimm's "Agent-Based and Individual-Based Modeling: A Practical Introduction", Netlogo dictionary, Netlogo user manual, and Netlogo user manual on extensions
extensions [csv]  ;Code from Netlogo dictionary (reveals how to 'install' extensions)

; Breeds code section based on codes from peers in Simulation and Modeling and Netlogo dictionary's examples
breed[preys prey]
breed[predators predator]
breed[hunters hunter]
breed[plants plant]

globals [organismSize
  preyPopulation
  predatorPopulation
  deathRateForEaten
  blockArea
  ;overall-birth-rate
  ;prey-stamina
  ;predator-stamina
  prey-energy
  ;predator-energy
  hunter-population
  ;hunter-stamina
  hunter-energy  ; Formation based on Simulation and Modeling Canvas Materials and how my peers have organized the declaration of globals (global variables)
]  ;The last seven variables are what the model mostly focuses on (for now)     ; Note: this globals code section is based on Simulation and Modeling Canvas, Netlogo Dictionary, and Railsback and Grimm (Simulation and Modeling Canvas, Netlogo Dictionary, Railsback and Grimm).

to setup
  ca
  clear-output
  file-open "Hexin_Liu_alldata_09062024.csv" ; Import Code based on Railsbeck's and Grimm's "Agent-Based Modeling: A Practical Introduction" textbook
  while [not file-at-end?]
  [
    let line file-read-line
    if (is-string? item 0 csv:from-row line = False) [ ; Is-string? excerpted from Netlogo Dictionary (It prevents the first line, which contains strings, to be 'printed' to the output)
      let newLine csv:from-row line    ; Idea based on Netlogo user manual's csv:from-row primative
      set organismSize item 0 newLine  ; Item primative from Netlogo dictionary
      set preyPopulation item 1 newLine
      set predatorPopulation item 2 newLine
      set deathRateForEaten item 3 newLine
      set blockArea item 4 newLine

      output-print (word "Values : "  organismSize " " preyPopulation " " predatorPopulation " " deathRateForEaten " "blockArea) ; Idea based on Netlogo dictionary and Netlogo user manual (The file-read-line is the only method that works for CSV files)
    ]

  ]
  file-close
  ;crt 1 [set size organismSize]  ; Creating a turtle with a size of organismSize
  ; Prey turtles (based on Railsback and Grimm, Netlogo Dictionary, Simulation and Modeling Canvas)
  ;crt 80 [set color red setxy random-xcor random-ycor]
  create-preys number-of-preys ;80
  [set color red setxy random-xcor random-ycor]   ; Prey version of the above code
  ; Predator turtles (based on Railsback and Grimm, Netlogo Dictionary, Simulation and Modeling Canvas)
  ;crt 10 [set color blue setxy random-xcor random-ycor]
  create-predators number-of-predators ;10
  [set color blue setxy random-xcor random-ycor]
  ; Hunter turtles  (based on Railsback and Grimm, Netlogo Dictionary, Simulation and Modeling Canvas)
  ;crt 10 [set color yellow set shape "person" setxy random-xcor random-ycor]
  create-hunters number-of-hunters ;10
  [set color yellow set shape "person" setxy random-xcor random-ycor]
  ; Making the patch green (based on Railsback and Grimm and Netlogo Dictionary)
  ask patches [set pcolor green]
  ; Creating our plants
  produce-vegetation-with-logistic-function
  ; Initalizing the stamina and energy variables (population is ignored for now)
  ;set overall-birth-rate 1.0   ; Make the birth rate for the organisms 1.0 (temporary)
  set prey-stamina 100
  set predator-stamina 100
  set hunter-stamina 100
  set prey-energy 100
  set predator-energy 100
  set hunter-energy 100
  reset-ticks
end   ; Note: the setup code uses elements from Simulation and Modeling Canvas, Railsback and Grimm, and Netlogo Dictionary (Simulation and Modeling Canvas, Railsback and Grimm, and Netlogo Dictionary).

to go; Based on Simulation and Modeling Canvas, Netlogo Dictionary, Railsback and Grimm...This is also based on the mushroom hunter model's go procedure.
  move-around  ; This allows the turtle to have movement (Simulation and Modeling Canvas, Railsback and Grimm).
  increase-birth-rate-with-bern-dist   ; Decide if the organism decides on increasing the birth rate
  show word "Birth-Rate: " overall-birth-rate  ; For demonstration purposes. Code based on Netlogo dictionary and previous versions of gamePredation model (gamePredation Model, Netlogo Dictionary).
  be-eaten-prey
  be-eaten-predator
  reduce-predator-energy
  die-of-hunger-for-predators
  give-birth
  set-birth-rate-to-default
  decrease-stamina
  stop-for-rest
  ;organisms-perish
  tick ; Allowing the ticks to go by (Railsback and Grimm, Simulation and Modeling Canvas).
  if ticks >= 3500 [stop] ;If ticks is equal or greater than 3500, stop the model (Railsback and Grimm, Simulation and Modeling Canvas).
end ; End of go procedure. The go code is based on Simulation and Modeling Canvas, Netlogo Dictionary, and Railsback and Grimm (Railsback and Grimm, Netlogo Dictionary, Simulation and Modeling Canvas).

to move-around ; The turtles take a random leftward degree from 0 to (roughly) 360 (Railsback and Grimm) and move forward by 0 to (roughly) 15 steps (Railsback and Grimm) (Based on Railsback and Grimm) [Ignore]. This is also based on Railsback and Grimm's mushroom hunter model's movement procedure.
  ;ask turtles [
  ;  lt random 360
  ;  fd random 15
  ;] ;Similar to the mushroom hunter model but using the left primitive and also putting a random primative for forward primitive (Railsback and Grimm)
  ; Alternative (and even modified) 'move' procedure with a loop code block
  ask (turtle-set preys predators hunters) [ ; turtles [
    repeat 5 [ ; A loop Statement for the move-around procedure
      ask preys [ ; turtles with [color = red] [
        ; (ignore) if any? up-to-n-of 1 (turtle-set predators hunters) in-radius 3 [ ; turtles with [color = blue or color = yellow] in-radius 3 [   ; If there are any predator turtles within the radius of 3
        if rand-bern 0.5 [
          let potential-nearby-hunters hunters-on neighbors  ; Code based on Netlogo Dictionary (Netlogo Dictionary)
          let potential-nearby-predators predators-on neighbors ; Code based on Netlogo Dictionary (Netlogo Dictionary)
          if any? potential-nearby-predators or any? potential-nearby-hunters [ ; Code based on the previous versions of gamePredation model and the Netlogo Dictionary (gamePredation model, Netlogo Dictionary). If there are any predators or hunters...
            ; Assigning the pred-heading to the heading of an predator (either non-hunter or hunter) that has the maximum heading within the radius of 3. This makes the pred-heading to be the maximum heading of the group of predators in the radius of 3.
            if any? predators [
              show word "Distance of prey and predator: " distance one-of predators ; Code based on previous versions of gamePredation model and Netlogo Dictionary (gamePredation Model, Netlogo Dictionary).
            ]
            let pred-heading [heading] of max-one-of up-to-n-of 1 (turtle-set potential-nearby-hunters potential-nearby-predators) [heading] ;turtles with [color = blue or color = yellow] in-radius 3 [heading]  ; Code based on previous model version of the gamePredation model and Netlogo dictionary (gamePredation model, Netlogo Dictionary).
            set heading pred-heading * -1  ; Make the heading the opposite direction (Netlogo Dictionary, gamePredation model).
            foreach (list (random 25) (random 25) (random 25)) [x -> fd x] ; For each item in this provided list, move the prey turtles forward by this value. Based on Netlogo dictionary (especially with Netlogo dictionary's examples). This is the loop statement.

          ]
        ]
      ]
      rt random 360
      ifelse prey-stamina > 0 or predator-stamina > 0 or hunter-stamina > 0 [
        fd random 15
      ] [
        let reduced-speed random 8 + 1
        fd reduced-speed
      ] ; Code section of the ifelse statement based on Netlogo Dictionary and the gamePredation model (Netlogo Dictionary, gamePredation Model).
    ]
  ]  ; The ask statement is based on the Mousetrap code from the Railsback and Grimm textbook (especially in the Powerpoint slides), the Railsback and Grimm textbook, and the Simulation and Modeling Canvas materials. Also used Netlogo dictionary on constructing the code.
     ; The ask statement also used the previous code for the move-around procedure (see above), which is based on Railsback's and Grimm's Mushroom Hunter model.
end ; End of move-around procedure. The move-around code is based on Simulation and Modeling Canvas, Netlogo Dictionary, and Railsback and Grimm (Railsback and Grimm, Netlogo Dictionary, Simulation and Modeling Canvas).

to increase-birth-rate-with-bern-dist
  ask turtles [  ; Asking the turtles
    let prob-of-birth 0.7    ; For now, make prob-of-birth (the chance of giving birth) into a local variable
    if rand-bern prob-of-birth [
      set overall-birth-rate overall-birth-rate + 0.01
    ]
  ]
end

to be-eaten-prey  ; For Prey
  let initial-prey-count count(preys) ; Setting our initial prey count to the number of prey before the death of one of the prey
  ask preys [ ; up-to-n-of 1 preys [
    ; If there are any predators or hunters in the radius of 3.5
    ;if any? (turtle-set predators hunters) in-radius 0.5 [ ; Comment: it will not work if you set this radius less than the sensing radius (radius located in move-around procedure)
    let potential-hunters-on-prey hunters-on patch-here
    let potential-predators-on-prey predators-on patch-here
    if any? potential-hunters-on-prey or any? potential-predators-on-prey [
      die
      show "Decrease in number."  ; Based on Netlogo's dictionary example, especially for any? entry in the Netlogo dictionary
  ]
  ]
  if initial-prey-count > count(preys) [  ; If the initial number of prey is greater than the current number of prey  ; Based on Netlogo Dictionary (especially for the globals entry and set entry)
    set predator-energy predator-energy + 5  ; Increment the predators' energy by 10
  ]
end

to be-eaten-predator  ; The Procedure code based on the previous versions of the gamePredation model (especially for the to-be-eaten model) (gamePredator Model)
  ask predators [  ; The ask code section based on the be-eaten-prey procedure
    let potential-hunters hunters-on patch-here
    if any? potential-hunters [
      die
    ]
  ]
end

to-report number-of-organisms [organisms]  ; Outputting the number of a specified organism
  report count organisms
end

to reduce-predator-energy  ; Subtracting the predator's energy
  ;output-print
  show (word "Predator's energy: " predator-energy)  ; Seeing the current state of the predator's energy
  set predator-energy predator-energy - 1
  if predator-energy < 0 [  ; If the predator's energy is less than 0, set it to 0.
    set predator-energy 0
  ]
end

to die-of-hunger-for-predators  ; Making the predators die of hunger
  ask up-to-n-of 1 predators [
    if predator-energy <= 0 [  ; If the predator's energy is less than or equals to zero, die
      die
    ]
  ]
end

to produce-vegetation-with-logistic-function   ; Idea based on Canvas
  ; Code based on the logistic function description from Railsback and Grimm.
  let probVeg1 random-normal 0.8 0.01
  if probVeg1 > 1 or probVeg1 < 0 [
    set probVeg1 0.8
  ]
  let probVeg2 probVeg1 + 0.03
  let numOfPrey1 count preys
  let numOfPrey2 numOfPrey1 - 35
  let d ln(probVeg1 / (1 - probVeg1))
  let c ln(probVeg2 / (1 - probVeg2))
  let b (d - c) / (numOfPrey1 - numOfPrey2)
  let a d - (b * numOfPrey1)
  let z exp(a + (b * numOfPrey2))
  let trueProbOfVeg z / (1 + z)
  let numOfVeg round(numOfPrey1 * trueProbOfVeg)
  create-plants numOfVeg [set color lime set shape "leaf" setxy random-xcor random-ycor]  ; Initializing our vegetations
end

to give-birth  ; Used Netlogo Dictionary in constructing the procedure
  ifelse overall-birth-rate <= 5.0 [
    ask one-of turtles [hatch 1]
  ] [
    ask one-of turtles [hatch 3]
  ]
end

to set-birth-rate-to-default   ; Used Netlogo Dictionary in constructing the procedure
  if overall-birth-rate > 10 [ ; Make the birth-rate 1.0 again if it exceeds 10
    set overall-birth-rate 1.0
  ]
end

; Ignore
to organisms-perish  ; Used Netlogo Dictionary in constructing the procedure
  if count(turtles) > 500 [
    let number-of-dying-prey count(turtles) - 100
    ask up-to-n-of number-of-dying-prey turtles [
      die
    ]
  ]
end
; End of ignore

to decrease-stamina  ; Used Netlogo Dictionary in constructing the procedure
  set prey-stamina prey-stamina - 1  ; Decrementing the stamina
  set predator-stamina predator-stamina - 1
  set hunter-stamina hunter-stamina - 1
  if prey-stamina < 0 or predator-stamina < 0 or hunter-stamina < 0 [ ; Make sure that the staminas remained zero
    set prey-stamina 0
    set predator-stamina 0
    set hunter-stamina 0
  ]
  show (word "Stamina: " prey-stamina " " predator-stamina " " hunter-stamina) ; Debug the stamina
end

to stop-for-rest
  let resting-organism one-of turtles  ; Defining our 'tired' organism
  ask resting-organism [ ; Asking the 'tired' organism
  if prey-stamina = 0 or predator-stamina = 0 or hunter-stamina = 0 [ ; If either prey-stamina, predator-stamina, or hunter stamina is 0
    every 1 [ ; Code based on Netlogo Dictionary (Netlogo Dictionary). The every primative means do it for each of the one second.
        ask resting-organism [ ; Code based on Netlogo Dictionary (Netlogo Dictionary). Asking the agent (the resting organism) to execute this command.
          fd 0 ; For every one second, move forward 0 (in other words, stop and rest).
        ]
    ]  ; Code section of the every command based on Netlogo Dictionary (Netlogo Dictionary). This code will ensure that the organism stops and has rest for every one second (Netlogo Dictionary).
    if is-prey? resting-organism [ ; If the 'tired' organism is a prey
        set prey-stamina prey-stamina + 20  ; Set its stamina by incrementing it by 20
      ]
    if is-predator? resting-organism [
        set predator-stamina predator-stamina + 20
      ]
    if is-hunter? resting-organism [
        set hunter-stamina hunter-stamina + 20
      ]
    ]
  ]
end


to-report rand-bern [given-prob]   ; Rand-bern code based on Railsback and Grimm (Railsback and Grimm)
  if (given-prob > 1.0 or given-prob < 0.0) [
    set given-prob 0.5 ; Make the given probability 0.5
  ]
  report random-float 1.0 < given-prob
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
777
578
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-21
21
-21
21
0
0
1
ticks
30.0

BUTTON
49
38
112
71
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
58
101
121
134
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

OUTPUT
10
190
202
370
11

MONITOR
10
393
67
438
Preys
number-of-organisms preys
17
1
11

MONITOR
105
402
172
447
Predators
number-of-organisms predators
17
1
11

SLIDER
16
478
188
511
overall-birth-rate
overall-birth-rate
0
10
7.21999999999989
0.01
1
NIL
HORIZONTAL

SLIDER
14
519
186
552
predator-energy
predator-energy
0
100
350.0
1
1
NIL
HORIZONTAL

SLIDER
12
569
184
602
prey-stamina
prey-stamina
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
13
659
185
692
predator-stamina
predator-stamina
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
11
618
183
651
hunter-stamina
hunter-stamina
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
256
618
428
651
number-of-preys
number-of-preys
1
100
80.0
1
1
NIL
HORIZONTAL

SLIDER
478
620
650
653
number-of-predators
number-of-predators
1
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
271
670
443
703
number-of-hunters
number-of-hunters
1
100
10.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
# Model ODD Description
One piece of data that is useful for this predation model is the use of Lotka-Volterra model in the predation model from www.jondarkow.com, a simulation website ("Predator-Prey Lotka-Volterra Model"). As described in the website, the Lotka-Volterra model highlights on the negative feedback in the prey-predator relations ("Predator-Prey Lotka-Volterra Model"). The consideration of the negative feedback can be useful in observing how the prey interacts with predators ("Predator-Prey Lotka-Volterra Model"). While the website's Lotka-Volterra model has good aspects to incorportate into this model, Netlogo's sheep-wolf predation model is also an ideal option for studying predation as this model is readily available to analyze and build upon ("Netlogo Wolf-Sheep Predation Model"). Netlogo's sheep-wolf predation model contains variables, including the initial amounts of predator and prey and the energy obtained from eating food. On the other hand, Netlogo's Wolf-Sheep-Stride-Inheritance model is similar to the wolf-sheep model but includes the stride variable, making it a potential guide on how to incorportate stride in this constructed model ("Netlogo Wolf-Sheep Stride Model"). This model will also have aspects from Scott Garrigan's virus model and Netlogo's tutorial 3 model to make sure that the entities are interacting with each other properly (for example, the predator eating the prey) and reproducing offsprings ("Virus Model", "Netlogo's Tutorial 3"). Netlogo's Tutorial 1 is insightful in brainstorming the necessary components for this model (such as buttons and outputs) ("Netlogo's Tutorial 1").

The two datasets that will be used to construct this model will be the tadpoles-predators dataset from McCoy et al. and the Lynx and Roe Deer dataset made by Andren et al. (Andren et al., Mccoy et al.). The tadpoles-predations focused on the predations of tadpoles (McCoy et al.), while the Lynx and Roe Deer dataset is more towards the predation of deers by Lynxes (Andren et al.).
 
Here are the main websites (sources) that I will based the model upon : 

https://sites.google.com/site/biologydarkow/ecology/predator-prey-simulation-of-the-lotka-volterra-model

https://ccl.northwestern.edu/netlogo/models/WolfSheepPredation

https://ccl.northwestern.edu/papers/wolfsheep.pdf

https://ccl.northwestern.edu/netlogo/models/WolfSheepStrideInheritance

https://www.youtube.com/watch?v=zzr6aJudoRI

https://ccl.northwestern.edu/netlogo/docs/tutorial3.html

https://ccl.northwestern.edu/netlogo/docs/tutorial1.html

https://zenodo.org/records/4932157 (Dataset)

https://zenodo.org/records/8368566 (Dataset)

Hexin_Liu_alldata_09062024.csv  (Dataset Used for the model)

(Honor Code: I have neither given or received nor have I tolerated others' use of unauthorized aid.   Hexin Liu)


## 1. Purpose and Patterns
Ecologists have studied one of the most researched topic known as predation. One model that addressed predation and its effects on the prey-predator populations is the Lotka-Volterra model ("Predator-Prey Lotka-Volterra Model"). The Lotka-Volterra model emphasizes on how the populations fluctuate as births and deaths change ("Predator-Prey Lotka-Volterra Model"). Like the Votka-Volterra model, the Netlogo model depicts a realistic prey-predator interactions in consideration of births and deaths ("Predator-Prey Lotka-Volterra Model", "Netlogo Wolf-Sheep Predation Model"). The most important similarity that the two models have are that these two models are applied to an assumption where there is only one prey and one predator ("Predator-Prey Lotka-Volterra Model", "Netlogo Wolf-Sheep Predation Model"). This model will also incoporate the Netlogo's wolf-sheep model and the Lotka-Volterra model from www.jondarkow.com. This model will have a modification where it has the third entity (namely, the hunter or the minecraft-survival-game-like human player agent) who hunts for both the prey and the second predator. The model will address this question: what will happen to the prey-predator populations if the model includes a third predator (the hunter). It will not delve into how the number of predators, as a kind of a stressor, impact the birth rate of the prey. To see if the model fits into the criteria, the criteria will be defined as the movements by the agents and the changes in the agents' populations. These insights on the predation behaviors will be helpful for conservation parks and organizations to make careful decisions on preserving species.

The variables in the datafile are size class (a category for designating sizes), initial total prey density (while it indicates more about the population density of the prey (McCoy et al.), the model will use this variable to indicate the number of prey), median predators (it displays the number of predators), number of tadpoles eaten (the model will re-catagorize the tadpoles into prey, and the variable presents the number of [prey] being eaten), and replicate blocks that will be utilized for grouping patch areas (all of the variables are from the dataset from McCoy et. al) (McCoy et al.). The most important variable that the model removes is the year variable from the dataset created by Andren et al. as the ticks measure is sufficent in illustrating time, and the year variable is difficult to interpret (Andren et al.). 

## 2. Entities, State Variables, and Scales

The entities for this model will be the patches that represent plants for the prey to consume (Railsbeck and Grimm, "Netlogo Wolf-Sheep Predation Model"), the prey, and the two predators (the hunter and the second predator). The state variables will be the birth-death rates for the preys and predators, as seen in the Lotka-Volterra model, to create a realistic model ("Predator-Prey Lotka-Volterra Model"); the starting numbers of the preys and predators based on the dataset's prey density and medium number of predators (Hexin_Liu_alldata_09062024.csv) to initialize the model ("Netlogo Wolf-Sheep Predation Model"); the stamina of the entities to portray the organism's speed more realistic ("Netlogo Wolf-Sheep Predation Model"); the energy of an organism based on Netlogo's Wolf-Sheep model to illustrate the organism's limited life ("Netlogo Wolf-Sheep Predation Model"); and the sizes of the preys and the non-hunter predators (shown as size classes in the created dataset) to indicate how much energy that the predators will take (McCoy et al., Hexin_Liu_alldata_09062024.csv).

The other potential state variable will be the average speed of the organisms (Simulation and Modeling Canvas, "Netlogo Wolf-Sheep Model", Railsback and Grimm). Adjusting the speeds will offer information on the behavior of preys when encountering predators (Simulation and Modeling Canvas, "Netlogo Wolf-Sheep Model", Railsback and Grimm)

For the scales element, a tick in the model will be one week (Railsbeck and Grimm). This way, the model will provide how the predator-prey populations evolve in the course of many weeks (Railsback and Grimm). The model will run until the number of ticks reach to 3500 ticks (Railsbeck and Grimm). The model will consist of a 43 x 43 patches with each patch representing 5x5 km^2 (Railsbeck and Grimm).   

## 3. Process Overview and Scheduling

In the model, the preys will attempt to avoid being captured by predators and the hunters with the non-hunter predators also escaping from the hunters ("Netlogo Wolf-Sheep Predation Model").

The stochasticity of the model will affect the schedule in the sense that the increased birth rates will change the movements of the prey, specifically how to execute the movements (Railsback and Grimm, Simulation and Modeling Canvas). The prey will be more aware of the increased number of predators (Railsback and Grimm, Simulation and Modeling Canvas). In knowing this, it will then tried to move away from the predators (Railsback and Grimm, Simulation and Modeling Canvas). Considering that ask is more oriented on randomness as detailed by Railsback and Grimm (Railsback and Grimm, Simulation and Modeling Canvas), each of the prey will 'take turns' in a random manner to make movements (Railsback and Grimm, Simulation and Modeling Canvas). This allows the model to be more aligned with randomized scheduling where the organisms randomly make decisions (Railsback and Grimm, Simulation and Modeling Canvas).

## 4. Design Concepts

The model's basic principle is focused on how predation impacts the populations of the preys and predators (Railsbeck and Grimm, "Netlogo Wolf-Sheep Predation Model"). Many researchers have documented how predation causes population changes between prey and predator ("Netlogo Wolf-Sheep Predation Model"). These changes can be utilized to predict the projected numbers of predators and preys ("Netlogo Wolf-Sheep Predation Model"). For the sensing part of the model, the preys and the non-hunter predators will need to know if the enemies are approaching to them to make decisions on eluding the enemies (Railsbeck and Grimm, "Netlogo Wolf-Sheep Predation Model"). The model attempts to predict the future numbers of preys and predators in light of predation (Railsbeck and Grimm, "Netlogo Wolf-Sheep Predation Model"). The stochasticity of the model is represented through the use of randomly placing the preys and predators in different initial locations (Railsbeck and Grimm, "Netlogo Wolf-Sheep Predation Model").

The model will qualify for the first element of the emergence test where it is not dependent on the sum of the individuals' properties (Railsbeck and Grimm). Instead, the model uses the Lotka-Volterra equations where it relies the probability of the effects of the predator/prey to the predator's/prey's populations ("Predator-Prey Lotka-Volterra Model"). The model also fits to the second part of emergence ('different type of result than the individuals' actions'). The model's population trends is not the same as the birth-rates and death-rates of organisms ("Netlogo Wolf-Sheep Predation Model", Railsbeck and Grimm), the stamina of organisms ("Netlogo Wolf-Sheep Predation Model", Railsbeck and Grimm), and other properties of the agents ("Netlogo Wolf-Sheep Predation Model", Railsbeck and Grimm). However, the model's population changes can be predicted from the agents' properties (for example, the birth-rates and the death rates of organisms) through the Lotka-Volterra equations ("Predator-Prey Lotka-Volterra Model"). Thus, the model would not fit to the third aspect of the emergence test (Railsbeck and Grimm).

One observation technique that this model will use is using Netlogo's plot (similar to the plot in Netlogo's Predation Model) to see how the populations of preys and predators evolve over time (Railsbeck and Grimm, "Netlogo Wolf-Sheep Predation Model"). Another observation technique for the model is the monitor for population sizes of organisms, that is used in Netlogo's predation model, to see the current population sizes of the preys and predators (Railsbeck and Grimm, "Netlogo Wolf-Sheep Predation Model"). The model incorporates an observation technique where the View has the labels that show the stamina or the energy of an agent (Railsbeck and Grimm).

The main adaptive behavior of the model is ensuring that the prey can make an escape path from the predator through adjusting its direction and also using stamina to outrun the predator (Simulation and Modeling Canvas, Railsback and Grimm). The prey's stamina will be quickly depleted if the prey runs at a faster rate to evade its predator (Simulation and Modeling Canvas, Railsback and Grimm). Hence, this will function as a trade-off situation where the prey needs to be far away from the predator without risking the prey's stamina (Simulation and Modeling Canvas, Railsback and Grimm). Based on Netlogo's Wolf-Sheep model, the alternatives are managing the prey's and predator's staminas and energies; keeping the farthest distance from the predators; and maintaining the population through reproduction (Simulation and Modeling Canvas, Railsback and Grimm). The sensing component is demonstrated through the prey noticing that a predator is nearby. The prey then will attempt to run away from the predator at a fast rate (Simulation and Modeling Canvas, Railsback and Grimm).

The three variables suitable for prediction would be the medium number of predators, the initial total prey density, and number of the prey being eaten (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). They would be essential in knowing the future change in population with the Lotka-Volterra model (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). The general, expected prediction of the organisms' population is when the number of predators increases, the number of prey would decrease (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). Hence, it is expected to see the increased speed of the prey to avoid a large number of nearby predators (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). The outcome would be the quickly decreasing slope of the prey's population as a result of overpredation of the predators (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). The only minor change for the research question would be the inclusion of focusing on how predator activities affect the behavior of the prey (most notably, the speed of the prey) (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas).

One pair of variables that would be interdependent to each other would be the median number of predators and the number of the eaten prey (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). The interdependence between these two variables would demonstrate how the number of predators would impact the number of the prey that they have consumed (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). It is predicted that the large population of predators would eat many prey and thus decrease the prey's population (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). This relationship would be useful in determining the death rate and using the death rate in the Lotka-Volterra equations to see the population trends of the organisms (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). The other variables that are interdependent are the initial total prey density and median predators (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas). As expected, these variables, along with other parameters (for example, birth rates), will be plugged into the Lotka-Volterra equations to calculate the population trends and observe the population shifts (Hexin_Liu_alldata_09062024.csv, "Predator-Prey Lotka-Volterra Model", Simulation and Modeling Canvas).

Railsback's and Grimm's Bernoulli distribution, as described in their textbook, would be ideal to include in this model (Railsback and Grimm, Simulation and Modeling Canvas). This discrete distribution will be used to decide to whetever to increment the birth rates of the organisms by 0.01 (Railsback and Grimm, Simulation and Modeling Canvas). The incorporation of the Bernoulli distribution will hence gave an interesting perspective of how it affects the predation dynamics in the model (Railsback and Grimm, Simulation and Modeling Canvas). The model will also use the discrete distribution called the Poisson distribution as this distribution is suitable for mimicking how birth rates work (Railsback and Grimm, Simulation and Modeling Canvas), which is seen in Railsback and Grimm's use of this distribution when mimicking birth rates (Railsback and Grimm, Simulation and Modeling Canvas). Indeed, as the Poisson distribution considers the number of times an event occurs based on the time (Railsback and Grimm, Simulation and Modeling Canvas), it is beneficial to use this distribution to emulate a populaton increase due to births (Railsback and Grimm, Simulation and Modeling Canvas). This will simulate the birth rates in the simulation and thus will be useful in studying population changes (Railsback and Grimm, Simulation and Modeling Canvas).
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="predation_model_demostration" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks &gt; 100</exitCondition>
    <metric>count preys</metric>
    <metric>count predators</metric>
    <enumeratedValueSet variable="prey-stamina">
      <value value="50"/>
      <value value="10"/>
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="overall-birth-rate">
      <value value="0"/>
      <value value="0.1"/>
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hunter-stamina">
      <value value="50"/>
      <value value="10"/>
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="predator-stamina">
      <value value="50"/>
      <value value="5"/>
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="predator-energy">
      <value value="100"/>
      <value value="-10"/>
      <value value="70"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Sensitivity Analysis" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>count preys = 0</exitCondition>
    <metric>count preys</metric>
    <metric>count predators</metric>
    <metric>overall-birth-rate</metric>
    <steppedValueSet variable="overall-birth-rate" first="0" step="0.5" last="4"/>
    <enumeratedValueSet variable="number-of-preys">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-predators">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
