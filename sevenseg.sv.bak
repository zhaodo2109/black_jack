module sevenseg( input logic [5:0]mag_result, 
                 output logic [6:0]seg1, 
					  output logic [6:0]seg2);
    
	 logic [3:0] tens, ones;

    always_comb begin
        tens = mag_result / 10;
        ones = mag_result % 10;
    end 
	 
    always_comb
        begin
            case (ones)
            4'b0000 : seg1<= 7'b1000000;//Hexadecimal 0
            4'b0001 : seg1<= 7'b1111001;//Hexadecimal 1 
            4'b0010 : seg1<= 7'b0100100;//Hexadecimal 2
            4'b0011 : seg1<= 7'b0110000;//Hexadecimal 3
            4'b0100 : seg1<= 7'b0011001;//Hexadecimal 4
            4'b0101 : seg1<= 7'b0010010;//Hexadecimal 5
            4'b0110 : seg1<= 7'b0000010;//Hexadecimal 6
            4'b0111 : seg1<= 7'b1111000;//Hexadecimal 7
            4'b1000 : seg1<= 7'b0000000;//Hexadecimal 8
            4'b1001 : seg1<= 7'b0011000;//Hexadecimal 9 
            default seg1<= 7'b1111111;
            endcase
        end
		  
	always_comb
        begin
            case (tens)
            4'b0000 : seg2<= 7'b1000000;//Hexadecimal 0
            4'b0001 : seg2<= 7'b1111001;//Hexadecimal 1 
            4'b0010 : seg2<= 7'b0100100;//Hexadecimal 2
            4'b0011 : seg2<= 7'b0110000;//Hexadecimal 3
            4'b0100 : seg2<= 7'b0011001;//Hexadecimal 4
            4'b0101 : seg2<= 7'b0010010;//Hexadecimal 5
            4'b0110 : seg2<= 7'b0000010;//Hexadecimal 6
            4'b0111 : seg2<= 7'b1111000;//Hexadecimal 7
            4'b1000 : seg2<= 7'b0000000;//Hexadecimal 8
            4'b1001 : seg2<= 7'b0011000;//Hexadecimal 9 
            default seg2<= 7'b1111111;
            endcase
        end
        
endmodule