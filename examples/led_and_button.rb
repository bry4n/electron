$:.unshift "lib"
require 'electron'
class Electron
  class Base
    def initialize(options = {})
      @board  = options[:board] || (raise "Board is required")
      @pin    = options[:pin] || (raise "Pin is required")
      setup
    end

    def setup

    end
  end

  class LED < Base
   
    def setup
      @board.pin_mode(@pin, Electron::OUTPUT)
    end

    def on
      @board.digital_write(@pin, Electron::HIGH)
    end
    def off
      @board.digital_write(@pin, Electron::LOW)
    end

    def blink(delay = 0.2)
      loop do
        on
        sleep delay
        off
        sleep delay
      end
    end
  end

  class Button < Base

    def setup
      @board.pin_mode(@pin, Electron::INPUT)
    end

    def down?
      @board.digital_read(@pin) == 1
    end

    def up?
      @board.digital_read(@pin) == 0
    end

  end
end

LED     = 11
BUTTON  = 12

board = Electron.new
led = Electron::LED.new({:board => board, :pin => LED})
button = Electron::Button.new({:board => board, :pin => BUTTON})

board.loop do
  if button.down?
    led.on
  else
    led.off
  end
end
