using AccurateSleep
using BenchmarkTools
println("done here")
transient_threshold, permanent_threshold = AccurateSleep.get_threshold()
sleep_ns_threshold = transient_threshold #-- use transient as default
sleep_ns(.1)
AccurateSleep.regulate(1000, update = true, quiet = false)
transient_threshold, permanent_threshold = AccurateSleep.get_threshold()
sleep_ns_threshold = permanent_threshold #-- use transient as default
AccurateSleep.simulate(.03, 1000)
