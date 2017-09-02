function get_threshold()
  if is_windows()
    threshold = 0.0175  #-- for windows
  elseif is_linux()
    threshold = 0.0020  #-- for linux
  else
    threshold = .0051   #-- for apple or unix 
  end
  threshold = .0151
  PkgDir = Pkg.dir()
  PkgName = "\\AccurateSleep"
  SubFolderPath = "\\src\\"
  FileName = "sleep_threshold.jl"
  @show(PkgDir)
  @show(PkgName)
  @show(SubFolderPath)
  @show(FileName)
  FullPath1 = PkgDir * PkgName * SubFolderPath * FileName
  @show(FullPath1)
  #FullPath1 = "C://Users//Owner//.julia//v0.6//AccurateSleep//src//sleep_threshold.jl"
  if isfile(FullPath1)
    println("found default")
    threshold = include(FullPath1)
    #@show(default_threshold)
  else
    println("default not found")
  end
  return threshold
end