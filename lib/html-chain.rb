require_relative "markov-chain"
require_relative "html-node"

class HTMLChain < MarkovChain

  protected

  def instantiate_node(tokens)
    HTMLNode.new(tokens)
  end

end

