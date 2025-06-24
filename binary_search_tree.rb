class Node

  include Comparable
  attr_accessor :left_children , :right_children, :value

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

    #basically dont include mid value 
    node.left_children = build_tree(array,start_index, mid_index -1)
    node.right_children = build_tree(array, mid_index + 1, end_index)
    #return the node, this will return the 
    #tree's header when recursion ends
    node
  end

  #tree visualise method from odin project page
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
  end
  #refacter this
  def insert(value)

    root_node = @root
    insert_value_to_tree(root_node, value)
    # node = Node.new(value)
    # current_node = @root
    # #travel until we find the leaf node
    # until (current_node.left_children == nil && current_node.right_children == nil ) || current_node.right_children.value > value && current_node
    #   #when the value is less or EQUAL to current node's value move left
    #   if value <= current_node.value 
    #     current_node = current_node.left_children
    #   else
    #     current_node = current_node.right_children
    #   end
    # end

    # #deciding on which side new node gonna be
    # if value < current_node.value 
    #   current_node.left_children = node
    # else
    #   current_node.right_children = node
    # end
  end

  def insert_value_to_tree(root, value)
    #base case return a new node when recursion reaches 
    #the leaf node
    return Node.new(value) if root.nil?
    #stop the recursion if the node with 
    #the value we want to add already exist
    return root if root.value == value

    #travel right if the new node's value is
    #bigger than current node's value 
    if root.value < value
      #this works because eventually the method 
      #will return a new node or node that it already exist 
      #which means it doesnt add a new node
      root.right_children = insert_value_to_tree(root.right_children, value)
    #travel left otherwise 
    else
      root.left_children = insert_value_to_tree(root.left_children, value)
    end
    #return the new added node
    return root 
  end

  def delete(value)
    #first check if the node we want to delete exist
    node_to_delete = find_the_node(value)
    
    if !node_to_delete
      puts "Couldn't find the node to delte"  
    #call different method depends on the number of
    #children the node we want to delete has. 
    elsif number_of_children(node_to_delete) == 0
      delete_node_with_no_children(node_to_delete)
    elsif number_of_children(node_to_delete) == 1
      delete_node_with_one_children(node_to_delete)
    else
      delete_node_with_both_children(node_to_delete)
    end

  end

  def find_the_node(value)
    node_to_find = @root
    until node_to_find.value == value 
      #if there is no matching node 
      if value < node_to_find.value 
        node_to_find = node_to_find.left_children
      elsif value > node_to_find.value
        node_to_find = node_to_find.right_children
      else
        # nil if node with the value we looking for
        #doesn't exist  
        return nil
      end
    end
    node_to_find
  end

  def number_of_children(node)
    if node.left_children == nil && node.right_children == nil
      return 0 
    elsif (node.left_children == nil && node.right_children ) || (node.left_children && node.right_children == nil )
      return 1 
    else
     
      return 2
    end
  end

  def delete_node_with_no_children(node_to_delete)
    #find the parent node 
    parent_node_of_node_to_delete = find_the_parent_node(node_to_delete.value)
    if parent_node_of_node_to_delete.left_children&.value == node_to_delete.value
      parent_node_of_node_to_delete.left_children = nil
    else
      parent_node_of_node_to_delete.right_children = nil
    end
  end

  def delete_node_with_one_children(node_to_delete)
    #get the child node 
    child_node = node_to_delete.left_children || node_to_delete.right_children
    parent_node = find_the_parent_node(node_to_delete.value)

    if parent_node.left_children == node_to_delete
      parent_node.left_children = child_node
    else
      parent_node.right_children = child_node
    end
  end

  def delete_node_with_both_children(node_to_delete)
    preorder_successor = find_preorder_successor(node_to_delete)
    #store the value of preorder successor before we delete the node 
    value_of_preorder_successor = preorder_successor.value
    #delete the preorder successor 
    self.delete(value_of_preorder_successor)
    #assign the value from preorder successor 
    node_to_delete.value = value_of_preorder_successor
    
  end

  def find_preorder_successor(node)
    #go right once and travel left until we can't
  preorder_successor = node.right_children

  until preorder_successor.left_children == nil
    preorder_successor = preorder_successor.left_children
  end

  preorder_successor
  end

  #find that node that has the node with the value as children
  def find_the_parent_node(value)
    parent_node = @root
    # return @root if @root.value == value
    until parent_node.left_children&.value == value || parent_node.right_children&.value == value
      if value < parent_node.value
        parent_node = parent_node.left_children
      else
        parent_node = parent_node.right_children
      end
    end
    parent_node
  end

  def level_order_iteration
    #much better than the first one 
    nodes = [@root]
    values = []
    until nodes.empty?
      current_node = nodes.shift
      values << current_node.value
      nodes << current_node.left_children if current_node.left_children
      nodes << current_node.right_children if current_node.right_children 
    end
    if block_given?
      values.each { |node| yield node}
    else
      values

    end

    
      
    # end
    #-----first try/ eat works but i think i can do better
    # nodes = [@root]
    # child_nodes = []
    # values = []
    # until nodes.empty?
    #   #add all the child nodes from nodes array to child nodes 
    #   nodes.each do |node|
    #     child_nodes << node.left_children if node.left_children
    #     child_nodes << node.right_children if node.right_children
    #   end
    #   #add values of nodes in nodes array to values 
    #   nodes.size.times { values << nodes.shift.value}
    #   nodes = child_nodes
    #   child_nodes = []
    # end

    # values
  end
  # [4, 2, 6, 1, 3, 5, 7]
  # #use flat_map 
  def level_order_recursion(nodes =[@root], values=[])
    #base case when nodes array is empty
    return nil if nodes.empty?

    current_node = nodes.shift
    values << current_node.value 
    
    nodes << current_node.left_children if current_node.left_children
    nodes << current_node.right_children if current_node.right_children
    
    level_order_recursion(nodes,values)
    

    if block_given? 
      values.each {|value| yield value}
    else
      values
    end
    

    # return nil if node.nil?
    
    # array << node.value if node == @root

    # array << node.left_children.value if node.left_children
    # array << node.right_children.value if node.right_children


    # level_order_recursion(node.left_children, array) if node.left_children
    # level_order_recursion(node.right_children, array) if node.right_children

    # return array
  end

  #--preorder,inorder,  postorder
  def preorder(node = @root ,array = [])
    return nil if node.nil?
    
    array << node.value 
    preorder(node.left_children, array) if node.left_children
    preorder(node.right_children, array) if node.right_children

    if block_given?
      array.each { |value| yield value}
    else
      return array
    end
  end

  def inorder(node = @root ,array = [])
    return nil if node.nil?
    
    inorder(node.left_children, array) if node.left_children
    array << node.value 
    inorder(node.right_children, array) if node.right_children

    if block_given?
      array.each { |value| yield value}
    else
      return array
    end
  end

  def postorder(node = @root ,array = [])
    return nil if node.nil?
    
    postorder(node.left_children, array) if node.left_children
    postorder(node.right_children, array) if node.right_children
    array << node.value 

    if block_given?
      array.each { |value| yield value}
    else
      return array
    end
  end

  def height(value)
    #check if node with value we  exist
    node_to_find = find_the_node(value)
    if node_to_find
      find_the_height(node_to_find)
    else
      return nil 
    end
  end

  def find_the_height(node)
    return -1  if node.nil?

    left_height = find_the_height(node.left_children)
    right_height = find_the_height(node.right_children)

    1 + [left_height,right_height].max

    
  end

  def depth(value)
    node_to_find = find_the_node(value)
    if node_to_find
      find_the_depth(node_to_find)
    else
      nil
    end    
  end

  def find_the_depth(node)
    return 0 if node == @root
    
    parent_node = find_the_parent_node(node.value)
    depth_travel = find_the_depth(parent_node)

    1 + depth_travel
  end


end


#test

a= [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
c = [1,2,3,4,5,6,7]
random_array  = (Array.new(15) { rand(1..100) })
d = [1,2,3,4,5]
simple_test = [1,2,3]
b = Tree.new(c)

b.insert(432432)
# b.insert(4324322)
# b.insert(43243223)

b.pretty_print
p b.depth(432432)
# p b.level_order_iteration 
# p b.level_order_recursion 
# 
# p b.preorder
# p b.inorder
# p b.postorder

# p b.height(3)

# b.level_order_recursion { |value| puts value}
# b.insert(15)
# b.insert(534)
# b.insert(645)
# b.insert(423)
# b.insert(123)
# puts "\n \n \n "

# b.pretty_print


# b.delete(1)
# b.delete(7)
# b.insert(8)
#-----------------
# b.delete(4)
# puts "\n \n \n "
# b.pretty_print
# puts "\n \n \n "
# b.delete(6)
# b.pretty_print

# b.pretty_print
# puts b.root
# puts b.root.left_children
# puts b.root.right_children

