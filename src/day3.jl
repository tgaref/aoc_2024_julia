  module Day3

  using CombinedParsers, TextParse
  
  export day3

  mulformparser = Sequence("mul(", Numeric(Int), ",", Numeric(Int), ")")
  prodparser = map(Sequence("mul(", Numeric(Int), ",", Numeric(Int), ")")) do (_,a,_,b,_ )
      a*b
  end
  doparser = parser("do()")
  dontparser = parser("don't()")
  
  function day3(::Val{:a})
      total = 0
      for line in eachline("../inputs/3.input")
          for m in match_all(mulformparser, line)              
              total += parse(prodparser, m.match)
          end
      end
      total
  end
       
  function day3(::Val{:b})
      total = 0
      enabled = true
      for line in eachline("../inputs/3.input")          
          for m in match_all(Either(mulformparser, doparser, dontparser), line)
              if m.match == "do()"
                  enabled = true
              elseif m.match == "don't()"
                  enabled = false
              else
                  if enabled
                      total += parse(prodparser, m.match)
                  end
              end
          end
      end
      total
  end
       
  end
