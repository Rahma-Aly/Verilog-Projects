module FIFO #(parameter ADDR_WIDTH = 5, DATA_WIDTH = 8 )(
    input                       clk_read,
    input                       clk_write,
    input                       rst_n,
    input [DATA_WIDTH-1:0]      DataIn,   /*Parallel data input*/
    input                       Wr_enable, /*1-> Data is loaded into reg , shift data in*/
    input                       Read_enable, /*1 -> empties locations, shift data out*/
    output reg [DATA_WIDTH-1:0] DataOut, /*Data Output*/
    output reg                  Empty, /*empty signal synchronized with the read clk
                                         High when the read addr = that of the write addr*/
    output reg                  Full /*full signal synchronized with the write clk
                                       High when the write addr = that of the read addr*/
);
	reg [DATA_WIDTH-1:0] dataReg [(2**ADDR_WIDTH)-1:0]; 
	
	reg [ADDR_WIDTH-1:0] w_addr, /*Memory addr of incoming data*/
	                     r_addr; /*Memory addr of data to be read out*/
	                     /*after reset both indicate the same memory location*/
	reg [ADDR_WIDTH-1:0] counter;
	reg                  full_reg, empty_reg;
	                     
	always @(posedge clk_read or negedge rst_n) begin : Read_Control
	    if (~rst_n) begin
        r_addr  <= 0;
        Empty   <= 1;
        DataOut <= 0;
        counter <= 0;
        end
        else if (Read_enable) begin
                if (empty_reg) begin
                    Empty   <= 1;
                    DataOut <= 0;
                end
                else begin
                    Empty   <= 0;
                    DataOut <= dataReg[r_addr];
                    counter <= counter - 1;
                    if (r_addr == (2**ADDR_WIDTH)-1) begin
                        r_addr <= 0;
                    end
                    else begin
                        r_addr  <= r_addr + 1;
                    end    
                end       
        end
        else Empty   <= empty_reg;
	end
	
	always @(posedge clk_write or negedge rst_n) begin : Write_Control
	    if (~rst_n) begin
        w_addr   <= 0;
        Full     <= 0;
        end
        else if (Wr_enable) begin
                if (full_reg) begin
                    Full <= 1;
                end
                else begin
                    Full            <= 0;
                    dataReg[w_addr] <= DataIn;
                    counter         <= counter + 1;
                    if (w_addr == (2**ADDR_WIDTH) - 1) begin
                        w_addr <= 0;
                    end
                    else begin
                            w_addr <= w_addr + 1;
                    end    
                end   
	    end
	    else Full <= full_reg;
	end

    always @(counter) begin : Flag_Logic
        if (counter == (2**ADDR_WIDTH)) begin
            full_reg = 1;
            empty_reg = 0;
        end
        else if (counter == 0) begin
            empty_reg = 1;
            full_reg  = 0;
        end
        else begin
                full_reg  = 0;
                empty_reg = 0;
        end
    end
	
endmodule : FIFO
