module version (
  output [63:0] git_hash_scripts    ,
  output [63:0] git_hash_top        ,
  output [63:0] git_hash_common     ,
  output [63:0] git_hash_sw         ,
  output [63:0] git_hash_ip         ,

  output [31:0] timestamp_scripts   ,
  output [31:0] timestamp_top       ,
  output [31:0] timestamp_common    ,
  output [31:0] timestamp_sw        ,
  output [31:0] timestamp_ip        
);
///////////////////////////////////////////////////////////////////////////////////////////////////

// SCRIPTS
  user_init_64b scripts_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_scripts)
  );

  user_init_32b scripts_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_scripts)
  );

// TOP
  user_init_64b top_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_top)
  );

  user_init_32b top_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_top)
  );

// common
  user_init_64b common_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_common)
  );

  user_init_32b common_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_common)
  );

// sw
  user_init_64b sw_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_sw)
  );

  user_init_32b sw_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_sw)
  );

// ip
  user_init_64b ip_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_ip)
  );

  user_init_32b ip_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_ip)
  );

endmodule

/* 

version version_inst (
  .git_hash_scripts   (git_hash_scripts    ),
  .git_hash_top       (git_hash_top        ),
  .git_hash_common    (git_hash_common     ),
  .git_hash_sw        (git_hash_sw         ),
  .git_hash_ip        (git_hash_ip         ),
  .timestamp_scripts  (timestamp_scripts   ),
  .timestamp_top      (timestamp_top       ),
  .timestamp_common   (timestamp_common    ),
  .timestamp_sw       (timestamp_sw        ),
  .timestamp_ip       (timestamp_ip        )
);

*/