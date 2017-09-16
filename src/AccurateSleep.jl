#-- 09-16-2017
#=
TODO:
better unit tests
how to turn of linting
should I do a git branch for AccurateSleep project
rename package to HybridSleep?
markdown for README.md
FIXME:
=#
module AccurateSleep
using BenchmarkTools
include("set_threshold.jl")
include("get_threshold.jl")
include("regulate.jl")
threshold_default = get_threshold()
if isapprox(threshold_default, 0.0)
  println("... initial threshold is being calculated ...")
  threshold_default = regulate(2000, update = true, verbose = true)  #-- update threshold
end
include("sleep_ns.jl")
#include("hybrid_sleep.jl")
include("simulate.jl")
#include("demo.jl")
@printf("Stored threshold_default > %8.4f secs\n", threshold_default)
export sleep_ns
end #-- end of module
