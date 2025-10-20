# sap-1-1

This is an implementation of the SAP-1 computer for a Digilent Basys3
development board.

See below for installation hints and user guide.

# Backstory

The SAP (Simple-As-Possible) computer is a pedagogic design described
in

  [MB] Malvino and Brown, "Digital Computer Electronics", 3rd ed. 1993.

The first edition of [MB] appeared in 1977. The details of SAP seem
not to have changed much since then. It is built from 7400-series TTL
chips. In 1977 this is what a typical hobbyist/student/amateur would
use.  These chips are still available. It is still possible to build
the SAP computer as described and many have done so.  As befits a
student/hobbyist/amateur project, everyone adds their own variations,
extensions, twists and flare.  The most famous implementation is
probably Ben Eater's. He built the project on breadboards and made a
nice series of Youtube videos about the adventure. See
  [BE] https://eater.net/8bit and https://www.youtube.com/c/BenEater

The SAP is divided into three iterations. The first, SAP-1 is very
primitive. Functionally just an adding machine. The second, SAP-2 adds
many improvements such as the ability to program loops and write to
RAM. It adds better i/o. The third, SAP-3, adds built-in stack
operations, register shifts, arithmetic with carry/borrow.

This project is restricted to SAP-1. Extensions may follow.



# Installation

Assume that we recall the basics of Vivado and of the Digilent Basys3
board.


1. Clone this git repo. For instance:
   ```
     > cd _somewhere_
     > git clone https://github.com/jzhs/sap-1-1.git
   ```

   Verify that the repo contains at least a number of verilog source files, a Basys3
   constraints file (*.xdc), a couple documentation files (*.md), and a Vivado project
   (sap-vivado).
   

2. There is a skeleton Vivado project included in the repo:
   
   > sap-1-1/sap-vivado/sap-vivado.xpr
   
   Start Vivado and open that project.

   Or, if you are more familiar with Vivado you can set up a project
   however you see fit.
   
4. Run a behavioral simulation

   You should get a timing diagram showing the output register (o_out)
   eventually being set to 0x1C.

5. Generate the bitstream.

6. Connect the Basys3 board. Ensure all switches are in off position.

7. Program the Basys3 with the bitstream.

8. Press the left pushbutton on the board.

9. The rightmost 8 LEDs should light up as 0x1C (ie 00011100)


# User's Guide

## The switches, buttons, and LEDS
Looking at the Basys3 board there are 16 slide switches along the
bottom edge. The board labels these SW15-SW0.

Just above each switch is a LED labeled LD15-LD0.

There are five pushbuttons. I use three of them labeled BTNL, BTNC,
BTNR. 


These items are assigned the following meanings:

SW15 - the leftmost slide switch corresponds to what the book [MB]
calls the MANUAL/AUTO switch. When ON it enables single stepping the
clock.

SW14 - the next slide switch corresponds to the book's PROG/RUN
switch. When ON it enables placing a new program in the memory.

SW11-SW8 - correspond to book's signals A3-A0. Set an address while
programming.

SW7-SW0 - correspond to book's D7-D0. Set a data byte while programming.


BTNL - left pushbutton. Corresponds to CLEAR.

BTNC - center pushbutton. Corresponds to WRITE.

BTNR - right pushbutton. Corresponds to STEP.

The LEDs LD7-LD0 are used to display the content of the output register.



## Debugging items
SW13-12 - these are not used for anything appearing in the book. I
used them for extra debugging.

The LEDs LD15-LD8 are used for debugging purposes and display
different things depending on the setting of SW12-11.

If SW12-11 = 0b00 these LEDs show the state of the ring counter. T6
... T1.

If SW12-11 = 0b01 these LEDs show the PC

If SW12-11 = 0b10 these LEDs show the current value of MEM[MAR]

SWs set to 0b11 is currently undefined.

The Basys3 version here is almost functionally equivalent to that in
the book.  There are a couple differences.

## Programming

1. Set the PROG switch to ON.

2. Set the address switches to the address you want to change. 

3. Set the data switches to the byte you want in that address.

4. Press the center pushbutton.

Continue with step 2. This is a bit more transparent with the debug
switches set to SW12-11 = 0b10. The display should change each time
you press the button.

5. When done set PROG OFF and press CLEAR.



## Differences with book

First, the memory is initialized with a little program
for testing purposes. I find using the switches and LEDs on the board
very annoying. Having a built in test program helps a bit.

Second, after power up you have to press the CLEAR button (the left
pushbutton) to run the program. This came about accidentally at one
point but I found I actually prefer it that way. It give me an
opportunity to alter RAM and set switches before running.


# What did I learn? What to do next?

I embarked on this project to learn a little about computer
architecture and a little about FPGAs. I feel it served the purpose.

I am leaving this project with some unresolved issues. I think it's
better to move on to more interesting things than to perfect the
current project.

First, he whole 1KHz clock business seems suspect. The tools complain
about it and lots of people online say that it is generally a bad
idea, at least on fpgas. The prefered method seems to be to use the
builtin 100MHz clock and generate clock enable signals at a slow rate.

Second, here are infered latches in the memory module. I am assured
that is also a generally bad thing.

So next: I need to add better i/o. Switch to a hex keypad input and
7-segment hex display. This will at least make programming almost
tolerable I hope. It will also free up some switches. Those might have
some use.