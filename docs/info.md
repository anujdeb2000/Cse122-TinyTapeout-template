<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Minefield is a simple guessing game. After a start signal, a sequence of  5 2-bit random values is generated through an 8-bit LFSR, with each entry corresponding to a round of a game. After the sequence is loaded, the game will start with the 1st round. 1 of 4 buttons signals will be inputted and will be converted into a 2-bit corresponding value. (0-3). If the inputted value is equal to the value of the sequence of entry 0 (1st round), the game is lost. If the values aren't equal, the game will progress into the next round. This goes up to the 5th round, where if the values don't match, the game is won.
## How to test

To test the project, use the minefield_tb.v file with the minefield.v file. The testbench file was designed for use with the minefield.v file and was not adapted for use with the tt_um_minefield.v file. The tesbench tests 2 different cases: A lose case and a win case. Both cases start with a reset signal followed by a start signal, then wait until the state transitions to PLAY, meaning that the game is ready to be played. Note that editing the start signal timing will result in different sequence values for the output. However, this does not change the outcome of our test cases aslong as the timing of the start signal is a factor of 10. The lost case will input the exact value of the first entry in the sequence. This will result in our loss. The win case will input a value 1 higher than the sequence entry (0 -> 1, 3 -> 0) for every round, until it finally wins after beating the 5th round. This testbench is sufficient as it tests a win and a loss, which are the only outcomes of the game. Below is the ouput of the testbench:

________________________Case 1: Lose Game test________________________
Time=5000 | gState=         | gIndex=x | TargetSeq=xx | Win=x | Lose=x
Time=15000 | gState=    INIT | gIndex=0 | TargetSeq=xx | Win=0 | Lose=0
Time=25000 | gState=    INIT | gIndex=0 | TargetSeq=xx | Win=0 | Lose=0
Time=35000 | gState=    INIT | gIndex=0 | TargetSeq=xx | Win=0 | Lose=0
Time=45000 | gState=    INIT | gIndex=0 | TargetSeq=xx | Win=0 | Lose=0
Time=55000 | gState=    LOAD | gIndex=0 | TargetSeq=xx | Win=0 | Lose=0
Time=65000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=75000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=85000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=95000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=105000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=115000 | gState=    PLAY | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Round 0: Sequence is 00, choosing 00
Time=125000 | gState=    PLAY | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=135000 | gState=    PLAY | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=145000 | gState=    PLAY | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=155000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=165000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=175000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=185000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=195000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=205000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=215000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=225000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Design Passes Case 1 (Lose)
________________________Case 2: Win Game test________________________
Time=235000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=245000 | gState=    LOSE | gIndex=0 | TargetSeq=00 | Win=0 | Lose=1
Time=255000 | gState=    INIT | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=265000 | gState=    INIT | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=275000 | gState=    INIT | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=285000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=295000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=305000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=315000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=325000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=335000 | gState=    LOAD | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Round 0: Sequence is 00, choosing 01
Time=345000 | gState=    PLAY | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=355000 | gState=    PLAY | gIndex=0 | TargetSeq=00 | Win=0 | Lose=0
Time=365000 | gState=    PLAY | gIndex=1 | TargetSeq=01 | Win=0 | Lose=0
Time=375000 | gState=    PLAY | gIndex=1 | TargetSeq=01 | Win=0 | Lose=0
Time=385000 | gState=    PLAY | gIndex=1 | TargetSeq=01 | Win=0 | Lose=0
Time=395000 | gState=    PLAY | gIndex=1 | TargetSeq=01 | Win=0 | Lose=0
Time=405000 | gState=    PLAY | gIndex=1 | TargetSeq=01 | Win=0 | Lose=0
Round 1: Sequence is 01, choosing 10
Time=415000 | gState=    PLAY | gIndex=1 | TargetSeq=01 | Win=0 | Lose=0
Time=425000 | gState=    PLAY | gIndex=1 | TargetSeq=01 | Win=0 | Lose=0
Time=435000 | gState=    PLAY | gIndex=1 | TargetSeq=01 | Win=0 | Lose=0
Time=445000 | gState=    PLAY | gIndex=2 | TargetSeq=11 | Win=0 | Lose=0
Time=455000 | gState=    PLAY | gIndex=2 | TargetSeq=11 | Win=0 | Lose=0
Time=465000 | gState=    PLAY | gIndex=2 | TargetSeq=11 | Win=0 | Lose=0
Time=475000 | gState=    PLAY | gIndex=2 | TargetSeq=11 | Win=0 | Lose=0
Time=485000 | gState=    PLAY | gIndex=2 | TargetSeq=11 | Win=0 | Lose=0
Round 2: Sequence is 11, choosing 00
Time=495000 | gState=    PLAY | gIndex=2 | TargetSeq=11 | Win=0 | Lose=0
Time=505000 | gState=    PLAY | gIndex=2 | TargetSeq=11 | Win=0 | Lose=0
Time=515000 | gState=    PLAY | gIndex=2 | TargetSeq=11 | Win=0 | Lose=0
Time=525000 | gState=    PLAY | gIndex=3 | TargetSeq=11 | Win=0 | Lose=0
Time=535000 | gState=    PLAY | gIndex=3 | TargetSeq=11 | Win=0 | Lose=0
Time=545000 | gState=    PLAY | gIndex=3 | TargetSeq=11 | Win=0 | Lose=0
Time=555000 | gState=    PLAY | gIndex=3 | TargetSeq=11 | Win=0 | Lose=0
Time=565000 | gState=    PLAY | gIndex=3 | TargetSeq=11 | Win=0 | Lose=0
Round 3: Sequence is 11, choosing 00
Time=575000 | gState=    PLAY | gIndex=3 | TargetSeq=11 | Win=0 | Lose=0
Time=585000 | gState=    PLAY | gIndex=3 | TargetSeq=11 | Win=0 | Lose=0
Time=595000 | gState=    PLAY | gIndex=3 | TargetSeq=11 | Win=0 | Lose=0
Time=605000 | gState=    PLAY | gIndex=4 | TargetSeq=10 | Win=0 | Lose=0
Time=615000 | gState=    PLAY | gIndex=4 | TargetSeq=10 | Win=0 | Lose=0
Time=625000 | gState=    PLAY | gIndex=4 | TargetSeq=10 | Win=0 | Lose=0
Time=635000 | gState=    PLAY | gIndex=4 | TargetSeq=10 | Win=0 | Lose=0
Time=645000 | gState=    PLAY | gIndex=4 | TargetSeq=10 | Win=0 | Lose=0
Round 4: Sequence is 10, choosing 11
Time=655000 | gState=    PLAY | gIndex=4 | TargetSeq=10 | Win=0 | Lose=0
Time=665000 | gState=    PLAY | gIndex=4 | TargetSeq=10 | Win=0 | Lose=0
Time=675000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=685000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=695000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=705000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=715000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=725000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=735000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=745000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=755000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=765000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=775000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=785000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=795000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=805000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=815000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Time=825000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0
Design Passes Case 2 (Win)
Time=835000 | gState=     WIN | gIndex=4 | TargetSeq=10 | Win=1 | Lose=0

## External hardware
This project wasn't designed with any piece of hardware in mind outside of buttons. It is meant to be adapted/interpreted to different hardware. The win and losegame outputs of the module can be translated to LEDS, a display, or anything else. 

Generative AI was used for a number of things. First, it was used for catching any syntax errors and debugging. It was also for formatting the display of the testbench, aswell as the algorithm for what input should be used in each case. Lastly, it was used to help format the minefield.v verilog file into tt_um_minefield.v.
