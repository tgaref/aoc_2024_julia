module Day12

export day12

Grid = Matrix{Char}
Node = Tuple{Int, Int}

struct Region
    type::Char
    plots::Set{Node}
end

function readinput(file)
    rows = Vector{Int}[]
    for line in eachline(file)
        push!(rows, collect(line))
    end
    Matrix{Char}(hcat(rows...) |> transpose)
end

function neighbors(grid::Grid, (i,j)::Node)
    (m,n) = size(grid)
    nei = Vector{Tuple{Int, Int}}()
    for dir in [(-1,0), (1,0), (0,-1), (0,1)]
        x = dir[1]+i
        y = dir[2]+j
        if 1 <= x <= m && 1 <= y <= n && grid[x,y] == grid[i,j]
            push!(nei, (x,y))
        end
    end
    nei
end

direction = Dict{Tuple{Int, Int}, Symbol}([(-1,0) => :up,
                                           (1,0) => :down,
                                           (0,-1) => :left,
                                           (0,1) => :right])


function dfs(grid::Grid, start::Node)
    queue = [start]
    plots = Set{Node}()
    while !isempty(queue)
        node = pop!(queue)        
        push!(plots, node)
        for n in neighbors(grid, node)
            if !in(n, plots)
                push!(plots, n)
                push!(queue, n)                
            end
        end
    end
    plots
end

function seen(regions::Set{Region}, n::Node)
    for region in regions
        if n in region.plots
            return true
        end
    end
    false
end

function day12(::Val{:a})
    grid = readinput("../inputs/12.input")
    regions = Set{Region}()
    for i in 1:size(grid, 1), j in 1:size(grid, 2)
        if !seen(regions, (i,j))
            plots = dfs(grid, (i,j))            
            push!(regions, Region(grid[i,j], plots))
        end
    end
    suma = 0
    for region in regions
        perimeter = sum(4-length(neighbors(grid, r)) for r in region.plots)
        area = length(region.plots)
        suma += area * perimeter
    end
    suma
end

function partition(v::Vector{Tuple{Symbol, Int, Int}}; by)
    groups = Dict{Int, Vector{Tuple{Symbol, Int, Int}}}()
    for t in v
        groups[by(t)] = push!(get(groups, by(t), []), t)
    end
    groups
end

function group(v::Vector{Tuple{Symbol, Int, Int}}; by)
    v = sort(v; by)
    segments = Int[]
    seg = 1
    for i in 2:length(v)
        if by(v[i]) == by(v[i-1])+1
            seg += 1
        else
            push!(segments, seg)
            seg = 0
        end        
    end
    push!(segments, seg)
    segments
end

function borders(grid::Grid, (i,j)::Node)
    (m,n) = size(grid)
    bs = Tuple{Symbol, Int, Int}[]
    for dir in [(-1,0), (1,0), (0,-1), (0,1)]
        x = dir[1]+i
        y = dir[2]+j
        if !(1 <= x <= m && 1 <= y <= n && grid[x,y] == grid[i,j])
            push!(bs, (direction[dir], x,y))
        end
    end
    bs
end

function day12(::Val{:b})
    grid = readinput("../inputs/12.input")
    regions = Set{Region}()
    for i in 1:size(grid, 1), j in 1:size(grid, 2)
        if !seen(regions, (i,j))
            plots = dfs(grid, (i,j))            
            push!(regions, Region(grid[i,j], plots))
        end
    end
    cost = 0
    for region in regions
        total = 0
        bs = Tuple{Symbol, Int, Int}[]
        for r in region.plots
            bs = vcat(bs, borders(grid, r))
        end
        for dir in (:up, :down)
            b = filter(t -> t[1] == dir, bs)
            d = partition(b; by=t->t[2])
            for v in values(d)
                segments = group(v; by=t->t[3])
                total += length(segments)
            end
        end
        for dir in (:left, :right)
            b = filter(t -> t[1] == dir, bs)
            d = partition(b; by=t->t[3])
            for v in values(d)
                segments = group(v; by=t->t[2])
                total += length(segments)
            end
        end
        cost += length(region.plots) * total
    end
    cost
end
       
end
