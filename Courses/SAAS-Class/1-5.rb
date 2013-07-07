class Class
def attr_accessor_with_history(attr_name)
attr_name = attr_name.to_s # make sure it's a string
attr_reader attr_name # create the attribute's getter
attr_reader attr_name+"_history" # create bar_history getter
class_eval %Q{
                def #{attr_name}= (attr_name)
                  
                if not defined? @#{attr_name}_history
                    @#{attr_name}_history = []
                  end
                  
                  @#{attr_name}_history.push(@#{attr_name})  
                  
                  @#{attr_name} = attr_name
                end  
                
                def #{attr_name}
                  @#{attr_name}
                end
                
                def #{attr_name}_history
                  history = @#{attr_name}_history
                  history.push(@#{attr_name}) #add the current value of @attr_name
                  return history
                end
                    

            }
end
end

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

# class Foo
# attr_accessor_with_history :bar
# attr_accessor_with_history :a
# end
# f = Foo.new
# f.bar = 1
# f.a = "a"

# f.bar = 2
# f.a = 1

#print f.bar_history # => if your code works, should be [nil,1,2]
#print "\n"
#print f.a_history
