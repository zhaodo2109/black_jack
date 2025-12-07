/*module player_hand(
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
*/

// player_hand.sv  (final clean version – NO read port needed)
module player_hand (
    input  logic       clk,
    input  logic       rst,          // connect to sync_rst in fullgame

    input  logic [6:0] data,         // card index 0-51 from card_draw
    input  logic [2:0] wraddr,       // write address 0-4
    input  logic       wen,          // write enable (deal_player && card_ready)

    // Direct combinatorial view of all 5 cards in the hand
    output logic [5:0] card0,
    output logic [5:0] card1,
    output logic [5:0] card2,
    output logic [5:0] card3,
    output logic [5:0] card4
);

    // 5-slot memory holding card indices
    logic [5:0] mem [0:4];

    // Synchronous write + reset
    always_ff @(posedge clk) begin
        if (rst) begin
            mem[0] <= 6'd0;
            mem[1] <= 6'd0;
            mem[2] <= 6'd0;
            mem[3] <= 6'd0;
            mem[4] <= 6'd0;
        end
        else if (wen) begin
            mem[wraddr] <= data;
        end
    end
/*
    // All five cards are always visible for display logic
    assign card0 = mem[0];
    assign card1 = mem[1];
    assign card2 = mem[2];
    assign card3 = mem[3];
    assign card4 = mem[4];
*/

always_ff @(posedge clk or posedge rst) begin
  if (rst) {card0,card1,card2,card3,card4} <= 0;
  else begin
    card0 <= mem[0];
    card1 <= mem[1];
    card2 <= mem[2];
    card3 <= mem[3];
    card4 <= mem[4];
  end
end
  
endmodule