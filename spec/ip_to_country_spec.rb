require 'im_helpers'
require 'fileutils'
require 'active_support/time'


RSpec.describe ImHelpers::IpToCountry do
  let!(:default_dir){ ImHelpers::IpToCountry.default_dir }

  describe 'get IP to country data' do
    it "should download the file and process it into a DAT file" do
      ImHelpers::IpToCountry.get('216.58.204.142')

      expect(File).to exist("#{default_dir}/IpToCountry.csv")
      expect(File).to exist("#{default_dir}/packed-ip.dat")
    end
  end


  describe "no outdated CSV data file" do
    it "should not have a data file older than one month" do
      FileUtils.touch "#{default_dir}/IpToCountry.csv", :mtime => Time.now - 35.days
      expect(ImHelpers::IpToCountry.data_is_outdated?).to eq(true)

      ImHelpers::IpToCountry.search('102.129.65.255')
      expect(ImHelpers::IpToCountry.data_is_outdated?).to eq(false)
    end

  end
  describe 'search country by IP' do
    it "should return the right country for a given IP address" do
      expect(ImHelpers::IpToCountry.search('102.129.65.255')).to eq('FR')
      expect(ImHelpers::IpToCountry.search('101.198.199.255')).to eq('US')
      expect(ImHelpers::IpToCountry.search('2.57.99.255')).to eq('KZ')
      expect(ImHelpers::IpToCountry.search('14.137.37.255')).to eq('VU')
      expect(ImHelpers::IpToCountry.search('37.228.128.255')).to eq('SC')
    end

    it "should raise a RangeError when provided with an invalid IP address" do
      expect { ImHelpers::IpToCountry.search('1.1.266.2') }.to raise_error(RangeError)
    end
  end
end