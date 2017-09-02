#-- 09-02-2017
module AccurateSleep
using BenchmarkTools
include("set_threshold.jl")
include("get_threshold.jl")
default_threshold = get_threshold()
include("sleep_ns.jl")
include("simulate.jl")
include("regulate.jl")
include("demo.jl")
#@show(default_threshold)
export sleep_ns
println(now())
end #-- end of module
