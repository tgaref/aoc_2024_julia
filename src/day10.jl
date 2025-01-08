module Day10

export day10

Grid = Matrix{Int}
Node = Tuple{Int, Int}

function readinput(file)
    rows = Vector{Int}[]
    for line in eachline(file)
        push!(rows, map(c -> parse(Int, c), collect(line)))
    end
    Matrix{Int}(hcat(rows...) |> transpose)
end

function neighbors(grid::Grid, (i,j)::Node)
    (m,n) = size(grid)
    nei = Vector{Tuple{Int, Int}}()
    for dir in [(-1,0), (1,0), (0,-1), (0,1)]
        x = dir[1]+i
        y = dir[2]+j
        if 1 <= x <= m && 1 <= y <= n && grid[x,y] == grid[i,j] + 1
            push!(nei, (x,y))
        end
    end
    nei
end

function dfs(grid::Grid, start::Node)
    queue = [start]
    destinations = Dict{Node, Int}()
    while !isempty(queue)
        node = pop!(queue)
        for n in neighbors(grid, node)
            if grid[n...] == 9
                destinations[n] = get(destinations, n, 0) + 1
            else
                push!(queue, n)
            end
        end
    end
    destinations
end

function day10(::Val{:a})
    grid = readinput("../inputs/10.input")
    sum(length(keys(dfs(grid, (i,j)))) for i in 1:size(grid, 1), j in 1:size(grid, 2) if grid[i,j] == 0)
end
       
function day10(::Val{:b})
    grid = readinput("../inputs/10.input")
    sum(sum(values(dfs(grid, (i,j)))) for i in 1:size(grid, 1), j in 1:size(grid, 2) if grid[i,j] == 0)
end
       
end
