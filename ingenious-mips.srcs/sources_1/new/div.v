`include "defines.v"
module DIV(
    input wire rst,
    input wire clk,
    input wire signed_div_i,
    input wire [`RegBus] operand1_i, //opdata1
    input wire [`RegBus] operand2_i, //opdata2
    input wire start_i,
    input wire annul_i,
    output reg [`DoubleRegBus] quotient_o,
    output reg finished_o
   
);
    wire [32:0] div_temp;
    reg [5:0] cnt;
    reg [64:0] dividend; 
    //front 32 bits is minuend, and the back 32 bits is initially the dividend
    //add the quotient to the back of dividend as it divides, 
    //and pushes left as it goes,
    reg [1:0] state;
    reg [`RegBus] divisor;
    reg [`RegBus] operand1_tmp;
    reg [`RegBus] operand2_tmp;
    
    assign div_temp = {1'b0, dividend[63:32]} - {1'b0, divisor};
    
    always @ (posedge clk) begin
        if(rst == `Enable) begin
            state <= `DivFree;
            finished_o <= `DivResultNotReady;
            quotient_o <= {`ZeroWord, `ZeroWord};
        end else begin
            case(state)
                `DivFree: begin
                    if(start_i == `DivStart && annul_i == 1'b0) begin
                        if(operand2_i == `ZeroWord) begin
                            state <= `DivByZero;
                        end else begin
                            state <= `DivOn;
                            cnt <= 6'b000000;
                            if(signed_div_i == 1'b1 && operand1_i[31] == 1'b1) begin
                                operand1_tmp <= ~operand1_i + 1; 
                            end else begin
                                operand1_tmp <= operand1_i;
                            end
                            if(signed_div_i == 1'b1 && operand2_i[31] == 1'b1) begin
                                operand2_tmp <= ~operand2_i + 1; 
                            end else begin
                                operand2_tmp <= operand2_i;
                            end
                            dividend <= {`ZeroWord, `ZeroWord};
                            dividend[32:1] <= operand1_tmp; //把被除数放入dividend
                            divisor <= operand2_tmp;
                        end
                    end else begin
                        finished_o <= `DivResultNotReady;
                        quotient_o <= {`ZeroWord, `ZeroWord};
                    end
                end
                `DivByZero: begin
                    dividend <= {`ZeroWord, `ZeroWord};
                    state <= `DivEnd;
                end
                `DivOn: begin
                    if(annul_i == 1'b0) begin
                        if(cnt != 6'b100000) begin
                            //if div_temp is negative, shift left for dividend
                            if(div_temp[32] == 1'b1) begin
                                dividend <= {dividend[63:0], 1'b0};
                            //else, it means that the divisor is less than the minuend
                            //set the minuend - divisor (aka the div_temp) as the new front 32 bits of dividend,
                            // and shift the last 32 digits left, add 1 to the last bit for quotient
                            end else begin
                                dividend <= {div_temp[31:0], dividend[31:0], 1'b1};
                            end
                            cnt <= cnt + 1;
                        end else begin //cnt == 32
                            //if the signs don't match, means the quotient is negative
                            if((signed_div_i == 1'b1) && ((operand1_i[31] ^ operand2_i[31])== 1'b1)) begin
                                dividend[31:0] <= ~dividend[31:0] + 1;
                            end
                            //if the signs of the dividend and remainder doesn't match
                            if((signed_div_i == 1'b1) && ((operand1_i[31] ^ dividend[64]) == 1'b1)) begin
                                dividend[64:33] <= ~dividend[64:33] + 1;
                            end
                            state <= `DivEnd;
                            cnt <= 6'b00000;
                        end
                    end else begin //annul == 1
                        state <= `DivFree;
                    end
                end
                `DivEnd: begin
                    quotient_o <= {dividend[64:33], dividend[31:0]}; //technically it's remainder and quotient
                    finished_o <= `DivResultReady;
                    if(start_i == `DivStop) begin
                        state <= `DivFree;
                        finished_o <= `DivResultNotReady;
                        quotient_o <= {`ZeroWord, `ZeroWord};
                    end
                end
            endcase
        end
        
    end //always
    
endmodule