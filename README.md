# digtrace-create

Clone the repo and build docker image:  
```docker build -t digtrace .```

Run in interactive mode - will mount your home folder to `/mnt`:  
```docker run -it -v ~:/mnt digtrace```

Build models (the scripts are expecting input data in `~/inputs` and will create outputs in `~/outputs`):  
```./run-all.sh```
