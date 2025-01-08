module Day25

export day25

Lock = Vector{Int}

Key = Vector{Int}

function readinput(file)
    ls = Set{Lock}()
    ks = Set{Key}()
    block = Int[]
    for line in eachline(file)
        if isempty(line)
            mat = transpose(reshape(block, 5, 7))
            tmp = [count(!iszero, mat[:, j])-1 for j in 1:5]
            if all(iszero, mat[1,:]) && all(!iszero, mat[7,:])
                push!(ks, tmp)
            else 
                push!(ls, tmp)
            end
            block = Int[]
            continue
        end
        line = map(x -> x == '#' ? 1 : 0, collect(line))
        block = vcat(block, line)
    end
    
    (ls, ks)
end

function test(l, k)
    all(l[i]+k[i] <= 5 for i in 1:5)
end

function day25(::Val{:a})
    (ls, ks) = readinput("../inputs/25.input")
    count(test(l,k) for l in ls,  k in ks)
end
       
function day25(::Val{:b})
  
end
       
end
