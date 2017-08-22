require_relative "html-chain"

def mangle(text)
  HTMLChain.new
    .set_text(text)
    .generate(1) { |value|
      yield value
    }
end

input = $stdin.read

mangle(input) { |segment|
  print segment
}

print "\n\n"

