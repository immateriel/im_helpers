require 'im_helpers/ext/helpers/date_helpers'

class Date
  include ImHelpers::DateMethods

  # helpers
  def self.each_between(start_at, end_at, &block)
    ((end_at - start_at)+1).to_i.times do |i|
      yield(start_at+i.days)
    end
  end
end

class DateTime
  include ImHelpers::DateTimeMethods
end

class Time
  include ImHelpers::TimeMethods
end