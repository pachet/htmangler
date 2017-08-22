require_relative "markov-chain"
require_relative "html-node"

class HTMLChain < MarkovChain

  protected

  def instantiate_node(tokens)
    node = HTMLNode.new(tokens)

    key = key_from_tokens(tokens)

    node.is_start_tag = true if is_start_tag_key(key)
    node.is_end_tag = true if is_end_tag_key(key)

    node
  end

  def get_output_for_node(node)
    return '</END>' if node.is_end_tag

    super(node)
  end

  def text_to_tokens(text)
    result = []
    slice_pos = 0
    scan_pos = 1

    while scan_pos < text.length
      char = text[scan_pos]

      scan_pos += 1
      token = nil

      case char
      when ' '
        token = text[slice_pos, scan_pos - slice_pos - 1]
        slice_pos = scan_pos
      when '<'
        token = text[slice_pos, scan_pos - slice_pos - 1]
        slice_pos = scan_pos - 1
      when '>'
        token = text[slice_pos, scan_pos - slice_pos]
        slice_pos = scan_pos
      end

      if token
        token = token.strip
        result.push(token) if token.length > 0
      end

    end

    if scan_pos > slice_pos
      token = text[slice_pos, scan_pos - slice_pos]
      result.push(token)
    end

    result
  end

  private

  def is_start_tag_key(key)
    key[0] == '<' && key[1] != '/'
  end

  def is_end_tag_key(key)
    key[0] == '<' && key[1] == '/'
  end

end

