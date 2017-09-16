using BenchmarkTools
using AccurateSleep
println("StartUp")
sleep_ns(.1)
function goober()
  println("before first call")
  @show(sleep_ns(1))
  println("@benchmark sleep_ns(.04)")
  display(@benchmark sleep_ns(.04))
  #sleep_ns(.1, -2.0)
  @printf("\nafter call that errors out - this line should not have executed!\n")
end
#goober()

println("done")