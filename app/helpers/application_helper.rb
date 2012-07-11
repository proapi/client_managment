module ApplicationHelper
  def help_block(content, title = nil)
    render partial: 'shared/help_block', locals: {content: content, title: title}
  end

  def check_blank(label, value)
    render partial: "shared/field", locals: {label: label, value: value}
  end

  def check_blank_value(value)
    return l(value) if value.respond_to? :beginning_of_day
    value.nil? ? "Brak" : value
  end
end
