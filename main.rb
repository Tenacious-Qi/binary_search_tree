# frozen_string_literal: true

# creates Node objects for BST
class Node
  include Comparable

  def <=>(other)
    data <=> other.data
  end

  attr_accessor :data, :left_child, :right_child

  def initialize(data = nil, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end
end

# creates trees. manages nodes within tree
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
    Node.new(arr[mid_index], left, right)
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

  # removes node if node has no children
  # handles cases where node has only one child
  # if node has two children, finds max value of L subtree.
  # copies that value into node to delete; removes max value or L subtree (temp)
  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left_child = delete(value, node.left_child)
    elsif value > node.data
      node.right_child = delete(value, node.right_child)
    elsif node.left_child.nil? && node.right_child.nil? # node is a leaf
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
      find_node(value, node.left_child)
    else
      find_node(value, node.right_child)
    end
  end

  def height(node = @root)
    return -1 if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    [left_height, right_height].max + 1
  end

  # iterative solution -- returns array of values if no block given
  # def level_order(node = @root, queue = [], display_array = [])
  #   return if node.nil?

  #   queue << node
  #   until queue.empty?
  #     node = queue.first
  #     yield(node) if block_given?
  #     display_array << node.data unless block_given?
  #     queue << node.left_child unless node.left_child.nil?
  #     queue << node.right_child unless node.right_child.nil?
  #     queue.shift
  #   end
  #   block_given? ? yield(node) : display_array
  # end

  # traverses tree in level order. returns array if no block given
  def level_order(node = @root, array = [], level = 0, &block)
    return level_order_block(node, level, &block) if block_given?

    until level > height + 1
      result = push_node_data_to_array(node, level, array)
      level += 1
    end
    result
  end

  # yields to node when level_order is called with a block
  def level_order_block(node = @root, level, &block)
    return if node.nil?

    yield(node)
    level_order_block(node.left_child, level - 1, &block)
    level_order_block(node.right_child, level - 1, &block)
  end

  # returns array of values at each level
  def push_node_data_to_array(node = @root, level = height, array = [])
    return array if node.nil?

    if level == 1
      array << node.data
    else
      push_node_data_to_array(node.left_child, level - 1, array)
      push_node_data_to_array(node.right_child, level - 1, array)
    end
  end

  # visits nodes in preoder <node><left><right>
  def preorder(node = @root, display_array = [], &block)
    if node.nil?
      return display_array unless block_given?

      return
    end

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

  # visits nodes in order <left><node><right>
  def inorder(node = @root, display_array = [], &block)
    if node.nil?
      return display_array unless block_given?

      return
    end

    if block_given?
      inorder(node.left_child, &block)
      inorder(node.right_child, &block)
    else
      inorder(node.left_child, display_array)
      display_array << node.data
      inorder(node.right_child, display_array)
    end
    block_given? ? yield(node) : display_array
  end

  def postorder(node = @root, display_array = [], &block)
    if node.nil?
      return display_array unless block_given?

      return
    end

    if block_given?
      postorder(node.left_child, &block)
      postorder(node.right_child, &block)
    else
      postorder(node.left_child, display_array)
      postorder(node.right_child, display_array)
      display_array << node.data
    end
    block_given? ? yield(node) : display_array
  end

  def balanced?
    left = @root.left_child
    right = @root.right_child
    if height(left) - height(right) > 1 || height(right) - height(left) > 1
      return false
    end

    true
  end

  def rebalance!
    return warn 'Tree is already balanced.' if balanced?

    initialize(level_order)
  end
end

# DRIVER SCRIPT
tree = Tree.new(Array.new(15) { rand(1..100) })

print = proc do
  puts '---LEVEL ORDER---'
  p tree.level_order
  puts
  puts '---PREORDER---'
  p tree.preorder
  puts
  puts '---POSTORDER---'
  p tree.postorder
  puts
  puts '---IN ORDER---'
  p tree.inorder
  puts
end

puts "CHECK IF TREE IS BALANCED: #{tree.balanced?}"
print.call
puts 'TRY TO UNBALANCE TREE'
puts
num1 = rand(101..1000)
num2 = rand(101..1000)
tree.insert(num1)
puts "* #{num1} added to the tree *"
tree.insert(num2)
puts "* #{num2} added to the tree *"
puts
puts "CHECK IF TREE IS BALANCED: #{tree.balanced?}"
puts
tree.rebalance!
puts '* rebalance! method called *'
puts
puts "CHECK IF TREE IS BALANCED: #{tree.balanced?}"
puts
print.call
