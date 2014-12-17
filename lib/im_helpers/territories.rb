module ImHelpers
module Territories
  def self.included(klass)
    klass.instance_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end

  def self.world_ISO_3166_1
    ["AF", "ZA", "AX", "AL", "DZ", "DE", "AD", "AO", "AI", "AQ", "AG", "SA", "AR", "AM", "AW", "AU", "AT", "AZ",
     "BS", "BH", "BD", "BB", "BY", "BE", "BZ", "BJ", "BM", "BT", "BO", "BQ", "BA", "BW", "BV", "BR", "BN", "BG",
     "BF", "BI", "KY", "KH", "CM", "CA", "CV", "CF", "CL", "CN", "CX", "CY", "CC", "CO", "KM", "CG", "CD", "CK",
     "KR", "KP", "CR", "CI", "HR", "CU", "CW", "DK", "DJ", "DO", "DM", "EG", "SV", "AE", "EC", "ER", "ES", "EE",
     "US", "ET", "FK", "FO", "FJ", "FI", "FR", "GA", "GM", "GE", "GS", "GH", "GI", "GR", "GD", "GL", "GP", "GU",
     "GT", "GG", "GN", "GW", "GQ", "GY", "GF", "HT", "HM", "HN", "HK", "HU", "IM", "UM", "VG", "VI", "IN", "ID",
     "IR", "IQ", "IE", "IS", "IL", "IT", "JM", "JP", "JE", "JO", "KZ", "KE", "KG", "KI", "KW", "LA", "LS", "LV",
     "LB", "LR", "LY", "LI", "LT", "LU", "MO", "MK", "MG", "MY", "MW", "MV", "ML", "MT", "MP", "MA", "MH", "MQ",
     "MU", "MR", "YT", "MX", "FM", "MD", "MC", "MN", "ME", "MS", "MZ", "MM", "NA", "NR", "NP", "NI", "NE", "NG",
     "NU", "NF", "NO", "NC", "NZ", "IO", "OM", "UG", "UZ", "PK", "PW", "PS", "PA", "PG", "PY", "NL", "PE", "PH",
     "PN", "PL", "PF", "PR", "PT", "QA", "RE", "RO", "GB", "RU", "RW", "EH", "BL", "SH", "LC", "KN", "SM", "MF",
     "SX", "PM", "VA", "VC", "SB", "WS", "AS", "ST", "SN", "RS", "SC", "SL", "SG", "SK", "SI", "SO", "SD", "SS",
     "LK", "SE", "CH", "SR", "SJ", "SZ", "SY", "TJ", "TW", "TZ", "TD", "CZ", "TF", "TH", "TL", "TG", "TK", "TO",
     "TT", "TN", "TM", "TC", "TR", "TV", "UA", "UY", "VU", "VE", "VN", "WF", "YE", "ZM", "ZW"]
  end

  def self.world
    ["AD", "AE", "AF", "AG", "AL", "AM", "AO", "AR", "AT", "AU", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH",
     "BI", "BJ", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BW", "BY", "BZ", "CA", "CD", "CF", "CG", "CH", "CI",
     "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG",
     "EH", "ER", "ES", "ET", "FI", "FJ", "FM", "FR", "GA", "GB", "GD", "GE", "GH", "GL", "GM", "GN", "GQ", "GR",
     "GT", "GW", "GY", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IN", "IQ", "IR", "IS", "IT", "JM", "JO", "JP",
     "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS",
     "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MR", "MT", "MU",
     "MV", "MW", "MX", "MY", "MZ", "NA", "NE", "NG", "NI", "NL", "NO", "NP", "NR", "NZ", "OM", "PA", "PE", "PG",
     "PH", "PK", "PL", "PS", "PT", "PW", "PY", "QA", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG",
     "SH", "SI", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SY", "SZ", "TD", "TF", "TG", "TH", "TJ",
     "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VC", "VE", "VN",
     "VU", "WS", "YE", "ZA", "ZM", "ZW"]
  end

  def self.eurozone
    ["AT", "BE", "CY", "EE", "FI", "FR", "DE", "ES", "GR", "IE", "IT", "LU", "MT", "NL", "PT", "SI", "SK",
     "AD", "MC", "SM", "VA", "ME"]
  end

  def self.european_union
    ["AT", "BE", "BG", "HR", "CY", "CZ", "DK", "EE", "FI", "FR", "DE", "GR", "HU", "IE", "IT", "LV", "LT", "LU", "MT", "NL", "PL", "PT", "RO", "SK", "SI", "ES", "SE", "GB"]
  end

  def self.europe
    ["AL", "AD", "AM", "AT", "BY", "BE", "BA", "BG", "CH", "CY", "CZ", "DE", "DK", "EE", "ES", "FO", "FI", "FR",
     "GB", "GE", "GI", "GR", "HU", "HR", "IE", "IS", "IT", "LT", "LU", "LV", "MC", "MK", "MT", "NO", "NL", "PL",
     "PT", "RO", "RU", "SE", "SI", "SK", "SM", "TR", "UA", "VA"]
  end

  def self.francophonie
    ["BE", "BF", "BI", "BJ", "CA", "CD", "CF", "CG", "CH", "CI", "CM", "DJ", "FR", "GA", "GN", "GQ", "HT", "KM",
     "LU", "MC", "MG", "ML", "NE", "RW", "SN", "SC", "TD", "TG", "VU"]
  end

  def self.south_america
    ["AR", "BO", "BR", "CL", "CO", "EC", "FK", "GF", "GY", "GY", "PY", "PE", "SR", "UY", "VE"]
  end

  def self.outremer
    ["RE", "GP", "MQ", "GF", "YT"]
  end

  def self.north_america
    ["AI", "AG", "AW", "BS", "BB", "BZ", "BM", "VG", "CA", "KY", "CR", "CU", "CW", "DM", "DO", "SV", "GL", "GD",
     "GP", "GT", "HT", "HN", "JM", "MQ", "MX", "PM", "MS", "CW", "KN", "NI", "PA", "PR", "KN", "LC", "PM", "VC",
     "TT", "TC", "VI", "US", "SX"]
  end

  def self.africa
    ["DZ", "AO", "BW", "BI", "CM", "CV", "CF", "TD", "KM", "YT", "CG", "CD", "BJ", "GQ", "ET", "ER", "DJ", "GA",
     "GM", "GH", "GN", "CI", "KE", "LS", "LR", "LY", "MG", "MW", "ML", "MR", "MU", "MA", "MZ", "NA", "NE", "NG",
     "GW", "RW", "SH", "ST", "SN", "SC", "SL", "SO", "ZA", "ZW", "EH", "SD", "SZ", "TG", "TN", "UG", "EG", "TZ",
     "BF", "ZM"]
  end

  def self.currencies
    ["USD", "CAD", "GBP", "AUD", "CHF", "DKK", "NOK", "SEK", "KRW", "ZAR", "BRL", "SGD", "MXN", "NZD", "JPY", "EUR"]
  end

  def self.is_country_in_european_union?(country)
    self.european_union.include?(country)
  end

  def self.first_level_countries(countries)
    countries & self.world
  end

  def self.currency_for_country(country)
    ct= Country.find_country_by_alpha2(country)
    if ct and ct.currency
      ct.currency.code
    else
      nil
    end
  end

  def self.currencies_for_countries(countries)
    countries.map { |country| self.currency_for_country(country) }.uniq.compact
  end

  def self.countries_with_currencies(currencies)
    currencies.map { |currency| self.countries_with_currency(currency) }.flatten.uniq.compact
  end

  def self.countries_with_currency(currency)
    Country.find_all_by_currency(currency).map { |country| country.first }.compact
  end

  def self.countries_with_currency_fallback(currency, default_currency="EUR")
    if currency==default_currency
      self.world
    else
      self.countries_with_currency(currency)
    end
  end

  def self.currencies_all
    Country.all.map { |c| Country.new(c.last) }.map { |c| c.currency }.compact.map { |c| c.code }.uniq
  end

  @@tax_rates=nil


  # see http://www.vatlive.com
  def self.tax_rates
    @@tax_rates || @@tax_rates=YAML.load_file(File.dirname(__FILE__) + '/../../config/tax_rates.yml')[:tax_rates]
  end

  def self.country_ebook_vat(country)
    self.country_tax_rates_at(country, Date.today)[:ebook][:tax_rate]
  end

  def self.country_tax_rates_at(country, date)
    trs=self.tax_rates[country]
    if trs.class==Array
      ctr=nil

      utrs=trs.dup
      utrs.each do |t|
        unless t[:end_at]
          t[:end_at]=Date.today
        end
      end
      utrs.sort { |a, b| b[:end_at] <=> a[:end_at] }.each do |tr|
        if date <= tr[:end_at]
          ctr=tr
        end
      end
      ctr
    else
      trs
    end
  end

  # private
  def self.explode(str)
    list=[]
    slist=str.split(" ")
    slist.each do |s|
      case s
        when /^\-/
          list-=self.explode_token(s.gsub(/\-/, ""))
        when /^\&/
          list=list & self.explode_token(s.gsub(/\&/, ""))
        else
          list+=self.explode_token(s)
      end
    end
    list.uniq
  end

  # private
  def self.explode_token(tk)
    case tk
      when "WORLD"
        self.world
      when "FCP"
        self.francophonie
      when "EUR"
        self.europe
      when "EUZ"
        self.eurozone
      else
        [tk]
    end
  end

  def self.exploder(list)
    list.map { |c| self.explode(c) }.flatten.uniq
  end

  # private
  def self.simplify(slist, tk, tklist)
    list=[]
    if slist.include?(tk)
      list=((slist - [tk]) + tklist).uniq
    else
      list=slist.uniq
    end

    if list.sort == tklist.sort
      list=[tk]
    end
    list.uniq
  end

  def self.simplifier(slist, default=nil, currency=nil)
    list=Territories.simplify(slist, "WORLD", Territories.world)

    unless default.blank?
      countries_for_currency=Territories.world
      if currency
        countries_for_currency=Territories.countries_with_currency_fallback(currency, "EUR")
      end
      pub_countries=Territories.exploder(default) & countries_for_currency
      unless pub_countries.blank?
        list=Territories.simplify(list, "DEFAULT", pub_countries)
      end
      list=Territories.simplify(list, "DEFAULT", default)
    end

    list
  end

  def self.human_territories(territory)
    case territory
      when "WORLD"
        ["World".t]
      when "DEFAULT"
        ["Publisher default".t]
      else
        territory.split(" ").map { |ter| (I18n.t ter, :scope => 'countries') }
    end
  end


  module ClassMethods
  end

  module InstanceMethods

    def territory_string
      self.territory_list.join(" ")
    end

    # on explose les raccourcis en liste complete
    def all_territory_list
      if self.territory_list.include?("WORLD")
        Territories.world
      else
        self.territory_list
      end
    end

    def human_territories
      Territories.human_territories(self.territory_string)
    end

    def worldwide?
      if self.territory_string=="WORLD"
        true
      else
        false
      end
    end

  end
end
end
