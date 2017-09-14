#-- 09-14-2017
#=
TODO:
better unit tests
should I do a branch for AccurateSleep project
finish off min-max sleep_time errors and min threshold error
rename SleepTime to sleep_time
markdown for README.md
=#
module AccurateSleep
using BenchmarkTools
include("set_threshold.jl")
include("get_threshold.jl")
include("regulate.jl")
sleep_threshold = get_threshold()
if isapprox(sleep_threshold, 0.0)
  println("... initial threshold is being calculated ...")
  sleep_threshold = regulate(2000, update = true, verbose = true)  #-- update threshold
end
include("sleep_ns.jl")
include("hybrid_sleep.jl")
include("simulate.jl")
include("demo.jl")
@printf("Stored sleep_threshold > %8.4f secs\n", sleep_threshold)
export sleep_ns
end #-- end of module
