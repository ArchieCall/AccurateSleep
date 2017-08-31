function set_threshold()
  if is_windows()
    default_threshold = 0.0175  #-- for windows
  elseif is_linux()
    default_threshold = 0.0020  #-- for linux
  else
    default_threshold = .0050   #-- for apple or unix 
  end
  default_threshold = .0100   #-- you can override the operating system default here
end