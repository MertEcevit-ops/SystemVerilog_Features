`timescale 1ns/1ps

//========================= DUT (verdiğin) =========================
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

//=========================== INTERFACE ============================
interface mul_if;
  logic        clk;
  logic [3:0]  a;
  logic [3:0]  b;
  logic [7:0]  mul;
endinterface

//========================== TRANSACTION ===========================
class transaction;
  randc bit [3:0] a;
  randc bit [3:0] b;
       bit [7:0] mul;  // beklenen (a*b) değerini de tutalım

  function void display();
    $display("a : %0d \t b : %0d \t mul(exp) : %0d", a, b, mul);
  endfunction

  // deep copy
  function transaction copy();
    copy = new();
    copy.a   = this.a;
    copy.b   = this.b;
    copy.mul = this.mul;
  endfunction

  // randomize sonrası beklenen değeri hesapla
  function void post_randomize();
    mul = a * b;
  endfunction
endclass

//=========================== GENERATOR ============================
class generator;
  transaction                trans;
  mailbox #(transaction)     mbx;
  event                      done;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    trans = new();
  endfunction

  task run();
    for (int i = 0; i < 10; i++) begin
      void'(trans.randomize());
      mbx.put(trans.copy());      // DİKKAT: copy() fonksiyon
      $display("[GEN] : DATA SENT TO DRIVER");
      trans.display();
      #20;
    end
    -> done;
  endtask
endclass

//============================ DRIVER ==============================
class driver;
  virtual mul_if             aif;
  mailbox #(transaction)     mbx;
  transaction                data;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    forever begin
      mbx.get(data);            // bir iş al
      @(posedge aif.clk);       // senkron sür
      aif.a <= data.a;
      aif.b <= data.b;
      $display("[DRV] : Interface Trigger  a=%0d b=%0d (expect mul=%0d)", data.a, data.b, data.mul);
      // Sonuç bir sonraki pozedge'de aif.mul üzerinde oluşur (monitor ekleyebilirsin).
    end
  endtask
endclass

//============================== TB ================================
module tb;
  mul_if aif();
  driver     drv;
  generator  gen;
  event      done;
  mailbox #(transaction) mbx;

  // Saat
  initial aif.clk = 0;
  always  #10 aif.clk = ~aif.clk;  // 50 MHz

  // DUT inst
  top dut (
    .clk (aif.clk),
    .a   (aif.a),
    .b   (aif.b),
    .mul (aif.mul)
  );

  // Basit gözlem (monitor yerine), çıktıyı her pozedge yazdır
  always @(posedge aif.clk) begin
    $display("[TB ] @%0t  a=%0d b=%0d -> mul=%0d", $time, aif.a, aif.b, aif.mul);
  end

  initial begin
    mbx = new();
    drv = new(mbx);
    gen = new(mbx);
    drv.aif = aif;
    done = gen.done;
  end

  initial begin
    fork
      gen.run();
      drv.run();
    join_none
    wait(done.triggered);
    // Son birkaç sonuç için 3-4 clock bekleyelim
    repeat (4) @(posedge aif.clk);
    $finish();
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end
endmodule
