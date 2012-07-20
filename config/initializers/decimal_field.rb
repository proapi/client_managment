ActionView::Helpers::FormBuilder.class_eval do

  def decimal_field(field, options = {})
    value = object.send(field).to_s
    value.gsub!('.', ',') unless value.blank?
    options[:value] = value
    text_field(field, options)
  end

end