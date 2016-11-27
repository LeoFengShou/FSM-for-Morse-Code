module part3(input[2:0] SW, input[1:0] KEY, input CLOCK_50, output[9:0] LEDR);
wire [3:0] M_code;
morse_encoder M0 (SW[2:0], M_code[3:0]);
wire [1:0] length;
length_determiner L0 (SW[2:0], length[1:0]);
wire [3:0] Mc;
wire [2:0] y_C, y_D;
wire [2:0] counter;
//y_C is the current state and Y_D is the next state
//debug code
assign LEDR[2:1] = length[1:0];
assign LEDR[6:3] = M_code[3:0];
assign LEDR[8:7] = counter[2:0];


halfSecondCounter H0 (y_D,CLOCK_50,KEY[0],length,M_code,Mc,y_C,counter);
FSM F0 (y_C, y_D, Mc, KEY[1:0], counter);
assignLEDOutput(y_C, LEDR[0]);

endmodule


module halfSecondCounter(input [2:0] y_D, input CLOCK_50, input Resetn,
input [1:0] length, input [3:0] M_code,
output reg [3:0] Mc,output reg [2:0] y_C, output reg [2:0] counter_reg
);
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;
reg [25:0] count;
always @(posedge CLOCK_50, negedge Resetn)
begin
if(!Resetn)
begin
y_C <= A;
count <= 0;
counter_reg <= 0;
Mc <= 0;
end
else
begin
if (count < 25000000)
count <= count + 1;
else
begin
count <= 0;
y_C <= y_D;
if (y_D == A) begin
counter_reg <= length + 1;
Mc <= M_code;
end
if (y_D == E) begin
counter_reg <= counter_reg - 1;
Mc[0] <= Mc[1];
Mc[1] <= Mc[2];
Mc[2] <= Mc[3];
Mc[3] <= 1'b0;
end
end
end
end
endmodule


module FSM (y_C, y_D, Mc, KEY, counter);
input [2:0] y_C;
input [3:0] Mc;
input [1:0] KEY;
input [2:0] counter;
output reg [2:0] y_D;
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;
always @(Mc[0], KEY[1:0], counter, y_C)
begin
case (y_C)
A: if (!KEY[1]) y_D = B;
else y_D = A;
B: if (!Mc[0]) y_D = E;
else y_D = C;
C: if (!KEY[0]) y_D = A;
else y_D = D;
D: if (!KEY[0]) y_D = A;
else y_D = E;
E: if (counter == 0) y_D = A;
else y_D = B;
default: y_D = A;
endcase
end
endmodule

module assignLEDOutput(input [2:0]y_C, output reg z);
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100;
always @(y_C)
begin
case (y_C)
B: z = 1;
C: z = 1;
D: z = 1;
default: z = 0;
endcase
end
endmodule


module length_determiner(input [2:0]s, output[1:0] l);
assign l[1] = s[1]|s[0];
assign l[0] = (s[2]&s[0])|((~s[0])&(~s[2]))|((~s[2])&(~s[1]));
endmodule


module morse_encoder(input [2:0] s, output reg [3:0] L);
always @(s)
        case(s)
            3'b000: begin L<=4'b0010; end
            3'b001: begin L<=4'b0001; end
            3'b010: begin L<=4'b0101; end
            3'b011: begin L<=4'b0001; end
            3'b100: begin L<=4'b0000; end
            3'b101: begin L<=4'b0100; end
            3'b110: begin L<=4'b0011; end
            3'b111: begin L<=4'b0000; end
            default: begin L<=4'bxxxx; end
        endcase
endmodule
