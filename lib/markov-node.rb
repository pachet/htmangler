require "byebug"

class MarkovNode

  attr_reader :tokens
  attr_reader :linked_keys
  attr_accessor :is_terminal

  alias is_terminal? is_terminal


  public

  def link_key(key)
    @linked_keys.push(key)
  end

  def random_key
    @linked_keys.sample
  end

  def first_token
    @tokens[0]
  end

  def last_character
    last_token[-1]
  end


  private

  def initialize(tokens)
    @tokens = tokens
    @linked_keys = [ ]
  end

  def last_token
    @tokens[-1]
  end

end

