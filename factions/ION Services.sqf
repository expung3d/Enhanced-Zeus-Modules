if(!isNull (findDisplay 312) && {!isNil "this"} && {!isNull this}) then { 
 deleteVehicle this; 
}; 

if(isNil "MAZ_EZM_Version") exitWith {
    systemChat "Enhanced Zeus Modules is not running!";
    playSound "addItemFailed";
};

if(isNil "MAZ_EZM_fnc_addNewFactionToDynamicFactions") exitWith {
    ["Your version of EZM is incompatible with dynamic factions. Please use the latest version!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

if(!isNil "MAZ_EZM_ION") exitWith {
    ["ION Services is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_ION_Ver = "1.1";
MAZ_EZM_ION = true;

comment "ION Units";  
    comment "APCs";  

        MAZ_EZM_ION_fnc_createPantherModule = {  
            private _vehicle = ["B_APC_Tracked_01_rcws_F",["a3\armor_f_beta\apc_tracked_01\data\apc_tracked_01_body_co.paa","a3\armor_f_beta\apc_tracked_01\data\mbt_01_body_co.paa","a3\data_f\vehicles\turret_co.paa","a3\armor_f\data\camonet_csat_stripe_desert_co.paa"]] call MAZ_EZM_fnc_createVehicle; 
            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true; 

            _vehicle animateSource ["showCamonetHull",1];
            _vehicle animateSource ["showBags",0];

            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createCrewmanModule;  
                _driver moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createCrewmanModule;  
                _gunner moveInGunner _vehicle;  
                
                private _commander = [] call MAZ_EZM_ION_fnc_createCrewmanModule;  
                _commander moveInCommander _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_driver,_gunner,_commander] joinSilent _grp;  
                _grp selectLeader _commander;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createPantherUnarmedModule = {  
            private _vehicle = ["B_APC_Tracked_01_rcws_F",["a3\armor_f_beta\apc_tracked_01\data\apc_tracked_01_body_co.paa","a3\armor_f_beta\apc_tracked_01\data\mbt_01_body_co.paa","a3\data_f\vehicles\turret_co.paa","a3\armor_f\data\camonet_csat_stripe_desert_co.paa"]] call MAZ_EZM_fnc_createVehicle; 
            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true; 


            _vehicle animate['HideTurret',1];
            _vehicle lockTurret [[0],true]; 
            _vehicle removeWeaponTurret ["GMG_40mm", [0]];
            _vehicle removeWeaponTurret ["HMG_127_APC", [0]];

            _vehicle animateSource ["showCamonetHull",1];
            _vehicle animateSource ["showBags",0];
                
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createCrewmanModule;  
                _driver moveInDriver _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  
    
    comment "Boats";  
    
        MAZ_EZM_ION_fnc_createRhibBoatModule = {  
            private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_driver,_gunner] joinSilent _grp;  
                _grp selectLeader _driver;  
            };  
            
            _vehicle  
        };  
        
    comment "Cars";  
        
        MAZ_EZM_ION_fnc_createHatchbackModule = {  
            private _vehicle = ["C_Hatchback_01_sport_red_F",["a3\soft_f_gamma\hatchback_01\data\hatchback_01_ext_base08_co.paa"]] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createGuardSMGModule;  
                _driver moveInDriver _vehicle;  
            };  

            _vehicle  
        };

        MAZ_EZM_ION_fnc_createOffroadModule = {  
            private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Green",1],   
                ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]  
            ] call BIS_fnc_initVehicle;  

            _vehicle setObjectTextureGlobal [0,"a3\soft_f_enoch\offroad_01\data\offroad_01_ext_blk_co.paa"];
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        }; 

        MAZ_EZM_ION_fnc_createOffroadPortModule = {  
            private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Green",1],   
                ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]  
            ] call BIS_fnc_initVehicle;  

            _vehicle setObjectTextureGlobal [0,"a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_repair_civ_co.paa"];
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createGuardRifleModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        }; 
            
        MAZ_EZM_ION_fnc_createOffroadCoveredModule = {  
            private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Black",1],   
                ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0]  
            ] call BIS_fnc_initVehicle;  

            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };

        MAZ_EZM_ION_fnc_createOffroadJammerModule = {  
                
            private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
            _vehicle setPosWorld [24481.3,19130.9,4.90674];
            _vehicle setVectorDirAndUp [[-0.00261094,0.999997,0],[0,0,1]];
            _vehicle setHitPointDamage ["hitglass3", 1];
            _vehicle lockCargo [1, true];
            _vehicle lockCargo [2, true];

            [ 
                _vehicle, 
                ["Black",1],  
                ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",1,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0] 
            ] call BIS_fnc_initVehicle; 
            _vehicle setFuelConsumptionCoef 1;
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  

            _simpleObject_0 = createSimpleObject ['Land_PortableCabinet_01_lid_black_F', [24481.253906,19129.564453,5.365244]]; 
            _simpleObject_0 setVectorDirAndUp [[-1.2,0,0],[0,0.01,1.2]]; 
            [_simpleObject_0, _vehicle] call BIS_fnc_attachToRelative; 
            [_simpleObject_0,1.2] remoteExec ['setObjectScale',0,_simpleObject_0];
            _simpleObject_1 = createSimpleObject ['a3\boat_f_jets\carrier_01\carrier_01_island_03_f.p3d', [24481.289063,19129.681641,4.943081]];
            _simpleObject_1 setVectorDirAndUp [[-0.1,0,0],[0,0,0.1]];
            [_simpleObject_1, _vehicle] call BIS_fnc_attachToRelative;
            [_simpleObject_1,0.1] remoteExec ['setObjectScale',0,_simpleObject_1];
            _simpleObject_2 = createSimpleObject ['Land_Router_01_black_F', [24481.251953,19128.935547,5.233574]];
            _simpleObject_2 setVectorDirAndUp [[0.04,5,0],[0,0,5]];
            [_simpleObject_2, _vehicle] call BIS_fnc_attachToRelative;
            [_simpleObject_2,5] remoteExec ['setObjectScale',0,_simpleObject_2];
            _simpleObject_3 = createSimpleObject ['Land_PortableDesk_01_panel_black_F', [24481.248047,19128.371094,4.687862]];
            _simpleObject_3 setVectorDirAndUp [[0,0.01,-1.2],[0,-1.2,-0.01]];
            [_simpleObject_3, _vehicle] call BIS_fnc_attachToRelative;
            [_simpleObject_3,1.2] remoteExec ['setObjectScale',0,_simpleObject_3];
            _simpleObject_4 = createSimpleObject ['Land_PortableDesk_01_panel_black_F', [24481.513672,19130.664063,4.720433]];
            _simpleObject_4 setVectorDirAndUp [[-0.01,0,-1],[0,1,0]];
            [_simpleObject_4, _vehicle] call BIS_fnc_attachToRelative;
            [_simpleObject_4,1] remoteExec ['setObjectScale',0,_simpleObject_4];
            _simpleObject_5 = createSimpleObject ['Land_PortableDesk_01_panel_black_F', [24480.974609,19130.664063,4.728301]];
            _simpleObject_5 setVectorDirAndUp [[-0.01,0,-1],[0,1,0]];
            [_simpleObject_5, _vehicle] call BIS_fnc_attachToRelative;
            [_simpleObject_5,1] remoteExec ['setObjectScale',0,_simpleObject_5];
            _simpleObject_6 = createSimpleObject ['Land_PortableDesk_01_panel_black_F', [24481.0253906,19128.439453,4.862167]];
            _simpleObject_6 setVectorDirAndUp [[0.01,0,-1],[0,-1,0]];
            [_simpleObject_6, _vehicle] call BIS_fnc_attachToRelative;
            [_simpleObject_6,1] remoteExec ['setObjectScale',0,_simpleObject_6];
            _simpleObject_7 = createSimpleObject ['Land_PortableDesk_01_panel_black_F', [24481.462891,19128.431641,4.870035]];
            _simpleObject_7 setVectorDirAndUp [[0.01,0,-1],[0,-1,0]];
            [_simpleObject_7, _vehicle] call BIS_fnc_attachToRelative;
            [_simpleObject_7,1] remoteExec ['setObjectScale',0,_simpleObject_7];
            _simpleObject_8 = createSimpleObject ['Land_PortableDesk_01_panel_black_F', [24481.259766,19129.306641,5.37815]]; 
            _simpleObject_8 setVectorDirAndUp [[0,-0.5,0],[0,0,0.5]]; 
            [_simpleObject_8, _vehicle] call BIS_fnc_attachToRelative; 
            [_simpleObject_8,0.5] remoteExec ['setObjectScale',0,_simpleObject_8];
            _simpleObject_9 = createSimpleObject ['Land_PortableDesk_01_panel_black_F', [24481.132813,19129.808594,5.377479]]; 
            _simpleObject_9 setVectorDirAndUp [[0.4,0,0],[0,0.01,0.4]]; 
            [_simpleObject_9, _vehicle] call BIS_fnc_attachToRelative; 
            [_simpleObject_9,0.4] remoteExec ['setObjectScale',0,_simpleObject_9];

            _item23 = createTrigger ["EmptyDetector",[24480.9,19130.6,1.28223],false];
            _this = _item23;
            _item23 setPosATL [24480.9,19130.6,1.28223];
            _this setTriggerArea [600,600,0,false,600];
            _this setTriggerActivation ["ANY","PRESENT",true];
            _this setTriggerStatements ["{unitIsUAV _x && side _x in [east,independent]} count thisList > 0;","  
            {if (unitIsUAV _x && side _x in [east,independent]) then {  
            _x setFuel 0 &&   
            objNull remoteControl driver _x &&   
            player disableUAVConnectability [_x, false] &&  
            _x lockDriver true &&  
            _x lockturret [[0,0],true] &&                      
            _x lockturret [[0],true];  
            };} forEach thisList;",""];
            JmTrgA1 = _this;
            _this setTriggerText "Drone_Jammer_Trigger_A1";
            [_this, _vehicle] call BIS_fnc_attachToRelative;

            _item24 = createTrigger ["EmptyDetector",[24480.9,19130.6,1.28223],false];
            _this = _item24;
            _item24 setPosATL [24480.9,19130.6,1.28223];
            _this setTriggerArea [600,600,0,false,600];
            _this setTriggerActivation ["ANY","PRESENT",true];
            _this setTriggerStatements ["{unitIsUAV _x && isTouchingGround _x && side _x in [east,independent]} count thisList > 0;","
            {if (unitIsUAV _x && isTouchingGround _x && side _x in [east,independent]) then {deleteVehicle _x};} forEach thisList;",""];
            JmTrgA2 = _this;
            _this setTriggerText "Drone_Jammer_Trigger_A2";
            _this setTriggerTimeout [10,10,10,true];
            [_this, _vehicle] call BIS_fnc_attachToRelative;

            _item25 = createTrigger ["EmptyDetector",[24480.9,19130.6,1.28223],false];
            _this = _item25;
            _item25 setPosATL [24480.9,19130.6,1.28223];
            _this setTriggerStatements ["!Alive _vehicle;","deleteVehicle JmTrgA1;
            deleteVehicle JmTrgA2;
            ",""];
            JmTrgA_Delete = _this;
            [_this, _vehicle] call BIS_fnc_attachToRelative;

            _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition); 

            _vehicle 

        };  
            
        MAZ_EZM_ION_fnc_createOffroadRepairModule = {  
            private _vehicle = ["C_Offroad_01_repair_F"] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  

            _vehicle setObjectTextureGlobal [0,"a3\soft_f_enoch\offroad_01\data\offroad_01_ext_blk_co.paa"];
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createOffroadHMGModule = {  
            private _vehicle = ["I_G_Offroad_01_armed_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Green",1],   
                ["Hide_Shield",0,"Hide_Rail",1,"HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0]  
            ] call BIS_fnc_initVehicle;  
            
            _vehicle setObjectTextureGlobal [0,"a3\soft_f_enoch\offroad_01\data\offroad_01_ext_blk_co.paa"];

            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _gunner moveInGunner _vehicle;  
                private _grp = createGroup [west,true];  
                [_driver,_gunner] joinSilent _grp;  
                _grp selectLeader _driver;  
            };  
            
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createProwlerModule = {  
            private _vehicle = ["B_LSV_01_unarmed_black_F"] call MAZ_EZM_fnc_createVehicle;  
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                [_driver] call MAZ_EZM_ION_fnc_addIONBackpack;  
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
            };  
            _vehicle  
        };

        MAZ_EZM_ION_fnc_createProwlerATModule = {  
            private _vehicle = ["B_LSV_01_AT_F"] call MAZ_EZM_fnc_createVehicle;  
            [_vehicle,"Black"] call bis_fnc_initVehicle;
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle;  
                _gunner moveinGunner _vehicle;  
                [_driver] call MAZ_EZM_ION_fnc_addIONBackpack;  
                [_gunner] call MAZ_EZM_ION_fnc_addIONBackpack; 
                private _grp = createGroup [west,true];  
                [_driver,_gunner] joinSilent _grp;  
                _grp selectLeader _gunner;  
            };  
            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true; 
            _vehicle  
        };

        MAZ_EZM_ION_fnc_createProwlerHMGModule = {  
            private _vehicle = ["B_LSV_01_armed_black_F"] call MAZ_EZM_fnc_createVehicle;  
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                _gunner moveinGunner _vehicle;  
                [_driver] call MAZ_EZM_ION_fnc_addIONBackpack;  
                [_gunner] call MAZ_EZM_ION_fnc_addIONBackpack; 
                private _grp = createGroup [west,true];  
                [_driver,_gunner] joinSilent _grp;  
                _grp selectLeader _gunner;  
            };  
            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true; 
            _vehicle  
        };
            
        MAZ_EZM_ION_fnc_createJeepModule = {  
            private _vehicle = ["I_C_Offroad_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Olive",1],   
                ["hideLeftDoor",0,"hideRightDoor",0,"hideRearDoor",0,"hideBullbar",0,"hideFenders",0,"hideHeadSupportRear",0,"hideHeadSupportFront",0,"hideRollcage",1,"hideSeatsRear",0,"hideSpareWheel",1]  
            ] call BIS_fnc_initVehicle;  
            
            _vehicle setObjectTextureGlobal [0, "\a3\data_f\black.paa"];  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createGuardRifleModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createJeepLMGModule = {  
            private _vehicle = ["I_C_Offroad_02_LMG_F"] call MAZ_EZM_fnc_createVehicle; 
            _vehicle removeMagazines "200Rnd_556x45_Box_Tracer_F";  
            _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]];  
            _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]];  
            _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]];
            _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]]; 
            _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]]; 
            _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]]; 
            
            [  
                _vehicle,  
                ["Olive",1],   
                ["hideLeftDoor",0,"hideRightDoor",0,"hideRearDoor",0,"hideBullbar",0,"hideFenders",0,"hideHeadSupportRear",0,"hideHeadSupportFront",0,"hideRollcage",1,"hideSeatsRear",0,"hideSpareWheel",1]  
            ] call BIS_fnc_initVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _gunner moveInGunner _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_driver,_gunner] joinSilent _grp;  
                _grp selectLeader _gunner;  
            }; 

            _vehicle setObjectTextureGlobal [0,"\a3\data_f\black.paa"];
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createQuadbikeModule = {  
            private _vehicle = ["C_Quadbike_01_black_F"] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                _passanger moveinCargo _vehicle;  
                [_driver] call MAZ_EZM_ION_fnc_addIONBackpack;  
                [_passanger] call MAZ_EZM_ION_fnc_addIONBackpack;  
                private _grp = createGroup [west,true];  
                [_driver,_passanger] joinSilent _grp;  
                _grp selectLeader _driver;  
            };  
            
            _vehicle  
        };

        MAZ_EZM_ION_fnc_createStriderModule = {  
            private _vehicle = ["I_MRAP_03_F",["\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa","\A3\data_f\vehicles\turret_co.paa"]] call MAZ_EZM_fnc_createVehicle;  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _commander = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger = [] call MAZ_EZM_ION_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle;  
                _commander moveincommander _vehicle;  
                _passanger moveincargo _vehicle; 
                [_driver] call MAZ_EZM_ION_fnc_addIONBackpack;  
                [_commander] call MAZ_EZM_ION_fnc_addIONBackpack; 
                private _grp = createGroup [west,true];  
                [_driver,_commander,_passanger] joinSilent _grp;  
                _grp selectLeader _commander;  
            };  

            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true;
            
            _vehicle  
        }; 
        
        MAZ_EZM_ION_fnc_createStriderHMGModule = {  
            private _vehicle = ["I_MRAP_03_hmg_F",["\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa","\A3\data_f\vehicles\turret_co.paa"]] call MAZ_EZM_fnc_createVehicle;  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule; 
                private _commander = [] call MAZ_EZM_ION_fnc_createRiflemanModule;   
                _driver moveInDriver _vehicle;  
                _gunner moveinGunner _vehicle; 
                _commander moveinCommander _vehicle;   
                [_driver] call MAZ_EZM_ION_fnc_addIONBackpack;  
                [_gunner] call MAZ_EZM_ION_fnc_addIONBackpack; 
                private _grp = createGroup [west,true];  
                [_driver,_gunner,_commander] joinSilent _grp;  
                _grp selectLeader _gunner;  
            };  

            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true; 
            
            _vehicle  
        }; 
        
        MAZ_EZM_ION_fnc_createStriderGMGModule = {  
            private _vehicle = ["I_MRAP_03_gmg_F",["\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa","\A3\data_f\vehicles\turret_co.paa"]] call MAZ_EZM_fnc_createVehicle;  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule; 
                private _commander = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                _gunner moveinGunner _vehicle;  
                _commander moveinCommander _vehicle; 
                [_driver] call MAZ_EZM_ION_fnc_addIONBackpack;  
                [_gunner] call MAZ_EZM_ION_fnc_addIONBackpack; 
                private _grp = createGroup [west,true];  
                [_driver,_gunner,_commander] joinSilent _grp;  
                _grp selectLeader _gunner;  
            };  

            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true; 
            
            _vehicle  
        };
      
    comment "Compositions";
       
        MAZ_EZM_ION_fnc_createCacheModule = { 
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 
        
            _box = createVehicle ["Land_PlasticCase_01_medium_black_F",[24504.3,19008,-0.00255609],[],0,"CAN_COLLIDE"];
            _box setPosWorld [24504.3,19008,3.38157];
            _box setVectorDirAndUp [[-0.999621,0.0275377,0],[0,0,1]];
            _box setObjectTextureGlobal  [0,""];  

            _item21 = createSimpleObject ["Land_Ammobox_rounds_F",[24504.2,19007.6,3.38403]];
            _this = _item21;
            _objects pushback _this;
            _objectIDs pushback 21;
            _this setPosWorld [24504.2,19007.6,3.48939];
            _this setVectorDirAndUp [[-0.0166643,-0.999861,0],[0,0,1]];
            [_this, _box] call BIS_fnc_attachToRelative;  
    
            _item22 = createSimpleObject ["Land_Ammobox_rounds_F",[24504.5,19007.6,3.38723]]; 
            _this = _item22; 
            _objects pushback _this; 
            _objectIDs pushback 22; 
            _this setPosWorld [24504.53,19007.6,3.49259]; 
            _this setVectorDirAndUp [[-0.0166643,-0.999861,0],[0,0,1]]; 
            [_this, _box] call BIS_fnc_attachToRelative;  

            _item15 = createSimpleObject ["Land_ConcreteHedgehog_01_palette_F",[24504.3,19007.9,3.37506]];
            _this = _item15;
            _objects pushback _this;
            _objectIDs pushback 15;
            _this setPosWorld [24504.3,19007.9,2.73225];
            _this setVectorDirAndUp [[-0.899999,0.0012725,-7.75855e-05],[7.88069e-05,0.000863807,-0.9]];
            [_this, _box] call BIS_fnc_attachToRelative;  
            [_this,0.9] remoteExec ['setObjectScale',0,_this];

            _item16 = createSimpleObject ["Land_ConcreteHedgehog_01_palette_F",[24504.3,19008,3.37306]];
            _this = _item16;
            _objects pushback _this;
            _objectIDs pushback 16;
            _this setPosWorld [24504.3,19008,2.73025];
            _this setVectorDirAndUp [[-0.899999,0.0012725,-7.75855e-05],[7.88069e-05,0.000863807,-0.9]];
            [_this, _box] call BIS_fnc_attachToRelative;  
            [_this,0.9] remoteExec ['setObjectScale',0,_this];
            
            _item12 = createSimpleObject ["Land_PlasticCase_01_small_black_F",[24503.9,19008,3.387]]; 
            _this = _item12; 
            _objects pushback _this; 
            _objectIDs pushback 12; 
            _this setPosWorld [24503.85,19008,3.54366]; 
            _this setVectorDirAndUp [[-0.0115712,-0.999933,0],[0,0,1]]; 
            [_this, _box] call BIS_fnc_attachToRelative;   

            _item36 = createSimpleObject ["Land_MultiScreenComputer_01_closed_black_F",[24503.9,19008,3.67722]];
            _this = _item36;
            _objects pushback _this;
            _objectIDs pushback 36;
            _this setPosWorld [24503.9,19008,3.92731];
            _this setVectorDirAndUp [[0.999974,-0.00727258,0],[0,0,1]];
            [_this, _box] call BIS_fnc_attachToRelative;  

            _item9 = createSimpleObject ["Land_PortableCabinet_01_closed_black_F",[24504.4,19008,3.37909]];
            _this = _item9;
            _objects pushback _this;
            _objectIDs pushback 9;
            _this setPosWorld [24504.4,19008,3.54267];
            _this setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_this, _box] call BIS_fnc_attachToRelative;  

            _item10 = createSimpleObject ["Land_PortableCabinet_01_closed_black_F",[24504.4,19008,3.67845]]; 
            _this = _item10; 
            _objects pushback _this; 
            _objectIDs pushback 10; 
            _this setPosWorld [24504.4,19008,3.83667]; 
            _this setVectorDirAndUp [[0,0.9,0],[0,0,0.9]]; 
            [_this, _box] call BIS_fnc_attachToRelative;   
            [_this,0.9] remoteExec ['setObjectScale',0,_this];

            _simpleObject_1 = createSimpleObject ['a3\weapons_f\ammo\anm8_white.p3d', [24503.925781,19007.591797,3.467545]];
            _simpleObject_1 setVectorDirAndUp [[0.94,-0.34,0],[0,0,1]];
            [_simpleObject_1, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_1,1] remoteExec ['setObjectScale',0,_simpleObject_1];
            _simpleObject_2 = createSimpleObject ['a3\weapons_f\ammo\anm8_white.p3d', [24503.99,19007.595703,3.462565]]; 
            _simpleObject_2 setVectorDirAndUp [[0.96,0.28,0],[0,0,1]]; 
            [_simpleObject_2, _box] call BIS_fnc_attachToRelative;   
            [_simpleObject_2,1] remoteExec ['setObjectScale',0,_simpleObject_2];
            _simpleObject_3 = createSimpleObject ['a3\weapons_f_tank\launchers\mraws\rocket_mraws_heat55_f_item.p3d', [24504.722656,19007.695313,3.744405]];
            _simpleObject_3 setVectorDirAndUp [[0.99,-0.13,0],[-0.13,-0.99,0]];
            [_simpleObject_3, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_3,1] remoteExec ['setObjectScale',0,_simpleObject_3];
            _simpleObject_4 = createSimpleObject ['a3\weapons_f_tank\launchers\mraws\rocket_mraws_heat55_f_item.p3d', [24504.808594,19007.693359,3.744727]];
            _simpleObject_4 setVectorDirAndUp [[1,0.03,0],[0.03,-1,0]];
            [_simpleObject_4, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_4,1] remoteExec ['setObjectScale',0,_simpleObject_4];

            _simpleObject_0 = createSimpleObject ['a3\structures_f_mark\training\shootingmat_01_f.p3d', [24504.246094,19008.0976563,3.386943]];
            _simpleObject_0 setVectorDirAndUp [[0.7,0,0],[0,0,0.7]];
            [_simpleObject_0, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_0,0.7] remoteExec ['setObjectScale',0,_simpleObject_0];
            _simpleObject_1 = createSimpleObject ['a3\structures_f_mark\training\shootingmat_01_f.p3d', [24504.25,19007.751953,3.386033]];
            _simpleObject_1 setVectorDirAndUp [[0.7,-0.01,0],[0,0,0.7]];
            [_simpleObject_1, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_1,0.7] remoteExec ['setObjectScale',0,_simpleObject_1];

            [_box] call MAZ_EZM_fnc_deleteAttachedWhenKilled; 
            [_box] call MAZ_EZM_fnc_deleteAttachedWhenDeleted; 
            [_box] call MAZ_EZM_fnc_addObjectToInterface; 
        
            _box setpos _pos; 
            
            _box
        };

        MAZ_EZM_ION_fnc_createCacheArsenalModule = { 
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 
        
            _box = createVehicle ["Box_NATO_Ammo_F",[24504.3,19008,-0.00255609],[],0,"CAN_COLLIDE"];
            _box setPosWorld [24504.3,19008,3.47];
            _box setVectorDirAndUp [[-0.999621,0.0275377,0],[0,0,1]];
            [_box, false] remoteExec ['allowDamage']; 
            _box setObjectTextureGlobal  [0,""];  
            _box setObjectTextureGlobal  [1,""]; 

            clearBackpackCargoGlobal _box;
            clearMagazineCargoGlobal _box;
            clearWeaponCargoGlobal _box;
            clearItemCargoGlobal _box;

            private _fnc_addArmoryActions = {
                params ["_box"];
                [_box,["launch_NLAW_F","arifle_Mk20_plain_F","arifle_Mk20C_plain_F","arifle_Mk20_GL_plain_F","arifle_MXC_Black_F","arifle_MX_Black_F","arifle_MX_GL_Black_F","arifle_MXM_Black_F","hgun_PDW2000_F","SMG_01_F","SMG_02_F","SMG_03_TR_black","SMG_03C_TR_black","SMG_03_black","SMG_03C_black","arifle_AK12_F","arifle_AK12_GL_F","arifle_SPAR_01_blk_F","arifle_SPAR_01_GL_blk_F","SMG_05_F","arifle_AK12U_F","arifle_MSBS65_black_F","arifle_MSBS65_Mark_black_F","arifle_MSBS65_GL_black_F","arifle_MX_SW_Black_F","LMG_03_F","LMG_03_Vehicle_F","arifle_SPAR_02_blk_F","LMG_Mk200_black_F","srifle_EBR_F","srifle_DMR_03_F","srifle_DMR_06_olive_F","arifle_SPAR_03_blk_F","launch_MRAWS_green_F","launch_MRAWS_green_rail_F","launch_RPG32_green_F","hgun_ACPC2_F","hgun_P07_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_02_F","hgun_P07_blk_F","hgun_Pistol_heavy_01_green_F"],true,false] call BIS_fnc_addVirtualWeaponCargo; 
                [_box,["acc_flashlight","bipod_01_F_blk","optic_Arco","optic_Hamr","optic_Aco","optic_ACO_grn","optic_Aco_smg","optic_ACO_grn_smg","acc_flashlight_smg_01","acc_flashlight_pistol","acc_pointer_IR","optic_MRCO","optic_NVS","optic_Yorris","optic_Arco_blk_F","optic_ERCO_blk_F","optic_Holosight_blk_F","optic_Holosight_smg_blk_F","optic_ico_01_black_f","optic_Arco_AK_blk_F","ChemicalDetector_01_black_F","U_I_G_Story_Protagonist_F","U_Marshal","U_I_C_Soldier_Bandit_3_F","U_C_Man_casual_3_F","U_I_L_Uniform_01_tshirt_skull_F","U_I_L_Uniform_01_tshirt_black_F","V_Rangemaster_belt","V_BandollierB_blk","V_PlateCarrier2_blk","V_PlateCarrier1_blk","V_Chestrig_blk","V_TacVest_blk","V_TacVestIR_blk","V_LegStrapBag_black_F","V_CarrierRigKBT_01_Olive_F","V_CarrierRigKBT_01_light_Olive_F","H_Booniehat_mcamo","H_Cap_headphones","H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_CrewHelmetHeli_B","H_Cap_blk_ION","H_Cap_oli_hs","H_Cap_usblack","H_MilCap_gry","H_Bandanna_gry","H_Bandanna_mcamo","H_Watchcap_blk","H_HeadSet_black_F","H_PASGT_basic_black_F","H_HelmetHBK_F","G_Shades_Black","G_Shades_Green","G_Shades_Red","G_Tactical_Black","G_Balaclava_blk","G_Bandanna_blk","G_Bandanna_beast","G_Bandanna_shades","G_Bandanna_sport","G_Bandanna_aviator","G_Shades_Blue","G_Tactical_Clear","G_AirPurifyingRespirator_01_F","G_Balaclava_Skull1","H_PilotHelmetHeli_B","H_HelmetB_light_black","ItemWatch","ItemCompass","ItemGPS","ItemRadio","ItemMap","MineDetector","Binocular","Rangefinder","NVGoggles_OPFOR","Laserdesignator","FirstAidKit","Medikit","ToolKit","B_UavTerminal","Laserdesignator_01_khk_F","ChemicalDetector_01_watch_F","U_BG_Guerilla2_2","U_I_G_resistanceLeader_F","U_B_HeliPilotCoveralls","U_B_CTRG_Soldier_2_Arid_F","H_WirelessEarpiece_F","G_WirelessEarpiece_F","G_Bandanna_Skull1","muzzle_snds_H","muzzle_snds_L","muzzle_snds_M","muzzle_snds_B","optic_Holosight","muzzle_snds_acp","muzzle_snds_570","muzzle_snds_65_TI_blk_F"],true,false] call BIS_fnc_addVirtualItemCargo; 
                [_box,["B_AssaultPack_blk","B_FieldPack_blk","B_Carryall_blk","B_LegStrapBag_black_F","B_RadioBag_01_black_F","B_Kitbag_rgr","B_Carryall_green_F","B_FieldPack_green_F"],true,false] call BIS_fnc_addVirtualBackpackCargo; 
                [_box,["16Rnd_9x21_Mag","30Rnd_45ACP_Mag_SMG_01","20Rnd_762x51_Mag","1Rnd_HE_Grenade_shell","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","Chemlight_green","NLAW_F","HandGrenade","MiniGrenade","SmokeShell","SmokeShellGreen","UGL_FlareWhite_F","UGL_FlareGreen_F","UGL_FlareRed_F","UGL_FlareYellow_F","UGL_FlareCIR_F","1Rnd_SmokeRed_Grenade_shell","1Rnd_SmokeYellow_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","30Rnd_556x45_Stanag","30Rnd_556x45_Stanag_Tracer_Red","30Rnd_556x45_Stanag_Tracer_Green","30Rnd_556x45_Stanag_Tracer_Yellow","30Rnd_556x45_Stanag_red","30Rnd_556x45_Stanag_green","30Rnd_65x39_caseless_black_mag","30Rnd_65x39_caseless_black_mag_Tracer","100Rnd_65x39_caseless_black_mag","100Rnd_65x39_caseless_black_mag_tracer","3Rnd_UGL_FlareWhite_F","3Rnd_UGL_FlareGreen_F","3Rnd_UGL_FlareRed_F","3Rnd_UGL_FlareYellow_F","3Rnd_UGL_FlareCIR_F","3Rnd_Smoke_Grenade_shell","3Rnd_SmokeRed_Grenade_shell","3Rnd_SmokeGreen_Grenade_shell","3Rnd_SmokeYellow_Grenade_shell","3Rnd_SmokePurple_Grenade_shell","3Rnd_SmokeBlue_Grenade_shell","3Rnd_SmokeOrange_Grenade_shell","30Rnd_9x21_Mag","30Rnd_9x21_Red_Mag","30Rnd_9x21_Yellow_Mag","30Rnd_9x21_Green_Mag","16Rnd_9x21_red_Mag","16Rnd_9x21_green_Mag","16Rnd_9x21_yellow_Mag","30Rnd_45ACP_Mag_SMG_01_Tracer_Green","30Rnd_45ACP_Mag_SMG_01_Tracer_Red","30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow","30Rnd_9x21_Mag_SMG_02","30Rnd_9x21_Mag_SMG_02_Tracer_Red","30Rnd_9x21_Mag_SMG_02_Tracer_Yellow","30Rnd_9x21_Mag_SMG_02_Tracer_Green","50Rnd_570x28_SMG_03","30Rnd_762x39_AK12_Mag_F","30Rnd_762x39_Mag_F","30Rnd_762x39_Mag_Green_F","30Rnd_762x39_Mag_Tracer_F","30Rnd_762x39_Mag_Tracer_Green_F","30Rnd_762x39_AK12_Mag_Tracer_F","75Rnd_762x39_Mag_F","75Rnd_762x39_Mag_Tracer_F","75rnd_762x39_AK12_Mag_F","75rnd_762x39_AK12_Mag_Tracer_F","150Rnd_556x45_Drum_Mag_F","150Rnd_556x45_Drum_Mag_Tracer_F","30Rnd_65x39_caseless_msbs_mag","30Rnd_65x39_caseless_msbs_mag_Tracer","2Rnd_12Gauge_Pellets","2Rnd_12Gauge_Slug","200Rnd_65x39_cased_Box","200Rnd_65x39_cased_Box_Tracer","200Rnd_65x39_cased_Box_Red","200Rnd_65x39_cased_Box_Tracer_Red","130Rnd_338_Mag","200Rnd_556x45_Box_F","200Rnd_556x45_Box_Red_F","200Rnd_556x45_Box_Tracer_F","200Rnd_556x45_Box_Tracer_Red_F","10Rnd_Mk14_762x51_Mag","RPG32_F","MRAWS_HEAT_F","MRAWS_HEAT55_F","9Rnd_45ACP_Mag","11Rnd_45ACP_Mag","6Rnd_45ACP_Cylinder","10Rnd_9x21_Mag","SmokeShellYellow","SmokeShellRed","SmokeShellPurple","SmokeShellOrange","SmokeShellBlue","Chemlight_red","Chemlight_yellow","Chemlight_blue","DemoCharge_Remote_Mag","SatchelCharge_Remote_Mag","ClaymoreDirectionalMine_Remote_Mag","SLAMDirectionalMine_Wire_Mag","B_IR_Grenade"],true,false] call BIS_fnc_addVirtualMagazineCargo; 
                
                if(isNil "MAZ_EZM_ION_ArsenalAr") then {
                    private _arsenalAction = {
                        params ["_box"];
                        private _id = _box addAction [
                            "Arsenal",
                            {
                                params ["_target", "_caller", "_actionId", "_arguments"];

                                if(!isNil "MAZ_SEH_arsenalOpened_IONUniform") then {
                                    [missionNamespace,"arsenalOpened",MAZ_SEH_arsenalOpened_IONUniform] call BIS_fnc_removeScriptedEventHandler;
                                };
                                MAZ_SEH_arsenalOpened_IONUniform = [missionNamespace, "arsenalOpened", {
                                    params ["_display","_togglespace"];
                                    MAZ_MRP_ArsenalOpen = true;
                                    [] spawn {
                                        while {MAZ_MRP_ArsenalOpen} do {
                                            [player] call MAZ_MRP_fnc_IONUniform;
                                            sleep 0.1;
                                        };
                                    };
                                }] call BIS_fnc_addScriptedEventHandler;

                                if(!isNil "MAZ_SEH_arsenalClosed_IONUniform") then {
                                    [missionNamespace,"arsenalClosed",MAZ_SEH_arsenalClosed_IONUniform] call BIS_fnc_removeScriptedEventHandler;
                                };
                                MAZ_SEH_arsenalClosed_IONUniform = [missionNamespace, "arsenalClosed", {
                                    params ["_display","_togglespace"];
                                    MAZ_MRP_ArsenalOpen = false;
                                }] call BIS_fnc_addScriptedEventHandler;

                                if(!isNil "MAZ_SEH_IONLoadout") then {
                                    [missionNamespace,"MAZ_LA_LoadoutApplied",MAZ_SEH_IONLoadout] call BIS_fnc_removeScriptedEventHandler;
                                };
                                MAZ_SEH_IONLoadout = [missionNamespace, "MAZ_LA_LoadoutApplied", {
                                    params ["_box","_loadout"];
                                    [_box] call MAZ_MRP_fnc_IONUniform;
                                }] call BIS_fnc_addScriptedEventHandler;
                                if(!isNil "MAZ_EH_Respawn_IONLoadout") then {
                                    player removeEventhandler ["Respawn",MAZ_EH_Respawn_IONLoadout];
                                };
                                MAZ_EH_Respawn_IONLoadout = player addEventhandler ["Respawn",{
                                    [player] call MAZ_MRP_fnc_IONUniform;
                                }];

                                ["Preload"] call BIS_fnc_arsenal;
                                ["Open", [false,_target,_caller]] call BIS_fnc_arsenal;
                                showChat true;
                            },
                            nil,
                            1.5,
                            true,
                            true,
                            "",
                            "_target distance _this < 5",
                            50
                        ];
                    };
                    MAZ_EZM_ION_ArsenalAr = ['t',_arsenalAction];
                    publicVariable "MAZ_EZM_ION_ArsenalAr";
                };
                [[_box], {
                    params ["_box"];
                    [_box] call (MAZ_EZM_ION_ArsenalAr # 1);
                }] remoteExec ["spawn",0,_box];
            };

            MAZ_MRP_fnc_IONUniform = {
                params ["_unit"];
                switch (uniform _unit) do {
                    case "U_B_CTRG_Soldier_2_Arid_F": {
                        _unit setObjectTextureGlobal [0,"\a3\characters_f\BLUFOR\Data\clothing_wdl_co.paa"];
                    };
                    case "U_C_Man_casual_3_F": {
                        _unit setObjectTextureGlobal [0,"A3\Characters_F\Civil\Data\ig_poloshirt_1_co.paa"];
                    };
                    case "U_B_HeliPilotCoveralls": {
                        _unit setObjectTextureGlobal [0,"\A3\characters_f\common\data\coveralls_grey_co.paa"];
                    };
                    case "U_I_C_Soldier_Bandit_3_F": {
                        _unit setObjectTextureGlobal [1,"a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_skull_2_co.paa"];
                        _unit setObjectTextureGlobal [0,"a3\characters_f_enoch\uniforms\data\i_l_uniform_01_deserter_1_co.paa"];
                    };
                    case "U_I_L_Uniform_01_tshirt_black_F": {
                        _unit setObjectTextureGlobal [1,"a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_skull_2_co.paa"];
                    };
                    case "U_Marshal": {
                        _unit setObjectTextureGlobal [0,"A3\Characters_F\Civil\Data\ig_poloshirt_2_co.paa"];
                    };
                    
                };
            };

            [_box] call _fnc_addArmoryActions;

            _item21 = createSimpleObject ["Land_Ammobox_rounds_F",[24504.2,19007.6,3.38403]];
            _this = _item21;
            _objects pushback _this;
            _objectIDs pushback 21;
            _this setPosWorld [24504.2,19007.6,3.48939];
            _this setVectorDirAndUp [[-0.0166643,-0.999861,0],[0,0,1]];
            [_this, _box] call BIS_fnc_attachToRelative;  
    
            _item22 = createSimpleObject ["Land_Ammobox_rounds_F",[24504.5,19007.6,3.38723]]; 
            _this = _item22; 
            _objects pushback _this; 
            _objectIDs pushback 22; 
            _this setPosWorld [24504.53,19007.6,3.49259]; 
            _this setVectorDirAndUp [[-0.0166643,-0.999861,0],[0,0,1]]; 
            [_this, _box] call BIS_fnc_attachToRelative;  

            _item15 = createSimpleObject ["Land_ConcreteHedgehog_01_palette_F",[24504.3,19007.9,3.37506]];
            _this = _item15;
            _objects pushback _this;
            _objectIDs pushback 15;
            _this setPosWorld [24504.3,19007.9,2.73225];
            _this setVectorDirAndUp [[-0.899999,0.0012725,-7.75855e-05],[7.88069e-05,0.000863807,-0.9]];
            [_this, _box] call BIS_fnc_attachToRelative;  
            [_this,0.9] remoteExec ['setObjectScale',0,_this];

            _item16 = createSimpleObject ["Land_ConcreteHedgehog_01_palette_F",[24504.3,19008,3.37306]];
            _this = _item16;
            _objects pushback _this;
            _objectIDs pushback 16;
            _this setPosWorld [24504.3,19008,2.73025];
            _this setVectorDirAndUp [[-0.899999,0.0012725,-7.75855e-05],[7.88069e-05,0.000863807,-0.9]];
            [_this, _box] call BIS_fnc_attachToRelative;  
            [_this,0.9] remoteExec ['setObjectScale',0,_this];
            
            _item12 = createSimpleObject ["Land_PlasticCase_01_small_black_F",[24503.9,19008,3.387]]; 
            _this = _item12; 
            _objects pushback _this; 
            _objectIDs pushback 12; 
            _this setPosWorld [24503.85,19008,3.54366]; 
            _this setVectorDirAndUp [[-0.0115712,-0.999933,0],[0,0,1]]; 
            [_this, _box] call BIS_fnc_attachToRelative;   

            _item36 = createSimpleObject ["Land_MultiScreenComputer_01_closed_black_F",[24503.9,19008,3.67722]];
            _this = _item36;
            _objects pushback _this;
            _objectIDs pushback 36;
            _this setPosWorld [24503.9,19008,3.92731];
            _this setVectorDirAndUp [[0.999974,-0.00727258,0],[0,0,1]];
            [_this, _box] call BIS_fnc_attachToRelative;  

            _item9 = createSimpleObject ["Land_PortableCabinet_01_closed_black_F",[24504.4,19008,3.37909]];
            _this = _item9;
            _objects pushback _this;
            _objectIDs pushback 9;
            _this setPosWorld [24504.4,19008,3.54267];
            _this setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_this, _box] call BIS_fnc_attachToRelative;  

            _item10 = createSimpleObject ["Land_PortableCabinet_01_closed_black_F",[24504.4,19008,3.67845]]; 
            _this = _item10; 
            _objects pushback _this; 
            _objectIDs pushback 10; 
            _this setPosWorld [24504.4,19008,3.83667]; 
            _this setVectorDirAndUp [[0,0.9,0],[0,0,0.9]]; 
            [_this, _box] call BIS_fnc_attachToRelative;   
            [_this,0.9] remoteExec ['setObjectScale',0,_this];

            _simpleObject_1 = createSimpleObject ['a3\weapons_f\ammo\anm8_white.p3d', [24503.925781,19007.591797,3.467545]];
            _simpleObject_1 setVectorDirAndUp [[0.94,-0.34,0],[0,0,1]];
            [_simpleObject_1, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_1,1] remoteExec ['setObjectScale',0,_simpleObject_1];
            _simpleObject_2 = createSimpleObject ['a3\weapons_f\ammo\anm8_white.p3d', [24503.99,19007.595703,3.462565]]; 
            _simpleObject_2 setVectorDirAndUp [[0.96,0.28,0],[0,0,1]]; 
            [_simpleObject_2, _box] call BIS_fnc_attachToRelative;   
            [_simpleObject_2,1] remoteExec ['setObjectScale',0,_simpleObject_2];
            _simpleObject_3 = createSimpleObject ['a3\weapons_f_tank\launchers\mraws\rocket_mraws_heat55_f_item.p3d', [24504.722656,19007.695313,3.744405]];
            _simpleObject_3 setVectorDirAndUp [[0.99,-0.13,0],[-0.13,-0.99,0]];
            [_simpleObject_3, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_3,1] remoteExec ['setObjectScale',0,_simpleObject_3];
            _simpleObject_4 = createSimpleObject ['a3\weapons_f_tank\launchers\mraws\rocket_mraws_heat55_f_item.p3d', [24504.808594,19007.693359,3.744727]];
            _simpleObject_4 setVectorDirAndUp [[1,0.03,0],[0.03,-1,0]];
            [_simpleObject_4, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_4,1] remoteExec ['setObjectScale',0,_simpleObject_4];

            _simpleObject_0 = createSimpleObject ['a3\structures_f_mark\training\shootingmat_01_f.p3d', [24504.246094,19008.0976563,3.386943]];
            _simpleObject_0 setVectorDirAndUp [[0.7,0,0],[0,0,0.7]];
            [_simpleObject_0, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_0,0.7] remoteExec ['setObjectScale',0,_simpleObject_0];
            _simpleObject_1 = createSimpleObject ['a3\structures_f_mark\training\shootingmat_01_f.p3d', [24504.25,19007.751953,3.386033]];
            _simpleObject_1 setVectorDirAndUp [[0.7,-0.01,0],[0,0,0.7]];
            [_simpleObject_1, _box] call BIS_fnc_attachToRelative;  
            [_simpleObject_1,0.7] remoteExec ['setObjectScale',0,_simpleObject_1];

            [_box] call MAZ_EZM_fnc_deleteAttachedWhenKilled; 
            [_box] call MAZ_EZM_fnc_deleteAttachedWhenDeleted; 
            [_box] call MAZ_EZM_fnc_addObjectToInterface; 
            [_arsenal] call MAZ_EZM_fnc_addObjectToInterface; 
        
            _box setpos _pos; 
            
            _box 
        };

        MAZ_EZM_ION_fnc_createCrashsiteGreyhawkModule = { 
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 

            _pad = createVehicle ["Land_HelipadEmpty_F",[24220.5,18957,0],[],0,"CAN_COLLIDE"];
            _pad setPosWorld [24220.5,18957,3.19];
            _pad setVectorDirAndUp [[0,1,0],[0,0,1]];

            _item130 = createVehicle ["B_UAV_02_dynamicLoadout_F",[24220.6,18956.1,-0.892],[],0,"CAN_COLLIDE"];
            createVehicleCrew _item130;
            private _crew = crew _item130;
            _crew joinsilent _item129;
            _objects append _crew;
            _objectIDs append (_crew apply {-1});
            _this = _item130;
            _objects pushback _this;
            _objectIDs pushback 130;
            _this setPosWorld [24220.6,18956.1,3.86634];
            _this setVectorDirAndUp [[0.0615794,-0.997956,-0.0171069],[-0.0505581,-0.0202362,0.998516]];
            _this setPylonLoadout [1,""];
            _this setPylonLoadout [2,""];
            [_this, 0] remoteExec ['setFeatureType', 0, _this];
            _this enableSimulationGlobal false;
            if (local _this) then {parseSimpleArray "[[""hithull"",""hitengine"",""hitfuel"",""hitlaileron"",""hitraileron"",""hitlcrudder"",""hitrrudder"",""hitlcelevator"",""hitrelevator"",""hitturret"",""hitgun"",""#l svetlo""],[0.59,0.55,0.58,0.54,0.54,0.61,0.62,0.62,0.62,0,0,0]]" params ['_hitpoints', '_damage']; {if ((_damage # _forEachIndex) == 0) then {continue}; _this setHitPointDamage [_x, _damage # _forEachIndex, false]} forEach _hitpoints};
            [_this, _pad] call BIS_fnc_attachToRelative;

            _simpleObject_0 = createSimpleObject ['a3\structures_f\mil\helipads\helipadempty_f.p3d', [24193.599609,18921.650391,3.19]];
            _simpleObject_0 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_0, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_0,1] remoteExec ['setObjectScale',0,_simpleObject_0];
            _simpleObject_2 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24220.804688,18954.259766,3.222535]];
            _simpleObject_2 setVectorDirAndUp [[-0.01,-0.5,0],[0,0,0.5]];
            [_simpleObject_2, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_2,0.5] remoteExec ['setObjectScale',0,_simpleObject_2];
            _simpleObject_3 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24220.681641,18956.357422,3.192338]];
            _simpleObject_3 setVectorDirAndUp [[-0.01,-0.5,0],[0,0,0.5]];
            [_simpleObject_3, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_3,0.5] remoteExec ['setObjectScale',0,_simpleObject_3];
            _simpleObject_4 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24220.394531,18959.849609,3.234962]];
            _simpleObject_4 setVectorDirAndUp [[-0.01,-0.5,0],[0,0,0.5]];
            [_simpleObject_4, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_4,0.5] remoteExec ['setObjectScale',0,_simpleObject_4];
            _simpleObject_5 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24220.253906,18961.621094,3.226961]];
            _simpleObject_5 setVectorDirAndUp [[0.07,-0.49,0],[0,0,0.5]];
            [_simpleObject_5, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_5,0.5] remoteExec ['setObjectScale',0,_simpleObject_5];
            _simpleObject_6 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24215.503906,18958.570313,3.192961]];
            _simpleObject_6 setVectorDirAndUp [[0,-0.2,0],[0.03,0,0.2]];
            [_simpleObject_6, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_6,0.2] remoteExec ['setObjectScale',0,_simpleObject_6];
            _simpleObject_7 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24215.474609,18959.109375,3.178516]];
            _simpleObject_7 setVectorDirAndUp [[0.01,-0.2,-0.02],[0.03,-0.02,0.2]];
            [_simpleObject_7, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_7,0.2] remoteExec ['setObjectScale',0,_simpleObject_7];
            _simpleObject_8 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24221.828125,18960.810547,3.19]];
            _simpleObject_8 setVectorDirAndUp [[0.86,-0.52,0],[0,0,1]];
            [_simpleObject_8, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_8,1] remoteExec ['setObjectScale',0,_simpleObject_8];
            _simpleObject_9 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24222.294922,18957.417969,3.19]];
            _simpleObject_9 setVectorDirAndUp [[0.8,-0.6,0],[0,0,1]];
            [_simpleObject_9, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_9,1] remoteExec ['setObjectScale',0,_simpleObject_9];
            _simpleObject_10 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24220.777344,18952.416016,3.19]];
            _simpleObject_10 setVectorDirAndUp [[-0.54,-0.44,0],[0,0,0.7]];
            [_simpleObject_10, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_10,0.7] remoteExec ['setObjectScale',0,_simpleObject_10];
            _simpleObject_11 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24222.369141,18953.988281,3.19]];
            _simpleObject_11 setVectorDirAndUp [[0.67,-0.74,0],[0,0,1]];
            [_simpleObject_11, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_11,1] remoteExec ['setObjectScale',0,_simpleObject_11];
            _simpleObject_12 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24219.267578,18954.556641,3.19]];
            _simpleObject_12 setVectorDirAndUp [[-0.82,0.58,0],[0,0,1]];
            [_simpleObject_12, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_12,1] remoteExec ['setObjectScale',0,_simpleObject_12];
            _simpleObject_13 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24219.150391,18961.0488281,3.19]];
            _simpleObject_13 setVectorDirAndUp [[-0.75,0.66,0],[0,0,1]];
            [_simpleObject_13, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_13,1] remoteExec ['setObjectScale',0,_simpleObject_13];
            _simpleObject_14 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24219.03125,18957.417969,3.19]];
            _simpleObject_14 setVectorDirAndUp [[-0.57,0.4,0],[0,0,0.7]];
            [_simpleObject_14, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_14,0.7] remoteExec ['setObjectScale',0,_simpleObject_14];
            _simpleObject_15 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24220.0136719,18962.882813,3.19]];
            _simpleObject_15 setVectorDirAndUp [[0.28,0.41,0],[0,0,0.5]];
            [_simpleObject_15, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_15,0.5] remoteExec ['setObjectScale',0,_simpleObject_15];
            _simpleObject_16 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24214.933594,18958.886719,3.19]];
            _simpleObject_16 setVectorDirAndUp [[-0.22,0.21,0],[0,0,0.3]];
            [_simpleObject_16, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_16,0.3] remoteExec ['setObjectScale',0,_simpleObject_16];
            _simpleObject_17 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24215.878906,18959.248047,3.19]];
            _simpleObject_17 setVectorDirAndUp [[0.25,-0.16,0],[0,0,0.3]];
            [_simpleObject_17, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_17,0.3] remoteExec ['setObjectScale',0,_simpleObject_17];
            _simpleObject_18 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24215.757813,18957.802734,3.19]];
            _simpleObject_18 setVectorDirAndUp [[-0.02,-0.2,0],[0,0,0.2]];
            [_simpleObject_18, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_18,0.2] remoteExec ['setObjectScale',0,_simpleObject_18];
            _simpleObject_19 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24215.0820313,18957.964844,3.19]];
            _simpleObject_19 setVectorDirAndUp [[-0.2,0.03,0],[0,0,0.2]];
            [_simpleObject_19, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_19,0.2] remoteExec ['setObjectScale',0,_simpleObject_19];
            _simpleObject_20 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24222.0976563,18954.6875,3.219372]];
            _simpleObject_20 setVectorDirAndUp [[0,0.4,0],[0,0,0.4]];
            [_simpleObject_20, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_20,0.4] remoteExec ['setObjectScale',0,_simpleObject_20];
            _simpleObject_21 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24219.664063,18955.728516,3.219372]];
            _simpleObject_21 setVectorDirAndUp [[0,0.4,0],[0,0,0.4]];
            [_simpleObject_21, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_21,0.4] remoteExec ['setObjectScale',0,_simpleObject_21];
            _simpleObject_22 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24219.230469,18960.0878906,3.219372]];
            _simpleObject_22 setVectorDirAndUp [[0,0.4,0],[0,0,0.4]];
            [_simpleObject_22, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_22,0.4] remoteExec ['setObjectScale',0,_simpleObject_22];
            _simpleObject_23 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24221.582031,18960.275391,3.219372]];
            _simpleObject_23 setVectorDirAndUp [[0,0.4,0],[0,0,0.4]];
            [_simpleObject_23, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_23,0.4] remoteExec ['setObjectScale',0,_simpleObject_23];
            _simpleObject_24 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24221.355469,18962.0332031,3.219372]];
            _simpleObject_24 setVectorDirAndUp [[0,0.4,0],[0,0,0.4]];
            [_simpleObject_24, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_24,0.4] remoteExec ['setObjectScale',0,_simpleObject_24];
            _simpleObject_25 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24221.84375,18956.775391,3.219372]];
            _simpleObject_25 setVectorDirAndUp [[0,0.4,0],[0,0,0.4]];
            [_simpleObject_25, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_25,0.4] remoteExec ['setObjectScale',0,_simpleObject_25];
            _simpleObject_26 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24222.210938,18955.964844,3.219372]];
            _simpleObject_26 setVectorDirAndUp [[-0.11,-0.39,0],[0,0,0.4]];
            [_simpleObject_26, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_26,0.4] remoteExec ['setObjectScale',0,_simpleObject_26];
            _simpleObject_27 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24215.439453,18959.189453,3.219372]];
            _simpleObject_27 setVectorDirAndUp [[0,0.4,0],[0,0,0.4]];
            [_simpleObject_27, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_27,0.4] remoteExec ['setObjectScale',0,_simpleObject_27];

            _source01 = "#particlesource" createVehicle getPosWorld _pad;   
            _source01 setParticleClass "SmallDestructionSmoke";   
            _source01 attachTo [_pad,[-0.1,0.8,0.6]]; 

            _wreckSound1 = createSoundSource ["Sound_SmokeWreck1", getPosWorld _pad, [], 0];
            _wreckSound1 attachTo [_pad,[0,0,0.3]];

            _wreckSound1 = createSoundSource ["Sound_SmokeWreck1", getPosWorld _pad, [], 0];
            _wreckSound1 attachTo [_pad,[0,0,0.3]];

            [_pad] call MAZ_EZM_fnc_deleteAttachedWhenKilled; 
            [_pad] call MAZ_EZM_fnc_deleteAttachedWhenDeleted; 
            [_pad] call MAZ_EZM_fnc_addObjectToInterface;  

            _pad setpos _pos; 
            
            _pad 
        };

        MAZ_EZM_ION_fnc_createCrashsiteMohawkModule = { 
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 

            _pad = createVehicle ["Land_HelipadEmpty_F",[24247.6,18933.6,0],[],0,"CAN_COLLIDE"];
            _pad setPosWorld [24247.6,18933.6,3.19];
            _pad setVectorDirAndUp [[0,1,0],[0,0,1]];

            _item168 = createVehicle ["I_Heli_Transport_02_F",[24248.3,18934.9,-0.874],[],0,"CAN_COLLIDE"];
            _this = _item168;
            _objects pushback _this;
            _objectIDs pushback 168;
            _this setPosWorld [24248.3,18934.9,5.9469];
            _this setVectorDirAndUp [[-0.325238,-0.945632,0],[0,0,1]];
            heli = _this;
            [_this, 0] remoteExec ['setFeatureType', 0, _this];
            [_this,"[[[[],[]],[[],[]],[[],[]],[[],[]]],false]"] call bis_fnc_initAmmoBox;;
            _this animateDoor ['door_back_R', 1]; 
            _this animateDoor ["Door_Back_L", 1];
            _this setHitPointDamage ["hitthrotor", 1];
            _this enableSimulationGlobal true;
            if (local _this) then {parseSimpleArray "[[""hithull"",""hitfuel"",""hitavionics"",""hitengine1"",""hitengine2"",""hitengine"",""hithrotor"",""hitvrotor"",""hitglass1"",""hitglass1a"",""hitglass1b"",""hitglass2"",""hitglass3"",""hitglass4"",""hitglass5"",""hitglass6"",""hitglass7"",""hitglass8"",""hitglass9"",""hitglass10"",""hitglass11"",""hitglass12"",""hitglass13"",""hitglass14"",""hitglass15"",""hitglass16"",""hitglass17"",""hitmissiles"",""hitrglass"",""hitlglass"",""hitengine3"",""hitwinch"",""hittransmission"",""hitlight"",""hithydraulics"",""hitgear"",""hithstabilizerl1"",""hithstabilizerr1"",""hitvstabilizer1"",""hittail"",""hitpitottube"",""hitstaticport"",""hitstarter1"",""hitstarter2"",""hitstarter3"",""hitturret"",""hitgun"",""#light_hitpoint""],[0.59,0.6,0.61,0.64,0.65,0.64,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.63,0,0,0,0,0,0,0,0]]" params ['_hitpoints', '_damage']; {if ((_damage # _forEachIndex) == 0) then {continue}; _this setHitPointDamage [_x, _damage # _forEachIndex, false]} forEach _hitpoints};
            _this setObjectTexture [0,"a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_1_ion_co.paa"]; 
            _this setObjectTexture [1,"a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_2_ion_co.paa"]; 
            _this setObjectTexture [2,"a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_3_ion_co.paa"];
            [_this, _pad] call BIS_fnc_attachToRelative; 

            _source05 = "#particlesource" createVehicle getPosWorld _pad;  
            _source05 setParticleClass "SmallDestructionFire";  
            _source05 attachTo [_pad,[4.2,4.3,0.5]];  
            _light05 = "#lightpoint" createVehicle getPosWorld _pad;  
            _light05 setLightBrightness 0.1;  
            _light05 setLightAmbient [0.75, 0.25, 0.1];  
            _light05 setLightColor [0.75, 0.25, 0.1];  
            _light05 attachTo [_pad,[4.2,4.3,0.5]]; 

            _source06 = "#particlesource" createVehicle getPosWorld _pad;  
            _source06 setParticleClass "SmallDestructionFire";  
            _source06 attachTo [_pad,[0.3,-5,0.7]];  
            _light06 = "#lightpoint" createVehicle getPosWorld _pad;  
            _light06 setLightBrightness 0.1;  
            _light06 setLightAmbient [0.75, 0.25, 0.1];  
            _light06 setLightColor [0.75, 0.25, 0.1];  
            _light06 attachTo [_pad,[0.3,-5,0.7]]; 

            _source07 = "#particlesource" createVehicle getPosWorld _pad;  
            _source07 setParticleClass "SmallDestructionFire";  
            _source07 attachTo [_pad,[-2,-1,0.4]];  
            _light07 = "#lightpoint" createVehicle getPosWorld _pad;  
            _light07 setLightBrightness 0.1;  
            _light07 setLightAmbient [0.75, 0.25, 0.1];  
            _light07 setLightColor [0.75, 0.25, 0.1];  
            _light07 attachTo [_pad,[-2,-1,0.4]]; 

            _source08 = "#particlesource" createVehicle getPosWorld _pad;  
            _source08 setParticleClass "SmallDestructionFire";  
            _source08 attachTo [_pad,[-2.7,2.7,0.1]];  
            _light08 = "#lightpoint" createVehicle getPosWorld _pad;  
            _light08 setLightBrightness 0.1;  
            _light08 setLightAmbient [0.75, 0.25, 0.1];  
            _light08 setLightColor [0.75, 0.25, 0.1];  
            _light08 attachTo [_pad,[-2.7,2.7,0.1]]; ;  

            if(MAZ_EZM_spawnWithCrew) then { 
                        
                    private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                    _pilot moveInDriver _this;  
                    _pilot setDamage 1;  
            };  

            _this  lockDriver true; 
            _this  lockTurret [[0], true];

            _simpleObject_0 = createSimpleObject ['a3\structures_f\mil\helipads\helipadempty_f.p3d', [24193.599609,18921.650391,3.19]];
            _simpleObject_0 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_0, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_0,1] remoteExec ['setObjectScale',0,_simpleObject_0];
            _simpleObject_1 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_f.p3d', [24246.714844,18930.111328,3.397452]];
            _simpleObject_1 setVectorDirAndUp [[-0.26,-0.76,0],[0,0,0.8]];
            [_simpleObject_1, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_1,0.8] remoteExec ['setObjectScale',0,_simpleObject_1];
            _simpleObject_2 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24250.412109,18936.0410156,3.139893]];
            _simpleObject_2 setVectorDirAndUp [[-0.24,-0.76,-0.02],[-0.08,0,0.8]];
            [_simpleObject_2, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_2,0.8] remoteExec ['setObjectScale',0,_simpleObject_2];
            _simpleObject_3 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24246.861328,18936.84375,3.160826]];
            _simpleObject_3 setVectorDirAndUp [[-0.16,-0.78,-0.06],[0.08,-0.08,0.79]];
            [_simpleObject_3, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_3,0.8] remoteExec ['setObjectScale',0,_simpleObject_3];
            _simpleObject_4 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24248.162109,18939.595703,3.170275]];
            _simpleObject_4 setVectorDirAndUp [[-0.24,-0.66,-0.03],[0.09,-0.06,0.69]];
            [_simpleObject_4, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_4,0.7] remoteExec ['setObjectScale',0,_simpleObject_4];
            _simpleObject_5 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24251.53125,18938.662109,3.186638]];
            _simpleObject_5 setVectorDirAndUp [[-0.18,-0.68,-0.01],[-0.05,0,0.7]];
            [_simpleObject_5, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_5,0.7] remoteExec ['setObjectScale',0,_simpleObject_5];
            _simpleObject_6 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24248.269531,18933.181641,3.233933]];
            _simpleObject_6 setVectorDirAndUp [[-0.24,-0.76,0],[0,0,0.8]];
            [_simpleObject_6, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_6,0.8] remoteExec ['setObjectScale',0,_simpleObject_6];
            _simpleObject_7 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24247.132813,18933.548828,3.233933]];
            _simpleObject_7 setVectorDirAndUp [[-0.24,-0.76,0],[0,0,0.8]];
            [_simpleObject_7, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_7,0.8] remoteExec ['setObjectScale',0,_simpleObject_7];
            _simpleObject_8 = createSimpleObject ['a3\structures_f\mil\helipads\helipadempty_f.p3d', [24248.0195313,18934.478516,3.235]];
            _simpleObject_8 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_8, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_8,1] remoteExec ['setObjectScale',0,_simpleObject_8];
            _simpleObject_9 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24244.613281,18934.240234,3.19]];
            _simpleObject_9 setVectorDirAndUp [[-0.82,0.57,0],[0,0,1]];
            [_simpleObject_9, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_9,1] remoteExec ['setObjectScale',0,_simpleObject_9];
            _simpleObject_10 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24243.880859,18931.470703,3.19]];
            _simpleObject_10 setVectorDirAndUp [[-0.35,0.94,0],[0,0,1]];
            [_simpleObject_10, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_10,1] remoteExec ['setObjectScale',0,_simpleObject_10];
            _simpleObject_11 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24243.300781,18927.873047,3.19]];
            _simpleObject_11 setVectorDirAndUp [[-0.9,0.43,0],[0,0,1]];
            [_simpleObject_11, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_11,1] remoteExec ['setObjectScale',0,_simpleObject_11];
            _simpleObject_12 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24244.914063,18937.496094,3.19]];
            _simpleObject_12 setVectorDirAndUp [[-0.52,0.86,0],[0,0,1]];
            [_simpleObject_12, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_12,1] remoteExec ['setObjectScale',0,_simpleObject_12];
            _simpleObject_13 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24246.970703,18940.679688,3.190001]];
            _simpleObject_13 setVectorDirAndUp [[-0.05,1,0],[0,0,1]];
            [_simpleObject_13, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_13,1] remoteExec ['setObjectScale',0,_simpleObject_13];
            _simpleObject_14 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24245.671875,18925.431641,3.19]];
            _simpleObject_14 setVectorDirAndUp [[-0.86,-0.51,0],[0,0,1]];
            [_simpleObject_14, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_14,1] remoteExec ['setObjectScale',0,_simpleObject_14];
            _simpleObject_15 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24248.648438,18926.664063,3.19]];
            _simpleObject_15 setVectorDirAndUp [[0.28,-0.96,0],[0,0,1]];
            [_simpleObject_15, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_15,1] remoteExec ['setObjectScale',0,_simpleObject_15];
            _simpleObject_16 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24249.898438,18930.179688,3.19]];
            _simpleObject_16 setVectorDirAndUp [[0.65,-0.76,0],[0,0,1]];
            [_simpleObject_16, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_16,1] remoteExec ['setObjectScale',0,_simpleObject_16];
            _simpleObject_17 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24251.246094,18933.248047,3.19]];
            _simpleObject_17 setVectorDirAndUp [[0.36,-0.93,0],[0,0,1]];
            [_simpleObject_17, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_17,1] remoteExec ['setObjectScale',0,_simpleObject_17];
            _simpleObject_18 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24252.619141,18935.546875,3.19]];
            _simpleObject_18 setVectorDirAndUp [[0.5,-0.87,0],[0,0,1]];
            [_simpleObject_18, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_18,1] remoteExec ['setObjectScale',0,_simpleObject_18];
            _simpleObject_19 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24253.388672,18938.839844,3.19]];
            _simpleObject_19 setVectorDirAndUp [[0.87,-0.49,0],[0,0,1]];
            [_simpleObject_19, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_19,1] remoteExec ['setObjectScale',0,_simpleObject_19];
            _simpleObject_20 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24248.605469,18937.744141,3.19]];
            _simpleObject_20 setVectorDirAndUp [[0.58,-0.82,0],[0,0,1]];
            [_simpleObject_20, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_20,1] remoteExec ['setObjectScale',0,_simpleObject_20];
            _simpleObject_21 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24249.474609,18940.267578,3.19]];
            _simpleObject_21 setVectorDirAndUp [[0.79,-0.62,0],[0,0,1]];
            [_simpleObject_21, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_21,1] remoteExec ['setObjectScale',0,_simpleObject_21];
            _simpleObject_22 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24250.171875,18938.138672,3.19]];
            _simpleObject_22 setVectorDirAndUp [[0.07,1,0],[0,0,1]];
            [_simpleObject_22, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_22,1] remoteExec ['setObjectScale',0,_simpleObject_22];
            _simpleObject_23 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24251.130859,18940.216797,3.19]];
            _simpleObject_23 setVectorDirAndUp [[0.07,1,0],[0,0,1]];
            [_simpleObject_23, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_23,1] remoteExec ['setObjectScale',0,_simpleObject_23];
            _simpleObject_24 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24249.609375,18929.669922,3.206881]];
            _simpleObject_24 setVectorDirAndUp [[0,0.6,0],[0,0,0.6]];
            [_simpleObject_24, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_24,0.6] remoteExec ['setObjectScale',0,_simpleObject_24];
            _simpleObject_25 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24249.802734,18932.490234,3.200231]];
            _simpleObject_25 setVectorDirAndUp [[0.51,-0.32,0],[0,0,0.6]];
            [_simpleObject_25, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_25,0.6] remoteExec ['setObjectScale',0,_simpleObject_25];
            _simpleObject_26 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24249.914063,18931.486328,3.201402]];
            _simpleObject_26 setVectorDirAndUp [[0,0.6,0],[0,0,0.6]];
            [_simpleObject_26, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_26,0.6] remoteExec ['setObjectScale',0,_simpleObject_26];
            _simpleObject_27 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24252.238281,18935.734375,3.219372]];
            _simpleObject_27 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_27, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_27,0.6] remoteExec ['setObjectScale',0,_simpleObject_27];
            _simpleObject_28 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24251.314453,18933.865234,3.219372]];
            _simpleObject_28 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_28, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_28,0.6] remoteExec ['setObjectScale',0,_simpleObject_28];
            _simpleObject_29 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24252.808594,18938.265625,3.219372]];
            _simpleObject_29 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_29, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_29,0.6] remoteExec ['setObjectScale',0,_simpleObject_29];
            _simpleObject_30 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24250.0839844,18937.916016,3.219372]];
            _simpleObject_30 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_30, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_30,0.6] remoteExec ['setObjectScale',0,_simpleObject_30];
            _simpleObject_31 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24248.820313,18940.833984,3.219372]];
            _simpleObject_31 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_31, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_31,0.6] remoteExec ['setObjectScale',0,_simpleObject_31];
            _simpleObject_32 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24246.248047,18939.216797,3.219372]];
            _simpleObject_32 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_32, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_32,0.6] remoteExec ['setObjectScale',0,_simpleObject_32];
            _simpleObject_33 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24252.369141,18939.927734,3.219372]];
            _simpleObject_33 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_33, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_33,0.6] remoteExec ['setObjectScale',0,_simpleObject_33];
            _simpleObject_34 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24248.734375,18928.0546875,3.219372]];
            _simpleObject_34 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_34, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_34,0.6] remoteExec ['setObjectScale',0,_simpleObject_34];
            _simpleObject_35 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24247.1875,18925.988281,3.21719]];
            _simpleObject_35 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_35, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_35,0.6] remoteExec ['setObjectScale',0,_simpleObject_35];
            _simpleObject_36 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24248.00390625,18926.835938,3.219372]];
            _simpleObject_36 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_36, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_36,0.6] remoteExec ['setObjectScale',0,_simpleObject_36];
            _simpleObject_37 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24245.226563,18936.435547,3.219372]];
            _simpleObject_37 setVectorDirAndUp [[0.54,-0.26,0],[0,0,0.6]];
            [_simpleObject_37, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_37,0.6] remoteExec ['setObjectScale',0,_simpleObject_37];
            _simpleObject_38 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24245.0800781,18934.0449219,3.219372]];
            _simpleObject_38 setVectorDirAndUp [[-0.49,0.35,0],[0,0,0.6]];
            [_simpleObject_38, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_38,0.6] remoteExec ['setObjectScale',0,_simpleObject_38];
            _simpleObject_39 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24244.544922,18931.544922,3.219372]];
            _simpleObject_39 setVectorDirAndUp [[-0.49,0.35,0],[0,0,0.6]];
            [_simpleObject_39, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_39,0.6] remoteExec ['setObjectScale',0,_simpleObject_39];
            _simpleObject_40 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24244.0800781,18929.521484,3.219372]];
            _simpleObject_40 setVectorDirAndUp [[-0.49,0.35,0],[0,0,0.6]];
            [_simpleObject_40, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_40,0.6] remoteExec ['setObjectScale',0,_simpleObject_40];
            _simpleObject_41 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24243.962891,18927.638672,3.205833]];
            _simpleObject_41 setVectorDirAndUp [[-0.49,0.35,0],[0,0,0.6]];
            [_simpleObject_41, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_41,0.6] remoteExec ['setObjectScale',0,_simpleObject_41];
            _simpleObject_42 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24245.798828,18926.152344,3.219372]];
            _simpleObject_42 setVectorDirAndUp [[-0.4,-0.44,0],[0,0,0.6]];
            [_simpleObject_42, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_42,0.6] remoteExec ['setObjectScale',0,_simpleObject_42];
            _simpleObject_43 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24244.509766,18926.595703,3.208735]];
            _simpleObject_43 setVectorDirAndUp [[-0.49,0.35,0],[0,0,0.6]];
            [_simpleObject_43, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_43,0.6] remoteExec ['setObjectScale',0,_simpleObject_43];
            _simpleObject_44 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24245.412109,18937.808594,3.219372]];
            _simpleObject_44 setVectorDirAndUp [[-0.49,0.35,0],[0,0,0.6]];
            [_simpleObject_44, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_44,0.6] remoteExec ['setObjectScale',0,_simpleObject_44];
            _simpleObject_45 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24249.484375,18929.542969,3.219372]];
            _simpleObject_45 setVectorDirAndUp [[-0.73,0.53,0],[0,0,0.9]];
            [_simpleObject_45, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_45,0.9] remoteExec ['setObjectScale',0,_simpleObject_45];
            _simpleObject_46 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24244.947266,18932.453125,3.219372]];
            _simpleObject_46 setVectorDirAndUp [[-0.73,0.53,0],[0,0,0.9]];
            [_simpleObject_46, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_46,0.9] remoteExec ['setObjectScale',0,_simpleObject_46];
            _simpleObject_47 = createSimpleObject ['a3\structures_f_oldman\decals\brokencarglass_01_4x4_f.p3d', [24250.0957031,18931.0664063,3.209008]];
            _simpleObject_47 setVectorDirAndUp [[0.99,-0.14,0],[0,0,1]];
            [_simpleObject_47, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_47,1] remoteExec ['setObjectScale',0,_simpleObject_47];
            _simpleObject_48 = createSimpleObject ['a3\structures_f_oldman\decals\brokencarglass_01_4x4_f.p3d', [24244.824219,18932.117188,3.209008]];
            _simpleObject_48 setVectorDirAndUp [[0.99,-0.14,0],[0,0,1]];
            [_simpleObject_48, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_48,1] remoteExec ['setObjectScale',0,_simpleObject_48];
            _simpleObject_49 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24243.527344,18930.535156,3.186123]];
            _simpleObject_49 setVectorDirAndUp [[0.26,0.91,-0.33],[0.23,0.27,0.93]];
            [_simpleObject_49, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_49,1] remoteExec ['setObjectScale',0,_simpleObject_49];
            _simpleObject_50 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24244.714844,18936.306641,3.24144]];
            _simpleObject_50 setVectorDirAndUp [[-0.62,0.77,0.13],[-0.6,-0.58,0.55]];
            [_simpleObject_50, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_50,1] remoteExec ['setObjectScale',0,_simpleObject_50];
            _simpleObject_51 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24252.761719,18939.449219,3.244401]];
            _simpleObject_51 setVectorDirAndUp [[-0.62,0.38,-0.68],[-0.6,0.32,0.73]];
            [_simpleObject_51, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_51,1] remoteExec ['setObjectScale',0,_simpleObject_51];
            _simpleObject_52 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24251.136719,18934.753906,3.542693]];
            _simpleObject_52 setVectorDirAndUp [[-0.62,-0.15,-0.77],[-0.6,0.72,0.35]];
            [_simpleObject_52, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_52,1] remoteExec ['setObjectScale',0,_simpleObject_52];
            _simpleObject_53 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24248.253906,18928.529297,3.791069]];
            _simpleObject_53 setVectorDirAndUp [[-0.1,0.77,0.63],[0.3,-0.58,0.76]];
            [_simpleObject_53, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_53,1] remoteExec ['setObjectScale',0,_simpleObject_53];
            _simpleObject_54 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24247.525391,18939.90625,3.479481]];
            _simpleObject_54 setVectorDirAndUp [[-0.13,0.77,0.62],[0.26,-0.58,0.77]];
            [_simpleObject_54, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_54,1] remoteExec ['setObjectScale',0,_simpleObject_54];
            _simpleObject_55 = createSimpleObject ['a3\data_f\particleeffects\shard\shard4.p3d', [24249.244141,18932.0996094,3.531269]];
            _simpleObject_55 setVectorDirAndUp [[0,0.69,-0.13],[0.15,0.13,0.67]];
            [_simpleObject_55, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_55,0.7] remoteExec ['setObjectScale',0,_simpleObject_55];
            _simpleObject_56 = createSimpleObject ['a3\data_f\particleeffects\shard\shard4.p3d', [24251.203125,18935.371094,3.628353]];
            _simpleObject_56 setVectorDirAndUp [[-0.5,0.47,-0.13],[0,0.2,0.67]];
            [_simpleObject_50, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_56,0.7] remoteExec ['setObjectScale',0,_simpleObject_56];
            _simpleObject_57 = createSimpleObject ['a3\data_f\particleeffects\shard\shard4.p3d', [24247.488281,18940.462891,3.461096]];
            _simpleObject_57 setVectorDirAndUp [[-0.36,0.47,-0.38],[-0.35,0.2,0.57]];
            [_simpleObject_57, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_57,0.7] remoteExec ['setObjectScale',0,_simpleObject_57];
            _simpleObject_58 = createSimpleObject ['a3\data_f\particleeffects\shard\shard4.p3d', [24244.630859,18930.521484,3.563969]];
            _simpleObject_58 setVectorDirAndUp [[0.52,0.28,-0.38],[0.25,0.32,0.57]];
            [_simpleObject_58, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_58,0.7] remoteExec ['setObjectScale',0,_simpleObject_58];
            _simpleObject_59 = createSimpleObject ['a3\data_f\particleeffects\shard\shard4.p3d', [24245.818359,18934.177734,3.305502]];
            _simpleObject_59 setVectorDirAndUp [[0.06,-0.68,0.16],[-0.03,-0.17,-0.68]];
            [_simpleObject_59, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_59,0.7] remoteExec ['setObjectScale',0,_simpleObject_59];
            _simpleObject_60 = createSimpleObject ['a3\data_f\particleeffects\shard\shard3.p3d', [24246.828125,18938.339844,3.481801]];
            _simpleObject_60 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_60, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_60,1] remoteExec ['setObjectScale',0,_simpleObject_60];
            _simpleObject_61 = createSimpleObject ['a3\data_f\particleeffects\shard\shard3.p3d', [24251.980469,18937.767578,3.606808]];
            _simpleObject_61 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_61, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_61,1] remoteExec ['setObjectScale',0,_simpleObject_61];
            _simpleObject_62 = createSimpleObject ['a3\data_f\particleeffects\shard\shard3.p3d', [24248.269531,18929.28125,3.865875]];
            _simpleObject_62 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_62, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_62,1] remoteExec ['setObjectScale',0,_simpleObject_62];
            _simpleObject_63 = createSimpleObject ['a3\data_f\particleeffects\shard\shard3.p3d', [24245.583984,18932.523438,3.550786]];
            _simpleObject_63 setVectorDirAndUp [[0,-0.86,0.5],[0,-0.5,-0.86]];
            [_simpleObject_63, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_63,1] remoteExec ['setObjectScale',0,_simpleObject_63];

            _wreckSound1 = createSoundSource ["Sound_SmokeWreck1", getPosWorld _pad, [], 0];
            _wreckSound1 attachTo [_pad,[0,0,2.5]];

            _wreckSound1 = createSoundSource ["Sound_SmokeWreck1", getPosWorld _pad, [], 0];
            _wreckSound1 attachTo [_pad,[0,0,2.5]];

            _source01 = "#particlesource" createVehicle getPosWorld _pad;  
            _source01 setParticleClass "SmallDestructionSmoke";  
            _source01 attachTo [_pad,[0.7,3,2.8]]; 

            _source02 = "#particlesource" createVehicle getPosWorld _pad;  
            _source02 setParticleClass "SmallDestructionSmoke";  
            _source02 attachTo [_pad,[1.8,3,2.8]]; 

            _source03 = "#particlesource" createVehicle getPosWorld _pad;  
            _source03 setParticleClass "SmallDestructionSmoke";  
            _source03 attachTo [_pad,[-1.4,-1.7,2.8]]; 

            _source04 = "#particlesource" createVehicle getPosWorld _pad;   
            _source04 setParticleClass "SmallDestructionSmoke";   
            _source04 attachTo [_pad,[0.2,-2,2.8]];

            [_pad] call MAZ_EZM_fnc_deleteAttachedWhenKilled; 
            [_pad] call MAZ_EZM_fnc_deleteAttachedWhenDeleted; 
            [_pad] call MAZ_EZM_fnc_addObjectToInterface; 
            [_pad] call MAZ_EZM_fnc_addObjectToInterface; 

            _pad setpos _pos; 
            
            _pad 
        };

        MAZ_EZM_ION_fnc_createCrashsiteOrcaModule = { 
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 

            _pad = createVehicle ["Land_HelipadEmpty_F",[24193.6,18921.7,0],[],0,"CAN_COLLIDE"];
            _pad setPosWorld [24193.6,18921.7,3.19];
            _pad setVectorDirAndUp [[0,1,0],[0,0,1]];

            _simpleObject_0 = createSimpleObject ['a3\props_f_enoch\military\wrecks\heli_light_02_wreck_04_f.p3d', [24195.445313,18920.96875,3.428848]];
            _simpleObject_0 setVectorDirAndUp [[0,1,0.03],[0.36,-0.03,0.93]];
            [_simpleObject_0, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_0,1] remoteExec ['setObjectScale',0,_simpleObject_0];
            _simpleObject_1 = createSimpleObject ['a3\props_f_enoch\military\wrecks\heli_light_02_wreck_01_f.p3d', [24195.132813,18922.294922,4.613764]];
            _simpleObject_1 setVectorDirAndUp [[0,1,-0.06],[0.99,0.01,0.1]];
            [_simpleObject_1, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_1,1] remoteExec ['setObjectScale',0,_simpleObject_1];
            _simpleObject_2 = createSimpleObject ['a3\props_f_enoch\military\wrecks\heli_light_02_wreck_02_f.p3d', [24191.150391,18929.0546875,4.364806]];
            _simpleObject_2 setVectorDirAndUp [[-0.77,0.64,0],[-0.24,-0.29,0.93]];
            [_simpleObject_2, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_2,1] remoteExec ['setObjectScale',0,_simpleObject_2];
            _simpleObject_3 = createSimpleObject ['a3\props_f_enoch\military\wrecks\heli_light_02_wreck_03_f.p3d', [24196.84375,18916.970703,3.507797]];
            _simpleObject_3 setVectorDirAndUp [[0.73,0.68,0],[0.54,-0.58,0.6]];
            [_simpleObject_3, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_3,1] remoteExec ['setObjectScale',0,_simpleObject_3];
            _simpleObject_4 = createSimpleObject ['a3\props_f_enoch\military\wrecks\heli_light_02_wreck_03_f.p3d', [24189.621094,18924.654297,3.218599]];
            _simpleObject_4 setVectorDirAndUp [[0.43,0.42,-0.8],[0.71,0.39,0.59]];
            [_simpleObject_4, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_4,1] remoteExec ['setObjectScale',0,_simpleObject_4];
            _simpleObject_5 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24193.263672,18919.876953,3.26372]];
            _simpleObject_5 setVectorDirAndUp [[0.03,-0.9,0],[0,0,0.9]];
            [_simpleObject_5, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_5,0.9] remoteExec ['setObjectScale',0,_simpleObject_5];
            _simpleObject_6 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24196.185547,18918.884766,3.220446]];
            _simpleObject_6 setVectorDirAndUp [[0,0.8,0],[0,0,0.8]];
            [_simpleObject_6, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_6,0.8] remoteExec ['setObjectScale',0,_simpleObject_6];
            _simpleObject_7 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24195.808594,18917.03125,3.218668]];
            _simpleObject_7 setVectorDirAndUp [[0,0.9,0],[0,0,0.9]];
            [_simpleObject_7, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_7,0.9] remoteExec ['setObjectScale',0,_simpleObject_7];
            _simpleObject_8 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24191.0625,18920.130859,3.219372]];
            _simpleObject_8 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_8, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_8,1] remoteExec ['setObjectScale',0,_simpleObject_8];
            _simpleObject_9 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24193.25,18922.517578,3.11553]];
            _simpleObject_9 setVectorDirAndUp [[0.03,-0.9,0],[0,0,0.9]];
            [_simpleObject_9, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_9,0.9] remoteExec ['setObjectScale',0,_simpleObject_9];
            _simpleObject_10 = createSimpleObject ['a3\structures_f_enoch\military\training\craterlong_02_small_f.p3d', [24193.158203,18925.201172,3.22928]];
            _simpleObject_10 setVectorDirAndUp [[0.03,-0.9,0],[0,0,0.9]];
            [_simpleObject_10, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_10,0.9] remoteExec ['setObjectScale',0,_simpleObject_10];
            _simpleObject_11 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24195.330078,18925.519531,3.213861]];
            _simpleObject_11 setVectorDirAndUp [[0,0.6,0],[0,0,0.6]];
            [_simpleObject_11, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_11,0.6] remoteExec ['setObjectScale',0,_simpleObject_11];
            _simpleObject_12 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24194.720703,18927.0136719,3.217307]];
            _simpleObject_12 setVectorDirAndUp [[0.4,-0.3,0],[0,0,0.5]];
            [_simpleObject_12, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_12,0.5] remoteExec ['setObjectScale',0,_simpleObject_12];
            _simpleObject_13 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24195.738281,18923.175781,3.219372]];
            _simpleObject_13 setVectorDirAndUp [[0.77,0.23,0],[0,0,0.8]];
            [_simpleObject_13, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_13,0.8] remoteExec ['setObjectScale',0,_simpleObject_13];
            _simpleObject_14 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24192.179688,18928.015625,3.222818]];
            _simpleObject_14 setVectorDirAndUp [[0.04,-0.5,0],[0,0,0.5]];
            [_simpleObject_14, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_14,0.5] remoteExec ['setObjectScale',0,_simpleObject_14];
            _simpleObject_15 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24191.474609,18926.570313,3.219372]];
            _simpleObject_15 setVectorDirAndUp [[0.45,0.4,0],[0,0,0.6]];
            [_simpleObject_15, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_15,0.6] remoteExec ['setObjectScale',0,_simpleObject_15];
            _simpleObject_16 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24190.394531,18925.978516,3.222201]];
            _simpleObject_16 setVectorDirAndUp [[0.32,-0.38,0],[0,0,0.5]];
            [_simpleObject_16, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_16,0.5] remoteExec ['setObjectScale',0,_simpleObject_16];
            _simpleObject_17 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24190.650391,18924.388672,3.218755]];
            _simpleObject_17 setVectorDirAndUp [[0.14,0.58,0],[0,0,0.6]];
            [_simpleObject_17, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_17,0.6] remoteExec ['setObjectScale',0,_simpleObject_17];
            _simpleObject_18 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24190.515625,18922.0117188,3.224266]];
            _simpleObject_18 setVectorDirAndUp [[0.8,0.05,0],[0,0,0.8]];
            [_simpleObject_18, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_18,0.8] remoteExec ['setObjectScale',0,_simpleObject_18];
            _simpleObject_19 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24192.0332031,18916.332031,3.220798]];
            _simpleObject_19 setVectorDirAndUp [[-0.29,0.52,0],[0,0,0.6]];
            [_simpleObject_19, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_19,0.6] remoteExec ['setObjectScale',0,_simpleObject_19];
            _simpleObject_20 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_02_debris_f.p3d', [24190.771484,18917.339844,3.224244]];
            _simpleObject_20 setVectorDirAndUp [[0.5,-0.07,0],[0,0,0.5]];
            [_simpleObject_20, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_20,0.5] remoteExec ['setObjectScale',0,_simpleObject_20];
            _simpleObject_21 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24195.832031,18919.230469,3.19]];
            _simpleObject_21 setVectorDirAndUp [[0.71,-0.7,0],[0,0,1]];
            [_simpleObject_21, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_21,1] remoteExec ['setObjectScale',0,_simpleObject_21];
            _simpleObject_22 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24196.0898438,18923.210938,3.190001]];
            _simpleObject_22 setVectorDirAndUp [[0.71,-0.7,0],[0,0,1]];
            [_simpleObject_22, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_22,1] remoteExec ['setObjectScale',0,_simpleObject_22];
            _simpleObject_23 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24195.0800781,18926.75,3.19]];
            _simpleObject_23 setVectorDirAndUp [[0.97,-0.24,0],[0,0,1]];
            [_simpleObject_23, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_23,1] remoteExec ['setObjectScale',0,_simpleObject_23];
            _simpleObject_24 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24191.00390625,18926.423828,3.19]];
            _simpleObject_24 setVectorDirAndUp [[-0.35,0.94,0],[0,0,1]];
            [_simpleObject_24, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_24,1] remoteExec ['setObjectScale',0,_simpleObject_24];
            _simpleObject_25 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24190.626953,18923.130859,3.190001]];
            _simpleObject_25 setVectorDirAndUp [[-0.68,0.74,0],[0,0,1]];
            [_simpleObject_25, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_25,1] remoteExec ['setObjectScale',0,_simpleObject_25];
            _simpleObject_26 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24190.679688,18919.345703,3.19]];
            _simpleObject_26 setVectorDirAndUp [[-0.71,0.71,0],[0,0,1]];
            [_simpleObject_26, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_26,1] remoteExec ['setObjectScale',0,_simpleObject_26];
            _simpleObject_27 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24193.314453,18916.171875,3.19]];
            _simpleObject_27 setVectorDirAndUp [[-0.9,-0.94,0],[0,0,1.3]];
            [_simpleObject_27, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_27,1.3] remoteExec ['setObjectScale',0,_simpleObject_27];
            _simpleObject_28 = createSimpleObject ['a3\structures_f_enoch\military\training\shellcrater_01_decal_f.p3d', [24193.291016,18927.630859,3.19]];
            _simpleObject_28 setVectorDirAndUp [[0.97,-0.24,0],[0,0,1]];
            [_simpleObject_28, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_28,1] remoteExec ['setObjectScale',0,_simpleObject_28];
            _simpleObject_29 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24195.998047,18925.3125,3.191222]];
            _simpleObject_29 setVectorDirAndUp [[0.26,0.91,-0.33],[0.23,0.27,0.93]];
            [_simpleObject_29, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_29,1] remoteExec ['setObjectScale',0,_simpleObject_29];
            _simpleObject_30 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24189.771484,18925.748047,3.226318]];
            _simpleObject_30 setVectorDirAndUp [[-0.99,0.06,0.1],[-0.05,0.55,-0.84]];
            [_simpleObject_30, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_30,1] remoteExec ['setObjectScale',0,_simpleObject_30];
            _simpleObject_31 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24193.259766,18915.462891,3.24144]];
            _simpleObject_31 setVectorDirAndUp [[-0.99,0.08,0.08],[-0.05,0.38,-0.92]];
            [_simpleObject_31, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_31,1] remoteExec ['setObjectScale',0,_simpleObject_31];
            _simpleObject_32 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24190.185547,18920.1875,3.192557]];
            _simpleObject_32 setVectorDirAndUp [[0.19,0.89,-0.41],[-0.19,0.44,0.88]];
            [_simpleObject_32, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_32,1] remoteExec ['setObjectScale',0,_simpleObject_32];
            _simpleObject_33 = createSimpleObject ['a3\data_f\particleeffects\shard\shard2.p3d', [24189.601563,18927.470703,3.205058]];
            _simpleObject_33 setVectorDirAndUp [[-0.99,0.11,-0.02],[-0.05,-0.55,-0.84]];
            [_simpleObject_33, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_33,1] remoteExec ['setObjectScale',0,_simpleObject_33];
            _simpleObject_34 = createSimpleObject ['a3\structures_f_oldman\decals\brokencarglass_01_4x4_f.p3d', [24195.621094,18919.552734,3.195618]];
            _simpleObject_34 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_34, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_34,1] remoteExec ['setObjectScale',0,_simpleObject_34];
            _simpleObject_35 = createSimpleObject ['a3\structures_f_oldman\decals\brokencarglass_01_4x4_f.p3d', [24191.488281,18920.71875,3.201681]];
            _simpleObject_35 setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_simpleObject_35, _pad] call BIS_fnc_attachToRelative;
            [_simpleObject_35,1] remoteExec ['setObjectScale',0,_simpleObject_35];

            _source01 = "#particlesource" createVehicle getPosWorld _pad; 
            _source01 setParticleClass "SmallDestructionSmoke"; 
            _source01 attachTo [_pad,[0.2,0.4,2.5]];
            _source02 = "#particlesource" createVehicle getPosWorld _pad; 
            _source02 setParticleClass "SmallDestructionSmoke"; 
            _source02 attachTo [_pad,[-0.8,0.4,2.5]];
            _source03 = "#particlesource" createVehicle getPosWorld _pad; 
            _source03 setParticleClass "SmallDestructionSmoke"; 
            _source03 attachTo [_pad,[-0.6,2.9,1.7]];
            _source04 = "#particlesource" createVehicle getPosWorld _pad; 
            _source04 setParticleClass "SmallDestructionSmoke"; 
            _source04 attachTo [_pad,[0.25,3,1.8]];
            _source05 = "#particlesource" createVehicle getPosWorld _pad; 
            _source05 setParticleClass "SmallDestructionFire"; 
            _source05 attachTo [_pad,[2.5,3.5,0.05]]; 
            _light05 = "#lightpoint" createVehicle getPosWorld _pad; 
            _light05 setLightBrightness 0.1; 
            _light05 setLightAmbient [0.75, 0.25, 0.1]; 
            _light05 setLightColor [0.75, 0.25, 0.1]; 
            _light05 attachTo [_pad,[2.5,3.5,0.05]]; 
            _source06 = "#particlesource" createVehicle getPosWorld _pad; 
            _source06 setParticleClass "SmallDestructionFire"; 
            _source06 attachTo [_pad,[-0.4,-6.2,0.15]]; 
            _light06 = "#lightpoint" createVehicle getPosWorld _pad; 
            _light06 setLightBrightness 0.1; 
            _light06 setLightAmbient [0.75, 0.25, 0.1]; 
            _light06 setLightColor [0.75, 0.25, 0.1]; 
            _light06 attachTo [_pad,[-0.4,-6.2,0.15]]; 
            _source07 = "#particlesource" createVehicle getPosWorld _pad; 
            _source07 setParticleClass "SmallDestructionFire"; 
            _source07 attachTo [_pad,[-3.3,-1.6,0.1]]; 
            _light07 = "#lightpoint" createVehicle getPosWorld _pad; 
            _light07 setLightBrightness 0.1; 
            _light07 setLightAmbient [0.75, 0.25, 0.1]; 
            _light07 setLightColor [0.75, 0.25, 0.1]; 
            _light07 attachTo [_pad,[-3.3,-1.6,0.1]]; 
            _source08 = "#particlesource" createVehicle getPosWorld _pad; 
            _source08 setParticleClass "SmallDestructionFire"; 
            _source08 attachTo [_pad,[-3.95,4,0.05]]; 
            _light08 = "#lightpoint" createVehicle getPosWorld _pad; 
            _light08 setLightBrightness 0.1; 
            _light08 setLightAmbient [0.75, 0.25, 0.1]; 
            _light08 setLightColor [0.75, 0.25, 0.1]; 
            _light08 attachTo [_pad,[-3.95,4,0.05]]; 
            _wreckSound1 = createSoundSource ["Sound_SmokeWreck1", getPosWorld _pad, [], 0];
            _wreckSound1 attachTo [_pad,[0,0,2]];
            _wreckSound1 = createSoundSource ["Sound_SmokeWreck1", getPosWorld _pad, [], 0];
            _wreckSound1 attachTo [_pad,[0,0,2]];

            [_pad] call MAZ_EZM_fnc_deleteAttachedWhenKilled; 
            [_pad] call MAZ_EZM_fnc_deleteAttachedWhenDeleted; 
            [_pad] call MAZ_EZM_fnc_addObjectToInterface;

            _pad setpos _pos; 
            
            _pad 
        };

        MAZ_EZM_ION_fnc_createDeadSoldierModule = { 
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 
            
            private _KIA = createVehicle ["C_man_p_beggar_F",[24602.4,19234.3,2.38419e-007],[],0,"CAN_COLLIDE"]; 
            private _animData = selectRandom [ 
            ["KIA_gunner_static_low01",[24602.4,19234.4,3.19144],[24603.4,19234.9,3.20104],[24601.7,19235,3.195]], 
            ["KIA_gunner_standup01",[24602.4,19234.4,3.19144],[24602.9,19233.5,3.2036],[24602.4,19234.3,3.19136]], 
            ["KIA_driver_boat01",[24602.4,19234.4,3.19144],[24603,19235.2,3.19],[24602.8,19234.5,3.195]], 
            ["KIA_passenger_boat_holdleft",[24602.5,19234.4,3.19144],[24603,19235.1,3.19896],[24602.8,19234.4,3.195]] 
            ]; 
            
            _animData params ["_anim","_unitPos","_gunPos","_bloodPos"]; 
            [_KIA,_anim] remoteExec ['switchMove',0,true]; 
            _KIA disableAI "ALL";   
            _KIA setCaptive true;  
            _KIA setSpeaker "NoVoice";  
            _KIA setHitPointDamage ["hitHead", 0.9]; 
            _KIA setHitPointDamage ["hitHands", 0.9]; 
            _KIA allowDamage false;
            private _face = selectRandom ["Ioannou","AfricanHead_01","WhiteHead_11","WhiteHead_16","WhiteHead_17","GreekHead_A3_09","WhiteHead_18","Sturrock","GreekHead_A3_14"]; 
            _KIA setface _face; 
            _KIA setPosWorld _unitPos; 
            _KIA setVectorDirAndUp [[0.965509,-0.26037,0],[0,0,1]]; 
            _KIA setDir (random 359); 
            [_KIA] call MAZ_EZM_fnc_deleteAttachedWhenKilled; 
            [_KIA] call MAZ_EZM_fnc_deleteAttachedWhenDeleted; 
            [_KIA] call MAZ_EZM_fnc_addObjectToInterface; 
            [_KIA] call MAZ_EZM_fnc_ignoreWhenCleaning; 
            [_KIA] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit; 
            [_KIA] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            

            _KIA spawn { 
            while {!isNull _this} do { 
            private _sounds = [ 
            ["A3\Missions_F_Oldman\Data\sound\Flies\Flies_02.wss",10.5,0.5,15] 
            ]; 
            private _soundData = selectRandom _sounds; 
            _soundData params ["_sound","_time","_volume","_distance"]; 
            playSound3D [_sound,_this,false,getPosASL _this, _volume, 1, _distance]; 
            sleep _time; 
            }; 
            }; 
        
            private _gun = createVehicle ["Weapon_arifle_SPAR_01_blk_F",[24603.4,19234.9,0.0110364],[],0,"CAN_COLLIDE"]; 
            _gun setPosWorld _gunPos; 
            _gun setDir (random 90); 
            [_gun,_KIA] call BIS_fnc_attachToRelative; 

            private _blood = createVehicle ["BloodSplatter_01_Medium_New_F",[24601.7,19235,0],[],0,"CAN_COLLIDE"]; 
            _blood setPosWorld _bloodPos; 
            _blood setVectorDirAndUp [[0,1,0],[0,0,1]]; 
            _blood setObjectTextureGlobal [0,"a3\props_f_orange\humanitarian\garbage\data\bloodsplatter_medium_fresh_ca.paa"]; 
            _blood setDir (random 359); 
            [_blood, _KIA] call BIS_fnc_attachToRelative;

            _KIA setpos _pos; 
        
            _KIA 
        };  

        MAZ_EZM_ION_fnc_createDeadSoldierBaggableModule = { 
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 
            
            private _KIA = createVehicle ["C_man_p_beggar_F",[24602.4,19234.3,2.38419e-007],[],0,"CAN_COLLIDE"]; 
            private _animData = selectRandom [ 
            ["KIA_gunner_static_low01",[24602.4,19234.4,3.19144],[24603.4,19234.9,3.20104],[24601.7,19235,3.195]], 
            ["KIA_gunner_standup01",[24602.4,19234.4,3.19144],[24602.9,19233.5,3.2036],[24602.4,19234.3,3.19136]], 
            ["KIA_driver_boat01",[24602.4,19234.4,3.19144],[24603,19235.2,3.19],[24602.8,19234.5,3.195]], 
            ["KIA_passenger_boat_holdleft",[24602.5,19234.4,3.19144],[24603,19235.1,3.19896],[24602.8,19234.4,3.195]] 
            ]; 
            
            _animData params ["_anim","_unitPos","_gunPos","_bloodPos"]; 
            [_KIA,_anim] remoteExec ['switchMove',0,true]; 
            _KIA disableAI "ALL";   
            _KIA setCaptive true;  
            _KIA setSpeaker "NoVoice";  
            _KIA setHitPointDamage ["hitHead", 0.9]; 
            _KIA setHitPointDamage ["hitHands", 0.9]; 
            _KIA allowDamage false;
            private _face = selectRandom ["Ioannou","AfricanHead_01","WhiteHead_11","WhiteHead_16","WhiteHead_17","GreekHead_A3_09","WhiteHead_18","Sturrock","GreekHead_A3_14"]; 
            _KIA setface _face; 
            _KIA setPosWorld _unitPos; 
            _KIA setVectorDirAndUp [[0.965509,-0.26037,0],[0,0,1]]; 
            _KIA setDir (random 359);
            [_KIA] call MAZ_EZM_fnc_deleteAttachedWhenKilled; 
            [_KIA] call MAZ_EZM_fnc_deleteAttachedWhenDeleted; 
            [_KIA] call MAZ_EZM_fnc_addObjectToInterface; 
            [_KIA] call MAZ_EZM_fnc_ignoreWhenCleaning; 
            [_KIA] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit; 
            [_KIA] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            

            _KIA spawn { 
            while {!isNull _this} do { 
            private _sounds = [ 
            ["A3\Missions_F_Oldman\Data\sound\Flies\Flies_02.wss",10.5,0.5,15] 
            ]; 
            private _soundData = selectRandom _sounds; 
            _soundData params ["_sound","_time","_volume","_distance"]; 
            playSound3D [_sound,_this,false,getPosASL _this, _volume, 1, _distance]; 
            sleep _time; 
            }; 
            }; 
        
            private _gun = createVehicle ["Weapon_arifle_SPAR_01_blk_F",[24603.4,19234.9,0.0110364],[],0,"CAN_COLLIDE"]; 
            _gun setPosWorld _gunPos; 
            _gun setDir (random 90); 
            [_gun,_KIA] call BIS_fnc_attachToRelative; 

            private _blood = createVehicle ["BloodSplatter_01_Medium_New_F",[24601.7,19235,0],[],0,"CAN_COLLIDE"]; 
            _blood setPosWorld _bloodPos; 
            _blood setVectorDirAndUp [[0,1,0],[0,0,1]]; 
            _blood setObjectTextureGlobal [0,"a3\props_f_orange\humanitarian\garbage\data\bloodsplatter_medium_fresh_ca.paa"]; 
            _blood setDir (random 359); 
            [_blood, _KIA] call BIS_fnc_attachToRelative;

            private _holdActionIndex = [ 
                _KIA,            
                "Bag and Tag",           
                "\a3\ui_f\data\igui\cfg\revive\overlayicons\d75_ca.paa",  
                "\a3\ui_f\data\igui\cfg\revive\overlayicons\d75_ca.paa",  
                "_this distance _target < 3", 
                "_caller distance _target < 3",       
                {}, 
                {}, 
                {  
                _unit = (_this select 0);
                deleteVehicle _unit;
                _bag = createVehicle ["Land_Bodybag_01_black_F", getPosATL _unit, [], 0, "CAN_COLLIDE"];
                [_bag] call MAZ_EZM_fnc_addObjectToInterface;
                }, 
                {}, 
                [], 
                3, 
                0, 
                true,             
                false             
            ] remoteExec ["BIS_fnc_holdActionAdd",0, _KIA];

            _KIA setpos _pos; 
        
            _KIA 
        };  

    comment "Drones";  
          
        MAZ_EZM_ION_fnc_createDarterModule = {  
            private _vehicle = ["B_UAV_01_F",["\a3\data_f\black.paa"]] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [west,true];  
            private _oldGroup = createVehicleCrew _vehicle;  
            private _leader = leader _oldGroup;  
            {  
                [_x] joinSilent _aiGroup;  
            }forEach units _oldGroup;  
            _aiGroup selectLeader _leader;  
            
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createFalconModule = {  
            private _vehicle = ["B_T_UAV_03_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [west,true];  
            private _oldGroup = createVehicleCrew _vehicle;  
            private _leader = leader _oldGroup;  
            {  
                [_x] joinSilent _aiGroup;  
            }forEach units _oldGroup;  
            _aiGroup selectLeader _leader;  
            
            _vehicle  
        };

        MAZ_EZM_ION_fnc_createPelicanMedicalModule = {  
            private _vehicle = ["B_UAV_06_medical_F",["\a3\data_f\black.paa"]] call MAZ_EZM_fnc_createVehicle;  
            
            private _aiGroup = createGroup [west,true];  
            private _oldGroup = createVehicleCrew _vehicle;  
            private _leader = leader _oldGroup;  
            {  
                [_x] joinSilent _aiGroup;  
            }forEach units _oldGroup;  
            _aiGroup selectLeader _leader;  
            
            _vehicle  
        };  
    
        MAZ_EZM_ION_fnc_createGreyhawkModule = {  
            private _vehicle = ["B_UAV_02_F"] call MAZ_EZM_fnc_createVehicle;  
            
            private _aiGroup = createGroup [west,true];  
            private _oldGroup = createVehicleCrew _vehicle;  
            private _leader = leader _oldGroup;  
            {  
                [_x] joinSilent _aiGroup;  
            }forEach units _oldGroup;  
            _aiGroup selectLeader _leader; 
        
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createStomperModule = {  
            private _vehicle = ["B_UGV_01_F"] call MAZ_EZM_fnc_createVehicle; 
            
            private _aiGroup = createGroup [west,true];  
            private _oldGroup = createVehicleCrew _vehicle;  
            private _leader = leader _oldGroup;  
            {  
                [_x] joinSilent _aiGroup;  
            }forEach units _oldGroup;  
            _aiGroup selectLeader _leader; 

            _vehicle  
        };  
    
        MAZ_EZM_ION_fnc_createStomperRCWSModule = {  
            private _vehicle = ["B_UGV_01_rcws_F"] call MAZ_EZM_fnc_createVehicle; 
            
            private _aiGroup = createGroup [west,true];  
            private _oldGroup = createVehicleCrew _vehicle;  
            private _leader = leader _oldGroup;  
            {  
                [_x] joinSilent _aiGroup;  
            }forEach units _oldGroup;  
            _aiGroup selectLeader _leader; 

            _vehicle  
        };  
       
    comment "Groups";  
        
        MAZ_EZM_ION_fnc_createSquadModule = {  
            private _squadLead = call MAZ_EZM_ION_fnc_createSquadLeadModule;  
            private _grp = group _squadLead;  
            {  
                private _unit = call (missionNamespace getVariable _x);  
                [_unit] joinSilent _grp;  
            }forEach [  
                'MAZ_EZM_ION_fnc_createAmmoBearerModule',  
                'MAZ_EZM_ION_fnc_createCombatMedicModule',  
                'MAZ_EZM_ION_fnc_createRiflemanModule',  
                'MAZ_EZM_ION_fnc_createMarksmanModule',  
                'MAZ_EZM_ION_fnc_createRiflemanLATModule',  
                'MAZ_EZM_ION_fnc_createGrenadierModule',  
                'MAZ_EZM_ION_fnc_createAutoriflemanModule',  
                'MAZ_EZM_ION_fnc_createRiflemanModule'  
            ];  
            _grp setBehaviour "AWARE";  
            {_x setUnitPos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  
        
        MAZ_EZM_ION_fnc_createPatrolModule = {  
            private _squadLead = call MAZ_EZM_ION_fnc_createSquadLeadModule;  
            private _grp = group _squadLead;  
            {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
            }forEach [  
            'MAZ_EZM_ION_fnc_createCombatMedicModule',  
            'MAZ_EZM_ION_fnc_createRiflemanModule',  
            'MAZ_EZM_ION_fnc_createRiflemanModule',  
            'MAZ_EZM_ION_fnc_createRiflemanModule'  
            ];  
            _grp setBehaviour "AWARE";  
            {_x setUnitPos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  
            
        MAZ_EZM_ION_fnc_createSentryModule = {  
            private _squadLead = call MAZ_EZM_ION_fnc_createSquadLeadModule;  
            private _grp = group _squadLead;  
            {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
            }forEach [  
            'MAZ_EZM_ION_fnc_createRiflemanModule'  
            ];  
            _grp setBehaviour "AWARE";  
            {_x setUnitPos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  
            
        MAZ_EZM_ION_fnc_createAntiAirTeamModule = {  
            private _squadLead = call MAZ_EZM_ION_fnc_createSquadLeadModule;  
            private _grp = group _squadLead;  
            {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
            }forEach [  
            'MAZ_EZM_ION_fnc_createAmmoBearerModule',  
            'MAZ_EZM_ION_fnc_createMissileSpecAAModule'  
            ];  
            _grp setBehaviour "AWARE";  
            {_x setUnitPos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  
            
        MAZ_EZM_ION_fnc_createAntiTankTeamModule = {  
            private _squadLead = call MAZ_EZM_ION_fnc_createSquadLeadModule;  
            private _grp = group _squadLead;  
            {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
            }forEach [  
            'MAZ_EZM_ION_fnc_createAmmoBearerModule',  
            'MAZ_EZM_ION_fnc_createRiflemanLATModule'  
            ];  
            _grp setBehaviour "AWARE";  
            {_x setUnitPos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  
            
        MAZ_EZM_ION_fnc_createSharpshooterTeamModule = {  
            private _squadLead = call MAZ_EZM_ION_fnc_createMarksmanModule;  
            private _grp = group _squadLead;  
            _squadLead addPrimaryWeaponItem "optic_AMS";  
            {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
            }forEach [  
            'MAZ_EZM_ION_fnc_createSquadLeadModule'  
            ];  
            
            _grp setBehaviour "AWARE";  
        };  
       
    comment "Groups (Guards)"; 
        
        MAZ_EZM_ION_fnc_createGuardPatrolModule = {  
            private _squadLead = call MAZ_EZM_ION_fnc_createGuardRifleModule;  
            private _grp = group _squadLead;  
            {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
            }forEach [  
            'MAZ_EZM_ION_fnc_createGuardSMGModule',  
            'MAZ_EZM_ION_fnc_createGuardRifleModule',  
            'MAZ_EZM_ION_fnc_createGuardPistolModule',  
            'MAZ_EZM_ION_fnc_createGuardShotgunModule'  
            ];  
            _grp setBehaviour "AWARE";  
            {_x setUnitPos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  
        
        MAZ_EZM_ION_fnc_createGuardSentryModule = {  
            private _squadLead = call MAZ_EZM_ION_fnc_createGuardRifleModule;  
            private _grp = group _squadLead;  
            {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
            }forEach [  
            'MAZ_EZM_ION_fnc_createGuardSMGModule'  
            ];  
            _grp setBehaviour "AWARE";  
            {_x setUnitPos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  
        
    comment "Men";  
       
        MAZ_EZM_ION_fnc_addNightHelmet = {
            params [["_unit",objNull,[objNull]],["_nvg","",[""]]];
            if(isNull _unit) exitWith {};
            if(!MAZ_EZM_nvgsOnlyAtNight) exitWith {};
            if(_nvg == "") then {
                private _loadout = getUnitLoadout (configFile >> "CfgVehicles" >> typeOf _unit);
                private _loadoutNVG = (_loadout select 9) select {"NV" in _x};
                if(_loadoutNVG isEqualTo []) exitWith {};
                _loadoutNVG = _loadoutNVG select 0;
                _nvg = _loadoutNVG;
            };
            if(call MAZ_EZM_fnc_isNightTime) then {
                _unit addHeadgear _nvg;
            } else {
                private _nvg = (assignedItems _unit) select {"NV" in _x};
                if(_nvg isEqualTo []) exitWith {};
                _nvg = _nvg select 0;
                removeHeadgear _unit;
            };
        };

        MAZ_EZM_ION_fnc_addIONIdentitiesToUnit = {  
            params ["_unit"];  
            sleep 0.1;  
            private _IONVoice = [  
            "Male01ENG",  
            "Male02ENG",  
            "Male03ENG",  
            "Male04ENG",
            "Male05ENG",
            "Male06ENG",
            "Male07ENG",
            "Male08ENG",
            "Male09ENG",
            "Male10ENG",
            "Male11ENG",
            "Male12ENG",
            "Male01ENGB",
            "Male02ENGB",
            "Male03ENGB",
            "Male04ENGB",
            "Male05ENGB"
            ];  
            private _IONHeads = [    
            "LivonianHead_2",  
            "LivonianHead_3",  
            "LivonianHead_4",  
            "LivonianHead_5",  
            "LivonianHead_6",  
            "LivonianHead_7",  
            "LivonianHead_8",  
            "LivonianHead_9",  
            "LivonianHead_10",  
            "RussianHead_1",  
            "RussianHead_2",  
            "RussianHead_3",  
            "RussianHead_4",  
            "RussianHead_5", 
            "WhiteHead_23",
            "WhiteHead_24",
            "WhiteHead_25",
            "WhiteHead_28",
            "WhiteHead_29",
            "WhiteHead_30",
            "WhiteHead_32",
            "AfricanHead_01",
            "AfricanHead_03"
            ]; 
            
            [_unit,(selectRandom _IONVoice)] remoteExec ['setSpeaker'];  
            [_unit,(selectRandom _IONHeads)] remoteExec ['setFace']; 
        
            _unit setskill 0.5; 
            _unit setUnitAbility 0.5; 
            _unit setSkill ["general", 0.5];  
            _unit setSkill ["courage", 1];  
            _unit setSkill ["aimingAccuracy", 0.45];   
            _unit setSkill ["commanding", 1];  
            _unit setSkill ["spotDistance", 1];  
            _unit setSkill ["spotTime", 0.9];  
            _unit setSkill ["reloadSpeed", 0.5];  
        };  

        MAZ_EZM_ION_fnc_addIONSuitIdentityToUnit = {  
            params ["_unit"];  
            sleep 0.1;  

            private _SuitHeads = ["Ivan","WhiteHead_26","WhiteHead_07"]; 

            private _SuitVoices = ["Male08ENG","Male01ENG","Male04ENGB"]; 
            
            removeGoggles _unit;
            _unit addGoggles "G_Shades_Black";
            [_unit,(selectRandom _SuitVoices)] remoteExec ['setSpeaker'];  
            [_unit,(selectRandom _SuitHeads)] remoteExec ['setFace'];  
        
            _unit setskill 0.5; 
            _unit setUnitAbility 0.5; 
            _unit setSkill ["general", 0.5];  
            _unit setSkill ["courage", 1];  
            _unit setSkill ["aimingAccuracy", 0.6];  
            _unit setSkill ["commanding", 1];  
            _unit setSkill ["spotDistance", 1];  
            _unit setSkill ["spotTime", 0.9];  
            _unit setSkill ["reloadSpeed", 0.5];
        };  

        MAZ_EZM_ION_fnc_getIONWeaponToUnit = {  
            params ["_unit"];  
            private _556Ammo = "30Rnd_556x45_Stanag";  
            private _545Ammo = "30Rnd_545x39_Mag_F";  
            private _65Ammo = "30Rnd_65x39_caseless_black_mag";  
            private _pWeapon = selectRandom [ ["arifle_SPAR_01_blk_F", _556Ammo], ["arifle_MX_Black_F", _65Ammo] ];  
            _pWeapon  
        };  
            
        MAZ_EZM_ION_fnc_addIONBackpack = {  
            params ["_unit"];  
            private _randomBackpack = selectRandom ["B_AssaultPack_blk"];  
            _unit addBackpackGlobal _randomBackpack;  
        };  
            
        MAZ_EZM_ION_fnc_addIONGogglesToUnit = {  
            params ["_unit"]; 
            sleep 1;
            private _IONGoggles = ["G_Tactical_Clear","G_WirelessEarpiece_F","G_Tactical_Black","G_Shades_Black",""];  
            _unit addGoggles (selectRandom _IONGoggles);
        };  
        
        MAZ_EZM_ION_fnc_addIONUniformToUnit = {  
            params ["_unit"];  
            private _IONUniforms = ["U_I_C_Soldier_Bandit_3_F","U_I_G_resistanceLeader_F","U_I_G_Story_Protagonist_F","U_I_L_Uniform_01_tshirt_black_F","U_IG_Guerilla2_2","U_B_CTRG_Soldier_2_Arid_F","U_I_L_Uniform_01_tshirt_skull_F"];  
            private _IONVests = ["V_PlateCarrier1_blk","V_CarrierRigKBT_01_light_Olive_F"];  
            private _IONHeadgear = ["H_WirelessEarpiece_F","H_HeadSet_black_F","H_Cap_khaki_specops_UK","H_Cap_usblack","H_Watchcap_blk","H_Cap_blk_ION","H_Bandanna_gry","H_Cap_blk_ION","H_Cap_blk_ION"];  
        
            _unit forceAddUniform (selectRandom _IONUniforms);  
            _unit addVest (selectRandom _IONVests);  
            _unit addHeadgear (selectRandom _IONHeadgear);  
            
            private _textureData = switch (uniform _unit) do { 
                case "U_B_CTRG_Soldier_2_Arid_F": {  
                    ["\a3\characters_f\BLUFOR\Data\clothing_wdl_co.paa"]
                };  
                
                case "U_I_C_Soldier_Bandit_3_F": {  
                    ["a3\characters_f_enoch\uniforms\data\i_l_uniform_01_deserter_1_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_skull_2_co.paa"]  
                };

                case "U_I_L_Uniform_01_tshirt_black_F": {  
                    ["a3\characters_f\civil\data\poor_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_skull_2_co.paa"]
                };   
                default {[]};
            }; 

            [_unit,_textureData] spawn {
                params ["_unit","_textureData"];
                sleep 0.1;
                {
                    if(_x == "") then {continue};
                    _unit setObjectTextureGlobal [_forEachIndex,_x];
                }forEach _textureData;
            };
        };  
        
        MAZ_EZM_ION_fnc_createAmmoBearerModule = {  
            private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] call MAZ_EZM_ION_fnc_addIONBackpack;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],["optic_Holosight_blk_F","acc_pointer_IR"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        };  
            
        MAZ_EZM_ION_fnc_createAutoriflemanModule = {  
            private _unit = [west,"B_soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            private _M556Ammo = selectRandom ["200Rnd_556x45_Box_Red_F", "200Rnd_556x45_Box_Tracer_Red_F"];  
            private _pMachineGun = selectRandom [ ["LMG_03_F",_M556Ammo] ];   
            [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        };  
            
        MAZ_EZM_ION_fnc_createCombatMedicModule = {  
            private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] call MAZ_EZM_ION_fnc_addIONBackpack;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;  
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],["optic_Holosight_blk_F","acc_pointer_IR"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            _unit addItemToBackpack "Medikit";  
            for "_i" from 0 to 4 do {  
            _unit addItemToBackpack "FirstAidKit";  
            };  

            _unit  
        };   
            
        MAZ_EZM_ION_fnc_createCrewmanModule = {  
            private _unit = [west,"B_crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit; 
            removeHeadgear _unit;  
            removevest _unit;  
            removeheadgear _unit;  
            _unit addHeadgear "H_HelmetCrew_I";  
            _unit addVest "V_TacVest_blk";  
            _unit addItemToVest "ToolKit";  
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],[]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        };  
            
        MAZ_EZM_ION_fnc_createEngineerModule = {  
            private _unit = [west,"B_engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],["optic_Holosight_blk_F","acc_pointer_IR"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            _unit  
        };  

        MAZ_EZM_ION_fnc_createSuitModule = {  
        
            private _unit = [west,"B_Survivor_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_ION_fnc_addIONSuitIdentityToUnit;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            removeVest _unit;  
            removeHeadgear _unit;
            _unit forceAddUniform "U_C_FormalSuit_01_gray_F"; 
            [_unit,""] remoteExec ["switchMove"]; 
            _unit    
        }; 
            
        MAZ_EZM_ION_fnc_createSquadLeadModule = {  
            private _unit = [west,"B_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit; 
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            _unit addWeapon "Rangefinder";  
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],["optic_Holosight_blk_F","acc_pointer_IR"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            removeGoggles _unit;   
            
            _unit    
        };  
            
        MAZ_EZM_ION_fnc_createGrenadierModule = {  
            private _unit = [west,"B_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;   
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            private _pGrenadier = selectRandom ["arifle_SPAR_01_GL_blk_F"];  
            [_unit,[_pGrenadier,["30Rnd_556x45_Stanag",7],["optic_Holosight_blk_F","acc_pointer_IR"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        };  
            
        MAZ_EZM_ION_fnc_createMarksmanModule = {  
            private _unit = [west,"B_soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            private _pSniper = selectRandom ["arifle_SPAR_03_blk_F"];  
            [_unit,[_pSniper,["20Rnd_762x51_Mag",5],["optic_DMS","acc_pointer_IR"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;   
            
            _unit  
        };  
            
        MAZ_EZM_ION_fnc_createMissileSpecAAModule = {  
            private _unit = [west,"B_soldier_AA_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] call MAZ_EZM_ION_fnc_addIONBackpack;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],["optic_Holosight_blk_F","acc_pointer_IR"]],["launch_B_Titan_F",["Titan_AA",2]],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            _unit  
        };  

        MAZ_EZM_ION_fnc_createHeliCrewModule = {  
            private _unit = [west,"B_T_Helicrew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;   
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            removeHeadgear _unit;  
            removevest _unit;  
            removeheadgear _unit;  
            _unit addUniform "U_B_HeliPilotCoveralls";
            _unit setObjectTextureGlobal [0,'\A3\characters_f\common\data\coveralls_grey_co.paa'];
            _unit addHeadgear "H_CrewHelmetHeli_B";  
            _unit addVest "V_TacVest_blk";  
            _unit addItemToVest "ToolKit";  
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],[]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        }; 
        
        MAZ_EZM_ION_fnc_createHeliPilotModule = {  
            private _unit = [west,"B_Helipilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;   
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            removeHeadgear _unit;  
            removevest _unit;  
            removeheadgear _unit;  
            _unit addUniform "U_B_HeliPilotCoveralls";
            _unit setObjectTextureGlobal [0,'\A3\characters_f\common\data\coveralls_grey_co.paa'];
            _unit addHeadgear "H_PilotHelmetHeli_B";  
            _unit addVest "V_TacVest_blk";  
            _unit addItemToVest "ToolKit";  
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],[]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        }; 

        MAZ_EZM_ION_fnc_createRiflemanModule = {  
            private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],["optic_Holosight_blk_F","acc_pointer_IR"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        };  
            
        MAZ_EZM_ION_fnc_createRiflemanLATModule = {  
            private _unit = [west,"B_soldier_AT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;   
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] call MAZ_EZM_ION_fnc_addIONBackpack;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            private _pRPG = selectRandom ["NLAW_F"];  
            private _pRPG32 = selectRandom ["RPG32_F"];  
            private _pAT = selectRandom [ ["launch_NLAW_F",_pRPG],["launch_RPG32_green_F",_pRPG32] ];  
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],["optic_Holosight_blk_F","acc_pointer_IR"]],[_pAT select 0, [_pAT select 1,3]],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        };  
            
        MAZ_EZM_ION_fnc_createRadiomanModule = {  
            private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,"H_HelmetHBK_F"] call MAZ_EZM_ION_fnc_addNightHelmet;
            [_unit,"NVGoggles_OPFOR"] call MAZ_EZM_fnc_addNVGs;
            _unit addBackpack "B_RadioBag_01_black_F";  
            private _weaponInfo = [_unit] call MAZ_EZM_ION_fnc_getIONWeaponToUnit;  
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,7],["optic_Holosight_blk_F","acc_pointer_IR"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            
            _unit  
        };  
            
        MAZ_EZM_ION_fnc_createUnarmedModule = {
            private _unit = [west,"B_Survivor_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;  
            _unit setVariable ["BIS_enableRandomization", false]; 
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            removeVest _unit;  
            removeHeadgear _unit;
            _unit addUniform "U_B_CTRG_Soldier_2_Arid_F";

            _unit spawn {
                sleep 0.1;
                _this setObjectTextureGlobal [0,'\a3\characters_f\BLUFOR\Data\clothing_wdl_co.paa'];
            };

            [_unit,""] remoteExec ["switchMove"]; 
            
            _unit  
        };  
        
    comment "Men (Guards)"; 
     
        MAZ_EZM_ION_fnc_addIONGuardUniformToUnit = {  
            params ["_unit"];  
            private _IONUniforms = ["U_C_Man_casual_1_F","U_Competitor"];  
            private _IONGuardVests = ["V_TacVest_blk"];  
            private _IONHeadgear = ["H_WirelessEarpiece_F","H_WirelessEarpiece_F","H_Cap_blk_ION","H_Cap_blk_ION","H_Cap_blk_ION"];  
            
            _unit forceAddUniform (selectRandom _IONUniforms);  
            _unit addVest (selectRandom _IONGuardVests);  
            _unit addHeadgear (selectRandom _IONHeadgear);  
            _unit addGoggles (selectRandom _IONGoggles);
            
            private _textureData = switch (uniform _unit) do {  
                case "U_C_Man_casual_1_F": {  
                    private _textureTop = selectRandom ["A3\Characters_F\Civil\Data\ig_poloshirt_2_co.paa","A3\Characters_F\Civil\Data\ig_poloshirt_1_co.paa"];  
                    [_textureTop];  
                };   
                default {[]}; 
            }; 

            [_unit,_textureData] spawn {
                params ["_unit","_textureData"];
                sleep 0.1;
                {
                    if(_x == "") then {continue};
                    _unit setObjectTextureGlobal [_forEachIndex,_x];
                }forEach _textureData;
            };
        };   
       
        MAZ_EZM_ION_fnc_createGuardRifleModule = {   
            private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONGuardUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,["arifle_SPAR_01_blk_F",["30Rnd_556x45_Stanag",5],["optic_Holosight_blk_F","acc_flashlight"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[[],[],[]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            _unit  
        }; 
     
        MAZ_EZM_ION_fnc_createGuardPistolModule = {  
            private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONGuardUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;   
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            _unit addVest "V_Rangemaster_belt";
            [_unit,["",[""],[]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",5]],3,[[],[],[]]] call MAZ_EZM_fnc_addItemAndWeapons;
            [_unit] spawn {
                params ["_unit"];
                sleep 1;
                _unit action ['SWITCHWEAPON',_unit,_unit,-1];
            };
            _unit  
        }; 
        
        MAZ_EZM_ION_fnc_createGuardSMGModule = {  
            private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_ION_fnc_addIONGuardUniformToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONIdentitiesToUnit;  
            [_unit] spawn MAZ_EZM_ION_fnc_addIONGogglesToUnit;  
            [_unit,["SMG_05_F",["30Rnd_9x21_Mag_SMG_02",5],["optic_Aco","acc_flashlight"]],[],["hgun_P07_blk_F",["16Rnd_9x21_Mag",2]],3,[[],[],[]]] call MAZ_EZM_fnc_addItemAndWeapons;
            _unit  
        };
      
    comment "Helicopters";   

        MAZ_EZM_ION_fnc_createGhosthawkModule = { 
            private _vehicle = ["B_Heli_Transport_01_F"] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then { 
                    
                private _pilot1 = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot1 moveInDriver _vehicle;   
                
                private _gunner1 = [] call MAZ_EZM_ION_fnc_createHeliCrewModule;  
                _gunner1 moveInGunner _vehicle;

                private _pilot2 = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot2 moveInAny _vehicle; 
                
                private _gunner2 = [] call MAZ_EZM_ION_fnc_createHeliCrewModule;  
                _gunner2 moveInAny _vehicle;

                private _grp = createGroup [west,true];  
                [_pilot1,_pilot2,_gunner1,_gunner2] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };
 
        MAZ_EZM_ION_fnc_createHellcatModule = { 
            private _vehicle = ["I_Heli_light_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 

            [_vehicle,"Green"] call bis_fnc_initVehicle; 

            if(MAZ_EZM_spawnWithCrew) then { 
                    
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _gunner moveInAny _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };

        MAZ_EZM_ION_fnc_createHellcatUnarmedModule = { 
            private _vehicle = ["I_Heli_light_03_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 

            [_vehicle,"Green"] call bis_fnc_initVehicle; 

            if(MAZ_EZM_spawnWithCrew) then { 
                    
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _gunner moveInAny _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        }; 

        MAZ_EZM_ION_fnc_createMohawkModule = { 
            private _vehicle = ["I_Heli_Transport_02_F",["a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_1_ion_co.paa","a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_2_ion_co.paa","a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_3_ion_co.paa"]] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                    
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _gunner moveInAny _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };

        MAZ_EZM_ION_fnc_createHummingbirdModule = { 
            private _vehicle = ["B_Heli_Light_01_F",["\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa"]] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then { 
                    
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _gunner moveInAny _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };

        MAZ_EZM_ION_fnc_createOrcaModule = { 
            private _vehicle = ["O_Heli_Light_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 

            [_vehicle,"Black"] call bis_fnc_initVehicle; 

            if(MAZ_EZM_spawnWithCrew) then {  
                    
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _gunner moveInAny _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        }; 

        MAZ_EZM_ION_fnc_createOrcaUnarmedModule = { 
            private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then { 
                
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot moveInDriver _vehicle;  
            
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _gunner moveInAny _vehicle;  
            
                private _grp = createGroup [west,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
        
            _vehicle  
        }; 
       
        MAZ_EZM_ION_fnc_createPawneeModule = { 
            
            private _vehicle = ["B_Heli_Light_01_dynamicLoadout_F",["\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa"]] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then { 
                    
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _gunner moveInAny _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
                
            _vehicle  
        }; 

        MAZ_EZM_ION_fnc_createPawneeMinigunModule = { 
            
            private _vehicle = ["B_Heli_Light_01_dynamicLoadout_F",["\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa"]] call MAZ_EZM_fnc_createVehicle; 

            _vehicle setPylonLoadout [1,""];
            _vehicle setPylonLoadout [2,""];
            _vehicle removeWeaponTurret ["missiles_DAR", [-1]]; 

            if(MAZ_EZM_spawnWithCrew) then { 
                    
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _pilot moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                _gunner moveInAny _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
                
            _vehicle  
        }; 

    comment "Reinforcement";  
       
        MAZ_EZM_ION_fnc_createReinforcementMohawkModule = {  
            private _vehicle = ["I_Heli_Transport_02_F",["a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_1_ion_co.paa","a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_2_ion_co.paa","a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_3_ion_co.paa"]] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule; 
                private _passanger16 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                private _passanger15 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger14 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger13 = [] call MAZ_EZM_ION_fnc_createAutoriflemanModule;  
                private _passanger12 = [] call MAZ_EZM_ION_fnc_createEngineerModule;  
                private _passanger11 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger10 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger9 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger8 = [] call MAZ_EZM_ION_fnc_createAutoriflemanModule;  
                private _passanger7 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createAmmoBearerModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _pilot moveInDriver _vehicle;  
                _gunner moveInAny _vehicle; 
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
                _passanger7 moveInCargo _vehicle;  
                _passanger8 moveInCargo _vehicle;  
                _passanger9 moveInCargo _vehicle;  
                _passanger10 moveInCargo _vehicle;  
                _passanger11 moveInCargo _vehicle;  
                _passanger12 moveInCargo _vehicle;  
                _passanger13 moveInCargo _vehicle;  
                _passanger14 moveInCargo _vehicle;  
                _passanger15 moveInCargo _vehicle;  
                _passanger16 moveInCargo _vehicle;  
                
                private _grp = createGroup [westendent,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [westendent,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [westendent,true];  
                [_passanger16,_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent _grp;  
                _grp selectLeader _passanger16;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  
        
        MAZ_EZM_ION_fnc_createReinforcementHellcatUnarmedModule = {  
            private _vehicle = ["I_Heli_light_03_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule; 
            
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createAmmoBearerModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _pilot moveInDriver _vehicle;  
                _gunner moveInAny _vehicle; 
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
                
                private _grp = createGroup [westendent,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [westendent,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  
        
        MAZ_EZM_ION_fnc_createReinforcementHellcatModule = {  
            private _vehicle = ["I_Heli_light_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 
        
            [_vehicle,"Green"] call bis_fnc_initVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule; 
            
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createAmmoBearerModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _pilot moveInDriver _vehicle;  
                _gunner moveInAny _vehicle; 
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
                
                private _grp = createGroup [westendent,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [westendent,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  
        
        MAZ_EZM_ION_fnc_createReinforcementOrcaModule = { 
            private _vehicle = ["O_Heli_Light_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [_vehicle,"Black"] call bis_fnc_initVehicle; 

            if(MAZ_EZM_spawnWithCrew) then {  
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule; 
            
                private _passanger8 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger7 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _pilot moveInDriver _vehicle;  
                _gunner moveInAny _vehicle; 
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
                _passanger7 moveInCargo _vehicle;  
                _passanger8 moveInCargo _vehicle;  
                
                private _grp = createGroup [westendent,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [westendent,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  
        
        MAZ_EZM_ION_fnc_createReinforcementOrcaUnarmedModule = {
            private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 
        
            [_vehicle,"Black"] call bis_fnc_initVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule; 
            
                private _passanger8 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger7 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _pilot moveInDriver _vehicle;  
                _gunner moveInAny _vehicle; 
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
                _passanger7 moveInCargo _vehicle;  
                _passanger8 moveInCargo _vehicle;  
                
                private _grp = createGroup [westendent,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [westendent,true];  
                [_pilo,_gunnert] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  
        
        MAZ_EZM_ION_fnc_createReinforcementHummingbirdModule = {  
            private _vehicle = ["B_Heli_Light_01_F",["\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa"]] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then {  
                private _pilot = [] call MAZ_EZM_ION_fnc_createHeliPilotModule;  
                private _gunner = [] call MAZ_EZM_ION_fnc_createHeliPilotModule; 
            
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _pilot moveInDriver _vehicle;  
                _gunner moveInAny _vehicle; 
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
            
                private _grp = createGroup [westendent,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [westendent,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createReinforcementHEMTTCoveredTransportModule = {  
            private _vehicle = ["B_Truck_01_covered_F",["","","","\a3\props_f_enoch\military\decontamination\data\containmentarea_black_co.paa"]] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger16 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                private _passanger15 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger14 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger13 = [] call MAZ_EZM_ION_fnc_createAutoriflemanModule;  
                private _passanger12 = [] call MAZ_EZM_ION_fnc_createEngineerModule;  
                private _passanger11 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger10 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger9 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger8 = [] call MAZ_EZM_ION_fnc_createAutoriflemanModule;  
                private _passanger7 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createAmmoBearerModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _driver moveInDriver _vehicle;  
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
                _passanger7 moveInCargo _vehicle;  
                _passanger8 moveInCargo _vehicle;  
                _passanger9 moveInCargo _vehicle;  
                _passanger10 moveInCargo _vehicle;  
                _passanger11 moveInCargo _vehicle;  
                _passanger12 moveInCargo _vehicle;  
                _passanger13 moveInCargo _vehicle;  
                _passanger14 moveInCargo _vehicle;  
                _passanger15 moveInCargo _vehicle;  
                _passanger16 moveInCargo _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [west,true];  
                [_passanger16,_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent _grp;  
                _grp selectLeader _passanger16;  
                _grp setBehaviour "AWARE";  
            };  

            _vehicle  
        };  
        
        MAZ_EZM_ION_fnc_createReinforcementOffroadCoveredModule = {  
            private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Black",1],   
                ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0]  
            ] call BIS_fnc_initVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE";  
                
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createReinforcementOffroadModule = { 
            private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Green",1],   
                ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]  
            ] call BIS_fnc_initVehicle;  

            _vehicle setObjectTextureGlobal [0,"a3\soft_f_enoch\offroad_01\data\offroad_01_ext_blk_co.paa"];  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE";  
                
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createReinforcementOffroadPortModule = { 
            private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Green",1],   
                ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]  
            ] call BIS_fnc_initVehicle;  

            _vehicle setObjectTextureGlobal [0,"a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_repair_civ_co.paa"];
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createGuardRifleModule;  
                _driver moveInDriver _vehicle;  
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE";  
                
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createGuardSMGModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createGuardSMGModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createGuardRifleModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createGuardRifleModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGuardRifleModule;  
                
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        }; 
        
        MAZ_EZM_ION_fnc_createReinforcementProwlerModule = { 
            private _vehicle = ["B_LSV_01_unarmed_black_F"] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE";  
                
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;
                
                private _grp = createGroup [west,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        }; 

        MAZ_EZM_ION_fnc_createReinforcementRhibModule = { 
            private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createAutoriflemanModule;  
                private _passanger7 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createAmmoBearerModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _driver moveInDriver _vehicle;  
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle; 
                _passanger7 moveInCargo _vehicle; 
                
                private _grp = createGroup [west,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE";  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createReinforcementVanModule = {  
            private _vehicle = ["I_G_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Black",1],   
                ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
            ] call BIS_fnc_initVehicle;  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                
                private _passanger10 = [] call MAZ_EZM_ION_fnc_createAutoriflemanModule;  
                private _passanger9 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger8 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger7 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createAmmoBearerModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _driver moveInDriver _vehicle;  
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
                _passanger7 moveInCargo _vehicle;  
                _passanger8 moveInCargo _vehicle;  
                _passanger9 moveInCargo _vehicle;  
                _passanger10 moveInCargo _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8,_passanger9,_passanger10] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE";  
            
            };  
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createReinforcementVanTransportModule = {  
            private _vehicle = ["I_G_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Black",1],   
                ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",0,"spare_tyre_hide",0,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
            ] call BIS_fnc_initVehicle;   
            
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                
                private _passanger10 = [] call MAZ_EZM_ION_fnc_createAutoriflemanModule;  
                private _passanger9 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger8 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger7 = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                private _passanger6 = [] call MAZ_EZM_ION_fnc_createAmmoBearerModule;  
                private _passanger5 = [] call MAZ_EZM_ION_fnc_createGrenadierModule;  
                private _passanger4 = [] call MAZ_EZM_ION_fnc_createMarksmanModule;  
                private _passanger3 = [] call MAZ_EZM_ION_fnc_createRiflemanLATModule;  
                private _passanger2 = [] call MAZ_EZM_ION_fnc_createCombatMedicModule;  
                private _passanger1 = [] call MAZ_EZM_ION_fnc_createSquadLeadModule;  
                
                _driver moveInDriver _vehicle;  
                _passanger1 moveInCargo _vehicle;  
                _passanger2 moveInCargo _vehicle;  
                _passanger3 moveInCargo _vehicle;  
                _passanger4 moveInCargo _vehicle;  
                _passanger5 moveInCargo _vehicle;  
                _passanger6 moveInCargo _vehicle;  
                _passanger7 moveInCargo _vehicle;  
                _passanger8 moveInCargo _vehicle;  
                _passanger9 moveInCargo _vehicle;  
                _passanger10 moveInCargo _vehicle;  
                
                private _grp = createGroup [west,true];  
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8,_passanger9,_passanger10] joinSilent _grp;  
                _grp selectLeader _passanger1;  
                _grp setBehaviour "AWARE";  
                
                private _grp = createGroup [west,true];  
                [_driver] joinSilent _grp;  
                _grp selectLeader _driver;  
                _grp setBehaviour "AWARE"; 
            };  
            _vehicle  
        }; 

    comment "Trucks";  

        MAZ_EZM_ION_fnc_createHEMTTModule = {   
            private _vehicle = ["B_Truck_01_mover_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createHEMTTAmmoModule = {   
            private _vehicle = ["B_Truck_01_ammo_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createHEMTTFuelModule = {  
            private _vehicle = ["B_Truck_01_fuel_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createHEMTTMedicalModule = {  
            private _vehicle = ["B_Truck_01_medical_F",["","","","\a3\props_f_enoch\military\decontamination\data\containmentarea_black_co.paa"]] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createHEMTTRepairModule = {  
            private _vehicle = ["B_Truck_01_Repair_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createHEMTTTransportModule = {  
            private _vehicle = ["B_Truck_01_transport_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createHEMTTCoveredTransportModule = {  
            private _vehicle = ["B_Truck_01_covered_F",["","","","\a3\props_f_enoch\military\decontamination\data\containmentarea_black_co.paa"]] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };   
        
    comment "Turrets";  
       
        MAZ_EZM_ION_fnc_createM2HMGModule = {  
            private _vehicle = ["I_G_HMG_02_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [_vehicle,nil,["Hide_Shield",1,"Hide_Rail",1]] call BIS_fnc_initVehicle;

            if(MAZ_EZM_spawnWithCrew) then {  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _gunner moveInGunner _vehicle;  
            };  
            
            _vehicle  
        };  
        
        MAZ_EZM_ION_fnc_createM2HMGRaisedModule = {  
            private _vehicle = ["I_G_HMG_02_high_F"] call MAZ_EZM_fnc_createVehicle; 

            [_vehicle,nil,["Hide_Shield",1,"Hide_Rail",1]] call BIS_fnc_initVehicle;
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _gunner moveInGunner _vehicle;  
            };  
            
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createMk32GMGModule = {  
            private _vehicle = ["O_GMG_01_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _gunner moveInGunner _vehicle;  
            };  
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createMk6MortarModule = {  
            private _vehicle = ["I_G_Mortar_01_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _gunner moveInGunner _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createAALauncherModule = {  
            private _vehicle = ["B_static_AA_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _gunner moveInGunner _vehicle;  
            };  
            
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createATLauncherModule = {  
            private _vehicle = ["I_static_AT_F"] call MAZ_EZM_fnc_createVehicle; 
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _gunner = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _gunner moveInGunner _vehicle;  
            };  
            
            _vehicle  
        };
       
    comment "Vans";  
         
        MAZ_EZM_ION_fnc_createTransportVanModule = {  
            private _vehicle = ["I_G_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Black",1],   
                ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",0,"spare_tyre_hide",0,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
            ] call BIS_fnc_initVehicle;  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
            
            _vehicle  
        };  
            
        MAZ_EZM_ION_fnc_createVanModule = {  
            private _vehicle = ["I_G_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Black",1],   
                ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
            ] call BIS_fnc_initVehicle;  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
        
            _vehicle  
        };  

        MAZ_EZM_ION_fnc_createSupplyVanModule = {  
            private _vehicle = ["I_G_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle; 
            
            [  
                _vehicle,  
                ["Black",1],   
                ["Enable_Cargo",0,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
            ] call BIS_fnc_initVehicle;  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  
        
            _vehicle  
        }; 

        MAZ_EZM_ION_fnc_createPortVanModule = {  
            private _vehicle = ["C_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle; 

            [
                _vehicle,
                ["CivService",1], 
                ["Enable_Cargo",0,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",1,"front_protective_frame_hide",1,"beacon_front_hide",0,"beacon_rear_hide",0]
            ] call BIS_fnc_initVehicle;

            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_ION_fnc_createGuardRifleModule;  
                _driver moveInDriver _vehicle;  
            };  
        
            _vehicle  
        }; 
       
comment "ION Modules";

    MAZ_EZM_ION_fnc_addToInterface = { 
        with uiNamespace do { 
        
            MAZ_IONTree = [   
                MAZ_UnitsTree_BLUFOR,   
                "ION Services",   
                "a3\ui_f_oldman\data\igui\cfg\holdactions\holdaction_market_ca.paa", 
                [1,1,1,1],  
                "ION Services"   
            ] call MAZ_EZM_fnc_zeusAddCategory;  

            comment "APCs";

                MAZ_IONAPCTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "APCs",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONAPCTree,  
                    "Panther",  
                    "Creates a ION Panther",  
                    "MAZ_EZM_ION_fnc_createPantherModule",  
                    "\A3\armor_f_beta\APC_Tracked_01\Data\UI\map_APC_Tracked_01_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONAPCTree,  
                    "Panther (Unarmed)",  
                    "Creates a ION Panther (Unarmed)",  
                    "MAZ_EZM_ION_fnc_createPantherUnarmedModule",  
                    "\A3\armor_f_beta\APC_Tracked_01\Data\UI\map_APC_Tracked_01_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
            comment "Boats";  
                
                MAZ_IONBoatsTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Boats",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONBoatsTree,  
                    "RHIB",  
                    "Creates a ION RHIB",  
                    "MAZ_EZM_ION_fnc_createRhibBoatModule",  
                    "\A3\Boat_F_Exp\Boat_Transport_02\Data\UI\Map_Boat_Transport_02_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
            comment "Cars";  
                
                MAZ_IONCarsTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Cars",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Hatchback",  
                    "Creates a ION Hatchback.",  
                    "MAZ_EZM_ION_fnc_createHatchbackModule",  
                    "\a3\soft_f_gamma\hatchback_01\data\ui\map_car_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "HEMTT",  
                    "Creates a ION HEMTT.",  
                    "MAZ_EZM_ION_fnc_createHEMTTModule",  
                    "\a3\soft_f_gamma\truck_01\data\ui\map_truck_01_mover_f_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "HEMTT Ammo",  
                    "Creates a ION HEMTT Ammo.",  
                    "MAZ_EZM_ION_fnc_createHEMTTAmmoModule",  
                    "a3\soft_f_gamma\Truck_01\Data\UI\map_truck_01_ammo_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "HEMTT Fuel",  
                    "Creates a ION HEMTT Fuel.",  
                    "MAZ_EZM_ION_fnc_createHEMTTFuelModule",  
                    "a3\soft_f_gamma\Truck_01\Data\UI\map_truck_01_fuel_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "HEMTT Medical",  
                    "Creates a ION Medical HEMTT.",  
                    "MAZ_EZM_ION_fnc_createHEMTTMedicalModule",  
                    "\a3\soft_f_beta\truck_01\data\ui\map_truck_01_covered_ca.paa" 
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "HEMTT Repair",  
                    "Creates a ION HEMTT Repair.",  
                    "MAZ_EZM_ION_fnc_createHEMTTRepairModule",  
                    "a3\soft_f_gamma\Truck_01\Data\UI\map_Truck_01_box_F_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "HEMTT Transport",  
                    "Creates a ION HEMTT.",  
                    "MAZ_EZM_ION_fnc_createHEMTTTransportModule",  
                    "a3\soft_f_beta\truck_01\data\ui\map_truck_01_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "HEMTT Transport (Covered)",  
                    "Creates a ION HEMTT (Covered).",  
                    "MAZ_EZM_ION_fnc_createHEMTTCoveredTransportModule",  
                    "a3\soft_f_beta\truck_01\data\ui\map_truck_01_covered_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Offroad",  
                    "Creates a ION Offroad.",  
                    "MAZ_EZM_ION_fnc_createOffroadModule",  
                    "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Offroad (Covered)",  
                    "Creates a ION Offroad (Covered).",  
                    "MAZ_EZM_ION_fnc_createOffroadCoveredModule",  
                    "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Offroad (Jammer)",  
                    "Creates a ION Offroad (Jammer).",  
                    "MAZ_EZM_ION_fnc_createOffroadJammerModule",  
                    "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Offroad (HMG)",  
                    "Creates a ION Offroad (HMG).",  
                    "MAZ_EZM_ION_fnc_createOffroadHMGModule",  
                    "\A3\Soft_F_Gamma\Offroad_01\Data\UI\map_offroad_armed_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;   

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Offroad (Port Security)",  
                    "Creates a ION Offroad (Port Security).",  
                    "MAZ_EZM_ION_fnc_createOffroadPortModule",  
                    "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Offroad (Repair)",  
                    "Creates a ION Offroad (Repair).",  
                    "MAZ_EZM_ION_fnc_createOffroadRepairModule",  
                    "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Jeep",  
                    "Creates a ION Jeep.",  
                    "MAZ_EZM_ION_fnc_createJeepModule",  
                    "\A3\Soft_F_Exp\Offroad_02\Data\UI\map_Offroad_02_base_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;   
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Jeep (LMG)",  
                    "Creates a ION Jeep (LMG).",  
                    "MAZ_EZM_ION_fnc_createJeepLMGModule",  
                    "\A3\Soft_F_Exp\Offroad_02\Data\UI\map_Offroad_02_base_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Prowler",  
                    "Creates a ION Prowler.",  
                    "MAZ_EZM_ION_fnc_createProwlerModule",  
                    "\a3\soft_f_exp\lsv_01\data\ui\map_lsv_01_base_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Prowler (AT)",  
                    "Creates a ION Prowler (AT).",  
                    "MAZ_EZM_ION_fnc_createProwlerATModule",  
                    "\a3\soft_f_exp\lsv_01\data\ui\map_lsv_01_base_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Prowler (HMG)",  
                    "Creates a ION Prowler (HMG).",  
                    "MAZ_EZM_ION_fnc_createProwlerHMGModule",  
                    "\a3\soft_f_exp\lsv_01\data\ui\map_lsv_01_base_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Quadbike",  
                    "Creates a ION Quadbike",  
                    "MAZ_EZM_ION_fnc_createQuadbikeModule",  
                    "\A3\Soft_F\Quadbike_01\Data\UI\map_Quad_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Strider",  
                    "Strider",  
                    "MAZ_EZM_ION_fnc_createStriderModule",  
                    "\a3\soft_f_beta\mrap_03\data\ui\map_mrap_03_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Strider HMG",  
                    "Strider HMG",  
                    "MAZ_EZM_ION_fnc_createStriderHMGModule",  
                    "\a3\soft_f_beta\mrap_03\data\ui\map_mrap_03_hmg_ca.paa" 
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Strider GMG",  
                    "Strider GMG",  
                    "MAZ_EZM_ION_fnc_createStriderGMGModule",  
                    "\a3\soft_f_beta\mrap_03\data\ui\map_mrap_03_rcws_ca.paa" 
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Van",  
                    "Creates a ION Van.",  
                    "MAZ_EZM_ION_fnc_createVanModule",  
                    "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Van (Port Security)",  
                    "Creates a ION Van (Port Security).",  
                    "MAZ_EZM_ION_fnc_createPortVanModule",  
                    "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Van (Supply)",  
                    "Creates a Supply Van.",  
                    "MAZ_EZM_ION_fnc_createSupplyVanModule",  
                    "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCarsTree,  
                    "Van Transport",  
                    "Creates a ION Transport Van.",  
                    "MAZ_EZM_ION_fnc_createTransportVanModule",  
                    "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
            comment "Compositions";  
                
                MAZ_IONCompositionsTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Compositions",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;   
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCompositionsTree,  
                    "Cache",  
                    "Creates a ION Cache.",  
                    "MAZ_EZM_ION_fnc_createCacheModule",  
                    "\a3\supplies_f_exp\ammoboxes\data\ui\icon_equipment_box_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCompositionsTree,  
                    "Cache (Arsenal)",  
                    "Creates a ION Arsenal Cache.",  
                    "MAZ_EZM_ION_fnc_createCacheArsenalModule",  
                    "\a3\ui_f\data\map\vehicleicons\iconcrateammo_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCompositionsTree,  
                    "Crashsite (Greyhawk)",  
                    "Creates a Crashsite.",  
                    "MAZ_EZM_ION_fnc_createCrashsiteGreyhawkModule",  
                    "\A3\Drones_F\Air_F_Gamma\UAV_02\Data\UI\Map_UAV_02_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCompositionsTree,  
                    "Crashsite (Mohawk)",  
                    "Creates a Crashsite.",  
                    "MAZ_EZM_ION_fnc_createCrashsiteMohawkModule",  
                    "\a3\air_f_beta\heli_transport_02\data\ui\map_heli_transport_02_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCompositionsTree,  
                    "Crashsite (Orca)",  
                    "Creates a Crashsite.",  
                    "MAZ_EZM_ION_fnc_createCrashsiteOrcaModule",  
                    "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCompositionsTree,  
                    "KIA",  
                    "KIA",  
                    "MAZ_EZM_ION_fnc_createDeadSoldierModule",  
                    "a3\ui_f_curator\data\cfgmarkers\kia_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONCompositionsTree,  
                    "KIA (Baggable)",  
                    "KIA (Baggable)",  
                    "MAZ_EZM_ION_fnc_createDeadSoldierBaggableModule",  
                    "a3\ui_f_curator\data\cfgmarkers\kia_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 
                
            comment "Drones";  
                
                MAZ_IONDronesTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Drones",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory; 

                [  
                MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONDronesTree,  
                    "AL-6 Pelican (Medical)",  
                    "AL-6 Pelican (Medical)",  
                    "MAZ_EZM_ION_fnc_createPelicanMedicalModule",  
                    "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONDronesTree,  
                    "AR-2 Darter",  
                    "AR-2 Darter", 
                    "MAZ_EZM_ION_fnc_createDarterModule",  
                    "\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UI\Map_UAV_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [ 
                MAZ_UnitsTree_BLUFOR, 
                    MAZ_IONTree, 
                    MAZ_IONDronesTree, 
                    "MK-4A Greyhawk", 
                    "MK-4A Greyhawk", 
                    "MAZ_EZM_ION_fnc_createGreyhawkModule", 
                    "\A3\Drones_F\Air_F_Gamma\UAV_02\Data\UI\Map_UAV_02_CA.paa" 
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

                [ 
                MAZ_UnitsTree_BLUFOR, 
                    MAZ_IONTree, 
                    MAZ_IONDronesTree, 
                    "MQ-12 Falcon", 
                    "MQ-12 Falcon", 
                    "MAZ_EZM_ION_fnc_createFalconModule", 
                    "\A3\Air_F_Exp\UAV_03\Data\UI\Map_UAV_03_CA.paa" 
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;
            
                [  
                MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONDronesTree,  
                    "UGV Stomper",  
                    "UGV Stomper",  
                    "MAZ_EZM_ION_fnc_createStomperModule",  
                    "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONDronesTree,  
                    "UGV Stomper RCWS",  
                    "UGV Stomper RCWS",  
                    "MAZ_EZM_ION_fnc_createStomperRCWSModule",  
                    "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_rcws_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;    
                
            comment "Groups";  
                
                MAZ_IONSubCatTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Groups",  
                    "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONSubCatTree,  
                    "Anti-Air Team",  
                    "Creates a ION Anti-Air Team",  
                    "MAZ_EZM_ION_fnc_createAntiAirTeamModule",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONSubCatTree,  
                    "Anti-Tank Team",  
                    "Creates a ION Anti-Tank Team",  
                    "MAZ_EZM_ION_fnc_createAntiTankTeamModule",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONSubCatTree,  
                    "Squad",  
                    "Creates a ION Squad",  
                    "MAZ_EZM_ION_fnc_createSquadModule",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONSubCatTree,  
                    "Patrol",  
                    "Creates a ION Patrol",  
                    "MAZ_EZM_ION_fnc_createPatrolModule",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONSubCatTree,  
                    "Sentry",  
                    "Creates a ION Sentry",  
                    "MAZ_EZM_ION_fnc_createSentryModule",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONSubCatTree,  
                    "Sharpshooter Team",  
                    "Creates a ION Sharpshooter Team",  
                    "MAZ_EZM_ION_fnc_createSharpshooterTeamModule",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

            comment "Groups (Guards)"; 
                
                MAZ_IONSubCatTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Groups (Guards)",  
                    "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONSubCatTree,  
                    "Patrol",  
                    "Creates a ION Guard Patrol",  
                    "MAZ_EZM_ION_fnc_createGuardPatrolModule",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONSubCatTree,  
                    "Sentry",  
                    "Creates a ION Guard Sentry",  
                    "MAZ_EZM_ION_fnc_createGuardSentryModule",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
        
            comment "Helicopters";  
    
                MAZ_IONHelicoptersTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Helicopters",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "AH-9 Pawnee",  
                    "AH-9 Pawnee",  
                    "MAZ_EZM_ION_fnc_createPawneeModule",  
                    "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_armed_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "AH-9 Pawnee (Minigun)",  
                    "AH-9 Pawnee (Minigun)",  
                    "MAZ_EZM_ION_fnc_createPawneeMinigunModule",  
                    "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_armed_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "CH-49 Mohawk",  
                    "CH-49 Mohawk",  
                    "MAZ_EZM_ION_fnc_createMohawkModule",  
                    "\a3\air_f_beta\heli_transport_02\data\ui\map_heli_transport_02_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "MH-9 Hummingbird",  
                    "MH-9 Hummingbird",  
                    "MAZ_EZM_ION_fnc_createHummingbirdModule",  
                    "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "PO-30 Orca",  
                    "PO-30 Orca",  
                    "MAZ_EZM_ION_fnc_createOrcaModule",  
                    "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "PO-30 Orca (Unarmed)",  
                    "PO-30 Orca (Unarmed)",  
                    "MAZ_EZM_ION_fnc_createOrcaUnarmedModule",  
                    "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "UH-80 Ghosthawk",  
                    "UH-80 Ghosthawk",  
                    "MAZ_EZM_ION_fnc_createGhosthawkModule",  
                    "\a3\air_f_beta\heli_transport_01\data\ui\map_heli_transport_01_base_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "WY-55 Hellcat",  
                    "WY-55 Hellcat",  
                    "MAZ_EZM_ION_fnc_createHellcatModule",  
                    "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONHelicoptersTree,  
                    "WY-55 Hellcat (Unarmed)",  
                    "WY-55 Hellcat (Unarmed)",  
                    "MAZ_EZM_ION_fnc_createHellcatUnarmedModule",  
                    "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_unarmed_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

            comment "Men";  
                
                MAZ_IONMenTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Men",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Ammo Bearer",  
                    "Creates a ION Ammo Bearer.",  
                    "MAZ_EZM_ION_fnc_createAmmoBearerModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Autorifleman",  
                    "Creates a ION Autorifleman.",  
                    "MAZ_EZM_ION_fnc_createAutoriflemanModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Combat Lifesaver",  
                    "Creates a ION Combat Lifesaver.",  
                    "MAZ_EZM_ION_fnc_createCombatMedicModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Crewman",  
                    "Creates a ION Crewman.",  
                    "MAZ_EZM_ION_fnc_createCrewmanModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Engineer",  
                    "Creates a ION Engineer.",  
                    "MAZ_EZM_ION_fnc_createEngineerModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Grenadier",  
                    "Creates a ION Grenadier.",  
                    "MAZ_EZM_ION_fnc_createGrenadierModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Marksman",  
                    "Creates a ION Marksman.",  
                    "MAZ_EZM_ION_fnc_createMarksmanModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Missile Specialist (AA)",  
                    "Creates a ION Anti-Air Missile Specialist.",  
                    "MAZ_EZM_ION_fnc_createMissileSpecAAModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Helicopter Crew",  
                    "Creates a ION Helicopter Crew.",  
                    "MAZ_EZM_ION_fnc_createHeliCrewModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Helicopter Pilot",  
                    "Creates a ION Helicopter Pilot.",  
                    "MAZ_EZM_ION_fnc_createHeliPilotModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Rifleman",  
                    "Creates a ION Rifleman.",  
                    "MAZ_EZM_ION_fnc_createRiflemanModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Rifleman (LAT)",  
                    "Creates a ION Light Anti-Tank Rifleman.",  
                    "MAZ_EZM_ION_fnc_createRiflemanLATModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Suit",  
                    "Creates a ION Suit.",  
                    "MAZ_EZM_ION_fnc_createSuitModule",  
                    "\a3\ui_f\data\map\vehicleicons\iconmanofficer_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Squad Leader",  
                    "Creates a ION Squad Leader.",  
                    "MAZ_EZM_ION_fnc_createSquadLeadModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Radio Operator",  
                    "Creates a ION Radio Operator.",  
                    "MAZ_EZM_ION_fnc_createRadiomanModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenTree,  
                    "Unarmed",  
                    "Creates a ION Unarmed.",  
                    "MAZ_EZM_ION_fnc_createUnarmedModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
            comment "Men (Guards)";  
                
                MAZ_IONMenGuardTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Men (Guards)",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenGuardTree,  
                    "Guard (Rifle)",  
                    "Creates a ION Guard (Rifle)",  
                    "MAZ_EZM_ION_fnc_createGuardRifleModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenGuardTree,  
                    "Guard (Pistol)",  
                    "Creates a ION Guard (Pistol).",  
                    "MAZ_EZM_ION_fnc_createGuardPistolModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;   
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONMenGuardTree,  
                    "Guard (SMG)",  
                    "Creates a ION Guard (SMG).",  
                    "MAZ_EZM_ION_fnc_createGuardSMGModule",  
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
            comment "Reinforcement";  
                
                MAZ_IONReinforcementTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Reinforcement",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "CH-49 Mohawk",  
                    "Creates a loaded ION CH-49 Mohawk",  
                    "MAZ_EZM_ION_fnc_createReinforcementMohawkModule",  
                    "\a3\air_f_beta\heli_transport_02\data\ui\map_heli_transport_02_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "HEMTT Transport",  
                    "Creates a loaded ION HEMTT (Covered)",  
                    "MAZ_EZM_ION_fnc_createReinforcementHEMTTCoveredTransportModule",  
                    "a3\soft_f_beta\truck_01\data\ui\map_truck_01_covered_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "MH-9 Hummingbird",  
                    "Creates a loaded ION MH-9 Hummingbird",  
                    "MAZ_EZM_ION_fnc_createReinforcementHummingbirdModule",  
                    "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "Offroad",  
                    "Creates a loaded ION Offroad",  
                    "MAZ_EZM_ION_fnc_createReinforcementOffroadModule",  
                    "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "Offroad (Covered)",  
                    "Creates a loaded ION Offroad (Covered)",  
                    "MAZ_EZM_ION_fnc_createReinforcementOffroadCoveredModule",  
                    "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "Offroad (Port Security)",  
                    "Creates a loaded ION Offroad",  
                    "MAZ_EZM_ION_fnc_createReinforcementOffroadPortModule",  
                    "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "PO-30 Orca (Unarmed)",  
                    "Creates a loaded AAF PO-30 Orca (Unarmed)",  
                    "MAZ_EZM_ION_fnc_createReinforcementOrcaUnarmedModule",  
                    "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "PO-30 Orca",  
                    "Creates a loaded AAF PO-30 Orca",  
                    "MAZ_EZM_ION_fnc_createReinforcementOrcaModule",  
                    "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "Prowler",  
                    "Creates a loaded ION Prowler",  
                    "MAZ_EZM_ION_fnc_createReinforcementProwlerModule",  
                    "\a3\soft_f_exp\lsv_01\data\ui\map_lsv_01_base_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                        
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "RHIB",  
                    "RHIB",  
                    "MAZ_EZM_ION_fnc_createReinforcementRhibModule",  
                    "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "Van",  
                    "Creates a loaded ION Van.",  
                    "MAZ_EZM_ION_fnc_createReinforcementVanModule",  
                    "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR; 
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "Van Transport",  
                    "Creates a loaded ION Transport Van.",  
                    "MAZ_EZM_ION_fnc_createReinforcementVanTransportModule",  
                    "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "WY-55 Hellcat",  
                    "Creates a loaded AAF WY-55 Hellcat",  
                    "MAZ_EZM_ION_fnc_createReinforcementHellcatModule",  
                    "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONReinforcementTree,  
                    "WY-55 Hellcat (Unarmed)",  
                    "Creates a loaded AAF WY-55 Hellcat (Unarmed)",  
                    "MAZ_EZM_ION_fnc_createReinforcementHellcatUnarmedModule",  
                    "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_unarmed_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
            
            comment "Turrets";  
                
                MAZ_IONTurretTree = [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    "Turrets",  
                    ""  
                ] call MAZ_EZM_fnc_zeusAddSubCategory;  

                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONTurretTree,  
                    "Mk32 GMG",  
                    "Creates a ION Mk32 GMG",  
                    "MAZ_EZM_ION_fnc_createMk32GMGModule",  
                    "\a3\ui_f\data\map\vehicleicons\iconstaticmg_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONTurretTree,  
                    "M2 HMG",  
                    "Creates a ION M2 HMG",  
                    "MAZ_EZM_ION_fnc_createM2HMGModule",  
                    "\a3\ui_f\data\map\vehicleicons\iconstaticmg_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONTurretTree,  
                    "M2 HMG (Raised)",  
                    "Creates a ION M2 HMG (Raised)",  
                    "MAZ_EZM_ION_fnc_createM2HMGRaisedModule",  
                    "\a3\ui_f\data\map\vehicleicons\iconstaticmg_ca.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONTurretTree,  
                    "Mk6 Mortar",  
                    "Creates a ION Mk6 Mortar",  
                    "MAZ_EZM_ION_fnc_createMk6MortarModule",  
                    "\A3\Static_f\Mortar_01\data\UI\map_Mortar_01_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONTurretTree,  
                    "Static AA Launcher",  
                    "Creates a Static AA Launcher",  
                    "MAZ_EZM_ION_fnc_createAALauncherModule",  
                    "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AA_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;    
                
                [  
                    MAZ_UnitsTree_BLUFOR,  
                    MAZ_IONTree,  
                    MAZ_IONTurretTree,  
                    "Static AT Launcher",  
                    "Creates a Static AT Launcher",  
                    "MAZ_EZM_ION_fnc_createATLauncherModule",  
                    "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AT_CA.paa"  
                ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;  
        
            
        };  
    }; 
 
["MAZ_EZM_ION_fnc_addToInterface"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;