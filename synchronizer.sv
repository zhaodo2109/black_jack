module synchronizer(input logic clk, w, output logic rise,fall);
	logic ff1, ff2, ff3;
	
	always_ff@(posedge clk) begin
		ff1 <= w;
		ff2 <= ff1;
		ff3 <= ff2;
		
	end
	assign fall = ff3 &~ ff2;
	assign rise = ~ff3 & ff2;
	
endmodule