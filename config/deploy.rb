set :application, "clubcar"
set :repository,  "https://www.slackers.net/svn/erik/trunk/#{application}"

set :scm_username, "cloudshield"
# Until I get it installed, then we figure out how to get it to prompt
set :scm_password, "cp0sRockz"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/afs/slackers.net/projects/#{application}/release"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

#role :app, "your app-server here"
#role :web, "your web-server here"
#role :db,  "your db-server here", :primary => true

#server "clubcar.app.cloudshield.com", :app, :web, :db, :primary => true
server "10.23.41.5", :app, :web, :db, :primary => true

# For now, we'll fix it later
set :user, "erik"
set :use_sudo, false
