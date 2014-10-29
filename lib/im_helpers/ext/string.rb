require 'im_helpers/ext/helpers/string_helpers'

class String
  include ImHelpers::StringMethods
  include ImHelpers::HtmlMethods
  include ImHelpers::TranslationHelpers

  def downcase
    Unicode.downcase self
  end

  def upcase
    Unicode.upcase self
  end

  def capitalize
    Unicode.capitalize self
  end

end