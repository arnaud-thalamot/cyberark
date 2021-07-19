########################################################################################################################
#                                                                                                                      #
#                                Cyberark cookbook                                                                     #
#                                                                                                                      #
#   Language            : Chef/Ruby                                                                                    #
#   Date                : 01.03.2016                                                                                   #
#   Date Last Update    : 01.03.2016                                                                                   #
#   Version             : 0.4                                                                                          #
#   Author              : Arnaud THALAMOT                                                                              #
#                                                                                                                      #
########################################################################################################################

require 'chef/resource'

use_inline_resources

def whyrun_supported?
  true
end

action :add do
  converge_by("Create #{@new_resource}") do
    Chef::Log.debug("version = #{@new_resource.version}")
    Chef::Log.debug("date = #{@new_resource.date}")
    Chef::Log.debug("reference = #{@new_resource.reference}")
    Chef::Log.debug("hostname = #{@new_resource.hostname}")
    Chef::Log.debug("ip = #{@new_resource.ip}")
    Chef::Log.debug("fqdn = #{@new_resource.fqdn}")
    Chef::Log.debug("platform = #{@new_resource.platform}")
    Chef::Log.debug("location = #{@new_resource.location}")
    Chef::Log.debug("username = #{@new_resource.username}")
    Chef::Log.debug("password = #{@new_resource.password}")
    Chef::Log.debug("cpm_server = #{@new_resource.cpm_server}")
    Chef::Log.debug("env = #{@new_resource.env}")

    create_file('ADD', @new_resource)
  end
end

action :modify do
  converge_by("Create #{@new_resource}") do
    Chef::Log.debug("version = #{@new_resource.version}")
    Chef::Log.debug("date = #{@new_resource.date}")
    Chef::Log.debug("reference = #{@new_resource.reference}")
    Chef::Log.debug("hostname = #{@new_resource.hostname}")
    Chef::Log.debug("ip = #{@new_resource.ip}")
    Chef::Log.debug("fqdn = #{@new_resource.fqdn}")
    Chef::Log.debug("platform = #{@new_resource.platform}")
    Chef::Log.debug("location = #{@new_resource.location}")
    Chef::Log.debug("username = #{@new_resource.username}")
    Chef::Log.debug("password = #{@new_resource.password}")
    Chef::Log.debug("cpm_server = #{@new_resource.cpm_server}")
    Chef::Log.debug("env = #{@new_resource.env}")

    create_file('MOD', @new_resource)
  end
end

action :delete do
  converge_by("Create #{@new_resource}") do
    Chef::Log.debug("version = #{@new_resource.version}")
    Chef::Log.debug("date = #{@new_resource.date}")
    Chef::Log.debug("reference = #{@new_resource.reference}")
    Chef::Log.debug("hostname = #{@new_resource.hostname}")
    Chef::Log.debug("ip = #{@new_resource.ip}")
    Chef::Log.debug("fqdn = #{@new_resource.fqdn}")
    Chef::Log.debug("platform = #{@new_resource.platform}")
    Chef::Log.debug("location = #{@new_resource.location}")
    Chef::Log.debug("username = #{@new_resource.username}")
    Chef::Log.debug("password = #{@new_resource.password}")
    Chef::Log.debug("cpm_server = #{@new_resource.cpm_server}")
    Chef::Log.debug("env = #{@new_resource.env}")

    create_file('DEL', @new_resource)
  end
end

action :submit do
  converge_by("Create #{@new_resource}") do
    temporary_directory = if platform_family?('windows')
                            'C:/Windows/Temp/'
                          else
                            '/opt/IBM/'
                          end

    # Path the cmd.exe on the CPM server
    cmd_path = '/cygdrive/c/Windows/System32/cmd.exe'
    key = "#{temporary_directory}cyberark_key"

    # Copy ssh key
    cookbook_file key.to_s do
      source 'cyberark_key'
      mode '0600'
      action :create_if_missing
    end

    if platform_family?('windows')
      powershell_out('cp C:\chef\cache\cookbooks\cyberark\files\default\cyberark_key C:/Windows/Temp')

      powershell_script 'fix_keyfile_permission' do
        code <<-EOH
        cd 'C:/Program Files/OpenSSH-Win64/'
        Import-Module ./OpenSSHUtils.psd1 -Force 
        Repair-UserKeyPermission -FilePath 'C:\\Windows\\Temp\\cyberark_key' -Confirm:$false
        EOH
        only_if { ::File.exist?('C:/Windows/Temp/cyberark_key') }
      end

    end

    env = @new_resource.env
    ssh_username = @new_resource.ssh_username
    cpm_server = @new_resource.cpm_server
    username = @new_resource.username

    case env
    when 'dev'
      queue_name = 'D:\\\\CO2PV_TEST\\\\_INBOX_\\\\'
      controller = '@TEST'
    when 'int'
      queue_name = 'D:\\\\CO2PV_INTG\\\\_INBOX_\\\\'
      controller = '@INTG'
    when 'preprod'
      queue_name = 'D:\\\\CO2PV_PPRD\\\\_INBOX_\\\\'
      controller = '@PPRD'
    when 'prod'
      queue_name = 'D:\\\\CO2PV_PROD\\\\_INBOX_\\\\'
      controller = '@PROD'
    end

    if platform_family?('windows')
      ruby_block 'server-workflow-windows' do
        block do
          # Copy Data Files into home directory from Transfer PUSH User on Data Processing Queue server...
          Chef::Log.info('Copy Data Files into home directory from Transfer PUSH User on Data Processing Queue server...')
          powershell_out("&'C:/Program Files/OpenSSH-Win64/scp.exe' -o StrictHostKeyChecking=no -i #{key} #{temporary_directory}#{node['cyberark']['filename']}.tmp #{ssh_username}@#{cpm_server}:.")

          # Copy Data Files in Data Processing Queue folder...
          Chef::Log.info('Copy Data Files in Data Processing Queue folder...')
          copy_out = powershell_out("&'C:/Program Files/OpenSSH-Win64/ssh.exe' #{ssh_username}@#{cpm_server} -i #{key} -o StrictHostKeyChecking=no '#{cmd_path} /C COPY #{node['cyberark']['filename']}.tmp #{queue_name}'> #{node['cyberark']['ssh_output']} 2>&1")
          # Rename Data Files (in Queue)...
          Chef::Log.info('Rename Data Files (in Queue)...')
          powershell_out("&'C:/Program Files/OpenSSH-Win64/ssh.exe' #{ssh_username}@#{cpm_server} -i #{key} -o StrictHostKeyChecking=no '#{cmd_path} /C \"RENAME #{queue_name}#{node['cyberark']['filename']}.tmp *.NEW\"'>> #{node['cyberark']['ssh_output']} 2>&1")

          # Launch Data Processing...
          Chef::Log.info('Launch Data Processing...')
          powershell_out("&'C:/Program Files/OpenSSH-Win64/ssh.exe' #{ssh_username}@#{cpm_server} -i #{key} -o StrictHostKeyChecking=no 'cd #{controller};./controller.cmd \"#{node['cyberark']['filename']}.NEW\"'>> #{node['cyberark']['ssh_output']} 2>&1")

          # Launch Data Processing...
          Chef::Log.info('Launch Data Processing...')
          powershell_out("&'C:/Program Files/OpenSSH-Win64/ssh.exe' #{ssh_username}@#{cpm_server} -i #{key} -o StrictHostKeyChecking=no 'rm -f #{node['cyberark']['filename']}.tmp' >> #{node['cyberark']['ssh_output']} 2>&1")
        end
        action :create
      end
    else
      # Copy Data Files into home directory from Transfer PUSH User on Data Processing Queue server...
      execute 'copy to server' do
        command "scp -o StrictHostKeyChecking=no -i #{key} #{temporary_directory}#{node['cyberark']['filename']}.tmp #{ssh_username}@#{cpm_server}:."
        action :run
      end

      # Copy Data Files in Data Processing Queue folder...
      execute 'copy' do
        command "ssh #{ssh_username}@#{cpm_server} -i #{key} -o StrictHostKeyChecking=no '#{cmd_path} /C \"COPY #{node['cyberark']['filename']}.tmp #{queue_name}\"'> #{node['cyberark']['ssh_output']} 2>&1"
        action :run
      end

      # Rename Data Files (in Queue)...
      execute 'rename' do
        command "ssh #{ssh_username}@#{cpm_server} -i #{key} -o StrictHostKeyChecking=no '#{cmd_path} /C \"RENAME #{queue_name}#{node['cyberark']['filename']}.tmp *.NEW\"'>> #{node['cyberark']['ssh_output']} 2>&1"
        action :run
      end

      # Launch Data Processing...
      execute 'data_processing' do
        command "ssh #{ssh_username}@#{cpm_server} -i #{key} -o StrictHostKeyChecking=no 'cd #{controller};./controller.cmd \"#{node['cyberark']['filename']}.NEW\"'>> #{node['cyberark']['ssh_output']} 2>&1"
        action :run
        returns (0..255).to_a
      end

      # Cleaning directory
      execute 'cleaning' do
        command "ssh #{ssh_username}@#{cpm_server} -i #{key} -o StrictHostKeyChecking=no 'rm -f #{node['cyberark']['filename']}.tmp'>> #{node['cyberark']['ssh_output']} 2>&1"
        action :run
      end

      # remove the key
      Chef::Log.info("Removing cyberark-key from temp location.........")
      file key.to_s do
        action :delete
      end

	  # clean the unwanted request files
	  execute 'remove-unwanted files' do
        command "cd /opt/IBM/; rm *.tmp"
        action :run
      end
    end
    Chef::Log.info("User #{username} successfully added to Cyberark vault")
  end
end

# Method to create the corresponding request file of given type
def create_file(type, resource)
  Chef::Log.info("date : #{resource.date}")

  date = ''
  temporary_filename = ''

  if platform_family?('windows')
    temporary_filename = "C:/Windows/Temp/#{resource.reference}"

    # Formatted date for the request"
    ruby_block 'date-windows' do
      block do
        # Get date
        date = powershell_out('get-date -Format "yyyy/%M/%d HHHH:mmmm:ssss"').stdout.chop
      end
      action :create
    end

  else
    temporary_filename = "/tmp/#{resource.reference}"

    # Formatted date for the request"
    ruby_block 'date-linux' do
      block do
        # Get date
        date = shell_out('date +"%Y/%m/%d %T"').stdout.chop
      end
      action :create
    end
  end

  Chef::Log.debug("temporary_filename : #{temporary_filename}")

  template temporary_filename.to_s do
    source 'cyberark_request.erb'
    variables(
      version: resource.version,
      date: resource.date,
      type: type.to_s,
      reference: resource.reference,
      hostname: resource.hostname,
      ip: resource.ip,
      fqdn: resource.fqdn,
      platform: resource.platform,
      location: resource.location,
      geographic_code: resource.geographic_code,
      username: resource.username,
      password: resource.password
    )
  end

  ruby_block 'create-file' do
    block do
      if platform_family?('windows')
        hash = powershell_out("$(Get-FileHash #{temporary_filename} -Algorithm MD5).hash").stdout.chop
        date_short = powershell_out('get-date -Format "yyyyMMddHHmmss"').stdout.chop
      else
        hash = shell_out("md5sum #{temporary_filename} | cut -f1 -d ' '").stdout.chop
        date_short = shell_out('date +"%Y%m%d%H%M"').stdout.chop
      end

      filename = "#{date_short}_#{type}_#{resource.reference}_#{hash}"
      Chef::Log.debug("date_short : #{date_short}")
      Chef::Log.debug("filename : #{filename}")
      Chef::Log.debug("mv #{temporary_filename} /tmp/#{filename}.tmp")
      node.default['cyberark']['filename'] = filename.to_s

      if platform_family?('windows')
        powershell_out("mv #{temporary_filename} C:/Windows/Temp/#{filename}.tmp")
      else
        shell_out("mv #{temporary_filename} /opt/IBM/#{filename}.tmp")
      end
    end
    action :create
  end
end
