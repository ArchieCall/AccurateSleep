# ============================================================================================
function sleep_ns(sleep_time::Float64, threshold::Float64 = default_threshold)
  # ============================================================================================
  # hybrid sleep for sleep_time secs (uses mixture of busy wait and sleep(ie. Libc.systemsleep) 
  # ============================================================================================
  #  if sleep_time is < threshold, busy wait for entire sleep_time
  #  if sleep_time is > threshold, hybrid sleep as follows:
  #     1) set actual_time = sleep_time - threshold
  #     2) if actual_time < .001, actual_time = .001
  #     3) sleep with function Libc.systemsleep(actual_sleep)
  #     4) busy wait any remaining time after the sleep in 3) above completes
  # -------------------------------------------------------------------------
  const tics_per_sec = 1_000_000_000.  #-- number of tics in one sec
  nano1 = time_ns()  #-- get beginning time tic for the entire sleep_ns function
  nano2 = nano1 + (sleep_time * tics_per_sec)  #-- final time tic that needs to be exceeded in busy wait cycle
  const min_actual_sleep = .001   #-- do not let the actual_sleep be less than this value
  const max_sleep = 86_400_000.   #-- maximum allowed sleep_time parm (100 days in secs)
  const min_sleep = .000001000    #-- mininum allowed sleep_time parm (1 micro sec)
  
  #-- validate the value of sleep_time parm
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
  
  #--- calc actual_sleep time
  actual_sleep = 0.
  if sleep_time > threshold  
    actual_sleep = sleep_time - threshold  #-- actual_sleep is the amount over the threshold
    if actual_sleep < min_actual_sleep   
      actual_sleep = min_actual_sleep  #-- set actual_sleep to minimum if too small
    end  
  end
  
  if actual_sleep > 0.
    Libc.systemsleep(actual_sleep)  #--- perform the actual sleep only if needed
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
