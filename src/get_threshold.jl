function get_threshold()
  #--- a dummy remark dididi 88888
  #=
  TODO:
  priority
  - permanent: is hard coded in permanent_threshold.jl file
  - transient: is auto generated in transient_threshold.jl file
  - dkdkdk
  =#
  # FIXME: correct for best apple or unix setting
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
  FileNameP = "permanent_threshold.jl"  #-- permanent file name
  FileNameT = "transient_threshold.jl"  #-- transient file name
  FullPathP = PkgDir * PkgName * SubFolderPath * FileNameP
  FullPathT = PkgDir * PkgName * SubFolderPath * FileNameT
  if isfile(FullPathT)
    thresholdT = include(FullPathT)
  else
    thresholdT = 0.0
  end
  if isfile(FullPathP)
    thresholdP = include(FullPathP)
  else
    thresholdP = 0.0
  end
  return thresholdT, thresholdP
end