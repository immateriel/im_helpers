module I18n
  @@number_helper=Object.new.extend(ActionView::Helpers::NumberHelper)

  def self.float_localize(f, p=2)
    @@number_helper.number_with_precision(f, :precision => p)
  end
end
