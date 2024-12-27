module core (
    input clk,
    input rst_n,
    input [15:0] position_note,
    input [31:0] position_hand,
    input [2:0] tolerance,

    output [9:0] score,
    output [15:0] circle1_position,
    output [15:0] circle2_position,
    output [15:0] circle3_position,
    output [15:0] circle4_position,
    output [15:0] circle5_position,

    output circle1_show,
    output circle2_show,
    output circle3_show
);
    parameter MINUS1 = 16'hffff;
    reg [9:0] score_r, score_w;
    reg [15:0] circle1_position_r, circle1_position_w;
    reg [15:0] circle2_position_r, circle2_position_w;
    reg [15:0] circle3_position_r, circle3_position_w;
    reg [15:0] circle4_position_r, circle4_position_w;
    reg [15:0] circle5_position_r, circle5_position_w;
    reg circle1_show_r,circle1_show_w;
    reg circle2_show_r,circle2_show_w;
    reg circle3_show_r,circle3_show_w;
    reg [7:0] order_r, order_w;

    wire [7:0] lx, ly, rx, ry;
    reg circle1_hit, circle2_hit, circle3_hit;

    assign score = score_r;
    assign circle1_position = circle1_position_r;
    assign circle2_position = circle2_position_r;
    assign circle3_position = circle3_position_r;
    assign circle4_position = circle4_position_r;
    assign circle5_position = circle5_position_r;
    assign circle1_show = circle1_show_r;
    assign circle2_show = circle2_show_r;
    assign circle3_show = circle3_show_r;

    assign lx=position_hand[31:24];
    assign ly=15-position_hand[23:16];
    assign rx=position_hand[15:8];
    assign ry=15-position_hand[7:0];

always_comb begin
    circle4_position_w[15:8]=lx;
    circle4_position_w[7:0]=ly;
    circle5_position_w[15:8]=rx;
    circle5_position_w[7:0]=ry;
    if(lx==MINUS1 || ly==MINUS1)begin
        circle4_position_w = 0;
    end
    if(rx==MINUS1 || ry==MINUS1)begin
        circle5_position_w = 0;
    end
end



//circle move logic
    always_comb begin
        score_w = score_r;
        circle1_position_w = circle1_position_r;
        circle2_position_w = circle2_position_r;
        circle3_position_w = circle3_position_r;
        order_w = order_r;
        circle1_show_w= circle1_show_r;
        circle2_show_w= circle2_show_r;
        circle3_show_w= circle3_show_r;
        //keep last 3 position
        if(circle1_position_r!=position_note && circle2_position_r!=position_note && circle3_position_r!=position_note && position_note!=MINUS1)begin
            order_w = order_r + 1;//handle last note
            if(order_w==3)begin
                order_w = 0;
            end
            case(order_r)//last note change to new note
                0:begin
                    circle1_position_w = position_note;
                    circle2_position_w = circle2_position_r;
                    circle3_position_w = circle3_position_r;
                    circle1_show_w= 1;
                end
                1:begin
                    circle1_position_w = circle1_position_r;
                    circle2_position_w = position_note;
                    circle3_position_w = circle3_position_r;
                    circle2_show_w= 1;
                end
                2:begin
                    circle1_position_w = circle1_position_r;
                    circle2_position_w = circle2_position_r;
                    circle3_position_w = position_note;
                    circle3_show_w= 1;
                end
                default:begin
                    circle1_position_w = circle1_position_r;
                    circle2_position_w = circle2_position_r;
                    circle3_position_w = circle3_position_r;
                    circle1_show_w= circle1_show_r;
                    circle2_show_w= circle2_show_r;
                    circle3_show_w= circle3_show_r;
                end
            endcase
        end
        if(circle1_hit && circle1_show_r)begin
            circle1_show_w = 0;
            score_w = score_r + 5;
        end
        if(circle2_hit && circle2_show_r)begin
            circle2_show_w = 0;
            score_w = score_r + 5;
        end
        if(circle3_hit && circle3_show_r)begin
            circle3_show_w= 0;
            score_w = score_r + 5;
        end
    end


always_comb begin//circle hit logic
    circle1_hit = 0;
    circle2_hit = 0;
    circle3_hit = 0;
    //circle1 hit by right hand
    if(position_hand[15:0]!=MINUS1)begin
        if( (rx-circle1_position_r[15:8] < tolerance ||  circle1_position_r[15:8]-rx < tolerance) &&
            (ry-circle1_position_r[7: 0] < tolerance ||  circle1_position_r[7: 0]-ry < tolerance)   )begin
               circle1_hit = 1;
        end
        //circle2 hit by right hand
        if( (rx-circle2_position_r[15: 8] < tolerance || circle2_position_r[15: 8]-rx < tolerance) &&
            (ry-circle2_position_r[ 7: 0] < tolerance || circle2_position_r[ 7: 0]-ry < tolerance)  )begin
               circle2_hit = 1;
        end
        //circle3 hit by right hand
        if( (rx-circle3_position_r[15: 8] < tolerance && circle3_position_r[15: 8]-rx < tolerance) &&
            (ry-circle3_position_r[ 7: 0] < tolerance && circle3_position_r[ 7: 0]-ry < tolerance)  )begin
                circle3_hit = 1;
        end
    end
    if(position_hand[31:16]!=MINUS1)begin
        //circle1 hit by left hand
        if( (lx-circle1_position_r[15: 8] < tolerance || circle1_position_r[15: 8]-lx < tolerance) &&
            (ly-circle1_position_r[ 7: 0] < tolerance || circle1_position_r[ 7: 0]-ly < tolerance)  )begin
                circle1_hit = 1;
        end
        //circle2 hit by left hand
        if( (lx-circle2_position_r[15: 8] < tolerance || circle2_position_r[15: 8]-lx < tolerance) &&
            (ly-circle2_position_r[ 7: 0] < tolerance || circle2_position_r[ 7: 0]-ly < tolerance)  )begin
                circle2_hit = 1;
        end
        //circle3 hit by left hand
        if( (lx-circle3_position_r[15: 8] < tolerance || circle3_position_r[15: 8]-lx < tolerance) &&
            (ly-circle3_position_r[ 7: 0] < tolerance || circle3_position_r[ 7: 0]-ly < tolerance)  )begin
                circle3_hit = 1;
        end
    end

end

//sequential logic
    always_ff @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            score_r <= 0;
            circle1_position_r <= 0;
            circle2_position_r <= 0;
            circle3_position_r <= 0;
            circle4_position_r <= 0;
            circle5_position_r <= 0;
            order_r <= 0;
            circle1_show_r <= 1;
            circle2_show_r <= 1;
            circle3_show_r <= 1;
        end
        else begin
            score_r <= score_w;
            circle1_position_r <= circle1_position_w;
            circle2_position_r <= circle2_position_w;
            circle3_position_r <= circle3_position_w;
            circle4_position_r <= circle4_position_w;
            circle5_position_r <= circle5_position_w;
            order_r <= order_w;
            circle1_show_r <= circle1_show_w;
            circle2_show_r <= circle2_show_w;
            circle3_show_r <= circle3_show_w;
        end
    end
endmodule