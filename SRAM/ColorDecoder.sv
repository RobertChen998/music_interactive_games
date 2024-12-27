module ColorDecoder (
    input [3:0] i_encoded_color,
    output [23:0] o_decoded_color
);
wire [23:0] color_map [0:15];

bg_palette u_bg_palette (
    .color_map    (color_map)
);

assign o_decoded_color = color_map[i_encoded_color];


endmodule