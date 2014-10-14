module ImHelpers
  module TimeMethods
    def localize(ign=nil)
      begin
        I18n.localize self
      rescue
        self
      end
    end
  end

  module DateTimeMethods
    def to_i
      Time.parse(self.to_s).to_i
    end
  end

  module DateMethods
    def localize(ign=nil)
      begin
        I18n.localize self
      rescue
        self
      end
    end

    def loc(ign=nil)
      begin
        I18n.localize self
      rescue
        self
      end
    end

    def first_day_of_month
      Date.new(self.year, self.month, 1)
    end

    def last_day_of_month
      Date.new((self + 1.month).year, (self + 1.month).month, 1) - 1.day
    end

  end
end