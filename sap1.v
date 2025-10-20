// sap1 module 

// It is instantiated in top.v for actual devboard use, and in tb.v for
// simulation.

`default_nettype none 

module sap1(
  input	wire clk,  
  input	wire fp_clear,
  input wire fp_prog,
  input wire fp_write,
  input wire [3:0] fp_adr,
  input wire [7:0] fp_data,
  output wire [7:0] o_out,
  input wire [1:0] eo_sel,
  output reg [7:0] extra_out,
  output wire hlt
);


wire [7:0] w_bus;


wire pc_en;
wire pc_incr;
wire [3:0] pc_value;

register #(.size(4))
pc(
  .clock(clk),
  .reset(fp_clear),
  .load(pc_incr),
  .data_in(pc_value + 4'b0001),
  .value(pc_value) );

assign w_bus[3:0] = (pc_en) ? pc_value : 4'bZZZZ;


wire mar_load;
wire [3:0] mar_value;

register #(.size(4))
mar(
  .clock(clk),
  .reset(fp_clear),
  .load(mar_load),
  .data_in(w_bus[3:0]),
  .value(mar_value) );


wire mem_en;
wire [7:0] mem_value;

memory
mem (
  .write(fp_write),
  .adr((fp_prog) ?  fp_adr : mar_value),
  .data_in(fp_data),
  .value(mem_value) );

assign w_bus = mem_en ? mem_value : 8'bZZZZZZZZ;


wire ir_enable;
wire ir_load;
wire [7:0] ir_value;

register 
ir(
  .clock(clk),
  .reset(fp_clear),
  .load(ir_load),
  .data_in(w_bus),
  .value(ir_value) );

assign w_bus[3:0] = ir_enable? ir_value[3:0] : 4'bZZZZ;



wire a_enable;
wire a_load;
wire [7:0] a_value;

register a(
  .clock(clk),
  .reset(1'b0),  // has no reset
  .load(a_load),
  .data_in(w_bus),
  .value(a_value) );

assign w_bus = a_enable ? a_value : 8'bZZZZZZZZ;

   

wire b_load;
wire [7:0] b_value;

register b(
  .clock(clk),
  .reset(1'b0), // no reset
  .load(b_load),
  .data_in(w_bus),
  .value(b_value) );

   
wire alu_enable;
wire [7:0] alu_value;

alu ALU(
  .a(a_value),
  .b(b_value),
  .op(sub),
  .value(alu_value) );

assign w_bus = alu_enable ? ALU.value : 8'bZZZZZZZZ;

wire o_load;
   
wire [7:0] o_value;

register o(
   .clock(clk),
   .reset(1'b0), // no reset
   .load(o_load),
   .data_in(w_bus),
   .value(o_value) );

assign o_out = o_value;

// Control unit
wire T1, T2, T3, T4, T5, T6;

register #(.size(6))
ring(
  .clock(~clk),
  .reset(1'b0),
  .load(1'b1),
  .data_in(fp_clear ? 6'b000001 : { T5, T4, T3, T2, T1, T6}),
  .value({T6, T5, T4, T3, T2, T1}) );


wire [3:0] opcode = ir_value[7:4];
   
wire lda = (opcode == 4'b0000);
wire add = (opcode == 4'b0001);
wire sub = (opcode == 4'b0010);
wire out = (opcode == 4'b1110);
assign hlt = (opcode == 4'b1111);

assign pc_en = T1;
assign pc_incr = T2;
assign mar_load = T1 | (lda & T4) | (add & T4) | (sub & T4);
assign ir_enable = T4 & (lda | add | sub) ;
assign ir_load = T3;
assign mem_en = T3 | (T5 & lda) | (T5 & add) | (T5 & sub);
assign a_enable = T4 & out;
assign a_load = (T5 & lda) | (T6 & add) | (T6 & sub);
assign b_load = (T5 & add) | (T5 & sub);
assign alu_enable = (T6 & add) | (T6 & sub);
assign o_load = T4 & out;


// Debug helper - set SW[13], SW[12] to get various extra output
always @*
begin
    case (eo_sel)
      2'b00 : extra_out <= {1'b0, 1'b0, T6, T5, T4, T3, T2, T1};
      2'b01 : extra_out <= {1'b0, 1'b0, 1'b0, 1'b0, pc_value};
      2'b10 : extra_out <= mem_value;
      2'b11 : extra_out <= 8'b00000000;
      default: 
        extra_out = 8'b00000000;
    endcase
end

endmodule
