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

// circle image size
`define IMAGE_H 60
`define IMAGE_V 60

module vga (
    input i_clk,
    input i_rst_n,
    output o_H_sync, 
    output o_V_sync,
    output [7:0] o_R, 
    output [7:0] o_G, 
    output [7:0] o_B
);

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

assign o_H_sync = H_sync;
assign o_V_sync = V_sync;

// color_map for decode image_data
wire [23:0] color_map1 [0:15];
color_palette1 u_color_palette1 (
    .color_map    (color_map1)
);

wire [3:0] pixel_data1 [0:`IMAGE_V-1][0:`IMAGE_H-1];
image_data1 u_image_data1 (
    .pixel_data    (pixel_data1)
);



reg [11:0] H_rel1, V_rel1, H_rel2, V_rel2; // relative position to the LT corner
// Player position registers
reg [11:0] player1_x, player1_y;

// Player position update logic
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        // Reset to fixed positions
        player1_x <= `H_SIZE / 2;
        player1_y <= `V_SIZE / 2;
    end
end

// Modify rendering logic to use player position
always @(*) begin
    RGB_nxt = 0;
    if (H_STATE == S_C && V_STATE == S_C) begin
        // Calculate relative position based on player position
        H_rel1 = H_counter - player1_x;
        V_rel1 = V_counter  - player1_y;
        /*
        H_counter: now render position
        player1_x, player1_y: center
        H_rel2: relative postiion 
        */
        H_rel2 = H_counter - 100; // Second player1 fixed position
        V_rel2 = V_counter - 100; // Second player1 fixed position
        // Render player1's image
        if ((H_rel1 >= 0) && (H_rel1 < `IMAGE_H) && (V_rel1 >= 0) && (V_rel1 < `IMAGE_V)) begin
            RGB_nxt = color_map1[pixel_data1[V_rel1][H_rel1]];
        end
        // Render second player1's image
        else if ((H_rel2 >= 0) && (H_rel2 < `IMAGE_H) && (V_rel2 >= 0) && (V_rel2 < `IMAGE_V)) begin
            RGB_nxt = color_map1[pixel_data1[V_rel2][H_rel2]];
        end
        else if (((H_counter >= (`H_SIZE / 2 - 480) && H_counter < (`H_SIZE / 2 - 470)) || 
                  (H_counter >= (`H_SIZE / 2 + 470) && H_counter < (`H_SIZE / 2 + 480))) && 
                 ((V_counter >= (`V_SIZE / 2 - 240) && V_counter < (`V_SIZE / 2 + 240))) ||
                 ((V_counter >= (`V_SIZE / 2 - 240) && V_counter < (`V_SIZE / 2 - 230)) || 
                  (V_counter >= (`V_SIZE / 2 + 230) && V_counter < (`V_SIZE / 2 + 240))) && 
                 ((H_counter >= (`H_SIZE / 2 - 480) && H_counter < (`H_SIZE / 2 + 480)))) begin
            RGB_nxt = 24'hFFFFFF; // White color
        end        
        else begin
            // Render background color
            RGB_nxt = 0;
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

always @(*) begin
    frame_counter_nxt = frame_counter;
    if((H_STATE == S_A) && (V_STATE == S_A)) begin
        if((H_counter == `H_A) && (V_counter == `V_A)) frame_counter_nxt = frame_counter + 1;
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
    end
end

endmodule