module Day16

export day16

using DataStructures

Grid = Matrix{Char}

Node = Tuple{Int, Int}

struct State
    node::Node
    dir::Tuple{Int, Int}
end

struct Neighbour
    state::State
    cost::Int
end

function readinput(file)
    rows = Vector{Int}[]
    for line in eachline(file)        
        push!(rows, collect(line))
    end
    Matrix{Char}(map(Char, (hcat(rows...)|> transpose)))
end

function print_grid(grid::Grid)
    for i in 1:size(grid, 1)
        println(String(grid[i,:]))
    end
    println()
end

opposite(dir1, dir2) = dir1[1] * dir2[1] + dir1[2] * dir2[2] == -1

function neighbours(grid::Grid, state::State)
    nei = Neighbour[]
    for (i,j) in ((-1,0), (1,0), (0,1), (0,-1))
        if opposite(state.dir, (i,j))
            continue
        end
        x = state.node[1]+i
        y = state.node[2]+j
        if grid[x,y] == '.' || grid[x,y] == 'E'
            node = (x,y)
            cost = (i,j) == state.dir ? 1 : 1001
            push!(nei, Neighbour(State(node, (i,j)), cost))
        end
    end
    return nei 
end

function dijkstra(grid::Grid, start::State)
    queue = PriorityQueue{State, Int}(start => 0)
    tempdist = Dict{State, Int}()
    dist = Dict{State, Int}()
    tempdist[start] = 0
    while !isempty(queue)
        (state, d) = first(queue)
        delete!(queue, state)
        if haskey(dist, state)
            continue
        end
        dist[state] = d
        for n in neighbours(grid, state)
            if haskey(dist, n.state)
                continue
            end
            if !haskey(tempdist, n.state)
                tempdist[n.state] = d + n.cost
            else 
                tempdist[n.state] = min(d + n.cost, tempdist[n.state])
            end
            queue[n.state] = tempdist[n.state]
        end
    end
    dist
end

function day16(::Val{:a})
    grid = readinput("../inputs/16.input")
    n = size(grid, 1)
    start = (n-1, 2)
    target = (2, n-1)
    minimum(cost for (s,cost) in dijkstra(grid, State(start, (0,1))) if s.node == target)
end

Path = Set{Node}

struct PathCost
    paths::Set{Path}
    cost::Int
end

function minpaths(grid::Grid, start::State, target::Node)
    queue = PriorityQueue{State, Int}(start => 0)
    paths = Dict{State, PathCost}()
    goal = Dict{State, PathCost}()
    temppaths = Dict{State, PathCost}(start => PathCost(Set([[start.node]]), 0))
    while !isempty(queue)
        (state, d) = first(queue)
        delete!(queue, state)
        if haskey(paths, state) && paths[state].cost < state.cost
            continue
        end
        paths[state] = PathCost(temppaths[state].paths, d)
        if state.node == target
            goal[state] = paths[state]
        end
        for n in neighbours(grid, state)
            if haskey(paths, n.state)
                continue
            end
            if !haskey(temppaths, n.state) || temppaths[n.state].cost > d + n.cost
                ps = Set{Path}()
                for p in paths[state].paths
                    tp = push!(copy(p), n.state.node)
                    push!(ps, tp)
                end
                temppaths[n.state] = PathCost(ps, d + n.cost)
            elseif temppaths[n.state].cost == d + n.cost
                for p in paths[state].paths
                    tp = push!(copy(p), n.state.node)
                    push!(temppaths[n.state].paths, tp)
                end
            end
            queue[n.state] = temppaths[n.state].cost
        end
    end
    goal
end

function day16(::Val{:b})
    grid = readinput("../inputs/16.input")
    n = size(grid, 1)
    start = (n-1, 2)
    target = (2, n-1)
    ps = minpaths(grid, State(start, (0,1)), target)
    m = minimum(pathcost.cost for (s, pathcost) in ps)
    goodseats = Set{Node}()
    for (s, pathcost) in ps
        if pathcost.cost == m
            union!(goodseats, pathcost.paths...)
        end
    end
    length(goodseats)
end
       
end
