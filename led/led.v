module led(
	input clk,
	input rst_n,
	input [31:0] position,
	output out,
	
	input [7:0] cur_note,
	input [31:0] cur_time
);
/*
	input position[x1,y1,x2,y2], light up two positions
	input cur_note, cur_time display note as background
*/

parameter unit_time_cycle=750000;//0.015s
parameter hand_pos_color1=24'h00004F;
parameter hand_pos_color2=24'h00284F;
parameter hand_pos_color3=24'h004F4F;
reg [23:0] led[0:31][0:15];
reg [12287:0] ledd;
reg show_r,show_w;
reg [31:0] t_r,t_w;
reg [31:0] cnt_r,cnt_w;
reg [7:0] note_display_w[15:0], note_display_r [15:0];
reg [23:0] rainbow_color;
// Assign rainbow colors in GRB format

wire [23:0] rainbow[15:0] ;

assign rainbow[0]=24'h000F0F;
assign rainbow[1]=24'h000F0F;
assign rainbow[2]=24'h000F0A;
assign rainbow[3]=24'h000F00;
assign rainbow[4]=24'h0A0F00;
assign rainbow[5]=24'h0F0F00;
assign rainbow[6]=24'h0F0A00;
assign rainbow[7]=24'h0F0000;
assign rainbow[8]=24'h0F0005;
assign rainbow[9]=24'h0F000A;
assign rainbow[10]=24'h0F000F;
assign rainbow[11]=24'h0F000F;
assign rainbow[12]=24'h0A000F;
assign rainbow[13]=24'h00000F;
assign rainbow[14]=24'h000A0F;
assign rainbow[15]=24'h000F0F;

wire [7:0] x1,y1,x2,y2;
integer a,b,i,j;

assign x1=position[31:24];
assign y1=position[23:16];
assign x2=position[15: 8];
assign y2=position[ 7: 0];


always @(*) begin//2D to 1D
	for(b=0;b<16;b=b+1)begin
		for(a=0;a<32;a=a+1)begin
			for(j=23;j>=0;j=j-1)begin
				ledd[24*(64*(2*(a/8)+((15-b)/8))+(a%8)+8*((15-b)%8))+(23-j)]=led[a][b][j]; 
			end
		end
	end
end
//module
ws2812b ws(
	.rst_n(rst_n),
	.clk(clk),
	.show(show_r),
	.signal(ledd),
	.out(out)
);

always @(*)begin
	cnt_w=cnt_r+1;
	t_w=cur_time;
	show_w=0;
	for(i=0;i<16;i=i+1)begin
		note_display_w[i]=note_display_r[i];
	end
	
	if(t_r!=cur_time)begin//new unit time, update note
		for(i=1;i<16;i=i+1)begin
				note_display_w[i]=note_display_r[i-1];
		end
		note_display_w[0]=cur_note;
	end
		
		
	if(cnt_r>unit_time_cycle)begin
		cnt_w=0;
		for(a=0;a<32;a=a+1)begin//led reset
			for(b=0;b<16;b=b+1)begin
				led[a][b]=0;
			end
		end
		for(i=1;i<16;i=i+1)begin
			led[	note_display_r[i]-51	][i]=rainbow[i];
			led[	note_display_r[i]-50	][i]=rainbow[i];
			led[	note_display_r[i]-49	][i]=rainbow[i];
		end
			
		if(x1!=-1 && y1!=-1)begin//hand position
			led[x1  ][y1  ]=hand_pos_color1;
			led[x1+1][y1  ]=hand_pos_color2;
			led[x1-1][y1  ]=hand_pos_color2;
			led[x1  ][y1+1]=hand_pos_color2;
			led[x1  ][y1-1]=hand_pos_color2;
		
			led[x1+1][y1+1]=hand_pos_color3;
			led[x1+1][y1-1]=hand_pos_color3;
			led[x1-1][y1+1]=hand_pos_color3;
			led[x1-1][y1-1]=hand_pos_color3;
		end
		if(x2!=-1 && y2!=-1)begin//hand position
			led[x2  ][y2  ]=hand_pos_color1;
			led[x2+1][y2  ]=hand_pos_color2;
			led[x2-1][y2  ]=hand_pos_color2;
			led[x2  ][y2+1]=hand_pos_color2;
			led[x2  ][y2-1]=hand_pos_color2;
		
			led[x2+1][y2+1]=hand_pos_color3;
			led[x2+1][y2-1]=hand_pos_color3;
			led[x2-1][y2+1]=hand_pos_color3;
			led[x2-1][y2-1]=hand_pos_color3;
		end
		show_w=1;
	end

end 
	 
	 //sequential logic
always @(negedge rst_n or posedge clk)begin
	if(!rst_n)begin
		cnt_r<=0;
		t_r<=0;
		show_r<=0;
		for(b=0;b<16;b=b+1)begin 
			note_display_r[b]=0;
		end
	end
	else begin
		cnt_r<=cnt_w;
		t_r<=t_w;
		show_r<=show_w;
		for(b=0;b<16;b=b+1)begin
			note_display_r[b]=note_display_w[b];
		end
	end
end

endmodule



/*
always @(*) begin
	cnt_w=cnt_r+1;
	t_w=t_r;
	show_w=0;
	position_w=position_r;
	slopex_w=slopex_r;
	slopey_w=slopey_r;
	for(a=0;a<32;a=a+1)begin
		for(b=0;b<trail_length;b=b+1)begin
			trail_w[b][a]=trail_r[b][a];
		end
	end
	//				default
	//--------------------------------------
	if(done)begin
		position_w=position;
	end
	if(cnt_r>unit_time_cycle)begin
		position_w=-1;
		cnt_w=0;
		t_w=t_r+1;
		for(b=0;b<trail_length-1;b=b+1)begin
			trail_w[b+1]=trail_r[b];
		end
		if(t_r%32<16)begin
			trail_w[0]={{t_r%32},{t_r/32},16'b0};
		end
		else begin
			trail_w[0]={16'b0,{t_r%32},{t_r/32}};
		end
		
		
		//trail_w[0]=position_r;

		if(position_r!=-1)begin
			for(b=1;b<t_r-slopex_r && b<trail_length;b=b+1)begin
				trail_w[b][7:0]=(slopey_r[7:0]*(b)+position_r[7:0]*(t_r-b-slopex_r))/(t_r-slopex_r);
			end
			for(b=1;b<t_r-slopex_r && b<trail_length;b=b+1)begin
				trail_w[b][15:8]=(slopey_r[15:8]*(b)+position_r[15:8]*(t_r-b-slopex_r))/(t_r-slopex_r);
			end	
			for(b=1;b<t_r-slopex_r && b<trail_length;b=b+1)begin
				trail_w[b][23:16]=(slopey_r[23:16]*(b)+position_r[23:16]*(t_r-b-slopex_r))/(t_r-slopex_r);
			end
			for(b=1;b<t_r-slopex_r && b<trail_length;b=b+1)begin
				trail_w[b][31:24]=(slopey_r[31:24]*(b)+position_r[31:24]*(t_r-b-slopex_r))/(t_r-slopex_r);
			end
			slopey_w=position_r;
			slopex_w=t_r;
		end
		
		for(a=0;a<32;a=a+1)begin
			for(b=0;b<16;b=b+1)begin
				led[a][b]=0;
			end
		end
		for(b=0;b<trail_length;b=b+1)begin
			if(trail_r[b]!=32'hFFFFFFFF)begin
				led[trail_r[b][31:24]][trail_r[b][23:16]]=24'h000020;
				led[trail_r[b][15: 8]][trail_r[b][ 7: 0]]=24'h000020; 
			end
		end

		show_w=1;
	end  
end
*/
	 
