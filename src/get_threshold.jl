function get_threshold()
  if is_windows()
    default_threshold = 0.0175  #-- for windows
  elseif is_linux()
    default_threshold = 0.0020  #-- for linux
  else
    default_threshold = .0050   #-- for apple or unix 
  end
  default_threshold = .0151
  #FilePath = pwd()
  #PkgPath = "\\src\\"
  #FileName = "default_threshold.jl"
  #FullPath = FilePath * PkgPath * FileName
  #println(FullPath)
  #FullPath1 = "C://Users//Owner//.julia//v0.6//AccurateSleep//src//default_threshold.jl"
  FullPath1 = "C://Users//Owner//.julia//v0.6//AccurateSleep//src//sleep_threshold.jl"
  #FullPath1 = "C://ArchieJunk//Cody.jl"
  #found_default = isfile(FullPath1)
  if isfile(FullPath1)
    println("found default")
    crabbyjoe = 100
    @show(crabbyjoe)
    include(FullPath1)
    sleep_threshold()
    @show(crabbyjoe)
    @show(default_threshold)
  else
    println("default not found")
  end
  return default_threshold
end