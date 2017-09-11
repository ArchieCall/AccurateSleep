function set_threshold(sleep_threshold::Float64)
  #-- create or overwrite the file "sleep_threshold.jl" stored in src folder
  #-- sleep_threshold is the new desired threshold value
  #-- note: if sleep_threshold is .0174, the file contains only one line of
  #   sleep_threshold = .0174
  #-- the file is subsequently included in get_threshold()
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
end