library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity teclado is
  port (
    clk : in std_logic;  -- Reloj de la FPGA
    PS2_CLK, PS2_DAT : in std_logic;
    lcd_rs, lcd_rw, lcd_en : out std_logic;
    lcd_data : out std_logic_vector(7 downto 0)
  );
end teclado;

architecture teclado_arch of teclado is
  signal PS2_DAT_frame : std_logic_vector(21 downto 0);
  signal char_to_display : std_logic_vector(7 downto 0);

  procedure send_to_lcd(command : std_logic; data : std_logic_vector) is
    variable delay_counter : integer := 0;
  begin
    -- Secuencia de envío de comando o dato al LCD_Display --
    lcd_rs <= command;  -- RS = 0 para comando, RS = 1 para dato
    lcd_rw <= '0';      -- RW = 0 para escritura
    lcd_en <= '1';      -- Habilita el LCD

    lcd_data <= data;   -- Envía los datos al LCD

    -- Retardo para asegurar que el LCD reciba los datos correctamente
    for i in 1 to 1000 loop
      delay_counter := delay_counter + 1;
    end loop;

    lcd_en <= '0';      -- Deshabilita el LCD
  end procedure;

begin
  process (clk)
    variable lcd_data_value : std_logic_vector(7 downto 0);
  begin
    if rising_edge(clk) then
      PS2_DAT_frame <= PS2_DAT & PS2_DAT_frame(21 downto 1);  -- Actualiza el valor de PS2_DAT_frame

      if PS2_CLK = '1' then
        if PS2_DAT_frame(8 downto 1) = X"F0" then  -- Verifica si es el inicio de un código de tecla
          case PS2_DAT_frame(16 downto 9) is
            -- Caracteres de la A a la Z --
            when X"1C" => -- A
              char_to_display <= "01000001";
            when X"32" => -- B
              char_to_display <= "01000010";
            when X"21" => -- C
              char_to_display <= "01000011";
            when X"2B" => -- F
              char_to_display <= "01000110";
            when X"34" => -- G
              char_to_display <= "01000111";
            when X"33" => -- H
              char_to_display <= "01001000";
            when X"43" => -- I
              char_to_display <= "01001001";
            when X"3B" => -- J
              char_to_display <= "01001010";
            when X"42" => -- K
              char_to_display <= "01001011";
            when X"4B" => -- L
              char_to_display <= "01001100";
            when X"3A" => -- M
              char_to_display <= "01001101";
            when X"31" => -- N
              char_to_display <= "01001110";
            when X"44" => -- O
              char_to_display <= "01001111";
				when X"4D" => -- P
              char_to_display <= "01010000";
            when X"15" => -- Q
              char_to_display <= "01010001";
            when X"2D" => -- R
              char_to_display <= "01010010";
            when X"1B" => -- S
              char_to_display <= "01010011";
            when X"2C" => -- T
              char_to_display <= "01010100";
            when X"3C" => -- U
              char_to_display <= "01010101";
            when X"2A" => -- V
              char_to_display <= "01010110";
            when X"1D" => -- W
              char_to_display <= "01010111";
            when X"22" => -- X
              char_to_display <= "01011000";
            when X"35" => -- Y
              char_to_display <= "01011001";
            when X"1A" => -- Z
              char_to_display <= "01011010";

            -- Números del 0 al 9 --
            when X"45" => -- 0
              char_to_display <= "00110000";
            when X"16" => -- 1
              char_to_display <= "00110001";
            when X"1E" => -- 2
              char_to_display <= "00110010";
            when X"26" => -- 3
              char_to_display <= "00110011";
            when X"25" => -- 4
              char_to_display <= "00110100";
            when X"2E" => -- 5
              char_to_display <= "00110101";
            when X"36" => -- 6
              char_to_display <= "00110110";
            when X"3D" => -- 7
              char_to_display <= "00110111";
            when X"3E" => -- 8
              char_to_display <= "00111000";
            when X"46" => -- 9
              char_to_display <= "00111001";

            when others =>
              char_to_display <= "00000000";
          end case;

          -- Llama a la función o rutina para enviar comandos y datos al LCD --
          send_to_lcd('1', char_to_display); -- '1' es un comando para establecer la posición (fila 1, columna 1)
        end if;
      end if;
    end if;

    -- Actualiza las señales de salida en cada ciclo del reloj
    lcd_data_value := char_to_display;
    lcd_data <= lcd_data_value;

  end process;

end teclado_arch;
