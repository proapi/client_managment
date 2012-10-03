ActionView::Helpers::FormBuilder.class_eval do

  def decimal_field(field, options = {})
    value = object.send(field).to_s
    #value = value.slice(/\A\d+(\.\d{0,2})?/) unless value.blank?
    value = ActionController::Base.helpers.number_with_precision(value, precision: 2, delimiter: " ")
    #value.gsub!('.', ',') unless value.blank?
    options[:value] = value
    text_field(field, options)
  end

end