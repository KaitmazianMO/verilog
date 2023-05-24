module button
(
	input clk,
	input key,
	output was_pressed
);
reg but_r;
reg but_rr;

always @(posedge clk)
begin
	but_r <= key;
	but_rr <= but_r;
end
	assign was_pressed = but_rr & ~but_r;
endmodule // button


module sum // store register
(
	input clk,
	input reset_key,
	input write_key,
	input move_key,
	input [7:0] num1,
	input [7:0] num2,
	output [7:0] RED_LEDS1,
	output [7:0] RED_LEDS2,
	output [7:0] GREN_LEDS

);

wire reset_was_pressed, write, move;
reg [7:0] RLEDS_value;
reg [7:0] GLEDS_value;

button reset_button
(
	.clk		(clk),
	.key		(reset_key),
	.was_pressed(reset_was_pressed)
);

button write_buton
(
	.clk		(clk),
	.key		(write_key),
	.was_pressed(write)
);

button move_buton
(
	.clk		(clk),
	.key		(move_key),
	.was_pressed(move)

);

always @(posedge clk)
begin
	if (!reset_key)
	begin
		RLEDS_value <= 0;
		GLEDS_value <= 0;
	end
	else if (write)
		RLEDS_value <= num1;
	else if (move)
		GLEDS_value <= RLEDS_value;
end

assign RED_LEDS1[7:0] = RLEDS_value[7:0];
assign GREN_LEDS[7:0] = GLEDS_value[7:0];

endmodule // sum