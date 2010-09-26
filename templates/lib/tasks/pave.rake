desc "Initial setup of app on local system"
task :pave do
  system "bundle install --binstubs --path vendor/bundle/"
  system "web_server_setup ."
  system "script/db_setup -c"
  system "rake get_and_import_production_data"
  system "rake db:migrate && rake db:test:prepare"
end

desc "Nuke And Repave Sir"
task :repave do
  system "script/db_setup"
  system "rake get_and_import_production_data"
  system "rake db:migrate && rake db:test:prepare"
end

namespace :test do
  desc "Run all tests"
  task :all do
    system "rake test"
    system "cucumber -t @shouldwork --format progress features"
  end
end
