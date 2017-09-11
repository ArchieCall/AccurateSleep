using AccurateSleep
using Base.Test

# write your own tests here
@testset "sleep_ns" begin
  @test 1 + 1 == 2
  @test 2 + 2 == 4
  @test sleep_ns(.1) < .0001
  @test AccurateSleep.sleep_threshold > 0.00001
  @test AccurateSleep.sleep_threshold < 0.1
end
