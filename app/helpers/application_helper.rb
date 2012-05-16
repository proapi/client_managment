module ApplicationHelper
  def help_block(content, title = nil)
    render partial: 'shared/help_block', locals: {content: content, title: title}
  end
end
