# ccs-ci

Dockerfile to build a code composer studio container for continues integration/build/test

* Targeted towards MSP432

# Get the Container

There are two options available: you can either build it OR pull from dockerhub.

## build

```
make
```

## pull
```
docker pull nishanthmenon/ccs-msp430-ci
```

# Use the container

## Run manually with a docker container command line.
docker run -ti --rm -v C:\\workspace\\roomzscreen:/workdir nishanthmenon/ccs-msp430-ci /bin/bash


## Use wrapper scripts

- docker\_ccs - Opens up CCS in your Linux PC.
- docker\_shell - Drops you straight to shell inside the container
- docker\_make - invokes standard make command and you can do stuff like `./docker\_make -C /automation\_iface`

## Reference shell commands

* Few of the command line options are below.
* I prefer to do a GUI build once, save up the makefiles and then plain use the makefiles
  since my folder positions are always exactly same inside the docker container, I can let people reproduce the builds by mapping via
  docker volume to the predefined locations.

## import project
/opt/ti/ccs/eclipse/eclipse -noSplash -data "/workspace" -application com.ti.ccstudio.apps.projectImport -ccs.location /workdir/<projectName>/

## build
/opt/ti/ccs/eclipse/eclipse -noSplash -data "/workspace" -application com.ti.ccstudio.apps.projectBuild  -ccs.workspace -ccs.setBuildOption com.ti.ccstudio.buildDefinitions.C6000_6.1.compilerID.QUIET_LEVEL com.ti.ccstudio.buildDefinitions.C6000_6.1.compilerID.QUIET_LEVEL.VERBOSE
