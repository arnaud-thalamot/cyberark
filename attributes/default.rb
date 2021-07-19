########################################################################################################################
#                                                                                                                      #
#                                            Attributes for Cyberark Cookbook                                          #
#                                                                                                                      #
#   Language            : Chef/Ruby                                                                                    #
#   Date                : 01.03.2016                                                                                   #
#   Date Last Update    : 01.03.2016                                                                                   #
#   Version             : 0.4                                                                                          #
#   Author              : Arnaud THALAMOT                                                                              #
#                                                                                                                      #
########################################################################################################################

# CPM server queue name
node.set['cyberark']['env'] = 'dev'
# Cyberark execution status
default['cyberark']['status'] = 'failure'
if platform_family?('windows')
  # cybeark ssh cmd output file
  default['cyberark']['ssh_output'] = 'C:\\temp\\Q144.txt'
else
  # cybeark ssh cmd output file
  default['cyberark']['ssh_output'] = '/var/log/Q144.txt'
end