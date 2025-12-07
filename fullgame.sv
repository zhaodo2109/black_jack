// Modified fullgame.sv
module fullgame(
    input logic clk, 
    input logic rst, 
    input logic hit, 
    input logic stand, 
    input logic start,
	 output logic [6:0] HEX0,
	 output logic [6:0] HEX2,
	 output logic [6:0] HEX3,
	 output logic [6:0] HEX6,
	 output logic [6:0] HEX4,
	 output logic load_done,
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
    output logic is_result,
	 output logic p_rq, d_rq

);

    logic rise_h, fall_h;
    logic rise_s, fall_s;
    logic wen, ren;
    
    logic [3:0] card_value;
    
    //logic load_done;
    logic [5:0] mem_addr;
    logic mem_wen, deck_read_en;
    logic [6:0] mem_in, mem_out;
     

    // Control signals
    logic dealer_bust, deal_player, deal_dealer, clear_sums, compare, dealer_auto_hit;
    logic rw, s_active;
    logic sync_rst;
    logic do_write, do_read;
    
    
    logic card_ready;
    logic [6:0] card_data_out;

    assign card_value = card_data_out[3:0];
    
    // Win signals
    logic [5:0] player_sum, dealer_sum;
    logic player_bust;
    logic player_win, dealer_win, tie;
    
    logic [5:0] loader_addr, draw_addr;
    logic loader_wen, draw_wen;
    logic [6:0] loader_data_in, draw_data_in;
	 
	 logic outclk;
    
    clockdiv cd(.iclk(clk), .oclk(outclk));
    
    synchronizer hit_sync(.clk(outclk), .w(hit), .rise(rise_h), .fall(fall_h));
    synchronizer stand_sync(.clk(outclk), .w(stand), .rise(rise_s), .fall(fall_s));

    asyncRst_syncRst rst_sync(.clk(outclk), .rst(rst), .syncRst(sync_rst));
     

    deck_loader loader(
         .clk(outclk),
         .rst(sync_rst),
         .load_done(load_done),
         .deck_addr(loader_addr),
         .deck_wen(loader_wen),
         .deck_data_in(loader_data_in)
    );
    

		 
    card_draw draw( .clk(outclk),
                         .rst(sync_rst),
                         .request_card(deal_player|deal_dealer),
                         .deck_addr(draw_addr),
                         .deck_read_en(deck_read_en),
                         .deck_write_en(draw_wen),
                         .deck_write_data(draw_data_in),
                         .deck_read_data(mem_out),
                         .card_ready(card_ready),
                         .card_data_out(card_data_out)
                        );
                        
    assign mem_addr = (load_done) ? draw_addr : loader_addr;
    assign mem_wen  = (load_done) ? draw_wen  : loader_wen;
    assign mem_in   = (load_done) ? draw_data_in : loader_data_in;
    
    deck_memory bram(
         .clk(outclk),
         .addr(mem_addr),
         .data_in(mem_in),
         .wen(mem_wen),
         .data_out(mem_out)
    );
    

	     
	 logic cr_d;
	 logic card_ready_pulse;

	 always_ff @(posedge outclk or posedge sync_rst) begin
	 	 if (sync_rst)
			  cr_d <= 0;
		 else
			  cr_d <= card_ready;
	 end

	 assign card_ready_pulse = card_ready & ~cr_d;

	 

    game_fsm game( .clk(outclk), 
                        .rst(sync_rst),
                        .start(start),
                        .hit(rise_h),
                        .stand(rise_s),
                        .player_sum(player_sum),
                        .dealer_sum(dealer_sum),
                        .dealer_bust(dealer_bust),
                        .deal_player(deal_player),
                       .deal_dealer(deal_dealer),
                        .clear_sums(clear_sums),
                       .compare(compare),
                        .dealer_auto_hit(dealer_auto_hit),
                        .card_ready(card_ready),
                        .stand_active(s_active),
                        .is_idle(is_idle),
                        .is_deal_player1(is_deal_player1),
                        .is_wait_p1(is_wait_p1),
                        .is_deal_dealer1(is_deal_dealer1),
                        .is_wait_d1(is_wait_d1),
                        .is_deal_player2(is_deal_player2),
                        .is_wait_p2(is_wait_p2),
                        .is_deal_dealer2(is_deal_dealer2),
                        .is_wait_d2(is_wait_d2),
                        .is_hit_s(is_hit_s),
                        .is_stand_s(is_stand_s),
                        .is_result(is_result)
                    );

    alu_logic datapath(.clk(outclk),
                          .rst(sync_rst),
                          .clear_sums(clear_sums),
                          .deal_player(deal_player),
                          .deal_dealer(deal_dealer),
                          .compare(compare),
                          .card_value(card_value),
                          .player_sum(player_sum),
                          .dealer_sum(dealer_sum),
                          .player_bust(player_bust),
                          .dealer_bust(dealer_bust),
                          .dealer_auto_hit(dealer_auto_hit),
                          .player_win(player_win),
                          .dealer_win(dealer_win),
                          .tie(tie),
                          .card_ready(card_ready_pulse),
                          .stand_active(s_active)
                        );

/*
	 logic [2:0] player_wrptr, dealer_wrptr;
	 logic player_wen, dealer_wen;
	 
	 always_ff @(posedge outclk or posedge sync_rst) begin
		 if (sync_rst) begin
			  player_wrptr <= 0;
			  dealer_wrptr <= 0;
		 end else begin
			  if (deal_player && card_ready)
					player_wrptr <= player_wrptr + 1;

			  if (deal_dealer && card_ready)
					dealer_wrptr <= dealer_wrptr + 1;
		 end
	 end

	 assign player_wen = deal_player & card_ready;
	 assign dealer_wen = deal_dealer & card_ready;
	 
	 logic [5:0] q;
*/	 
/*	 player_hand player_mem(
		 .data(draw_addr),           // store card INDEX 0-51
		 .wraddr(player_wrptr),      
		 .raddr(3'd0),
		 .wen(player_wen),
		 .ren(1'b0),
		 .clk(clk),
		 .q(q)
	 );
*/
	 /*
	 logic [5:0] p_card0;
	 logic [5:0] p_card1;
	 logic [5:0] p_card2;
	 logic [5:0] p_card3;
	 logic [5:0] p_card4;
	 
	 player_hand player_mem (
    .clk    (outclk),
    .rst    (sync_rst),
    .data   (card_data_out),       // card index from card_draw module
    .wraddr (player_wrptr),    // your existing 0-4 counter
    .wen    (player_wen),      // deal_player && card_ready
    .card0  (p_card0),
    .card1  (p_card1),
    .card2  (p_card2),
    .card3  (p_card3),
    .card4  (p_card4)
);

	 dealer_hand dealer_mem(
		 .data(draw_addr),
		 .wraddr(dealer_wrptr),
		 .raddr(3'd0),
		 .wen(dealer_wen),
		 .ren(1'b0),
		 .clk(outclk)
	 );
*/
	 

	display disp_p0 (.displayNum(card_data_out % 13), .displayOut(HEX0),.displayOut1(HEX3),.displayOut0(HEX2));

	always_comb begin
		 if (is_result) begin
			  HEX6 = 7'b1111111;
			  HEX4 = 7'b1111111;

			  if (player_win) begin
					HEX6 = 7'b1111001;    
					HEX4 = 7'b1000000; 
			  end
			  else if (dealer_win) begin
					HEX6 = 7'b1000000;   
					HEX4 = 7'b1111001;   
			  end
			  else if (tie) begin
					HEX6 = 7'b0111111; 
					HEX4 = 7'b0111111;
			  end
		 end 
		 else begin
			  HEX6 = 7'b1111111;
			  HEX4 = 7'b1111111;
		 end
	end

	
	
	always_comb begin
		 p_rq = 1'b0;
		 d_rq = 1'b0;
		 if (deal_player) begin
			  p_rq = 1'b1;
			  d_rq = 1'b0;
		 end
		 else if (deal_dealer) begin
			  p_rq = 1'b0;
			  d_rq = 1'b1;
		 end
	end

       
endmodule