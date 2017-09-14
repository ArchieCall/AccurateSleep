using BenchmarkTools
using AccurateSleep
println("StartUp")
sleep_ns(.1)

tic()
try
  for u = 1:100_000
    sleep_ns(.00001)
  end
catch y
  @printf("...caught error = > %30s\n",y)
end
toc()

tic()
for u = 1:100_000
  sleep_ns(.00001)
end
toc()



println("here")