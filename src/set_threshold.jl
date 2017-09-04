function set_threshold(threshold::Float64, threshold_type::String = "T")
  #--- a comment
  PkgDir = Pkg.dir()
  PkgName = "\\AccurateSleep"
  SubFolderPath = "\\src\\"
  if threshold_type == "T"
    FileName = "transient_threshold.jl"
  elseif threshold_type == "P"
    FileName = "permanent_threshold.jl"
  end
  FullPath1 = PkgDir * PkgName * SubFolderPath * FileName
  sfull = string(threshold) * "0000"
  periodpos = searchindex(sfull, ".")
  string_threshold = sfull[periodpos:periodpos + 4]
  new_threshold = "threshold = " * string_threshold
  f = open(FullPath1, "w")
  write(f, new_threshold)
  close(f)
end