class Node
  include Comparable
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
    mid_node = Node.new(array[mid_index], left, right)
  end

  def insert(value)
    current = @root
    until current.left_child.left_child.nil? || current.right_child.right_child.nil?
      if value < current.data
        current = current.left_child
        current.left_child.left_child = Node.new(value)
      elsif value > current.data
        current = current.right_child
        current.right_child.right_child = Node.new(value)
      end
    end
  end
end
