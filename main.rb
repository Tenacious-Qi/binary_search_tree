require 'pry'
class Node
  include Comparable
  
  def <=> (other_node)
    data <=> other_node.data
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
    @root = build_tree(arr) unless array.nil?
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
    return node if value == node.data

    if value < node.data
      node = find_node(value, node.left_child)
    else
      node = find_node(value, node.right_child)
    end
  end

  # iterative solution -- returns array of values if no block given
  def level_order(node = @root, queue = [], display_array = [])
    return if @root.nil?

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

  # recursive solution -- returns array of values if no block given
  def level_order(node = @root, queue = [], display_array = [], &block)
    return display_array if node.nil? unless block_given?
    return if node.nil?

    queue << node
    node = queue.first
    if block_given?
      level_order(node.left_child, queue[1..-1], &block)
      level_order(node.right_child, queue[1..-1], &block)
    else
      display_array << node.data 
      level_order(node.left_child, queue[1..-1], display_array)
      level_order(node.right_child, queue[1..-1], display_array)
    end
    block_given? ? yield(node) : display_array
  end
end

