module fulladd(input logic A, B, Cin,
               output logic s, Cout);


	assign s = Cin ^ (A ^ B);
	assign Cout = (A&B) | ((A^B)&Cin);

endmodule