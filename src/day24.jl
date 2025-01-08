module Day24

export day24

using CombinedParsers

Wire = String

mutable struct Gate
    type::Symbol
    a::Wire
    b::Wire
    out::Wire
end

State = Dict{Wire, Bool}

struct Input
    inputs::State
    circuit::Vector{Gate}
end

alphanumeric = CharIn('a':'z') | CharIn('0':'9')

wire = map(Sequence(alphanumeric, alphanumeric, alphanumeric)) do t
    collect(t) |> String
end

wirevalue = map(wire * ": " * Numeric(Int)) do (w, _, b)
    (w, b == 1)
end

gatetype = map(Either(" XOR ", " OR ", " AND ")) do t
    if t == " XOR "
        :xor
    elseif t == " OR "
        :or
    elseif t == " AND "
        :and
    end
end

gate = map(wire * gatetype * wire * " -> " * wire) do (a, t, b, _, out)    
    Gate(t, a, b, out)
end

function readinput(file)
    inputs = Dict{Wire, Bool}()
    circuit = Gate[]
    stage = 1
    for line in eachline(file)
        if isempty(line)
            stage = 2
            continue
        end
        if stage == 1
            (w,b) = parse(wirevalue, line)
            inputs[w] = b
        else
            g = parse(gate, line)
            push!(circuit, g)
        end
    end
    Input(inputs, circuit)
end

function compute(type, a, b)
    if type == :xor
        a ⊻ b
    elseif type == :or
        a || b
    else
        a && b
    end
end

function day24(::Val{:a})
    input = readinput("../inputs/24.input")
    state = input.inputs
    circuit = Set(input.circuit)
    outputs = Tuple{Int, Bool}[]
    while !isempty(circuit)
        for gate in circuit
            if haskey(state, gate.a) && haskey(state, gate.b)
                out = compute(gate.type, state[gate.a], state[gate.b])
                state[gate.out] = out
                delete!(circuit, gate)
                if gate.out[1] == 'z'
                    push!(outputs, (parse(Int, gate.out[2:3]), out))
                end
            end
        end
    end
    outputs = sort(outputs; by = t -> t[1], rev = true)
    res = 0
    for t in outputs
        res = res * 2 + t[2]
    end
    res
end

function computecone(circuit, wire)
    cone = Set([wire])
    wires = Set([wire])
    circuit = Set(circuit)
    change = true
    while change
        change = false
        for gate in circuit
            if in(gate.out, wires)
                push!(cone, gate.out)
                push!(wires, gate.a)
                push!(wires, gate.b)
                delete!(circuit, gate)
                change = true 
            end
        end
    end
    cone
end

function genstate(x, y)
    state = Dict{Wire, Bool}()
    for (i, a) in enumerate(x)
        state[string("x", string(i-1; pad=2))] = x[i]
        state[string("y", string(i-1; pad=2))] = y[i]
    end
    state
end

function correctbit(x, y, i)
    a = num(x; base = 2)
    b = num(y; base = 2)
    ds = digits(a+b; base = 2)
    if length(ds) >= i+1
        ds[i+1]
    else
        0
    end
end

function bit(directory, state, wire)
    if haskey(state, wire)
        return state[wire]
    end
    circuit = copy(keys(directory))
    change = true
    while !isempty(circuit) && change
        change = false
        for id in circuit
            gate = directory[id]
            if haskey(state, gate.a) && haskey(state, gate.b)
                out = compute(gate.type, state[gate.a], state[gate.b])
                state[gate.out] = out
                delete!(circuit, id)
                change = true
                if gate.out == wire
                    return out
                end
            end
        end
    end
    nothing
end

function test(directory, wire, i)
    for j in 1:20
        x = rand(Bool, 46)
        y = rand(Bool, 46)
        state = genstate(x,y)
        b = bit(directory, state, wire)
        if b != correctbit(x, y, i)
            return false
        end            
    end
    true
end

function correct(directory, correct_gates, i)
    wire = string("z", string(i; pad = 2))
    for id1 in keys(directory)
        if in(id1, correct_gates)
            continue
        end
        for id2 in keys(directory)
            if in(id2, correct_gates)
                continue
            end
            # swap the wires
            tmp = directory[id1].out
            directory[id1].out = directory[id2].out 
            directory[id2].out = tmp
                        
            t = test(directory, wire, i)

            tmp = directory[id1].out
            directory[id1].out = directory[id2].out 
            directory[id2].out = tmp
            if t 
                println("YEEEES!!! $id1, $id2")
                return (id1, id2)
            end
        end
    end
    println("TZIFOS!")
end

function day24(::Val{:b})
    input = readinput("../inputs/24.input")    
    circuit = input.circuit
    directory = Dict{Wire, Gate}()
    for gate in circuit
        directory[gate.out] = gate
    end
    correct_gates = Set{Wire}()
    wires = Wire[]
    for i in 0:45
        wire = string("z", string(i; pad = 2))
        t = test(directory, wire, i)        
        if !t
            (id1, id2) = correct(directory, correct_gates, i)
            #swap wires
            directory[id1].out = id2
            directory[id2].out = id1
            push!(wires, id1)
            push!(wires, id2)
        end
        cone = computecone(circuit, wire)
        union!(correct_gates, cone)
        if length(wires) == 8
            return join(sort(wires), ',')
        end
    end

end

function num(ds; base = 2)
    foldr((d, acc) -> acc * base + d, ds; init = 0)
end

end
