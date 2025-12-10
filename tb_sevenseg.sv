module tb_sevenseg;

  logic [5:0] mag_result;
  logic [6:0] seg1, seg2;

  sevenseg dut (
    .mag_result(mag_result),
    .seg1      (seg1),
    .seg2      (seg2)
  );

  initial begin
    $display("=== sevenseg test begin ===");
    foreach (mag_result) begin end // just to quiet some tools

    mag_result = 6'd0;   #1 $display("val=%0d seg1=%b seg2=%b", mag_result, seg1, seg2);
    mag_result = 6'd9;   #1 $display("val=%0d seg1=%b seg2=%b", mag_result, seg1, seg2);
    mag_result = 6'd10;  #1 $display("val=%0d seg1=%b seg2=%b", mag_result, seg1, seg2);
    mag_result = 6'd17;  #1 $display("val=%0d seg1=%b seg2=%b", mag_result, seg1, seg2);
    mag_result = 6'd21;  #1 $display("val=%0d seg1=%b seg2=%b", mag_result, seg1, seg2);
    mag_result = 6'd31;  #1 $display("val=%0d seg1=%b seg2=%b", mag_result, seg1, seg2);

    $display("=== sevenseg test end ===");
    #20 $finish;
  end

endmodule
