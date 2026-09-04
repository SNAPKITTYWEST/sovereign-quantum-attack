// File: state_machine_top.sv
// Wrapper for FPGA State Machine

module state_machine_top #(
    parameter N = 10,
    parameter CTRL_WIDTH = 4
)(
    input logic clk,
    input logic rst_n,
    input logic [CTRL_WIDTH-1:0] ctrl_in,
    output logic [N-1:0] state_out,
    output logic alarm
);

    logic [N-1:0] current_state;
    logic [N-1:0] next_state;
    logic error;

    binary_transition_matrix #(N, CTRL_WIDTH) matrix_inst (
        .clk(clk),
        .rst_n(rst_n),
        .ctrl_in(ctrl_in),
        .current_state(current_state),
        .next_state(next_state),
        .error_flag(error)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= 10'd0;
        end else begin
            current_state <= next_state;
        end
    end

    assign state_out = current_state;
    assign alarm = error;

endmodule
