module fullgame(input logic clk, input logic rst, input logic hit, input logic stand, input logic start);

	logic rise_h, fall_h;
	logic rise_s, fall_s;
	logic wen,ren;
	
	logic [3:0] card_value;
	
	logic load_done;
   logic [5:0] mem_addr;
   logic mem_wen,deck_read_en;
   logic [6:0] mem_in, mem_out;
	 

	//control signals
	logic dealer_bust,deal_player,deal_dealer,clear_sums,compare,dealer_auto_hit;
	logic rw,s_active;
	logic sync_rst;
	logic do_write,do_read;
	
	
	logic card_ready;
   logic [6:0] card_data_out;

   assign card_value = card_data_out[3:0];
	
	//win signals
	logic [5:0] player_sum, dealer_sum;
   logic player_bust;
   logic player_win, dealer_win, tie;
	
   logic [5:0] loader_addr, draw_addr;
   logic loader_wen, draw_wen;
   logic [6:0] loader_data_in, draw_data_in;
	
	
	
	synchronizer hit_sync(.clk(clk),.w(hit),.rise(rise_h),.fall(fall_h));
	synchronizer stand_sync(.clk(clk),.w(stand),.rise(rise_s),.fall(fall_s));

	asyncRst_syncRst rst_sync(.clk(clk), .rst(rst),.syncRst(sync_rst));
	 

	deck_loader loader(
		 .clk(clk),
		 .rst(sync_rst),
		 .load_done(load_done),
		 .deck_addr(loader_addr),
		 .deck_wen(loader_wen),
		 .deck_data_in(loader_data_in)
	);
	
	
	card_draw draw( .clk(clk),
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
		 .clk(clk),
		 .addr(mem_addr),
		 .data_in(mem_in),
		 .wen(mem_wen),
		 .data_out(mem_out)
	);
	


	game_fsm game( .clk(clk), 
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
						.stand_active(s_active)
					);

	alu_logic datapath(.clk(clk),
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
						  .card_ready(card_ready),
						  .stand_active(s_active)
						);

									
endmodule