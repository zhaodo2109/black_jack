/*module display(input [5:0] displayNum, output logic [6:0] displayOut,output logic [6:0] displayOut1,output logic [6:0] displayOut0);

	always_comb begin
		case (displayNum)
			6'd0: displayOut = 7'b0001000; // A
			6'd1: displayOut = 7'b0100100; // 2
			6'd2: displayOut = 7'b0110000; // 3
			6'd3: displayOut = 7'b0011001; // 4
			6'd4: displayOut = 7'b0010010; // 5
			6'd5: displayOut = 7'b0000010; // 6
			6'd6: displayOut = 7'b1111000; // 7
			6'd7: displayOut = 7'b0000000; // 8
			6'd8: displayOut = 7'b0010000; // 9
			6'd9: begin
				displayOut  = 7'b1111111;
				displayOut0 = 7'b1000000; // 0
				displayOut1 = 7'b1111001; // 1
			end
			6'd10: displayOut = 7'b1110001; // J 
			6'd11: displayOut = 7'b0011000; // Q 
			6'd12: displayOut = 7'b0001011; // k (might look weird because of hardware, looks like 'h')
			
			//6'd20: displayOut = 7'b1000000; // 0
			//6'd21: displayOut = 7'b1111001; // 1
			
			default: begin 
			displayOut = 7'b1111111;
			displayOut1 = 7'b1111111;
			displayOut0 = 7'b1111111;
			end
		endcase
	end
endmodule

*/

module display(
    input  logic [5:0] displayNum,
    output logic [6:0] displayOut,
    output logic [6:0] displayOut1,
    output logic [6:0] displayOut0
	 
);

    always_comb begin
		  displayOut  = 7'b1111111;
        displayOut1 = 7'b1111111;
        displayOut0 = 7'b1111111;
        case (displayNum)

            6'd0: begin
                displayOut  = 7'b0001000; // A
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd1: begin
                displayOut  = 7'b0100100; // 2
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd2: begin
                displayOut  = 7'b0110000; // 3
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd3: begin
                displayOut  = 7'b0011001; // 4
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd4: begin
                displayOut  = 7'b0010010; // 5
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd5: begin
                displayOut  = 7'b0000010; // 6
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd6: begin
                displayOut  = 7'b1111000; // 7
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd7: begin
                displayOut  = 7'b0000000; // 8
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd8: begin
                displayOut  = 7'b0010000; // 9
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            // Display “10”
            6'd9: begin
                displayOut  = 7'b1111111; // blank
                displayOut1 = 7'b1111001; // 1
                displayOut0 = 7'b1000000; // 0
            end

            6'd10: begin
                displayOut  = 7'b1110001; // J
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd11: begin
                displayOut  = 7'b0011000; // Q
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            6'd12: begin
                displayOut  = 7'b0001011; // K
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

            default: begin
                displayOut  = 7'b1111111;
                displayOut1 = 7'b1111111;
                displayOut0 = 7'b1111111;
            end

        endcase
    end

endmodule
