module tb_dealer_hand;

  logic [5:0] data;
  logic [2:0] wraddr, raddr;
  logic       wen, ren, clk;
  logic [5:0] q;

  dealer_hand dut (
    .data  (data),
    .wraddr(wraddr),
    .raddr (raddr),
    .wen   (wen),
    .ren   (ren),
    .clk   (clk),
    .q     (q)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  task write_card(input [2:0] addr, input [5:0] val);
    begin
      @(negedge clk);
      wraddr = addr;
      data   = val;
      wen    = 1;
      ren    = 0;
      @(negedge clk);
      wen    = 0;
    end
  endtask

  task read_card(input [2:0] addr);
    begin
      @(negedge clk);
      raddr = addr;
      ren   = 1;
      @(negedge clk);
      ren   = 0;
    end
  endtask

  initial begin
    wen = 0; ren = 0;
    wraddr = 0; raddr = 0;
    data = 0;

    $display("=== dealer_hand test begin ===");

    write_card(3'd0, 6'd5);
    write_card(3'd1, 6'd12);
    write_card(3'd2, 6'd25);

    read_card(3'd0);
    read_card(3'd1);
    read_card(3'd2);

    $display("=== dealer_hand test end ===");
    #50 $finish;
  end

  initial begin
    $monitor("t=%0t | wen=%0b addr=%0d data=%0d | ren=%0b raddr=%0d q=%0d",
              $time, wen, wraddr, data, ren, raddr, q);
  end

endmodule
