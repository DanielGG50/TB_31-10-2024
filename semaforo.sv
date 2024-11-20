module semaforo #(parameter WIDTH = 32) (
    input logic clk, start, maintenance,        // Basic controls
    input logic [WIDTH-1:0] red_duration,       // Control durations 
    input logic [WIDTH-1:0] yellow_duration,    
    input logic [WIDTH-1:0] green_duration,     
    input logic manual_red, manual_yellow, manual_green, // Maintinence inputs
    output logic red, yellow, green             // Colors
);

    logic [WIDTH-1:0] counter; // Contador para controlar los tiempos

    typedef enum logic [1:0] {
        RED = 2'b00,
        GREEN = 2'b01,
        YELLOW = 2'b10
    } state_t;

    state_t current_state, next_state;

    // Process 1: Red
    always_ff @(posedge clk) begin
        if (maintenance) begin   // When maintinence is active color is dependent to maintinence color input
            red <= manual_red;  
        end else if (!start) begin
            red <= 1'b0;         // If not started turn off
        end else if (current_state == RED) begin
            red <= 1'b1;         // When state is red turn on
        end else begin
            red <= 1'b0;         // Turn off in any other case
        end
    end

    // Process 2: Green
    always_ff @(posedge clk) begin
        if (maintenance) begin
            green <= manual_green;          // Same as red
        end else if (!start) begin
            green <= 1'b0;           
        end else if (current_state == GREEN) begin
            green <= 1'b1;           
        end else begin
            green <= 1'b0;          
        end
    end

    // Process 3: Yellow
    always_ff @(posedge clk) begin
        if (maintenance) begin
            yellow <= manual_yellow;        // Same as red
        end else if (!start) begin
            yellow <= 1'b0;            
        end else if (current_state == YELLOW) begin
            yellow <= 1'b1;
        end else begin
            yellow <= 1'b0;
        end
    end

    // Process 4: Sequence
    always_ff @(posedge clk) begin
        if (maintenance) begin
	    current_state <= current_state;
	    counter <= counter;  
        end 
        else if (!start) begin
            current_state <= RED; 
            counter <= 0;  
        end 
        else begin
            if (counter == 0) begin
                // When counter meets value evaluates case
                case (current_state)
                    RED: begin
                        counter <= green_duration - 1; // Sets next color value
                        next_state <= GREEN;           // Sets next state 
                    end
                    GREEN: begin
                        counter <= yellow_duration - 1; // Same as red
                        next_state <= YELLOW;          
                    end
                    YELLOW: begin
                        counter <= red_duration - 1; // Same as red
                        next_state <= RED;          
                    end
                endcase
            end else begin
                counter <= counter - 1; // Counter decreases
            end
            current_state <= next_state; // Sets new state
        end
    end

endmodule




