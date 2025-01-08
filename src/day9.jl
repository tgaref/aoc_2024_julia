module Day9

export day9, day9old, test

mutable struct Sig
    pos::Int
    nblocks::Int
    id::Int
end

mutable struct Space
    pos::Int
    nspace::Int
end

function readinput(file)
    input = read(file, String)
    map(x -> parse(Int, x), collect(input))
end

function day9(::Val{:a})
    input = readinput("../inputs/9.input")

    disc = Int[]
    id = 0
    for (i,n) in enumerate(input)
        if isodd(i)
            for j in 1:n
                push!(disc, id)
            end
            id += 1
        else
            for j in 1:n
                push!(disc, -1)
            end
        end        
    end

    front = 1
    back = length(disc)
    while disc[front] >= 0
            front += 1
    end
    while disc[back] < 0
            back -= 1
    end
    while front < back
        disc[front] = disc[back]
        disc[back] = -1
        while disc[front] >= 0
            front += 1
        end
        while disc[back] < 0
            back -= 1
        end        
    end

    checksum = 0
    for i in 1:back
        checksum += (i-1) * disc[i]
    end
    checksum
end

function day9(::Val{:b})
    disc = readinput("../inputs/9.input")
    files = [Sig(0,disc[1],0)]
    space = Space[]
    pos = disc[1]
    id = 1
    for i in 2:2:length(disc)
        push!(space, Space(pos, disc[i]))
        push!(files, Sig(pos+disc[i], disc[i+1], id))
        pos += disc[i] + disc[i+1]
        id += 1
    end
    sort!(files; by=sig->sig.id, rev=true)
#    println(space)
#    print_files(files)
#    println("--------------------------------------------")
    for sig in files
        for s in space
            if s.nspace >= sig.nblocks && s.pos < sig.pos
                sig.pos = s.pos
                s.pos += sig.nblocks
                s.nspace -= sig.nblocks
#                print_files(files)
                break
            end
        end
    end
    
    checksum = Int128(0)
    for sig in files
        checksum += div(sig.nblocks*(2*sig.pos+sig.nblocks-1), 2) * sig.id
    end
#    print_files(files)
    checksum
end

function print_files(files)
    files = sort(files; by=sig->sig.pos)
    l = length(files)
    for i in 1:l-1 
        for j in 1:files[i].nblocks
            print(files[i].id)
        end
        for j in 1:files[i+1].pos-files[i].pos-files[i].nblocks
            print(".")
        end        
    end
    for j in 1:files[end].nblocks
        print(files[end].id)
    end
    println()
end

end
