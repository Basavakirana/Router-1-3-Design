module router_synchronizer(detect_addr,write_enb_reg,clk,rstn,din,re_0,re_1,re_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,fifo_full,we,soft_rst_0,soft_rst_1,soft_rst_2,valid_out_0,valid_out_1,valid_out_2);
input detect_addr,write_enb_reg,clk,rstn;
input[1:0]din;
input re_0,re_1,re_2;
input empty_0,empty_1,empty_2;
input full_0,full_1,full_2;
output reg fifo_full;
output reg[2:0]we;
output reg soft_rst_0,soft_rst_1,soft_rst_2;
output valid_out_0,valid_out_1,valid_out_2;
reg [4:0]timer_0,timer_1,timer_2;
reg [1:0]int_addr_reg;
wire w1=(timer_0==5'd29)?1'b1:1'b0;
wire w2=(timer_1==5'd29)?1'b1:1'b0;
wire w3=(timer_2==5'd29)?1'b1:1'b0;
always@(posedge clk)
begin
        if(~(rstn))
begin
                timer_0<=0;
        soft_rst_0<=0;
end
else if(valid_out_0)
begin
        if(!re_0)
        begin
                if(w1)
                begin
                        soft_rst_0<=1;
                        timer_0<=0;
                end
                else
                begin
                        soft_rst_0<=0;
                        timer_0<=timer_0+1'b1;
                end
        end
end
end
always@(posedge clk)
begin
        if(~(rstn))
begin
                timer_1<=0;
        soft_rst_1<=0;
end
else if(valid_out_1)
begin
        if(!re_1)
        begin
                if(w2)
                begin
                        soft_rst_1<=1;
                        timer_1<=0;
                end
                else
                begin
                        soft_rst_1<=0;
                        timer_1<=timer_1+1'b1;
                end
        end
end
end
always@(posedge clk)
begin
        if(~(rstn))
begin
                timer_2<=0;
        soft_rst_2<=0;
end
else if(valid_out_2)
begin
        if(!re_2)
        begin
                if(w3)
                begin
                        soft_rst_2<=1;
                        timer_2<=0;
                end
                else
                begin
                        soft_rst_2<=0;
                        timer_2<=timer_2+1'b1;
                end
        end
end
end
always@(posedge clk)
begin
        if(~rstn)
                int_addr_reg<=0;
        else if(detect_addr)
                int_addr_reg<=din;
end
always@(*)
begin
        we=3'b000;
        if(write_enb_reg)
        begin
                case(int_addr_reg)
                        2'b00:we=3'b001;
                        2'b01:we=3'b010;
                        2'b10:we=3'b100;
                        default:we=3'b000;
                endcase
        end
end
always@(*)
begin
        case(int_addr_reg)
                2'b00:fifo_full=full_0;
                2'b01:fifo_full=full_1;
                2'b10:fifo_full=full_2;
                default:fifo_full=0;
        endcase
end
assign valid_out_0=~empty_0;
assign valid_out_1=~empty_1;
assign valid_out_2=~empty_2;
endmodule
