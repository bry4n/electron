require 'serialport'
require 'thread'

class Electron#ics

  HIGH    = 1
  LOW     = 0
  OUTPUT  = 0
  INPUT   = 1

  attr_reader :port
  attr_accessor :debug
  def initialize(port = nil, options = {})
    @port   = port || _scan_for_port
    Thread.current[:serial] = SerialPort.new @port, (options[:baud_rate] || 115200)
  end

  def helpers(&block)
    self.instance_eval(&block)
  end
  
  def loop(&block)
    while(true) do
      block.call
      sleep 0.1 
    end
  end

  def read
    Thread.current[:serial].gets
  end

  def close
    Thread.current[:serial].close
    Thread.current[:serial] = nil
  end

  def pin_mode(pin, value)
    _write("pm", pin, value)
  end

  def analog_write(pin, value)
    _write("aw", pin, value)
  end

  def digital_write(pin, value)
    _write("dw", pin, value)
  end

  def digital_read(pin)
    _write("dr", pin)
    read.to_i
  end

  def analog_write(pin, value)
    _write("ar", pin, value)
  end

  def analog_read(pin)
    _write("ar", pin)
    read.to_i
  end

  private
  def _write(*args)
    Thread.current[:serial].write "!#{args.join(" ")}."
  end

  def _scan_for_port
    serial_port = `ls /dev | grep usb`.chomp.split(/\n/).select {|port| port =~ /^cu\./}.first
    "/dev/#{serial_port}"
  end
end

