require 'im_helpers/ext/helpers/number_helpers'

class Float
  include ImHelpers::FloatMethods
end

class Integer
  include ImHelpers::FixnumMethods
end

class BigDecimal
  include ImHelpers::FloatMethods
end
