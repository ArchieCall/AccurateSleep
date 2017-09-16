function get_threshold()
  #-- read and execute the threshold value stored in "threshold_default.jl"
  #-- if file is non existent, return 0.0
  PkgDir = Pkg.dir()
  PkgName = "\\AccurateSleep"
  SubFolderPath = "\\src\\"
  FileName = "threshold_default.jl"  #-- transient file name
  FullFilePath = PkgDir * PkgName * SubFolderPath * FileName
  if isfile(FullFilePath)
    threshold_default = include(FullFilePath)
    if threshold_default < .001
      @printf("stored threshold is %12.5f secs\n", threshold_default)
      print("It was probably set too low by a text editor!")
      error("stored threshold is below .001")
    end
  else
    threshold_default = 0.0
  end
  return threshold_default
end