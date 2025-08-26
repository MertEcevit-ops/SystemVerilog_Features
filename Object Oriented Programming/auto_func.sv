module tb;
      
    // Local array to store the values
    bit [7:0] res[32];
    
    // Function that generates and returns 32 values of multiples of 8
    function automatic void init_arr(ref bit [7:0] a[32]);  
        for(int i = 0; i < 32; i++) begin  
            a[i] = 8 * i;
        end
    endfunction 
    

    initial begin
        // Method 1: Using reference parameter
        init_arr(res);
        
        $display("=== Method 1: Using ref parameter ===");
        for(int i = 0; i < 32; i++) begin  
            $display("res[%2d] : %3d", i, res[i]);
        end

    end
    
endmodule