class Dessert
 
attr_accessor :name, :calories  
  
def initialize(name, calories)
  @name = name
  @calories = calories
end

def healthy?
  if @calories < 200
    return true
  end
end

def delicious?
  return true
end
end

class JellyBean < Dessert

attr_accessor :name, :calories, :flavor    
  
def initialize(name, calories, flavor)
  @name = name
  @calories = calories
  @flavor = flavor
end

def delicious?
  if @flavor == "black licorice"
    return false  
  end
  
  return true
end
end

dessert = JellyBean.new("test", 199, "black licorice")
print dessert.healthy?
