module tb;
    int task1_count = 0;
    int task2_count = 0;
    
    task task1;
        while($time < 200) begin
            #20;
            $display("Task 1 Trigger");
            task1_count++;
        end
    endtask
    
    task task2;
        while($time < 200) begin
            #40;
            $display("Task 2 Trigger");
            task2_count++;
        end
    endtask
    
    task monitor;
        #200;
        $display("Task 1 executed: %0d times", task1_count);
        $display("Task 2 executed: %0d times", task2_count);
        $finish;
    endtask
    
    initial begin
        fork
            task1;
            task2;
            monitor;
        join
    end
endmodule