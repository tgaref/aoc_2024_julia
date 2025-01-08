using HTTP

function setday(D::Int)
    cookie = Dict("session" => "53616c7465645f5f73436dbc0aa814970c2a64e10f44d3a7bdcfa98dd11aea6db15cd1d7fa4462fa4cdc1fa9525f792ea078e7e90802dae489962022eb698f5a")
    resp = HTTP.request("GET", "https://adventofcode.com/2024/day/$D/input", ["User-Agent" => "tgaref@gmail.com, github.com/tgaref"]; cookies = cookie)
    open("../inputs/$D.input", "w") do io
        write(io, resp.body)
    end

    final = if !isfile("day$D.jl")
        true
    else
        print("File day$D.jl exist. Do you want to overwrite it? [yes/no]: ")
        answer = readline(stdin)
        if answer == "yes"
            print("Are you sure? [yes/no]: ")
            readline(stdin) == "yes" ? true : false
        else
            false
        end        
    end
    if final
        open("day$D.jl", "w") do io
            write(io, """
                 module Day$D
                 
                 export day$D
                        
                 function day$D(::Val{:a})
                            
                 end
                        
                 function day$D(::Val{:b})
                   
                 end
                        
                 end""")
        end
    end
end
