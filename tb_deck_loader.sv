module tb_deck_loader;

  logic clk, rst;
  logic load_done;
  logic [5:0] deck_addr;
  logic       deck_wen;
  logic [6:0] deck_data_in;

  deck_loader dut (
    .clk        (clk),
    .rst        (rst),
    .load_done  (load_done),
    .deck_addr  (deck_addr),
    .deck_wen   (deck_wen),
    .deck_data_in(deck_data_in)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst = 1;
    $display("=== deck_loader test begin ===");
    @(negedge clk);
    rst = 0;
    @(negedge clk);
    rst = 1;

    while (!load_done) begin
      @(negedge clk);
      if (deck_wen)
        $display("t=%0t | Write addr=%0d data=0x%0h", $time, deck_addr, deck_data_in);
    end

    $display("load_done asserted at t=%0t", $time);
    $display("=== deck_loader test end ===");
    #20 $finish;
  end

endmodule
