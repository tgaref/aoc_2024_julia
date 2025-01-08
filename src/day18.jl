module Day18

export day18

using DataStructures

struct Position
    x::Int
    y::Int
end

struct Grid
    len::Int
    corrupt::Set{Position}
end

function readinput(file)
    corruptions = Position[]
    for line in eachline(file)
        v = map(x -> parse(Int, x), split(line, ','))
        push!(corruptions, Position(v[1], v[2]))
    end
    corruptions
end

function neighbours(grid::Grid, pos::Position)
    nei = Position[]
    for (i,j) in ((-1,0), (1,0), (0,1), (0,-1))
        x = pos.x+i
        y = pos.y+j
        p = Position(x,y)
        if 0 <= x < grid.len && 0 <= y < grid.len && !in(p, grid.corrupt)
            push!(nei, p)
        end
    end
    return nei 
end

function dijkstra(grid::Grid, start::Position, target::Position)
    queue = PriorityQueue{Position, Int}(start => 0)
    tempdist = Dict{Position, Int}()
    dist = Dict{Position, Int}()
    tempdist[start] = 0
    while !isempty(queue)
        (pos, d) = first(queue)
        delete!(queue, pos)
        if haskey(dist, pos)
            continue
        end
        dist[pos] = d
        if pos == target
            return d
        end
        for p in neighbours(grid, pos)
            if haskey(dist, p)
                continue
            end
            if !haskey(tempdist, p)
                tempdist[p] = d + 1
            else 
                tempdist[p] = min(d + 1, tempdist[p])
            end
            queue[p] = tempdist[p]
        end
    end
    nothing
end

function day18(::Val{:a})
    corruptions = readinput("../inputs/18.input")
    t = 1024
    len = 71
    corrupt = Set{Position}()
    for i in 1:t
        push!(corrupt, corruptions[i])        
    end
    grid = Grid(len, corrupt)
    start = Position(0,0)
    target = Position(len-1, len-1)
    dijkstra(grid, start, target)    
end
       
function day18(::Val{:b})
    corruptions = readinput("../inputs/18.input")
    len = 71
    corrupt = Set{Position}(corruptions)
    start = Position(0,0)
    target = Position(len-1, len-1)
    for i in length(corruptions):-1:1
        c = corruptions[i]
        delete!(corrupt, c)
        grid = Grid(len, corrupt)
        if !isnothing(dijkstra(grid, start, target))
            return (c, i)
        end
    end
end
       
end
