module player (
    input rst_n,
    input clk,
    input [1:0]track_choose,
    output out0,//sound out
    output out1,//sound out
    output [15:0] position,//x[7:0] y[7:0]
    output [15:0] position_preview,//x[7:0] y[7:0]
    output [7:0] cur_note,
	output [31:0] cur_time,
	output new_time
);
    parameter S_IDLE  = 2'd0;
    parameter S_PLAY  = 2'd1;
    parameter S_DELAY = 2'd2;

    //   + time -  
    wire [12399:0] track_senbonzakura=12400'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccccccccccc4cca4ac747c343c545c3c3c343c5c5c545c7c7c747c8c8c848c343c0400000c747c343c545cc4cca4ac74700c7c7c7c7470047c5c54500c545c343c0400000c3430043c545c747c848c7470000c7c7c7470047c5c54500c545c343c0400000c747c343c545cc4cca4ac7470000c7c7c7470047c5c54500c545c343c0400000c5450045c343c545c343c1c1c141c3c3c343c5c5c545c6c6c646c141be3e0000c545c141c343ca4ac848c54500c5c5c5c5450045c3c34300c343c141be3e0000c1410041c343c545c646c5450000c5c5c5450045c3c34300c343c141be3e0000c545c141c343ca4ac848c5450000c5c5c5450045c3c34300c343c141be3e00000000c0c0c0c0c0c0c040c3c3c343c1c1c141be3e0000be3e003ebc3cb9390000b939b737b9393c3ebc3c00bcbc3cbebebe3ec0c0c040c1c1c141bebebebebebebe3ebc3cc040c1c1c141c0c0c040c3c3c3430000be3ebc3cb93900000000b9b9b939b737b9393c3ebc3c0000bc3cbebebe3ec0c0c040c1c1c141cacacacacacaca4ac848c545c141c343c1c1c141c3c3c343c5c5c545c6c6c646c141be3e0000c545c141c343ca4ac848c54500c5c5c5c5450045c3c34300c343c141be3e0000c1410041c343c545c646c5450000c5c5c5450045c3c34300c343c141be3e0000c545c141c343ca4ac848c5450000c5c5c5450045c3c34300c343c141be3e0000be3ebc3cc040c545c343c1c1c141c3c3c343c5c5c545c6c6c646c141be3e0000c545c141c343ca4ac848c54500c5c5c5c5450045c3c34300c343c141be3e0000c1410041c343c545c646c5450000c5c5c5450045c3c34300c343c141be3e0000c545c141c343ca4ac848c5450000c5c5c5450045c3c34300c343c141be3e00000000c0c0c0c0c0c0c040c3c3c343c1c1c141be3e0000be3e003ebc3cb9390000b939b737b9393c3ebc3c0000bc3cbebebe3ec0c0c040c1c1c141bebebebebebebe3ebc3cc040c1c1c141c0c0c040c3c3c3430000be3ebc3cb93900000000b9b9b939b737b9393c3ebc3c0000bc3cbebebe3ec0c0c040c1c1c141bebebe3ec1c1c1414345c343c5c5c545c343c141be3ebc3c003cbe3e00bebe3eb939bc3c003cbe3ebc3cbe3e00bebe3ec343c141be3e00393cbebe3e00bebe3e0000be3e0000c1414345c343c5c5c5450045c343c141be3e3cbebe3e0000be3ebc3cb939bc3cbe3e3cbebe3e0000be3ec343c1410041be3e3cbebe3e0000be3ecacacacacacaca4ac848c545c141c343c1c1c141c3c3c343c5c5c545c6c6c646c141be3e0000c545c141c343ca4ac848c54500c5c5c5c5450045c3c34300c343c141be3e0000c1410041c343c545c646c5450000c5c5c5450045c3c34300c343c141be3e0000c545c141c343ca4ac848c5450000c5c5c5450045c3c34300c343c141be3e0000be3ebc3cc040c545c343c1c1c141c3c3c343c5c5c545c6c6c646c141be3e0000c545c141c343ca4ac848c54500c5c5c5c5450045c3c34300c343c141be3e0000c1410041c343c545c646c5450000c5c5c5450045c3c34300c343c141be3e0000c545c141c343ca4ac848c5450000c5c5c5450045c3c34300c343c141be3e00000000c0c0c0c0c0c0c040c3c3c343c1c1c141be3e0000be3e003ebc3cb9390000b939b737b9393c3ebc3c00bcbc3cbebebe3ec0c0c040c1c1c141bebebebebebebe3ebc3cc040c1c1c141c0c0c040c3c3c3430000be3ebc3cb93900000000b9b9b939b737b9393c3ebc3c0000bc3cbebebe3ec0c0c040c1c1c141bebebe3ec1c1c1414345c343c5c5c545c343c141be3ebc3c003cbe3e00bebe3eb9390039bc3cbe3ebc3cbe3e00bebe3ec343c141be3ebc3c3900be3e0000be3e0000be3e0000c1414345c34300c5c5450045c343c141be3e3cbebe3e0000be3ebc3cb939bc3cbe3e3cbebe3e00bebe3ec34300410041be3e3cbebe3e0000be3e000000000000000000000000;
    wire [12399:0] track_haruhikage0 =12400'h00000000000000000000c7c7c7c7c7c7c7c7c7c7c7c7c7c7c747c949c747c949c747c949c747c7c7c7c7c7c7c7c7c7c7c747c747c3c3c343c0c0c040c040bbbbbbbbbbbbbbbbbbbbbb3bbd3dbf3fc040bf3fc040bf3fbfbfbfbfbfbfbfbfbfbfbf3fbd3dbf3fc040c040c2c2c242c242c4c4c444c444c444c646c747c7c7c747c9494bc9c9494742c7c7c747c747c747c949c242c7c7c747c747c9c9c949c242c7c7c747c747c9c9c9494740c7c7c747464749c9c949c949cb4bcc4c3fcbcb4bcb4b3f00c6c6c6464443c4c4c4444240c2c2c242403f3d3f3d3fc2c2c2c2c242403fbfbfbf3fc040c040c24242c2c2c2c2424749c7c7c7474644c4c4c4444240c2c2c242403f3d3f3d3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcb4bcc4ccbcbcb4bc949cb4b4949c949c949c949000000000000c7c7c7474949c747c9494747c747c646c747c7c7c7c7c747c747c9c9c9494242c9494949c9c9c9c9c949c949cb4bc2424447c747c949474747474749c7c7c747ca4a474747474749000000000000000000000000cbcbcbcbcbcbcbcbcb4b00000000c747c949474747474749c7c7c747ca4a474747474749000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2c2c2c2c2c2c2c2c2c2c2c2c2c2c242403fbf3fc0c0c0404040c242c444c444c4c4c4c4c4c4c4c4c444c444c6c6c646c747c7c7c747c747c9c9c949bf3fbd3dbf3f3f3f3f3fc040bf3f00000000000000000000000000000000000000000000bbbbbbbbbb3b3a3bbdbdbd3dbd3dbf3fc040c0404040c242c24200000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbb3bbb3bbdbdbd3dbf3fc0c0c040bb3bc242bb3bbbbbbb3bbd3d3b3b0000bbbbbbbbbbbbbb3bc242bfbfbf3fbd3dbf3fc0400000bfbfbf3fbf3fbf3fc040c040bd3dc242c2c2c2424446c747c6c6c646c747c6c6c646c747c242bf3f0000bfbfbfbfbfbfbfbfbf3f3d3b3dbdbd3dbd3dbf3fc0403b3bbd3dbd3dbd3dbf3fc040bd3dbf3fbf3f3d3b00000000000000000000bbbbbbbbbbbbbbbbbbbbbb3bbd3dbf3fc040bf3fc040bf3fbfbfbfbfbfbfbfbfbfbfbf3fbd3dbf3fc040c040c2c2c242c242c4c4c444c444c444c646c747c7c7c747c9494bc9c9494742c7c7c747c747c747c949c242c7c7c747c747c9c9c949c242c7c7c747c747c9c9c9494740c7c7c747464749c9c949c949cb4bcc4c3fcbcb4bcb4b3f00c6c6c6464443c4c4c4444240c2c2c242403f3d3f3d3fc2c2c2c2c242403fbfbfbf3fc040c040c24242c2c2c2c2424749c7c7c7474644c4c4c4444240c2c2c242403f3d3f3d3fc2c2c2c2c2c2c2c2c2c2c2c2c2c2c242403fbf3fc0c0c0404040c242c444c444c4c4c4c4c4c4c4c4c444c444c6c6c646c747c7c7c747c747c9c9c949bf3fbd3dbf3f3f3f3f3fc040bf3f00000000000000000000000000000000000000000000bbbbbbbbbb3b3a3bbdbdbd3dbd3dbf3fc040c0404040c242c24200000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbb3bbb3bbdbdbd3d3d3f4040c040bb3bc242bb3b0000bb3bbd3d3b3b0000bbbbbbbbbbbbbb3bc242bfbfbf3fbd3dbf3fc040b636bfbfbf3fbf3fbf3fc040c040bd3dc242c2c2c2424446c747c6c6c646c747c6c6c646c747c242bf3f0000bfbfbfbfbfbfbfbfbf3f3d3bbdbdbd3dbd3dbf3fc040bb3bbd3dbd3dbd3dbf3fc040bd3dbf3fbf3f3d3b0000bbbbbbbbbbbbbb3bbb3bbdbdbd3dbf3fc0c0c040bb3bc242bb3b3bbbbb3bbd3dbb3b0000bbbbbbbbbbbbbb3bc242bfbfbf3fbd3dbf3fc040b6360000bf3fbf3fc0c0c040c040bd3dc242c2c2c2424446c747c6c6c646c747c6c6c646c747c242bf3f0000bfbfbfbfbfbfbfbfbf3f3d3bbdbdbd3dbd3dbf3fc0403b3bbd3dbd3dbd3dbf3fc040bd3dbf3fbf3f363600000000000000000000;
    wire [12399:0] track_haruhikage1 =12400'h00000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb3bbd3dbf3fc040bf3fc040bf3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbb3bba3abb3bbd3dbd3dbfbfbf3fbf3fc0c0c040c0400000c242c444c2c2c242c0403fc0c0403f3bbfbfbf3fbf3f0000c040bb3bbfbfbf3fbf3fc0c0c040bb3bbfbfbf3fbf3fc0c0c0403f3bc4c4c444424400c4c444bf3fbf3fbf3f00bfbf3fbf3f0000c3c3c3433f3fc0c0c0403f3dbfbfbf3f3d3b3a3b3a3bbbbbbbbbbb3b3b3bbbbbbb3bbd3dbd3dbd3d00bdbdbdbd3d4042c4c4c4444240c0c0c0403f3dbfbfbf3f3d3b3a3b3a3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c747c949c7c7c747c646c747c646c646c646c646000000000000000000000000000000000000000000000000c4c4c4c4c444c444c6c6c6463f3fc6464646c6c6c6c6c646c646c747bf3f4042c444c646444444444446c4c4c444c747444444444446000000000000000000000000c7c7c7c7c7c7c7c7c747c2424447c444c646444444444446c4c4c444c747444444444446000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6464646c6c6c6c6c6464747c747c747c747c7c7c7c7c7c7c7c7c747c747c9c9c949c949c9c9c949c949cdcdcd4d0000000000000000000000000000bdbdbd3dbd3dbd3dbf3fc040c040c242c242c242c4440000000000000000000000000000000000000000000000000000bdbdbd3dbd3dbd3dbf3fc040c040c242c242c242c444bfbfbfbfbfbfbfbfbfbfbf3fbf3fc0c0c040c242c4c4c444bf3fc747bf3f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbb3bba3abb3bbd3dbd3dbfbfbf3fbf3fc0c0c040c0400000c242c444c2c2c242c0403fc0c0403f00bfbfbf3fbf3f0000c040bb3bbfbfbf3fbf3fc0c0c040bb3bbfbfbf3fbf3fc0c0c0403f3bc4c4c4444244c4c4c444bf3fbf3fbf3f00bfbf3fbf3f0000c3c3c3433f3fc0c0c0403f3dbfbfbf3f3d3b3a3b3a3bbbbbbbbbbb3b3b3bbbbbbb3bbd3dbd3dbd3dbdbdbdbdbd3d4042c4c4c4444240c0c0c0403f3dbfbfbf3f3d3b3a3b3a3bc6c6c6c6c6c6c6c6c6c6c6c6c6c6c6464646c6c6c6c6c6464747c747c747c747c7c7c7c7c7c7c7c7c747c747c9c9c949c949c9c9c949c949cdcdcd4d0000000000000000000000000000bdbdbdbdbd3dbd3dbf3fc040c040c242c242c242c4440000000000000000000000000000000000000000000000000000bdbdbdbdbd3dbd3dbf3fc040c040c242c242c242c44400000000bfbfbfbfbfbfbf3fbf3fbf3fc04040424444c444bf3fc747bf3f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c7c7c7c7c7c7c7c7c7474747c7c7c747c747c747c747c444c444c444c747c747c747c747c747c74746440000bfbfbfbfbfbfbf3fbf3fc0c0c040c242c4c4c444bf3fc747bf3f00bfbf3fc040bf3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    
    wire [12399:0] track0;//=track_haruhikage0;//change
    wire [12399:0] track1;//=track_haruhikage1;//change
    wire [31:0] unit_note_cycle;//=28'd7812500;//d7812500;//change
    wire [31:0] delay_cycle;//=unit_note_cycle/120;//change
    
    assign track0 = (track_choose==0)?track_senbonzakura:track_haruhikage0;
    assign track1 = (track_choose==0)?track_senbonzakura:track_haruhikage1;
    assign unit_note_cycle = (track_choose==0)?28'd5000000:28'd7812500;
    assign delay_cycle =(track_choose==0)?unit_note_cycle/96:unit_note_cycle/120;
    /*track info
    test:
        track=track_haruhikage0;
        unit_note_cycle=28'd1000;
        delay_cycle=unit_note_cycle/120;
    senbonzakura:
        track=track_senbonzakura;
        unit_note_cycle=28'd5000000;
        delay_cycle=unit_note_cycle/96;
        minnote=55
    haruhikage:
        track=track_haruhikage0;
        unit_note_cycle=28'd7812500;
        delay_cycle=unit_note_cycle/120;
        note_duration_threshold = 240;
        minnote=54

    */
    reg [7:0] read_note,read_nxt_note,note,note1,read_note1;
    reg [31:0] t_r,t_w;
    reg [31:0] cnt_r,cnt_w;
    reg [1:0] state_r,state_w;
    reg [15:0] position_r,position_w;
    reg [15:0] position_preview_r,position_preview_w;
	 reg done_r,done_w;
    reg test;
    wire [31:0] random_num;
    integer i;
    assign position_preview=(position_preview_r==position_r)?-1:position_preview_r;
    assign position=(read_note==0)?-1:position_r;
    assign cur_note=note;
	assign cur_time=t_r;
	assign new_time= done_r;
	 
    oscillator osc0(
        .rst_n(rst_n),
        .clk(clk),
        .note(note),
        .out(out0)
    );
    oscillator osc1(
        .rst_n(rst_n),
        .clk(clk),
        .note(note1),
        .out(out1)
    );
    random ran(
        .rst_n(rst_n),
        .clk(clk),
        .rand(random_num)
    );
    always @(*) begin//read note
        for (i=0;i<8;i=i+1) begin
            read_note[i]=track0[t_r*8+i];
            read_note1[i]=track1[t_r*8+i];
            read_nxt_note[i]=track0[(t_r+1)*8+i];
        end
    end

    always @(*) begin
        state_w=S_IDLE;
        cnt_w=cnt_r+1;
        t_w=t_r;
		done_w=0;
        position_w=position_r;
        position_preview_w=position_preview_r;
        note={1'b0,read_note[6:0]};
        note1={1'b0,read_note1[6:0]};
        test=0;
        case (state_r)
            S_IDLE:begin
                state_w=S_DELAY;
            end
            S_DELAY:begin
                state_w=S_DELAY;
                if(cnt_r>delay_cycle)begin//delay end
                    state_w=S_PLAY;
                end
                if(read_note[7]==0)begin//delay is needed
                    note=8'b0;
                end
                if(read_note1[7]==0)begin//1 delay is needed
                    note1=8'b0;
                end
                if(cnt_r==0)begin//new time unit begin
                    position_w=position_preview_r;
						  done_w=1;
                    if(read_nxt_note[7]==0 && read_nxt_note[6:0]!=0)begin//new note comming
                        test=1;
                        if(random_num[0]==1)begin//normal
                            position_preview_w[15:8]=random_num[31:27]%28+2;//x random
                            position_preview_w[7:0]=(read_nxt_note[6:0]-50)/2+random_num[23];// y follow note and add random
                        end
                        else begin//invert note position, for fun
                            position_preview_w[15:8]=random_num[31:27]%28+2;//x random
                            position_preview_w[7:0]=(80-read_nxt_note[6:0])/2+random_num[23];
                        end
                    end
                end
            end
            S_PLAY:begin
                state_w=S_PLAY;
                if(cnt_r>unit_note_cycle) begin
                    cnt_w=0;
                    t_w=t_r+1;
                    state_w=S_DELAY;
                end
                if(t_r>=1540)begin
                    state_w=S_IDLE;
                end
            end 
        endcase
    end
    
    always @(negedge rst_n or posedge clk)begin
    //always_ff @(posedge rst or posedge clk)begin
        if(!rst_n)begin
            t_r<=0;
            cnt_r<=0;
            state_r<=S_IDLE;
			done_r<=0;
            position_r<=-1;
            position_preview_r<=-1;
        end
        else begin
            t_r<=t_w;
            cnt_r<=cnt_w;
            state_r<=state_w;
			done_r<=done_w;
            position_r<=position_w;
            position_preview_r<=position_preview_w;
        end
    end
endmodule

module random (
    input  clk,             // Clock signal
    input  rst_n,             // Reset signal
    output  [31:0] rand   // 32-bit pseudo-random output
);
    reg [31:0] counter_r,counter_w;          // Free-running counter
    reg [31:0] lfsr_r,lfsr_w;             // 32-bit LFSR

    wire feedback;

    // Feedback logic for LFSR: x^32 + x^22 + x^2 + x^1 + 1
    assign feedback = lfsr_r[31] ^ lfsr_r[21] ^ lfsr_r[1] ^ lfsr_r[0];
    assign rand = lfsr_r ^ counter_r;
    always @(*) begin
        counter_w = counter_r + 1;
        lfsr_w={lfsr_r[30:0], feedback};
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_r <= 32'b0;   // Reset counter
            lfsr_r <= 32'h1;      // Initialize LFSR to non-zero value
        end else begin
            counter_r <= counter_w; // Increment counter
            lfsr_r <= lfsr_w; // Update LFSR
        end
    end

    // Combine counter and LFSR for more variation
    

endmodule
