class String
	def numeral?
		!!(self =~ /^[0-9]$/)
	end
end

class Array
	def to_s
		if self.size > 0
			str = self[0].to_s
			for i in (1..self.size - 1)
				str += ", " + self[i].to_s
			end
		else
			str = ""
		end
		"[" + str + "]"
	end
end

class Graph
	attr_accessor :nodes
	
	def initialize
		@nodes = []
	end
	
	def [] (key)
		node = nil
		@nodes.each do |n|
			if n.key == key
				node = n
			end
		end
		node
	end
	
	def []= (key, depends_on)
		depends_on = depends_on.map do |d|
			node = self[d]
			if node == nil
				node = Node.new(d, [])
				@nodes << node
			end
			node
		end
		
		node = self[key]
		if node
			node.depends_on << depends_on
		else
			@nodes << Node.new(key, depends_on)
		end
	end
	
	def needs? (key)
		self[key] == nil
	end
	
	def to_s
		@nodes.to_s
	end
end

class Node
	attr_accessor :key
	attr_accessor :depends_on
	
	def initialize (key, depends_on)
		@key = key
		@depends_on = depends_on
	end
	
	def to_s
		dep_str = @depends_on.map do |d|
			d.key
		end.to_s
		str = "(" + @key + " -> " + dep_str + ")"
	end
end

def dependency_graph (properties)
	deps = Graph.new
	properties = properties.select do |p|
		!!(p =~ /^[A-Z]?[0-9][A-Z]$/)
	end
	
	properties.each do |p|
		if deps.needs?(p)
			if p[0].numeral?
				num = p[0].to_i
				base = p[1]
				if num > 1
					deps[p] = [(num - 1).to_s + base]
				end
			else
				base0 = p[0]
				base1 = p[2]
				if base0 == base1
					deps[p] = ["2" + base0]
				else
					deps[p] = ["1" + base0, "1" + base1]
				end
			end
		end
	end
	
	deps
end

input0 = ["2A", "3A", "2B", "3B", "A5A", "A10A", "A10B", "B5B"]
deps0 = dependency_graph(input0)

puts deps0
