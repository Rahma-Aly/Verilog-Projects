module BaudRateGen #(parameter clk_freq = 100000000, oversampling_rate = 16)(
	input clk, 
	input rst_n,
	input [15:0] BaudRate, 
	output reg BCLK //BaudRate Clk
);
	reg [15:0] counter;
	reg [15:0] Divisor;
	    /*
	     * desired BR = Input clk freq /  (divisor x oversampling rate) 
	     * oversampling rate -> 16 (usually) 
	     * range of divisor: 1 to (2^16) -1 
	     * freq = 100MHz
	     * */
	always @(posedge clk or negedge rst_n) begin 
	  if (!rst_n) begin
	      counter = 16'b0; 
	      end
      else counter = counter + 16'b1; 
	end
	
	always @(posedge clk or negedge rst_n) begin
	    if (!rst_n) begin
	        BCLK <= 1'b0;
	        Divisor = clk_freq/(BaudRate*oversampling_rate);
	        end
	    else if (counter == Divisor) begin
	        counter <= 16'b0;
	        BCLK <= ~BCLK;
	    end
	    else
	    BCLK <= BCLK;
	end
	
	    
	    
	
endmodule : BaudRateGen
