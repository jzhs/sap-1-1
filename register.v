`default_nettype none 

module register
#(parameter size = 8)
(
  input wire clock,
  input wire reset,
  input wire load,
  input  wire [size-1:0] data_in,
  output reg [size-1:0] value
);

always @(posedge clock or posedge reset)
begin
  if (reset)
    value <= 0;
  else if (load)
    value <= data_in;
  else
    value <= value;
end
  
endmodule
