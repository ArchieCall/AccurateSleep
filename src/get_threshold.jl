function get_threshold()
  #-- read and execute the threshold value stored in "sleep_threshold.jl"
  #-- if file is non existent, return 0.0
  PkgDir = Pkg.dir()
  PkgName = "\\AccurateSleep"
  SubFolderPath = "\\src\\"
  FileName = "sleep_threshold.jl"  #-- transient file name
  FullFilePath = PkgDir * PkgName * SubFolderPath * FileName
  if isfile(FullFilePath)
    #sleep_threshold = include(FullFilePath)
    sleep_threshold = include(FullFilePath)
  else
    sleep_threshold = 0.0
  end
  return sleep_threshold
end