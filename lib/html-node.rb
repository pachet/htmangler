require_relative "markov-node"

class HTMLNode < MarkovNode

  attr_accessor :is_end_tag

  alias is_end_tag? is_end_tag

  def initialize(tokens)
    super(tokens)

    @is_end_tag = false
  end

end
