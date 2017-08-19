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

mangle($stdin.read) { |segment|
  print segment
}

print "\n"

