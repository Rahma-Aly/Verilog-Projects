module BCD_Adder (
	input [3:0] A,B,
	input       Cin,
	output reg [7:0] Sum);

	
	reg [4:0]sum1;
	always @(*) begin
		sum1 = A + B + Cin;
		if (sum1 > 9) begin
				Sum = sum1 + 'd6;
		end
		else begin
			Sum = {4'b0,sum1};
		end
	end
	
endmodule

