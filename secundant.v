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


module hex2segm
(
	input [3:0] hex,
	output [6:0] segm
);
assign segm = (hex == 4'h0) ? 7'b1000000 :
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
endmodule


module secundant
(
	input clk,
	input reset_key,
	input start_or_stop_key,
	output [6:0] SECONDS1_HEX,
	output [6:0] SECONDS2_HEX,
	output [6:0] DECISECONDS_HEX
);

//  /--------------|--------------|-----------------\
//  | SECONDS2_HEX | SECONDS1_HEX | DECISECONDS_HEX |
//  \--------------|--------------|-----------------/

wire reset, start_or_stop;
reg [32:0] clock_counter;

reg [3:0] sec_2;
reg [3:0] sec_1;
reg [3:0] sec_d;

reg is_stopped;

button reset_button
(
	.clk			(clk),
	.key			(reset_key),
	.was_pressed	(reset)
);

button stop_or_start_button
(
	.clk			(clk),
	.key			(start_or_stop_key),
	.was_pressed	(start_or_stop)
);

hex2segm second_segm
(
	.hex	(sec_2[3:0]),
	.segm	(SECONDS2_HEX)

);

hex2segm first_segm
(
	.hex	(sec_1[3:0]),
	.segm	(SECONDS1_HEX)
);

hex2segm deci_segm
(
	.hex	(sec_d[3:0]),
	.segm	(DECISECONDS_HEX)

);

always @(posedge clk)
begin
	if (~reset_key)
	begin
		clock_counter <= 0;
		sec_1 <= 0;
		sec_2 <= 0;
		sec_d <= 0;
		is_stopped <= 1;
	end
	
	else if (start_or_stop)
		is_stopped <= ~is_stopped;
		
	else
	begin
		if (~is_stopped)
		begin
			if (clock_counter > 32'd5000000)
			begin
				clock_counter <= 0;
				if (sec_d == 9 && sec_1 == 9 && sec_2 == 9)
				begin
					sec_d <= 0;
					sec_1 <= 0;
					sec_2 <= 0;
				end
			
				else if (sec_d == 9 && sec_1 == 9)
				begin
					sec_d <= 0;
					sec_1 <= 0;
					sec_2 <= sec_2 + 1;
				end
			
				else if (sec_d == 9)
				begin
					sec_d <= 0;
					sec_1 <= sec_1 + 1;
				end
			
				else 
					sec_d <= sec_d + 1;
			end
			else //clock_counter < 32'd5000000
				clock_counter <= clock_counter + 1;
		end
	end
end


endmodule 