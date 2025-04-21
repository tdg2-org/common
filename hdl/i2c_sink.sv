
// designed for avnet ZUBoard, MAC eeprom AT24MAC402
// accepts data sent by master - up to 3 bytes, in addition
// to device address. the 3 bytes are mem_addr and 2bytes of data_in
// 7bit dev addr + RW bit, 8bit mem addr, 8 bit data...
// RW bit : 1=read, 0=write
// responds to master read operations. external data_send or data written by master

// no consideration for timing/CDC - i2c runs at 100KHz, everything else 100MHz, meh...
// passes timing fine, dont care, just meant as a test/debug tool

// i2c clock and data from master are on the tri-state control '_t' pins!! 

`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module i2c_sink (
  input           clk             , // 100mhz
  input           clk12           , // clk div8 = 12.5mhz
  input           rst             ,
  input           data_send_en_i  ,
  input   [15:0]  data_send_i     ,
  input           scl_i           , // not used
  input           scl_t           ,
  output          scl_o           ,
  input           sda_i           , // not used
  output          sda_o           ,
  input           sda_t 
);
//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

  logic scl, sda, ack, ack_sync=0;

  assign scl = scl_t;
  assign sda = sda_t;

  //assign sda_o = 1;
  assign scl_o = scl_t;


  typedef enum {
    IDLE,GET_DADDR,SEND_DATA,GET_MADDR,GET_DATA,ACK1,ACK2,ACK3
  } i2c_sm_type;

  i2c_sm_type I2C_SM;

  logic [2:0] cnt=7;
  logic [7:0] data1, data2, dev_addr, mem_addr;
  logic [15:0] data_in, data_send;
  logic live=0,scl_re,scl_fe,rw,sda_send=0,rw_align_fe,send_byte=0,send_mem;
  logic [1:0] scl_sr,sda_sr;
  logic [7:0] data_save [1:0];

  assign scl_re = (scl_sr == 'b01) ? 1:0;
  assign scl_fe = (scl_sr == 'b10) ? 1:0;
  assign sda_re = (sda_sr == 'b01) ? 1:0;
  assign sda_fe = (sda_sr == 'b10) ? 1:0;

  always_ff @(posedge clk) begin //oversample i2c clock
    scl_sr <= {scl_sr[0],scl};
    sda_sr <= {sda_sr[0],sda};
    
    if (scl_fe && rw) rw_align_fe <= '1;
    else if (!rw)     rw_align_fe <= '0;

    if (scl_sr[1] && sda_re) begin//stop cond
      cnt <= 7;
      I2C_SM <= IDLE;
    end else begin 
    
    case (I2C_SM) 
      IDLE: begin 
        send_mem  <= 1;
        send_byte <= 0;
        rw        <= '0;
        //data_in   <= '0;
        if (scl_sr[1] && sda_fe) begin //start cond
          live <= 1;
          I2C_SM <= GET_DADDR;
        end
      end

      GET_DADDR: begin //0
        if (scl_re) begin 
          //data1 <= {data1[6:0],sda};
          data1[cnt] <= sda;
          cnt <= cnt - 1;
          if (cnt == 0) begin  
            rw  <= sda;
            cnt <= 7;
            I2C_SM <= ACK1;
          end
        end
      end
      
      ACK1: begin  
        if (scl_re) begin 
          if (rw) I2C_SM <= SEND_DATA;  // master READ
          else    I2C_SM <= GET_MADDR;  // master write
        end
      end

      SEND_DATA: begin 
        if (scl_fe) begin  
          if (send_mem) sda_send <= mem_addr[cnt];
          else          sda_send <= data_send[(send_byte + 1)*cnt + (send_byte*8 - send_byte*cnt)]; // easily expand number of send bytes (master reads). currently 2bytes max
          cnt <= cnt - 1;
          if (cnt == 0) begin
            if (!send_mem)  send_byte <= send_byte + 1; 
            else send_mem <= 0;
            cnt <= 7;
            I2C_SM <= ACK3;
          end
        end 
      end 

      GET_MADDR: begin 
        if (scl_re) begin  
          //data2 <= {data2[6:0],sda};
          data2[cnt] <= sda;
          cnt <= cnt - 1;
          if (cnt == 0) begin
            cnt <= 7;
            I2C_SM <= ACK2;
          end
        end
      end

      ACK2: begin  
        if (scl_re) begin 
          I2C_SM <= GET_DATA;
        end
      end

      GET_DATA: begin 
        if (scl_re) begin
          data_in <= {data_in[14:0],sda};
          cnt <= cnt - 1;
          if (cnt == 0) begin
            cnt <= 7;
            I2C_SM <= ACK3;
          end
        end
      end

      ACK3 : begin 
        if ((!rw && scl_re) || (rw && scl_fe)) begin   
          live <= 0;
          if (rw) I2C_SM <= SEND_DATA;  // master READ
          else    I2C_SM <= GET_DATA;   // master write
        end
      end

    endcase 
    end
  end 

  always_ff @(posedge clk) begin //oversample i2c clock
    if (I2C_SM==ACK1 || I2C_SM==ACK2 || I2C_SM==ACK3) ack <= 1;
    else ack <= 0;
  end

  always_ff @(negedge scl_t) begin 
    if (ack)  ack_sync <= 1;
    else      ack_sync <= 0;
  end

  assign sda_o =  (ack_sync) ? 0 : 
                  (rw_align_fe) ? sda_send: sda_t;

  logic data_valid, dev_valid, mem_valid;

  assign dev_valid  = (I2C_SM==ACK1) ? 1:0;
  assign mem_valid  = (I2C_SM==ACK2) ? 1:0;
  assign data_valid = (I2C_SM==ACK3) ? 1:0;

  always_comb begin 
    if (dev_valid) begin 
      dev_addr  = {1'b0,data1[7:1]};
      //rw        = data1[0];
    end
    if (mem_valid) mem_addr = data2;
  end

  always_ff @(posedge clk) begin
    if (data_valid && scl_re && !rw) data_save <= {data_save[0],data_in[7:0]};
  end

  // for master reads, send external user data, or send data written by master writes
  assign data_send = (data_send_en_i) ? {data_send_i[7:0],data_send_i[15:8]} : {data_save[0],data_save[1]}; 

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------


/*
`ifndef QUESTA
`ifndef MODELSIM

ila2 ila2_0 (
	.clk(clk), // input wire clk
	.probe0(data_send_i[7:0]  ),  // input wire [7:0]  probe0  
	.probe1(data_send_i[15:8] ),  // input wire [7:0]  probe1
	.probe2(data_in           ),  // input wire [15:0]  probe1
	.probe3({scl_t, ack, ack_sync, rw, scl_re, scl_fe, sda_re, sda_fe }    ),  // input wire [7:0]  probe1
  .probe4({data_send_en_i, send_byte, data_valid  }   ) // [2:0]
);

`endif
`endif 
*/


endmodule

/* instantiation quick copy

(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "TRUE" *) i2c_sink i2c_sink_inst (
    .clk    (clk    ),
    .rst    (rst    ),
    .scl_i  (scl0_i ),
    .scl_t  (scl0_t ),
    .scl_o  (scl0_o ),
    .sda_i  (sda0_i ),
    .sda_o  (sda0_o ),
    .sda_t  (sda0_t )
  );
*/
