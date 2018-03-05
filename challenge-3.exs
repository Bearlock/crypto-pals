# Challenge 3 - Single-byte XOR Cipher

defmodule ByteCipher do
  use Bitwise

  # This function takes the encoded string, a list of keys, and an accumulator
  # It accumulates the results of attemptCipher()
  # Mind you that it's accumulating things in a slow and expensive way
  # Elixir uses linked lists as the underlying data structure for lists
  # This makes it easy to prepend data, but expensive to append
  def accumulateAttempts(encodedString, [key | keys], decodedList) do
    accumulateAttempts(
      encodedString,
      keys,
      decodedList ++ [attemptCipher(Base.decode16!(String.trim(encodedString), case: :mixed), key, "")]
    )
  end

  def accumulateAttempts(_, [], decodedList), do: decodedList

  # This function takes the binary value of a key and letters
  # from the encoded string and xors them together.
  def attemptCipher(<<head, rest::binary>>, <<key>>, acc) do
    attemptCipher(rest, <<key>>, <<acc::binary, bxor(head, key)>>)
  end

  def attemptCipher("", _, accumulator), do: accumulator

  # This function takes the list of attempts, a comparison/scoring list
  # (vowels in my case) and an accumulator. If one of the xor'd strings
  # doesn't contain a vowel, it gets a score of zero. Otherwise, it'll
  # count the vowels in the string.
  def scoreCipher([head | rest], essentials, scoreAcc) do
    if String.contains?(String.downcase(head) , essentials) do
      scoreCipher(rest, essentials, scoreAcc ++ [countEssentials(String.downcase(head), essentials, 0)])
    else
      scoreCipher(rest, essentials, scoreAcc ++ [0])
    end
  end

  def scoreCipher([], _, scoreAcc), do: scoreAcc

  # This function takes in the encoded string, vowels, and an accumulator
  # It it iterates over the letters and checks if they are a vowel; that
  # becomes a point/partial score. That gets tallied up.
  def countEssentials(letters, [<<essential>> | essentials], score) do
    partialScore = Enum.count(String.codepoints(letters), (fn(<<letter>>) -> letter == essential end))
    countEssentials(letters, essentials, score + partialScore)
  end

  def countEssentials(_, [], score), do: score

  # This returns a nice map of the xor'd string, the letter key, and the score
  def mapIt([key | keys], [score | scores], [attempt | attempts], finalAcc) do
    mapIt(keys, scores, attempts, finalAcc ++ [%{"letter" => key, "score" => score, "result" => attempt}])
  end

  def mapIt([], [], [], finalAcc), do: finalAcc

  # This wraps the other functions in one nice easy to use super function
  def bruteforceCipher(cipher, keys, essentials) do
    attempts = accumulateAttempts(cipher, keys, [])
    scores = scoreCipher(attempts, essentials, [])
    cipherMapList = mapIt(keys, scores, attempts, [])
    determineCorrectCipher(cipherMapList)
  end

  # A helper method to get a list of symbols
  def getSymbols(), do: String.codepoints("!@\#$%^&*()_+{}[]:;<>/?\'\",.|\`\\~-=\n\t\r")

  # This function takes a list of maps and finds the highest scoring map
  def findHighScore([%{"score" => score} | rest], highScore) do
    highScore =
      if score > highScore do
        score
      else
        highScore
      end
    findHighScore(rest, highScore)
  end

  def findHighScore([], highScore), do: highScore

  # This function finds the highest scoring decode attempt. If there was a tie
  # it is (hopefully) broken by filtering out any attempts with symbols
  def determineCorrectCipher(mapList) do
    highScore = findHighScore(mapList, 0)
    final = Enum.filter(mapList, (fn(%{"score" => score}) -> score == highScore end))

    if Enum.count(final) > 1 do
      Enum.filter(final, (fn(%{"result" => enc}) -> !String.contains?(String.downcase(enc), getSymbols()) end))
    end
  end
end

vowels = "aeiou"
letters = "abcdefghijklmnopqrstuvwxyz"
keys = String.codepoints(letters)
essentials = String.codepoints(vowels)
cipher = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

[%{"result" => decodedCipher, "letter" => cipherKey, "score" => score}] = ByteCipher.bruteforceCipher(cipher, keys, essentials)
IO.puts("The key to the cipher was: #{cipherKey}")
IO.puts("The decoded message: #{String.downcase(decodedCipher)}")
IO.puts("It ended up with a score of: #{score}")
