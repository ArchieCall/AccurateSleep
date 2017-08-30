using BenchmarkTools
using AccurateSleep
sleep_ns(.2)
sample_sleep_ns(.003,1000)
display(@benchmark sleep_ns(.05))
display(@benchmark sleep_ns(.0001))