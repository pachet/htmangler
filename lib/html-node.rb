require_relative "markov-node"

class HTMLNode < MarkovNode

  attr_reader :is_start_tag, :is_end_tag

  alias is_start_tag? is_start_tag
  alias is_end_tag? is_end_tag

  def initialize(tokens)
    super(tokens)

    key = tokens[0]
    @is_start_tag = key[0] == '<' && key[1] != '/'
    @is_end_tag = key[0] == '<' && key[1] == '/'
  end

end
