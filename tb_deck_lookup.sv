module tb_deck_lookup;

  logic [5:0] addr;
  logic [6:0] data_out;

  deck_lookup dut (
    .addr    (addr),
    .data_out(data_out)
  );

  initial begin
    $display("=== deck_lookup test begin ===");
    addr = 6'd0;  #1 $display("addr=%0d data=0x%0h", addr, data_out);
    addr = 6'd1;  #1 $display("addr=%0d data=0x%0h", addr, data_out);
    addr = 6'd10; #1 $display("addr=%0d data=0x%0h", addr, data_out);
    addr = 6'd20; #1 $display("addr=%0d data=0x%0h", addr, data_out);
    addr = 6'd31; #1 $display("addr=%0d data=0x%0h", addr, data_out);
    addr = 6'd51; #1 $display("addr=%0d data=0x%0h", addr, data_out);
    $display("=== deck_lookup test end ===");
    #20 $finish;
  end

endmodule
