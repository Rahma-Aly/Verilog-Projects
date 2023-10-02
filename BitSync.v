module BitSync #(parameter Num_Stages = 2, Bus_Width = 1)(
	input                      clk,
	input                      rst_n,
	input      [Bus_Width-1:0] Async_Bits,
	output reg [Bus_Width-1:0] Sync_Bits
);

reg [Num_Stages-1:0] Q [Bus_Width-1:0];
integer i;

	always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
	    for (i = 0; i < Bus_Width ; i = i + 1 ) begin
	        Q[i] <= 0;
	    end
	end
	else begin
	        for (i = 0; i < Bus_Width ; i = i + 1 ) begin
	            Q[i] <= {Q[i][Num_Stages-2:0],Async_Bits[i]};
	            Sync_Bits[i] <= Q[i][Num_Stages-1];
	        end
	    end
	end
	
	
endmodule : BitSync
