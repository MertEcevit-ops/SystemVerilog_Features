    class generator;
      
      rand bit [3:0] addr;
      rand bit wr;
      
      /////////////////add constraint 
      
      constraint addr_range{
        if(wr = 1)
            addr inside {[0:7]};
        else
            addr inside {[8:15]};
      }
      
    endclass
     
    /////////////////Add testbench top code
    module tb;
    generator gen;
    
    initial begin
        gen = new();
        
        $display("=== Generating 20 Random Values ===");
        $display("Iteration | wr | addr | Expected Range");
        $display("----------|-------|------|---------------");
        
        repeat(20) begin
            gen.randomize();
            $display("    %2d    |   %0d   |  %2d  | %s", 
                     $time/10, gen.wr, gen.addr,
                     (gen.wr == 1) ? "[0:7]" : "[8:15]");
            #10;
        end
        
        $display("\n=== Verification ===");
        $display("When wr=1, addr should be 0-7");
        $display("When wr=0, addr should be 8-15");
        
        $finish;
    end
endmodule