class Electron
  class Button < Base

    def setup
      @board.pin_mode(@pin, Electron::INPUT)
    end

    def current_state
      @board.digital_read(@pin)
    end

    def down?
      current_state == 1
    end

    def up?
      current_state == 0
    end

  end
end
