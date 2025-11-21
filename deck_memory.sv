module deck_memory (
    input  logic        clk,
    input  logic [5:0]  addr,
    input  logic [6:0]  data_in, //suits [2:0], cards value [4:0]
    input  logic        wen,
    output logic [6:0]  data_out
);

    logic [6:0] deck [0:51];

    always_ff @(posedge clk) begin
        if (wen)
            deck[addr] <= data_in;
        data_out <= deck[addr];
    end
endmodule
