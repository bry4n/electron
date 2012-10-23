require 'serialport'
require 'thread'

class Electron#ics

  HIGH    = 1
  LOW     = 0
  OUTPUT  = 0
  INPUT   = 1

  attr_reader :port
  attr_accessor :debug
  def initialize(options = {})
    @debug      = options[:debug] || false
    @port       = options[:port] || _scan_for_port
    @baud_rate  = options[:baud_rate] || 115200
    @data_bits  = options[:data_bits] || 8
    @stop_bits  = options[:stop_bits] || 1
    @parity     = options[:party]     || SerialPort::NONE
    connect
  end

  def connect
    puts "connecting to #{@port}" if debug
    @board = SerialPort.new @port, @baud_rate, @data_bits, @stop_bits, @parity
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
    @board.gets
  end

  def close
    @board.close
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
    puts "#{@port}: !#{args.join(" ")}." if debug
    begin
      @board.write "!#{args.join(" ")}."
    rescue Errno::ENXIO => e
      sleep 1
      connect
      @board.write "!#{args.join(" ")}."
    end
  end

  def _scan_for_port
    serial_port = `ls /dev | grep usb`.chomp.split(/\n/).select {|port| port =~ /^cu\./}.first
    "/dev/#{serial_port}"
  end
end

require 'electron/base'
require 'electron/led'
require 'electron/button'
