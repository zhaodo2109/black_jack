module tb_result_mag;

  logic [5:0] raw_result;
  logic [5:0] mag_result;
  logic       sign;

  result_mag dut (
    .raw_result(raw_result),
    .mag_result(mag_result),
    .sign      (sign)
  );

  integer i;

  initial begin
    $display("=== result_mag test begin ===");
    // example range: small positives and negatives (2's complement)
    for (i = -10; i <= 10; i = i + 5) begin
      raw_result = i[5:0];
      #1;
      $display("raw=%0d (0x%0h) | sign=%0b mag=%0d",
                $signed(raw_result), raw_result, sign, mag_result);
    end
    $display("=== result_mag test end ===");
    #20 $finish;
  end

endmodule
