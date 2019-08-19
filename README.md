# RoboSim Textual Editor [![wercker status](https://app.wercker.com/status/07de73ebc57c8cdcf1226980b3957623/s/master "wercker status")](https://app.wercker.com/project/byKey/07de73ebc57c8cdcf1226980b3957623)
This repository contains the plugins for the RoboSim textual editor.

### Development platform requirements ###

* Eclipse 2019-06
* Sirius 6.2.0 http://download.eclipse.org/sirius/updates/releases/6.2.0/2018-12
* Xtext 2.18.0 can be found in the standard repository in http://download.eclipse.org/modeling/tmf/xtext/updates/composite/releases/ but the option "Show only the latest versions of available software" needs to be unchecked.
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
