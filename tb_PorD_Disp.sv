module tb_PorD_disp;

    // Inputs
    logic clk;
    logic rst;
    logic turn;
    logic p_done;

    // Outputs
    logic mode;

    // Instantiate the Unit Under Test (UUT)
    PorD_disp uut (
        .clk(clk),
        .rst(rst),
        .turn(turn),
        .p_done(p_done),
        .mode(mode)
    );

    // Clock generation
    always #5 clk = ~clk;  // 100 MHz clock (period 10 ns)

    initial begin
        // Initialize inputs
        clk = 0;
        rst = 0;    // Assert reset (active low)
        turn = 0;
        p_done = 0;

        // Dump variables for waveform viewing
        $dumpfile("PorD_disp_tb.vcd");
        $dumpvars(0, tb_PorD_disp);

        // Apply reset
        #10;
        rst = 1;    // Release reset

        // Test case 1: Start in player_hand (mode=0)
        #10;
        // Should stay in player_hand since turn=0
        turn = 0;
        p_done = 1;
        #10;

        // Test case 2: Switch to dealer_hand
        turn = 1;
        p_done = 1;
        #10;  // Should transition on next clock

        // Now in dealer_hand (mode=1)
        #10;
        // Stay in dealer_hand since turn=1
        turn = 1;
        p_done = 0;
        #10;

        // Test case 3: Switch back to player_hand
        turn = 0;
        #10;  // Should transition on next clock

        // Now back in player_hand
        #10;

        // Test reset during operation
        rst = 0;
        #10;
        rst = 1;
        #10;

        // End simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | rst=%b | turn=%b | p_done=%b | state=%s | mode=%b",
                 $time, rst, turn, p_done, uut.state, mode);
    end

endmodule