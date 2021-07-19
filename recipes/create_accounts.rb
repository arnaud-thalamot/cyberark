########################################################################################################################
#                                                                                                                      #
#                        Cyberark cookbook                                                                             #
#                                                                                                                      #
#   Language            : Chef/Ruby                                                                                    #
#   Date                : 01.03.2016                                                                                   #
#   Date Last Update    : 01.03.2016                                                                                   #
#   Version             : 0.4                                                                                          #
#   Author              : Arnaud THALAMOT                                                                              #
#                                                                                                                      #
########################################################################################################################

# Method to create a cyberark add request from inputs
def create_cyberark_request(version, date, reference, hostname, ip, fqdn, platform, location, geographic_code, account, ssh_username, ssh_password, cpm_server, env)
  ibm_cyberark_cyberark_request 'create-request-files' do
    action [:add, :submit]
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
cpm_server_name = 'server'
# Host FQDN
fqdn = node['hostname'] + '.client.com'

if node['cyberark']['status'] == 'failure'
  if platform_family?('windows')
    platform = 'WINDOWS-ICO-INT'
    date = powershell_out('get-date -Format \"yyyy/%M/%d HHHH:mmmm:ssss\"').stdout.chop

    # Creation of the local user
    user 'user1' do
      action :create
      password 'password'
    end

    batch 'set-user1-password-expires' do
      code <<-EOH
        WMIC USERACCOUNT WHERE Name='user1' SET PasswordExpires=TRUE
      EOH
    end

    execute 'set-gecos' do
      command 'NET USER user1 /COMMENT:"FR/CPM Reconcile User"'
      action :run
    end

    # Creation of the cyberark request for user
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user1', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user
    user 'user2' do
      action :create
      password 'password'
    end

    batch 'set-password-expires' do
      code <<-EOH
        WMIC USERACCOUNT WHERE Name='user2' SET PasswordExpires=TRUE
      EOH
    end

    execute 'set-gecos' do
      command 'NET USER user2 /COMMENT:"FR/Emergency Administrator User"'
      action :run
    end

    # Creation of the cyberark request for user
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user2', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user
    user 'user3' do
      action :create
      password 'password'
    end

    batch 'set-password-expires' do
      code <<-EOH
        WMIC USERACCOUNT WHERE Name='user3' SET PasswordExpires=TRUE
      EOH
    end

    execute 'set-gecos' do
      command 'NET USER user3 /COMMENT:"FR/Prod user4trialization User"'
      action :run
    end

    directory 'Creating C:/Users/user3/.ssh' do
      path 'C:/Users/user3/.ssh'
      owner 'user3'
      group 'user3'
      mode 0755
      action :create
      recursive true
      not_if { ::File.directory?('C:/Windows/Users/user3/.ssh') }
    end

    # Create authorized_keys
    cookbook_file 'C:/Users/user3/.ssh/authorized_keys' do
      source 'authorized_keys_account_ico'
      owner 'user3'
      group 'user3'
      mode '0755'
      action :create
    end

    # Creation of the cyberark request for user user3
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user3', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Create user4
      user 'user4' do
        password 'password'
        action :create
    end

    batch 'set-user4-expires' do
      code <<-EOH
        WMIC USERACCOUNT WHERE Name='user4' SET PasswordExpires=TRUE
      EOH
    end

    execute 'set-user4-gecos' do
      command 'NET USER user4 /COMMENT:"CZ/automation"'
      action :run
    end

    # Creation of the cyberark request for user user4
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user4', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Create user5
      user 'user5' do
        password 'password'
        action :create
    end

    batch 'set-user5-expires' do
      code <<-EOH
        WMIC USERACCOUNT WHERE Name='user5' SET PasswordExpires=TRUE
      EOH
    end

    execute 'set-user5-gecos' do
      command 'NET USER user5 /COMMENT:"CZ/automation"'
      action :run
    end

    # Creation of the cyberark request for user user5
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user5', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])


    # Creation of the local user user6
    user 'user6' do
      action :create
      password 'password'
    end

    batch 'set-imbsasc-expires' do
      code <<-EOH
        WMIC USERACCOUNT WHERE Name='user6' SET PasswordExpires=TRUE
      EOH
    end

    execute 'set-user6-gecos' do
      command 'NET USER user6 /COMMENT:"FR/CyberArk"'
      action :run
    end

    # Creation of the cyberark request for user user6
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user6', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user user6
    user 'user7' do
      action :create
      password 'password'
    end

    batch 'set-user7-expires' do
      code <<-EOH
        WMIC USERACCOUNT WHERE Name='user7' SET PasswordExpires=TRUE
      EOH
    end

    execute 'set-user7-gecos' do
      command 'NET USER user7 /COMMENT:"FR/CyberArk"'
      action :run
    end

    # Creation of the cyberark request for user user7
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user7', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    execute 'set-sshd-gecos' do
      command 'NET USER sshd /COMMENT:"FR/Prod SSH User"'
      action :run
    end

    # Add to Administrators group
    group 'Administrators' do
      action :modify
      append true
      members %w(user1 user2 user3 user4 user5 user6 user7)
    end
  end

  if platform_family?('rhel')
    platform = 'LINUX-ICO-INT'
    date = shell_out('date +"%Y/%m/%d %T"').stdout.chop

    execute 'set-root-gecos' do
    command 'usermod -c "FR/account"'
    action :run
    not_if { shell_out("cat /etc/passwd | grep -i 'FR/CPM'").stdout.chop != '' }
  end

    # Creation of the local user user1
    user 'user1' do
      action :create
      comment 'FR/Reconcile User'
      shell '/bin/sh'
      password 'password'
    end

    # Creation of the cyberark request for user user1
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user1', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user user2
    user 'user2' do
      action :create
      comment 'FR/User'
      shell '/bin/sh'
      password 'password'
    end

    # Creation of the cyberark request for user user2
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user2', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])
    
    # Creation of the local user user3
    user 'user3' do
      action :create
      comment 'FR/user4trialization'
      shell '/bin/sh'
      password 'password'
    end

    execute 'sudoers' do
        command "sed -i -e 's/USR_ROOT=/USR_ROOT=user3,/' /etc/sudoers"
    end

    directory 'Creating /home/user3/.ssh' do
      path '/home/user3/.ssh'
      owner 'user3'
      group 'user3'
      mode 0755
      action :create
      recursive true
      not_if { ::File.directory?('/home/user3/.ssh') }
    end

    # Create authorized_keys
    cookbook_file '/home/user3/.ssh/authorized_keys' do
      source 'authorized_keys_account_ico'
      owner 'user3'
      group 'user3'
      mode '0755'
      action :create
    end

    # Creation of the cyberark request for user user3
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user3', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user user6
    user 'user6' do
      action :create
      uid 6001
      comment 'FR/account'
      shell '/bin/ksh'
      password 'password'
    end

    remote_file '/home/user6/.profile' do
        source 'http://client.com/Appl_Linux/cyberark/user6/profile'
        owner 'user6'
        action :create_if_missing
    end

    remote_file '/home/user6/.kshrc' do
        source 'http://client.com/Appl_Linux/cyberark/user6/kshrc'
        owner 'user6'
        action :create_if_missing
    end

    # Creation of the cyberark request for user user6
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user6', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user user6
    user 'user7' do
      action :create
      uid 6000
      comment 'FR/Emergency'
      shell '/bin/sh'
      password 'password'
    end

    remote_file '/home/user7/.profile' do
        source 'http://client.com/Appl_Linux/cyberark/user7/profile'
        owner 'user7'
        action :create_if_missing
    end

    remote_file '/home/user7/.kshrc' do
        source 'http://client.com/Appl_Linux/cyberark/user7/kshrc'
        owner 'user7'
        action :create_if_missing
    end

    # Creation of the cyberark request for user user7
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user7', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

  end
  if platform_family?('aix')
    platform = 'LINUX-ICO-INT'
    date = shell_out('date +"%Y/%m/%d %T"').stdout.chop

    execute 'disable-ldap-for-users' do
      command "chsec -f /etc/security/user -s default -a registry=files -a SYSTEM=compat"
      action :run
    end

    # Creation of the local user user1
    user 'user1' do
      action :create
      comment 'FR/User'
      shell '/bin/sh'
      password 'password'
    end

    # Creation of the cyberark request for user user1
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user1', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user user2
    user 'user2' do
      action :create
      comment 'FR/User'
      shell '/bin/sh'
      password 'password'
    end

    # Creation of the cyberark request for user user2
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user2', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user user3
    user 'user3' do
      action :create
      comment 'FR/account'
      shell '/bin/sh'
      password 'password'
    end

    # Creation of the cyberark request for user user3
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user3', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])
    
    # Creation of the local user user3
    user 'user4' do
      action :create
      comment 'FR/User'
      shell '/bin/sh'
      password 'password'
    end

    execute 'sudoers' do
        command "sed -e 's/USR_ROOT=/USR_ROOT=user4,/' /etc/sudoers > tmp/sudoers; mv /tmp/sudoers /etc/sudoers"
    end

    directory 'Creating /home/user4/.ssh' do
      path '/home/user4/.ssh'
      owner 'user4'
      mode 0755
      action :create
      recursive true
      not_if { ::File.directory?('/home/user4/.ssh') }
    end

    # Create authorized_keys
    cookbook_file '/home/user4/.ssh/authorized_keys' do
      source 'authorized_keys_account_ico'
      owner 'user4'
      mode '0755'
      action :create
    end

    # Creation of the cyberark request for user user3
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user4', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user user6
    user 'user6' do
      action :create
      uid 6001
      comment 'FR/account'
      shell '/bin/ksh'
      password 'password'
    end

    directory 'Creating /home/user6' do
      path '/home/user6'
      owner 'user6'
      mode 0755
      action :create
      recursive true
      not_if { ::File.directory?('/home/user6') }
    end

    remote_file '/home/user6/.profile' do
        source 'http://client.com/Appl_Linux/cyberark/user6/profile'
        owner 'user6'
        action :create_if_missing
    end

    remote_file '/home/user6/.kshrc' do
        source 'http://client.com/Appl_Linux/cyberark/user6/kshrc'
        owner 'user6'
        action :create_if_missing
    end

    # Creation of the cyberark request for user user6
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user6', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    # Creation of the local user user6
    user 'user7' do
      action :create
      uid 6000
      comment 'FR/CPM'
      shell '/bin/sh'
      password 'password'
    end

    directory 'Creating /home/user7' do
      path '/home/user7'
      owner 'user7'
      mode 0755
      action :create
      recursive true
      not_if { ::File.directory?('/home/user7') }
    end

    remote_file '/home/user7/.profile' do
        source 'http://client.com/Appl_Linux/cyberark/user7/profile'
        owner 'user7'
        action :create_if_missing
    end

    remote_file '/home/user7/.kshrc' do
        source 'http://client.com/Appl_Linux/cyberark/user7/kshrc'
        owner 'user7'
        action :create_if_missing
    end

    # Creation of the cyberark request for user user7
    create_cyberark_request(version.to_s, date.to_s, reference.to_s, node['hostname'], node['ipaddress'], fqdn.to_s, platform.to_s, location.to_s, geographic_code.to_s, 'user7', ssh_username.to_s, ssh_password.to_s, cpm_server_name.to_s, node['cyberark']['env'])

    execute 'enable-ldap-for-users' do
      command 'chsec -f /etc/security/user -s default -a registry=LDAP -a SYSTEM="LDAP or compat"'
      action :run
    end
  end
  node.set['cyberark']['status'] = 'success'
end
