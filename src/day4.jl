module Day4

export day4

function count_matches(v)
    str = String(v)
    length(findall("XMAS", str)) + length(findall("SAMX", str))
end

function diagonal(grid::Matrix{T}, start::Tuple{Int, Int}, dir::Tuple{Int, Int}) where T
    (i,j) = start
    diag = T[]
    while 0 < i <= size(grid, 1) && 0 < j <= size(grid, 2)
        push!(diag, grid[i,j])
        i += dir[1]
        j += dir[2]
    end
    diag
end

function day4(::Val{:a})
    rows = Array{Char}[]
    for line in eachline("../inputs/4.input")
        push!(rows, collect(line))
    end
    grid = hcat(rows...)
    result = 0
    #Check lines    
    for i in 1:size(grid, 1)
        result += count_matches(grid[i,:])
    end
    #Check columns
    for j in 1:size(grid, 2)
        result += count_matches(grid[:,j])
    end
    #Check diagonals
    for i0 in 1:size(grid, 1)
        result += count_matches(diagonal(grid, (i0,1), (1,1)))
    end
    for j0 in 2:size(grid, 2)
        result += count_matches(diagonal(grid, (1,j0), (1,1)))
    end
    for j0 in 2:size(grid, 2)
        result += count_matches(diagonal(grid, (1,j0), (1,-1)))
    end
    for i0 in 2:size(grid, 1)
        result += count_matches(diagonal(grid, (i0,size(grid, 2)), (1,-1)))
    end
    result                         
end

function day4(::Val{:b})
    rows = Array{Char}[]
    for line in eachline("../inputs/4.input")
        push!(rows, collect(line))
    end
    grid = hcat(rows...)
    result = 0
    for i in 1:size(grid, 1)-2
        for j in 1:size(grid, 2)-2
            diag1 = String([grid[i, j], grid[i+1, j+1], grid[i+2, j+2]])
            diag2 = String([grid[i, j+2], grid[i+1, j+1], grid[i+2, j]])
            if (diag1 == "MAS" || diag1 == "SAM") && (diag2 == "MAS" || diag2 == "SAM")
                result += 1
            end
        end
    end
    result    
end
       
end
