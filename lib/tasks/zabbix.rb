require 'zabbix'

namespace :zabbix do
  desc 'Collect data for Zabbix'
  task :collect_once => :environment do
    Zabbix.logger.info "[Rake] executing #collect_once"
    Zabbix::Monitor.new.collect_data
  end

  desc 'Collect data for Zabbix every minute'
  task :collect_data => :environment do
    Zabbix.logger.info "[Rake] executing #collect_data, setting up Rufus"
    LightDaemon::Daemon.start(Zabbix::Worker.new, :children=> 2, :pid_file => 'tmp/zabbix-monitor.pid')
  end
end
