# -*- encoding : utf-8 -*-
require "htmlentities"
require 'unidecoder'

module ImHelpers

  module StringMethods
    PARTICLES = %w{d de des du l la le les von}

    def escape_sphinx_query
      key_value_pairs = [[/@/, '\@'], [/~/, '\~'], [/\//, '\/'], [/\s([-])+\s*/, ' \-'], [/\!/, '\!'], [/\?/, '\?'], [/\(/, '\('], [/\)/, '\)'], [/\"/, '\"'], [/\'/, '\'']]
      regexp_fragments = key_value_pairs.collect { |k,v| k }
      self.gsub!(Regexp.union(*regexp_fragments)) do |match|
        key_value_pairs.detect{|k,v| k =~ match}[1]
      end
      self.delete!('"') if self.count('"') % 2 != 0
      return self
    end

    def strip_spaces
      gsub(/\s+/, " ")
    end

    def each_utf8_char_with_index
      i = -1
      scan(/./mu) { |c| i+=1; yield(c, i) }
    end

    def cut_utf8(p, l) # (index) position, length
      raise(ArgumentError, "Error: argument is not Integer", caller) unless p.is_a?(Integer) && l.is_a?(Integer)
      s = self.length_utf8
      #if p < 0 then p = s - p.abs end
      if p < 0 then
        p.abs > s ? (p = 0) : (p = s - p.abs)
      end #  or:  ... p.abs > s ? (return nil) : ...
      return nil if l > s or p > (s - 1)
      ret = ""
      count = 0
      each_utf8_char_with_index do |c, i|
        break if count >= l
        if i >= p && count < l then
          count += 1; ret << c;
        end
      end
      ret
    end

    def length_utf8
      #scan(/./mu).size
      count = 0
      scan(/./mu) { count += 1 }
      count
    end

    def clean_cut(max_length, ellipsis="...")
      if self.to_s.length_utf8 > max_length
        new_str=self.to_s.cut_utf8(0, max_length)
        #[0..max_length]
        new_str.gsub!(/(.*)(,|\.).*$/, '\1\2')
        if new_str =~ /,$/
          new_str=new_str+" "+ellipsis
        end
        if new_str==self.to_s.cut_utf8(0, max_length)
          #[0..max_length]
          new_str.gsub!(/(.*) .*$/, '\1')
          new_str=new_str+" "+ellipsis
        end
        new_str
      else
        self.to_s
      end
    end

    def to_b
      self.to_i.to_b
    end

    def self.dameraulevenshtein(seq1, seq2)
      oneago = nil
      thisrow = (1..seq2.size).to_a + [0]
      seq1.size.times do |x|
        twoago, oneago, thisrow = oneago, thisrow, [0] * seq2.size + [x + 1]
        seq2.size.times do |y|
          delcost = oneago[y] + 1
          addcost = thisrow[y - 1] + 1
          subcost = oneago[y - 1] + ((seq1[x] != seq2[y]) ? 1 : 0)
          thisrow[y] = [delcost, addcost, subcost].min
          if (x > 0 and y > 0 and seq1[x] == seq2[y-1] and seq1[x-1] == seq2[y] and seq1[x] != seq2[y])
            thisrow[y] = [thisrow[y], twoago[y-2] + 1].min
          end
        end
      end
      return thisrow[seq2.size - 1]
    end

    def dameraulevenshtein(str)
      StringMethods.dameraulevenshtein(self, str)
    end

    def translit
      begin
        self.to_ascii
      rescue
        # if there is a problem, remove chars
        self.to_s.encode("ascii", :invalid => :replace, :undef => :replace, :replace => "")
      end
    end

    # translit if russian, arab ou greek
    def translit_non_latin_lang(lang)
      case lang
        when "ar","ru","el"
          self.translit
        else
          self
      end
    end


    def maybe_latin1_to_s
      if self.encoding.to_s == "ASCII-8BIT"
        self.force_encoding "UTF-8"
      end
      if self.valid_encoding?
        self
      else
        self.force_encoding("ISO-8859-15").encode("UTF-8")
      end
    end


    def namecase
      downcase.gsub(/(\p{Word}+\.?)/) { PARTICLES.include?($1) ? $1 : $1.capitalize }
    end

    def simplify_unicode
      self.to_s.gsub(/œ/, "oe").gsub(/Œ/, "OE").gsub(/Æ/, "Ae").gsub(/’/, "'")
    end
  end

  module HtmlMethods
    # transform HTML to plain text
    def strip_html(allowed = [])
      re = if allowed.any?
             Regexp.new(
                 %(<(?!(\\s|\\/)*(#{
                 allowed.map { |tag| Regexp.escape(tag) }.join("|")
                 })( |>|\\/|'|"|<|\\s*\\z))[^>]*(>+|\\s*\\z)),
                 Regexp::IGNORECASE | Regexp::MULTILINE, 'u'
             )
           else
             /<[^>]*(>+|\s*\z)/m
           end
      coder=HTMLEntities.new
      coder.decode(self.gsub(re, ''))
    end

    # basicly transform modern html to html3
    def purify_html
      doc= Nokogiri::XML::DocumentFragment.parse(self.to_s)
      doc.search(".//strong").each do |e|
        e.swap "<b>#{e.inner_html}</b>"
      end
      doc.search(".//h4").each do |e|
        e.swap "<b>#{e.inner_html}</b>"
      end
      doc.search(".//h3").each do |e|
        e.swap "<b>#{e.inner_html}</b>"
      end
      doc.search(".//h2").each do |e|
        e.swap "<b>#{e.inner_html}</b>"
      end
      doc.search(".//h1").each do |e|
        e.swap "<b>#{e.inner_html}</b>"
      end

      doc.search(".//em").each do |e|
        e.swap "<i>#{e.inner_html}</i>"
      end

      doc.search(".//ul").each do |e|
        e.swap "#{e.inner_html}"
      end
      doc.search(".//ol").each do |e|
        e.swap "#{e.inner_html}"
      end
      doc.search(".//li").each do |e|
        e.swap "<p>#{e.inner_html}</p>"
      end
      doc.search(".//span").each do |e|
        e.swap "#{e.inner_html}"
      end

      doc.to_xml(:encoding => "UTF-8").gsub(/\n/," ").gsub(/\s+/," ")
    end

    def strip_html_links
      doc= Nokogiri::XML::DocumentFragment.parse(self.to_s)
      doc.search(".//a").each do |e|
        e.swap "#{e.inner_html}"
      end

      doc.to_xml(:encoding => "UTF-8")
    end

    def delete_lonely_html_links
      doc= Nokogiri::XML.parse("<body>"+self.to_s+"</body>")
      doc.xpath("//p[a and not(*[not(self::a)] or text()[normalize-space()])]").each do |e|
        e.remove
      end
      doc.at("body").children.to_xml(:encoding => "UTF-8")
    end

    def valid_xhtml
      Hpricot(self, :xhtml_strict => true).to_s
#    Nokogiri::XML::DocumentFragment.parse(self).to_s
    end

    # cut html to len
    def clean_truncate_html(len=30, ellipsis="...")
      Nokogiri::HTML::DocumentFragment.parse(HTML_Truncator.truncate(self, len, :ellipsis => ellipsis, :length_in_chars => true)).to_xhtml
    end

    def truncate_html(len = 30)
      self.clean_truncate_html(len)
    end

    def strip_entities
      gsub(/&(#?)(.+?);/, '')
    end

  end

  module TranslationHelpers
    def t(args={})
      trkey=self.downcase.translit.gsub(/\./, "")
      I18n.t trkey, { default: self }.merge(args)
    end

    def routes_t
      I18n.t self, :scope => "routes", :default => self
    end
  end

end
