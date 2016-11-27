# FSM-for-Morse-Code
A Finite State Machine displaying Morse Code from A to H written in verilog
There are five states in the finite state machine.
State A: idle state, which checks whether the key1 is pressed. If key1 is pressed, then display, otherwise wait.
State B: display 0.5 seconds, then check if the displayed bit is equal to 1, if so, go to C if not, go to last state, state E.
State C: display 0.5 seconds, if Reseten(key0) is not pressed, go to D.
State D: display 0.5 seconds, if Reseten(key0) is not pressed, go to E.
State E: check the counter which counter the bits left to be displayed, if counter == 0, go back to state A
