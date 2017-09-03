function get_threshold()
  #--- a dummy remark
  if is_windows()
    threshold = 0.0175  #-- for windows
  elseif is_linux()
    threshold = 0.0025  #-- for linux
  else
    threshold = .0053   #-- for apple or unix 
  end
  threshold = .0151
  PkgDir = Pkg.dir()
  PkgName = "\\AccurateSleep"
  SubFolderPath = "\\src\\"
  FileName = "sleep_threshold.jl"
  FullPath1 = PkgDir * PkgName * SubFolderPath * FileName
  if isfile(FullPath1)
    #println("found default")
    threshold = include(FullPath1)
  else
    println("default not found")
  end
  return threshold
end