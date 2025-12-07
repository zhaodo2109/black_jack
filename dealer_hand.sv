module dealer_hand(
    input  logic [5:0] data,     // 6-bit card index 0–51
    input  logic [2:0] wraddr,   // index 0–4
    input  logic [2:0] raddr,
    input  logic       wen,
    input  logic       ren,
    input  logic       clk,
    output logic [5:0] q
);

    logic [5:0] mem [0:4];       // 5 card slots

    always_ff @(posedge clk) begin
        if (wen)
            mem[wraddr] <= data;

        if (ren)
            q <= mem[raddr];
    end

endmodule
