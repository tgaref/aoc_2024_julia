module Day11

export day11, blink

using Memoization

function readinput(file)
    map(x -> parse(Int, x), split(read(file, String), " "))
end

@memoize function leaves(s, n)
    if n == 0
        return 1
    end
    if s == 0
        leaves(1, n-1)
    else
        d = ndigits(s; base = 10)
        if iseven(d)
            (l,r) = divrem(s, 10^div(d,2))
            return leaves(l, n-1) + leaves(r, n-1)
        else
            return leaves(s * 2024, n-1)
        end
    end        
end

function day11(::Val{:a})
    stones = readinput("../inputs/11.input")
    sum(leaves(s, 25) for s in stones)
end
       
function day11(::Val{:b})
    stones = readinput("../inputs/11.input")
    sum(leaves(s, 75) for s in stones)
end
       
end
