module Day20

export day20

using DataStructures

Grid = Matrix{Char}

struct Position
    x::Int
    y::Int
end

struct Input
    grid::Grid
    walls::Set{Position}
    start::Position
    target::Position
end

function readinput(file)
    rows = Vector{Int}[]
    for line in eachline(file)
        push!(rows, collect(line))
    end
    grid = Matrix{Char}(hcat(rows...) |> transpose)
    walls = Set{Position}()
    start = Position(0,0)
    target = Position(0,0)
    for i in 2:size(grid,1)-1, j in 2:size(grid,2)-1
        if grid[i,j] == '#'
            push!(walls, Position(i,j))
        end
        if grid[i,j] == 'S'
            start = Position(i,j)
        elseif grid[i,j] == 'E'
            target = Position(i,j)
        end
    end
    Input(grid, walls, start, target)
end

function neighbours(grid::Grid, pos::Position)
    nei = Position[]
    for (i,j) in ((-1,0), (1,0), (0,1), (0,-1))
        x = pos.x+i
        y = pos.y+j
        p = Position(x,y)
        if grid[x,y] != '#'
            push!(nei, p)
        end
    end
    return nei 
end

function getdistances(grid::Grid, start::Position, target::Position)
    dist = Dict{Position, Int}(start => 0)
    nei = neighbours(grid, start)
    position = filter(p -> !haskey(dist, p), nei)[1]
    dist[position] = 1
    d = 1
    while position != target
        d += 1
        position = filter(p -> !haskey(dist, p), neighbours(grid, position))[1]
        dist[position] = d
    end
    dist    
end

function getball(grid, pos, radius)
    ball = Tuple{Position, Int}[]
    for i in -radius:radius, j in -radius:radius
        x = pos.x + i
        y = pos.y + j
        hamming = abs(i)+abs(j)
        if 1<= x <= size(grid, 1) && 1<= y <= size(grid, 2) && grid[x,y] != '#' && hamming <= radius
            push!(ball, (Position(x,y), hamming))
        end
    end
    ball
end

function day20(::Val{:a})
    input = readinput("../inputs/20.input")
    walls = input.walls
    dist = getdistances(input.grid, input.start, input.target)
    sum(length(filter(t -> dist[t[1]] >= d + 100 + t[2], getball(input.grid, pos, 2))) for (pos, d) in dist; init = 0)
end

function day20(::Val{:b})
    input = readinput("../inputs/20.input")
    walls = input.walls
    dist = getdistances(input.grid, input.start, input.target)
    sum(length(filter(t -> dist[t[1]] >= d + 100 + t[2], getball(input.grid, pos, 20))) for (pos, d) in dist; init = 0)
end
       
end
