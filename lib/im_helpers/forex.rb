module ImHelpers
  require 'nokogiri'
  # quick FOREX from BCE, only support top 28 currencies
  class Forex
    # frais de conversion des devises de 4.5%
    BANK_FEES = 0.045

    @default_dir="/tmp"

    def self.default_dir
      @default_dir
    end

    def self.default_dir= v
      @default_dir=v
    end

    def self.filename(date=Date.today)
      if date < Date.today
        "#{self.default_dir}/eurofxref-hist.xml"
      else
        "#{self.default_dir}/eurofxref-daily.xml"
      end
    end

    def self.download(date=Date.today)
      if date < Date.today
        system("wget -q http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.xml -O #{self.filename(date)}")
      else
        system("wget -q http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml -O #{self.filename(date)}")
      end
    end

    def self.refresh_file?(fn, date)
      !File.exist?(fn) || (date > File.ctime(fn).to_date) || File.empty?(fn)
    end

    def self.parse(date=Date.today)
      fn=self.filename(date)
      @parsed||={}
      if self.refresh_file?(fn, date)
        retries = 0
        begin
          self.download(date)
          raise if self.refresh_file?(fn, date)
        rescue
          retry if (retries += 1) < 3
          raise "Could not download Forex file"
        ensure
          @parsed[fn]=nil
        end
      end
      @parsed[fn]||=Nokogiri::XML.parse(File.open(fn))
    end

    def self.rate(from_currency, to_currency, date=Date.today)
      if date < Date.new(1999, 1, 6)
        return nil
      end

      xml=self.parse(date)
      from_rate=nil
      to_rate=nil

      if from_currency=="EUR"
        from_rate=1.0
      end

      if to_currency=="EUR"
        to_rate=1.0
      end

      raise "Error parsing Forex file ; Download failed ?" unless xml.root

      root_node = xml.root.at("Cube")

      if root_node
        date_attr=date.strftime("%Y-%m-%d")
        time_node=root_node.at("Cube[@time='#{date_attr}']")
        while time_node.nil?
#          puts "no rate for #{date}, try #{date - 1.day}"
          date = date - 1.day
          if date < Date.new(1999, 1, 6)
            return nil
          end
          date_attr=date.strftime("%Y-%m-%d")
          time_node=root_node.at("Cube[@time='#{date_attr}']")
        end
        node=time_node.search("Cube[@currency='#{from_currency}']").first
        if node
          from_rate=node["rate"].to_f
        end
        node=time_node.search("Cube[@currency='#{to_currency}']").first
        if node
          to_rate=node["rate"].to_f
        end

        if to_rate and from_rate
          ((to_rate/from_rate)*10000.0).round/10000.0
        else
          nil
        end
      end
    end

    # On retient les frais de conversion des devises
    def self.rate_with_fees(from_currency, to_currency, date=Date.today)
      return 1.0 if from_currency == "EUR"
      rate = self.rate(from_currency, to_currency, date)
      (rate / (1 + BANK_FEES)).round(4) if rate
    end

  end
end
