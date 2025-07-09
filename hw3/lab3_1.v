`timescale 1ns / 1ps

module ac_flip_flop(
    input A,
    input C,
    input clk,
    output reg Q
    );

    initial begin
    Q = 1'b1;  // Ensure Q starts as 1 at simulation start
end
	always @(posedge clk) begin
    case ({A,C})
        2'b00: Q <= 1'b1;
        2'b01: Q <= ~Q;
        2'b10: ;
        2'b11: Q <= 1'b1;
    endcase   
end



endmodule

module ic1406(
    input A0,
    input A1,
    input A2,
    input clk,
    output Q0,
    output Q1,
    output Z
);
    wire A_input_first, C_input_first;
    wire A_input_second, C_input_second;

    // Compute the inputs for the first AC Flip Flop
    assign A_input_first = ((A0 ^ A1) ~| !A2); // (A0 XOR A1) NOR !A2
    assign C_input_first = A0 & A1; // A0A1

    // Compute the inputs for the second AC Flip Flop
    assign A_input_second = A0 & A1; // A0A1
    assign C_input_second = (!A0 | !A1) & !A2; // (!A0 + !A1) AND !A2

    // Instantiate the first AC Flip Flop
    ac_flip_flop FF1 (
        .A(A_input_first),
        .C(C_input_first),
        .clk(clk),
        .Q(Q0)
    );

    // Instantiate the second AC Flip Flop
    ac_flip_flop FF2 (
        .A(A_input_second),
        .C(C_input_second),
        .clk(clk),
        .Q(Q1)
    );

    // Compute output Z
    assign Z = Q0 ^ Q1; // Output Z is Q0 XOR Q1

	// YOUR IMPLEMENTATION HERE
	
endmodule

