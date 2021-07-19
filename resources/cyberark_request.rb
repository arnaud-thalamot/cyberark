########################################################################################################################
#                                                                                                                      #
#                             Cyberark request resource                                                                #
#                                                                                                                      #
#   Language            : Chef/Ruby                                                                                    #
#   Date                : 01.03.2016                                                                                   #
#   Date Last Update    : 01.03.2016                                                                                   #
#   Version             : 0.1                                                                                          #
#   Author              : Arnaud THALAMOT                                                                              #
#                                                                                                                      #
########################################################################################################################

actions :add, :modify, :delete, :submit

property :version, String, required: true
property :date, String, required: true
property :reference, String, required: true
property :hostname, String, required: true
property :ip, String, required: true
property :fqdn, String, required: true
property :platform, String, required: true
property :location, String, required: true
property :geographic_code, String, required: true
property :username, String, required: true
property :password, String, required: true
property :ssh_username, String, required: true
property :ssh_password, String, required: true
property :cpm_server, String, required: true
property :env, String, required: true

def initialize(*args)
  super
  @action = :add
end
