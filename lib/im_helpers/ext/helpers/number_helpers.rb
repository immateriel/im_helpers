module ImHelpers
  module FloatMethods
    if RUBY_VERSION < "1.9"
      def prec(x)
        precision = 10 ** x
        (self * precision).round.to_f / precision
      end
    else
      def prec(x)
        self.round(x)
      end
    end

    def to_s_prec(x)
      "%.#{x}f" % self
    end

    def localize(p=2)
      I18n.float_localize(self.prec(p), p)
    end
  end

  module IntegerMethods
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
