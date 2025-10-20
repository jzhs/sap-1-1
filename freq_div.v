

// The output freq is 1/(2N) times the input freq.
// So with N = 50000, 100MHz ==> 1KHz

module freq_div
  #(parameter N = 50000)
(
  input wire clockin,   // 100MHz on Basys3 board
  output wire clockout  // 1KHz
);

localparam NBITS = $clog2(N);

reg [NBITS:0] counter_reg = 0;
reg clockout_reg = 0;

always @(posedge clockin) begin
    if (counter_reg == N-1) begin
       counter_reg <= 0;
       clockout_reg <= ~clockout_reg;
    end else
       counter_reg <= counter_reg + 1;
end

assign clockout = clockout_reg;

endmodule
