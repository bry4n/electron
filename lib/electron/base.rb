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

end
