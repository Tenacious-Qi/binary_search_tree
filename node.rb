# frozen_string_literal: true

# creates Node objects for BST
class Node
  include Comparable

  def <=>(other)
    if other.class.is_a?(Node)
      data <=> other.data
    else
      data <=> other
    end
  end

  attr_accessor :data, :left_child, :right_child

  def initialize(data = nil, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end
end
