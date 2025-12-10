module tb_synchronizer;

  logic clk, w;
  logic rise, fall;

  synchronizer dut (
    .clk (clk),
    .w   (w),
    .rise(rise),
    .fall(fall)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    w = 0;
    $display("=== synchronizer test begin ===");
    $monitor("t=%0t | w=%0b rise=%0b fall=%0b", $time, w, rise, fall);

    #7  w = 1;  // not aligned with clk
    #13 w = 0;
    #17 w = 1;
    #11 w = 0;

    #50;
    $display("=== synchronizer test end ===");
    $finish;
  end

endmodule
