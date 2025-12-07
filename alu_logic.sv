module alu_logic(
    input  logic clk,
    input  logic rst,
    input  logic clear_sums,
    input  logic deal_player,
    input  logic deal_dealer,
    input  logic compare, 
    input  logic [3:0] card_value,
    output logic [5:0] player_sum,
    output logic [5:0] dealer_sum,
    output logic player_bust,
    output logic dealer_bust,
    output logic dealer_auto_hit,
    output logic player_win,
    output logic dealer_win,
    output logic tie,
    input  logic card_ready,
    input  logic stand_active
);

    // Rising edge detector for card_ready
    logic card_ready_d;
    wire  card_ready_pulse;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            card_ready_d <= 1'b0;
        else
            card_ready_d <= card_ready;
    end

    assign card_ready_pulse = card_ready & ~card_ready_d;


    // Remember who requested the card
    logic pending_player, pending_dealer;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
				pending_player <= 0;
            pending_dealer <= 0;
		  end
		  else if (clear_sums) begin
            pending_player <= 0;
            pending_dealer <= 0;
		  end
        else begin
            // latch which side requested the next card
            if (deal_player)
                pending_player <= 1;
            else if (deal_dealer)
                pending_dealer <= 1;

            // clear the pending flag once a card arrives
            if (card_ready_pulse) begin
                pending_player <= 0;
                pending_dealer <= 0;
            end
        end
    end
	 
	 
	 // cards in hand
	 logic [2:0] player_card_count, dealer_card_count;

	always_ff @(posedge clk or negedge rst) begin
		 if (!rst)
			  player_card_count <= 3'd0;
		 else if (clear_sums)
			  player_card_count <= 3'd0;
		 else if (card_ready_pulse && pending_player)
			  player_card_count <= player_card_count + 3'd1;
	end

	always_ff @(posedge clk or negedge rst) begin
		 if (!rst)
			  dealer_card_count <= 3'd0;
		 else if (clear_sums)
			  dealer_card_count <= 3'd0;
		 else if (card_ready_pulse && pending_dealer)
			  dealer_card_count <= dealer_card_count + 3'd1;
	end


    // Player and dealer sums
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
				player_sum <= 6'd0;
		  end
		  else if(clear_sums) begin
            player_sum <= 6'd0;
		  end
        else if (card_ready_pulse && pending_player) begin
            //player_sum <= player_sum + card_value;
				if (card_value == 4'd11 && player_card_count >= 2)
					 player_sum <= player_sum + 6'd1;
				else
					 player_sum <= player_sum + card_value;
		  end
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
				dealer_sum <= 6'd0;
		  else if (clear_sums)
            dealer_sum <= 6'd0;
        else if (card_ready_pulse && pending_dealer)  begin
            //dealer_sum <= dealer_sum + card_value;
				if (card_value == 4'd11 && dealer_card_count >= 2)
					 dealer_sum <= dealer_sum + 6'd1;
				else
					 dealer_sum <= dealer_sum + card_value;
		  end
    end


    // Flags and compare logic
    assign player_bust = (player_sum > 6'd21);
    assign dealer_bust = (dealer_sum > 6'd21);
	 
	 logic dealer_auto_cond, dealer_auto_cond_d;
	 logic dealer_wait;
	 logic dealer_need_card;

	 assign dealer_need_card = (dealer_sum < 6'd17) && stand_active;
	
	always_ff @(posedge clk or negedge rst) begin
		 if (!rst)
			  dealer_wait <= 1'b0;
		 else if (clear_sums)
			  dealer_wait <= 1'b0;
		 else begin
			  // when we trigger an auto-hit, set wait flag
			  if (dealer_auto_hit)
					dealer_wait <= 1'b1;
			  // once card draw completes, clear wait so next hit can trigger
			  else if (card_ready)
					dealer_wait <= 1'b0;
		 end
	end
	 
	 assign dealer_auto_hit = dealer_need_card;

	

    always_comb begin
        player_win = 0;
        dealer_win = 0;
        tie = 0;

        if (compare) begin
            // both bust
            if (player_bust && dealer_bust) begin
                if (player_sum < dealer_sum)
                    player_win = 1;
                else if (dealer_sum < player_sum)
                    dealer_win = 1;
                else
                    tie = 1;
            end

            // player bust only
            else if (player_bust) begin
                if (dealer_sum <= 21)
                    dealer_win = 1;
                else if (player_sum == dealer_sum)
                    tie = 1;
                else
                    dealer_win = 1;
            end

            // dealer bust only
            else if (dealer_bust) begin
                if (player_sum >= 17 && player_sum <= 21)
                    player_win = 1;
                else if (player_sum == dealer_sum)
                    tie = 1;
                else if (player_sum < 17)
                    tie = 1;
                else
                    player_win = 1;
            end

            // normal compare
            else begin
                if (player_sum > dealer_sum)
                    player_win = 1;
                else if (dealer_sum > player_sum)
                    dealer_win = 1;
                else
                    tie = 1;
            end
        end
    end

endmodule

