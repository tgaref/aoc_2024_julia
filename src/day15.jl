module Day15

export day15

Grid = Matrix{Char}

struct Input
    rows::Vector{Vector{Char}}
    dir::Vector{Char}
end

function readinput(file)
    room = true
    rows = Vector{Int}[]
    directions = Char[]
    n = 0
    for line in eachline(file)        
        if isempty(line)
            room = false
            continue
        end
        if room
            n = length(line)
#            grid = vcat(grid, collect(line))
            push!(rows, collect(line))
        else
            directions = vcat(directions, collect(line))
        end        
    end
    #    Input(Matrix{Char}(map(Char, (hcat(rows...)|> transpose))), directions)
    Input(rows, directions)
end

function print_grid(grid::Grid)
    for i in 1:size(grid, 1)
        println(String(grid[i,:]))
    end
    println()
end

function step!(::Val{:a}, grid, (x,y), (i,j))
    (X,Y) = (x+i, y+j)
    if grid[X,Y] == '.'
        grid[X,Y] = grid[x,y]
        grid[x,y] = '.'
        return true
    elseif grid[X,Y] != '#'
        if step!(Val(:a), grid, (X,Y), (i,j))
            grid[X,Y] = grid[x,y]
            grid[x,y] = '.'
            return true
        else
            return false
        end
    else
        return false
    end
end

function stepvertically(grid, (x,y), (i,j))
    (X,Y) = (x+i, y+j)
    if grid[X,Y] == '.'
        return true
    elseif grid[X,Y] == '['
        if stepvertically(grid, (X,Y), (i,j)) && stepvertically(grid, (X,Y+1), (i,j))
            return true
        else
            return false
        end
    elseif grid[X,Y] == ']'
        if stepvertically(grid, (X,Y), (i,j)) && stepvertically(grid, (X,Y-1), (i,j))
            return true
        else
            return false
        end
    else
        return false
    end        
end

function step!(::Val{:b}, grid, (x,y), (i,j))
    if i == 0 # moving horizontally, this is identical to part A
        step!(Val(:a), grid, (x,y), (i,j))
    else # moving vertically, this is the interesting case...
        (X,Y) = (x+i, y+j)
        if grid[X,Y] == '.'
            grid[X,Y] = grid[x,y]
            grid[x,y] = '.'
        elseif grid[X,Y] == '['
            step!(Val(:b), grid, (X,Y), (i,j))
            step!(Val(:b), grid, (X,Y+1), (i,j))
            grid[X,Y] = grid[x,y]
            grid[x,y] = '.'
        elseif grid[X,Y] == ']'
            step!(Val(:b), grid, (X,Y), (i,j))
            step!(Val(:b), grid, (X,Y-1), (i,j))
            grid[X,Y] = grid[x,y]
            grid[x,y] = '.'
        end        
    end
end
       
function score(grid::Grid, box::Char)
    s = 0
    for i in 1:size(grid, 1), j in 1:size(grid, 2)
        if grid[i,j] == box
            s += (i-1)*100 + (j-1)
        end
    end
    s
end

function makegrid(rows::Vector{Vector{Char}}; wide=false)
    newrows = Vector{Char}[]
    if wide
        for row in rows
            widerow = Char[]
            for c in row
                if c == '@'
                    push!(widerow, '@')
                    push!(widerow, '.')
                elseif c == 'O'
                    push!(widerow, '[')
                    push!(widerow, ']')
                else
                    push!(widerow, c)
                    push!(widerow, c)
                end
            end
            push!(newrows, widerow)
        end
    else
        newrows = rows
    end
    Matrix{Char}(map(Char, (map(Int, hcat(newrows...))|> transpose)))
end

function findposition(grid::Grid)
    for i in 1:size(grid, 1), j in 1:size(grid, 2)
        if grid[i,j] == '@'
            return (i,j)
        end
    end
end

function day15(::Val{:a})
    input = readinput("../inputs/15.input")
    grid = makegrid(input.rows; wide=false)
    pos = findposition(grid)   
    for dir in input.dir
        (i,j) = if dir == '^'
            (-1,0)
        elseif dir == 'v'
            (1,0)
        elseif dir == '>'
            (0,1)
        else
            (0,-1)
        end        
        if step!(Val(:a), grid, pos, (i,j))
            pos = (pos[1]+i, pos[2]+j)
        end
    end
    score(grid, 'O')
end
       
function day15(::Val{:b})
    input = readinput("../inputs/15.input")
    grid = makegrid(input.rows; wide=true)
    pos = findposition(grid)
    for dir in input.dir
        (i,j) = if dir == '^'
            (-1,0)
        elseif dir == 'v'
            (1,0)
        elseif dir == '>'
            (0,1)
        else
            (0,-1)
        end
        if i == 0 && step!(Val(:b), grid, pos, (i,j))
            pos = (pos[1]+i, pos[2]+j)
        else 
            if stepvertically(grid, pos, (i,j))
                step!(Val(:b), grid, pos, (i,j))
                pos = (pos[1]+i, pos[2]+j)
            end
        end
    end
    score(grid, '[')
end
       
end
