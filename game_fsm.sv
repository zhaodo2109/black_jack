module game_fsm(input  logic clk, rst,
					 input  logic start,
					 input  logic hit,
					 input  logic stand,

					 input  logic [5:0] player_sum,
					 input  logic [5:0] dealer_sum,
					 input  logic dealer_bust,

					 output logic deal_player,
					 output logic deal_dealer,
					 output logic clear_sums,
					 output logic compare,
					 input logic dealer_auto_hit
					);

    typedef enum logic [2:0] {idle, deal, hit_s, stand_s, result} state_t;
    state_t state, next;

    always_ff @(posedge clk or negedge rst)
        if (!rst)
            state <= idle;
        else
            state <= next;

    always_comb begin
        deal_player = 0;
        deal_dealer = 0;
        clear_sums = 0;
        compare = 0;
        //dealer_auto_hit = 0;

        next = state;

        case(state)

        idle: begin
            clear_sums = 1;
            if (start)
                next = deal;
        end

        deal: begin
            deal_player = 1;
            deal_dealer = 1;
            next = hit_s;
        end

        hit_s: begin
            if (hit)
                deal_player = 1;
            else if (stand)
                next = stand_s;
        end

        stand_s: begin
            if (dealer_bust)
                next = result;
            else if (dealer_auto_hit) begin
                deal_dealer = 1;
            end else
                next = result;
        end

        result: begin
            compare = 1;
            if (!rst)
                next = idle;
        end

        endcase
    end

endmodule
