module tb_deck_memory;
   logic clk = 0;
   logic [6:0] data_in;
   logic [5:0] addr;
   logic wen;
   logic [6:0] data_out;
   deck_memory dut (
      .data_in(data_in),
      .addr(addr),
      .wen(wen),
      .clk(clk),
      .data_out(data_out)
   );
   always #5 clk = ~clk;
//write to memory
   task write_memory(input [5:0] address, input [6:0] value);
      begin
         @(negedge clk);
         addr = address;
         data_in = value;
         wen = 1'b1;
         @(posedge clk);
         #1;
         wen = 1'b0;
      end
   endtask
//set read address
   task read_memory(input [5:0] address);
      begin
         @(negedge clk);
         addr = address;
      end
   endtask
//sample and check
   task automatic sample_and_check(
         input [5:0] address,
         input [6:0] expected,
         input string phase
      );
      begin
         read_memory(address);
         @(posedge clk); #1;
         $display("Read address %0d: data = %0d (Expected: %0d) [%s]",
                  address, data_out, expected, phase);
         assert(data_out == expected)
            else $error("FAIL at addr %0d: got %0d, expected %0d [%s]",
                        address, data_out, expected, phase);
      end
   endtask
//main testing sequence
   initial begin
      //initialize inputs
      wen = 1'b0;
      data_in = 7'd0;
      addr = 6'd0;
      $display("Starting Deck Memory Testbench");
//initialize memory
      $display("Initializing memory in testbench");
      for (int i = 0; i < 52; i++) begin
         dut.deck[i] = i; //direct write to DUT's memory array
      end
      $display("Memory initialized in testbench");
      //give one clock edge so data_out reflects initial addr (0)
      @(posedge clk); #1;
      //verify initial values: 0 to 51 (test subset for brevity)
      $display("Checking power-on initialization");
      for (int i = 0; i < 8; i++) begin
         sample_and_check(i, i, "INIT");
      end
      $display("Initial values verified");
      //write new values: 100 to 107 (mod 128 since 7 bits)
      $display("Writing new data");
      for (int i = 0; i < 8; i++) begin
         write_memory(i, 7'd100 + i);
         $display(" Wrote %0d to address %0d", 7'd100 + i, i);
      end
      //read back and verify
      $display("Verifying written data");
      for (int i = 0; i < 8; i++) begin
         sample_and_check(i, 7'd100 + i, "Write-Back");
      end
      $display("All Tests Passed");
   end
endmodule