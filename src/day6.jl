module Day6

export day6

struct Coords
    x::Int
    y::Int
end

struct State
    obstacles::Set{Coords}
    pos::Coords
    dir::Tuple{Int, Int}
end

function readinput(file)
    obstacles = Set{Coords}()
    pos = Coords(0,0)
    dir = (0,0)
    rows = 0
    cols = 0
    for (i,line) in enumerate(eachline(file))
        rows += 1
        cols = length(line)
        for j in 1:cols
            if line[j] == '#'
                push!(obstacles, Coords(i,j))
            elseif line[j] == '^'
                pos = Coords(i,j)
                dir = (-1,0)
            elseif line[j] == 'v'
                pos = Coords(i,j)
                dir = (1,0)
            elseif line[j] == '>'
                pos = Coords(i,j)
                dir = (0,1)
            elseif line[j] == '<'
                pos = Coords(i,j)
                dir = (0,-1)
            end            
        end        
    end
    (rows, cols, State(obstacles, pos, dir))
end

function turn(dir)
    if dir == (1,0)
        (0,-1)
    elseif dir == (0,-1)
        (-1,0)
    elseif dir == (-1,0)
        (0,1)
    elseif dir == (0,1)
        (1,0)
    end
end

function step(state::State)
    newpos = Coords(state.pos.x + state.dir[1], state.pos.y + state.dir[2])
    if newpos in state.obstacles
        State(state.obstacles, state.pos, turn(state.dir))
    else
        State(state.obstacles, newpos, state.dir)
    end
end

function simulate(state, rows, cols)
    visited = Set{Tuple{Coords, Tuple{Int, Int}}}()
    while true
        if state.pos.x < 1 || state.pos.x > rows || state.pos.y < 1 || state.pos.y > cols
            return false
        elseif (state.pos, state.dir) in visited
            return true
        else 
            push!(visited, (state.pos, state.dir))
            state = step(state)
        end
    end    
end

function day6(::Val{:a})
    (rows, cols, state) = readinput("../inputs/6.input")
    visited = Set{Coords}()
    while 1 <= state.pos.x <= rows && 1 <= state.pos.y <= cols
        push!(visited, state.pos)
        state = step(state)
    end
    length(visited)
end
       
function day6(::Val{:b})
    (rows, cols, initstate) = readinput("../inputs/6.input")
    result = 0
    prev = Coords(0,0)
    for i in 1:rows, j in 1:cols
        if i == initstate.pos.x && j == initstate.pos.y
            continue
        end
        if Coords(i,j) in initstate.obstacles
            continue
        end
        obs = initstate.obstacles
        delete!(obs, prev)
        prev = Coords(i,j)
        push!(obs, prev)
        state = State(obs, initstate.pos, initstate.dir)
        if simulate(state, rows, cols)
            result += 1
        end
    end
    result
end
       
end
