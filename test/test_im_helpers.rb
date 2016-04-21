# coding: utf-8
require 'im_helpers'
require 'im_helpers/ext/string'
require 'im_helpers/ext/number'
require 'im_helpers/ext/date'

require 'countries'
require 'rubygems'
require 'minitest/autorun'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

class TestImOnix < Minitest::Test
  context "extensions" do
    setup do
    end

    should "strip html" do
      assert_equal "Hello World","<p><em>Hello</em> <strong>World</strong></p>".strip_html
    end

    should "strip spaces" do
      assert_equal "Hello World","Hello   World".strip_spaces
    end

    should "prec float" do
      assert_equal 1.23, 1.23456789.prec(2)
    end

    # Ce test ne passe pas avec `("%.#{x}f" % self).to_f`
    should "prec float with .005" do
      assert_equal 12.13, 12.125.prec(2)
    end
  end

  context '#namecase' do
    should 'not capitalize particles but initials' do
      assert_equal 'J. R. R. Tolkien', 'J. r. R. tolKien'.namecase
      assert_equal 'Jean de la Fontaine', 'jean DE La fonTAINE'.namecase
    end

    should 'capitalize initials which are particle letters' do
      assert_equal 'Sarah Agnès L.', 'Sarah Agnès L.'.namecase
      assert_equal 'D. R. Burrow', 'd. r. BurRow'.namecase
    end
  end

  context "language" do
    setup do
    end

    should "french" do
      assert_equal "Français",ImHelpers::Language.find("fre").native_name
    end
  end

  context "territories" do
    setup do

    end

  end
end
