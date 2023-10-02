module BaudRateGen #(parameter oversampling_rate = 1,divisor_width = 16)(
	input clk, 
	input rst_n,
	input EN,
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
	     
	reg [divisor_width-1:0] count, ratio;
	reg High_Flag, Low_Flag;
	
	always @(posedge clk or negedge rst_n) begin : Counter_Block
	  if (!rst_n) begin
	      count     <= 'b1; 
	  end
	  else if (EN) begin
	          count = count + 'b1; 	          
	          end
	end
	
	always @(*) begin
             ratio     <= (Divisor*oversampling_rate) >> 1;
	     if (!rst_n) begin
	         High_Flag <= 0;
	         Low_Flag  <= 0;
	     end
         if (Divisor[0] == 1) begin
                 if (count == ratio+1) begin
                      High_Flag <= 1;
                      Low_Flag  <= 0;
                 end
                  else if (count == ratio)begin
                      High_Flag <= 0;
                      Low_Flag  <= 1;   
                  end          
              end     
	end
	
	
	always @(posedge clk or negedge rst_n) begin : BaudRate_generation
	    if (!rst_n) begin
	        BCLK <= 1'b0;  
	    end
	    else if (EN) begin
	       if (Divisor[0] == 0) begin
	        if (count == ((Divisor*oversampling_rate)>>1)) begin
	        count <= 'b1;
	        BCLK  <= ~BCLK;
	        end
	        else BCLK <= BCLK;              
           end
           else begin
            if (High_Flag || Low_Flag) begin
            count <= 'b1;
            BCLK  <= ~BCLK;
            end
            else BCLK <= BCLK; 
           end
           end        
	end
	
 	
endmodule : BaudRateGen
