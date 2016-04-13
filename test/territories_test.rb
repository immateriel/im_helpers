# coding: utf-8
require 'im_helpers'
require 'im_helpers/ext/string'
require 'im_helpers/ext/number'
require 'im_helpers/ext/date'
require 'minitest/autorun'

class TerritoriesTest < Minitest::Test
  
  def test_explode_with_one_country_excluded
    territory = "WORLD -AE"
    assert_equal ImHelpers::Territories.world - ["AE"], ImHelpers::Territories.explode(territory)
  end

  def test_explode_with_several_countries_excluded
    territory = "WORLD -AE -AM -ZW"
    assert_equal ImHelpers::Territories.world - ["AE", "AM", "ZW"], ImHelpers::Territories.explode(territory)
  end

  def test_explode_with_one_country_added
    territory = "WORLD &FR"
    assert_equal ImHelpers::Territories.world, ImHelpers::Territories.explode(territory)
  end

  def test_explode_with_several_countries_added
    territory = "WORLD &FR &AD"
    assert_equal ImHelpers::Territories.world, ImHelpers::Territories.explode(territory)
  end

  def test_explode_with_several_countries_added_and_excluded
    territory = "WORLD -AO -FR &FR &AD"
    assert_equal ImHelpers::Territories.world - ["AO"], ImHelpers::Territories.explode(territory)
  end

  def test_simplifier
    country_list = [ "WORLD" ] + ImHelpers::Territories.world
    territory_list = [ "WORLD" ]
    currency = "EUR"

    assert_equal [ "WORLD" ], ImHelpers::Territories.simplifier(country_list, territory_list, currency)
  end

  def test_simplifier_with_one_country_excluded
    country_list = ImHelpers::Territories.world - ["AE"]
    territory_list = [ "WORLD" ]
    currency = "EUR"

    assert_equal [ "WORLD -AE" ], ImHelpers::Territories.simplifier(country_list, territory_list, currency)
  end

  def test_simplifier_with_several_countries_excluded
    country_list = ImHelpers::Territories.world - ["AE", "AD"]
    territory_list = [ "WORLD" ]
    currency = "EUR"

    assert_equal [ "WORLD -AD -AE" ], ImHelpers::Territories.simplifier(country_list, territory_list, currency)
  end

  def test_simplifier_with_one_country_added
    country_list = ImHelpers::Territories.eurozone + ["AE"]
    territory_list = [ "WORLD" ]
    currency = "EUR"

    assert_equal (ImHelpers::Territories.eurozone + ["AE"]).sort, ImHelpers::Territories.simplifier(country_list, territory_list, currency)
  end
  
  def test_simplifier_with_several_country_added
    country_list = ImHelpers::Territories.eurozone + ["AE", "CV"]
    territory_list = [ "WORLD" ]
    currency = "EUR"

    assert_equal (ImHelpers::Territories.eurozone + ["AE", "CV"]).sort, ImHelpers::Territories.simplifier(country_list, territory_list, currency)
  end
  
  def test_simplifier_with_a_lot_of_country_excluded
    country_list = ["BE", "DK", "FR"]
    territory_list = [ "WORLD" ]
    currency = "EUR"
    
    assert_equal ["BE", "DK", "FR"], ImHelpers::Territories.simplifier(country_list, territory_list, currency)
  end
  
  def test_currency
    assert_equal "EUR", ImHelpers::Territories.currency_for_country("FR")
  end

  def test_country_with_currency
    assert_equal ["CA"], ImHelpers::Territories.countries_with_currency("CAD")
  end
  
end