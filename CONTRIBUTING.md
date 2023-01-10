# Enhanced Zeus Modules Contribution Guidelines
Everything you need to know about contributing to E.Z.M.

## New Modules
When adding new modules there are two steps. First we must create the function that we desire the module to call on deployment and then we must add the module to the Zeus modules tree.
<hr>
When adding modules, ensure they are things that *should* be Zeus modules. If it a system that can work independently from Zeus, make it into its own script, don't incorporate it into E.Z.M. For example, do not add a module that creates a roles system or changes how vehicles perform into E.Z.M., this should be separate from Zeus as it can act independently.

I would go as far as to say even having earplugs added to E.Z.M. should not be done. E.Z.M. should focus on modifying *only* Zeus and their abilities. 
<hr>

### Adding the function
Adding the function is very simple. Inside E.Z.M. there is a function called `MAZ_EZM_fnc_initFunction` within this are all the function declarations. Inside your text editor you can use the collapse option to show and hide the sections denoted by comments. When adding a new function ensure that the function is placed within the correct category as this helps other developers understand where the function should be and what it affects. Also, all functions should contain the prefix `TAG_MAZ_EZM_fnc_`. TAG being your own tag. <br>For this example we will create a function within `MAZ_EZM_fnc_initFunction` called `MAZ_EZM_fnc_helloWorld`.
```sqf
MAZ_EZM_fnc_helloWorld = {
	params ["_entity"]; //This entity will always be passed into a function called via EZM.
	//The _entity represents whatever the module is placed onto, a vehicle, a player, etc.
	
	systemChat format ["Hello World! %1", typeOf _entity];
	//This will systemChat "Hello World!" and the type of the entity we placed the module onto.
	
	//!! This function has a script error if placed onto no object. See if you can fix it. !!
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
Following our example from the function declaration we will add the Hello World module. We will add it to the Utilities category.
```sqf
[
	MAZ_zeusModulesTree, //Module tree
	MAZ_UtilitiesTree, //Module category
	"Hello World!", //The module name
	"Says hello", //Our description
	"MAZ_EZM_fnc_helloWorld", //Our function
	"" //No icon
] call MAZ_EZM_fnc_zeusAddModule;
```
<hr>

## Adding Factions
At the most basic level factions are glorified modules located in a different place. Before you start creating a faction in E.Z.M. remember that your factions won't be included in future updates unless Expung3d looks at the faction and approves it to be an official faction. This means you should keep a backup of your factions and have the code separate from your E.Z.M. file so you can transfer it with new updates. 
<hr>

**Tips to make a good faction:**
 1. Randomize the loadouts of the units you create. 
	  - Give them a selection of weapons and clothing to use, this gives individual units identity so you are fighting different people, not a clone of one.
 2. Make them make sense for where they are meant to be used.
 3. Ensure the vehicles, armor, and weapons you give them are balanced and make sense for the type of faction they are.
	 - i.e. a militia should not have jets.
 4. Be creative, use textures in the game to make "new items" out of old items.

<hr>

### Creating the Faction Functions
Just like with the module functions we will add the function into `MAZ_EZM_fnc_initFunction`. Inside here we will see the familiar comment organization structure, create a new area for your faction's functions. <br>For this example we will create a function `MAZ_EZM_NF_fnc_createNewVehicle`. *Notice the new prefix, MAZ_EZM_[FactionTag]_fnc. FactionTag is replaced to a shortening of your faction's name. This is just "New Faction".* 

```sqf
MAZ_EZM_NF_fnc_createNewVehicle = {
	//Its lonely here...
};
```
Obviously this function is quite boring and doesn't do what we'd like. But before we can add anything cool we need to learn about some other functions built into E.Z.M. There are 5 functions to aid in faction creation: `MAZ_EZM_fnc_removeAllClothing`, `MAZ_EZM_fnc_createMan`, `MAZ_EZM_fnc_addItemAndWeapons`, `MAZ_EZM_fnc_createVehicle`, and `MAZ_EZM_fnc_addNVGs`.

<hr>

#### MAZ_EZM_fnc_removeAllClothing
This one is pretty self explanatory I think... 
```sqf
//The unit passed to the function (_unit) will have all item's removed from them.
[_unit] call MAZ_EZM_fnc_removeAllClothing;
```

<hr>

#### MAZ_EZM_fnc_createMan
This function will be used a lot when making factions. This creates the basic unit for the faction and adds him to the interface, fixes bugs with waypoints, and adds him to the clean-up scripts. **Never** create a unit for a faction with the createUnit command, as this will cause bugs with waypoints and will not add the unit to the cleaner. 
We have 6 parameters for creating a man:
```sqf
private _man = [ //Creating a private variable to hold the returned man
	west, //The side we want the man to be
	"B_Soldier_F", //The type of unit we want the man to be
	"UP", //The stance we want, see setUnitPos (Optional, default UP)
	"AWARE", //The behavior we want, see setBehaviour (Optional, default AWARE)
	"PRIVATE", //The rank they have (Optional, default private)
	_pos //Their position (Optional, default the mouse position)
] call MAZ_EZM_fnc_createMan;
```

<hr>

#### MAZ_EZM_fnc_addItemAndWeapons
This function is very complex and can take a lot of arguments. However, it is very powerful and adds all items you want to the unit. Weapons, first aid, grenades, etc. You can choose to not use this function, however, it will be much faster to use this function in most cases. All parameters in this function are optional. Anything you don't include won't be added.
```sqf
[
	_man, //The unit to add it to
	[ //The primary weapon for the unit
		"", //The primary weapon class
		[ //The magazines given
			"", //Magazine class
			5 //The number of magazines
		], 
		[] //Primary weapon attachments
	],
	[], //The secondary weapon (launcher) for the unit, same syntax as the primary weapon.
	[], //The handgun for the unit, same syntax as the primary and secondary weapon.
	3, //The number of first aid kits for the unit
	[ //The grenades the unit has
		[
			"", //Grenade type
			2 //Grenade amount
		]
	],
	[ //Any extra items (medkits, toolkits, etc)
		[
			"", //The item class
			1 //The item amount
		]
	]
] call MAZ_EZM_fnc_addItemAndWeapons;
```

For example, taken from the CTRG+ faction:
```sqf
//Defining the weapon, weapon mags, and grenadier grenades
(selectRandom [
	["arifle_SPAR_01_GL_blk_F","30Rnd_556x45_Stanag","1Rnd_HE_Grenade_shell"],
	["arifle_MX_GL_Black_F","30Rnd_65x39_caseless_black_mag","3Rnd_HE_Grenade_shell"]
]) params ["_grenadierWeapon","_grenadierMag","_grenadierGrenade"];
//Calling the function to add items
[
	_unit,
	[ //The grenadier weapon
		_grenadierWeapon,
		[_grenadierMag,5],
		[_optic,"acc_pointer_ir"]
	],
	[], //No launcher
	[ //The pistol
		"hgun_Pistol_heavy_01_F",
		["11Rnd_45ACP_Mag",2],
		["optic_MRD"]
	],
	3, //First aid kits
	[ //Grenades
		["HandGrenade",2],
		[_grenadierGrenade,4]
	]
] call MAZ_EZM_fnc_addItemAndWeapons;
```

<hr>

#### MAZ_EZM_fnc_createVehicle
Jeez, luckily that's the most confusing function here. This function is super simple and saves a lot of hassle. With this we can create a vehicle of a certain type, with specific textures, at a specific position. This function also adds the vehicle to the cleaner, however, you *can* forgo this function and use createVehicle to spawn a vehicle. 
```sqf
private _vehicle = [ //Storing the vehicle created in a private variable _vehicle
	"B_MRAP_01_F", //The vehicle type, this is a Hunter
	[], //The textures to apply, we can supply any strings for texture paths. (Optional)
	_pos //The position (Optional, default is cursor position)
] call MAZ_EZM_fnc_createVehicle;
```

<hr>

#### MAZ_EZM_fnc_addNVGs
Lastly we can add dynamic NVGs to the unit with this function. This will only add NVGs to the unit if it is night time, otherwise they'll receive none. This has super simple syntax:
```sqf
[
	_unit,	//The unit to add them to
	"NVGoggles" //The NVGs to add if its nighttime
] call MAZ_EZM_fnc_addNVGs;
```

<hr>

### Finally! Lets Make the Function
Now that we know about the faction functions lets go back to our empty function `MAZ_EZM_NF_fnc_createNewVehicle`.

```sqf
MAZ_EZM_NF_fnc_createNewVehicle = {
	//Lets create the driver for the vehicle
	private _driver = [west,"B_Soldier_F"] call MAZ_EZM_fnc_createMan;
	
	//Remove his items
	[_driver] call MAZ_EZM_fnc_removeAllClothing;
	
	//Give him new clothes (Ideally create another function for this)
	_driver forceAddUniform (selectRandom ["U_B_CTRG_1","U_B_CTRG_3","U_B_CTRG_2","U_B_CTRG_Soldier_2_Arid_F"]);
	_driver addVest (selectRandom ["V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG"]);
	//Lookin good
	
	//Now lets give him a gun
	[_driver,["arifle_MX_Black_F",["30Rnd_65x39_caseless_black_mag",3],["optic_ACO_grn","acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;
	
	//Then lets make the vehicle
	private _vehicle ["B_MRAP_01_F"] call MAZ_EZM_fnc_createVehicle;
	
	//And move in the driver
	_driver moveInDriver _vehicle;
	
	//Last thing, for the vehicle we return the vehicle
	//For units we return the unit created
	_vehicle
};
```

<hr>

### Creating the Faction Category
Creating a faction category is just like with a module, the only difference is instead of adding it to `MAZ_zeusModulesTree` (the modules tab) we add it to one of the following: `MAZ_UnitsTree_BLUFOR`, `MAZ_UnitsTree_OPFOR`, `MAZ_UnitsTree_INDEP`, or `MAZ_UnitsTree_CIVILIAN`.  Again, everything here happens in the function `JAM_MAZ_EZM_editZeusInterface`.

For example:
```sqf
MAZ_myNewFactionTree = [
	MAZ_UnitsTree_BLUFOR, //The main tree
	"My New Blufor Faction", //The faction category name
	"" //The icon
] call MAZ_EZM_fnc_zeusAddCategory;
```

<hr>

### Creating the Faction Sub-Categories
The faction sub-categories are for categories within the factions, Anti-Air, Cars, Groups, Helicopters, Men, Planes, etc. This portion is just as simple. 

For example:
```sqf
MAZ_myNewFactionSubCategory = [
	MAZ_UnitsTree_BLUFOR, //The main tree
	MAZ_myNewFactionTree, //The category we created above
	"My Sub-Category", //Our sub-category name
	"" //The sub-category icon
] call MAZ_EZM_fnc_zeusAddSubCategory;
```

<hr>

### Creating the Object Module
This is just like adding a normal module except we use a different function to create it. Instead of `MAZ_EZM_fnc_zeusAddModule` we will use `MAZ_EZM_fnc_zeusAddModule_BLUFOR`, `MAZ_EZM_fnc_zeusAddModule_OPFOR`, `MAZ_EZM_fnc_zeusAddModule_INDEP`, or `MAZ_EZM_fnc_zeusAddModule_CIVILIAN`. 

For example:
```sqf
[
	MAZ_UnitsTree_BLUFOR, //The main tree
	MAZ_myNewFactionTree, //The category we created
	MAZ_myNewFactionSubCategory, //The sub-category we want it in
	"My Faction Unit", //The display name
	"My super cool new unit for my faction", //The tooltip when we hover
	"MAZ_EZM_NF_fnc_createNewVehicle", //The function to call when placed
	"a3\soft_f\mrap_01\data\ui\map_mrap_01_ca.paa" //The icon
] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;
```

## Framework Functionality
Enhanced Zeus Modules has two main frameworks in it that you'll want to know about when making a module. The Dialog Creation framework (using `MAZ_EZM_fnc_createDialog`) creates any UI you need for a module. The Context Menu framework (using `MAZ_EZM_fnc_createNewContextAction`) creates any right click buttons you need.

<hr>

### The Dialog Creation Framework
The documentation for this framework is going to include how to create a dialog and the data needed for the 7 different types of rows in the dialog. 

<hr>

#### Making a Dialog
This portion is super easy, simply give it a name, content, code to run on confirmation, code to run on cancel, and any arguments given to the code. 

```sqf
[
	"My Dialog Title", //The title, obviously
	[], //This is our content, you fill this array with other arrays shown later
	{ //Code to execute on confirmation
		params ["_values","_args","_display"];
		systemChat "We confirmed!";
		_display closeDisplay 1;
		//exiting with 1 denotes an OK exit
	},
	{ //Code to execute on cancel
		params ["_values","_args","_display"];
		systemChat "We canceled...";
		_display closeDisplay 2;
		//exiting with 2 denotes a CANCEL exit
	},
	[] //Arguments (Optional, default is nil)
] call MAZ_EZM_fnc_createDialog;
```
This will create our basic skeleton for the dialog. Now lets look at the rows to fill it with.
The basic structure of a row in the content array will look like this:
```sqf
[ //The empty content array from above
	[
		"TYPE", //The type of the content
		"Label", //The label shown to the left
		[] //Values that go into the type
	]
]
```

<hr>

##### COMBO
The combo box creates a dropdown list of things to choose from and returns an index of what was selected. 
```sqf
[
	"COMBO", 
	"My Combo Box", 
	[ 
		["myDataFor0"], //Values (Actual values set with lbSetData)
		["Wow my entry!"], //The text shown in the list
		0 //The default index selected
	] 
]
```
This is the simplest implementation of a COMBO, however, we can get more complex with the entries in the combobox. By editing the text and changing it from a string to an array we can set the text, tooltip, picture, and color.
```sqf
[
	"COMBO", 
	"My Combo Box", 
	[ 
		["myDataFor0"], 
		[
			[ //Now an array, not a string
				"Wow my entry!", //Display text
				"This is my tooltip", //Tooltip
				"somePicturePath", //Picture path
				[0.8,0,0,0.8] //Text color
			]
		], 
		0 
	] 
]
```

<hr>

##### EDIT
The EDIT creates a row that allows for inputting text. This can be either one line or multiple lines. We can change this using a subtype. Subtypes are used by having the main type followed by the subtype after a ":": "EDIT:MULTI").

```sqf
//Subtypes: MULTI, CODE.
[
	"EDIT", 
	"My Text Box", 
	[ 
		"Default text", //Default text that shows
		5 //Height of the box
	] 
]
```

<hr>

##### LIST
The LIST creates a row that has a list of items to choose from. Similar to the combo except it isn't a dropdown, the list is always expanded. 
```sqf
[
	"LIST", 
	"My List Box", 
	[ 
		["myDataFor0"], //Values (Actual values set with lbSetData)
		["Wow my entry!"], //The text label shown in the list
		0, //The default index selected
		6 //Height of the listbox
	] 
]
```
The text labels can be edited in the same way as the COMBO ones can with tooltips, pictures, and colors. See the COMBO docs for more information.

<hr>

##### SIDES
The SIDES creates a row with all the sides and allows for the sides to be chosen from.
```sqf
[
	"SIDES",
	"Select side",
	west //Notice this doesn't need to be in an array. 
	//When it is just one side on its own only one side can be selected.
	//When it is an array, even just [west], multiple sides can be selected.
]
```

<hr>

##### SLIDER
The SLIDER creates a row with a slider that allows them to pick any number between two.
```sqf
//Subtypes: RADIUS
[
	"SLIDER",
	"Set health",
	[
		0, //Minimum value
		1, //Maximum value
		0, //Default value
		objNull, //Radius center (For use with RADIUS subtype)
		[1,1,1,0.7], //Radius color
		false //Is percentage value
	]
]
```

<hr>

##### TOOLBOX
The TOOLBOX creates a toggle switch. Because scripting has been neglected when compared to modding we can only have two values available in a toolbox, unfortunately.
```sqf
//Subtypes: YESNO, ENABLED
//YESNO creates selections of NO or YES
//ENABLED creates selections of DISABLE or ENABLE
[
	"TOOLBOX",
	"Enable?",
	[
		false, //Default selection, can be boolean or boolean number (0/1)
		["Disable","Enable"] //Strings for the selections
	]
]
```

<hr>

##### VECTOR
The VECTOR is not as cleanly made as the rest and is hardly used. However, it creates up to 3 edit boxes for modifying positions, rotation, etc.
```sqf
[
	"VECTOR",
	"Position",
	[
		[0,0,0], //Default values
		["X","Y","Z"], //Labels
		3 //Number of edits
	]
]
```

<hr>

#### Putting it Together
Now that we understand the rows we can create lets put them into a dialog. This will give us a text box and print whatever we put into it.
```sqf
[ 
	"My Dialog Title",  
	[
		[
			"EDIT",
			"My text",
			["Input text"]
	], 
	{ 
		["_values","_args","_display"]; 
		//Values stores all the returned values from the rows in an array.
		_values params ["_editBoxReturn"]; //Retrieving the return
		systemChat format ["We inputted: %1",_editBoxReturn]; //Print our text
		_display closeDisplay 1; 
	}, 
	{ //Code to execute on cancel 
		params ["_values","_args","_display"]; 
		systemChat "We canceled..."; 
		_display closeDisplay 2; 
	}, 
	[]
] call MAZ_EZM_fnc_createDialog;
```

<hr>

### The Context Menu Framework
Using this framework we can create a new action to show up when we right click. This framework works pretty much identically to how `addAction` works. 
```sqf
MAZ_EZM_action_myNewContextAction = [ //Stores our action ID in this variable
	"Our Action Text", //The action display text
	{ //Code to execute when selected
		params ["_pos","_entity"];
		//_pos is the position you right clicked
		//_entity is any entity you right clicked
		player setPos _pos;
	},
	{ //Condition for action to be shown
		//_this refers to the entity you right clicked
		//the condition should always return a boolean value
		true //we want this to always show
	},
	3, //Action priority (for sorting of the actions)
	"", //The action image
	[1,1,1,1], //The action color
	[] //Children actions
	//Children actions are literally just the array of an action within the children array.
	//This will create actions attached to this action that they can choose from.
]
```

<hr>

### Other Useful Functions
E.Z.M. has a ton of useful functions for repetitive tasks. Use these whenever possible.

#### MAZ_EZM_fnc_systemMessage
This function systemChats your message with the prefix "[ Enhanced Zeus Modules ] : " and can play a sound along with it.
```sqf
["My warning message","addItemFailed"] call MAZ_EZM_fnc_systemMessage;
```
<hr>

#### MAZ_EZM_fnc_getScreenPosition
This function returns the mouse position from the map or the Zeus view. You can choose to get the height of any intersects or not. *When retrieving the position from outside the map the returned position is given in **positionAGL***.
```sqf
//Height will not be included when selecting from the map
private _posAGL = [true] call MAZ_EZM_fnc_getScreenPosition; 
//Gets position with height included

private _pos = [] call MAZ_EZM_fnc_getScreenPosition; 
//Gets position without height
```
<hr>

#### MAZ_EZM_fnc_selectSecondaryPosition
Allows the Zeus to select a position after selecting an initial position. 
```sqf
[
	"Text", //Display text
	{ //Code to call on left click
		params ["_origin","_position","_args","_shift","_ctrl","_alt"];
		//_position is the position we ended up clicking
		//_shift, _ctrl, _alt is a boolean for if the keys are held down
	}, 
	_object, //any objects the line should be drawn from
	[], //arguments to the function, anything
	"", //the icon
	45, //the icon angle
	[1,0,0,1] //the icon color
] call MAZ_EZM_fnc_selectSecondaryPosition;
```
<hr>

#### MAZ_EZM_fnc_addObjectToInterface
This function adds the passed objects to the Zeus interface. You can even select which Zeus gets them added
```sqf
[
	_object1, //Adds a single object
	getAssignedCuratorLogic player //To just our Zeus
] call MAZ_EZM_fnc_addObjectToInterface;

[
	[_object1,_object2] //Adds multiple objects to all Zeuses
] call MAZ_EZM_fnc_addObjectToInterface;
```

<hr>

#### MAZ_EZM_fnc_removeObjectFromInterface
This function works just like `MAZ_EZM_fnc_addObjectToInterface` except it removes them.
```sqf
[_object] call MAZ_EZM_fnc_removeObjectFromInterface;
```

<hr>

#### MAZ_EZM_fnc_deleteAttachedWhenKilled
This function will delete all the attached objects when the object passed is killed. This is useful for any sort of vehicles with things attached or unique compositions.
```sqf
[_myVehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
```

<hr>

#### MAZ_EZM_fnc_deleteAttachedWhenDeleted
This function will delete all the attached objects when the object passed is deleted. This is useful for any sort of vehicles with things attached or unique compositions.
```sqf
[_myVehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
```

<hr>

#### MAZ_EZM_fnc_cleanerWaitTilNoPlayers
This function adds the object passed into the cleaner system so it can be auto-deleted when players are far away.
```sqf
//Must be in scheduled environment. You cannot CALL this function.
[_myEntity] spawn MAZ_EZM_fnc_cleanerWaitTilNoPlayers;
```

<hr>

## Thank You for Contributing!
Thank you for taking the time to look into the contribution information for E.Z.M. The community is what makes this entire project worth it, I hope to see some awesome things from you guys. If you find yourself needing more information to contribute please let me know and I can update this guide.
