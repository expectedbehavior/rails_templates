# -*- coding: utf-8 -*-
require "redgreen"
require "test_unit_slow"

module Test
  module Unit
    module UI
      module Console
        class TestRunner
          def test_started(name)
            @individual_test_start_time = Time.now
            output_single(name + ": ", VERBOSE)
          end
 
          def test_finished(name)
            elapsed_test_time = Time.now - @individual_test_start_time
            if elapsed_test_time > 1
              add_fault(Test::Unit::Slow.new(name, elapsed_test_time))
            else
              output_single(".", PROGRESS_ONLY) unless (@already_outputted)
              nl(VERBOSE)
            end
            @already_outputted = false
          end
          
          alias :tu_finished :finished
          def finished(elapsed_time)
            tu_finished(elapsed_time)
            if NetRecorder.recording?
              NetRecorder.cache!
            end            
          end
        end
      end
    end
  end
end

require File.join("#{RAILS_ROOT}/lib", 'patches/redgreen')
