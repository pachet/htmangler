require_relative "markov-node"
require "byebug"

class MarkovChain

  # This is a class representing a tokenized Markov chain, ready to be
  # consumed and turned into a string of output tokens.

  DEFAULT_ORDER = 1
  DEFAULT_DELIMITER = ' '
  DEFAULT_TERMINAL_CHARACTERS = ['.', '!', '?']

  def initialize(
    order = MarkovChain::DEFAULT_ORDER,
    delimiter = MarkovChain::DEFAULT_DELIMITER,
    terminal_characters = MarkovChain::DEFAULT_TERMINAL_CHARACTERS
  )
    @order = order
    @delimiter = delimiter
    @terminal_characters = terminal_characters

    @token_queue = []
    @nodes = { }
    @initial_nodes = [ ]
    @last_node = nil
  end

  def add_token(token)
    queue_token token
    process_token_queue
  end

  def queue_token(token)
    @token_queue.push(token)
  end

  def process_token_queue
    return if @token_queue.length < @order + 1

    source_tokens = next_tokens
    trim_token_queue
    target_tokens = next_tokens

    link_token_sets(source_tokens, target_tokens)
  end

  def clear_token_queue
    return if @token_queue.length != @order

    final_tokens = next_tokens
    get_or_create_node(final_tokens)
  end

  def next_tokens
    return @token_queue[0, @order]
  end

  def trim_token_queue
    @token_queue = @token_queue[1, @token_queue.length]
  end

  def link_token_sets(source_tokens, target_tokens)
    node = get_or_create_node(source_tokens)
    target_key = key_from_tokens(target_tokens)
    node.link_key(target_key)
  end

  def get_node(tokens)
    @nodes[key_from_tokens(tokens)]
  end

  def create_node(tokens)
    node = MarkovNode.new(tokens)
    add_initial_node(node) if !@last_node || @last_node.is_terminal?
    @nodes[key_from_tokens(tokens)] = node
    @last_node = node

    node.is_terminal = true if is_terminal_character(node.last_character)

    node
  end

  def get_or_create_node(tokens)
    get_node(tokens) || create_node(tokens)
  end

  def is_terminal_character(character)
    @terminal_characters.include? character
  end

  def key_from_tokens(tokens)
    return tokens.join(@delimiter)
  end

  def finalize
    clear_token_queue
    @last_node.is_terminal = true
  end

  def generate(phrases)
    phrase_count = 0
    node = nil

    while (phrase_count < phrases)
      node = get_node_after(node)
      segment = node.first_token

      if node.is_terminal?
        phrase_count += 1
      elsif phrase_count < phrases
        segment += @delimiter
      end

      yield segment
    end
  end

  def get_node_after(node)
    return random_initial_node if node.nil?

    key = node.random_key

    @nodes[key] || random_initial_node
  end

  def add_initial_node(node)
    @initial_nodes.push(node)
  end

  def random_initial_node
    @initial_nodes.sample
  end

end

