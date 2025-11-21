module deck_lookup (
    input  logic [5:0] addr,    // 0–51
    output logic [6:0] data_out
);
	 /* card info :
		first 2 bits: suite
		last 4 bits: card value
		Ace default at 11 
		5th bit = used indication (whether or not pull randomly from memory)
	 */
    always_comb begin
        case (addr)
				// spades
            6'd0:  data_out = 7'h0B; // A  (00 01011) (11)
				6'd1:  data_out = 7'h02; // 2  (00 00010) (2)
				6'd2:  data_out = 7'h03; // 3  (00 00011) (3)
				6'd3:  data_out = 7'h04; // 4  (00 00100) (4)
				6'd4:  data_out = 7'h05; // 5  (00 00101) (5)
				6'd5:  data_out = 7'h06; // 6  (00 00110) (6)
				6'd6:  data_out = 7'h07; // 7  (00 00111) (7)
				6'd7:  data_out = 7'h08; // 8  (00 01000) (8)
				6'd8:  data_out = 7'h09; // 9  (00 01001) (9)
				6'd9:  data_out = 7'h0A; // 10 (00 01010) (10)
				6'd10: data_out = 7'h0A; // J  (00 01010) (10)
				6'd11: data_out = 7'h0A; // Q  (00 01010) (10)
				6'd12: data_out = 7'h0A; // K  (00 01010) (10)

            // hearts
            6'd13:  data_out = 7'h1B; // A  (01 01011) (11)
				6'd14:  data_out = 7'h12; // 2  (01 00010) (2)
				6'd15:  data_out = 7'h13; // 3  (01 00011) (3)
				6'd16:  data_out = 7'h14; // 4  (01 00100) (4)
				6'd17:  data_out = 7'h15; // 5  (01 00101) (5)
				6'd18:  data_out = 7'h16; // 6  (01 00110) (6)
				6'd19:  data_out = 7'h17; // 7  (01 00111) (7)
				6'd20:  data_out = 7'h18; // 8  (01 01000) (8)
				6'd21:  data_out = 7'h19; // 9  (01 01001) (9)
				6'd22:  data_out = 7'h1A; // 10 (01 01010) (10)
				6'd23:  data_out = 7'h1A; // J  (01 01010) (10)
				6'd24:  data_out = 7'h1A; // Q  (01 01010) (10)
				6'd25:  data_out = 7'h1A; // K  (01 01010) (10)
            
				
				// diamond
            6'd26:  data_out = 7'h2B; // A  (10 01011) (11)
				6'd27:  data_out = 7'h22; // 2  (10 00010) (2)
				6'd28:  data_out = 7'h23; // 3  (10 00011) (3)
				6'd29:  data_out = 7'h24; // 4  (10 00100) (4)
				6'd30:  data_out = 7'h25; // 5  (10 00101) (5)
				6'd31:  data_out = 7'h26; // 6  (10 00110) (6)
				6'd32:  data_out = 7'h27; // 7  (10 00111) (7)
				6'd33:  data_out = 7'h28; // 8  (10 01000) (8)
				6'd34:  data_out = 7'h29; // 9  (10 01001) (9)
				6'd35:  data_out = 7'h2A; // 10 (10 01010) (10)
				6'd36:  data_out = 7'h2A; // J  (10 01010) (10)
				6'd37:  data_out = 7'h2A; // Q  (10 01010) (10)
				6'd38:  data_out = 7'h2A; // K  (10 01010) (10)
				
				
				// clubs
				
				6'd39:  data_out = 7'h3B; // A  (11 01011) (11)
				6'd40:  data_out = 7'h32; // 2  (11 00010) (2)
				6'd41:  data_out = 7'h33; // 3  (11 00011) (3)
				6'd42:  data_out = 7'h34; // 4  (11 00100) (4)
				6'd43:  data_out = 7'h35; // 5  (11 00101) (5)
				6'd44:  data_out = 7'h36; // 6  (11 00110) (6)
				6'd45:  data_out = 7'h37; // 7  (11 00111) (7)
				6'd46:  data_out = 7'h38; // 8  (11 01000) (8)
				6'd47:  data_out = 7'h39; // 9  (11 01001) (9)
				6'd48:  data_out = 7'h3A; // 10 (11 01010) (10)
				6'd49:  data_out = 7'h3A; // J  (11 01010) (10)
				6'd50:  data_out = 7'h3A; // Q  (11 01010) (10)
				6'd51:  data_out = 7'h3A; // K  (1 01010) (10)
            default: data_out = 7'h00;
        endcase
    end
endmodule
