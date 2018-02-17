# Challenge 2 - Fixed XOR
# Decoded default strings XOR'd against each other: the kid don't play
# Encoded XOR'd string: 746865206b696420646f6e277420706c6179
defmodule Xorro do
  use Bitwise
  def areSameLength(str1, str2) do
    String.length(str1) == String.length(str2)
  end

  def xorText(<<headA, restA::binary>>, <<headB, restB::binary>>, accumulator) do
    xorText(restA, restB, <<accumulator::binary, bxor(headA, headB)>>)
  end

  def xorText("", "", accumulator) do
    accumulator
  end

  def fixedXor(str1, str2) do
    IO.puts("\nHere is your input: \n#{str1}\n#{str2}")
    IO.puts("\nChecking that they're the same length")
    if areSameLength(str1, str2) do
      IO.puts("They're the same length!\n")
      xorroText = xorText(Base.decode16!(String.trim(str1), case: :mixed), Base.decode16!(String.trim(str2), case: :mixed), "")
      IO.puts("Here is the XOR'd text: #{xorroText}")
      Base.encode16(xorroText, case: :lower)
    else
      IO.puts("Exiting, not the same length")
    end
  end
end

defaultString1 = "1c0111001f010100061a024b53535009181c"
defaultString2 = "686974207468652062756c6c277320657965"

IO.puts("Gonna run this with hardcoded values")
IO.puts("The encoded text: #{Xorro.fixedXor(defaultString1, defaultString2)}")
