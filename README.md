# AccurateSleep

[![Build Status](https://travis-ci.org/ArchieCall/AccurateSleep.jl.svg?branch=master)](https://travis-ci.org/ArchieCall/AccurateSleep.jl)

[![Coverage Status](https://coveralls.io/repos/ArchieCall/AccurateSleep.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/ArchieCall/AccurateSleep.jl?branch=master)

[![codecov.io](http://codecov.io/github/ArchieCall/AccurateSleep.jl/coverage.svg?branch=master)](http://codecov.io/github/ArchieCall/AccurateSleep.jl?branch=master)

Usage
======
```
using AccurateSleep    #-- load the package
using BenchmarkTools   #-- load BenchmarkTool (used if running @benchmark macro)
sleep_ns(.0003)  #-- hybrid sleep for .0003 secs
sleep_ns(.0003, .019)  #-- hybrid sleep for .0003 secs with threshold of .019 secs
println("Archie was here")
```

* mutte
* cowbells
* horses
