module adder6 (input logic [5:0] A, 
				  input logic [5:0] B, 
				  input logic Cin,
				  output logic [5:0] s, 
				  output logic Cout,
				  output logic Overflow);

	 logic c1, c2, c3, c4, c5;
	 
	 
	 fulladd FA0(.A(A[0]), .B(B[0]), .Cin(Cin), .s(s[0]), .Cout(c1));

	 fulladd FA1(.A(A[1]), .B(B[1]), .Cin(c1), .s(s[1]), .Cout(c2));

	 fulladd FA2(.A(A[2]), .B(B[2]), .Cin(c2), .s(s[2]), .Cout(c3));

	 fulladd FA3(.A(A[3]), .B(B[3]), .Cin(c3), .s(s[3]), .Cout(c4));
	 
	 fulladd FA4(.A(A[4]), .B(B[4]), .Cin(c4), .s(s[4]), .Cout(c5));
	 
	 fulladd FA5(.A(A[5]), .B(B[5]), .Cin(c5), .s(s[5]), .Cout(Cout));
	 
	 assign Overflow = (A[5] & B[5] & ~s[5]) | (~A[5] & ~B[5] & s[5]);
	 


endmodule