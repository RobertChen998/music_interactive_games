module Rsa232wrapper (
    input         avm_rst,
    input         avm_clk,
    output  [4:0] avm_address,
    output        avm_read,
    input  [31:0] avm_readdata,
    input         avm_waitrequest,
    output [31:0]  o_coord,
    output whole_coor_done
);

localparam RX_BASE     = 0*4;
//localparam TX_BASE     = 1*4;
localparam STATUS_BASE = 2*4;
//localparam TX_OK_BIT   = 6;
localparam RX_OK_BIT   = 7;

// Feel free to design your own FSM!
// localparam S_GET_KEY = 0;
// localparam S_GET_DATA = 1;
// localparam S_WAIT_CALCULATE = 2;
// localparam S_SEND_DATA = 3;

reg [31:0] coord_r, coord_w;
reg [2:0] coord_cnt_r, coord_cnt_w;
reg [4:0] avm_address_r, avm_address_w;
reg avm_read_r, avm_read_w;
reg done_r, done_w;

assign avm_address = avm_address_r;
assign avm_read = avm_read_r;

assign whole_coor_done = done_r;
assign o_coord = coord_r;

always @(*) begin
    avm_address_w = avm_address_r;
    avm_read_w = 1;
    coord_cnt_w = coord_cnt_r;
    done_w = 0;
    coord_w = coord_r;
    if(avm_waitrequest == 0) begin
        
        if(avm_address_r == STATUS_BASE) begin
            if(avm_readdata[RX_OK_BIT]) begin
                avm_address_w = RX_BASE;
                
            end
            // if (coord_cnt_r == 4) begin
            //     coord_cnt_w = 0;
            //     avm_address_w = STATUS_BASE;
            // end 
            
        end
        else if (avm_address_r == RX_BASE) begin
            avm_address_w = STATUS_BASE;
            coord_w = (coord_r << 8) | avm_readdata[7:0];
            
            if (coord_cnt_r == 3) begin
                coord_cnt_w = 0;
                done_w = 1;
            end 
            else begin
                coord_cnt_w = coord_cnt_r + 1;
            end
            
            
        end
    end

end

always @(posedge avm_clk or posedge avm_rst) begin
    if (avm_rst) begin
        avm_address_r <= STATUS_BASE;
        avm_read_r <= 1;
        coord_cnt_r <= 0;
        coord_r <= 0;
        done_r <= 0;

        
    end else begin
        avm_address_r <= avm_address_w;
        avm_read_r <= avm_read_w;
        coord_cnt_r <= coord_cnt_w;
        coord_r <= coord_w;
        done_r <= done_w;
    end
end

endmodule
/*
module Rsa256Wrapper (
    input         avm_rst,
    input         avm_clk,
    output  [4:0] avm_address,
    output        avm_read,
    input  [31:0] avm_readdata,
    output        avm_write,
    output [31:0] avm_writedata,
    input         avm_waitrequest
);

localparam RX_BASE     = 0*4;
localparam TX_BASE     = 1*4;
localparam STATUS_BASE = 2*4;
localparam TX_OK_BIT   = 6;
localparam RX_OK_BIT   = 7;

// Feel free to design your own FSM!
localparam S_KEY = 0;
localparam S_GET_DATA = 1;
localparam S_WAIT_CALCULATE = 2;
localparam S_SEND_DATA = 3;

logic [255:0] n_r, n_w, d_r, d_w, enc_r, enc_w, dec_r, dec_w;
logic [1:0] state_r, state_w;
logic [6:0] bytes_counter_r, bytes_counter_w;
logic [4:0] avm_address_r, avm_address_w;
logic avm_read_r, avm_read_w, avm_write_r, avm_write_w;

logic rsa_start_r, rsa_start_w;
logic rsa_finished;
logic [255:0] rsa_dec;

assign avm_address = avm_address_r;
assign avm_read = avm_read_r;
assign avm_write = avm_write_r;
assign avm_writedata = dec_r[247-:8]; //247~240

Rsa256Core rsa256_core(
    .i_clk(avm_clk),
    .i_rst(avm_rst),
    .i_start(rsa_start_r),
    .i_a(enc_r),
    .i_d(d_r),
    .i_n(n_r),
    .o_a_pow_d(rsa_dec),
    .o_finished(rsa_finished)
);

task StartRead;
    input [4:0] addr;
    begin
        avm_read_w = 1;
        avm_write_w = 0;
        avm_address_w = addr;
    end
endtask
task StartWrite;
    input [4:0] addr;
    begin
        avm_read_w = 0;
        avm_write_w = 1;
        avm_address_w = addr;
    end
endtask


always @ (*) begin
    // Default assignments
    n_w = n_r;
    d_w = d_r;
    enc_w = enc_r;
    dec_w = dec_r;
    rsa_start_w = 0;
    bytes_counter_w = bytes_counter_r;
    avm_read_w = avm_read_r;
    avm_write_w = avm_write_r;
    avm_address_w = avm_address_r;

    case(state_r)
        S_KEY: begin
            if(~avm_waitrequest & avm_readdata[RX_OK_BIT]) begin
                StartRead(RX_BASE);
                bytes_counter_w = bytes_counter_r + 1;
                state_w = S_GET_DATA;
            end
            else begin
                state_w = state_r;
            end
        end

        S_GET_DATA: begin
            if(~avm_waitrequest) begin
                StartRead(STATUS_BASE);
                if(bytes_counter_r <= 7'd32) begin
                    n_w = {n_r[247:0], avm_readdata[7:0]};
                    state_w = S_KEY;
                end
                else if(bytes_counter_r <= 7'd64) begin
                    d_w = {d_r[247:0], avm_readdata[7:0]};
                    state_w = S_KEY;
                end
                else begin
                    enc_w = {enc_r[247:0], avm_readdata[7:0]};
                    if(bytes_counter_r == 7'd96) begin
                        state_w = S_WAIT_CALCULATE;
                        rsa_start_w = 1;
                    end
                    else begin
                        state_w = S_KEY;
                    end
                end
            end
            else begin
                state_w = state_r;
            end
        end

        S_WAIT_CALCULATE: begin
            if(rsa_finished) begin
                StartRead(STATUS_BASE);
                state_w = S_SEND_DATA;
                dec_w = rsa_dec;
                bytes_counter_w = 0;
            end
            else begin
                state_w = state_r;
            end
        end

        S_SEND_DATA: begin
            if(avm_address_r == STATUS_BASE) begin
                if(~avm_waitrequest & avm_readdata[TX_OK_BIT]) begin
                    StartWrite(TX_BASE);
                    bytes_counter_w = bytes_counter_r + 1;
                end
            end
            else if(~avm_waitrequest) begin
                StartRead(STATUS_BASE);
                if(bytes_counter_r < 7'd31) begin
                    dec_w = {dec_r[247:0], 8'b0};
                end
                else begin
                    dec_w = {dec_r[247:0], 8'b0};
                    enc_w = 0;
                    state_w = S_KEY;
                    bytes_counter_w = 7'd64;
                end
            end
        end

        default: state_w = S_KEY;
    endcase
end

always_ff @(posedge avm_clk or posedge avm_rst) begin
    if (avm_rst) begin
        n_r <= 0;
        d_r <= 0;
        enc_r <= 0;
        dec_r <= 0;
        avm_address_r <= STATUS_BASE;
        avm_read_r <= 1;
        avm_write_r <= 0;
        state_r <= S_KEY;
        bytes_counter_r <= 0;
        rsa_start_r <= 0;
    end else begin
        n_r <= n_w;
        d_r <= d_w;
        enc_r <= enc_w;
        dec_r <= dec_w;
        avm_address_r <= avm_address_w;
        avm_read_r <= avm_read_w;
        avm_write_r <= avm_write_w;
        state_r <= state_w;
        bytes_counter_r <= bytes_counter_w;
        rsa_start_r <= rsa_start_w;
    end
end

endmodule
*/