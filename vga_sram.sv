// clock 25.2M
// `define H_SIZE 640
// `define V_SIZE 480
// `define FRAME_RATE 60
// `define H_A 96
// `define H_B 48
// `define H_D 16
// `define V_A 2
// `define V_B 33
// `define V_D 10

// clock 108M
`define H_SIZE 1600
`define V_SIZE 900
`define FRAME_RATE 60
`define H_A 24
`define H_B 80
`define H_D 96
`define V_A 1
`define V_B 3
`define V_D 96
/*
full: 1600*900
score panel:
1background: 1600*900
*/

// circle ans number image size
`define IMAGE_H 60
`define IMAGE_V 60
// score panel image size
`define IMAGE_H_SCORE 180
`define IMAGE_V_SCORE 60
module vga_sram (
    input i_clk,
    input i_rst_n,
    input logic [8:0] score,
    output o_H_sync, 
    output o_V_sync,
    output [7:0] o_R, 
    output [7:0] o_G, 
    output [7:0] o_B,
    output [19:0] o_SRAM_ADDR,
	inout  [15:0] io_SRAM_DQ,
	output o_SRAM_WE_N,

    input [15:0] position
);

wire [15:0] sram_data;

assign o_SRAM_WE_N = 1;
assign o_SRAM_ADDR = sram_addr;
assign io_SRAM_DQ  = 16'dz;
assign sram_data = io_SRAM_DQ;
// assign o_SRAM_WE_N = !sram_writing;
// assign o_SRAM_ADDR = sram_addr;
// assign io_SRAM_DQ  = sram_writing ? data_encode : 16'dz;
// assign data_decode = sram_writing ? 16'd0 : io_SRAM_DQ;

//circle signal
reg [15:0] position1_w, position2_w, position3_w, position1_r, position2_r, position3_r;

    
parameter S_B = 0;
parameter S_C = 1;
parameter S_D = 2;
parameter S_A = 3;

reg [23:0] RGB, RGB_nxt;
assign o_R = RGB[23:16];
assign o_G = RGB[15: 8];
assign o_B = RGB[ 7: 0];

reg [1:0] H_STATE, H_STATE_nxt;
reg [11:0] H_counter, H_counter_nxt;

reg [1:0] V_STATE, V_STATE_nxt;
reg [11:0] V_counter, V_counter_nxt;

reg [31:0] frame_counter, frame_counter_nxt;

reg V_sync, V_sync_nxt, H_sync, H_sync_nxt;

reg [20:0] object_pixel_index_after_sram,object_pixel_index_during_sram,object_pixel_index_before_sram,object_pixel_index_before_sram_nxt;

reg [8:0] score_nxt;
assign o_H_sync = H_sync;
assign o_V_sync = V_sync;
// ============================  ALL PICTURE DEFINITION ============================
// 0-9 look up table
wire [23:0] color_map0 [0:15];
color_palette0 u_color_palette0 (
    .color_map    (color_map0)
);
wire [3:0] pixel_data0 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data0 u_image_data0 (
    .pixel_data    (pixel_data0)
);
wire [23:0] color_map1 [0:15];
color_palette1 u_color_palette1 (
    .color_map    (color_map1)
);

wire [3:0] pixel_data1 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data1 u_image_data1 (
    .pixel_data    (pixel_data1)
);
wire [23:0] color_map2 [0:15];
color_palette2 u_color_palette2 (
    .color_map    (color_map2)
);
wire [3:0] pixel_data2 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data2 u_image_data2 (
    .pixel_data    (pixel_data2)
);
wire [23:0] color_map3 [0:15];
color_palette3 u_color_palette3 (
    .color_map    (color_map3)
);
wire [3:0] pixel_data3 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data3 u_image_data3 (
    .pixel_data    (pixel_data3)
);
wire [23:0] color_map4 [0:15];
color_palette4 u_color_palette4 (
    .color_map    (color_map4)
);
wire [3:0] pixel_data4 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data4 u_image_data4 (
    .pixel_data    (pixel_data4)
);
wire [23:0] color_map5 [0:15];
color_palette5 u_color_palette5 (
    .color_map    (color_map5)
);
wire [3:0] pixel_data5 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data5 u_image_data5 (
    .pixel_data    (pixel_data5)
);
wire [23:0] color_map6 [0:15];
color_palette6 u_color_palette6 (
    .color_map    (color_map6)
);
wire [3:0] pixel_data6 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data6 u_image_data6 (
    .pixel_data    (pixel_data6)
);
wire [23:0] color_map7 [0:15];
color_palette7 u_color_palette7 (
    .color_map    (color_map7)
);
wire [3:0] pixel_data7 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data7 u_image_data7 (
    .pixel_data    (pixel_data7)
);
wire [23:0] color_map8 [0:15];
color_palette8 u_color_palette8 (
    .color_map    (color_map8)
);
wire [3:0] pixel_data8 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data8 u_image_data8 (
    .pixel_data    (pixel_data8)
);
wire [23:0] color_map9 [0:15];
color_palette9 u_color_palette9 (
    .color_map    (color_map9)
);
wire [3:0] pixel_data9 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data9 u_image_data9 (
    .pixel_data    (pixel_data9)
);
 // score panel
wire [23:0] color_map_score [0:15];
color_map_score u_color_palette_score (
    .color_map    (color_map_score)
);
wire [3:0] pixel_data_score [0:`IMAGE_V_SCORE-1][0:`IMAGE_H_SCORE-1];
image_data_score u_image_data_score (
    .pixel_data    (pixel_data_score)
);
// circle1-3
wire [23:0] color_circle1 [0:15];
color_circle1 u_color_circle1 (
    .color_map    (color_circle1)
);
wire [3:0] pixel_data_circle1 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data_circlel u_image_data_circle1 (
    .pixel_data    (pixel_data_circle1)
);
wire [23:0] color_circle2 [0:15];
color_circle2 u_color_circle2 (
    .color_map    (color_circle2)
);
wire [3:0] pixel_data_circle2 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data_circle2 u_image_data_circle2 (
    .pixel_data    (pixel_data_circle2)
);
wire [23:0] color_circle3 [0:15];
color_circle3 u_color_circle3 (
    .color_map    (color_circle3)
);
wire [3:0] pixel_data_circle3 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data_circle3 u_image_data_circle3 (
    .pixel_data    (pixel_data_circle3)
);

// ============================  Sram define here ============================
wire [19:0] sram_addr;
SramAddrEncoder sram_addr_encoder(
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_object_pixel_index(object_pixel_index_before_sram),
    .o_sram_addr(sram_addr)

);

wire [3:0] encoded_color;
SramDataDecoder sram_data_decoder(
    .i_object_pixel_index(object_pixel_index_after_sram),
    .i_sram_data(sram_data),
    .o_encoded_color(encoded_color)

);

wire [23:0] decoded_color;
ColorDecoder color_decoder(
    .i_encoded_color(encoded_color),
    .o_decoded_color(decoded_color)
);

// ============================  Pistion define here ============================
// relative position
reg [11:0] H_rel1, V_rel1, H_rel2, V_rel2, H_rel3, V_rel3, H_rel4, V_rel4, H_rel5, V_rel5, H_rel6, V_rel6, H_rel7, V_rel7, H_rel8, V_rel8, H_rel9, V_rel9, H_rel10, V_rel10;

// all picture position
// score panel position
reg [11:0] score_x, score_y;
// score number1 position
reg [11:0] score1_x, score1_y;
// score number2 position
reg [11:0] score2_x, score2_y;
// score number3 position
reg [11:0] score3_x, score3_y;
// circle1 position (dark circle)
reg [11:0] circle1_x, circle1_y;
// circle2 position (light circle, light circle is used to show the next cicrle position)
reg [11:0] circle2_x, circle2_y;
// circle3 position 
reg [11:0] circle3_x, circle3_y;
// background position
reg [11:0] background_x, background_y;
// Player position update logic
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        // Reset to fixed positions
        circle1_x <= `H_SIZE / 2;
        circle1_y <= `V_SIZE / 2;
        circle2_x <= `H_SIZE / 3;
        circle2_y <= `V_SIZE / 3;
        circle3_x <= `H_SIZE / 4;
        circle3_y <= `V_SIZE / 4;
        score_x <= 680;
        score_y <= 110;
        score1_x <= 860;
        score1_y <= 110;
        score2_x <= 920;
        score2_y <= 110;
        score3_x <= 980;
        score3_y <= 110;
        background_x <= 0;
        background_y <= 200;
    end
    else begin
        /*
        to lee guan yee:
            position[15:8] is x position, ranges from 0 to 31 
            position[7: 0] is y position, ranges from 0 to 15 
            modify the following code to fit position to screen size
            also, i noticed that if the position assigned to cirle1_x is too small, VGA would not receive any signal, black screen
        */
        circle1_x <= 0+ position1_r[15:8] * 50;
        circle1_y <= 0+ position1_r[7:0] * 50;
        circle2_x <= 0+ position2_r[15:8] * 50;
        circle2_y <= 0+ position2_r[7:0] * 50;
        circle3_x <= 0+ position3_r[15:8] * 50;
        circle3_y <= 0+ position3_r[7:0] * 50;
        score_x <= 680;
        score_y <= 110;
        score1_x <= 860;
        score1_y <= 110;
        score2_x <= 920;
        score2_y <= 110;
        score3_x <= 980;
        score3_y <= 110;
        background_x <= 0;
        background_y <= 180;
    end
end

// Modify rendering logic to use player position
always @(*) begin
    // H_counter: now render position
    // circle1_x, circle1_y: center
    // H_rel2: relative postiion 
    RGB_nxt = 0;
    frame_counter_nxt = frame_counter;
    object_pixel_index_before_sram_nxt = object_pixel_index_before_sram;
    
    // one picture need one H_STATE and V_STATE to render
    H_rel1 = H_counter - circle1_x;
    V_rel1 = V_counter - circle1_y;
    H_rel2 = H_counter - circle2_x;
    V_rel2 = V_counter - circle2_y;
    H_rel8 = H_counter - circle3_x;
    V_rel8 = V_counter - circle3_y;
    H_rel3 = H_counter - score_x;
    V_rel3 = V_counter - score_y;
    H_rel4 = H_counter - score1_x;
    V_rel4 = V_counter - score1_y;
    H_rel5 = H_counter - score2_x;
    V_rel5 = V_counter - score2_y;
    H_rel6 = H_counter - score3_x;
    V_rel6 = V_counter - score3_y;
    H_rel7 = H_counter - background_x;
    V_rel7 = V_counter - background_y;


    if (H_STATE == S_C && V_STATE == S_C) begin
        // Render circle1 image
         if ((H_rel1 >= 0) && (H_rel1 < `IMAGE_H) && (V_rel1 >= 0) && (V_rel1 < `IMAGE_V)) begin
            RGB_nxt = color_circle1[pixel_data_circle1[V_rel1][H_rel1]];
        end
        // Render circle2 image
        else if ((H_rel2 >= 0) && (H_rel2 < `IMAGE_H) && (V_rel2 >= 0) && (V_rel2 < `IMAGE_V)) begin
            RGB_nxt = color_circle2[pixel_data_circle2[V_rel2][H_rel2]];
        end
        // Render circle3 image
        else if ((H_rel8 >= 0) && (H_rel8 < `IMAGE_H) && (V_rel8 >= 0) && (V_rel8 < `IMAGE_V)) begin
            RGB_nxt = color_circle3[pixel_data_circle3[V_rel8][H_rel8]];
        end
        // Render score panel
        else if ((H_rel3 >= 0) && (H_rel3 < `IMAGE_H_SCORE) && (V_rel3 >= 0) && (V_rel3 < `IMAGE_V_SCORE)) begin
            RGB_nxt = color_map_score[pixel_data_score[V_rel3][H_rel3]];
        end
        // Render score number1
        case (score / 100)
            0: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map0[pixel_data0[V_rel4][H_rel4]];
            end
            1: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map1[pixel_data1[V_rel4][H_rel4]];
            end
            2: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map2[pixel_data2[V_rel4][H_rel4]];
            end
            3: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map3[pixel_data3[V_rel4][H_rel4]];
            end
            4: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map4[pixel_data4[V_rel4][H_rel4]];
            end
            5: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map5[pixel_data5[V_rel4][H_rel4]];
            end
            6: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map6[pixel_data6[V_rel4][H_rel4]];
            end
            7: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map7[pixel_data7[V_rel4][H_rel4]];
            end
            8: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map8[pixel_data8[V_rel4][H_rel4]];
            end
            9: if ((H_rel4 >= 0) && (H_rel4 < `IMAGE_H) && (V_rel4 >= 0) && (V_rel4 < `IMAGE_V)) begin
            RGB_nxt = color_map9[pixel_data9[V_rel4][H_rel4]];
            end
            default: RGB_nxt = 0;
        endcase
        // Render score number2
        else if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
            case ((score / 10) % 10)
                0: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map0[pixel_data0[V_rel5][H_rel5]];
                end
                1: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map1[pixel_data1[V_rel5][H_rel5]];
                end
                2: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map2[pixel_data2[V_rel5][H_rel5]];
                end
                3: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map3[pixel_data3[V_rel5][H_rel5]];
                end
                4: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map4[pixel_data4[V_rel5][H_rel5]];
                end
                5: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map5[pixel_data5[V_rel5][H_rel5]];
                end
                6: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map6[pixel_data6[V_rel5][H_rel5]];
                end
                7: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map7[pixel_data7[V_rel5][H_rel5]];
                end
                8: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map8[pixel_data8[V_rel5][H_rel5]];
                end
                9: if ((H_rel5 >= 0) && (H_rel5 < `IMAGE_H) && (V_rel5 >= 0) && (V_rel5 < `IMAGE_V)) begin
                    RGB_nxt = color_map9[pixel_data9[V_rel5][H_rel5]];
                end
                default: RGB_nxt = 0;
            endcase
        end
        // Render score number3
        else if ((H_rel6 >= 0) && (H_rel6 < `IMAGE_H) && (V_rel6 >= 0) && (V_rel6 < `IMAGE_V)) begin
            case (score % 10)
                0: RGB_nxt = color_map0[pixel_data0[V_rel6][H_rel6]];
                5: RGB_nxt = color_map5[pixel_data5[V_rel6][H_rel6]];
                default: RGB_nxt = 0;
            endcase
        end

        // Render background image(from sram)        
        else if ((H_rel7 >= 0) && (H_rel7 < `H_SIZE) && (V_rel7 >= 0) && (V_rel7 < `V_SIZE)) begin
            RGB_nxt = decoded_color;
        end
        else begin
            RGB_nxt = 0;
        end
        object_pixel_index_before_sram_nxt = object_pixel_index_before_sram + 1;
    end
    if((H_STATE == S_A) && (V_STATE == S_A)) begin
        if((H_counter == `H_A) && (V_counter == `V_A)) begin
            frame_counter_nxt = frame_counter + 1;
            object_pixel_index_before_sram_nxt = 0;
        end
    end
end

always_comb begin
    H_STATE_nxt = H_STATE;
    H_counter_nxt = H_counter + 1;
    H_sync_nxt = !(H_STATE == S_A);

    case (H_STATE)
        S_B: begin 
            if (H_counter == `H_B) begin
                H_STATE_nxt = S_C;
                H_counter_nxt = 1;
            end
        end
        S_C: begin 
            if (H_counter == `H_SIZE) begin
                H_STATE_nxt = S_D;
                H_counter_nxt = 1;
            end
        end
        S_D: begin 
            if (H_counter == `H_D) begin
                H_STATE_nxt = S_A;
                H_counter_nxt = 1;
            end
        end
        S_A: begin 
            if (H_counter == `H_A) begin
                H_STATE_nxt = S_B;
                H_counter_nxt = 1;
            end
        end
    endcase
    
end

always_comb begin
    V_STATE_nxt = V_STATE;
    V_counter_nxt = V_counter;
    V_sync_nxt = !(V_STATE == S_A);

    if (H_STATE == S_A && H_counter == `H_A) begin
        V_counter_nxt = V_counter + 1;
        case (V_STATE)
            S_B: begin 
                if (V_counter == `V_B) begin
                    V_STATE_nxt = S_C;
                    V_counter_nxt = 1;
                end
            end
            S_C: begin 
                if (V_counter == `V_SIZE) begin
                    V_STATE_nxt = S_D;
                    V_counter_nxt = 1;
                end
            end
            S_D: begin 
                if (V_counter == `V_D) begin
                    V_STATE_nxt = S_A;
                    V_counter_nxt = 1;
                end
            end
            S_A: begin 
                if (V_counter == `V_A) begin
                    V_STATE_nxt = S_B;
                    V_counter_nxt = 1;
                end
            end
        endcase
    end
end

always_comb begin
    //keep last 3 position, by cianfong
    if(position1_r!=position && position!=-1)begin
        position1_w = position;
        position2_w = position1_r;
        position3_w = position2_r;
    end
    else begin
        position1_w = position1_r;
        position2_w = position2_r;
        position3_w = position3_r;
    end
end

    
always_ff @(posedge i_clk or negedge i_rst_n) begin 
    if (!i_rst_n) begin
        H_STATE <= S_B;
        H_counter <= 1;
        H_sync <= 1;
        V_STATE <= S_B;
        V_counter <= 1;
        V_sync <= 1;
        RGB <= 0;
        frame_counter <= 0;
        object_pixel_index_before_sram <= 0;
        object_pixel_index_during_sram <= 0;
        object_pixel_index_after_sram <= 0;
        position1_r <= 0;
        position2_r <= 0;
        position3_r <= 0;

    end
    else begin
        H_STATE <= H_STATE_nxt;
        H_counter <= H_counter_nxt;
        H_sync <= H_sync_nxt;
        V_STATE <= V_STATE_nxt;
        V_counter <= V_counter_nxt;
        V_sync <= V_sync_nxt;
        RGB <= RGB_nxt;
        frame_counter <= frame_counter_nxt;
        object_pixel_index_before_sram <= object_pixel_index_before_sram_nxt;
        object_pixel_index_during_sram <= object_pixel_index_before_sram;
        object_pixel_index_after_sram <= object_pixel_index_during_sram;
        position1_r <= position1_w;
        position2_r <= position2_w;
        position3_r <= position3_w;
        score <= score_nxt;
    end
end
endmodule