module AoC_2024_julia

export exec

for d in 1:25
    include("day$d.jl")
end

using .Day1, .Day2, .Day3, .Day4, .Day5, .Day6, .Day7
using .Day8, .Day9, .Day10, .Day11, .Day12, .Day13, .Day14
using .Day15, .Day16, .Day17, .Day18, .Day19, .Day20
using .Day21, .Day22, .Day23, .Day24, .Day25

const days = [day1, day2, day3, day4, day5, day6, day7, day8,
              day9, day10, day11, day12, day13, day14, day15,
              day16, day17, day18, day19, day20, day 21, day22,
              day23, day 24, day25]

function exec(d::Int, part::Symbol)
    println()        
    println("---------  Day $d  ---------")
    r = days[d](Val(part))
    println("part $part: $r")
end

function exec(d::Int)
    println()        
    println("---------  Day $d  ---------")
    println("part a: ", days[d](Val(:a)))
    println("part b: ", days[d](Val(:b)))
end

function exec(ds::AbstractVector{Int})
    for d in ds
        a = days[d](Val(:a))
        b = days[d](Val(:b))
        println()        
        println("---------  Day $d  ---------")
        println("part a: $a")
        println("part b: $b")
    end
end

end # module AoC_2024_julia
