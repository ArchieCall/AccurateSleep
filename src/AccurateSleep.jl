#-- 08-31-2017
module AccurateSleep
using BenchmarkTools

include("set_threshold.jl")
include("sleep_ns.jl")
include("sample_sleep_ns.jl")
include("evaluate_threshold.jl")
include("demo.jl")
include("StartUp.jl")

default_threshold = set_threshold()
@printf("default_threshold) => %8.4f secs\n", default_threshold)
export sleep_ns
end #-- end of module
