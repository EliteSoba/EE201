EE201
=====
Project Overview:

Our project is to design a scientific calculator using an FPGA to get user input and a combination of SSDs and the LCD Screen to give visual feedback to the user.
Our calculator will implement the following functions: addition, subtraction, multiplication, division, gcd, square root, prime factorization, isPrime.<p>
Each one of these functions will lead the user into a sub-State Machine that will prompt the user for the correct number of inputs (one or two) and then step slowly through the operation (slow enough for the user to see) selected in the main state machine.<br>
The User will enter numbers through the 8 switches at the bottom of the FPGA. The maximum value needed to hold the maximum possible variables is a 16-bit value (2^8 * 2^8 is the largest operation possible in this calculator, which is 16 bits long).<br>
After the value is calculated, it will be marched across the screen until the user wants to perform a new action. Then the entire operation repeats itself.


Tech. Requirements: LCD Screen Only

Usage: Implement calc_project_top.bit

Editing: Run calc_project.xise

Members:
Alex Jones
Tobias Lee