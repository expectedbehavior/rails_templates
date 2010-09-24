REPO_NAME = "<fill me in>"
HOST_URL  = "<fill me in>"
APP_NAME  = "<fill me in>"

require "bundler/capistrano"

default_run_options[:pty] = true
ssh_options[:paranoid] = false

set :keep_releases, 5
set :user,          "deploy"
set :use_sudo,      false
set :repository,    REPO_NAME
set :scm,           :git

task   :production do
  set  :application, APP_NAME
  set  :host_url,    REPO_NAME
  set  :deploy_to,   "/var/www/#{application}"
  set  :rails_env,   "production"
  role :app, host_url
  role :web, host_url
  role :db,  host_url, :primary => true
end

after "deploy", "deploy:cleanup"

deploy.task :start do
  # nothing, for mod_rails
end

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
