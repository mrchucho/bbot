require "mongrel_cluster/recipes"

set :application, "bbot"
set :application_short_name, "bbot" # used for config file names, etc.
set :site_name, "mrchucho.net" # FQDN - www
set :deploy_to, "/var/www/vhosts/#{application}"

set :repository, "file:///var/www/vhosts/svn/bbot/trunk"
set :local_repository, "http://svn.mrchucho.net/bbot/trunk"
set :deploy_via, :export
set :scm_username, "mrchucho"
set :scm_prefer_prompt, true

# -------------- STAGE --------------------------
set :rails_env, "production"
set :user, "mrchucho"
set :group, "rails"

role :app, "www.mrchucho.net"
role :web, "www.mrchucho.net"
role :db,  "www.mrchucho.net", :primary => true
# -------------- STAGE --------------------------

# Miscellaneous Configuration
default_run_options[:pty] = true # required for sudo w/ password

# Mongrel Configuration
set :mongrel_servers, 3
set :mongrel_port, "4000"
set :mongrel_user, "mongrel"
set :mongrel_group, "rails"
set :mongrel_config, "mongrel_cluster.yml"
set :mongrel_pid_dir, "/var/run/mongrel_cluster"

# Custom Tasks
namespace :deploy do
  desc "Ensure Rails log has proper persmissions."
  task :verify_log_permissions do
    run "chgrp -R #{group} #{current_path}/"
    sudo "chmod 0666 #{current_path}/log/#{rails_env}.log"
  end

  desc "Update my symlinks."
  task :update_my_symlinks do
    run "ln -nfs #{shared_path}/content #{current_path}/public/content"
    run "ln -nfs #{shared_path}/content #{current_path}/public/wp-content"
    run "ln -nfs #{shared_path}/downloads #{current_path}/public/downloads"
    run "ln -nfs #{shared_path}/system/database.yml #{current_path}/config/database.yml"
  end

  namespace :setup_tasks do
    #
    # before cap deploy:setup
    #
    desc "Required pre-setup configuration tasks."
    task :required_pre_setup do
      sudo "mkdir -p #{deploy_to}"
      sudo "chgrp #{group} #{deploy_to}"
      sudo "chmod g+w #{deploy_to}"
      sudo "mkdir -p #{mongrel_pid_dir}"
      sudo "chgrp #{group} #{mongrel_pid_dir}"
      sudo "chmod g+w #{mongrel_pid_dir}"
    end

    #
    # sub-item of required_post_setup
    #
    desc "Create and setup Mongrel Configuration."
    task :mongrel_configuration_setup do
      mongrel_cluster_yml = <<-EOF
--- 
cwd: #{deploy_to}/current
environment: #{rails_env}
host: 127.0.0.1
pid_file: #{mongrel_pid_dir}/mongrel.pid
log_file: log/mongrel.log
docroot: public
port: #{mongrel_port}
user: #{mongrel_user}
group: #{mongrel_group}
servers: #{mongrel_servers}

    EOF
      put mongrel_cluster_yml, "#{shared_path}/config/#{mongrel_config}"
      sudo "ln -nfs #{shared_path}/config/#{mongrel_config} /etc/mongrel_cluster/#{application}.yml"
    end

    #
    # sub-item of required_post_setup
    #
    desc "Create and setup Apache Configuration."
    task :apache_configuration_setup do
      nodes = []
      mongrel_servers.times {|n| nodes << "BalancerMember http://127.0.0.1:#{mongrel_port.to_i+n}"}
      mongrel_cluster_conf = <<-EOF
<Proxy balancer://mongrel_cluster>
      #{nodes.join("\n")}
</Proxy>
EOF

      httpd_common = <<-EOF
# This file is included WITHIN a VirtualHost configuration.
# References: http://mongrel.rubyforge.org/docs/apache.html

ServerName #{site_name}
ServerAlias www.#{site_name}
ServerAdmin admin@#{site_name}
DocumentRoot "#{current_path}/public"

<Directory "#{current_path}/public">
        Options FollowSymLinks
        AllowOverride None
        Order allow,deny
        Allow from all 
</Directory>

RewriteEngine On
RewriteRule ^/$ /index.html [QSA]

RewriteCond %{REQUEST_METHOD} ^GET$
RewriteRule ^([^.]+)$ $1.html [QSA]

RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
RewriteRule ^/(.*)$ balancer://mongrel_cluster%{REQUEST_URI} [P,QSA,L]
EOF

      httpd_conf = <<-EOF
<VirtualHost *:80>
        Include /etc/httpd/conf.d/#{application_short_name}.common

        ErrorLog logs/#{application_short_name}_errors_log
        CustomLog logs/#{application_short_name}_log combined
</VirtualHost>

EOF
      put mongrel_cluster_conf, "#{shared_path}/system/#{application_short_name}.cluster.conf"
      put httpd_common, "#{shared_path}/system/#{application_short_name}.common"
      put httpd_conf, "#{shared_path}/system/#{application_short_name}.conf"

      sudo "ln -nfs #{shared_path}/system/#{application_short_name}.cluster.conf /etc/httpd/conf.d/#{application_short_name}.cluster.conf"
      sudo "ln -nfs #{shared_path}/system/#{application_short_name}.common /etc/httpd/conf.d/#{application_short_name}.common"
      sudo "ln -nfs #{shared_path}/system/#{application_short_name}.conf /etc/httpd/conf.d/#{application_short_name}.conf"
    end
    
    #
    # after cap deploy:setup
    #
    desc "Setup Mongrel, Apache and the Application."
    task :required_post_setup do
      run "umask 02 && mkdir -p #{shared_path}/config"
      sudo "mkdir -p /etc/mongrel_cluster"
      mongrel_configuration_setup
      apache_configuration_setup
    end
  end
end

# Callbacks
before "deploy:setup", "deploy:setup_tasks:required_pre_setup"
after  "deploy:setup", "deploy:setup_tasks:required_post_setup"
after  "deploy:update","deploy:update_my_symlinks"
before "deploy:start", "deploy:verify_log_permissions"
before "deploy:restart", "deploy:verify_log_permissions"
