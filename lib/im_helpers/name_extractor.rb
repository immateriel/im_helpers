require 'benchmark'
require 'unicode'
require 'unidecoder'
require 'pstore'
require 'levenshtein'
require 'pp'

module ImHelpers

  class FirstNameHash

    def self.set(name, gender, countries)
      if name.to_ascii != name
        set name.to_ascii, gender, countries
      end

      if name.include? "+"
        ['', '-', ' '].each { |replacement|
          set name.gsub("+", replacement), gender, countries
        }
      else
          @names[name] ||= []
          @names[name] << {gender: gender, countries: countries}
      end
    end

    def self.countries
      {"GB" => 0, "IE" => 1, "US" => 2, "IT" => 3, "MT" => 4, "PT" => 5, "ES" => 6,
       "FR" => 7, "BE" => 8, "LU" => 9, "NL" => 10, "IGNORE0" => 11, "DE" => 12, "AT" => 13,
       "CH" => 14, "IS" => 15, "DK" => 16, "NO" => 17, "SE" => 18, "FI" => 19, "EE" => 20,
       "LV" => 21, "LT" => 22, "PL" => 23, "CZ" => 24, "SK" => 25, "HU" => 26, "RO" => 27,
       "BG" => 28, "BA" => 29, "HR" => 30, "IGNORE1" => 31, "MK" => 32, "ME" => 33, "RS" => 34,
       "SI" => 35, "AL" => 36, "GR" => 37, "RU" => 38, "BY" => 39, "MD" => 40, "UA" => 41,
       "AM" => 42, "AZ" => 43, "GE" => 44, "KZ" => 45, "TR" => 46, "IR" => 47, "IL" => 48,
       "CN" => 49, "IN" => 50, "JP" => 51, "KR" => 52, "VN" => 53, "OTHER" => 54
      }
    end

    def self._rev_countries
      h = {}
      self.countries.each do |country, col|
        h[col] = country
      end
      h
    end

    def self.rev_countries
      @rev_countries ||= self._rev_countries
    end

    def self.parse_name_line(line)
      return if line.start_with?("#") or line.start_with?("=")

      genre_k = line[0..2].strip
      name = Unicode.downcase(line[3..28].strip)
      countries_freq = line[30..85].split('')
      countries = []
      countries_freq.each_with_index do |cf, i|
        if cf.to_i > 0
          countries << self.rev_countries[i]
        end
      end

      genre = nil
      case genre_k
      when "M" then
        genre = :male
      when "1M", "?M" then
        genre = :mostly_male
      when "F" then
        genre = :female
      when "1F", "?F" then
        genre = :mostly_female
      when "?" then
        genre = :andy
      else
        raise "Not sure what to do with a gender of #{parts[0]}"
      end

      set(name, genre, countries)

    end

    def self.init(fname)
      @names = PStore.new("/tmp/firstnames.pstore")
      @names.transaction do
        File.foreach(fname) do |line|
          parse_name_line line
        end
      end
    end

    def self._hash
      @names = PStore.new("/tmp/firstnames.pstore")
      h = {}
      @names.transaction(true) {
        @names.roots.each do |k|
          h[k] = @names[k]
        end
      }
      h
    end

    def self.hash
      @hash ||= _hash
    end

    def self.get(name)
      init(File.dirname(__FILE__) + '/../../config/nam_dict.txt') unless File.exist?("/tmp/firstnames.pstore")
      hash[Unicode.downcase(name)]
    end

  end

  class NameExtractor
    attr_accessor :genres, :countries
    def initialize(name)
      @lastnames = []
      @firstnames = []
      @genres = []
      @countries = []
      @orig_name = name
      parse
    end

    def firstname
      @firstnames.join(" ")
    end

    def lastname
      @lastnames.join(" ")
    end

    def to_s
      "#{self.firstname} #{self.lastname}".strip
    end

    def normalized
      Unicode.downcase(to_s).to_ascii
    end

    def normalized_firstname
      Unicode.downcase(firstname).to_ascii
    end

    def normalized_lastname
      Unicode.downcase(lastname).to_ascii
    end

    def firstname_found?
      not @firstnames.empty?
    end

    def lastname_found?
      not @lastnames.empty?
    end

    def found?
      firstname_found? and lastname_found?
    end

    def == other
      compare(other) < 0.15
    end

    def inspect
      "#{to_s}<firstname:#{firstname_found? ? firstname : "?"},lastname:#{lastname_found? ? lastname : "?"},genres:#{firstname_found? ? genres : "?"},countries:#{firstname_found? ? countries : "?"}>"
    end

# 0 == exact match, 1 == completely different
    def compare(other)
      score = 0.0
      firstname_dist = Levenshtein.distance(normalized_firstname, other.normalized_firstname)
      lastname_dist = Levenshtein.distance(normalized_lastname, other.normalized_lastname)

      mod = 1.0
      if lastname_found?
        if normalized_firstname[0] == other.normalized_firstname[0]
          mod += 3.0
          if normalized_firstname.length < 3 or other.normalized_firstname.length < 3
            mod += 3.0
          end
          if lastname_dist == 0
            mod += 4.0
          end
        end
      end

      if normalized_firstname.length > 0 and other.normalized_firstname.length > 0
        score += 0.25 * (firstname_dist / (normalized_firstname.length.to_f) + firstname_dist / (other.normalized_firstname.length.to_f)) / mod
      end
      if normalized_lastname.length > 0 and other.normalized_lastname.length > 0
        score += 0.25 * (lastname_dist / (normalized_lastname.length.to_f) + lastname_dist / (other.normalized_lastname.length.to_f))
      end

      score
    end

    private

    def parse
      names = @orig_name.scan(/[^\s.]+\.?/)

      names.each do |name|
        res = FirstNameHash.get(name)
        unless res
          res = FirstNameHash.get(name.to_ascii)
        end
        if res or Unicode.downcase(name) =~ /^[a-z]\.?$/
          if res
            @genres << res.first[:gender]
            @countries += res.first[:countries]
          end
          @firstnames << name
        else
          @lastnames << name
        end
      end
    end
  end
end