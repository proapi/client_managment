module ApplicationHelper
  def help_block(content, title = nil)
    render partial: 'shared/help_block', locals: {content: content, title: title}
  end

  def check_blank(label, value)
    render partial: "shared/field", locals: {label: label, value: value}
  end
end
