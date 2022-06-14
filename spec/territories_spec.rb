require 'im_helpers'
require 'im_helpers/ext/string'
require 'im_helpers/ext/number'
require 'im_helpers/ext/date'

require 'countries'

describe ImHelpers::Territories do

  describe "territories helper" do

    it "explodes with one country excluded" do
      territory = "WORLD -AE"
      expect(ImHelpers::Territories.explode(territory)).to eq(ImHelpers::Territories.world - ["AE"])
    end

    it "explodes with several countries excluded" do
      territory = "WORLD -AE -AM -ZW"
      expect(ImHelpers::Territories.explode(territory)).to eq(ImHelpers::Territories.world - ["AE", "AM", "ZW"])
    end

    it "explodes with one country added" do
      territory = "WORLD &FR"
      expect(ImHelpers::Territories.explode(territory)).to eq(ImHelpers::Territories.world)
    end

    it "explodes with several countries added" do
      territory = "WORLD &FR &AD"
      expect(ImHelpers::Territories.explode(territory)).to eq(ImHelpers::Territories.world)
    end

    it "explodes with several countries added and excluded" do
      territory = "WORLD -AO -FR &FR &AD"
      expect(ImHelpers::Territories.explode(territory)).to eq(ImHelpers::Territories.world - ["AO"])
    end

    it "simplifies" do
      country_list = [ "WORLD" ] + ImHelpers::Territories.world
      territory_list = [ ]
      currency = "EUR"
      expect(ImHelpers::Territories.simplifier(country_list, territory_list, currency)).to eq([ "WORLD" ])
    end

    # it "simplifies with one country excluded" do
    #   country_list = ImHelpers::Territories.world - ["AE"]
    #   territory_list = [ "WORLD" ]
    #   currency = "EUR"
    #   expect(ImHelpers::Territories.simplifier(country_list, territory_list, currency)).to eq([ "WORLD -AE" ])
    # end
    #
    # it "simplifies with several countries excluded" do
    #   country_list = ImHelpers::Territories.world - ["AE", "AD"]
    #   territory_list = [ "WORLD" ]
    #   currency = "EUR"
    #   expect(ImHelpers::Territories.simplifier(country_list, territory_list, currency)).to eq([ "WORLD -AD -AE" ])
    # end

    it "simplifies with one country added" do
      country_list = ImHelpers::Territories.eurozone + ["AE"]
      territory_list = [ "WORLD" ]
      currency = "EUR"

      expect(ImHelpers::Territories.simplifier(country_list, territory_list, currency).sort).to eq((ImHelpers::Territories.eurozone + ["AE"]).sort)
    end

    it "simplifies with several countries added" do
      country_list = ImHelpers::Territories.eurozone + ["AE", "CV"]
      territory_list = [ "WORLD" ]
      currency = "EUR"

      expect(ImHelpers::Territories.simplifier(country_list, territory_list, currency).sort).to eq((ImHelpers::Territories.eurozone + ["AE", "CV"]).sort)
    end

    it "simplifies with a lot of countries added" do
      country_list = ["BE", "DK", "FR"]
      territory_list = [ "WORLD" ]
      currency = "EUR"

      expect(ImHelpers::Territories.simplifier(country_list, territory_list, currency)).to eq(["BE", "DK", "FR"])
    end

    it "gets currency for FR country" do
      expect(ImHelpers::Territories.currency_for_country("FR")).to eq("EUR")
    end

    it "gets countries for CAD currency" do
      expect(ImHelpers::Territories.countries_with_currency("CAD")).to eq(["CA"])
    end

    it "gets forex rate" do
      rate = ImHelpers::Forex.rate("USD", "EUR", Date.today)
      expect(rate).not_to eq(nil)

      rate = ImHelpers::Forex.rate("USD", "EUR", Date.today - 7.days)
      expect(rate).not_to eq(nil)
    end

    it "group world countries by continent" do
      territories_list = ImHelpers::Territories.countries_with_currency_fallback_by_continents("EUR")
      expect(territories_list.values.flatten.length).to eq(ImHelpers::Territories.world.count)
    end

  end

end
