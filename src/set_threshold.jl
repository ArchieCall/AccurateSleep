function set_threshold(sleep_threshold::Float64)
  #-- create or overwrite the file "sleep_threshold.jl" stored in src folder
  #-- sleep_threshold is the new desired threshold value
  #-- note: if sleep_threshold is .0174, the file contains only one line of
  #   sleep_threshold = .0174
  #-- the file is subsequently included in get_threshold()
  
  const min_true_sleep = .001  #-- allowed minimum threshold
  if sleep_threshold < min_true_sleep
    @printf("parameter error:  sleep_threshold => %6.4f is less than %6.4f secs!!\n", sleep_threshold, min_true_sleep)
    println("set_threshold aborted ==> specified sleep_threshold is too low!")
    sleep(2.)
    return -3.0   #-- parm error negative return
  end
  
  PkgDir = Pkg.dir()
  PkgName = "\\AccurateSleep"
  SubFolderPath = "\\src\\"
  FileName = "sleep_threshold.jl"
  FullFilePath = PkgDir * PkgName * SubFolderPath * FileName
  sfull = string(sleep_threshold) * "0000"
  periodpos = searchindex(sfull, ".")
  string_threshold = sfull[periodpos:periodpos + 4]
  new_threshold = "sleep_threshold = " * string_threshold
  f = open(FullFilePath, "w")
  write(f, new_threshold)
  close(f)
  return nothing
end