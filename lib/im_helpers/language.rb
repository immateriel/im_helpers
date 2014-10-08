module ImHelpers
  class Language
    def self.native_languages
      @@native_languages||=YAML.load(File.read( File.dirname(__FILE__) + "/../../config/native_languages.yml"))[:native_languages]
    end

    def self.all
      ISO_639::ISO_639_2.map { |iso|
        lang=self.new
        lang.iso639=iso
        lang.init_native
        lang
      }.select { |lang| lang.native_name }
    end

    def self.find(code)
      if code and ISO_639.find(code)
        lang=self.new
        lang.iso639=ISO_639.find(code)
        lang.init_native
        lang
      end
    end

    attr_accessor :iso639, :native_name
    delegate :alpha2, :alpha3, :english_name, :french_name, :to => :iso639

    def init_native
      @native_name=Language.native_languages[@iso639.alpha2]
    end
  end
end
