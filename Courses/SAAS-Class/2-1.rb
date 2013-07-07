class Numeric
  @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'dollar' => 1.000}
  def method_missing(method_id)
    singular_currency = method_id.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
      super
    end
  end
  
  def in(currency)
       singular_currency = currency.to_s.gsub( /s$/, '') #not too DRY, but oh well
       self * @@currencies[singular_currency]
    end  
end


class String
  def palindrome?
    clean = self.downcase.scan(/\w/)
    return clean == clean.reverse
  end
end

module Enumerable 
  def palindrome?
    if self.kind_of?(Array)
      clean = self.join("").downcase.scan(/\w/)
      return clean == clean.reverse
    end 
    
    return false
  end
end

#print 4.rupees.in(:euro)

#check = ["a","1","1","a"].palindrome?

#print check


