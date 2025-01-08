module Day1

export day1

function day1(::Val{:a})
    list1 = Int[]
    list2 = Int[]
    for line in readlines("../inputs/1.input")
        (num1, num2) = split(line, "   ")
        push!(list1, parse(Int, num1))
        push!(list2, parse(Int, num2))              
    end
    sort!(list1)
    sort!(list2)
    sum(map((a, b) -> abs(a-b), list1, list2))
end

function day1(::Val{:b})
    list = Int[]
    dict = Dict{Int, Int}()
    for line in readlines("../inputs/1.input")
        (a, b) = split(line, "   ")
        push!(list, parse(Int, a))
        n = parse(Int, b)
        dict[n] = get(dict, n, 0) + 1
    end
    result = 0
    for n in list
        result += n * get(dict, n, 0)
    end
    result
end
     
end
