module asyncRst_syncRst(input logic clk, rst,
					 output logic syncRst);

		logic iRst;
		
		always_ff @(posedge clk or negedge rst) begin
			if (!rst) begin
				iRst <= 1'b0;
				syncRst<= 1'b0;
			end else begin
				iRst <= 1'b1;
				syncRst <= iRst;
			end
		end

endmodule