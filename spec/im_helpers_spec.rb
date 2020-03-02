require 'im_helpers'
require 'im_helpers/ext/string'
require 'im_helpers/ext/number'
require 'im_helpers/ext/date'

require 'countries'

describe ImHelpers do
  describe "extensions" do
    it "escapes exclamations points" do
      expect("Ce qui se passe à Vegas reste à Vegas!".escape_sphinx_query).to eq("Ce qui se passe à Vegas reste à Vegas\\!")
      expect("Coucou !".escape_sphinx_query).to eq("Coucou \\!")
    end

    it "escapes at characters" do
      expect("jean@dupont.com".escape_sphinx_query).to eq("jean\\@dupont.com")
    end

    it "strips html" do
      expect("<p><em>Hello</em> <strong>World</strong></p>".strip_html).to eq("Hello World")
    end

    it "strips spaces" do
      expect("Hello   World".strip_spaces).to eq("Hello World")
    end

    it "prec float" do
      expect(1.23456789.prec(2)).to eq(1.23)
    end

    # Ce test ne passe pas avec `("%.#{x}f" % self).to_f`
    it "prec float with .005" do
      expect(12.125.prec(2)).to eq(12.13)
    end
  end

  describe "#namecase" do

    it 'does not capitalize particles but initials' do
      expect('J. r. R. tolKien'.namecase).to eq('J. R. R. Tolkien')
      expect('jean DE La fonTAINE'.namecase).to eq('Jean de la Fontaine')
    end

    it 'capitalizes initials which are particle letters' do
      expect('Sarah Agnès L.'.namecase).to eq('Sarah Agnès L.')
      expect('d. r. BurRow'.namecase).to eq('D. R. Burrow')
    end
  end

  describe "name extractor" do
    it 'founds firstname and lastname' do
      e = ImHelpers::NameExtractor.new("René Barjavel")
      expect(e.firstname).to eq("René")
      expect(e.lastname).to eq("Barjavel")

      e = ImHelpers::NameExtractor.new("D.R. Burrow")
      expect(e.firstname).to eq("D. R.")
      expect(e.lastname).to eq("Burrow")

      e = ImHelpers::NameExtractor.new("J. R. R. Tolkien")
      expect(e.firstname).to eq("J. R. R.")
      expect(e.lastname).to eq("Tolkien")

      e = ImHelpers::NameExtractor.new("Jean de la Fontaine")
      expect(e.firstname).to eq("Jean de")
      expect(e.lastname).to eq("la Fontaine")
    end

    it 'founds firstname or lastname' do
      e = ImHelpers::NameExtractor.new("alexandre@dumas.fr")
      expect(e.lastname).to eq("alexandre@dumas.fr")

      e = ImHelpers::NameExtractor.new("Sarah Agnès L.")
      expect(e.firstname).to eq("Sarah Agnès L.")
    end

    it 'should be equal' do
      e1 = ImHelpers::NameExtractor.new("René Barjavel")
      e2 = ImHelpers::NameExtractor.new("R Barjavel")
      e3 = ImHelpers::NameExtractor.new("BARJAVEL RENE")
      expect(e1).to eq(e2)
      expect(e1).to eq(e3)
      expect(e2).to eq(e3)
    end

    it "should be different" do
      e1 = ImHelpers::NameExtractor.new("Pierre Louÿs")
      e2 = ImHelpers::NameExtractor.new("Pierre Loti")
      e3 = ImHelpers::NameExtractor.new("P Loti")
      expect(e1).not_to eq(e2)
      expect(e1).not_to eq(e3)

      e1 = ImHelpers::NameExtractor.new("Pierre Loti")
      e2 = ImHelpers::NameExtractor.new("J Loti")
      e3 = ImHelpers::NameExtractor.new("Jean Loti")
      expect(e1).not_to eq(e2)
      expect(e1).not_to eq(e3)
    end

  end

  describe "language" do
    it "should be french" do
      expect(ImHelpers::Language.find("fre").native_name).to eq("Français")
    end
  end

end
