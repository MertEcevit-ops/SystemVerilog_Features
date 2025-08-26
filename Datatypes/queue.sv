module testbench_top;
    
    integer fixed_array [0:19];  // Fixed-size array with 20 elements
    integer queue_array [$];     // Queue
    
    initial begin
        // Fill fixed-size array with random values
        for (int i = 0; i < 20; i++) begin
            fixed_array[i] = $urandom % 100;  // Random values 0-99
        end
        
        // Transfer from fixed-size array to queue (reverse order)
        // First element of array becomes last element of queue
        for (int i = 0; i < 20; i++) begin
            queue_array.push_front(fixed_array[i]);
        end
        
        // Print fixed-size array
        $write("Fixed Array: ");
        for (int i = 0; i < 20; i++) $write("%0d ", fixed_array[i]);
        $display("");
        
        // Print queue
        $write("Queue:       ");
        for (int i = 0; i < queue_array.size(); i++) $write("%0d ", queue_array[i]);
        $display("");
        
        $finish;
    end
    
endmodule