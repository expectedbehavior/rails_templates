#!/usr/bin/ruby
require 'fileutils'

template_dir = File.dirname(File.expand_path(__FILE__))
project_dir = File.expand_path(ARGV.first)

Dir.mkdir(project_dir)

FileUtils.copy(File.join(template_dir, "templates", "Gemfile"), File.join(project_dir, "Gemfile"))

Dir.chdir(project_dir)

system "bundle install --binstubs --path vendor/bundle/"
system "bundle package"

system "./bin/rails -d mysql -m \"#{File.join(template_dir, 'base.rb')}\" ./"
