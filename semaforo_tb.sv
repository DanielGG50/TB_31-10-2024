module semaforo_tb;

    // Parámetros de prueba
    parameter WIDTH = 32;
    logic clk, start, maintenance;
    logic [WIDTH-1:0] red_duration, yellow_duration, green_duration;
    logic manual_red, manual_yellow, manual_green;
    logic red, yellow, green;

    // Instancia del módulo semáforo
    semaforo #(.WIDTH(WIDTH)) uut (
        .clk(clk),
        .start(start),
        .maintenance(maintenance),
        .red_duration(red_duration),
        .yellow_duration(yellow_duration),
        .green_duration(green_duration),
        .manual_red(manual_red),
        .manual_yellow(manual_yellow),
        .manual_green(manual_green),
        .red(red),
        .yellow(yellow),
        .green(green)
    );

    // Generador de reloj
    always #1 clk = ~clk;

    initial begin
        // Inicialización
        clk = 0;
        start = 0;  // El semáforo empieza apagado
        maintenance = 0; // Mantenimiento desactivado
        manual_red = 0;
        manual_yellow = 0;
        manual_green = 0;
        red_duration = 10;
        yellow_duration = 3;
        green_duration = 7;

        #50 start = 1;   // Iniciar semáforo en el ciclo de reloj 2

        // Activar mantenimiento
        #100 maintenance = 1;   // Activar mantenimiento después de 100 unidades de tiempo
        #10 manual_green = 1;         // Encender manualmente el rojo

        // Cambiar manualmente a otros colores
        #10 manual_red = 1; manual_yellow = 1; // Amarillo encendido
        #10 manual_yellow = 0; // Verde encendido
        #10 manual_green = 0; maintenance = 0;   // Desactivar mantenimiento y reiniciar semáforo automático
        
        // Activar mantenimiento
        //#100 maintenance = 1;   // Activar mantenimiento después de 100 unidades de tiempo
        //#10 manual_red = 1;         // Encender manualmente el rojo

        // Cambiar manualmente a otros colores
        //#10 manual_red = 0; manual_yellow = 1; // Amarillo encendido
        //#10 manual_yellow = 0; manual_green = 1; // Verde encendido
        //#10 manual_green = 0; maintenance = 0;   // Desactivar mantenimiento y reiniciar semáforo automático        
        
        

        // Simular por un tiempo
        #500 $stop;
    end
endmodule




