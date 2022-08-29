module Parity_Calc(
	input       clk,
	input [7:0] Data,
	input       Parity_type,
	output reg  Parity_bit
);

localparam even_parity = 0,
           odd_parity = 1;

integer counter;
reg ones_instance;
	always@(*)
	begin
	    ones_instance = 0;
	    case (Parity_type)
	        even_parity: begin
	            for (counter = 0; counter < 8; counter = counter+1)
	            begin
	                if (Data[counter] == 1) ones_instance = ones_instance + 1;
	            end
	            if (ones_instance %2 == 0) Parity_bit = 0;
	            else Parity_bit = 1;
	        end
	        odd_parity: begin
	           for (counter = 0; counter < 8; counter = counter+1)
                begin
                    if (Data[counter] == 1) ones_instance = ones_instance + 1;
                end
                if (ones_instance %2 == 1) Parity_bit = 0;
                else Parity_bit = 1;
	        end
	        default: begin
	            Parity_bit = 0;
	        end
	        endcase 	        
	end
	
endmodule : Parity_Calc
