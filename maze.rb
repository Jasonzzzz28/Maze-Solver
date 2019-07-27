
def read_and_print_simple_file(file)
  line = file.gets
  if line == nil then return end

  # read 1st line, must be maze header
  sz, sx, sy, ex, ey = line.split(/\s/)
  puts "header spec: size=#{sz}, start=(#{sx},#{sy}), end=(#{ex},#{ey})"

  # read additional lines
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] == "path"
      p, name, x, y, ds = line.split(/\s/)
      puts "path spec: #{name} starts at (#{x},#{y}) with dirs #{ds}"

    # otherwise must be cell specification (since maze spec must be valid)
    else
      x, y, ds, w = line.split(/\s/,4)
      puts "cell spec: coordinates (#{x},#{y}) with dirs #{ds}"
      ws = w.split(/\s/)
      ws.each {|w| puts "  weight #{w}"}
    end
  end
end

#----------------------------------
def shortestp(file)
  line = file.gets
  if line == nil then return end
  
  i = 0
  paths = []
  map = Hash.new
  result = Hash.new
  while line = file.gets do
    if line[0...4] == "path"
      p, name, x, y, ds = line.split(/\s/)
      newpath = Path.new(name, x, y, ds)
      paths[i] = newpath
      i= i+1
    else
      x, y, ds, w = line.split(/\s/,4)
      coordinates = []
      coordinates[0] = x.to_i
      coordinates[1] = y.to_i
      newcell = Cell.new(x,y,ds,w)
      map[coordinates] =  newcell
      
    end
  end
  if paths.size == 0
    return []
  end

  for k in paths
    valid =1
    cost = 0
    co = []
    co[0] = k.x.to_i
    co[1] = k.y.to_i
    pnam = k.name
    dirs = k.ds

    
    dirs.split("").each do |i|
      
      ind = map[co].ds.index(i)
      if ind == nil
        valid = 0
        break
      end
      ws = map[co].w.split(/\s/)
        cost = cost + ws[ind].to_f
        if i == "r"
          co[0] = co[0] +1
        elsif i == "l"
          co[0] = co[0] -1
        elsif i == "u"
          co[1] = co[1] -1
        else
          co[1] = co[1] +1
        end
     
      
    end
    if valid == 1
      cost = cost.round(4)
      result[cost] = k
    end
  end
  res = []
  
  if result.size == 0
    return []
  end
  
  result.keys.sort.each {|key| res.push (result[key])}

  #puts res[0]
  coordi = []
  coordi[0] =res[0].x.to_i
  coordi[1] =res[0].y.to_i

  final = []
  cop = []
  cop[0] = res[0].x.to_i
  cop[1] = res[0].y.to_i
  final[0] = cop

  count =1
  res[0].ds.split("").each do |f|
 
    if f == "r"
       coordi[0] = coordi[0] +1
    elsif f == "l"
      coordi[0] = coordi[0] -1
    elsif f == "u"
      coordi[1] = coordi[1] -1
    else
      coordi[1] = coordi[1] +1
    end
    copy = []
    copy[0] = coordi[0]
    copy[1] = coordi[1]
    final[count] = copy
    count = count+1
  end
  #puts final
  return final
    
end


  
class Cell
  attr_accessor :x, :y, :ds, :w
  def initialize(x0, y0, ds0, w0)
    @x = x0
    @y = y0
    @ds = ds0
    @w = w0
  end
end

class Path
  attr_accessor :name, :x, :y, :ds
  def initialize(name0, x0, y0, ds0)
    @name = name0
    @x = x0
    @y = y0
    @ds = ds0
  end
end

def opening (file)
  line = file.gets
  if line == nil then return end
  num = 0 
  while line = file.gets do
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/, 4)
      if ds.length == 4
        num = num +1
      end
    end
  end
  return num
end

def bridge (file)
  line = file.gets
  if line == nil then return end
  num = 0
  while line = file.gets do
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/, 4)
      if /u[a-z]?d|d[a-z]?u|l[a-z]?r|r[a-z]?l/ =~ ds 
        num = num +1
        if /[u,d,l,r][u,d,l,r][u,d,l,r][u,d,l,r]/ =~ ds
          num =num +1
        end
      end
    end
  end
      
  return num  
end

def sortcells (file)
  line = file.gets
  if line == nil then return end
  arr = []
  cells  = []
  count = 0
  while line = file.gets do
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/, 4)
      newcell = Cell.new(x, y, ds, w)
      cells[count] = newcell
      count = count+1
    end
  end
  cells.sort{|left, right| left.ds.length <=> right.ds.length}

  loop =[0,1,2,3,4]
  for k in loop
    res = ""
    res += "#{k}"
    for i in cells
      if i.ds.length == k
        res += ",(#{i.x},#{i.y})"
      end
    end
    arr[k] = res
  end
  return arr
end
        
def paths(file)
  line = file.gets
  if line == nil then return end
  i = 0
  paths = []
  map = Hash.new
  result = Hash.new
  while line = file.gets do
    if line[0...4] == "path"
      p, name, x, y, ds = line.split(/\s/)
      newpath = Path.new(name, x, y, ds)
      paths[i] = newpath
      i= i+1
    else
      x, y, ds, w = line.split(/\s/,4)
      coordinates = []
      coordinates[0] = x.to_i
      coordinates[1] = y.to_i
      newcell = Cell.new(x,y,ds,w)
      map[coordinates] =  newcell
      
    end
  end
  if paths.size == 0
    return "none"
  end
  
  for k in paths
    valid =1
    cost = 0
    co = []
    co[0] = k.x.to_i
    co[1] = k.y.to_i
    pnam = k.name
    dirs = k.ds


    
    dirs.split("").each do |i|

      ind = map[co].ds.index(i)
      if ind == nil
        valid = 0
        break
      end
      ws = map[co].w.split(/\s/)

        cost = cost + ws[ind].to_f
        if i == "r"
          co[0] = co[0] +1
        elsif i == "l"
          co[0] = co[0] -1
        elsif i == "u"
          co[1] = co[1] -1
        else
          co[1] = co[1] +1
        end
     
      
    end
    if valid == 1
      cost = cost.round(4)
      result[cost] = pnam
    end
  end
  res = []
  result.keys.sort.each {|key| res.push ("#{'%10.4f' % key} #{result[key]}")}
  #puts res.split.inspect
  if res.size == 0
    return "none"
  end
  return res
      
    
end

def prettyprinting (file)

  sp = shortestp(file)
  file.rewind
  
  line = file.gets
  if line == nil then return end
  
  
  sz, sx, sy, ex, ey = line.split(/\s/)
  size = sz.to_i
  startx = sx.to_i
  starty = sy.to_i
  start=[]
  start[0] = startx
  start[1] =starty
  
  endx = ex.to_i
  endy = ey.to_i
  endco = []
  endco[0] = endx
  endco[1] = endy
  res = ""
  
  
  map = Hash.new()
  while line = file.gets do
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/,4)
      coordinates = []
      coordinates[0] = x.to_i
      coordinates[1] = y.to_i
      newcell = Cell.new(x,y,ds,w)
      map[coordinates] =  newcell
    end
  end

  #sp = shortestp(file) #return array of coordinates
  
  0.upto(size-1) do |i|
    if i == 0 
      size.times do
        res += "+-"
      end
      res +=  "+"
      res += "\n"
    else
      0.upto(size-1) do |k|
        co=[]
        co[0] = k
        co[1] = i
        res +=  "+"
        if map[co].ds.include?("u")
          res += " "
        else
          res += "-"
        end
      end
      res += "+\n"
    end
    res +=  "|"
    
    0.upto(size-1) do |j|
      cor=[]
      cor[0]= j
      cor[1]= i
      if cor == start
        if sp.size != 0
          if sp.include?(cor)
            res += "S"
          else
            res += "s"
          end
        else
          res += "s"
        end
  

      elsif cor == endco
        if sp.size != 0
          if sp.include?(cor)
            res += "E"
          else
            res += "e"
          end
        else
          res += "e"
        end
     


      else
        if sp.size != 0
          if sp.include?(cor)
            res += "*"
          else
            res += " "
          end
        else
         res += " "
        end
      end
   
     # puts i
     # puts j
     # puts "#{map[cor]} ... #{map[cor].ds}"
      # puts  map[cor]
      if j == size-1
        res += "|\n"
      else
        if map[cor].ds == ""
 
          res += "|"
        elsif map[cor].ds.include?("r")
          res += " "
        else
          res += "|"
        end
      end
    end
  end

  size.times do
    res += "+-"
  end
  res += "+"

  return res
end

def distance(file)
  line = file.gets
  if line == nil then return end
  sz, sx, sy, ex, ey = line.split(/\s/)
  size = sz.to_i
  all = size*size
  start = []
  start[0] = sx.to_i
  start[1] = sy.to_i

  closed = 0

  map = Hash.new
  while line = file.gets do
    if line[0...4] != "path"
      x, y, ds, w = line.split(/\s/, 4)
      coordinates = []
      coordinates[0] = x.to_i
      coordinates[1] = y.to_i
      newcell = Cell.new(x,y,ds,w)
      if ds == ""
        closed = closed + 1
      end
      map[coordinates] =  newcell
    end
  end

  open = all-closed
  distance = Hash.new
  st = []
  st[0] = start[0]
  st[1] = start[1]
  distance [st] = 0
  
  record = []
  record[0] =st
  
  count = 0
  loop do
    count = count +1
    tarr=[]
    if record.size == 0
      break
    end
    record.each do |key|
      map[key].ds.split("").each do |i|
        ind =[]
        ind[0] = key[0]
        ind[1] = key[1]
        if i == "r"
          ind[0] = key[0] +1
        
        elsif i == "l"
          ind[0] = key[0] -1
        
        elsif i == "u"
          ind[1] = key[1] -1
        else
          ind[1] = key[1] +1
        end
        if !record.include?(ind)
          if !distance.has_key?(ind)
            tarr.push(ind)
            distance[ind]=count
          end
        end       
      end
    end
    record.clear
    tarr.each {|x| record.push(x)}
    break if distance.size == open

  end
  res =""

  result = distance.invert
  result.keys.each do |r|
    a = []
    result[r] = a
  end

  
  distance.keys.each do |k|
    num = distance[k]
    result[num].push(k)
  end
  result.keys.each do |u|
    result[u].sort!
  end

  result.keys.each do |q|
    res += "#{q}"
    result[q].each do |ar|
      res += ",(#{ar[0]},#{ar[1]})"
    end
    res += "\n"
  end
  res.chop!
  return res

end

def solve(file)
    line = file.gets
  if line == nil then return end
  sz, sx, sy, ex, ey = line.split(/\s/)

  endx = ex.to_i
  endy = ey.to_i

  file.rewind
  s = distance(file)
  if s.include?("(#{endx},#{endy})")
    return true
  else
    return false
  end
  
end
  
def main(command_name, file_name)
  maze_file = open(file_name)

  # perform command
  case command_name
    
  when "open"
    opening(maze_file)
  
  when "bridge"
    bridge(maze_file)
 
  when "sortcells"
    sortcells(maze_file)

  when "paths"
    paths(maze_file)

  when "print"
    prettyprinting(maze_file)

  when "distance"
    distance(maze_file)
  when "solve"
    solve(maze_file)
  else
    fail "Invalid command"
  end
end

