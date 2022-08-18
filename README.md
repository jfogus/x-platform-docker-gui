# Cross Platform Docker GUI Tool
## Description
This script can download the tools and setup the environment
to forward Docker GUI applications to a host xserver.

The only requirements prior to using this tool is having Docker installed,
having a container already built, and having python3 installed.

---
## Execution
There are three pathways the script can take. A single run can follow any
number of the given pathways

### Flags
* ```-i```: Installs the dependencies required for the script to run properly.
  * Long form: ```--install```
  * Windows: **Chocolatey** and **VcXsrv**
  * macOS: **Brew**, **Socat**, and **XQuartz**
  * Linux: *None*
* ```-r```: Runs the dependent software, sets up the environment, and runs a 
            user-provided docker container.
  * Long form: ```--run```
  * Must be paired with the ```-c``` flag.
* ```-u```: Uninstalls the dependencies indicated in the ```-i``` flag. A prompt
            confirms uninstallation prior to uninstalling each dependency.
  * Long form: ```--uninstall```
* ```-c CONTAINER```: Supplies the name of the container that should be run.
  * Long form:  ```--container CONTAINER```
  * Must be paired with the ```-r``` flag.

### Example
1. ```docker build -t gui-example .```
   * Run this from the root of the project to build the example container.
2. ```./main.py -ir -c gui-example```
   * Run this from the root of the project.
   * This installs the dependencies and runs the gui-example container.

---
## Help
From the root folder, run ``` main.py --help ``` for a list of flags to use.
A flag must be used to get get any of the desired behaviors.

---
## FAQ
### The script did not correctly identify my system. What do I do?
When prompted to confirm the detected system, enter ```n```. You will be given
a menu to choose the correct system.

### What operating systems are supported?
The supported operating systems are **Windows**, **macOS**, and **Linux**.