# config valid only for Capistrano 3.1
lock '3.1.0'


set :application, 'dealers_app'
set :rails_env, "production"

# setup repo details
set :scm, :git
set :repo_url, 'git@github.com:idoguterman/dealers_app.git'
set :deploy_to, '/var/www/dealers_app'
set :deploy_via, :copy

# setup rvm.
set :rbenv_type, :user
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# how many old releases do we want to keep
set :keep_releases, 5
set :bundle_flags,    ""
# files we want symlinking to specific entries in shared.
set :linked_files, %w{config/database.yml .rbenv-vars}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []
set :user , 'deploy'
set :ssh_options, {
  forward_agent: true,
  keys: [File.join(ENV["HOME"], ".ssh", "id_rsa")],
  verbose: :debug,
  user: fetch(:user)
}

#default_run_options[:pty] = true
server 'dist-dev-zh6054br.cloudapp.net', user: 'deploy', roles: %w{web app db}, primary: true

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :finishing, "deploy:cleanup"

end

#after "deploy", "deploy:symlink_config_files"
after "deploy", "deploy:restart"
after "deploy", "deploy:cleanup"

