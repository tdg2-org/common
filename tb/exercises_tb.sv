`timescale 1ns / 1ps  // <time_unit>/<time_precision>

import exercise_pkg::*;

module mux_tb;

  localparam N = 4;

  logic clk=0,rst,wr=0,rd=0,en=0,bnc;
  logic [N-1:0] data=0,dat;
  logic [$clog2(N)-1:0] sel=0;

  always #2.5ns clk = ~clk;

  initial begin 
    rst = 1;bnc = 0;
    #20ns;
    rst = 0;
    #20ns;en=1;
    data = 1; #20ns;
    sel = 1; #20ns; bnc = 1;
    data = 2; #20ns;
    data = 5; #20ns;
    sel = 3; #20ns;
    data = 6; #20ns;
    data = 7; #20ns;
    data = 8; #20ns;
    bnc = 0;#20ns;
    bnc = 1;#200ns;
    bnc = 0;#20ns;
  end



  mux #(
    .N      (N     )
  )mux_inst(
    .clk    (clk    ),
    .rst    (rst    ),
    .data_i (data  ),
    .sel_i  (sel   ),
    .out    (      )
  );

  demux #(
    .N      (N     )
  )demux(
    .clk    (clk    ),
    .rst    (rst    ),
    .data_i (data[0]),
    .sel_i  (sel   ),
    .data_o (      )
  );

  cnt #(
    .N      (N     )
  )cnt_inst(
    .clk    (clk    ),
    .rst    (rst    ),
    .en     (en     ),
    .count  (       )
  );

  pwm #(
    .PERIOD     (20 ),
    .DUTYCYCLE  (3  )
  )pwm_inst(
    .clk    (clk    ),
    .rst    (rst    ),
    .en     (en     ),
    .sig    (       )
  );

  priority_encoder #(
    .N      (N     )
  )priority_encoder(
    .clk    (clk    ),
    .rst    (rst    ),
    .data_i (data   ),
    .data_o (       )
  );

  debounce #(
    .N      (4     )
  )debounce(
    .clk    (clk    ),
    .rst    (rst    ),
    .sig_i  (bnc    ),
    .sig_o  (       )
  );

  sens_type sens;

  initial begin 
    sens.e = '0;sens.w = '0;sens.n = '0;sens.s = '0;
    wait (!rst);
    #30ns;
    sens.e = '1;
    #50ns;sens.e = '0;sens.n = '1;

  end

  traffic #(
    .Num      (4     )
  )traffic(
    .clk      (clk    ),
    .rst      (rst    ),
    .sensors  (sens   ),
    .lightE   (       ),
    .lightW   (       ),
    .lightN   (       ),
    .lightS   (       )
  );


endmodule


module fifo_tb;

  localparam WID = 8;
  localparam DEP = 8;

  logic clk=0,rst,wr=0,rd=0;
  logic [WID-1:0] data=0,dat;

  always #2.5ns clk = ~clk;

  initial begin 
    rst = 1;
    #20ns;
    rst = 0;
    #20ns;
    dat = 32'ha0;
    repeat (10) begin 
      wrd1(dat);dat = dat + 1;
    end
    #40ns;
    repeat (5) begin 
      rd1;
    end
    #40ns;
    repeat (6) begin 
      wrd1(dat);dat = dat + 1;
    end
    #40ns;
    repeat (10) begin 
      rd1;
    end


  end

  task wrd1(input logic [WID-1:0] dat);
    data = dat;
    @(posedge clk);wr=1;@(posedge clk);wr=0;    
  endtask

  task rd1;
    @(posedge clk);rd=1;@(posedge clk);rd=0;    
  endtask



  fifo #(
    .DWIDTH  (WID   ),
    .DEPTH   (DEP   ),
    .FWFT    (1     )
  )fifo_inst(
    .clk    (clk   ),
    .rst    (rst   ),
    .data_i (data  ),
    .wr     (wr    ),
    .full_o (      ),
    .data_o (      ),
    .rd     (rd    ),
    .empty_o(      )
  );


endmodule

module fifo_tb2;
    // Test parameters
    parameter DWIDTH = 32;
    parameter DEPTH  = 32;

    // Clock & Reset
    logic clk = 0;
    logic rst;
    
    // FIFO Interface
    logic [DWIDTH-1:0] data_i;
    logic wr, full_o;
    logic [DWIDTH-1:0] data_o;
    logic rd, empty_o;

    // Instantiate FIFO DUT
    fifo #(.DWIDTH(DWIDTH), .DEPTH(DEPTH), .FWFT(1)) dut (
        .clk(clk),
        .rst(rst),
        .data_i(data_i),
        .wr(wr),
        .full_o(full_o),
        .data_o(data_o),
        .rd(rd),
        .empty_o(empty_o)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Scoreboard for expected data tracking
    int unsigned queue[$]; // FIFO reference model
    int expected;
    
    // Test Procedure
    initial begin
        $display("Starting FIFO test...");
        rst = 1; wr = 0; rd = 0; data_i = 0;
        #20 rst = 0; // Release reset

        // Fill FIFO completely
        $display("Filling FIFO...");
        for (int i = 0; i < DEPTH; i++) begin
            data_i = i;
            wr = 1;
            queue.push_back(i); // Store expected value
            #10;
        end
        wr = 0; #10;

        // Try to write beyond FIFO capacity (overflow)
        $display("Testing Overflow...");
        repeat (5) begin
            data_i = 999; // Invalid data, should be ignored
            wr = 1;
            if (full_o !== 1)
                $error("FAIL: Overflow write attempt when full_o is not asserted!");
            #10;
        end
        wr = 0; #10;

        // Read all data from FIFO (FWFT mode handling)
        $display("Reading from FIFO...");
        while (!empty_o) begin
            // Ensure data_o is valid before reading
            if (queue.size() == 0) begin
                $error("FAIL: Read more data than written!");
                break;
            end

            expected = queue.pop_front();
            
            if (data_o !== expected)
                $error("FAIL: Expected %0d, got %0d", expected, data_o);
            else
                $display("PASS: Read %0d correctly", data_o);

            // Read only if FIFO is not empty
            rd = !empty_o;
            #10;
        end
        rd = 0; #10;

        // Test Underflow: Read when FIFO is empty
        $display("Testing Underflow...");
        repeat (5) begin
            rd = 1;
            #10;
            rd = 0;
            if (empty_o !== 1)
                $error("FAIL: Underflow read attempted but empty_o not asserted!");
            #10;
        end

        $display("FIFO test completed.");
        $finish;
    end
endmodule

