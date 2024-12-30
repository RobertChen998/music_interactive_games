module ws2812b (
    input rst_n,
    input clk,
    input show,
    input [12287:0] signal,
    output out
);
    parameter S_IDLE= 3'd0;
    parameter S_RST = 3'd1;
    parameter S_1XX = 3'd2;
    parameter S_X1X = 3'd3;
    parameter S_X0X = 3'd4;
    parameter S_XX0 = 3'd5;

    reg [12:0] cnt_w, cnt_r;
    reg [15:0] index_w,index_r;
    reg [2:0] state_w, state_r;
    /*
    logic [12:0] cnt_w, cnt_r;
    logic [15:0] index_w,index_r;
    logic [2:0] state_w, state_r;
    */
    reg o_data;

    assign out = o_data;




//FSM
    always @(*) begin
    //always_comb begin
        o_data=0;
        
        cnt_w=cnt_r+1;
        index_w=index_r;
        state_w=S_RST;

        case (state_r)
            S_IDLE:begin
                if(show)begin
                    state_w=S_RST;
                end
                else begin
                    state_w=S_IDLE;
                end
            end
            S_RST:begin
                o_data=0;
                if(cnt_r[12])begin//cnt >= 4096 ie over 81.92 microsecond
                    cnt_w=0;
                    state_w=S_1XX;
                    index_w=0;
                end
                else begin
                    state_w=S_RST;
                end
            end 
            S_1XX:begin
                o_data=1;
                if(cnt_r>=19)begin// 0.4 microseconds
                    cnt_w=0;
                    if(signal[index_r]==1)begin
                        state_w=S_X1X;
                    end
                    else begin
                        state_w=S_X0X;
                    end
                end
                else begin
                    state_w=S_1XX;
                end
                
            end
            S_X0X:begin
                o_data=0;
                if(cnt_r>=19)begin// 0.4 microseconds
                    cnt_w=0;
                    state_w=S_XX0;
                end
                else begin
                    state_w=S_X0X;
                end
            end
            S_X1X:begin
                o_data=1;
                if(cnt_r>=19)begin// 0.4 microseconds
                    cnt_w=0;
                    state_w=S_XX0;
                end
                else begin
                    state_w=S_X1X;
                end
            end
            S_XX0:begin
                o_data=0;
                if(cnt_r>=19)begin// 0.4 microseconds
                    cnt_w=0;
                    if(index_r>=12287)begin
                        state_w=S_IDLE;
                        index_w=0;
                    end
                    else begin
                        state_w=S_1XX;
                        index_w=index_r+1;
                    end
                end
                else begin
                    state_w=S_XX0;
                end
            end
            default:begin
                state_w=S_IDLE;
                cnt_w=0;
                o_data=0;
            end
        endcase
    end


    always @(negedge rst_n or posedge clk)begin
    //always_ff @(posedge rst or posedge clk)begin
        if(!rst_n)begin
            cnt_r<=0;
            state_r<=0;
            index_r<=0;
        end
        else begin
            cnt_r<=cnt_w;
            state_r<=state_w;
            index_r<=index_w;
        end
    end


    
endmodule