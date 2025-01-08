module Day17

export day17

mutable struct Register{T}
    A::T
    B::T
    C::T
end

function readinput(t::Symbol)
    if t == :test
        (Register{Int}(2024, 0, 0), [0,3,5,4,3,0])
    else
        (Register{Int}(56256477, 0, 0), [2,4,1,1,7,5,1,5,0,3,4,3,5,5,3,0])
    end
end

function evaluate!(opcode::Int, operand::T, reg::Register{T}, ptr::Int) where T<:Integer
    if opcode == 0
        reg.A = div(reg.A, 2^operand)
        (nothing, ptr + 2)
    elseif opcode == 1
        reg.B = reg.B ⊻ operand
        (nothing, ptr + 2)
    elseif opcode == 2
        reg.B = mod(operand, 8)
        (nothing, ptr + 2)
    elseif opcode == 3
        if reg.A == 0
            (nothing, ptr + 2)
        else
            (nothing, operand)
        end
    elseif opcode == 4
        reg.B = reg.B ⊻ reg.C
        (nothing, ptr + 2)
    elseif opcode == 5        
        (mod(operand, 8), ptr + 2)
    elseif opcode == 6
        reg.B = div(reg.A, 2^operand)
        (nothing, ptr + 2)
    elseif opcode == 7
        reg.C = div(reg.A, 2^operand)
        (nothing, ptr + 2)
    else
        error("Unrecognized opcode $opcode")
    end        
end

function combo(t::T, reg::Register{T}) where T<:Integer
    if 0 <= t <= 3
        t
    elseif t == 4
        reg.A
    elseif t == 5
        reg.B
    elseif t == 6
        reg.C
    end
end

function day17(::Val{:a})
    (reg, instructions) = readinput(:input)
    ptr = 0
    output = Int[]
    while ptr < length(instructions)
        opcode = instructions[ptr+1]
        t = instructions[ptr+2]
        operand = opcode in Set{Int}([0, 2, 5, 6, 7]) ? combo(t, reg) : t
        (out, ptr) = evaluate!(opcode, operand, reg, ptr)
        if !isnothing(out)
            push!(output, out)
        end
    end
    join(map(string, output), ',')
end

function compute(v)
    vals = Int[]
    queue = Tuple{Int, Vector{Int}}[]
    push!(queue, (0, v))
    while !isempty(queue)
        (A, v) = pop!(queue)
        for a in 0:7
            tmp = a + 8*A
            B = mod(a ⊻ 4 ⊻ div(tmp, 2^(a ⊻ 1)), 8)
            if B == v[end]
                if length(v) == 1
                    push!(vals, tmp)
                else
                    push!(queue, (tmp, v[1:end-1]))
                end
            end
        end
    end
    sort(vals)
end

function day17(::Val{:b})
    (reg, instructions) = readinput(:input)
    compute(instructions)[1]
end
       
end
