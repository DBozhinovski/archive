class CartesianProduct
  include Enumerable
  def initialize(sequence1, sequence2)
    @s1 = sequence1
    @s2 = sequence2
  end
  def each
    @s1.each do |e1|
      @s2.each do |e2|
        yield [e1,e2]
      end
    end
    self
  end
end
