module Day5

export day5, checkpage, getinput, bubbleup!, bubblesort!, lessthan

struct Input
    rules::Dict{Int, Set{Int}}
    pages::Vector{Vector{Int}}
end

function getinput(file)
    rules = Dict{Int, Set{Int}}()
    pages = Vector{Int}[]
    stage = 1
    for line in eachline(file)
        line = strip(line)
        if isempty(line)
            stage = 2
            continue
        end
        if stage == 1
            t = map(x -> parse(Int, x), split(line, '|'))
            rules[t[1]] = push!(get(rules, t[1], Set{Int}()), t[2])            
        else
            push!(pages, map(x -> parse(Int, x), split(line, ',')))
        end
    end
    Input(rules, pages)
end

function checkpage(rules, page)
    for i in 1:length(page)-1
        for j in i+1:length(page)
            if haskey(rules, page[j]) && page[i] in rules[page[j]]
                return false
            end
        end
    end
    true
end

function lessthan(rules, a, b)
    if haskey(rules, a) && b in rules[a]
        true
    else
        false
    end
end

function day5(::Val{:a})
    input = getinput("../inputs/5.input")

    result = 0
    for page in input.pages
        if checkpage(input.rules, page)
            result += page[div(1+length(page), 2)]
        end
    end
    result
end
       
function day5(::Val{:b})
    input = getinput("../inputs/5.input")

    result = 0
    for page in input.pages
        if checkpage(input.rules, page)
            continue
        else
            result += sort(page; lt=(a,b)->lessthan(input.rules, a, b))[div(1+length(page), 2)]
        end
    end
    result
end
       
end
