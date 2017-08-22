require_relative "markov-chain"
require_relative "html-node"

class HTMLChain < MarkovChain

  protected

  def instantiate_node(tokens)
    HTMLNode.new(tokens)
  end

  def get_output_for_node(node)
    node.is_end_tag ? next_end_tag : super(node)
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

  def last_node_is_terminal
    false
  end

  def determine_node_terminality(node)
    node.is_terminal = false
    node
  end

end

