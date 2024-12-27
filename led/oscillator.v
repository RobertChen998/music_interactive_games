module oscillator (
    input rst_n,
    input clk,
    input [7:0]note,
    output out
);
    wire [1759:0] note_to_cycles= 1760'h01754018b701a2f01bbe01d6401f24020fe022f4025080273c0299102c0a02ea80316e0345f0377c03ac903e48041fc045e804a1004e78053220581405d51062dd068be06ef90759207c90083f808bd10942109cf00a6450b0280baa20c5bb0d17d0ddf20eb240f920107f0117a212843139e114c8b160511754418b761a2fa1bbe41d6491f24020fe122f4425086273c2299162c0a22ea88316ec345f4377c83ac933e48141fc245e894a10c4e7845322c581445d51162dd968be96ef91759267c90283f848bd13942199cf08a6458b0289baa23c5bb3d17d3ddf22;
    reg [19:0] cycle;
    reg [20:0] cnt_r,cnt_w;
    reg o_r,o_w;
    integer i;
    
    assign out=o_r;

    always @(*) begin
        for (i=0;i<20;i=i+1) begin
            cycle[i]=note_to_cycles[i+20*(note-21)];
        end
    end
    
    always @(*) begin
        cnt_w=cnt_r+1;
        o_w=o_r;
        case (o_r)
            0:begin
                if(cnt_r>=cycle)begin
                    cnt_w=0;
                    o_w=1;
                end
            end 
            1:begin
                if(cnt_r>=cycle)begin
                    cnt_w=0;
                    o_w=0;
                end
            end
            default:begin
                cnt_w=cnt_r+1;
                o_w=o_r;
            end
        endcase
        if(note==0)begin
            cnt_w=0;
            o_w=0;
        end
    end
    always @(negedge rst_n or posedge clk)begin
    //always_ff @(posedge rst or posedge clk)begin
        if(!rst_n)begin
            cnt_r<=0;
            o_r<=0;
        end
        else begin
            cnt_r<=cnt_w;
            o_r<=o_w;
        end
    end
endmodule