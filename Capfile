load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

namespace :deploy do
#   task :start, :roles => :app do
#     run "touch #{deploy_to}/current/tmp/restart.txt"
#   end
  
#   task :restart, :roles => :app do
#     run "touch #{deploy_to}/current/tmp/restart.txt"
#   end

  task :after_symlink, :roles => :app do
    run "mkdir -p #{deploy_to}/current/public/stylesheets ; fs sa #{deploy_to}/current/public/stylesheets webmaster write"
    run "cd #{deploy_to}/current ; rake niftycube:install"
    # run "rm -f ~/public_html;ln -s #{deploy_to}/current/public ~/public_html"
    # run "ln -s #{deploy_to}/shared/database.yml #{deploy_to}/current/config/database.yml"
  end
end