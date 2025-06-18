class Node

  include Comparable
  attr_accessor :left_children , :right_children
  attr_reader :value

  def initialize(value)


    @value = value
    @left_children = nil 
    @right_children = nil 
    
  end
end

module Comparable
  
   
  def compare(node_one, node_two)
    puts "node one's value : #{node_one.value} node two's value : #{node_two.value}"
  end
end


class Tree

  attr_accessor :root
  def initialize(array)

    @sorted_and_no_duplicate_array = array.sort.uniq
    @start = 0
    @end = (@sorted_and_no_duplicate_array.size) -1
    @root = build_tree(@sorted_and_no_duplicate_array, @start, @end)
    
  end

  def build_tree(array, start_index, end_index)
    #when array is empty
    return nil if start_index > end_index 
    

    mid_index = (start_index + end_index) /2
    node = Node.new(array[mid_index])


    node.left_children = build_tree(array,start_index, mid_index -1)
    node.right_children = build_tree(array, mid_index + 1, end_index)
    #return the node
    node
  end

  #tree visualise method from odin project page
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
  end

  def insert(value)
    node = Node.new(value)
    current_node = @root
    #travel until we find the leaf node
    until current_node.left_children == nil && current_node.right_children == nil 
      #when the value is less or EQUAL to current node's value
      if value <= current_node.value 
        current_node = current_node.left_children
      else
        current_node = current_node.right_children
      end
    end
    
    if value < current_node.value
      current_node.left_children = node
    else
      current_node.right_children = node
    end
  end
  
end

a= [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
c = [1,2,3,4,5,6,7]
b = Tree.new(c)

b.pretty_print
b.insert(8)
b.insert(13)
b.insert(3)
b.insert(1)
b.insert(2)
b.insert(2)

b.pretty_print
# puts b.root
# puts b.root.left_children
# puts b.root.right_children

