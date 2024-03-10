module router_register(clk,rstn,pkt_valid,fifo_full,rst_int_reg,detect_addr,ld_state,laf_state,full_state,lfd_state,din,parity_done,low_pkt_valid,error,dout);
input clk,rstn,pkt_valid,fifo_full,rst_int_reg,detect_addr,ld_state,laf_state,full_state,lfd_state;
input[7:0]din;
output reg parity_done,low_pkt_valid,error;
output reg [7:0]dout;
reg [7:0]header_byte,fifo_full_state_byte,internal_parity,pkt_parity;
always@(posedge clk)
begin
if(~rstn)
parity_done<=0;
else
begin
if(ld_state&& ~pkt_valid&& ~fifo_full)
parity_done<=1'b1;
else if(laf_state&&low_pkt_valid&& ~parity_done)
parity_done<=1'b1;
else
begin
if(detect_addr)
parity_done<=0;
end
end
end
always@(posedge clk)
begin
if(~rstn)
dout<=0;
else if(lfd_state)
dout<=header_byte;
else if(ld_state&& ~fifo_full)
dout<=din;
else if(laf_state)
dout<=fifo_full_state_byte;
else
dout<=dout;
end
always@(posedge clk)
begin
if(~rstn)
{header_byte,fifo_full_state_byte}<=0;
else
begin
if(pkt_valid&&detect_addr)
header_byte<=din;
else if(ld_state&&fifo_full)
fifo_full_state_byte<=din;
end
end
always@(posedge clk)
begin
if(~rstn)
low_pkt_valid<=1'b0;
else if(rst_int_reg)
low_pkt_valid<=1'b0;
else
begin
        if(~pkt_valid && ld_state)
low_pkt_valid<=1'b1;
end
end
always@(posedge clk)
begin
if(~rstn)
pkt_parity<=0;
else if((ld_state&& ~pkt_valid&& ~fifo_full)||(laf_state&&low_pkt_valid&& ~parity_done))
pkt_parity<=din;
else if(~pkt_valid&&rst_int_reg)
pkt_parity<=0;
else
begin
if(detect_addr)
pkt_parity<=0;
end
end
always@(posedge clk)
begin
if(~rstn)
internal_parity<=8'b0;
else if(detect_addr)
internal_parity<=8'b0;
else if (lfd_state)
internal_parity<=header_byte;
else if(ld_state&&pkt_valid&& ~full_state)
internal_parity<=internal_parity^din;
else if(~pkt_valid&&rst_int_reg)
internal_parity<=0;
end
always@(posedge clk)
begin
if(~rstn)
error<=0;
else
begin
if(parity_done==1'b1 && (internal_parity!=pkt_parity))
error<=1'b1;
else
error<=0;
end
end
endmodule
