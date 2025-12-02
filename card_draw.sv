module card_draw ( input  logic clk,
						 input  logic rst,
						 input  logic request_card,
						 output logic [5:0]  deck_addr,
						 output logic deck_read_en,
						 output logic deck_write_en,
						 output logic [6:0] deck_write_data,
						 input  logic [6:0] deck_read_data,
						 output logic card_ready,
						 output logic [6:0] card_data_out
					);

    logic [5:0] lfsr;
    logic [5:0] rand_index;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            lfsr <= 6'b101001;
        else
            lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[3]};
    end

    assign rand_index = lfsr % 6'd52;

    typedef enum logic [2:0] {idle, gen,read_wait, check,used, done} state_t;
    state_t state, next;


    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            state <= idle;
        else
            state <= next;
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            card_ready <= 0;
            card_data_out <= 0;
        end
        else begin
            if (state == done) begin
                card_ready <= 1;
                card_data_out <= deck_read_data;
            end
            else begin
                card_ready <= 0;
            end
        end
    end

    always_comb begin
        deck_read_en    = 0;
        deck_write_en   = 0;
        deck_addr       = 0;
        deck_write_data = 0;
        next            = state;

        case (state)
            idle: if (request_card) 
					next = gen;

            gen: begin
                deck_addr = rand_index;
                deck_read_en = 1;
                next = read_wait;
            end
				
				read_wait: begin
					deck_addr = rand_index;
					next = check;
				end
				

            check: begin
                deck_addr = rand_index;
                if (deck_read_data[4]) // used flag
                    next = gen;
                else
                    next = used;
            end
				
				used: begin
					 deck_addr = rand_index;
                deck_write_en = 1;
                deck_write_data = {deck_read_data[6:5], 1'b1, deck_read_data[3:0]};
                next = done;
				end

            done: begin
                next = idle;
            end
        endcase
    end
endmodule

/*
module card_draw (
    input  logic clk,
    input  logic rst,
    input  logic request_card,
    output logic [5:0] deck_addr,
    output logic deck_read_en,
    output logic deck_write_en,
    output logic [6:0] deck_write_data,
    input  logic [6:0] deck_read_data,
    output logic card_ready,
    output logic [6:0] card_data_out
);

    // =====================================================
    // LFSR random generator
    // =====================================================
    logic [5:0] lfsr;
    logic [5:0] rand_index;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            lfsr <= 6'b101001;
        else 
            lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[3]};
    end

    assign rand_index = lfsr % 6'd52;

    // =====================================================
    // FSM declaration
    // =====================================================
    typedef enum logic [2:0] {
        idle, gen, read_wait, check, used, done
    } state_t;

    state_t state, next;

    // =====================================================
    // Detect rising edge of request_card
    // =====================================================
    logic req_d, req_pulse;
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            req_d <= 1'b0;
        else
            req_d <= request_card;
    end
    assign req_pulse = request_card & ~req_d;

    // =====================================================
    // State register
    // =====================================================
    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            state <= idle;
        else
            state <= next;
    end

    // =====================================================
    // Card ready and output latch
    // =====================================================
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            card_ready <= 0;
            card_data_out <= 0;
        end
        else begin
            if (state == done) begin
                card_ready <= 1;
                card_data_out <= deck_read_data;
            end
            else
                card_ready <= 0;
        end
    end

    // =====================================================
    // FSM next-state and memory control logic
    // =====================================================
    always_comb begin
        deck_read_en    = 0;
        deck_write_en   = 0;
        deck_addr       = 0;
        deck_write_data = 0;
        next            = state;

        case (state)
            idle: begin
                // *** only start when new request pulse occurs ***
                if (req_card)
                    next = gen;
            end

            gen: begin
                deck_addr = rand_index;
                deck_read_en = 1;
                next = read_wait;
            end

            read_wait: begin
                deck_addr = rand_index;
                next = check;
            end

            check: begin
                deck_addr = rand_index;
                if (deck_read_data[4]) // used flag = 1 already drawn
                    next = gen;        // retry new random
                else
                    next = used;       // unused card, mark as used
            end

            used: begin
                deck_addr       = rand_index;
                deck_write_en   = 1;
                deck_write_data = {deck_read_data[6:5], 1'b1, deck_read_data[3:0]};
                next = done;
            end

            done: begin
                next = idle;
            end
        endcase
    end
endmodule
*/