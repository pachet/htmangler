require_relative "markov-node"
require "byebug"
require "json"

class MarkovChain

  # This is a class representing a tokenized Markov chain, ready to be
  # consumed and turned into a string of output tokens.

  DEFAULT_ORDER = 1
  DEFAULT_DELIMITER = ' '
  DEFAULT_TERMINAL_CHARACTERS = ['.', '!', '?']
  DEFAULT_PHRASE_COUNT = 2

  public

  def set_text(text)
    text = trim_text(text)
    text_to_tokens(text).each do |token|
      add_token(token)
    end
    finalize
  end

  def generate(phrase_count = MarkovChain::DEFAULT_PHRASE_COUNT)
    index = 0
    node = nil

    while (index < phrase_count)
      node = get_node_after(node)
      segment = get_output_for_node(node)

      if node.is_terminal?
        index += 1
      elsif index < phrase_count
        segment += @delimiter
      end

      yield segment
    end
  end

  def serialize()
    to_hash.to_json
  end


  protected

  def initialize_defaults
    @token_queue = []
    @nodes = { }
    @initial_nodes = [ ]
    @last_node = nil
  end

  def instantiate_node(tokens)
    MarkovNode.new(tokens)
  end

  def get_output_for_node(node)
    node.first_token
  end

  def text_to_tokens(text)
    return text.split(@delimiter)
  end

  def trim_text(text)
    text.gsub(/[\r\n ]+/, ' ').strip
  end

  def last_node_is_terminal
    !@last_node || @last_node.is_terminal?
  end

  def determine_node_terminality(node)
    node.is_terminal = true if is_terminal_character(node.last_character)
    node
  end


  private

  def initialize(
    order = MarkovChain::DEFAULT_ORDER,
    delimiter = MarkovChain::DEFAULT_DELIMITER,
    terminal_characters = MarkovChain::DEFAULT_TERMINAL_CHARACTERS
  )
    @order = order
    @delimiter = delimiter
    @terminal_characters = terminal_characters

    initialize_defaults
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
    @last_node = get_or_create_node(final_tokens)
  end

  def finalize
    clear_token_queue
    @last_node.is_terminal = true
    self
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
    @last_node = node
  end

  def get_node(tokens)
    @nodes[key_from_tokens(tokens)]
  end

  def create_node(tokens)
    node = instantiate_node(tokens)

    add_initial_node(node) if last_node_is_terminal
    @nodes[key_from_tokens(tokens)] = node
    determine_node_terminality(node)
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

  def to_hash
    {
      "initial_nodes" => initial_node_keys,
      "nodes" => nodes_to_hash
    }
  end

  def initial_node_keys
    @initial_nodes.collect do |node|
      node.tokens.join(@delimiter)
    end
  end

  def nodes_to_hash
    @nodes.map { |key, node| [key, node.linked_keys] }.to_h
  end



end

