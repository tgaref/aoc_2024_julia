module Day14

export day14

using CombinedParsers

struct Position{T}
    x::T
    y::T
end

struct Velocity{T}
    x::T
    y::T
end

struct Robot{T}
    pos::Position{T}
    v::Velocity{T}
end

tuplep = map(Sequence(Numeric(Int), ',', Numeric(Int))) do (a, _, b)
    (a,b)
end

positionp = map(Sequence("p=", tuplep)) do (_, t)
    Position(t[1], t[2])
end

velocityp = map(Sequence("v=", tuplep)) do (_, t)
    Velocity(t[1], t[2])
end

robotp = map(Sequence(positionp, ' ', velocityp)) do (p, _, v)
    Robot(p, v)
end

function readinput(file)
    robots = Robot[]
    for line in eachline(file)
        push!(robots, parse(robotp, line))
    end
    robots
end

function step(r::Robot, n::Int, X::Int, Y::Int)
    Robot(Position(mod(r.pos.x + n * r.v.x, X), mod(r.pos.y + n * r.v.y, Y)), r.v)
end

function print_map_str(robots::Vector{Robot{T}}, X::Int, Y::Int) where T<:Integer
    ds = Dict{Position, Int}()
    for r in robots
        ds[r.pos] = get(ds, r.pos, 0) + 1
    end
    for y in 0:Y-1
        for x in 0:X-1
            p = Position(x,y) 
            if p in keys(ds)
                print(ds[p])
            else
                print(' ')
            end
        end
        println()
    end
    println()
end

function quadrant(p::Position, X::Int, Y::Int)
    midX = div(X, 2)
    midY = div(Y, 2)
    if p.y <= midY - 1
        if p.x <= midX - 1
            return 1
        elseif p.x > midX
            return 2
        end
    elseif p.y > midY
        if p.x <= midX - 1
            return 3
        elseif p.x > midX
            return 4
        end
    end
    return 0
end

function day14(::Val{:a})
    robots = readinput("../inputs/14.input")
    (Y,X) = (103,101)
    midY = div(Y, 2) + 1
    midX = div(X, 2) + 1
    n = 100
   
    positions = map(r -> step(r, n, X, Y).pos, robots)
    quadrants = [0,0,0,0]    
    for p in positions
        q = quadrant(p, X, Y)
        if q > 0
            quadrants[q] += 1
        end
    end
    prod(quadrants; init = big(1))
end

function search(robots::Vector{Robot{T}}, X::Int, Y::Int) where T<:Integer
    grid = reshape([' ' for _ in 1:Y*X], Y, X)
    for r in robots
        grid[r.pos.y+1, r.pos.x+1] = '#'
    end
    for x in 1:X
        if !isnothing(findfirst("############################", String(grid[:,x])))
            return true
        end
    end
    false
end

function day14(::Val{:b})
    robots = readinput("../inputs/14.input")
    (Y,X) = (103,101)
    found = false
    i = 0
    while true
        robots = map(r -> step(r, 1, X, Y), robots)
        i += 1
        if search(robots, X, Y)
            print_map_str(robots, X, Y)
            return i
        end
    end
end
       
end
