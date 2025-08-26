class generator;
    rand bit rst;
    rand bit wr;
    
    constraint signal_dist {
        rst dist {0 := 70, 1 := 30};
        wr dist {0 := 50, 1 := 50};
    }
endclass

module tb;
    generator gen;
    int rst_low_count = 0;
    int wr_high_count = 0;
    
    initial begin
        gen = new();
        
        $display("=== Generating 20 Random Values ===");
        $display("Iteration | rst | wr");
        $display("----------|-----|----");
        
        repeat(20) begin
            gen.randomize();
            $display("    %2d    |  %0d  | %0d", $time/10, gen.rst, gen.wr);
            
            if(gen.rst == 0) rst_low_count++;
            if(gen.wr == 1) wr_high_count++;
            
            #10;
        end
        
        $display("\n=== Statistics ===");
        $display("rst was low (0): %0d times out of 20 (%0.1f%%)", 
                 rst_low_count, (rst_low_count * 100.0 / 20));
        $display("wr was high (1): %0d times out of 20 (%0.1f%%)", 
                 wr_high_count, (wr_high_count * 100.0 / 20));
        
        $display("\nExpected: rst low ~30%%, wr high ~50%%");
        
        $finish;
    end
endmodule