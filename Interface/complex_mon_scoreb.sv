`timescale 1ns/1ps

// ===================== DUT =====================
module top
(
  input        clk,
  input  [3:0] a,
  input  [3:0] b,
  output reg [7:0] mul
);
  always @(posedge clk) begin
    mul <= a * b;
  end
endmodule

// ================== Interface ==================
interface top_if;
  logic        clk;
  logic [3:0]  a, b;
  logic [7:0]  mul;
endinterface

// ========== Sample type (Monitor->Scoreboard) ==========
typedef struct packed {
  bit [3:0] a;
  bit [3:0] b;
  bit [7:0] mul;
} mul_sample_t;

// ==================== Monitor ====================
class monitor;
  virtual top_if vif;
  mailbox #(mul_sample_t) mbx;

  function new(virtual top_if vif, mailbox #(mul_sample_t) mbx);
    this.vif = vif;
    this.mbx = mbx;
  endfunction

  task run();
    mul_sample_t s;
    forever begin
      @(posedge vif.clk);
      s.a   = vif.a;
      s.b   = vif.b;
      s.mul = vif.mul;
      mbx.put(s);
      // $display("[MON] a=%0d b=%0d mul=%0d", s.a, s.b, s.mul); // optional
    end
  endtask
endclass

// =================== Scoreboard ===================
class scoreboard;
  mailbox #(mul_sample_t) mbx;
  int pass_cnt, fail_cnt;

  // Model 1-cycle latency: store previous a,b
  bit       prev_valid;
  bit [3:0] prev_a, prev_b;

  function new(mailbox #(mul_sample_t) mbx);
    this.mbx = mbx;
    pass_cnt = 0;
    fail_cnt = 0;
    prev_valid = 0;
    prev_a = '0; prev_b = '0;
  endfunction

  task run();
    mul_sample_t s;
    bit [7:0] exp;

    forever begin
      mbx.get(s);

      if (prev_valid) begin
        exp = prev_a * prev_b;
        if (s.mul === exp) begin
          pass_cnt++;
          $display("[SCB][PASS] exp=%0d  got=%0d  (prev a=%0d, b=%0d)",
                   exp, s.mul, prev_a, prev_b);
        end else begin
          fail_cnt++;
          $display("[SCB][FAIL] exp=%0d  got=%0d  (prev a=%0d, b=%0d)",
                   exp, s.mul, prev_a, prev_b);
        end
      end

      // Move current inputs to "previous" for next cycle's check
      prev_a     = s.a;
      prev_b     = s.b;
      prev_valid = 1'b1;
    end
  endtask

  function void report();
    $display("\n================ SCOREBOARD SUMMARY ================");
    $display("  PASS: %0d", pass_cnt);
    $display("  FAIL: %0d", fail_cnt);
    $display("===================================================\n");
  endfunction
endclass

// ===================== TB Top =====================
module tb;

  top_if vif();

  // DUT instance
  top dut (vif.clk, vif.a, vif.b, vif.mul);

  // Clock
  initial begin
    vif.clk = 1'b0;
  end
  always #5 vif.clk = ~vif.clk;  // 100 MHz

  // Stimulus (as requested: generated in TB, no driver/generator classes)
  initial begin
    // initialize inputs to avoid X on first cycle
    vif.a <= 4'd0;
    vif.b <= 4'd0;

    for (int i = 0; i < 20; i++) begin
      @(posedge vif.clk);
      vif.a <= $urandom_range(1,15);
      vif.b <= $urandom_range(1,15);
    end
  end

  // Hook up Monitor & Scoreboard
  mailbox #(mul_sample_t) mbx = new();
  monitor   mon;
  scoreboard scb;

  initial begin
    mon = new(vif, mbx);
    scb = new(mbx);
    fork
      mon.run();
      scb.run();
    join_none
  end

  // Optional: print live view of DUT I/O every posedge
  always @(posedge vif.clk) begin
    $display("[TB ] @%0t  a=%0d b=%0d -> mul=%0d", $time, vif.a, vif.b, vif.mul);
  end

  // Dump & finish
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
    #300;
    scb.report();
    $finish();
  end

endmodule
