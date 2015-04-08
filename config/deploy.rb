# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'deadofthrones'
set :repo_url, 'https://github.com/weslleyaraujo/deadofthrones.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deadofthrones'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

namespace :deploy do

  task :compile_assets do
    run_locally do
      within fetch(:local_app_path) do
        system("grunt build")
      end
    end
  end


  task :copy_assets do
    on roles(:web) do
      upload! "./public/assets/css/application.min.css", "#{release_path}/public/assets/css"
      upload! "./public/assets/javascripts/application.min.js", "#{release_path}/public/assets/javascripts/"
    end
  end


  after 'deploy:publishing', 'deploy:compile_assets'
  after 'deploy:publishing', 'deploy:copy_assets'
  # after 'deploy:publishing', 'nginx:restart', 'unicorn:restart'

end
