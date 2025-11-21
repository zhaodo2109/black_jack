module alu_logic(input  logic clk,
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
					 output logic tie
				);

	/*
    always_ff @(posedge clk or negedge rst) begin
        if (!rst || clear_sums)
            player_sum <= 6'd0;
        else if (deal_player)
            player_sum <= player_sum + card_value;
    end

    assign player_bust = (player_sum > 6'd21);

    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst || clear_sums)
            dealer_sum <= 6'd0;
        else if (deal_dealer)
            dealer_sum <= dealer_sum + card_value;
    end

	 */
	 
	 always_ff @(posedge clk or negedge rst) begin
		 if (!rst)
			  player_sum <= 6'd0;                
		 else if (clear_sums)
			  player_sum <= 6'd0;                
		 else if (deal_player)
			  player_sum <= player_sum + card_value;
	end

	always_ff @(posedge clk or negedge rst) begin
		 if (!rst)
			  dealer_sum <= 6'd0;                
		 else if (clear_sums)
			  dealer_sum <= 6'd0;                
		 else if (deal_dealer)
			  dealer_sum <= dealer_sum + card_value;
	end

	 
    assign dealer_bust = (dealer_sum > 6'd21);


    assign dealer_auto_hit = (dealer_sum < 6'd17);


    always_comb begin
    player_win = 0;
    dealer_win = 0;
    tie = 0;

    if (compare) begin
	     //both bust
        if (player_bust && dealer_bust) begin
            if (player_sum < dealer_sum)   
					player_win = 1;
            else if (dealer_sum < player_sum) 
					dealer_win = 1;
            else 
					tie = 1;
        end

		 //player bust
        else if (player_bust) begin
            if (dealer_sum <= 21) 
					dealer_win = 1;
            else if (player_sum == dealer_sum) 
					tie = 1;
            else 
					dealer_win = 1; // normal
        end

		 // dealer bust
        else if (dealer_bust) begin
            if (player_sum >=17 && player_sum <=21) 
					player_win = 1;
            else if (player_sum == dealer_sum) 
					tie = 1;
				else if (player_sum <17)
					tie = 1;
            else 
					player_win = 1;
        end

		  
		  // normal
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
