# The default recipe is implied if only the cookbook name is provided.
# Effectively `include_recipe "git_cookbook::default"`
include_recipe "git_cookbook"

# Install the above 'daemon_pkg'
package 'git-daemon-run'

# Create the data directory
directory 'opt/git'

# Setup the systemd unit (service) with the above `daemon-bin`, enable, and start it
systemd_unit 'git-daemon.service' do
  content <<-EOU.gsub(/^\s+/, '')
    [Unit]
    Description=Git Repositories Server Daemon
    Documentation=man:git-daemon(1)

    [Service]
    ExecStart=/usr/bin/git daemon \
    --reuseaddr \
    --base-path=/opt/git/ \
    /opt/git

    [Install]
    WantedBy=getty.target
    DefaultInstance=tty1
    EOU

  action [ :create, :enable, :start ]
end
