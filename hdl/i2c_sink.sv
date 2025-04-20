
// designed for avnet ZUBoard, MAC eeprom AT24MAC402
// does not send data to master, but accepts data sent by master - up to 3 bytes, in addition
// to device address. the 3 bytes are mem_addr and 2bytes of data_in
// 7bit dev addr + RW bit, 8bit mem addr, 8 bit data...
// RW bit = 1 read, 0 write

`timescale 1ns / 1ps  // <time_unit>/<time_precision>

module i2c_sink (
  input   clk   ,
  input   clk12 ,
  input   rst   ,
  input   scl_i ,
  input   scl_t ,
  output  scl_o ,
  input   sda_i ,
  output  sda_o ,
  input   sda_t 
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
    IDLE,GET_DADDR,GET_MADDR,GET_DATA,ACK1,ACK2,ACK3
  } i2c_sm_type;

  i2c_sm_type I2C_SM;

  int cnt;
  logic [7:0] data1, data2, dev_addr, mem_addr;
  logic [15:0] data_in;
  logic live=0,scl_re,scl_fe;
  logic [1:0] scl_sr,sda_sr;

  assign scl_re = (scl_sr == 'b01) ? 1:0;
  assign scl_fe = (scl_sr == 'b10) ? 1:0;
  assign sda_re = (sda_sr == 'b01) ? 1:0;
  assign sda_fe = (sda_sr == 'b10) ? 1:0;

  always_ff @(posedge clk) begin //oversample i2c clock
    scl_sr <= {scl_sr[0],scl};
    sda_sr <= {sda_sr[0],sda};
    
    if (scl_sr[1] && sda_re) begin//stop cond
      cnt <= 0;
      I2C_SM <= IDLE;
    end else begin 
    
    case (I2C_SM) 
      IDLE: begin 
        data_in<='0;
        //if (!live && !sda_sr[1] && scl_sr[1]) begin //start cond
        if (scl_sr[1] && sda_fe) begin //start cond
          live <= 1;
          I2C_SM <= GET_DADDR;
        end
      end

      GET_DADDR: begin //0
        if (scl_re) begin 
          data1 <= {data1[6:0],sda};
          cnt <= cnt + 1;
          if (cnt == 7) begin  
            cnt <= 0;
            I2C_SM <= ACK1;
          end
        end
      end
      
      ACK1: begin  
        if (scl_re) begin 
          I2C_SM <= GET_MADDR;
        end
      end

      GET_MADDR: begin 
        if (scl_re) begin  
          data2 <= {data2[6:0],sda};
          cnt <= cnt + 1;
          if (cnt == 7) begin
            cnt <= 0;
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
          cnt <= cnt + 1;
          if (cnt == 7) begin
            cnt <= 0;
            I2C_SM <= ACK3;
          end
        end
      end

      ACK3 : begin 
        if (scl_re) begin   
          live <= 0;
          I2C_SM <= GET_DATA;
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

  assign sda_o = (ack_sync) ? 0 : sda_t;

  logic data_valid, dev_valid, mem_valid, rw;

  assign dev_valid  = (I2C_SM==ACK1) ? 1:0;
  assign mem_valid  = (I2C_SM==ACK2) ? 1:0;
  assign data_valid = (I2C_SM==ACK3) ? 1:0;

  always_comb begin 
    if (dev_valid) begin 
      dev_addr  = {1'b0,data1[7:1]};
      rw        = data1[0];
    end
    if (mem_valid) mem_addr = data2;
  end

//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------


`ifndef QUESTA
`ifndef MODELSIM

ila2 ila2_0 (
	.clk(clk), // input wire clk
	.probe0(dev_addr      ),  // input wire [7:0]  probe0  
	.probe1(mem_addr      ),  // input wire [7:0]  probe1
	.probe2(data_in       ),  // input wire [15:0]  probe1
	.probe3({scl_t, ack, ack_sync, rw, scl_re, scl_fe, sda_re, sda_fe }    ),  // input wire [7:0]  probe1
  .probe4({dev_valid, mem_valid, data_valid  }   ) // [2:0]
);

`endif
`endif 



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
