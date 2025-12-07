module display10(
    output logic [6:0] disp1, // left (shows '1')
    output logic [6:0] disp2  // right (shows '0')
);

    // disp1 will show the digit '1' (6'd20) and disp2 will show '0' (6'd21).
    display disp_tens(.displayNum(6'd21), .displayOut(disp1));
    display disp_ones(.displayNum(6'd20), .displayOut(disp2));

endmodule
