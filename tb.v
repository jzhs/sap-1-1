`timescale 1ns / 1ps
`default_nettype none


module tb();

reg clk;
reg reset;

// clock has 2 ns period (simulated)
always #1 clk = ~clk & ~reset;

// Make instance of sap1
sap1 SAP(.clk(clk),
         .fp_clear(reset),
         .fp_prog(1'b0),
         .fp_write(1'b0),
         .fp_adr(4'b0000),
         .fp_data(8'b00000000),
         .eo_sel(2'b01)
         );

// Pull some data out of the SAP module for debug display         
wire [5:0] tbits = SAP.ring.value;
wire [7:0] wbits = SAP.w_bus;
wire [3:0] pcbits = SAP.pc_value;
wire [3:0] marbits = SAP.mar_value;
wire [7:0] membits = SAP.mem_value;
wire [7:0] irbits = SAP.ir.value;
wire [7:0] a_out = SAP.a.value;
wire [7:0] b_out = SAP.b.value;
wire [7:0] o_out = SAP.o.value;
wire [7:0] eo = SAP.extra_out;

initial begin
  $dumpfile("top_tb.vcd");
  $dumpvars;
  $monitor("time: %t, T=%b, W=%b, PC=%b, MAR=%b" , 
     $time, tbits, wbits, 
     pcbits,
     marbits
     );
  clk = 0;
  reset = 1;
  #1;
  reset = 0;
  #60;
  $finish;
end

endmodule
