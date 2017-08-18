
class MarkovChain

  # This is a class representing a tokenized Markov chain, ready to be
  # consumed and turned into a string of output tokens.

  @nodes = [ ]

  def initialize
    @nodes = [ ]
  end

  def add_token(token)

  end

  def node_count
    @nodes.length
  end

  def get_next_node(node)
  end

  def generate
    index = 0
    max = [10, node_count].max
    node = nil

    while (index < max)
      node = get_next_node(node)
      index += 1
      yield 'boop'
    end
  end

end

