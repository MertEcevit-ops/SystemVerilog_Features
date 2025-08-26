class transaction;
    bit [7:0] addr = 7'h12;
    bit [3:0] data = 4'h4;
    bit we = 1'b1;
    bit rst = 1'b0;
endclass

class generator;
    transaction t;
    mailbox mbx;
    
    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction
    
    task main();
        repeat(5) begin
            t = new();
            t.addr = $urandom_range(0, 255);
            t.data = $urandom_range(0, 15);
            t.we = $urandom_range(0, 1);
            t.rst = $urandom_range(0, 1);
            
            $display("[GEN] : DATA SENT : addr=%0h, data=%0h, we=%0b, rst=%0b", 
                     t.addr, t.data, t.we, t.rst);
            mbx.put(t);
            #5;
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
        forever begin
            mbx.get(dc);
            $display("[DRV] : DATA RCVD : addr=%0h, data=%0h, we=%0b, rst=%0b", 
                     dc.addr, dc.data, dc.we, dc.rst);
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
        
        fork
            g.main();
            d.main();
        join_any
        
        #50;
        $finish;
    end
endmodule