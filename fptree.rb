class Itemset
	attr_accessor :items
	attr_accessor :support
	
	def initialize (items, support)
		@items = items
		@support = support
	end
end

class FPTree
	attr_accessor :subtrees
	attr_accessor :header_table
	
	def self.root?
		true
	end
end

class Subtree
	attr_accessor :item_name
	attr_accessor :count
	attr_accessor :node_link
	
	def self.root?
		false
	end
end

class Header
	attr_accessor :item_name
	attr_accessor :head
end

def frequent_items (database, itemset, threshold)
	c = Array.new()
	c << []
	itemset.each do |i|
		c[0] << Itemset.new([i], 0)
	end
	f = Array.new()
	f << []
	k = 0
	
	while c[k].size != 0 do
		database.each do |tid, i|
			c[k].each do |x|
				if (x.items - i).empty?
					x.support += 1
				end
			end
		end
		
		c[k].each do |x|
			if x.support >= threshold
				f[k] << x
			end
		end
		
		c << []
		f[k].each do |x|
			xi = x.items
			f[k].each do |y|
				y = y.items
				if x[k] < y[k]
					for iter in 0..k do
						if x[iter] == y[iter]
							i = union(x, [y[k]])
							matches = 0
							f[k].each do |j|
								if (j - i).empty? and j.size == k
									matches += 1
								end
							end
							if matches == f[k].size
								c[k + 1] = union(c[k + 1], i)
							end
						end
					end
				end
			end
		end
		
		f << []
		k += 1
	end
	
	f
end

def construct (database, itemset, support_threshold)
	f = frequent_items(database, itemset, support_threshold)
	
end

database0 = {100 => [:beer, :chips, :wine], 200 => [:beer, :chips], 300 => [:pizza, :wine], 400 => [:chips, :pizza]}
itemset0 = [:beer, :chips, :pizza, :wine]

construct(database0, itemset0, 2)
