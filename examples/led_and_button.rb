$:.unshift "lib"
require 'electron'

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
