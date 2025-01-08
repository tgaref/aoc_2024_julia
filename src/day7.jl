module Day7

using CombinedParsers

export day7

struct Equation
    r::Int128
    v::Vector{Int}
end

eqparser = map(Sequence(Numeric(Int), parser(": "), join(Repeat(Numeric(Int)), " "))) do (a,_,b)
    Equation(a, b)
end
               
function readinput(file)
    equations = Equation[]
    for line in eachline(file)
        push!(equations, parse(eqparser, line))
    end
    equations
end

function check(target::Int128, current::Int128, rest::Vector{Int}, ops)
    if current > target
        return false
    end
    if isempty(rest) && current == target
        return true
    end
    if isempty(rest)
        return false
    end
    any(op -> check(target, op(current, rest[1]), rest[2:end], ops), ops)
end

conc(a, b) =  a * (10^ndigits(b; base = 10)) + b
        
function day7(::Val{:a})
    suma = Int128(0)
    for eq in readinput("../inputs/7.input")
        if check(eq.r, Int128(eq.v[1]), eq.v[2:end], [Base.:+, Base.:*])
            suma += eq.r
        end
    end
    suma
end
       
function day7(::Val{:b})
    suma = Int128(0)
    for eq in readinput("../inputs/7.input")
        if check(eq.r, Int128(eq.v[1]), eq.v[2:end], [Base.:+, Base.:*, conc])
            suma += eq.r
        end
    end
    suma  
end
       
end
