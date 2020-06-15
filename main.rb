require 'pry'
class Node
  include Comparable
  
  def <=> (other)
    data <=> other.data
  end

  attr_accessor :data, :left_child, :right_child

  def initialize(data = nil, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end
end

class Tree
  attr_accessor :root

  def initialize(array = nil)
    @root = build_tree(array) unless array.nil?
  end

  def build_tree(array)
    return if array.size.zero?
    
    arr = array.sort
    arr.uniq!
    mid_index = (arr.size - 1) / 2
    left = build_tree(arr[0...mid_index])
    right = build_tree(arr[(mid_index + 1)...arr.size])
    root = Node.new(arr[mid_index], left, right)
  end

  def insert(value, node = @root)
    if node.nil?
      node = Node.new(value)
      @root = node if @root.nil?
    elsif value < node.data
      node.left_child = insert(value, node.left_child)
    else
      node.right_child = insert(value, node.right_child)
    end
    node
  end

  def delete(value, node = @root)
    return node if node.nil?
    
    if value < node.data
      node.left_child = delete(value, node.left_child)
    elsif value > node.data
      node.right_child = delete(value, node.right_child)
    else
      if node.left_child.nil? && node.right_child.nil? # no children (node is a leaf)
        node = nil
      elsif node.left_child.nil? # node has child on the right
        node = node.right_child
      elsif node.right_child.nil? # node has one child on the left
        node = node.left_child
      else # node has two children
        temp = find_max(node.left_child)
        node.data = temp.data
        node.left_child = delete(temp.data, node.left_child)
      end 
    end
    node
  end

  # finds largest node in left subtree
  def find_max(node)
    return nil if node.nil?
    return find_max(node.right_child) unless node.right_child.nil?

    node
  end

  def find_node(value, node = @root)
    return nil if node.nil?
    return node if value == node.data
  
    if value < node.data
      node = find_node(value, node.left_child)
    else
      node = find_node(value, node.right_child)
    end
  end

  # iterative solution -- returns array of values if no block given
  def level_order(node = @root, queue = [], display_array = [])
    return if node.nil?

    queue << node
    until queue.empty?
      node = queue.first
      yield(node) if block_given?
      display_array << node.data unless block_given?
      queue << node.left_child unless node.left_child.nil?
      queue << node.right_child unless node.right_child.nil?
      queue.shift
    end
    block_given? ? yield(node) : display_array
  end

  # traverses tree in level order. returns array if no block given
  def level_order(node = @root, array = [], level = 1, &block)
    return level_order_block(node, level, &block) if block_given?

    depth = depth(node)
    while level <= depth
      result = push_node_data_to_array(node, level, array)
      level += 1
    end
    result
  end

  def level_order_block(node = @root, level = depth, &block)
    return if node.nil?

    yield(node)
    level_order_block(node.left_child, level - 1, &block)
    level_order_block(node.right_child, level - 1, &block)
  end

  # returns array of values at each level
  def push_node_data_to_array(node = @root, level = depth, array = [])
    return array if node.nil?

    if level == 1
      array << node.data
    else
      push_node_data_to_array(node.left_child, level - 1, array)
      push_node_data_to_array(node.right_child, level - 1, array)
    end
  end

  def preorder(node = @root, display_array = [], &block)
    return display_array if node.nil? unless block_given?
    return if node.nil?

    if block_given?
      preorder(node.left_child, &block)
      preorder(node.right_child, &block)
    else
      display_array << node.data
      preorder(node.left_child, display_array)
      preorder(node.right_child, display_array)
    end
    block_given? ? yield(node) : display_array
  end

  def depth(node = @root)
    return 0 if node.nil?

    depth_left = depth(node.left_child)
    depth_right = depth(node.right_child)
    depth_left > depth_right ? depth_left + 1 : depth_right + 1
  end
end

