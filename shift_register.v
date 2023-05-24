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


module shift_register
(
	input clk,
	input rst_key,
	input ls_key,
	input rs_key,
	input ls_bit,
	input rs_bit,
	output [7:0] LEDS

);

wire reset_was_pressed, left_shift, rigth_shift;
reg [7:0] register;

button reset_button
(
	.clk		(clk),
	.key		(rst_key),
	.was_pressed(reset_was_pressed)
);

button left_shift_button
(
	.clk		(clk),
	.key		(ls_key),
	.was_pressed(left_shift)
);

button right_shift_button
(
	.clk		(clk),
	.key		(rs_key),
	.was_pressed(right_shift)
);

always @(posedge clk)
begin
	if (!rst_key)
		register <= 0;
	else if (left_shift)
		register <= {register[6:0], ls_bit};  //(register << 1) | ls_bit;
	else if (right_shift)
		register <= {rs_bit, register[7:1]}; 
end

assign LEDS = register;

endmodule