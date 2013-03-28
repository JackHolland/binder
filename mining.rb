class Itemset
	attr_accessor :items
	attr_accessor :support
	
	def initialize (items, support)
		@items = items
		@support = support
	end
end

def union (x, y)
	u = x.map do |i|
		i
	end
	y.each do |i|
		if not u.include?(i)
			u << i
		end
	end
end

def strict_subset (x, y)
	(x - y).size == 0 and x.size < y.size
end

def itemset_mine (database, itemset, threshold)
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
				f[k] << x.items
			end
		end
		
		c << []
		f[k].each do |x|
			f[k].each do |y|
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

def association_rule_mine (database, itemset, support_threshold, confidence_threshold)
	def support_count (x, db)
		support = db.select do |i, t|
			(x - t).size == 0
		end
		support.size
	end
	
	def confidence (x, y, db)
		sc1 = support_count(union(x, y), db)
		sc2 = support_count(x, db)
		if sc2 == 0
			0
		else
			sc1 / sc2
		end
	end
	
	f = itemset_mine(database, itemset, support_threshold)
	r = []
	
	f.each do |i|
		r = union(r, i)
		c = []
		c[0] = i.map do |j|
			j
		end
		k = 0
		h = []
		
		while c[k].size != 0 do
			h[k] = c[k].select do |x|
				confidence(i - x, x, database) >= confidence_threshold
			end
			
			c << []
			h[k].each do |x|
				h[k].each do |y|
					if x[k] < y[k]
						match = true
						for iter in 0..k do
							if x[i] != y[i]
								match = false
							end
						end
						if match
							i = union(x, [y[k]])
							h[k].each do |j|
								if strict_subset(j, i)
									c[k + 1] = union(c[k + 1], i)
								end
							end
						end
					end
				end
			end
			
			k += 1
			h << []
		end
		
		x = h.map do |i|
			i
		end
		r = union(r, (i - x))
	end
	
	r
end

database0 = {100 => [:beer, :chips, :wine], 200 => [:beer, :chips], 300 => [:pizza, :wine], 400 => [:chips, :pizza]}
itemset0 = [:beer, :chips, :pizza, :wine]

#puts itemset_mine(database0, itemset0, 2)
#puts association_rule_mine(database0, itemset0, 2, 2)
