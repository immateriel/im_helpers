module ImHelpers
  module FloatMethods
    def prec(x)
      ("%.#{x}f" % self).to_f
    end

    def to_s_prec(x)
      "%.#{x}f" % self
    end

    def localize(p=2)
      I18n.float_localize(self.prec(p), p)
    end
  end

  module FixnumMethods
    def to_s_prec(x)
      "%.#{x}f" % self
    end

    def prec(x)
      self
    end

    def localize(x=2)
      self
    end

    def to_b
      not self.zero?
    end
  end
end