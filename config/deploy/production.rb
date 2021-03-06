set :user, "deployer"
set :branch, "master"
set :application, "countdown2014"
set :deploy_to, "/home/#{user}/apps/#{application}"

set :rails_env, "production"

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "restarting resque workers"
    task :restart_workers, roles: :db do
      run_remote_rake "resque:restart_workers"
    end 
    desc "restarting nginx"
    task command, roles: :app, except: {no_release: true} do
      sudo "service nginx restart" 
    end 
  end 

  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    put File.read("config/facebook.example.yml"), "#{shared_path}/config/facebook.yml"
    puts "Now edit the config files in #{shared_path}."
  end 
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/facebook.yml #{release_path}/config/facebook.yml"
  end 
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end 
  end 
  before "deploy", "deploy:check_revision"
end
