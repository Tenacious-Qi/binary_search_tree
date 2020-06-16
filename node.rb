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
