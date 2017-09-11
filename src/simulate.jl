# =====================================================================================================
function simulate(sleep_time::Float64, num_samples::Int, threshold::Float64 = sleep_threshold)
  # ===================================================================================================
  # sample sleep_ns over num_samples using specified threshold
  # ===================================================================================================
  const tics_per_sec = 1_000_000_000.
  v = zeros(num_samples)
  println("\n================================================================")
  @printf("sleep_time (secs) => %8.6f\n", sleep_time )
  @printf("threshold (secs)             => %8.6f\n", threshold )
  @printf("number of samples            => %6i\n", num_samples )
  println(" ... generating sleep_ns samples - please wait...")
  for i = 1:num_samples
    nano3 = time_ns()
    sleep_ns(sleep_time, threshold)
    nano4 = time_ns()
    slept_time  = (nano4 - nano3) / tics_per_sec
    v[i] = slept_time
  end
  nano2 = time_ns()
  mean_time = mean(v)
  median_time = median(v)
  minimum_time = minimum(v)
  maximum_time = maximum(v)
  quant10 = quantile(v, .10; sorted=false)
  quant25 = quantile(v, .25; sorted=false)
  quant50 = quantile(v, .50; sorted=false)
  quant75 = quantile(v, .75; sorted=false)
  quant90 = quantile(v, .90; sorted=false)
  quant95 = quantile(v, .95; sorted=false)
  quant99 = quantile(v, .99; sorted=false)
  quant999 = quantile(v, .999; sorted=false)
  println(" ...results for simulation...")
  println("-------------------------------------------")
  @printf("maximum_time   => %11.9f\n", maximum_time)
  println("-------------------------------------")
  @printf("quantile .999  => %11.9f\n", quant999)
  @printf("quantile .990  => %11.9f\n", quant99)
  @printf("quantile .950  => %11.9f\n", quant95)
  @printf("quantile .900  => %11.9f\n", quant90)
  @printf("quantile .750  => %11.9f\n", quant75)
  @printf("quantile .500  => %11.9f\n", quant50)
  @printf("quantile .250  => %11.9f\n", quant25)
  @printf("quantile .100  => %11.9f\n", quant10)
  @printf("mean_time      => %11.9f\n", mean_time)
  @printf("minumum_time   => %11.9f\n", minimum_time)
  println("------------------------------------------")
  v = 0  #-- reclaim memory from potentially large array
  # FIXME:  is gc really needed
  sleep(1.)
  gc()
  sleep(1.)
  
end
