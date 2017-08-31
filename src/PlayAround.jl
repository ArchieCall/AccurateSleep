function PlayAround()
  #99
  a = 2
  @show(a)
  x = sleep_ns(.1)
  display(sleep_ns(.1))
  display(@benchmark sleep_ns(.1))
  #display(x)
end