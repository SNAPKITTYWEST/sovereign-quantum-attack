// File: binary_transition_matrix.sv
// Synthesizable RTL for Binary Transition Matrix M_trans
// Derived from Log-Complexity Attack Generator Formal Spec

module binary_transition_matrix #(
    parameter N = 10,
    parameter CTRL_WIDTH = 4
)(
    input logic clk,
    input logic rst_n,
    input logic [CTRL_WIDTH-1:0] ctrl_in,
    input logic [N-1:0] current_state,
    output logic [N-1:0] next_state,
    output logic error_flag
);

    always_comb begin
        error_flag = 1'b0;
        
        case ({current_state, ctrl_in})
            {10'd0, 4'd0} : next_state = 10'd1;
            {10'd1, 4'd1} : next_state = 10'd2;
            {10'd2, 4'd0} : next_state = 10'd5;
            
            default : begin
                next_state = current_state;
                error_flag = 1'b1;
            end
        endcase
    end

endmodule
