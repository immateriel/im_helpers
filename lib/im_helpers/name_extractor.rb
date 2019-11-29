require 'benchmark'
require 'unicode'
require 'unidecoder'
require 'pstore'
require 'levenshtein'
require 'pp'

module ImHelpers

  class FirstNameHash

    def self.set(name, gender)
      if name.include? "+"
        ['', '-', ' '].each { |replacement|
          set name.gsub("+", replacement), gender
        }
      else
        @names[name] ||= []
        @names[name] << gender
      end
    end

    def self.parse_name_line(line)
      return if line.start_with?("#") or line.start_with?("=")

      parts = line.split(" ").select { |p| p.strip != "" }
      name = Unicode.downcase(parts[1])

      case parts[0]
      when "M" then
        set(name, :male)
      when "1M", "?M" then
        set(name, :mostly_male)
      when "F" then
        set(name, :female)
      when "1F", "?F" then
        set(name, :mostly_female)
      when "?" then
        set(name, :andy)
      else
        raise "Not sure what to do with a gender of #{parts[0]}"
      end
    end

    def self.init(fname)
      @names = PStore.new("/tmp/firstnames.pstore")
      @names.transaction do
        File.foreach(fname, :encoding => "iso8859-1:utf-8") do |line|
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
    def initialize(name)
      @lastnames = []
      @firstnames = []
      @genres = []
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
      "#{to_s}<firstname:#{firstname_found? ? firstname : "?"},lastname:#{lastname_found? ? lastname : "?"},genres:#{firstname_found? ? genres : "?"}>"
    end

    def genres
      @genres
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
            @genres += res
          end
          @firstnames << name
        else
          @lastnames << name
        end
      end
    end
  end
end