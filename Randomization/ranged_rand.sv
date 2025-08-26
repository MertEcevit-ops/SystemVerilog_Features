class generator;
    rand bit [4:0] a;
    rand bit [5:0] b;
    
    constraint range_c {
        a inside {[0:8]};
        b inside {[0:5]};
    }
endclass

module tb;
    generator gen;
    int error_count = 0;
    int iteration = 0;
    
    initial begin
        gen = new();
        
        repeat(20) begin
            iteration++;
            if(gen.randomize()) begin
                $display("Iteration %2d: a=%0d b=%0d", iteration, gen.a, gen.b);
            end else begin
                $display("Iteration %2d: Randomization failed!", iteration);
                error_count++;
            end
        end
        
        $display("\n=== Summary ===");
        $display("Total iterations: 20");
        $display("Successful randomizations: %0d", 20 - error_count);
        $display("Failed randomizations: %0d", error_count);
        
        $finish;
    end
endmodule