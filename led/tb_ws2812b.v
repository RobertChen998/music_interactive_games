`timescale 1ns/100ps
`define CLK 20              //50Mhz
`define HCLK `CLK/2

module tb;
    reg clk,reset;
    reg show;
    reg [23:0] led[0:31][0:15];
    reg [12287:0] ledd;
    reg [23:0] color;
    wire out;
    integer a,b,j,x,y,i;

    initial begin
       $fsdbDumpfile("ws2812b.fsdb");
       $fsdbDumpvars;
    end
    initial begin
        # (4196* `CLK *512) $finish;
    end
    always #(`HCLK) clk = ~clk;

    ws2812b w(
        .rst(reset),
        .clk(clk),
        .show(show),
        .signal(ledd),
        .out(out)
    );

    always @(*) begin
        for(b=0;b<16;b=b+1)begin
            for(a=0;a<32;a=a+1)begin
                for(j=23;j>=0;j=j-1)begin
                    ledd[24*(64*(2*(a/8)+((15-b)/8))+(a%8)+8*((15-b)%8))+(23-j)]=led[a][b][j]; 
                end
            end
        end
    end

    initial begin
        clk=0;
        show=0;
        for(y=0;y<16;y=y+1)begin
            for(x=0;x<32;x=x+1)begin
                led[x][y]=24'b0;
            end
        end
        reset=1;
        #(`CLK);
        reset=0;
        #(`CLK*10);
//              reset
//--------------------------------------
        x=0;
        y=15;
        color={8'd128,8'd0,8'd0};
        led[x][y]=color;
        show=1;
        #(`CLK);
        show=0;

        #(750000* `CLK);

        x=31;
        y=0;
        color={8'd0,8'd0,8'd1};
        led[x][y]=color;
        show=1;
        #(`CLK);
        show=0;
        

    end
    
endmodule



