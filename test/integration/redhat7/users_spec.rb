describe user('user1') do
  it { should exist }
end

describe command("getent passwd user1 | cut -d ':' -f 5") do
  its('stdout') { should eq'FR/User' + "\n" }
end

describe user('user2') do
  it { should exist }
end

describe command("getent passwd user2 | cut -d ':' -f 5") do
  its('stdout') { should eq 'FR/User' + "\n" }
end

describe user('user3') do
  it { should exist }
end

describe command("getent passwd user3 | cut -d ':' -f 5") do
  its('stdout') { should eq 'FR/account' + "\n" }
end

requests = command('ls /tmp/*.tmp').stdout.chop.split("\n")
requests.each do |request|
  describe file(request) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_readable.by_user('root') }
    it { should be_writable.by_user('root') }
  end
end
