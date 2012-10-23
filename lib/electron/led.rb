class Electron
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
end
