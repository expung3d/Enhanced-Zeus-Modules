
# Enhanced Zeus Modules Contribution Guidelines
Everything you need to know about contributing to E.Z.M.

## New Modules
When adding new modules there are two steps. First we must create the function that we desire the module to call on deployment and then we must add the module to the Zeus modules tree. <br>When adding modules, ensure they are things that should be Zeus modules. If it a system that can work independently from Zeus, make it into its own script, don't incorporate it into E.Z.M. For example, do not add a module that creates a roles system or changes how vehicles perform into E.Z.M., this should be separate from Zeus as it can act independently.
<hr>

### Adding the function
Adding the function is very simple. Inside E.Z.M. there is a function called `MAZ_EZM_fnc_initFunction` within this are all the function declarations. Inside your text editor you can use the collapse option to show and hide the sections denoted by comments. When adding a new function ensure that the function is placed within the correct category as this helps other developers understand where the function should be and what it affects. Also, all functions should contain the prefix `TAG_MAZ_EZM_fnc_`. TAG being your own tag. <br>For this example we will create a function within `MAZ_EZM_fnc_initFunction` called `MAZ_EZM_fnc_helloWorld`.
```sqf
MAZ_EZM_fnc_helloWorld = {
	params ["_entity"]; //This entity will always be passed into a function called via EZM.
	//The _entity represents whatever the module is placed onto, a vehicle, a player, etc.
	
	systemChat format ["Hello World! %1", typeOf _entity];
	//This will systemChat "Hello World!" and the type of the entity we placed the module onto.
};
```
<hr>

### Adding the module
Adding the module can be confusing, especially if aiming to create a new category for modules. Find the function `JAM_MAZ_EZM_editZeusInterface`. Inside here are all the changes that happen to the Zeus interface, color changes, adding modules, the warning system, etc. Just like the `MAZ_EZM_fnc_initFunction` had comments to organize the categories, this function does too. Find the category and create your category or module as follows.
```sqf
//Creating the category
MAZ_EditAITree = [ //Returns our parent category, used for creating the module
	MAZ_zeusModulesTree,//Predefined variable for modules control tree
	"AI Modifiers", //The name of the category you wish to add
	'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\intel_ca.paa', //The icon shown
	[1,1,1,1], //The color of the text
	"" //The tooltip shown when hovering over the category
] call MAZ_EZM_fnc_zeusAddCategory;

---------------------------------------

//Creating the module
[
	MAZ_zeusModulesTree, //The modules control tree
	MAZ_EditAITree, //The parent category we defined prior
	"Easy Mode", //The module name
	"Decreases difficulty and makes AI stand.", //The tooltip/description of the module
	"MAZ_EZM_fnc_easyModeModule", //The function that is called (STRING)
	'\A3\ui_f\data\IGUI\Cfg\mptable\infantry_ca.paa' //The icon of the module
	[1,1,1,1], //The text color
	[1,1,1,1], //The icon color
	[0,0,0,1], //Icon color selected
	[0.8,0,0,0.8] //Icon color disabled
] call MAZ_EZM_fnc_zeusAddModule;
```
<hr>

## Adding Factions
To be completed later... lots of stuff goes into making a faction.
