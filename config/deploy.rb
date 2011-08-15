set :application, "email_spider"
set :repository,  "git@github.com:midwire/#{application}.git"
set :thehost, "rummagekc.com"
set :runner, 'deploy'
set :admin_runner, 'deploy' # user that makes the directories during deploy:setup
set :user, "deploy"
set :remote, "deploy"
set :scm, :git
set :deploy_to, "/var/www/spider.midwiretech.com"
set :deploy_via, :remote_cache
set :keep_releases, 3
set :use_sudo, true
# set :deploy_via, :export
set :ssh_options, { 
  :keys => ["#{ENV['HOME']}/.ssh/id_dsa"], 
  :host_key => 'ssh-dss',
  :paranoid => false
}

role :web, thehost
role :app, thehost
role :db,  thehost, :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


###
# My Own Module
###
module MyModule
  def self.included(base)
    base.send(:alias_method, :run_without_error_handling, :run)
    base.send(:alias_method, :run, :run_with_error_handling)
  end

  def run_with_error_handling(*args, &block)
    begin
      run_without_error_handling(*args, &block)
    rescue Capistrano::CommandError => e
      p "#{e}"
    end
  end
end

Capistrano::Configuration.send(:include, MyModule)

before "deploy:migrate", "custom_symlinks"
after "deploy", "custom_symlinks"
after "deploy", "deploy:cleanup"

###
# Custom Tasks
###

desc "Custom Symlinks"
task :custom_symlinks do
  sudo "ln -nsf #{shared_path}/system/config/database.yml #{current_path}/config/database.yml"
end

