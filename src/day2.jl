module Day2

export day2, issafe

function issafe(v::Vector{N}) where N<:Integer    
    d = v[1] - v[2]
    d == 0 && return false
    s = d > 0 ? 1 : -1
    for i in 1:length(v)-1
        d = v[i] - v[i+1]
        if s * d < 1 || s * d > 3
            return false
        end
    end
    true
end

function almostsafe(v::Vector{N}) where N<:Integer
    d = v[1] - v[2]
    if abs(d) > 3 || abs(d) < 1
        return (issafe(v[2:end]) || issafe(vcat(v[1], v[3:end])))
    end    
    s = d > 0 ? 1 : -1
    d = v[2] - v[3]
    if s * d < 1 || s * d > 3
        return (issafe(v[2:end]) || issafe(vcat(v[1], v[3:end])) || issafe(vcat(v[1:2], v[4:end])))
    end
    for i in 3:length(v)-2
        d = v[i] - v[i+1]
        if s * d < 1 || s * d > 3
            return (issafe(vcat(v[1:i-1], v[i+1:end])) || issafe(vcat(v[1:i], v[i+2:end])))
        end
    end
    d = v[end-1] - v[end]
    if s * d < 1 || s * d > 3
        return (issafe(vcat(v[1:end-2], v[end])) || issafe(v[1:end-1]))
    end
    true
end

function day2(::Val{:a})
    reports = Vector{Int}[]
    for line in eachline("../inputs/2.input")
        report = map(s -> parse(Int, s), split(line, " "))
        push!(reports, report)
    end
    count(issafe, reports)
end
     
function day2(::Val{:b})
    reports = Vector{Int}[]
    for line in eachline("../inputs/2.input")
        report = map(s -> parse(Int, s), split(line, " "))
        push!(reports, report)
    end
    count(almostsafe, reports)
end
     
end
