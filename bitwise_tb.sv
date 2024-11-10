module tb_bitwise#(parameter WIDTH = 4);
 
	// Declaracion de variables //
  bit clk; 
  reg [WIDTH-1:0] a = 4'b0000;
  reg [WIDTH-1:0] b = 4'b0000;
  reg [WIDTH-1:0] bitwise_and;
  reg [WIDTH-1:0] bitwise_or;
  reg [WIDTH-1:0] bitwise_xor;
  integer i=0;
	event a_ev;
	event b_ev;
	event and_ev;
 
	initial begin 				 // Proceso 1
		forever begin 			 // Debe llevar el forever si no, solo se ejecuta una vez
			@(posedge clk); 	 // El @ es un operador para esperar un evento
            std::randomize(a);
			->a_ev; 					 // Triggers el evento por 1 timestep
		end
	end
 
	always begin 					 // Proceso 2
			@(posedge clk); 	 // El @ es un operador para esperar un evento
			std::randomize(b);
			->b_ev; 					 // Triggers el evento por 1 timestep
	end
 
	initial begin 				 // Proceso 1
		forever begin 			 // Debe llevar el forever si no, solo se ejecuta una vez
			@(posedge clk); 	 // El @ es un operador para esperar un evento
            std::randomize(bitwise_and);
			->and_ev; 					 // Triggers el evento por 1 timestep
		end
	end
	 
	initial begin // Se ejecuta en t=0	
		fork
			begin // Proceso 3
				repeat(5) begin
					@(posedge clk); 	 // El @ es un operador para esperar un evento
					wait(and_ev.triggered);
					$display("a: %b", a); // Tercero a ser visto
				end
			end
 
			begin // Proceso 4
				repeat(5) begin
					@(posedge clk); 	 // El @ es un operador para esperar un evento
					wait(b_ev.triggered);
					$display("b: %b", b); // Segundo a ser visto
				end
			end
 
			begin // Proceso 5
				repeat(5) begin
					@(posedge clk); 	 // El @ es un operador para esperar un evento
					wait(a_ev.triggered);
					$display("and: %b", bitwise_and); // Primero a ser visto
				end
			end
		join
	end
  // Proceso de la señal de reloj
  always #10ns clk=!clk;
  // instanciación del modulo y asingacion de entradas y salidas
  bitwise #(.WIDTH(4)) DUT (
    .a(a),
    .b(b),
    .bitwise_and(bitwise_and),
    .bitwise_or(bitwise_or),
    .bitwise_xor(bitwise_xor)
  );
 
  initial begin 
    $dumpfile("filel.vcd");
    $dumpvars;
  end
endmodule