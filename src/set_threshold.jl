function set_threshold(threshold_default::Float64)
  #-- create or overwrite the file "threshold_default.jl" stored in src folder
  #-- threshold_default is the new desired threshold value
  #-- note: if threshold_default is .0174, the file contains only one line of
  #   threshold_default = .0174
  #-- the file is subsequently included in get_threshold()
  
  const min_true_sleep = .001  #-- allowed minimum threshold
  if threshold_default < min_true_sleep
    @printf("parameter error:  threshold_default => %6.4f is less than %6.4f secs!!\n", threshold_default, min_true_sleep)
    println("set_threshold aborted ==> specified threshold_default is too low!")
    sleep(2.)
    error("cannot set threshold below .001")
  end
  
  PkgDir = Pkg.dir()
  PkgName = "\\AccurateSleep"
  SubFolderPath = "\\src\\"
  FileName = "threshold_default.jl"
  FullFilePath = PkgDir * PkgName * SubFolderPath * FileName
  sfull = string(threshold_default) * "0000"
  periodpos = searchindex(sfull, ".")
  string_threshold = sfull[periodpos:periodpos + 4]
  new_threshold = "threshold_default = " * string_threshold
  f = open(FullFilePath, "w")
  write(f, new_threshold)
  close(f)
  return nothing
end