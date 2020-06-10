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

  def initialize(array)
    arr = array.sort
    arr.uniq!
    @root = build_tree(arr)
  end

  def build_tree(array)
    return if array.size.zero?
  
    mid_index = (array.size - 1) / 2
    left = build_tree(array[0...mid_index])
    right = build_tree(array[(mid_index + 1)...array.size])
    node = Node.new(array[mid_index], left, right)
  end

  def insert(value, node = @root)
    if node.nil?
      node = Node.new(value)
    elsif value < node.data
      node.left_child = insert(value, node.left_child)
    else
      node.right_child = insert(value, node.right_child)
    end
    node
  end
end
