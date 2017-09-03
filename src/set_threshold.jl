function set_threshold(threshold::Float64)
  #--- a comment
  PkgDir = Pkg.dir()
  PkgName = "\\AccurateSleep"
  SubFolderPath = "\\src\\"
  FileName = "sleep_threshold.jl"
  FullPath1 = PkgDir * PkgName * SubFolderPath * FileName
  sfull = string(threshold)
  string_threshold = sfull[1:6]
  new_threshold = "threshold = " * string_threshold
  f = open(FullPath1, "w")
  write(f, new_threshold)
  close(f)
end