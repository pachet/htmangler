
class MarkovNode

  @link_count = 0
  @links = { }

  def link_token(token)
    link = get_link(token) || create_link(token)
    link.increment_count
    increment_link_count
  end

  def get_link(token)
    @links[token]
  end

  def create_link(token)
    link = MarkovLink.new(token)
    @links[token] = link
    link
  end

  def get_random_link
    index = rand(@link_count)

    links.each do |link|
      return link if link.count > index
    end
  end

  def increment_links
    @link_count += 1
  end

end

