#-- 09-02-2017
module AccurateSleep
using BenchmarkTools
include("set_threshold.jl")
println("you are in AccurateSleep")
include("get_threshold.jl")
default_threshold = get_threshold()
include("sleep_ns.jl")
include("sample_sleep_ns.jl")
include("evaluate_threshold.jl")
include("demo.jl")
#@show(default_threshold)
export sleep_ns
end #-- end of module
