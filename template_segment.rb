require 'highline/import'

class TemplateSegment
  extend Forwardable
  
  def_delegators :runner, :run, :git, :plugin, :environment, :route, :generate
  
  attr_accessor :runner
  
  def initialize(template_runner)
    self.runner = template_runner
  end
  
  def required?
    false
  end
  
  def bail_if_skipped?
    false
  end
  
  def run_segment
    raise "Must define 'run_segment' method in your segment"
  end
  
  def question
    raise "Must define 'question' method in your segment if the segment is not required"
  end
  
  def default
    'y'
  end
  
  def templates_path
    @@templates_path
  end
  
  def app_name
    File.basename(FileUtils.pwd)
  end
  
  def copy_file(path, dest_path = nil)
    dest_path ||= path
    self.runner.file dest_path, File.read(File.join(self.templates_path, path))
  end
  
  def gsub_after(regexp, path)
    File.dirname(path)
    self.runner.send(:gsub_file, File.dirname(path), regexp, "\\1\n#{File.read(File.join(self.templates_path, path))}")
  end
  
  def gsub_before(regexp, path)
    File.dirname(path)
    self.runner.send(:gsub_file, File.dirname(path), regexp, "#{File.read(File.join(self.templates_path, path))}\n\\1")
  end
  
  #can't just delegate this, it is a protected method
  def gsub_file(*args, &block)
    self.runner.send(:gsub_file, *args, &block)
  end
  
  #can't just delegate this, it is a protected method
  def append_file(*args, &block)
    self.runner.send(:append_file, *args, &block)
  end
  
  def self.templates_path=(value)
    @@templates_path = value
  end
  
  def self.announce(text, lines = :both)
    puts ""
    puts "===================================" unless lines == :bottom
    puts "=== #{text}"
    puts "===================================" unless lines == :top
    puts ""
  end
  
  def self.agree_question( yes_or_no_question, default = 'n' )
    HighLine.ask(yes_or_no_question, lambda { |yn| yn.downcase[0] == ?y}) do |q|
      q.validate                 = /\Ay(?:es)?|no?\Z/i
      q.responses[:not_valid]    = 'Please enter "yes" or "no".'
      q.responses[:ask_on_error] = :question
      q.default                  = default
    end
  end

  def self.run_segments(path, runner)
    Dir.glob(File.join(path, "*")).each do |segment|
      if File.directory?(segment)
        TemplateSegment.run_segments(segment, runner)
        next
      end
      
      next unless segment =~ /\.rb$/
      
      current = Object.constants
      require segment
      (Object.constants - current).each do |klass_name|
        klass = Object.const_get(klass_name)
        next unless klass.class == Class && klass.superclass == TemplateSegment
        
        segment_runner = klass.new(runner)
        
        TemplateSegment.announce(segment_runner.starting_message, :top)
        
        if ! segment_runner.required? && ! agree_question(segment_runner.question, segment_runner.default)
          TemplateSegment.announce("Skipping....", :bottom)
          segment_runner.bail_if_skipped? ? return : next
        end
        
        segment_runner.run_segment
        runner.git :add => '.'
        runner.git :commit => "-q -m '#{segment_runner.commit_message}'"
        TemplateSegment.announce(segment_runner.ending_message, :bottom)
        
      end
    end
  end
  
end
