module testbench_top;
    
    integer dyn_array [];
    
    initial begin
        // Create array with 7 elements - multiples of 7
        dyn_array = new[7];
        for (int i = 0; i < 7; i++) dyn_array[i] = (i + 1) * 7;
        
        // Wait 20 ns
        #20ns;
        
        // Resize to 20 elements
        dyn_array = new[20](dyn_array);
        
        // Fill remaining elements - multiples of 5
        for (int i = 7; i < 20; i++) dyn_array[i] = (i - 6) * 5;
        
        // Print final array
        $write("Result: ");
        for (int i = 0; i < 20; i++) $write("%0d ", dyn_array[i]);
        $display("");
        
        $finish;
    end
    
endmodule