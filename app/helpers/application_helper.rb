module ApplicationHelper

  def title_tag(title)
    content_for :title do
      content_tag(:div, :id => "title") do
        content_tag(:h1, title)
      end
    end
  end

  def active?(*paths)
    active = false
    paths.each { |path| active ||= current_page?(path) }
    active ? 'active' : nil
  end

end