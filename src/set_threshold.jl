function set_threshold(threshold::Float64)
  FullPath1 = "C://Users//Owner//.julia//v0.6//AccurateSleep//src//sleep_threshold.jl"
  sfull = string(threshold)
  string_threshold = sfull[1:6]
  new_threshold = "threshold = " * string_threshold
  f = open(FullPath1, "w")
  write(f, new_threshold)
  close(f)
end