module BaudRateGen #(parameter clk_freq = 100000000, oversampling_rate = 16,divisor_width = 16)(
	input clk, 
	input rst_n,
	input [divisor_width-1:0] Divisor,  
	output reg BCLK //BaudRate Clk
);
	    /* *
	     * desired BR = Input clk freq /  (divisor x oversampling rate) 
	     * oversampling rate -> 16 (usually) 
	     * range of divisor: 1 to (2^16) -1 
	     * freq = 100MHz
	     * 
	     *  n clk cycles = 1 UART clk cycle
	     * */
	     
	reg [divisor_width-1:0] count;
	
	always @(posedge clk or negedge rst_n) begin : Counter_Block
	  if (!rst_n) begin
	      count = 'b0; 
	  end
	  else if (EN) count = count + 'b1; 
	end
	
	always @(posedge clk or negedge rst_n) begin : BaudRate_generation
	    if (!rst_n) begin
	        BCLK <= 1'b0;
	    end
	    else if (EN) begin
	       if (is_Even(Divisor)) begin
	        if (count == Divisor*oversampling_rate/2) begin
	        count <= 'b0;
	        BCLK <= ~BCLK;
	        end
	        else BCLK <= BCLK;              
           end
           else begin
            if (count == ((Divisor*oversampling_rate/2)+1)) begin
            count <= 'b0;
            BCLK <= ~BCLK;
            end
            else BCLK <= BCLK; 
           end
           end        
	end
	
function is_Even; // 0 -> odd and 1-> even
	input [divisor_width-1:0] x;
    begin
        if (x %2 == 0) is_Even = 1;
        else is_Even = 0;
    end
    endfunction	    
	    
	
endmodule : BaudRateGen

