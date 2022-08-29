module FIFO_Reg #(parameter width = 4)(
	input                  EN, /*output enable*/
	input                  rst, /*when high, the control functions are cleared , DIR = 1, DOR = 0, output remains
	                                     in the state of the last word shifted out*/
    input [width-1:0]      DataIn,   /*Parallel data input*/
	input                  W_EN, /*1-> Data is loaded into reg , shift data in*/
	input                  R_EN, /*1 -> DOR = 0, empties locations, shift data out*/
    output reg             DIR, /*DataInReady -> 1 indicates that input stage is empty and ready to accept valid data
                                              -> 0 indicates that fifo is full or a previous shift is not complete*/
    output reg             DOR, /*DataOutReady -> 1 valid data is present at outputs (does not indicate new data)
                                               -> 0 output stage busy or no valid data  Or FIFO is empty*/
    output reg [width-1:0] DataOut /*Data Output*/
);

reg [width-1:0] dataReg [(2**width)-1:0]; 
reg [width-1:0] w_addr, r_addr;

always @(*)
begin
    if (rst)
    begin
        DIR    = 1; // FIFO input stage is empty
        DOR    = 0; // No valid Data
        w_addr = 0;
        r_addr = 0;
    end
    else if (EN)begin
            if (W_EN) begin //input data is shifted-in
                if (w_addr == (2**width-1)) DIR = 0; //FULL
                else begin
                        dataReg[w_addr] = DataIn;
                        w_addr = w_addr + 1; 
                        DIR = 1; //ready to accept more data
                    end
                end
            if (R_EN) begin//data is shifted-out
                            DataOut = dataReg[r_addr];
                            r_addr = r_addr + 1;
                            DOR = 1;
                            if (r_addr == w_addr) begin//fifo is empty
                                DOR = 0;     
                                w_addr = 0;
                                r_addr = 0;
                            end
                        end
                    end
end


endmodule : FIFO_Reg
