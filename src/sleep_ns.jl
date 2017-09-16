# ============================================================================================
function sleep_ns(sleep_time::Float64, threshold::Float64 = threshold_default)
  # ============================================================================================
  # accurately sleep for sleep_time secs 
  # ============================================================================================
  #  if sleep_time is <= threshold, busy wait all of sleep_time
  #  if sleep_time is >  threshold, hybrid sleep as follows:
  #     1) actual_sleep = max(.001, sleep_time - threshold)
  #     2) Libc.systemsleep(actual_sleep)
  #     3) busy wait remaining time when 2) completes
  # -------------------------------------------------------------------------
  
  
  const tics_per_sec = 1_000_000_000.  #-- number of tics in one sec
  nano1 = time_ns()                            #-- beginning nano time
  nano2 = nano1 + (sleep_time * tics_per_sec)  #-- final nano time
  const max_sleep = 86_400_000.   #-- maximum allowed sleep_time parm (100 days in secs)
  const min_sleep = .000001000    #-- mininum allowed sleep_time parm (1 micro sec)
  
  #------------------------------------------------------------------------------
  #   Libc.systemsleep(secs) has no accuracy if sleeping for less than .001 secs.
  #
  #   The threshold setting is determined by sampling Libc.systemsleep(.001) over
  #   many samples and then setting the threshold to a value such that its elapsed time
  #   is within quantile = .995 of the samples.
  #
  #   When true sleeping kicks in (ie. sleep_time is above the threshold),
  #   min_true_sleep is the minimum that Libc.systemsleep is allowed to sleep.
  #-----------------------------------------------------------------------------
  const min_true_sleep = .001   #-- warning do not change this value
  
  #-- verify if sleep_time is within limits
  if sleep_time < min_sleep
    @printf("parameter error:  sleep_time => %10.8f is less than %10.8f secs!!\n", sleep_time, min_sleep)
    println("sleep_ns aborted ==> specified sleep time is too low!")
    sleep(2.)
    error("sleep_time is too low!")
  end
  
  if sleep_time > max_sleep
    @printf("parameter error:  sleep_time => %12.1f is greater than %10.1f secs!!\n", sleep_time, max_sleep)
    println("sleep_ns aborted ==> specified sleep time is too high!")
    sleep(2.)
    error("sleep_time is too high!")
  end

  #-- threshold is too low
  if threshold < min_true_sleep
    @printf("parameter error:  threshold => %8.4f is less than %8.4f secs!!\n", threshold, min_true_sleep)
    error("threshold below allowed minimum")
  end
  
  #------ actual sleep
  if sleep_time > threshold  #-- sleep only if above threshold
    #-- actual_sleep_time must be at least min_true_sleep
    actual_sleep_time = max(min_true_sleep, sleep_time - threshold)
    Libc.systemsleep(actual_sleep_time)
  end
  
  #------ final busy wait
  nano3::UInt64 = time_ns()  #-- interim nano time for while loop
  while true
    nano3 >= nano2 && break   #-- break out if final nano time has been exceeded
    nano3 = time_ns()
  end
  
  seconds_over = (nano3 - nano2) / tics_per_sec  #-- seconds that sleep_time was exceeded
  return seconds_over
end #-- end of sleep_ns
