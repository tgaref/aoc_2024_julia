module Day13

export day13, readinput

using CombinedParsers

struct Button{T}
    x::T
    y::T
end

struct Position{T}
    x::T
    y::T
end

struct Machine{S,T}
    A::Button{S}
    B::Button{S}
    t::Position{T}
end

function Machine(bA::Button{S}, bB::Button{S}, t::Position{T}) where {S,T}
    Machine{S,T}(bA, bB, t)
end

buttonp = map(Sequence("Button ",
                       ('A' | 'B'),
                       ": X+",
                       Numeric(Int),
                       ", Y+",
                       Numeric(Int))) do (_, type, _, x, _, y)
                           Button(x,y)
                       end
targetp = map(Sequence("Prize: X=",
                       Numeric(Int),
                       ", Y=",
                       Numeric(Int))) do (_, x, _, y)
                           Position(x,y)
                       end
machinep = map(Sequence(buttonp, "\n",
                        buttonp, "\n",
                        targetp, "\n")) do (bA, _, bB, _, t, _)
                            Machine(bA, bB, t)
                        end

function readinput(file)
    input = read(file, String)
    parse(join(Repeat(machinep), '\n'), input)
end

function f1(m,l1,l2,d,j)
    div(m.t.x, d)*(3*l1+l2 + j*(3*div(m.B.x,d)-div(m.A.x,d)))
end

function f2(m,l1,l2,d,j)
    div(m.t.x, d)*(3*l1+l2 + j*(-3*div(m.B.x,d)+div(m.A.x,d)))
end

function cost(m::Machine{S,T}) where {S,T}
    D = m.A.x * m.B.y - m.B.x * m.A.y
    if D != 0
        Da = m.t.x * m.B.y - m.B.x * m.t.y
        Db = m.A.x * m.t.y - m.t.x * m.A.y
#        println("D = $D, Da = $Da, Db = $Db")
        if mod(Da, D) == 0 && mod(Db, D) == 0 && Da * D >=0 && Db * D >= 0
            cst = 3 * div(Da, D) + div(Db, D)
#            println("machine $m --> $cst")
            return cst
        else
            return T(0)
        end
    else
        (d, l1, l2) = gcdx(m.A.x, m.B.x)
        if l1 < 0
            (tmp1, tmp2) = divrem(-l1*d, m.B.x)
            t1 = tmp2 == 0 ? tmp1 : tmp1+1
            t2 = div(l2*d, m.A.x)
            if t1 <= t2 
                min(f1(m, l1, l2, d, t1), f1(m, l1, l2, d, t2))
            else
                T(0)
            end
        else # l1 >= 0
            (tmp1, tmp2) = divrem(-l2*d, m.A.x)
            t1 = tmp2 == 0 ? tmp1 : tmp1+1
            t2 = div(l1*d, m.B.x)
            if t1 <= t2 
                min(f2(m, l1, l2, d, t1), f2(m, l1, l2, d, t2))
            else
                T(0)
            end
        end
    end
end

function day13(::Val{:a})
    machines = readinput("../inputs/13.input")
    sum(cost(m) for m in machines)
end
       
function day13(::Val{:b})
    offset = big(10000000000000)
    machines = readinput("../inputs/13.input")
    machines = map(m -> Machine{Int, BigInt}(m.A, m.B, Position{BigInt}(m.t.x+offset, m.t.y+offset)), machines)
    sum(cost(m) for m in machines)
end
       
end
