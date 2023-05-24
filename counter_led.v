module button
(
	input clk,
	input key,
	output is_pressed
);
reg but_r;
reg but_rr;

always @(posedge clk)
begin
	but_r <= key;
	but_rr <= but_r;
end
	assign is_pressed = but_rr & ~but_r;
endmodule // button

module hex2LEDS
(
	input  [8:0] hex,
	output [8:0] LEDS
	
);

assign LEDS = hex;

endmodule // hex2LEDS

module counter_led
(
	input clk,
	input reset_key,
	input inc_count_key,
	input dec_count_key,
	output [8:0] LEDS
);

reg [8:0] hex;
reg [8:0] counter;
wire reset_is_pressed;
wire inc_count_is_pressed;
wire dec_count_is_pressed;

button reset
(
	.clk(clk),
	.key(reset_key),
	.is_pressed(reset_is_pressed)
);

button inc_count_button
(
	.clk(clk),
	.key(inc_count_key),
	.is_pressed(inc_count_is_pressed)
);

button dec_count_button
(
	.clk(clk),
	.key(dec_count_key),
	.is_pressed(dec_count_is_pressed)
);

hex2LEDS hex2LEDS
(
	.hex(hex),
	.LEDS(LEDS)
);

always @(posedge clk)
begin
	if (!reset_key)
		counter <= 0;
	else if (inc_count_is_pressed)
		counter <= counter == 8'd8 ? 8'd0 : counter + 1;
	else if (dec_count_is_pressed)
		counter <= counter == 8'd0 ? 8'd8 : counter - 1;
end

always @(posedge clk)
begin
	hex <= counter != 0 ? (9'd1 << (counter)) - 1 : 0;
end

endmodule // counter_led

