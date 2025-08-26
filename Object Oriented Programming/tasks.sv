module tb_memory_simple;

    // Signals
    logic clk_25mhz;
    logic [5:0] addr;
    logic wr;
    logic en;
    
    // 25MHz clock generation
    initial begin
        clk_25mhz = 0;
        forever #20 clk_25mhz = ~clk_25mhz; // 25MHz = 40ns period
    end
    
    // Simple stimulus task
    task send_stimulus(input [5:0] address, input write_en, input enable);
        @(posedge clk_25mhz);
        addr = address;
        wr = write_en;
        en = enable;
        $display("Time: %0t, addr: 0x%02X, wr: %b, en: %b", $time, addr, wr, en);
    endtask
    
    // Test sequence
    initial begin
        // Initialize
        addr = 0;
        wr = 0;
        en = 0;
        
        #100; // Wait 100ns
        
        // Test stimulus
        send_stimulus(6'h00, 1, 1); // Write to address 0x00
        send_stimulus(6'h01, 1, 1); // Write to address 0x01
        send_stimulus(6'h02, 0, 1); // Read from address 0x02
        send_stimulus(6'h03, 0, 1); // Read from address 0x03
        send_stimulus(6'h00, 0, 0); // Idle state
        
        #200;
        $finish;
    end
    
endmodule