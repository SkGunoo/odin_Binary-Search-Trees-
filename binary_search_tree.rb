class Node

  include Comparable
  attr_reader :value

  def initialize(value)


    @value = value
    @left_children = nil 
    @right_choldren = nil 
    
  end
end

module Comparable
  
   
  def compare(node_one, node_two)
    puts "node one's value : #{node_one.value} node two's value : #{node_two.value}"
  end
end


class Tree
  
  def initialize(array)

    @root = build_tree(array)
    
  end

  def build_tree(array)
    
  end
end


