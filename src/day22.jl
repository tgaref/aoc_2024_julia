module Day22

export day22

Pattern = Tuple{Int, Int, Int, Int}

function readinput(file)
    map(x -> parse(Int, x), split(read(file, String), '\n'))    
end

function next(s::Int)
    s = mod((s * 64) ⊻ s, 16777216)
    s = mod(div(s, 32) ⊻ s, 16777216)
    mod((s * 2048) ⊻ s,  16777216)
end

function next(s::Int, n::Int)
    for i in 1:n
        s = next(s)
    end
    s
end

function getdigit(s::Int)
    mod(s, 10)
end

function day22(::Val{:a})
    init = readinput("../inputs/22.input")
    suma = 0
    for s in init
        s = next(s, 2000)
        suma += s
    end
    suma
end
       
function shift!(v, a)
    for i in 2:length(v)
        v[i-1] = v[i]
    end
    v[end] = a
end

function day22(::Val{:b})
    init = readinput("../inputs/22.input")
    offers = Dict{Pattern, Int}[]
    for (i, a) in enumerate(init)
        changes = Int[0]
        offer = Dict{Pattern, Int}()
        for _ in 1:3
            b = next(a)
            push!(changes, getdigit(b)-getdigit(a))
            a = b
        end
        for i in 4:2000
            b = next(a)
            shift!(changes, getdigit(b)-getdigit(a))
            a = b
            pattern = (changes[1], changes[2], changes[3], changes[4])
            if !haskey(offer, pattern)
                offer[pattern] = getdigit(b)
            end
        end
        push!(offers, offer)
    end
    all_patterns = Set{Pattern}()
    for offer in offers
        union!(all_patterns, keys(offer))
    end
    best = 0
    for pattern in all_patterns
        this = sum(offer[pattern] for offer in values(offers) if haskey(offer, pattern); init = 0)
        best = max(best, this)
    end
    best
end

end
