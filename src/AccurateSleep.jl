#-- 08-31-2017
module AccurateSleep
using BenchmarkTools
include("get_threshold.jl")
default_threshold = get_threshold()
@printf("default_threshold) => %8.4f secs\n", default_threshold)
include("sleep_ns.jl")
include("sample_sleep_ns.jl")
include("evaluate_threshold.jl")
include("demo.jl")
#include("StartUp.jl")

export sleep_ns
end #-- end of module
