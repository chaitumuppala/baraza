# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'baraza'
set :repo_url, 'git@bitbucket.org:tw_osci/baraza.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/baraza'
set :rvm_type, :system
set :bundle_flags, '--deployment'
# Default value for :scm is :git
set :scm, :git
set :pty, true

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(".env.#{fetch(:stage)}")

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :run_task do
  desc 'Take backup of database before deploy and store it in s3'
  task :database_backup do
    on roles(:web) do
      execute "sh /home/deploy/db_backup/backup.sh"
      system("\\say backup complete !!!")
    end
  end


  desc 'Runs rake db:migrate, db:admin, restarts delayed_job'
  task :set_up_environment do
    on roles(:web) do
      within "#{current_path}" do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
          execute :rake, "db:migrate"
          system("\\say Database migrated!!!")
          execute :rake, "db:admin"
          system("\\say Admin rake task complete")
          execute :rake, "db:category"
          execute "cd #{File.join(current_path)} && RAILS_ENV=#{fetch(:rails_env)} bundle exec bin/delayed_job restart"
          system("\\say delayed job restarted!!!")
        end
      end
    end
  end

  desc 'Restart nginx'
  task :restart_nginx do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo service nginx restart"
      system("\\say Nginx restarted! Good Job!")
    end
  end

  desc 'Deployment is completed'
  task :say do
    system("\\say Capistrano Deployment Completed! Good Job!")
  end
end

after "deploy", "run_task:database_backup"
after "run_task:database_backup", "run_task:set_up_environment"
after "run_task:set_up_environment", "run_task:restart_nginx"
after "run_task:restart_nginx", 'run_task:say'
