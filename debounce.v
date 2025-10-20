// When input differs from the current output, increment the counter. 
// When counter hits max go ahead and change the output.
// The input has to be different from current output "for
// a long time" to get the output to change. Here a long time means
// something like 20ms. This is enough time for most physical switches to
// settle but still seems instantaneous to human perception.

// So basically 
//    clock_period x MAX_COUNT  <  20ms
// will work for many purposes.  Default is  1ms clock with a MAX_COUNT of 16. 


module debounce
#(
    parameter MAX_COUNT = 16
)
(
    input wire clock,  // a slow (1ms) clock
    input wire in,     // noisy input
    output reg out     // debounced and synched output
);

localparam COUNTER_BITS = $clog2(MAX_COUNT);

reg [COUNTER_BITS - 1 : 0] counter;

initial begin
  counter = 0;
  out = 0;
end
    
always @(posedge clock)
begin
  if (counter == MAX_COUNT - 1) begin
    out <= in; 
    counter <= 0;
  end else if (in != out)
    counter <= counter + 1;  
end

endmodule
