module ActiveSupport
  module Testing
    module Declarative

      alias :tu_test_original :test
      
      # test "verify something" do
      #   ...
      # end
      def test(name, tags = nil, &block)
        if tag_option_specified?
          tags_list = parse_cli_tags_list
          raise "missing argument: -t [@tag1 [@tag2 ...]]" if tags_list.blank?
          return if(tags.blank? || intersection(tags_list, tags).blank?)
        end

        if ignore_tag_option_specified?
          tags_list = parse_cli_ignore_tags_list
          raise "missing argument: -i [@tag1 [@tag2 ...]]" if tags_list.blank?
          return unless intersection(tags_list, tags).blank?
        end

        tu_test_original(name, &block)
      end
      
      private

      def intersection(tags1, tags2)
        cleaned_tags1 = tags1.map{|x| clean_tag x }
        cleaned_tags2 = tags2.map{|x| clean_tag x }
        cleaned_tags1 & cleaned_tags2
      end

      def parse_cli_tags_list
        get_tags_list(determine_cli_tag_switch)
      end

      def parse_cli_ignore_tags_list
        get_tags_list(determine_cli_ignore_tag_switch)
      end

      def tag_option_specified?
        option_in_args? ['--tags', '-t']
      end

      def ignore_tag_option_specified?
        option_in_args? ['--ignore-tags', '-i']
      end

      private #helpers

      def option_in_args?(arg_arr)
        arg_arr.any?{ |x| ARGV.include?(x) }
      end
      
      def clean_tag(tag)
        tag.to_s.gsub(/\s/, "_").gsub(/\W/, "").downcase.gsub(/^[:@]/,"")
      end

      def determine_cli_tag_switch
        ARGV.include?('--tags') ? "--tags" : "-t" if tag_option_specified?
      end

      def determine_cli_ignore_tag_switch
        ARGV.include?('--ignore-tags') ? "--ignore-tags" : "-i" if ignore_tag_option_specified?
      end
      
      def get_tags_list(option_switch_used)
        unless option_switch_used.blank?
          start_index       = ARGV.find_index(option_switch_used) + 1
          next_option_index = ARGV[start_index..-1].find_index{|x| x =~ /^-/} + start_index rescue -1
          ARGV[start_index..next_option_index]
        else
          []
        end
      end
    end
  end
end
