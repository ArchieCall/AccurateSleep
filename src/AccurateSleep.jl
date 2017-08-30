#-- 08-29-2017
module AccurateSleep
using BenchmarkTools

#---------------------------------------------------------------------------------------------
#    set the default threshold specific to your operating system
#    threshold is set to a value where if julia attemts sleep(.001) secs, then
#    the maximum actual sleep time rarely exceeds the threshold (think quantile = .999)
#    you should run AccurateSleep.evaluate
#---------------------------------------------------------------------------------------------
if is_windows()
  default_threshold = 0.0175  #-- for windows
else
  default_threshold = 0.0020  #-- for linux and mac
end
default_threshold = .0100   #-- you can override the operating system default here
@printf("default_threshold) => %8.4f secs\n", default_threshold)

include("sleep_ns.jl")
include("sample_sleep_ns.jl")
include("evaluate_threshold.jl")
include("demo_sleep_ns.jl")
include("StartUp.jl")



export sleep_ns
export sample_sleep_ns
export evaluate_threshold
export demo_sleep_ns
end #-- end of module
