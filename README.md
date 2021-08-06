# RoboSim Textual Editor [![CI](https://github.com/UoY-RoboStar/robosim-textual/actions/workflows/main.yml/badge.svg)](https://github.com/UoY-RoboStar/robosim-textual/actions/workflows/main.yml)
This repository contains the plugins for the RoboSim textual editor.

### Development platform requirements ###

* Eclipse 2020-03 (or above)
* Sirius 6.2.0 http://download.eclipse.org/sirius/updates/releases/6.2.0/2018-12
* Xtext 2.25.0 (at least 2.23.0 or above) can be found in the standard repository in http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/ but the option "Show only the latest versions of available software" needs to be unchecked.
* Maven
* Git

### Build (maven) ###

        1. mvn clean install

### Build (eclipse) ###

        1. Right click circus.robocalc.robosim.textual/src/circus.robocalc.robosim.textual/GenerateRoboSim.mwe2
            1. select 'Run As' > 'MWE2 Workflow'

### Run (eclipse) ###

        1. Right click circus.robocalc.robosim.textual.parent
            1. select 'Run As'
            2. double click 'Eclipse Application'
        2. Select the new configuration
            1. click 'Run'
            
### Protocol for updating the tool ###

Whenever updating the tool, follow these steps:

        1. Perform regression testing
        2. Change the language reference manual
        3. Change the tool manual

If changes to documentations are not possible immediately, create issues indicating exactly what needs to be done.

