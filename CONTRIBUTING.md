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

## Thank You for Contributing!
Thank you for taking the time to look into the contribution information for E.Z.M. The community is what makes this entire project worth it, I hope to see some awesome things from you guys. If you find yourself needing more information to contribute please let me know and I can update this guide.
