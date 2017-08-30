#-- 08-29-2017
module AccurateSleep

#---------------------------------------------------------------------------------------------
#    set the default threshold specific to your operating system
#    threshold is set to a value where if julia attemts sleep(.001) secs, then
#    the maximum actual sleep time rarely exceeds the threshold (think quantile = .999)
#    you should run AccurateSleep.evaluate
#---------------------------------------------------------------------------------------------
if is_windows()
  default_threshold = 0.0175  #-- for windows
else
  default_threshold = 0.0020  #-- for linux and mac
end
#default_threshold = .0160   #-- you can override the operating system default here
@printf("default_threshold) => %8.4f secs\n", default_threshold)

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

# =====================================================================================================
function sample_sleep_ns(sleep_time::Float64, num_samples::Int, threshold::Float64 = default_threshold)
  # ===================================================================================================
  # sample sleep_ns over num_samples using specified threshold
  # ===================================================================================================
  const tics_per_sec = 1_000_000_000.
  v = zeros(num_samples)
  println("\n================================================================")
  @printf("sleep_time (secs) => %8.6f\n", sleep_time )
  @printf("threshold (secs)             => %8.6f\n", threshold )
  @printf("number of samples            => %6i\n", num_samples )
  println(" ... generating samples - please wait...")
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
  sleep(1.)
  gc()
  sleep(1.)
  
end

# ================================================================
function evaluate_threshold(num_samples::Int = 5000)
  # =================================================================
  # sample Libc.systemsleep(.001) to determine a potential threshold
  # =================================================================
  const tics_per_sec = 1_000_000_000.
  #num_samples = 5000
  v = zeros(num_samples)
  println("... please wait generating samples ...")
  for i = 1:num_samples
    nano3 = time_ns()
    Libc.systemsleep(.001)
    #sleep(.001)
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
  println("")
  @printf("------------- Results for evaluating %5i samples --------------\n", num_samples)
  @printf("            Command is Libc.systemsleep(.001)\n")
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

  setrounding(Float64, RoundUp)
  suggested_default = round(quant999, 4) + .0002
  println("")
  @printf("Suggested default_threshold => %7.4f\n", suggested_default)
  
  existing_default = AccurateSleep.default_threshold
  @printf("Existing default_threshold  => %7.4f\n", existing_default)
  
  @show(suggested_default - existing_default)

  #PercentDiff = (abs(suggested_default - existing_default) / ((suggested_default + existing_default) * 0.5)) * 100.0
  #@show(PercentDiff)
  
  if isapprox(suggested_default, existing_default)
    #---
    println("")
    println("Both Suggested and Existing default_threshold are the same value.")
    println("No change needed to default_threshold in the AccurateSleep module")
  elseif abs(suggested_default - existing_default) > .002
    println("")
    println("Note. Suggested and Existing default_threshold differ substantially!")
    println("You probably should update default_threshold in the AccurateSleep module")
  else
    println("")
    println("Note. Suggested and Existing default_threshold differ only slightly!")
    println("Your option to update default_threshold in the AccurateSleep module")
  end
  println("--------------------------------------------------------------------\n")
  #sleep_ns(5.0)
  return suggested_default
end

function demo()
  #using BenchmarkTools
  #using AccurateSleep
  #--- warm up the sleep commands
  Libc.systemsleep(1.)
  sleep_ns(.1)
  for q =1:1
    suggested_default = AccurateSleep.evaluate_threshold(5000)     #--- evaluate potential default_threshold values
    @printf("suggested_default => %9.4f\n", suggested_default)
    AccurateSleep.sample_sleep_ns(.05, 200, suggested_default)
    break
    for i = 1:200
      over = sleep_ns(.05, .017)
      @printf("iter => %3i secs over => %16.9f\n",i, over)
    end
    
    #=
    #for sleep_time in (.2, .1, .05, .02, .01, .005, .001, .0001, .00001, .000001)
    for sleep_time in (.2, .1, .05)
      NumSecs = 30.0
      NumIters = convert(Int64, round(NumSecs / sleep_time, 0))
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
export sleep_ns
end #-- end of module
