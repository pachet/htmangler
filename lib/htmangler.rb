require_relative "markov-chain"

def mangle(text)
  chain = MarkovChain.new

  text.split(' ').each do |word|
    chain.add_token(word)
  end

  chain.finalize

  chain.generate(1) { |value|
    yield value
  }
end

input = $stdin.read

mangle(input) { |segment|
  print segment
}

print "\n\n"

