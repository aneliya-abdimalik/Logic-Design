`timescale 1ns / 1ps
module lab3_2(
    input [5:0] money,
    input CLK,
    input [1:0] selectedArea,
    input plugAvailability,
    output reg [5:0] moneyLeft,
    output reg [4:0] seatLeft,
    output reg seatUnavailable,
    output reg insufficientFund,
    output reg notExactFund,
    output reg invalidPlugSeat,
    output reg plugSeatUnavailable,
    output reg seatReady
);


reg [4:0] TotalSeatsCount[0:2];      
reg [4:0] PlugSeats[0:2];   

initial begin
    
    TotalSeatsCount[0] = 15;  
    TotalSeatsCount[1] = 25;  
    TotalSeatsCount[2] = 20; 
    PlugSeats[0] = 0;
    PlugSeats[1] = 10;
    PlugSeats[2] = 20;
end

always @(posedge CLK) begin
    seatUnavailable = 0;
    insufficientFund = 0;
    notExactFund = 0;
    invalidPlugSeat = 0;
    plugSeatUnavailable = 0;
    seatReady = 0;
    moneyLeft =0;
    
    case (selectedArea)
        2'b00: begin 
            moneyLeft=money;
            seatLeft=TotalSeatsCount[0]; 
            if (TotalSeatsCount[0] == 0) begin
                seatUnavailable = 1;
            end else if (plugAvailability) begin
                invalidPlugSeat = 1;
            end else if (money < 10) begin
                insufficientFund = 1;
            end else begin
                TotalSeatsCount[0] = TotalSeatsCount[0] - 1;
                moneyLeft = money - 10;
                seatLeft = TotalSeatsCount[0];
                seatReady = 1;
            end
        end
        2'b01: begin  
            seatLeft=TotalSeatsCount[1];
            moneyLeft=money;
            if (!plugAvailability && (TotalSeatsCount[1] - PlugSeats[1] == 0)) begin
                seatUnavailable = 1;
            end else if (plugAvailability && PlugSeats[1] == 0) begin
                plugSeatUnavailable = 1;
            end  else if (money < 20) begin
                insufficientFund = 1;
            end else begin
                if (plugAvailability) begin
                    PlugSeats[1] = PlugSeats[1] - 1;
                end
                TotalSeatsCount[1] = TotalSeatsCount[1] - 1;
                moneyLeft = money - 20;
                seatLeft = PlugSeats[1];
                seatReady = 1;
            end
        end
        2'b11: begin 
            seatLeft=TotalSeatsCount[2];
            moneyLeft=money;
            if (TotalSeatsCount[2] == 0) begin
                seatUnavailable = 1;
            end else if (money != 30) begin
                notExactFund = 1;
            end else begin
                TotalSeatsCount[2] = TotalSeatsCount[2] - 1;
                moneyLeft = money - 30;
                seatLeft = TotalSeatsCount[2];
                seatReady = 1;
            end
        end
    endcase
end

endmodule

