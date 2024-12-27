module SramAddrEncoder (
    input i_clk,
    input i_rst_n,
    input [20:0] i_object_pixel_index,
    output [19:0] o_sram_addr
);
    localparam BG_START = 0;
    reg [19:0] sram_addr_r, sram_addr_w;
    assign o_sram_addr = sram_addr_r;

    always @(*) begin
        sram_addr_w = BG_START + (i_object_pixel_index >> 2);
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            sram_addr_r <= 0;
        end
        else begin
            sram_addr_r <= sram_addr_w;
        end
    end
endmodule