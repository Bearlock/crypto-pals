# Challenge 1 - Convert hex to base64
# Decoded default hex: I'm killing your brain like a poisonous mushroom
# default hex to base64: SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
defmodule BaseInterface do
  def isNotEmpty(str) do
    str != ""
  end

  def hexToBase64(hex) do
    IO.puts("This is the string I'm gonna transform: #{hex}")
    decodedHex = Base.decode16!(String.trim(hex), case: :mixed)
    IO.puts("\This is the decoded hex string: #{decodedHex}")
    IO.puts("This is it in base64: #{Base.encode64(decodedHex)}\n")
  end
end

defaultHex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
hexString = String.trim(IO.gets("\nHi! I'll transform a hex string to base64 if you have one; if not, hit 'Enter' and I'll use my own: "))

if BaseInterface.isNotEmpty(hexString) do
  BaseInterface.hexToBase64(hexString)
else
  BaseInterface.hexToBase64(defaultHex)
end
