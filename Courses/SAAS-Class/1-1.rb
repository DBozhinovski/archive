def palindrome?(string)

  clean = string.downcase.scan(/\w/)
  return clean == clean.reverse
  
end

def count_words(string)
  
  frequency_hash = Hash.new(0)
  
  words = string.split(/\b/)
  words.each do|word|
    
    #ignore whitespace and non-alphabet characters when adding occurences
    if word.match(/[a-zA-Z]/)
        frequency_hash[word.downcase] += 1 
    end
  
  end
 
  return frequency_hash
   
end 

