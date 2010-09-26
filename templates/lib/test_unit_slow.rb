# -*- coding: utf-8 -*-
module Test
  module Unit
    class Slow
      attr_reader :test_name, :message
 
      def initialize(test_name, time_taken)
        @test_name  = test_name
        @time_taken = time_taken
        @message    = "Too Slow"
      end
 
      def single_character_display
        "☻"
      end
 
      def short_display
        "#{@message}:\n#@test_name: #{"%.3f" % @time_taken}s"
      end
 
      def long_display
        short_display
      end
 
      def to_s
        long_display
      end
    end
  end
end
