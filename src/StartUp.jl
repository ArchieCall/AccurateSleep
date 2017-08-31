using BenchmarkTools
using AccurateSleep
sleep_ns(.2)
#=
min_actual_sleep = .001
sleep_time = .02
threshold = .0174

if sleep_time > threshold
  #-- do an actual sleep only if sleep_time > threshold
  actual_sleep_time = max(min_actual_sleep, sleep_time - threshold)  #--
  Libc.systemsleep(actual_sleep_time)
end
=#
println("done")