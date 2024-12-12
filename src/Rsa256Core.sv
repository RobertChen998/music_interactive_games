module Rsa256Core (
    input          i_clk,
    input          i_rst,
    input          i_start,
    input  [255:0] i_x, // 256-bit input??
    input  [255:0] i_y,
    output [255:0] o_x,
    output [255:0] o_y,
    output         o_finished
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE,
        INIT,
        PROCESS,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Internal signals
    logic o_finished_r, o_finished_w;

    assign o_x = i_x;
    assign o_y = i_y;
    assign o_finished = o_finished_r;

    // FSM state transition
    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // FSM next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (i_start) begin
                    next_state = INIT;
                end else begin
                    next_state = IDLE;
                end
            end
            INIT: begin
                next_state = PROCESS;
            end
            PROCESS: begin
                next_state = DONE;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // FSM output logic
    always_comb begin
        case (current_state)
            IDLE: begin
                o_finished_r = 0;
            end
            INIT: begin
                o_finished_r = 0;
            end
            PROCESS: begin
                o_finished_r = 0;
            end
            DONE: begin
                o_finished_r = 1;
            end
        endcase
    end

endmodule