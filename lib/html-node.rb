require_relative "markov-node"

class HTMLNode < MarkovNode

  attr_accessor :is_start_tag, :is_end_tag

  alias is_start_tag? is_start_tag
  alias is_end_tag? is_end_tag

  def initialize(tokens)
    super(tokens)

    @is_start_tag = false
    @is_end_tag = false
  end

end
