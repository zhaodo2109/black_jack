module tb_alu_logic;

  logic clk, rst;
  logic clear_sums;
  logic deal_player, deal_dealer;
  logic compare;
  logic [3:0] card_value;
  logic [5:0] player_sum, dealer_sum;
  logic player_bust, dealer_bust;
  logic dealer_auto_hit;
  logic player_win, dealer_win, tie;
  logic card_ready;
  logic stand_active;

  alu_logic dut (
    .clk          (clk),
    .rst          (rst),
    .clear_sums   (clear_sums),
    .deal_player  (deal_player),
    .deal_dealer  (deal_dealer),
    .compare      (compare),
    .card_value   (card_value),
    .player_sum   (player_sum),
    .dealer_sum   (dealer_sum),
    .player_bust  (player_bust),
    .dealer_bust  (dealer_bust),
    .dealer_auto_hit(dealer_auto_hit),
    .player_win   (player_win),
    .dealer_win   (dealer_win),
    .tie          (tie),
    .card_ready   (card_ready),
    .stand_active (stand_active)
  );

  // clock
  initial clk = 0;
  always #5 clk = ~clk;

  task give_card_to_player(input [3:0] val);
    begin
      @(negedge clk);
      deal_player = 1;
      card_value  = val;
      card_ready  = 0;
      @(negedge clk);
      deal_player = 0;
      card_ready  = 1;
      @(negedge clk);
      card_ready  = 0;
    end
  endtask

  task give_card_to_dealer(input [3:0] val);
    begin
      @(negedge clk);
      deal_dealer = 1;
      card_value  = val;
      card_ready  = 0;
      @(negedge clk);
      deal_dealer = 0;
      card_ready  = 1;
      @(negedge clk);
      card_ready  = 0;
    end
  endtask

  initial begin
    // init
    rst         = 0;
    clear_sums  = 0;
    deal_player = 0;
    deal_dealer = 0;
    compare     = 0;
    card_value  = 0;
    card_ready  = 0;
    stand_active = 0;

    $display("=== alu_logic test begin ===");
    @(negedge clk);
    rst = 1;   // active-low reset deassert
    @(negedge clk);
    rst = 0;   // assert reset
    @(negedge clk);
    rst = 1;   // release reset

    // Clear sums
    clear_sums = 1;
    @(negedge clk);
    clear_sums = 0;

    // Scenario 1: Player 10 + 7, Dealer 9 + 7
    stand_active = 1;

    give_card_to_player(4'd10);
    give_card_to_dealer(4'd9);
    give_card_to_player(4'd7);
    give_card_to_dealer(4'd7);

    repeat(2) @(negedge clk);

    compare = 1;
    @(negedge clk);
    compare = 0;

    $display("After compare: Psum=%0d Dsum=%0d  Pwin=%0b Dwin=%0b tie=%0b",
              player_sum, dealer_sum, player_win, dealer_win, tie);

    // Scenario 2: Player busts with 10 + 10 + 5
    clear_sums = 1;
    @(negedge clk);
    clear_sums = 0;

    give_card_to_player(4'd10);
    give_card_to_player(4'd10);
    give_card_to_player(4'd5);

    repeat(2) @(negedge clk);
    compare = 1;
    @(negedge clk);
    compare = 0;

    $display("Bust scenario: Psum=%0d Dbust=%0b Pbust=%0b Pwin=%0b Dwin=%0b tie=%0b",
              player_sum, dealer_bust, player_bust, player_win, dealer_win, tie);

    $display("=== alu_logic test end ===");
    #50 $finish;
  end

  initial begin
    $monitor("t=%0t | Psum=%0d Dsum=%0d Pb=%0b Db=%0b Dah=%0b Pwin=%0b Dwin=%0b tie=%0b",
              $time, player_sum, dealer_sum, player_bust, dealer_bust,
              dealer_auto_hit, player_win, dealer_win, tie);
  end

endmodule
