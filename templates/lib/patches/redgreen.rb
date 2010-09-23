# -*- coding: utf-8 -*-
require "redgreen"
require "test_unit_slow"

module Color
  COLORS[:magenta] = 35
end

class Test::Unit::Slow
  alias :old_long_display :long_display
  def long_display
    time_index = /\d+\.\d+s$/ =~ old_long_display
    time = old_long_display[time_index..-1] if time_index
    new_display = old_long_display.sub(time, Color.magenta(time)) if time

    new_display.sub('Too Slow', Color.magenta('Too Slow'))
  end
end

class Test::Unit::UI::Console::RedGreenTestRunner < Test::Unit::UI::Console::TestRunner  
  def output_single(something, level=NORMAL)
    return unless (output?(level))
    something = case something
                when '.' then Color.green('.')
                when '☻' then Color.magenta("☻")
                when 'F' then Color.red("F")
                when 'E' then Color.yellow("E")
                else something
                end
    @io.write(something) 
    @io.flush
  end
end
