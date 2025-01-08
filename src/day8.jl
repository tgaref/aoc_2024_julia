module Day8

export day8

struct Coords
    row::Int
    col::Int
end

struct Antenna
    row::Int
    col::Int
    freq::Char
end

function readinput(file)
    grid = Dict{Char, Vector{Coords}}()
    rows = 0
    cols = 0
    for (i,line) in enumerate(eachline(file))
        rows += 1
        cols = length(line)
        for (j,c) in enumerate(line)
            if c != '.'
                grid[c] = push!(get(grid, c, Vector{Coords}()), Coords(i,j))
            end
        end       
    end
    (rows, cols, grid)
end

function compute_antinodes1(p1, p2, rows, cols)
    x1 = p1.row
    y1 = p1.col
    x2 = p2.row
    y2 = p2.col
    t = if x1 == x2
        (y1,y2) = minmax(y1,y2)
        (Coords(x1, 2*y1-y2), Coords(x1, 2*y2-y1)) 
    else
        (Coords(2*x1-x2, 2*y1-y2), Coords(2*x2-x1, 2*y2-y1))
    end
    anti = Coords[]
    for p in t 
        if 1 <= p.row <= rows && 1 <= p.col <= cols
            push!(anti, p)
        end
    end
    anti
end

function day8(::Val{:a})
    (rows, cols, grid) = readinput("../inputs/8.input")
    antinodes = Set{Coords}()
    for antennas in values(grid)
        for i in 1:length(antennas)
            for j in i+1:length(antennas)
                new_anti = compute_antinodes1(antennas[i], antennas[j], rows, cols)
                union!(antinodes, new_anti)
            end
        end
    end
    length(antinodes)
end

function compute_antinodes2(p1, p2, rows, cols)
    x1 = p1.row
    y1 = p1.col
    x2 = p2.row
    y2 = p2.col
    if x1 == x2
        [Coords(x,y) for y in 1:cols]
    else
        b = div(x2-x1, gcd(x2-x1, y2-y1))
        lower = div(1-x1, b)
        upper = div(rows-x1,b)
        anti = Coords[]
        for k in lower:upper
            y = y1 + div((y2-y1) * k * b, x2-x1)
            if 1 <= y <= cols
                push!(anti, Coords(x1+k*b, y))
            end
        end
        anti
    end
end

function day8(::Val{:b})
    (rows, cols, grid) = readinput("../inputs/8.input")
    antinodes = Set{Coords}()
    for antennas in values(grid)
        for i in 1:length(antennas)
            for j in i+1:length(antennas)
                new_anti = compute_antinodes2(antennas[i], antennas[j], rows, cols)
                union!(antinodes, new_anti)
            end
        end
    end
    length(antinodes)  
end
       
end
