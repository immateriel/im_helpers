require 'benchmark'
require 'unicode'
require 'pstore'
require 'levenshtein'
require 'csv'
require 'pp'

module ImHelpers

  class FirstNameConverter

    def self.max
      10000
    end

    def self.convert
      names = {}
      File.foreach("config/nam_dict.txt") do |line|
        if !line.start_with?("#") and !line.start_with?("=")
          nm = Unicode.downcase(line[3..28].strip)
          freq = line[30..85].split('').map { |f| f == "" ? 0 : f.to_i }.inject(0) { |sum, i| sum + i }
          names[nm] ||= 0
          names[nm] += freq * 1000
          if names[nm] > self.max
            names[nm] = self.max
          end
        end
      end

      # Insee
      CSV.open("config/nat2018.csv", col_sep: ";").each do |r|
        nm = Unicode.downcase(r[1])
        freq = r[3].to_i * 100
        names[nm] ||= 0
        names[nm] += freq
        if names[nm] > self.max
          names[nm] = self.max
        end
      end

      # https://github.com/philipperemy/name-dataset
      File.foreach("config/firstnames.all.txt") do |line|
        nm = Unicode.downcase(line.strip)
        names[nm] ||= 0
        names[nm] += 1000
        if names[nm] > self.max
          names[nm] = self.max
        end
      end

      # extra
      ["carian"].each do |n|
        names[n] ||= 0
        names[n] += 2500
      end

      File.open("config/firstnames.txt", "w") do |f|
        names.each do |nm, freq|
          f.write("#{nm},#{freq}\n")
        end
      end

    end
  end

  class FirstNameHash
    def self.set(name, gender, countries)
      if name.include? "+"
        ['', '-', ' '].each { |replacement|
          set name.gsub("+", replacement), gender, countries
        }
      else
        @names[name] ||= []
        @names[name] << {gender: gender, countries: countries}
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
      self.init unless File.exist?("/tmp/firstnames.pstore")
      hash[Unicode.downcase(name)]
    end

    def self.init
      fname = (File.dirname(__FILE__) + '/../../config/firstnames.txt')
      @names = PStore.new("/tmp/firstnames.pstore")
      @names.transaction do
        File.foreach(fname) do |line|
          nm, freq = line.strip.split(",")
          @names[nm] ||= freq.to_i
        end
      end
    end

  end

  class NameExtractor
    def self.hash_class
      FirstNameHash
    end

    def initialize(name)
      @lastnames = []
      @firstnames = []
      @results = []
      @orig_name = name

      parse

      # fallback
      if @firstnames.length == 0 and @lastnames.length == 0
        @lastnames = [@orig_name]
      end
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
      I18n.transliterate(Unicode.downcase(to_s))
    end

    def normalized_firstname
      I18n.transliterate(Unicode.downcase(firstname))
    end

    def normalized_lastname
      I18n.transliterate(Unicode.downcase(lastname))
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

    def results
      @results
    end

    def inspect
      "#{to_s}<firstname:#{firstname_found? ? firstname : "?"},lastname:#{lastname_found? ? lastname : "?"},results:#{results}>"
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

      med = 0
      if names.length < 5 # fail with more than 4 names
        names.each_with_index do |name, i|
          splitted_names = name.split("-")
          if splitted_names.length > 0
            res = splitted_names.map { |nm| NameExtractor.hash_class.get(nm) }.compact.inject(0) { |sum, x| sum + x } / splitted_names.length
            unless res
              res = splitted_names.map { |nm| NameExtractor.hash_class.get(I18n.transliterate(nm)) }.compact.inject(0) { |sum, x| sum + x } / splitted_names.length
            end
            if res
              if Unicode.downcase(name) =~ /^-?[a-z]\.?$/ or Unicode.downcase(name) =~ /^dr\.?/
                @results << {name: name, freq: 4000}
                med += 4000
              else
                freq = (res * (names.length - i) / names.length.to_f).round
                if name.length == 2 # only two char
                  freq -= 2000
                end
                if name[0] =~ /[a-z]/ # downcase first char
                  freq -= 2000
                end
                @results << {name: name, freq: freq}
                med += freq
              end
            else
              @results << {name: name, freq: ((names.length - i).to_f * 500).round}
            end
          end
        end

        if results.length > 0
          med = (med / results.length.to_f).round
          if med > 1000 # not sure enough
            if @results.length == 2
              max = [@results.first[:freq], @results.last[:freq]].max
              min = [@results.first[:freq], @results.last[:freq]].min
              return if max < 2 * min # firstname should have 2x freq than lastname
            end
            @results.each_with_index do |result, i|
              fact = med * (i / @results.length.to_f) * 2.0
#            puts "#{result} > #{fact}"
              if result[:freq] > fact
                @firstnames << result[:name]
              else
                @lastnames << result[:name]
              end
            end
          end
        end
      end
    end
  end
end