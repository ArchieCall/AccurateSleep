using AccurateSleep
using Base.Test

# write your own tests here
@testset "sleep_ns" begin
  @test 1 + 1 == 2
  @test 2 + 2 == 4
  @test sleep_ns(.1) < .000001   #-- sleep is inaccurate
  @test_throws ErrorException sleep_ns(.0000001)       #-- sleep_time too low
  @test_throws ErrorException sleep_ns(100_000_000.)   #-- sleep_time too high
  @test_throws ErrorException AccurateSleep.set_threshold(.00099)  #-- threshold too low
  @test AccurateSleep.threshold_default > .00001
  @test AccurateSleep.threshold_default < 0.1
end
