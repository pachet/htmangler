require_relative "markov-node"

class HTMLNode < MarkovNode

  attr_reader :is_start_tag, :is_end_tag

  alias is_start_tag? is_start_tag
  alias is_end_tag? is_end_tag

  public

  def to_end_tag
    raise "Node did not correspond to a start tag" if !is_start_tag?

    token = first_token

    result = token[0] + '/' + token[1, token.length - 1]
    result += '>' if result[-1] != '>'
    result
  end


  private

  def initialize(tokens)
    super(tokens)

    token = first_token
    @is_start_tag = token[0] == '<' && token[1] != '/'
    @is_end_tag = token[0] == '<' && token[1] == '/'
  end

end
