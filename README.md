# alafia-ohif

## Description

Alafia-specific deployment of [OHIF Viewer](https://ohif.org/) based on [the official Docker image](https://hub.docker.com/r/ohif/viewer). This app is run in the browser and can be launched either from https://ohif.alafia, the link in https://home.alafia, or the desktop launcher. 

## Usage

Meant to be used as a submodule in [alafia-apps](https://github.com/Alafia-Ai/alafia-apps).

`Makefile` can be manually invoked with the following options:

- `make` or `make build`: Locally build the Docker image
- `make install`: Install the files in the `deploy/` directory, and if relevant, install systemd service files and modify `/etc/hosts/`
- `make uninstall`: Removes all installed files, and if relevant, removes systemd services and resets `/etc/hosts/` 
