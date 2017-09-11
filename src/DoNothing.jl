using BenchmarkTools
using AccurateSleep
sleep_ns(.5)  #-- warmup

#-- benchmark Libc.systemsleep to show the jitter
@benchmark Libc.systemsleep(.001)
@benchmark Libc.systemsleep(.01)
@benchmark Libc.systemsleep(.1)
@benchmark Libc.systemsleep(1.0)
@benchmark Libc.systemsleep(10.0)

#-- time sleep_ns using the BenchmarkTools macro
@benchmark sleep_ns(.000001)
@benchmark sleep_ns(.0001)
@benchmark sleep_ns(.001)
@benchmark sleep_ns(.01)
@benchmark sleep_ns(.1)
@benchmark sleep_ns(1.0)
@benchmark sleep_ns(10.0)

#-- time sleep_ns using a simulate function
AccurateSleep.simulate(.000001, 1_000_000)
AccurateSleep.simulate(.0001, 10_000)
AccurateSleep.simulate(.001, 1_000)
AccurateSleep.simulate(.01, 100)
AccurateSleep.simulate(.1, 10)
AccurateSleep.simulate(1.0, 5)
AccurateSleep.simulate(10., 3)
println("DoNothing")