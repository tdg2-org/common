// **! STOP - dont use this for DFX ILAs!
//  to add ILA into an RP, just need to add BSCAN ports unconnected 
//    * see UG909 'Using Vivado Debug Cores' section. v2023.2 

// Leaving as-is, may be useful for other reasons in future??...

// this module is instantiated in static region
// connect to debug_bridge instantiated in partial reconfig region
 

module bscan (
  output  [9:0] bscan_o ,
  input   tdo_i     
);

  logic capture,drck,reset,runtest,sel,shift,tck,tdi,tms,update;

  assign bscan_o[9] = capture ;  
  assign bscan_o[8] = drck    ;  
  assign bscan_o[7] = reset   ;  
  assign bscan_o[6] = runtest ;  
  assign bscan_o[5] = sel     ;  
  assign bscan_o[4] = shift   ;  
  assign bscan_o[3] = tck     ;  
  assign bscan_o[2] = tdi     ;  
  assign bscan_o[1] = tms     ;  
  assign bscan_o[0] = update  ;

  // BSCANE2: Boundary-Scan User Instruction
  // UltraScale
  // Xilinx HDL Language Template, version 2024.2
  BSCANE2 #(
    .JTAG_CHAIN(1) // Value for USER command
  ) BSCANE2_inst (
    .CAPTURE  (capture  ),  // 1-bit output: CAPTURE output from TAP controller.
    .DRCK     (drck     ),  // 1-bit output: Gated TCK output. When SEL is asserted, DRCK toggles when CAPTURE or SHIFT are asserted.
    .RESET    (reset    ),  // 1-bit output: Reset output for TAP controller.
    .RUNTEST  (runtest  ),  // 1-bit output: Output asserted when TAP controller is in Run Test/Idle state.
    .SEL      (sel      ),  // 1-bit output: USER instruction active output.
    .SHIFT    (shift    ),  // 1-bit output: SHIFT output from TAP controller.
    .TCK      (tck      ),  // 1-bit output: Test Clock output. Fabric connection to TAP Clock pin.
    .TDI      (tdi      ),  // 1-bit output: Test Data Input (TDI) output from TAP controller.
    .TMS      (tms      ),  // 1-bit output: Test Mode Select output. Fabric connection to TAP.
    .UPDATE   (update   ),  // 1-bit output: UPDATE output from TAP controller.
    .TDO      (tdo      )   // 1-bit input: Test Data Output (TDO) input for USER function.
  );


endmodule

// instantiation quick copy

/*
`ifndef QUESTA
`ifndef MODELSIM

debug_bridge_RM debug_bridge_RM_inst (
  .clk                (clk                ), // input wire clk
  .S_BSCAN_bscanid_en (0                  ), // input wire S_BSCAN_bscanid_en
  .S_BSCAN_capture    (bscan_i[9]         ), // input wire S_BSCAN_capture
  .S_BSCAN_drck       (bscan_i[8]         ), // input wire S_BSCAN_drck
  .S_BSCAN_reset      (bscan_i[7]         ), // input wire S_BSCAN_reset
  .S_BSCAN_runtest    (bscan_i[6]         ), // input wire S_BSCAN_runtest
  .S_BSCAN_sel        (bscan_i[5]         ), // input wire S_BSCAN_sel
  .S_BSCAN_shift      (bscan_i[4]         ), // input wire S_BSCAN_shift
  .S_BSCAN_tck        (bscan_i[3]         ), // input wire S_BSCAN_tck
  .S_BSCAN_tdi        (bscan_i[2]         ), // input wire S_BSCAN_tdi
  .S_BSCAN_tms        (bscan_i[1]         ), // input wire S_BSCAN_tms
  .S_BSCAN_update     (bscan_i[0]         ), // input wire S_BSCAN_update
  .S_BSCAN_tdo        (tdo_o              )  // output wire S_BSCAN_tdo
);

`endif
`endif 
*/

