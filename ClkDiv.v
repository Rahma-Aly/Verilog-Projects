module ClkDiv #(parameter divisor_width = 16)(
	input clk, 
	input rst_n,
	input EN,
	input [divisor_width-1:0] Divisor,  
	output reg BCLK 
);
	    /* *
	     * desired clk = Input clk freq / divisor  
	     * range of divisor: 1 to (2^16) -1 
	     * */
	     
	reg [divisor_width-1:0] count, ratio;
	reg High_Flag, Low_Flag;
	
	always @(posedge clk or negedge rst_n) begin : Counter_Block
	  if (!rst_n) begin
	      count = 'b0; 
	  end
	  else if (EN) begin
	          count = count + 'b1; 	          
	          end
	end
	
	always @(*) begin
             ratio <= Divisor >> 1;
         if (Divisor[0] == 1) begin
                 if (count == ratio+1) begin
                      High_Flag <= 1;
                      Low_Flag  <= 0;
                 end
                 else if (count == ratio)begin
                      Low_Flag  <= 1;   
                      High_Flag <= 0;
                  end   
              end     
	end
	
	
	always @(posedge clk or negedge rst_n) begin : BaudRate_generation
	    if (!rst_n) begin
	        BCLK <= 1'b0;  
	    end
	    else if (EN) begin
	       if (Divisor[0] == 0) begin
	               if (count == ratio+1) begin
	                   count <= 'b1;
	                   BCLK  <= ~BCLK;
	               end
	               else BCLK <= BCLK;              
           end
           else begin
            if ((High_Flag && (BCLK == 1)) || (Low_Flag && (BCLK == 0))) begin
            count <= 'b1;
            BCLK  <= ~BCLK;
            end
            else BCLK <= BCLK; 
           end
           end        
	end
	
 	
endmodule : ClkDiv
