function demo()
  #=
  Usage of functions
  =====================================================================
  sleep_ns(sleep_time::Float64, threshold::Float64 = default_threshold)
  =====================================================================
  .. sleep for specified sleep_time seconds using specified threshold
  .. sleep_time >= .000001 and sleep_time <= 86_400_000.
  .. threshold >= .001 seconds
  ........................ sample of usage .............................
  .. sleep_ns(.03)       - sleep .03 seconds using stored threshold value
  .. sleep_ns(.03, .017) - sleep .03 seconds using threshold of .017
  .. sleep_ns(1.0)       - sleep 1 second
  .. sleep_ns(.000001)   - sleep 1 microsecond
  
  ====================================================================
  evaluate_threshold(num_samples::Int = 5000, store_threshold = false)
  ====================================================================
  .. evaluate num_samples of Libc.systemsleep(.001)
  .. produces quantiles for various groupings of the samples
  .. quantile = .999 is a good estimate for the threshold
  .. the returned value is the threshold value which yields quantile .999
  .. if store_threshold = true, store the returned value
  '''
  =#

  for q = 1:1
    println("accurately sleep for .1 secs")
    ans = sleep_ns(.1)          #-- sample of an accurate sleep of .1 seconds
    @printf("slept for %12.9f seconds\n", ans + .1 )
    display(@elapsed Libc.systemsleep(.1))
    display(@elapsed sleep_ns(.1))
    display(@benchmark sleep_ns(.000001))
    AccurateSleep.sample_sleep_ns(.000001, 10000)
    return
    suggested_default = AccurateSleep.evaluate_threshold(1000)     #--- evaluate potential default_threshold values
    @printf("suggested_default => %9.4f\n", suggested_default)
    AccurateSleep.sample_sleep_ns(.05, 200, suggested_default)
    display(@benchmark Libc.systemsleep(.05))
    display(@benchmark sleep_ns(.05))
    for i = 1:200
      over = sleep_ns(.05, .017)
      @printf("iter => %3i secs over => %16.9f\n",i, over)
    end
    
    #=
    #for sleep_time in (.2, .1, .05, .02, .01, .005, .001, .0001, .00001, .000001)
    for sleep_time in (.2, .1, .05)
      NumSecs = 30.0
      # NumIters = convert(Int64, round(NumSecs / sleep_time, 0))
      AccurateSleep.sample_sleep_ns(sleep_time, NumIters)
    end
    
    display(@benchmark sleep_ns(.001))
    display(@benchmark sleep_ns(.0001))
    display(@benchmark sleep_ns(.000001))
    =#
    #AccurateSleep.sample_sleep_ns(.030, 1000)
    #AccurateSleep.sample_sleep_ns(.030, 1000, .010)
    #AccurateSleep.sample_sleep_ns(.030, 1000, .0015)
  end
end