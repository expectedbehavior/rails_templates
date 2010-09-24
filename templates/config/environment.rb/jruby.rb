OSX_JAVA_HOME = "/System/Library/Frameworks/JavaVM.framework/Home"
UBUNTU_JAVA_HOME = "/usr/lib/jvm/java-1.5.0-sun"
GENTOO_JAVA_HOME = "/etc/java-config-2/current-system-vm"

if File.exists?(OSX_JAVA_HOME)
  ENV["JAVA_HOME"] = OSX_JAVA_HOME
elsif File.exists?(UBUNTU_JAVA_HOME)
  ENV["JAVA_HOME"] = UBUNTU_JAVA_HOME
elsif File.exists?(GENTOO_JAVA_HOME)
  ENV["JAVA_HOME"] = GENTOO_JAVA_HOME
end 

#make it so jruby doesn't try and use bundler
ENV["JRUBY_INVOCATION"] = "unset RUBYOPT; unset GEM_HOME; jruby"

# add jruby at the end of the path for culerity
ENV['PATH'] ||= ""
ENV['PATH'] = ENV['PATH'] + ":" + File.join(File.dirname(__FILE__), '..', 'vendor', 'jruby-1.4.0', 'bin')


