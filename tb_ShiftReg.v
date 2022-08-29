`timescale 1us/1us
module tb_ShiftReg();

reg tb_clk;
reg tb_rst_n;
reg [1:0] tb_mode;
reg tb_S_DataIn;
reg [7:0] tb_P_DataIn;

wire [7:0]tb_P_DataOut;
wire      tb_S_DataOut;



// testbench parameters 
localparam clk_period = 10;

// clock generation 
always # (clk_period /2) tb_clk = ~tb_clk;

integer i;

ShiftReg #(
    .width(8)
) ShiftReg_instance(
    .clk(tb_clk),
    .rst_n(tb_rst_n),
    .Mode_Control(tb_mode),
    .S_DataIn(tb_S_DataIn),
    .P_DataIn(tb_P_DataIn),
    .P_DataOut(tb_P_DataOut),
    .S_DataOut(tb_S_DataOut)
);
	
// main intial block
initial 
 begin

     // intialization 
     tb_clk = 1'b0;
     tb_rst_n = 1'b1;
     tb_mode = 2'b00;
     tb_S_DataIn = 0;
     tb_P_DataIn = 8'b11001100;
     

     // Reset
     #(clk_period * 0.2)
     tb_rst_n = 1'b0;
     #(clk_period * 0.6)
     tb_rst_n = 1'b1;
      
     
     // test case
      
     tb_mode = 2'b11;
     $display ("-------------------test: parallel load--------------------");
     #10
     if (tb_P_DataOut ==  tb_P_DataIn)
     $display ("test case 1 : passed");
     else 
     $display ("test case 1 : failed");
     
     tb_mode = 2'b01;
     $display ("-------------------test: shift left--------------------");
     #10
     for (i = 0; i<8; i =i+1)
     begin
         #10
     $display ("%b", tb_P_DataOut);
     end


     
 end
	
endmodule : tb_ShiftReg
