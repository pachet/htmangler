require_relative "markov-chain"

def mangle(text)
  chain = MarkovChain.new

  text.split(' ').each do |word|
    chain.add_token(word)
  end

  chain.generate do |value|
    yield value
  end
end

mangle('a a b a b a c a b d a b a c c b a d e f d a b d e f a b d e f c c e f c c c b c c c f b f b f b') { |word|
  puts word
}

