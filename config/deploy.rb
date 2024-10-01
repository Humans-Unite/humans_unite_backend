# config valid for current version and patch releases of Capistrano
lock '~> 3.19.1'
server '65.2.144.59', port: 22, roles: %i[web app db], primary: true

set :repo_url,        'git@github.com:Humans-Unite/humans_unite_backend.git'
set :application,     'humans_unite_backend'

set :rbenv_ruby,      '3.0.6'
set :default_env, { path: '~/.rbenv/shims:~/.rbenv/bin:$PATH' }

# If using Digital Ocean's Ruby on Rails Marketplace framework, your username is 'rails'
set :user,            'humans_unite_backend_deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :assets_roles, []

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_rsa.pub] }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_conf, "#{shared_path}/puma.rb"

append :rbenv_map_bins, 'puma', 'pumactl'

set :linked_files, %w[config/database.yml config/secrets.yml]

Rake::Task['deploy:assets:precompile'].clear

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  desc 'Restart Puma with systemd'
  task :restart do
    on roles(:app) do
      within release_path do
        execute :sudo, :systemctl, 'restart puma'
      end
    end
  end

  desc 'Start Puma with systemd'
  task :start do
    on roles(:app) do
      execute :sudo, :systemctl, 'start puma'
    end
  end

  desc 'Stop Puma with systemd'
  task :stop do
    on roles(:app) do
      execute :sudo, :systemctl, 'stop puma'
    end
  end

  before 'deploy:starting', 'puma:make_dirs'
end

namespace :deploy do
  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts 'WARNING: HEAD is not the same as origin/master'
        puts 'Run `git push` to sync changes.'
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc 'Create Database if it does not exist'
  task :db_create do
    on primary :db do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, 'rake db:create'
        end
      end
    end
  end

  before 'deploy:migrate', 'deploy:db_create'

  before :starting,     :check_revision
  after  :finishing,    :cleanup
  # after  :finishing,    'puma:restart'
end