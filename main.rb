# frozen_string_literal: true

require_relative 'tree.rb'
require_relative 'node.rb'

# DRIVER SCRIPT
tree = Tree.new(Array.new(15) { rand(1..100) })

print = proc do
  puts '---LEVEL ORDER---'
  p tree.level_order
  sleep(0.5)
  puts
  puts '---PREORDER---'
  p tree.preorder
  sleep(0.5)
  puts
  puts '---POSTORDER---'
  p tree.postorder
  sleep(0.5)
  puts
  puts '---IN ORDER---'
  p tree.inorder
  sleep(0.5)
  puts
end

puts "CHECK IF TREE IS BALANCED: #{tree.balanced?}"
print.call
puts 'TRY TO UNBALANCE TREE'
sleep(0.5)
puts
num1 = rand(101..1000)
num2 = rand(101..1000)
tree.insert(num1)
puts "* #{num1} added to the tree *"
sleep(0.5)
tree.insert(num2)
puts "* #{num2} added to the tree *"
puts
puts "CHECK IF TREE IS BALANCED: #{tree.balanced?}"
sleep(0.5)
puts
tree.rebalance!
puts '* rebalance! method called *'
sleep(0.5)
puts
puts "CHECK IF TREE IS BALANCED: #{tree.balanced?}"
puts
print.call
