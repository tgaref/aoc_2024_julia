module Day23

export day23

Node = String

Graph = Dict{Node, Set{Node}}
    
function readinput(file)
    graph = Dict{Node, Set{Node}}()
    for line in eachline(file)
        nodes = split(line, '-')
        graph[nodes[1]] = push!(get(graph, nodes[1], Set{Node}()), nodes[2])
        graph[nodes[2]] = push!(get(graph, nodes[2], Set{Node}()), nodes[1])
    end
    graph
end

function triangles(graph, node)
    tri = Set{Set{Node}}()
    for node1 in graph[node], node2 in graph[node]
        if node1 == node2
            continue
        end
        if node2 in graph[node1]
            push!(tri, Set([node, node1, node2]))
        end
    end
    tri
end

function ttriangles(graph)
    tri = Set{Set{Node}}()
    for node in keys(graph)
       if node[1] == 't'
            union!(tri, triangles(graph, node))
       end
    end
    tri
end

function triangles(graph)
    tri = Set{Set{Node}}()
    for node in keys(graph)
        union!(tri, triangles(graph, node))
    end
    tri
end

function subset(set1::Set{T}, set2::Set{T}) where T
    for a in set1
        if !in(a, set2)
            return false
        end
    end
    true
end

function extend(graph::Graph, clique::Set{Node})
    cliques = Set{Set{Node}}()
    for node in keys(graph)
        if subset(clique, graph[node])
            newclique = copy(clique)
            push!(newclique, node)
            push!(cliques, newclique)
        end        
    end
    cliques
end

function maxcliques(graph)
    cliques = gettriangles(graph)
    n = 3
    while true
        n += 1
        newcliques = Set{Set{Node}}()
        for clique in cliques
            union!(newcliques, extend(graph, clique))
        end
        if isempty(newcliques)
            return cliques
        end
        cliques = newcliques
    end    
end

function day23(::Val{:a})
    graph = readinput("../inputs/23.input")
    triangles(graph) |> length
end

function day23(::Val{:b})
    graph = readinput("../inputs/23.input")
    mc = maxcliques(graph)
    join(sort!(collect(collect(mc)[1])), ',')
end
       
end
