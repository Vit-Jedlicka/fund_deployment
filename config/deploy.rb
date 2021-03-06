# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'catarse'
set :repo_url, 'https://github.com/liberland/catarse.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/app'

set :rvm_ruby_version, '2.2.2'

#set :branch, "4811862f3be6b2cbf01113dd7c20baa70bcf7c23"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/initializers/sendgrid.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

after 'deploy:finished', 'deploy:restart'

namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute "touch #{current_path}/tmp/restart.txt"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
