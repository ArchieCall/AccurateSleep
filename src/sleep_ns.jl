# ============================================================================================
function sleep_ns(sleep_time::Float64, threshold::Float64 = default_threshold)
  # ============================================================================================
  # accurately sleep for sleep_time secs 
  # ============================================================================================
  #  if sleep_time is <= threshold, busy wait whole sleep_time
  #  if sleep_time is >  threshold, hybrid sleep as follows:
  #     1) actual_sleep = max(.001, sleep_time - threshold)
  #     2) Libc.systemsleep(actual_sleep)
  #     3) busy wait remaining time after the sleep in 2) above completes
  # -------------------------------------------------------------------------
  const tics_per_sec = 1_000_000_000.  #-- number of tics in one sec
  nano1 = time_ns()  #-- get beginning time tic for the entire sleep_ns function
  nano2 = nano1 + (sleep_time * tics_per_sec)  #-- final time tic that needs to be exceeded in busy wait cycle
  const min_actual_sleep = .001   #-- do not let the actual_sleep be less than this value
  const max_sleep = 86_400_000.   #-- maximum allowed sleep_time parm (100 days in secs)
  const min_sleep = .000001000    #-- mininum allowed sleep_time parm (1 micro sec)
  
  #-- verify if sleep_time is within limits
  if sleep_time < min_sleep
    @printf("parameter error:  sleep_time => %10.8f is less than %10.8f secs!!\n", sleep_time, min_sleep)
    println("program halted ==> specified sleep time is too low!")
    sleep(8.)
    return -1.0   #-- parm error negative return
  end
  
  if sleep_time > max_sleep
    @printf("parameter error:  sleep_time => %12.1f is greater than %10.1f secs!!\n", sleep_time, max_sleep)
    println("program halted ==> specified sleep time is too high!")
    sleep(8.)
    return -2.0    #-- parm error negative return
  end
  
  #------ actual sleep
  if sleep_time > threshold  #-- sleep only if above threshold
    #-- actual_sleep_time must be at least min_actual_sleep
    actual_sleep_time = max(min_actual_sleep, sleep_time - threshold)
    Libc.systemsleep(actual_sleep_time)
  end
  
  #------ final busy wait
  nano3::UInt64 = time_ns()  #-- first time tic of final busy wait
  while true
    nano3 >= nano2 && break   #-- break out if sleep_time has been exceeded
    nano3 = time_ns()
  end

  seconds_over = (nano3 - nano2) / tics_per_sec  #-- seconds that sleep_time was exceeded
  return seconds_over
end #-- end of sleep_ns
