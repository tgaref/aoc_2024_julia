module Day19

export day19

using Memoization

function readinput(file)
    towels = map(strip, split(readline(file), ','))
    patterns = split(read(file, String), '\n')[3:end]
    (towels, patterns)
end

function canmakepattern(ts, pattern)
    queue = String[pattern]
    while !isempty(queue)
        p = pop!(queue)
        for front in ts, back in ts            
            if startswith(p, front) && endswith(p, back)
                frontrange = findfirst(front, p)
                backrange = findlast(back, p)
                if frontrange == backrange || length(frontrange) + length(backrange) == length(p)
                    return true
                end
                push!(queue, p[frontrange[end]+1:backrange[1]-1])
            end
        end
    end
    false   
end

function countways(ts, pattern)
    queue = String[pattern]
    cntr = 0
    while !isempty(queue)
        p = pop!(queue)
        for front in ts, back in ts            
            if startswith(p, front) && endswith(p, back)
                frontrange = findfirst(front, p)
                backrange = findlast(back, p)
                if frontrange == backrange || length(frontrange) + length(backrange) == length(p)
                    cntr += 1
                else
                    push!(queue, p[frontrange[end]+1:backrange[1]-1])
                end
            end
        end
    end
    cntr
end

@memoize function cntways(ts, p)
    cnt = big(0)
    for front in ts, back in ts
        if startswith(p, front) && endswith(p, back)
            frontrange = findfirst(front, p)
            backrange = findlast(back, p)
            if frontrange == backrange || length(frontrange) + length(backrange) == length(p)
                cnt += 1
            else
                cnt += cntways(ts, p[frontrange[end]+1:backrange[1]-1])
            end
        end
    end
    return cnt
end

function day19(::Val{:a})
    (towels, patterns) = readinput("../inputs/19.input")
    count(p -> canmakepattern(towels, p), patterns; init=0)
end
       
function day19(::Val{:b})
    (towels, patterns) = readinput("../inputs/19.input")
    sum(cntways(towels, p) for p in patterns; init = big(0))
#=
    for p in patterns
        println(cntways(towels, p))                
    end
    =#
end
       
end
