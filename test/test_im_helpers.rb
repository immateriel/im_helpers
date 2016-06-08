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

  context "name extractor" do
    should 'found firstname and lastname' do
      e=ImHelpers::NameExtractor.new("René Barjavel")
      assert_equal "René", e.firstname
      assert_equal "Barjavel", e.lastname
      assert_equal true, e.genres.include?(:male)
      e=ImHelpers::NameExtractor.new("J. R. R. Tolkien")
      assert_equal "J. R. R.", e.firstname
      assert_equal "Tolkien", e.lastname
    end

    should 'be equal' do
      e1=ImHelpers::NameExtractor.new("René Barjavel")
      e2=ImHelpers::NameExtractor.new("R Barjavel")
      e3=ImHelpers::NameExtractor.new("BARJAVEL RENE")

      assert_equal true,e1==e2
      assert_equal true,e1==e3
      assert_equal true,e2==e3

      e1=ImHelpers::NameExtractor.new("Pierre Loti")
      e2=ImHelpers::NameExtractor.new("P Loti")

      assert_equal true,e1==e2

      e1=ImHelpers::NameExtractor.new("Guy de Maupassant")
      e2=ImHelpers::NameExtractor.new("G de Maupassant")
      e3=ImHelpers::NameExtractor.new("G Maupassant")

      assert_equal true,e1==e2
      assert_equal true,e1==e3

    end

    should "be different" do
      e1=ImHelpers::NameExtractor.new("Pierre Louÿs")
      e2=ImHelpers::NameExtractor.new("Pierre Loti")
      e3=ImHelpers::NameExtractor.new("P Loti")

      assert_equal false,e1==e2
      assert_equal false,e1==e3

      e1=ImHelpers::NameExtractor.new("Pierre Loti")
      e2=ImHelpers::NameExtractor.new("J Loti")
      e3=ImHelpers::NameExtractor.new("Jean Loti")

      assert_equal false,e1==e2
      assert_equal false,e1==e3

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
