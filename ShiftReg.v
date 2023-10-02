module ShiftReg #(parameter width = 8)( 
	input                  clk,
	input                  rst_n,
	input      [1:0]       Mode_Control,
	input                  S_DataIn, //serial input
	input      [width-1:0] P_DataIn, //Parallel input
	output reg [width-1:0] P_DataOut, //Parallel output
	output reg             S_DataOut   //serial output
);
/*The operations performed by the Shift register:
 * 1. Shift data to the right
 * 2. shift data to the left
 * 3. load parallel data into the register
 * 
 * To perform any of the first 2 operations, we first must load the parallel data in (perform the first operation)*/
localparam  No_Change     = 2'b00,
            Shift_Right   = 2'b01,
            Shift_Left    = 2'b10,
            Parallel_Load = 2'b11;
            
	always @(posedge clk, negedge rst_n)
	begin
	    if (~rst_n) P_DataOut <= {(width){1'b0}};
	    else begin
	     //   P_DataOut <= P_DataIn;
	        case (Mode_Control)
	            No_Change: begin
	                P_DataOut <= P_DataOut;
	            end
	            Shift_Right: begin   
	                P_DataOut <= {S_DataIn, P_DataOut[width-1:1]};
	                S_DataOut = P_DataOut[0]; 
	            end
	            Shift_Left: begin       
	                P_DataOut <= {P_DataOut[width-2:0],S_DataIn};
	                  S_DataOut = P_DataOut[width-1]; 
	            end
	            Parallel_Load:begin
	                P_DataOut <= P_DataIn;
	            end
	            default: begin
	                P_DataOut <= {(width){1'b0}};
	            end
	        endcase  
	         end
	end
	
endmodule : ShiftReg
