
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
	 output logic stand_active,
    output logic is_idle,
    output logic is_deal_player1,
    output logic is_wait_p1,
    output logic is_deal_dealer1,
    output logic is_wait_d1,
    output logic is_deal_player2,
    output logic is_wait_p2,
    output logic is_deal_dealer2,
    output logic is_wait_d2,
    output logic is_hit_s,
    output logic is_stand_s,
    output logic is_result
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

        // Initial Reset
        idle: begin
            clear_sums = 1;
            if (start)
                next = deal_player1;
        end

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

        // Player's Turn
        /*hit_s: begin
            if (hit)
                deal_player = 1;
            else if (stand)
                next = stand_s;
        end
			*/
			
			hit_s: begin
				deal_dealer = 0;
				if (stand)
					next = stand_s;
				else if (hit && !card_ready)
					deal_player = 1; // request draw
				else if (hit && card_ready)
					deal_player = 0; // card arrived, release
			end
		  
        // Dealer's Auto Hit Turn
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

        // Results
        result: begin
            compare = 1;
            if (!rst)
                next = idle;
			   else if (start)
					 next = idle;
        end

        endcase

        is_idle = (state == idle);
        is_deal_player1 = (state == deal_player1);
        is_wait_p1 = (state == wait_p1);
        is_deal_dealer1 = (state == deal_dealer1);
        is_wait_d1 = (state == wait_d1);
        is_deal_player2 = (state == deal_player2);
        is_wait_p2 = (state == wait_p2);
        is_deal_dealer2 = (state == deal_dealer2);
        is_wait_d2 = (state == wait_d2);
        is_hit_s = (state == hit_s);
        is_stand_s = (state == stand_s);
        is_result = (state == result);
    end
	 
	 assign stand_active = (state == stand_s);

endmodule