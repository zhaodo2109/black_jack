module deck_loader ( input  logic clk, rst,
							output logic load_done,
							output logic [5:0] deck_addr,
							output logic deck_wen,
							output logic [6:0]  deck_data_in
						 );

    typedef enum logic [1:0] {idle, load, done} state_t;
    state_t state, next;

    logic [5:0] addr;  // 0–51

    logic [6:0] lookup_val;
    deck_lookup rom (
        .addr(addr),
        .data_out(lookup_val)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            state <= idle;
        else
            state <= next;
    end

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            addr <= 0;
        else if (state == load)
            addr <= addr + 1;
    end

    always_comb begin
        deck_wen = 0;
        deck_data_in = lookup_val;
        deck_addr = addr;
        load_done = 0;

        next = state;

        case (state)

        idle: begin
            if (!rst)
                next = idle;
            else
                next = load;
        end

        load: begin
            deck_wen = 1;   
            if (addr == 6'd51)
                next = done;
        end

        done: begin
            load_done = 1;
        end

        endcase
    end

endmodule
