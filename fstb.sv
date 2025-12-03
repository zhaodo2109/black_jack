/*
module fstb;

  // ----------------------------------------
  // Signals
  // ----------------------------------------
  logic clk, rst;
  logic start, hit, stand;

  // DUT instance
  fullgame dut(
    .clk(clk),
    .rst(rst),
    .hit(hit),
    .stand(stand),
    .start(start)
  );

  // ----------------------------------------
  // Clock
  // ----------------------------------------
  always #50 clk = ~clk; // 100ns period

  // ----------------------------------------
  // Simple button press tasks
  // ----------------------------------------
  task press_start;
    $display("[%0t] >>> START pressed", $time);
    start = 1; #100; start = 0;
  endtask

  task press_hit;
    $display("[%0t] >>> HIT pressed", $time);
    hit = 1; #100; hit = 0;
  endtask

  task press_stand;
    $display("[%0t] >>> STAND pressed", $time);
    stand = 1; #100; stand = 0;
  endtask

  // ----------------------------------------
  // Decode card name (helper)
  // ----------------------------------------
  function string card_name(input [6:0] c);
    string suit, rank;
    int v;
    v = c[3:0];

    case (c[6:5])
      2'b00: suit = "spades";
      2'b01: suit = "hearts";
      2'b10: suit = "diamonds";
      2'b11: suit = "clubs";
      default: suit = "?";
    endcase

    case (v)
      1:   rank = "A";
      2:   rank = "2";
      3:   rank = "3";
      4:   rank = "4";
      5:   rank = "5";
      6:   rank = "6";
      7:   rank = "7";
      8:   rank = "8";
      9:   rank = "9";
      10:  rank = "10";
      11:  rank = "A"; // Ace can appear as 11
      default: rank = $sformatf("%0d", v);
    endcase

    return {rank, suit};
  endfunction

  // ----------------------------------------
  // Monitor card draw events
  // ----------------------------------------
  always @(posedge dut.card_ready) begin
    $display("[%0t] CARD DRAWN -> %s (raw=%b)",
             $time, card_name(dut.card_data_out), dut.card_data_out);
  end

  // Optional: show who requested it
  always @(posedge dut.deal_player)
    $display("[%0t] PLAYER requested a card", $time);

  always @(posedge dut.deal_dealer)
    $display("[%0t] DEALER requested a card", $time);

  // ----------------------------------------
  // Display main signals every change
  // ----------------------------------------
  initial begin
    $display("------------------------------------------------");
    $display("        BLACKJACK FULLGAME TESTBENCH STARTED     ");
    $display("------------------------------------------------");
    $monitor("[%0t] player_sum=%0d dealer_sum=%0d | bust_p=%b bust_d=%b | win_p=%b win_d=%b tie=%b",
             $time,
             dut.player_sum, dut.dealer_sum,
             dut.player_bust, dut.dealer_bust,
             dut.player_win, dut.dealer_win, dut.tie);
  end

  // ----------------------------------------
  // Main test sequence
  // ----------------------------------------
  initial begin
    clk   = 0;
    rst   = 0;
    start = 0;
    hit   = 0;
    stand = 0;

    // Reset
    #200;
    rst = 1;
    #200;

	 // Wait for deck_loader to finish
	wait (dut.load_done == 1);
	$display("[%0t] Deck loaded, now starting game.", $time);
	press_start;

	 
    // Round 1
    press_start;
    #5000;
    press_hit;
    #1000;
    press_stand;
    //#4000;


    //$display("--------------------------------------------");
    //$display(" TEST COMPLETE ");
    //$display("--------------------------------------------");
    //#500;
  end

endmodule


*/

module fstb;

  // ----------------------------------------
  // Signals
  // ----------------------------------------
  logic clk, rst;
  logic start, hit, stand;

  // DUT instance
  fullgame dut(
    .clk(clk),
    .rst(rst),
    .hit(hit),
    .stand(stand),
    .start(start)
  );

  // ----------------------------------------
  // Clock
  // ----------------------------------------
  always #50 clk = ~clk; // 100ns period

  // ----------------------------------------
  // Simple button press tasks
  // ----------------------------------------
  task press_start;
    $display("[%0t] >>> START pressed", $time);
    start = 1; #100; start = 0;
  endtask

  task press_hit;
    $display("[%0t] >>> HIT pressed", $time);
    hit = 1; #100; hit = 0;
  endtask

  task press_stand;
    $display("[%0t] >>> STAND pressed", $time);
    stand = 1; #100; stand = 0;
  endtask

  // ----------------------------------------
  // Decode card name (helper)
  // ----------------------------------------
  function string card_name(input [6:0] c);
    string suit, rank;
    int v;
    v = c[3:0];

    case (c[6:5])
      2'b00: suit = "spades";
      2'b01: suit = "hearts";
      2'b10: suit = "diamonds";
      2'b11: suit = "clubs";
      default: suit = "?";
    endcase

    case (v)
      1:   rank = "A";
      2:   rank = "2";
      3:   rank = "3";
      4:   rank = "4";
      5:   rank = "5";
      6:   rank = "6";
      7:   rank = "7";
      8:   rank = "8";
      9:   rank = "9";
      10:  rank = "10";
      11:  rank = "A"; // Ace can appear as 11
      default: rank = $sformatf("%0d", v);
    endcase

    return {rank, suit};
  endfunction

  // ----------------------------------------
  // Monitor card draw events
  // ----------------------------------------
  always @(posedge dut.card_ready) begin
    $display("[%0t] CARD DRAWN -> %s (raw=%b)",
             $time, card_name(dut.card_data_out), dut.card_data_out);
  end

  // Optional: show who requested it
  always @(posedge dut.deal_player)
    $display("[%0t] PLAYER requested a card", $time);

  always @(posedge dut.deal_dealer)
    $display("[%0t] DEALER requested a card", $time);

  // ----------------------------------------
  // Display main signals every change
  // ----------------------------------------
  initial begin
    $display("------------------------------------------------");
    $display("        BLACKJACK FULLGAME TESTBENCH STARTED     ");
    $display("------------------------------------------------");
    $monitor("[%0t] player_sum=%0d dealer_sum=%0d | bust_p=%b bust_d=%b | win_p=%b win_d=%b tie=%b",
             $time,
             dut.player_sum, dut.dealer_sum,
             dut.player_bust, dut.dealer_bust,
             dut.player_win, dut.dealer_win, dut.tie);
  end
/*

  always @(posedge clk) begin
    $display("[%0t] dealP=%b dealD=%b | card_value=%0d | card_draw.state=%s | rand_idx=%0d | card_ready=%b",
             $time,
             dut.deal_player,
             dut.deal_dealer,
             dut.card_data_out[3:0],
             dut.draw.state.name(),
             dut.draw.rand_index,
             dut.card_ready);
  end
*/
  // ----------------------------------------
  // Main test sequence
  // ----------------------------------------
  initial begin
    clk   = 0;
    rst   = 0;
    start = 0;
    hit   = 0;
    stand = 0;

    // Reset
    #200;
    rst = 1;
    #200;

    // Wait for deck_loader to finish
    wait (dut.load_done == 1);
    $display("[%0t] Deck loaded, now starting game.", $time);

    // Round 1
    press_start;
    #5000;
    press_hit;
    #1000;
    press_stand;
	 
	 wait (dut.player_win || dut.dealer_win || dut.tie);

	 #100;
	 
	 if (dut.player_win == 1)
		$display("Winner is: PLAYER");
	 else if (dut.dealer_win==1)
		$display("Winner is: DEALER");
	 else if (dut.tie==1)
	   $display("TIE");
		
		
	 // Round 2
    
	 $monitor("[%0t] player_sum=%0d dealer_sum=%0d | bust_p=%b bust_d=%b | win_p=%b win_d=%b tie=%b",
             $time,
             dut.player_sum, dut.dealer_sum,
             dut.player_bust, dut.dealer_bust,
             dut.player_win, dut.dealer_win, dut.tie);
				 
	rst = 1;
    #200;
				 
	press_start;
	press_start;
	
	
	
  end

endmodule
