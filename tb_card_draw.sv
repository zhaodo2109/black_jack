module tb_card_draw;

    // Inputs
    logic clk;
    logic rst;
    logic request_card;
    logic [6:0] deck_read_data;

    // Outputs
    logic [5:0] deck_addr;
    logic deck_read_en;
    logic deck_write_en;
    logic [6:0] deck_write_data;
    logic card_ready;
    logic [6:0] card_data_out;

    // Deck memory model (simple RAM)
    logic [6:0] deck [0:51];

    // Instantiate the Unit Under Test (UUT)
    card_draw uut (
        .clk(clk),
        .rst(rst),
        .request_card(request_card),
        .deck_addr(deck_addr),
        .deck_read_en(deck_read_en),
        .deck_write_en(deck_write_en),
        .deck_write_data(deck_write_data),
        .deck_read_data(deck_read_data),
        .card_ready(card_ready),
        .card_data_out(card_data_out)
    );

    // Simulate deck memory
    always_comb begin
        deck_read_data = deck[deck_addr];  // Read
    end

    always @(posedge clk) begin
        if (deck_write_en)
            deck[deck_addr] <= deck_write_data;  // Write
    end

    // Clock generation
    always #5 clk = ~clk;  // 100 MHz clock (period 10 ns)

    initial begin
        // Initialize inputs and deck
        clk = 0;
        rst = 0;  // Assert reset (active low)
        request_card = 0;
        for (int i = 0; i < 52; i++) begin
            deck[i] = {2'b00, 1'b0, 4'h0 + i[3:0]};  // Dummy values, unused (bit4=0)
        end

        // Dump variables for waveform viewing
        $dumpfile("card_draw_tb.vcd");
        $dumpvars(0, tb_card_draw);

        // Apply reset
        #10;
        rst = 1;  // Release reset

        // Test case 1: No request, check idle
        #20;
        if (card_ready !== 0) $error("card_ready should be 0 in idle");

        // Test case 2: Request a card (all unused, should draw first rand)
        request_card = 1;
        #10;  // Enter gen
        request_card = 0;  // Drop request to avoid looping
        #30;  // Through read_wait, check, used, done (3-4 cycles)
        #10;  // Back to idle
        if (card_ready !== 0) $error("card_ready should drop after done");

        // Check if bit4 set on drawn addr
        if (deck[uut.rand_index][4] !== 1) $error("Used flag not set");

        // Test case 3: Request again (next LFSR, unused)
        request_card = 1;
        #10;
        request_card = 0;
        #30;
        #10;

        // Test case 4: Simulate retry (set next rand to used)
        // Predict next LFSR: initial 101001 (41), next 010011 (19), next 100110 (38), next 001101 (13), etc.
        // After two draws, next should be around there; force one used
        deck[13] = {2'b00, 1'b1, 4'hA};  // Set used
        request_card = 1;
        #10;
        request_card = 0;
        #50;  // Allow time for retry (loop gen->read_wait->check->gen...)
        #10;

        // Test case 5: Reset during operation
        request_card = 1;
        #20;
        rst = 0;
        #10;
        rst = 1;
        #20;
        request_card = 0;
        #10;

        // End simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | state=%s | request_card=%b | card_ready=%b | deck_addr=%d | read_en=%b | write_en=%b | card_data_out=0x%h",
                 $time, uut.state.name, request_card, card_ready, deck_addr, deck_read_en, deck_write_en, card_data_out);
    end

endmodule