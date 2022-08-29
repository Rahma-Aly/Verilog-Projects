module UART_TX #(parameter width = 8)(
	input              clk,
	input              rst, //sychronous reset
	input              Data_Valid,
	input              Parity_type,
	input              Parity_EN,
	input [width-1:0]  P_Data, //
	output reg         TX_Out,
	output reg         Busy //high signal when transmitting
);
	
	always @(*)
	begin
	    
	end
	
endmodule : UART_TX
