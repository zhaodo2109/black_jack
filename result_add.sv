module result_mag( input logic [5:0]raw_result, 
                 output logic [5:0]mag_result, 
					  output logic sign);
     
	
	assign sign = raw_result[5];  
		
	always_comb begin
		
		if (!sign)
			mag_result = raw_result;
		else
			mag_result = ~raw_result + 6'b0000001;
	end
			
endmodule