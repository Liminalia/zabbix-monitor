require 'spec_helper'

describe Zabbix::Reader do

  before :each do
    @filename = 'tmp/zabbix-stats.yml'
    # File.open(@filename, 'w') { |file| file.write({'statistics' => {'test' => 'OK'}}.to_yaml) } unless File.exists?(@filename)
  end

  describe 'initialize' do
    it 'raises an error when the file can\'t be found' do
      expect(File).to receive(:exists?).with(@filename).and_return(false)
      expect{ Zabbix::Reader.new }.to raise_error(Zabbix::FileNotFoundError, 'Monitoring file not found')
    end

    it 'reads the monitoring file from tmp' do
      expect(File).to receive(:exists?).with(@filename).and_return(true)
      expect(YAML).to receive(:load_file).with(@filename)
      Zabbix::Reader.new
    end
  end

  describe 'get_value' do
    before :each do
      expect(File).to receive(:exists?).and_return true
      expect(YAML).to receive(:load_file).and_return({'statistics' => {'test' => 'OK'}})
    end
    let(:reader) { Zabbix::Reader.new }

    it 'returns the requested value' do
      expect(reader.get_value 'test').to eq('OK')
    end

    it 'returns nil when the key can\'t be found' do
      expect(reader.get_value 'missing').to be_nil
    end
  end

end
