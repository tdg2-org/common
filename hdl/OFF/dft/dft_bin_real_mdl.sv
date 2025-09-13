// 2-space indent as requested
module dft_bin_real_mdl
  #(parameter int N = 1024,
    parameter int K = 7)
(
  input  logic        clk,
  input  logic        rst,
  input  logic        sample_valid,
  input  real         x,           // real input sample
  output logic        bin_done,
  output real         X_re,
  output real         X_im
);

  localparam real TWO_PI = 6.2831853071795864769;
  localparam real dtheta = TWO_PI * K / N;

  // running phasor for the current n
  real c, s;         // cos(theta_n), sin(theta_n)
  real cs, ss;       // cos(dtheta),  sin(dtheta)

  // accumulators
  real acc_re, acc_im;
  int  n;

  // initialize at each block start: u=cos(0)+j sin(0)=1+ j*0
  task automatic start_block();
    acc_re = 0.0;
    acc_im = 0.0;
    c = 1.0;
    s = 0.0;
    cs = $cos(dtheta);
    ss = $sin(dtheta);
    n  = 0;
    bin_done = 0;
  endtask



  real c_next;
  real s_next;
  // complex multiply-accumulate with twiddle = c - j*s
  // Re += x*c ; Im -= x*s
  always_ff @(posedge clk) begin
    if (rst) begin
      start_block();
    end else if (sample_valid && !bin_done) begin
      acc_re += x * c;
      acc_im -= x * s;

      // advance phasor: [c'; s'] = [c; s] * e^{j dtheta}
      // c' = c*cs - s*ss ; s' = s*cs + c*ss
      c_next = c*cs - s*ss;
      s_next = s*cs + c*ss;
      c <= c_next;
      s <= s_next;

      n <= n + 1;
      if (n+1 == N) begin
        X_re    <= acc_re;
        X_im    <= acc_im;
        bin_done <= 1;
      end
    end
  end

endmodule
/*

  dft_bin_real_mdl #(
    .N(1024   ) ,
    .K(7      )
  ) dft_bin_real_mdl_inst (
    .clk            (),
    .rst            (),
    .sample_valid   (),
    .x              (),           // real input sample
    .bin_done       (),
    .X_re           (),
    .X_im           ()
  );


*/