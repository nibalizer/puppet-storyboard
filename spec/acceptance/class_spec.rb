require 'spec_helper_acceptance'

describe 'nova class' do

  context 'default parameters' do
    hosts.each do |host|
      if fact('osfamily') == 'RedHat'
        if fact('architecture') == 'amd64'
          on host, "wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm; rpm -ivh epel-release-6-8.noarch.rpm"
        else
          on host, "wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm; rpm -ivh epel-release-6-8.noarch.rpm"
        end
      end
    end

    it 'should work with no errors' do
      pp= <<-EOS
      class { 'storyboard':
          mysql_user_password    => 'changeme',
          rabbitmq_user_password => 'changemetoo'
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

  end
end
