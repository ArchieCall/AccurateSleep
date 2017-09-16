function regulate(num_samples::Int = 100; update::Bool = false, verbose::Bool = false)
  # =================================================================
  # sample Libc.systemsleep(.001) to determine suggested threshold
  # =================================================================
  const tics_per_sec = 1_000_000_000.
  v = zeros(num_samples)  #-- setup the sample array v
  if verbose
    println("... generating threshold samples -- please wait ...")
  end
  for i = 1:num_samples
    nano3 = time_ns()
    Libc.systemsleep(.001)  #-- sleep .001 secs
    nano4 = time_ns()
    slept_time  = (nano4 - nano3) / tics_per_sec  #-- actual secs slept
    v[i] = slept_time  #-- put slecpt secs in the array
  end
  #-- compute various quantile stats
  quant999 = quantile(v, .999; sorted=false)
  quant995 = quantile(v, .995; sorted=false)
  quant99 = quantile(v, .990; sorted=false)
  quant95 = quantile(v, .950; sorted=false)
  quant90 = quantile(v, .900; sorted=false)
  quant75 = quantile(v, .750; sorted=false)
  maxtime = maximum(v)
  meantime = mean(v)
  mediantime = median(v)
  mintime = minimum(v)
  if verbose
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
    @printf("quantile .75    => %7.4f secs\n", quant75)
    @printf("mean            => %7.4f secs\n", meantime)
    @printf("median          => %7.4f secs\n", mediantime)
    @printf("minimum         => %7.4f secs\n", mintime)
  end
  
  setrounding(Float64, RoundUp)  #-- set rounding mode
  
  #-- suggestion is .0001 secs greater than quantile .995
  suggested_threshold = round(quant995 + .0001, 4)   
  
  #-- get the previously stored thresholds
  threshold_default = AccurateSleep.get_threshold()
  
  if verbose
    @printf("Stored threshold_default     => %7.4f\n", threshold_default)
    @printf("Suggested threshold_default  => %7.4f\n", suggested_threshold)
    println("--------------------------------------------------------------------\n")
  end
  
  if update
    set_threshold(suggested_threshold)  #-- set the stored threshold_default
    if verbose
      println("Stop and restart Julia for the new threshold to become effective!")
      println(" ")
    end
  end
  return suggested_threshold
end
