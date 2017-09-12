using AccurateSleep
using BenchmarkTools
println("StartUp")
sleep_ns(.1)
tic()
a = 0
for i = 1:1_000_000
  sleep_ns(.000001)
  a += 1
end
toc()
@show(a)

tic()
a = 0
for i = 1:1_000_000
  sleep_ns(.000001) < 0.0 && break
  a += 1
end
toc()
@show(a)