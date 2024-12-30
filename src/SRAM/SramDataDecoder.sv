module SramDataDecoder (
    input [20:0] i_object_pixel_index,
    input [15:0] i_sram_data,
    output [3:0] o_encoded_color
);
   
    wire [3:0] start_index;
    assign start_index[3:0] = i_object_pixel_index[1:0] << 2;
    assign o_encoded_color = i_sram_data[start_index +: 4];
endmodule