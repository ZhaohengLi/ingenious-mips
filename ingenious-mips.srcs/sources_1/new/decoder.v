`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/23 17:19:33
// Design Name: 
// Module Name: decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DECODER(
    input wire[3:0] inByte,
    output wire[7:0] dpy
);

reg[7:0] display;
assign dpy = display;

always @ (inByte) begin
    case (inByte)
        4'h0: begin
            display <= 8'b01111110;
        end
        4'h1: begin
            display <= 8'b00010010;
        end
        4'h2: begin
            display <= 8'b10111100;
        end
        4'h3: begin
            display <= 8'b10110110;
        end
        4'h4: begin
            display <= 8'b11010010;
        end
        4'h5: begin
            display <= 8'b11100110;
        end
        4'h6: begin
            display <= 8'b11101110;
        end
        4'h7: begin
            display <= 8'b00110010;
        end
        4'h8: begin
            display <= 8'b11111110;
        end
        4'h9: begin
            display <= 8'b11110110;
        end
        4'ha: begin
            display <= 8'b10001110;
        end
        4'hb: begin
            display <= 8'b11001110;
        end
        4'hc: begin
            display <= 8'b10001100;
        end
        4'hd: begin
            display <= 8'b10011110;
        end
        4'he: begin
            display <= 8'b11101100;
        end
        4'hf: begin
            display <= 8'b11101000;
        end
    endcase
end

endmodule
