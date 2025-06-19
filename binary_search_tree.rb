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
    return Node.new(value) if root.nil?
    return root if root.value == value 
    if root.value < value
      root.right_children = insert_value_to_tree(root.right_children, value)
    else
      root.left_children = insert_value_to_tree(root.left_children, value)
    end
    return root 
  end

  def delete(value)
    
    node_to_delete = find_the_node(value)
    if !node_to_delete
      puts "Couldn't find the node to delte"  
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
        # puts "Couldn't find the node to delte"  
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
    inorder_successor = find_inorder_successor(node_to_delete)
    #store the value of inorder successor before we delete the node 
    value_of_inorder_successor = inorder_successor.value
    #delete the inorder successor 
    self.delete(value_of_inorder_successor)
    #assign the value from inorder successor 
    node_to_delete.value = value_of_inorder_successor
    
  end

  def find_inorder_successor(node)
    #go right once and travel left until we can't
  inorder_successor = node.right_children

  until inorder_successor.left_children == nil
    inorder_successor = inorder_successor.left_children
  end

  inorder_successor
  end

  #find that node that has the node with the value as children
  def find_the_parent_node(value)
    parent_node = @root
    until parent_node.left_children&.value == value || parent_node.right_children&.value == value
      if value < parent_node.value
        parent_node = parent_node.left_children
      else
        parent_node = parent_node.right_children
      end
    end
    parent_node
  end
  
end


#test

a= [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
c = [1,2,3,4,5,6,7]
b = Tree.new((Array.new(15) { rand(1..100) }))

b.pretty_print
# b.insert(15)
# b.insert(432432)
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

