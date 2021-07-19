########################################################################################################################
#                                                                                                                      #
#                        Main recipe to delete CyberArk Accounts Cookbook                                              #
#                                                                                                                      #
#   Language            : Chef/Ruby                                                                                    #
#   Date                : 01.03.2016                                                                                   #
#   Date Last Update    : 01.03.2016                                                                                   #
#   Version             : 0.4                                                                                          #
#   Author              : Arnaud THALAMOT                                                                              #
#                                                                                                                      #
########################################################################################################################

# Method to create a cyberark delete request from inputs
def create_cyberark_request(version, date, reference, hostname, ip, fqdn, platform, location, geographic_code, account, ssh_username, ssh_password, cpm_server, env)
  ibm_cyberark_cyberark_request 'create-request-files' do
    action [:delete, :submit]
    version version
    date date
    reference reference
    hostname hostname
    ip ip
    fqdn fqdn
    platform platform
    location location
    geographic_code geographic_code
    username account
    password account
    ssh_username ssh_username
    ssh_password ssh_password
    cpm_server cpm_server
    env env
  end
end

# Data file version, must be a valide number on the Community
version = '1'
# ICD request id Random.rand(10_000)
reference = 12
# Location of the account
location = 'PRIVATE'
# Geographic code of the account
geographic_code = 'FR-MRS'
# Ssh username used to connect to CPM Server
ssh_username = 'username'
# Ssh password used to connect to CPM Server
ssh_password = 'password'
# Hostname of the CPM server to push requests
cpm_server_name = 'hostname'
# Host FQDN
fqdn = node['hostname'] + '.client.com'

if platform_family?('windows')
  platform = 'WINDOWS-ICO-INT'
  date = powershell_out('get-date -Format \"yyyy/%M/%d HHHH:mmmm:ssss\"').stdout.chop

  # Deletion of the local user user1
  user 'user1' do
    action :remove
    comment 'FR/User'
    gid 'Users'
    password 'user1'
  end

  # Creation of the cyberark request for user user1
  create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user1', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

  # Deletion of the local user user2
  user 'user2' do
    action :remove
    comment 'FR/User'
    gid 'Users'
    password 'user2'
  end

  # Creation of the cyberark request for user user2
  create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user2', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

  # Delete user1, user2, ibm_admin from Administrators group
  group 'Administrators' do
    action :modify
    append true
    excluded_members %w(user1 user2)
  end
else
  platform = 'LINUX-ICO-INT'
  # Deletion of the user user1
  user 'user1' do
    action :remove
    comment 'FR/User'
    shell '/bin/sh'
    gid 'user1'
    password 'user1'
  end

  # Creation of the deletion cyberark request for user user1
  create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user1', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

  # Deletion of the user user2
  user 'user2' do
    action :remove
    comment 'FR/User'
    shell '/bin/sh'
    gid 'user2'
    password 'user2'
  end

  # Creation of the deletion cyberark request for user user2
  create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user2', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])
end