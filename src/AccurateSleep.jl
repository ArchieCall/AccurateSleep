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
export sleep_ns
end #-- end of module
