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

module hex2s
(
	input  [3:0] hex,
	output [6:0] segm
);

assign segm =   (hex == 4'h0) ? 7'b1000000 :
		(hex == 4'h1) ? 7'b1111001 :
		(hex == 4'h2) ? 7'b0100100 :
		(hex == 4'h3) ? 7'b0110000 :
		(hex == 4'h4) ? 7'b0011001 :
		(hex == 4'h5) ? 7'b0010010 :
		(hex == 4'h6) ? 7'b0000010 :
		(hex == 4'h7) ? 7'b1111000 :
		(hex == 4'h8) ? 7'b0000000 :
		(hex == 4'h9) ? 7'b0010000 :
		(hex == 4'ha) ? 7'b0001000 :
		(hex == 4'hb) ? 7'b0000011 :
		(hex == 4'hc) ? 7'b1000110 :
		(hex == 4'hd) ? 7'b0100001 :
		(hex == 4'he) ? 7'b0000110 :
		(hex == 4'hf) ? 7'b0001110 : 7'b0001110;
endmodule // hex2segm

module click_counter_extra
(
	input clk,
	input reset_key,
	input inc_count_key,
	input dec_count_key,
	output [6:0] segm
);

reg [3:0] counter;
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

always @(posedge clk)
begin
	if (reset_is_pressed)
		counter <= 0;
	else if (inc_count_is_pressed)
		counter <= counter == 4'hf ? 0 : counter + 1;
	else if (dec_count_is_pressed)
		counter <= counter == 4'h0 ? 4'hf : counter - 1;
end

endmodule // click counter

