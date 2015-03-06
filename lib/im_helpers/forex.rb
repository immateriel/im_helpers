module ImHelpers
  require 'nokogiri'
  # quick FOREX from BCE, only support top 28 currencies
  class Forex
    @default_dir="/tmp"
    def self.default_dir
      @default_dir
    end

    def self.default_dir=v
      @default_dir=v
    end

    def self.download
      system("wget http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml -O #{self.default_dir}/eurofxref-daily.xml")
    end

    def self.parse
      unless File.exists?("#{self.default_dir}/eurofxref-daily.xml")
        self.download
      end
      Nokogiri::XML.parse(File.open("#{self.default_dir}/eurofxref-daily.xml"))
    end

    def self.rate(from_currency,to_currency)
      xml=self.parse
      from_rate=nil
      to_rate=nil

      if from_currency=="EUR"
        from_rate=1.0
      end

      if to_currency=="EUR"
        to_rate=1.0
      end

      node=xml.root.at("Cube").at("Cube").search("Cube[@currency='#{from_currency}']").first
      if node
        from_rate=node["rate"].to_f
      end
      node=xml.root.at("Cube").at("Cube").search("Cube[@currency='#{to_currency}']").first
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
end