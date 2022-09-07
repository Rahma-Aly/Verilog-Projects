module BaudRateGen #(parameter clk_freq = 100000000, oversampling_rate = 16)(
	input clk, 
	input rst_n,
	input [15:0] Divisor,  
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
	     
	reg [15:0] count;
	
	always @(posedge clk or negedge rst_n) begin : Counter_Block
	  if (!rst_n) begin
	      count = 16'b0; 
	  end
      else count = count + 16'b1; 
	end
	
	always @(posedge clk or negedge rst_n) begin : BaudRate_generation
	    if (!rst_n) begin
	        BCLK <= 1'b0;
	    end
	   else if (is_Even(Divisor)) begin
	        if (count == Divisor*oversampling_rate/2) begin
	        count <= 16'b0;
	        BCLK <= ~BCLK;
	        end
	        else BCLK <= BCLK;              
       end
       else begin
            if (count == ((Divisor*oversampling_rate/2)+1)) begin
            count <= 16'b0;
            BCLK <= ~BCLK;
            end
            else BCLK <= BCLK; 
           end
           
	end
	
function is_Even; // 0 -> odd and 1-> even
    input [15:0] x;
    begin
        if (x %2 == 0) is_Even = 1;
        else is_Even = 0;
    end
    endfunction	    
	    
	
endmodule : BaudRateGen

