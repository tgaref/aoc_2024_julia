module Day21

export day21

using Memoization

struct Position
    x::Int
    y::Int
end

Path = Vector{Char}

function readinput(s::Symbol)
    if s == :test
        ["029A","980A","179A","456A","379A"]
    else
        ["539A","964A","803A","149A","789A"]
    end
end

nchar2pos = Dict{Char, Position}('A' => Position(4,3),
                                  '0' => Position(4,2),
                                  '1' => Position(3,1),
                                  '2' => Position(3,2),
                                  '3' => Position(3,3),
                                  '4' => Position(2,1),
                                  '5' => Position(2,2),
                                  '6' => Position(2,3),
                                  '7' => Position(1,1),
                                  '8' => Position(1,2),
                                  '9' => Position(1,3))

dchar2pos = Dict{Char, Position}('^' => Position(1,2),
                                  'A' => Position(1,3),
                                  '<' => Position(2,1),
                                  'v' => Position(2,2),
                                  '>' => Position(2,3))

function moves(::Val{:numeric}, start::Char, finish::Char)
    from = nchar2pos[start]
    to = nchar2pos[finish]
    horizontal = to.y - from.y
    vertical = to.x - from.x
    mvs = Char[]
    if from.y == 1 && to.x == 4
        mvs = vcat(mvs, collect(repeat('>', horizontal)))       
        mvs = vcat(mvs, collect(repeat('v', vertical)))
    elseif from.x == 4 && to.y == 1
        mvs = vcat(mvs, collect(repeat('^', -vertical)))
        mvs = vcat(mvs, collect(repeat('<', -horizontal)))       
    else        
        if horizontal < 0
            mvs = vcat(mvs, collect(repeat('<', -horizontal)))
        end
        if vertical < 0
            mvs = vcat(mvs, collect(repeat('^', -vertical)))
        end
        if vertical > 0
            mvs = vcat(mvs, collect(repeat('v', vertical)))
        end
        if horizontal > 0
            mvs = vcat(mvs, collect(repeat('>', horizontal)))
        end
    end       
    push!(mvs, 'A')
    mvs
end

function moves(::Val{:directional}, start::Char, finish::Char)
    from = dchar2pos[start]
    to = dchar2pos[finish]
    horizontal = to.y - from.y
    vertical = to.x - from.x
    mvs = Char[]
    if from.y == 1 && to.x == 1 
        mvs = vcat(mvs, collect(repeat('>', horizontal)))
        mvs = vcat(mvs, collect(repeat('^', -vertical)))
    elseif from.x == 1 && to.y == 1        
        mvs = vcat(mvs, collect(repeat('v', vertical)))
        mvs = vcat(mvs, collect(repeat('<', -horizontal)))
    else
        if horizontal < 0
            mvs = vcat(mvs, collect(repeat('<', -horizontal)))
        end
        if vertical > 0
            mvs = vcat(mvs, collect(repeat('v', vertical)))
        end                
        if vertical < 0
            mvs = vcat(mvs, collect(repeat('^', -vertical)))
        end
        if horizontal > 0
            mvs = vcat(mvs, collect(repeat('>', horizontal)))
        end
    end
    push!(mvs, 'A')
    mvs
end

function path(pad::Symbol, code)
    p = Char[]
    pos = 'A'
    for c in code
        p = vcat(p, moves(Val(pad), pos, c))
        pos = c
    end
    p
end

@memoize function len(from::Char, to::Char, n::Int)
    if n == 1
        return 1
    end
    pos = 'A'
    suma = big(0)
    for c in moves(Val(:directional), from, to)
        suma += len(pos, c, n-1)
        pos = c
    end
    suma
end

function day21(::Val{:a})
    codes = readinput(:input)
    cost = 0
    for code in codes
        dcode = path(:numeric, collect(code))
        for _ in 1:2
            dcode = path(:directional, dcode)
        end
#        println("$code : $(length(dcode))")
        cost += length(dcode) * parse(Int, code[1:3])        
    end
    cost
end

function day21(::Val{:b})
    codes = readinput(:input)
    cost = big(0)
    for code in codes
        dcode = path(:numeric, collect(code))
        pos = 'A'
        l = big(0)
        for c in dcode 
            l += len(pos, c, 26)
            pos = c
        end
#        println("$code : $l")        
        cost += l * parse(Int, code[1:3])        
    end
    cost
end
       
end
