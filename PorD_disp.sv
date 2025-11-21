module PorD_disp( input  logic clk,
						input  logic rst,
						input  logic turn,
						input  logic p_done,
						output logic mode
					);

    typedef enum logic [1:0] {player_hand, dealer_hand} state_t;
    state_t state, next;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            state <= player_hand;
        else
            state <= next;
    end

    always_comb begin
		  next = state;
        mode = 1'b0;
        case (state)
            player_hand: begin
                mode = 0;
                if (turn && p_done) begin
                    next = dealer_hand;
                end
            end

            dealer_hand: begin
                mode = 1;
                if (!turn) begin
                    next = player_hand;
                end
				end
				default: next = player_hand;
        endcase
    end

endmodule
