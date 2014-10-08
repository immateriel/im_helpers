require 'im_helpers/ext/helpers/date_helpers'

class Date
  include ImHelpers::DateMethods
end

class DateTime
  include ImHelpers::DateTimeMethods
end

class Time
  include ImHelpers::TimeMethods
end