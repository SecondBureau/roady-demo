module MetaHelper
  def to_keywords title
    title.to_s.downcase.split(" ").join(",")
  end

  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def description(page_description)
    @content_for_description = page_description.to_s
  end
end
