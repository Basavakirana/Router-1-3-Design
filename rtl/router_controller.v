module router_controller(clk,rstn,pkt_valid,parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
din,busy,detect_addr,lfd_state,laf_state,full_state,write_enb_reg,rst_int_reg,ld_state);
input clk,rstn,pkt_valid,parity_done,fifo_full,low_pkt_valid;
input soft_rst_0,soft_rst_1,soft_rst_2;
input fifo_empty_0,fifo_empty_1,fifo_empty_2;
input [1:0]din;
output busy,detect_addr,lfd_state,laf_state,full_state,write_enb_reg,rst_int_reg,ld_state;
parameter decode_address=3'b000,load_first_data=3'b001,load_data=3'b010,fifo_full_state=3'b011,load_after_full=3'b100,load_parity=3'b101,check_parity_error=3'b110,wait_till_empty=3'b111;
reg[2:0]pre,next;
reg[2:0]addr;
always@(posedge clk)
begin
if(~rstn)
pre<=next;
else
if((soft_rst_0&&din==2'b00)||(soft_rst_0&&din==2'b01)||(soft_rst_2&&din==2'b10))
pre<=decode_address;
else
pre<=next;
end
always@(*)
begin
next=pre;
begin
case(pre)
decode_address: if((pkt_valid&&(din==0)&&fifo_empty_0)||(pkt_valid&&(din==1)&&fifo_empty_1)||(pkt_valid&&(din==2)&&fifo_empty_2))
                next=load_first_data;
                else if((pkt_valid&&(din==0)&& ~fifo_empty_0)||(pkt_valid&&(din==1)&& ~fifo_empty_1)||(pkt_valid&&(din==2)&& ~fifo_empty_2))
                next=wait_till_empty;
                else next=load_data;
load_first_data: next=load_data;
load_data:      if(fifo_full)
                next=fifo_full_state;
                else if (~fifo_full&& ~pkt_valid)
                next=load_parity;
                else next=load_data;
fifo_full_state: if(~fifo_full)
                next=load_after_full;
                 else next=fifo_full_state;
load_after_full: if(~parity_done&&low_pkt_valid)
                next=load_parity;
                 else if(~parity_done&& ~low_pkt_valid)
                next=load_data;
                 else next=decode_address;
load_parity: next=check_parity_error;
check_parity_error: if(fifo_full)
                   next=fifo_full_state;
                     else next=decode_address;
wait_till_empty: if((fifo_empty_0&&(addr==0))||(fifo_empty_1&&(addr==1))||(fifo_empty_2&&(addr==2)))
                        next=load_first_data;
                  else next=wait_till_empty;
default: next=decode_address;
endcase
end
end
always@(posedge clk)
begin
if(~rstn)
addr<=0;
else
if((soft_rst_0&&din==2'b00)||(soft_rst_1&&din==2'b01)||(soft_rst_2&&din==2'b10))
addr<=0;
else if(decode_address)
addr<=din;
end
assign detect_addr=(pre==decode_address)?1'b1:1'b0;
assign lfd_state=(pre==load_first_data)?1'b1:1'b0;
assign full_state=(pre==fifo_full_state)?1'b1:1'b0;
assign ld_state=(pre==load_data)?1'b1:1'b0;
assign laf_state=(pre==load_after_full)?1'b1:1'b0;
assign rst_int_reg=(pre==check_parity_error)?1'b1:1'b0;
assign write_enb_reg=((pre==load_data||pre==load_after_full||pre==load_parity))?1'b1:1'b0;
assign busy=((pre==load_first_data||pre==fifo_full_state||pre==load_after_full||pre==load_parity||pre==check_parity_error||pre==wait_till_empty))?1'b1:1'b0;
endmodule
