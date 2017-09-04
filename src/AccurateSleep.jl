#-- 09-04-2017
#=
TODO:
unit tests
decide on what vars to export
=#
module AccurateSleep
using BenchmarkTools
include("set_threshold.jl")
include("get_threshold.jl")
threshold_transient, threshold_permanent = get_threshold()
@show(threshold_transient)
sleep_ns_threshold = threshold_transient #-- use transient as default

include("sleep_ns.jl")
include("simulate.jl")
include("regulate.jl")
include("demo.jl")
export sleep_ns
end #-- end of module
