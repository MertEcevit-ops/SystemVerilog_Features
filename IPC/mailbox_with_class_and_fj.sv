class transaction;
    rand bit [7:0] a;
    rand bit [7:0] b;
    rand bit wr;
endclass

class generator;
    transaction t;
    mailbox mbx;
    
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction
    
    task main();
        repeat(10) begin
            t = new();
            t.randomize();
            $display("[GEN] : Transaction %0d SENT : a=%0d, b=%0d, wr=%0b", 
                     $time/10, t.a, t.b, t.wr);
            mbx.put(t);
            #10;
        end
    endtask
endclass

class driver;
    transaction dc;
    mailbox mbx;
    
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction
    
    task main();
        repeat(10) begin
            mbx.get(dc);
            $display("[DRV] : Transaction %0d RCVD : a=%0d, b=%0d, wr=%0b", 
                     $time/10, dc.a, dc.b, dc.wr);
            #10;
        end
    endtask
endclass

module tb;
    generator g;
    driver d;
    mailbox mbx;
    
    initial begin
        mbx = new();
        g = new(mbx);
        d = new(mbx);
        
        $display("=== Starting 10 Random Transactions ===\n");
        
        fork
            g.main();
            d.main();
        join
        
        $display("\n=== All 10 Transactions Completed ===");
        $finish;
    end
endmodule