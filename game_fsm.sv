/*module game_fsm(input  logic clk, rst,
					 input  logic start,
					 input  logic hit,
					 input  logic stand,

					 input  logic [5:0] player_sum,
					 input  logic [5:0] dealer_sum,
					 input  logic dealer_bust,

					 output logic deal_player,
					 output logic deal_dealer,
					 output logic clear_sums,
					 output logic compare,
					 input logic dealer_auto_hit,
					 input logic card_ready
					);

    typedef enum logic [2:0] {idle, deal, hit_s, stand_s, result} state_t;
    state_t state, next;

    always_ff @(posedge clk or negedge rst)
        if (!rst)
            state <= idle;
        else
            state <= next;

    always_comb begin
        deal_player = 0;
        deal_dealer = 0;
        clear_sums = 0;
        compare = 0;
        //dealer_auto_hit = 0;

        next = state;

        case(state)

        idle: begin
            clear_sums = 1;
            if (start)
                next = deal;
        end

        deal: begin
            deal_player = 1;
            deal_dealer = 1;
				if (card_ready)
					next = hit_s;
        end

        hit_s: begin
            if (hit)
                deal_player = 1;
            else if (stand)
                next = stand_s;
        end

        stand_s: begin
            if (dealer_bust)
                next = result;
            else if (dealer_auto_hit && card_ready) begin
                deal_dealer = 1;
            end else
                next = result;
        end

        result: begin
            compare = 1;
            if (!rst)
                next = idle;
        end

        endcase
    end

endmodule
*/

module game_fsm(
    input  logic clk, rst,
    input  logic start,
    input  logic hit,
    input  logic stand,
    input  logic [5:0] player_sum,
    input  logic [5:0] dealer_sum,
    input  logic dealer_bust,
    input  logic dealer_auto_hit,
    input  logic card_ready,

    output logic deal_player,
    output logic deal_dealer,
    output logic clear_sums,
    output logic compare,
	 output logic stand_active
);

    typedef enum logic [3:0] {
        idle,
        deal_player1,
        wait_p1,
        deal_dealer1,
        wait_d1,
        deal_player2,
        wait_p2,
        deal_dealer2,
        wait_d2,
        hit_s,
        stand_s,
        result
    } state_t;

    state_t state, next;

    always_ff @(posedge clk or negedge rst)
        if (!rst)
            state <= idle;
        else
            state <= next;

    always_comb begin
        // Default outputs
        deal_player = 0;
        deal_dealer = 0;
        clear_sums  = 0;
        compare     = 0;
        next        = state;

        case (state)

        // ---------------------------
        // Initial Reset
        // ---------------------------
        idle: begin
            clear_sums = 1;
            if (start)
                next = deal_player1;
        end

        // ---------------------------
        // Initial 2x Player + Dealer Dealing
        // ---------------------------
        deal_player1: begin
            deal_player = 1;
            if (card_ready)
                next = wait_p1;
        end

        wait_p1: begin
            if (!card_ready)
                next = deal_dealer1;
        end

        deal_dealer1: begin
            deal_dealer = 1;
            if (card_ready)
                next = wait_d1;
        end

        wait_d1: begin
            if (!card_ready)
                next = deal_player2;
        end

        deal_player2: begin
            deal_player = 1;
            if (card_ready)
                next = wait_p2;
        end

        wait_p2: begin
            if (!card_ready)
                next = deal_dealer2;
        end

        deal_dealer2: begin
            deal_dealer = 1;
            if (card_ready)
                next = wait_d2;
        end

        wait_d2: begin
            if (card_ready) begin
					 deal_player = 0;
					 deal_dealer = 0;
					 next = hit_s;
				end
        end

        // ---------------------------
        // Player's Turn
        // ---------------------------
        /*hit_s: begin
            if (hit)
                deal_player = 1;
            else if (stand)
                next = stand_s;
        end
			*/
			
			hit_s: begin
				deal_dealer = 0;
				if (hit && !card_ready)
					deal_player = 1; // request draw
				else if (hit && card_ready)
					deal_player = 0; // card arrived, release
				else if (stand)
					next = stand_s;
			end
		  
        // ---------------------------
        // Dealer's Auto Hit Turn
        // ---------------------------
        /*stand_s: begin
            if (dealer_bust)
                next = result;
            else if (dealer_auto_hit && card_ready)
                deal_dealer = 1;
            else
                next = result;
        end
		*/
		
		stand_s: begin
			 if (dealer_bust)
				  next = result;

			 else if (dealer_auto_hit && !card_ready)
				  deal_dealer = 1;

			 else if (dealer_auto_hit && card_ready)
				  next = stand_s;  // wait for next card check

			 else if (!dealer_auto_hit)
				  next = result;
		end

        // ---------------------------
        // Compare Results
        // ---------------------------
        result: begin
            compare = 1;
            if (!rst)
                next = idle;
			   else if (start)
					 next = idle;
        end

        endcase
    end
	 
	 assign stand_active = (state == stand_s);

endmodule
