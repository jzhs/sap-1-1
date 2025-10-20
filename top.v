
module top(
  input wire CLOCK_100MHZ, 
  input wire [15:0] SW,  // the sixteen switches
  input wire btnC,  // Write
  input wire btnL,  // Clear
  input wire btnR,  // Step
  //input wire btnU,
  //input wire btnD,
  output wire [15:0] LED // the sixteen LEDs
);

wire CLOCK_1KHZ;

wire CLR;
wire CLOCK_MANUAL; // Manual clock (single step)
             // Malvino C25 input pin 2

wire WRITE;
wire clk;
wire hlt;

freq_div 
divider(
  .clockin(CLOCK_100MHZ),
  .clockout(CLOCK_1KHZ) );



wire MANUAL, AUTO;

debounce
manual_deb(
  .clock(CLOCK_1KHZ),
  .in(SW[15]),
  .out(MANUAL) );

assign AUTO = ~MANUAL;



wire PROG, RUN;
debounce
progrun_deb(
  .clock(CLOCK_1KHZ),
  .in(SW[14]),
  .out(PROG) );

assign RUN = ~PROG;



debounce
clear_deb(
  .clock(CLOCK_1KHZ),
  .in(btnL),
  .out(CLR) );

debounce
singlestep_deb(
  .clock(CLOCK_1KHZ),
  .in(btnR),
  .out(CLOCK_MANUAL) );

debounce
readwrite_deb(
  .clock(CLOCK_1KHZ),
  .in(btnC),
  .out(WRITE) );

assign clk = ~hlt & ((CLOCK_1KHZ & AUTO) | (CLOCK_MANUAL & MANUAL));

// Instantiate the sap1 core, connect to board 

sap1 SAP(
   .clk(clk),
   .fp_clear(CLR),
   .fp_prog(PROG),
   .hlt(hlt),
   .fp_write(WRITE),
   .fp_adr(SW[11:8]),
   .fp_data(SW[7:0]),
   .o_out(LED[7:0]),
   .eo_sel(SW[13:12]),
   .extra_out(LED[15:8]) );

endmodule
