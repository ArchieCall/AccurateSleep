function regulate(num_samples::Int = 100; update::Bool = false, quiet::Bool = true)
  # =================================================================
  # sample Libc.systemsleep(.001) to determine a potential threshold
  # =================================================================
  const tics_per_sec = 1_000_000_000.
  v = zeros(num_samples)
  if !quiet
    println("... generating threshold samples -- please wait ...")
  end
  for i = 1:num_samples
    nano3 = time_ns()
    Libc.systemsleep(.001)
    nano4 = time_ns()
    slept_time  = (nano4 - nano3) / tics_per_sec
    v[i] = slept_time
  end
  quant999 = quantile(v, .999; sorted=false)
  quant995 = quantile(v, .995; sorted=false)
  quant99 = quantile(v, .990; sorted=false)
  quant95 = quantile(v, .950; sorted=false)
  quant90 = quantile(v, .900; sorted=false)
  maxtime = maximum(v)
  meantime = mean(v)
  mediantime = median(v)
  mintime = minimum(v)
  if !quiet
    println("")
    @printf("------------- Results for %5i threshold samples --------------\n", num_samples)
    @printf("            threshold command => Libc.systemsleep(.001)\n")
    @printf("---------------------------------------------------------------\n")
    @printf("maximum         => %7.4f secs\n", maxtime)
    @printf("quantile .999   => %7.4f secs\n", quant999)
    @printf("quantile .995   => %7.4f secs\n", quant995)
    @printf("quantile .99    => %7.4f secs\n", quant99)
    @printf("quantile .95    => %7.4f secs\n", quant95)
    @printf("quantile .90    => %7.4f secs\n", quant90)
    @printf("mean            => %7.4f secs\n", meantime)
    @printf("median          => %7.4f secs\n", mediantime)
    @printf("minimum         => %7.4f secs\n", mintime)
  end
  
  setrounding(Float64, RoundUp)
  suggested_default = round(quant999, 4) + round(.0002,4)
  existing_default = AccurateSleep.get_threshold()
  if !quiet
    @printf("Suggested default_threshold => %7.4f\n", suggested_default)
    @printf("Existing default_threshold  => %7.4f\n", existing_default)
  end
  if update
    set_threshold(suggested_default)
  end
  
  println("--------------------------------------------------------------------\n")
  return suggested_default
end
