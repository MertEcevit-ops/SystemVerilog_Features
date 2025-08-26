module testbench_top;
    
    // Variable declarations
    reg [7:0] a, b;     // 8-bit reg variables
    integer c, d;       // integer variables
    
    initial begin
        // Initialize variables
        a = 8'd12;
        b = 8'd34;
        c = 67;
        d = 255;
        
        // Wait for 12 ns and then print values
        #12ns;
        
        $display("Time: %0t ns", $time);
        $display("a = %0d (8'h%h)", a, a);
        $display("b = %0d (8'h%h)", b, b);
        $display("c = %0d", c);
        $display("d = %0d", d);
        
        // End simulation
        $finish;
    end
    
endmodule