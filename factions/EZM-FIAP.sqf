if(isNil "MAZ_EZM_Version") exitWith {
    systemChat "Enhanced Zeus Modules is not running!";
    playSound "addItemFailed";
};

if(isNil "MAZ_EZM_fnc_addNewFactionToDynamicFactions") exitWith {
    ["Your version of EZM is incompatible with dynamic factions. Please use the latest version!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

if(!isNil "MAZ_EZM_FIAP") exitWith {
    ["FIA+ is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_FIAP_Ver = "1.0";
MAZ_EZM_FIAP = true;

comment "APCs"; 

    MAZ_EZM_FIAP_fnc_createGorgonModule = { 
        private _vehicle = ["I_APC_Wheeled_03_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        private _camo = selectRandom ["Guerilla_01","Guerilla_02","Guerilla_03"]; 
        [ 
            _vehicle, 
            [_camo,1],  
            ["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _commander = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _commander; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createGorgon20mmModule = { 
        private _vehicle = ["I_APC_Wheeled_03_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
        _vehicle allowCrewInImmobile true;
        _vehicle animate ["HideTurret",1]; 
        private _turret = createVehicle ["I_LT_01_cannon_F",[0,0,0],[],0,"CAN_COLLIDE"]; 
        [_turret] call MAZ_EZM_fnc_addObjectToInterface; 
    
        _turret attachTo [_vehicle,[0.63,0,-0.1]]; 
        _turret allowDamage true; 
    
        [ 
            _vehicle, 
            ["Guerilla_01",1],  
            ["showCamonetHull",1,"showBags",0,"showBags2",0,"showTools",0,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        [ 
            _turret, 
            ["Indep_Olive",1],  
            ["showTools",0,"showCamonetHull",0,"showBags",0,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        _turret disableTIEquipment true; 
    
        _turret addMagazineTurret ["60Rnd_20mm_HE_shells",[0]]; 
        _turret addMagazineTurret ["60Rnd_20mm_HE_shells",[0]]; 
        _turret removeWeaponTurret ["LMG_coax_ext", [0]]; 
    
        _turret setObjectTexture [0, ""]; 
        _vehicle lockTurret [[0], true]; 
        _vehicle lockTurret [[1,1], true]; 
        _turret  lockDriver true; 
        _vehicle lockTurret [[1], true]; 
        _turret lockTurret [[1,1], true]; 
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
            _driver setUnloadInCombat [false, false]; 
        
            private _commander = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
            _commander setUnloadInCombat [false, false]; 
        
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _gunner moveInGunner _turret; 
            _gunner setUnloadInCombat [false, false]; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

comment "Boats"; 

    MAZ_EZM_FIAP_fnc_createRhibBoatModule = { 
        private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_FIAP_fnc_createAssaultBoatModule = { 
        private _vehicle = ["I_G_Boat_Transport_01_F"] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 

comment "Cars"; 

    MAZ_EZM_FIAP_fnc_createOffroadModule = { 
        private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        [_vehicle,[0, selectrandom ["a3\soft_f_enoch\offroad_01\data\offroad_01_ext_grn_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_02_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_03_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_05_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_06_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_07_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_08_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_09_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_11_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_12_co.paa"]]] remoteExec ['setObjectTexture',0,_vehicle]; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createMortarOffroadModule = { 
        private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
        private _turret = createVehicle ["I_Mortar_01_F",[0,0,0],[],0,"CAN_COLLIDE"]; 
        private _box = createVehicle ["Box_Syndicate_WpsLaunch_F",[0,0,0],[],0,"CAN_COLLIDE"];  
        [_turret] call MAZ_EZM_fnc_addObjectToInterface; 
        [_box] call MAZ_EZM_fnc_addObjectToInterface; 
                    
        _turret attachTo [_vehicle,[0.3,-2,0]]; 
        _box attachTo [_vehicle,[-0.05,-0.8,-0.49]]; 
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",1,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        [_vehicle,[0, selectrandom ["a3\soft_f_enoch\offroad_01\data\offroad_01_ext_grn_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_02_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_03_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_05_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_06_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_07_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_08_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_09_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_11_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_12_co.paa"]]] remoteExec ['setObjectTexture',0,_vehicle]; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            _gunner moveInGunner _turret; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createOffroadCoveredModule = { 
        private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        [_vehicle,[0, selectrandom ["a3\soft_f_enoch\offroad_01\data\offroad_01_ext_grn_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_02_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_03_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_05_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_06_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_07_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_08_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_09_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_11_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_12_co.paa"]]] remoteExec ['setObjectTexture',0,_vehicle]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createOffroadRepairModule = { 
        private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["hidePolice",1,"HideServices",0,"HideCover",1,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",1,"HideConstruction",1,"BeaconsStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        [_vehicle,[0, selectrandom ["a3\soft_f_enoch\offroad_01\data\offroad_01_ext_grn_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_02_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_03_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_05_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_06_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_07_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_08_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_09_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_11_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_12_co.paa"]]] remoteExec ['setObjectTexture',0,_vehicle]; 
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createOffroadHMGModule = { 
        private _vehicle = ["I_G_Offroad_01_armed_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["Hide_Shield",0,"Hide_Rail",1,"HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0] 
        ] call BIS_fnc_initVehicle; 
    
        [_vehicle,[0, selectrandom ["a3\soft_f_enoch\offroad_01\data\offroad_01_ext_grn_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_02_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_03_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_05_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_06_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_07_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_08_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_09_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_11_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_12_co.paa"]]] remoteExec ['setObjectTexture',0,_vehicle]; 
            
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createOffroadATModule = { 
        private _vehicle = ["I_G_Offroad_01_AT_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0] 
        ] call BIS_fnc_initVehicle; 
    
        [_vehicle,[0, selectrandom ["a3\soft_f_enoch\offroad_01\data\offroad_01_ext_grn_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_02_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_03_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_05_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_06_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_07_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_08_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_09_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_11_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_12_co.paa"]]] remoteExec ['setObjectTexture',0,_vehicle]; 
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createJeepModule = { 
        private _vehicle = ["I_C_Offroad_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Olive",1],  
            ["hideLeftDoor",0,"hideRightDoor",0,"hideRearDoor",0,"hideBullbar",0,"hideFenders",0,"hideHeadSupportRear",0,"hideHeadSupportFront",0,"hideRollcage",1,"hideSeatsRear",0,"hideSpareWheel",1] 
        ] call BIS_fnc_initVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
        
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createJeepLMGModule = { 
        private _vehicle = ["I_C_Offroad_02_LMG_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle removeMagazines "200Rnd_556x45_Box_Tracer_F"; 
        _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]]; 
        _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]]; 
        _vehicle addMagazineTurret ["200Rnd_556x45_Box_F",[0]]; 
    
        [ 
            _vehicle, 
            ["Olive",1],  
            ["hideLeftDoor",0,"hideRightDoor",0,"hideRearDoor",0,"hideBullbar",0,"hideFenders",0,"hideHeadSupportRear",0,"hideHeadSupportFront",0,"hideRollcage",1,"hideSeatsRear",0,"hideSpareWheel",1] 
        ] call BIS_fnc_initVehicle; 
                            
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createJeepATModule = { 
        private _vehicle = ["I_C_Offroad_02_AT_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Olive",1],  
            ["hideLeftDoor",0,"hideRightDoor",0,"hideRearDoor",0,"hideBullbar",0,"hideFenders",0,"hideHeadSupportRear",0,"hideHeadSupportFront",0,"hideRollcage",1,"hideSeatsRear",0,"hideSpareWheel",1] 
        ] call BIS_fnc_initVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createQuadbikeModule = { 
        private _vehicle = ["I_G_Quadbike_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        private _bikehelmets = selectRandom ["H_RacingHelmet_3_F","H_RacingHelmet_1_black_F","H_RacingHelmet_4_F"]; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            _passanger moveinCargo _vehicle; 
            [_driver] call MAZ_EZM_FIAP_fnc_addFIAPBackpack; 
            [_passanger] call MAZ_EZM_FIAP_fnc_addFIAPBackpack; 
            _driver addHeadgear _bikehelmets; 
            private _grp = createGroup [east,true]; 
            [_driver,_passanger] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 

comment "Compositions";

    MAZ_EZM_FIAP_fnc_createCache1Module = {
        
        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
        
        private _vehicle = createVehicle ["Land_Pallet_F",[24604.4,18789.3,0],[],0,"CAN_COLLIDE"];
        
        _vehicle setPosWorld [24589.396484,18790.230469,3.291037];
        _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]];
        
        private _simpleObject_1 = createSimpleObject ['a3\structures_f_mark\training\shootingmat_01_f.p3d', [24589.396484,18790.591797,3.390154]];
        _simpleObject_1 setVectorDirAndUp [[0.799994,0.00317998,0],[0,0,0.8]];
        [_simpleObject_1, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_1 setObjectScale 0.8;
        private _simpleObject_2 = createSimpleObject ['a3\structures_f_mark\training\shootingmat_01_f.p3d', [24589.402344,18789.908203,3.388135]];
        _simpleObject_2 setVectorDirAndUp [[0.799992,0.00358987,0],[0,0,0.8]];
        [_simpleObject_2, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_2 setObjectScale 0.8;
        private _simpleObject_3 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammobox.p3d', [24589.0488281,18790.720703,3.591737]];
        _simpleObject_3 setVectorDirAndUp [[0,1,0],[0,0,1]];
        _simpleObject_3 setObjectScale 1;
        [_simpleObject_3, _vehicle] call BIS_fnc_attachToRelative;
        private _simpleObject_4 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammobox.p3d', [24589.0507813,18790.212891,3.585812]];
        _simpleObject_4 setVectorDirAndUp [[0,1,0],[0,0,1]];
        _simpleObject_4 setObjectScale 1;
        [_simpleObject_4, _vehicle] call BIS_fnc_attachToRelative;
        private _simpleObject_5 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammoboxbig.p3d', [24589.0234375,18789.820313,3.55642]];
        _simpleObject_5 setVectorDirAndUp [[-0.00146181,0.999999,0],[0,0,1]];
        _simpleObject_5 setObjectScale 1;
        [_simpleObject_5, _vehicle] call BIS_fnc_attachToRelative;
        private _simpleObject_6 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammoboxbig.p3d', [24589.0253906,18789.638672,3.549962]];
        _simpleObject_6 setVectorDirAndUp [[-0.00137598,0.999999,0],[0,0,1]];
        _simpleObject_6 setObjectScale 1; 
        [_simpleObject_6, _vehicle] call BIS_fnc_attachToRelative;
        private _simpleObject_7 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_uslouncherbox.p3d', [24589.626953,18790.318359,3.568008]];
        _simpleObject_7 setVectorDirAndUp [[-1,1.19249e-008,0],[0,0,1]];
        _simpleObject_7 setObjectScale 1;
        [_simpleObject_7, _vehicle] call BIS_fnc_attachToRelative;
        private _simpleObject_8 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicweaponbox.p3d', [24589.978516,18790.486328,3.452644]];
        _simpleObject_8 setVectorDirAndUp [[1,7.54979e-008,0],[0,0,1]];
        _simpleObject_8 setObjectScale 1;
        [_simpleObject_8, _vehicle] call BIS_fnc_attachToRelative;
        private _simpleObject_9 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicweaponbox.p3d', [24589.980469,18790.480469,3.586804]];
        _simpleObject_9 setVectorDirAndUp [[1,7.54979e-008,0],[0,0,1]];
        _simpleObject_9 setObjectScale 1;
        [_simpleObject_9, _vehicle] call BIS_fnc_attachToRelative;
        private _simpleObject_10 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammoboxsmall.p3d', [24590.00585938,18789.951172,3.508759]];
        _simpleObject_10 setVectorDirAndUp [[0.0232496,-0.99973,0],[0,0,1]];
        _simpleObject_10 setObjectScale 1;
        [_simpleObject_10, _vehicle] call BIS_fnc_attachToRelative;
        private _simpleObject_11 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammoboxsmall.p3d', [24590.00976563,18789.826172,3.512415]];
        _simpleObject_11 setVectorDirAndUp [[0.0232496,-0.99973,0],[0,0,1]];
        _simpleObject_11 setObjectScale 1;
        [_simpleObject_11, _vehicle] call BIS_fnc_attachToRelative;
        [_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

        _vehicle addEventHandler ["HandleDamage", {
        params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
        if(_projectile isKindOf "TimeBombCore" || _projectile isKindOf "GrenadeCore" || _projectile isKindOf "BombCore" || _projectile isKindOf "RocketCore") then {
            private _bomb = "IEDUrbanBig_Remote_Ammo" createVehicle (_unit modelToWorld [0,0,0]);  
            _bomb setDamage 1;
            deleteVehicle _unit;
        };
        }];

        _vehicle addEventHandler ["Killed", {
            params ["_unit"];
            {
                detach _x;
                deleteVehicle _x;
            } forEach attachedObjects _unit;
        }];
        _vehicle addEventHandler ["Deleted", {
            params ["_unit"];
            {
                detach _x;
                deleteVehicle _x;
            } forEach attachedObjects _unit;
        }];

        _vehicle setpos _pos;
        
        _vehicle
    };

    MAZ_EZM_FIAP_fnc_createCache2Module = {
        
        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
        
        private _vehicle = createVehicle ["Land_Pallet_F",[24604.4,18789.3,0],[],0,"CAN_COLLIDE"];
            
        _vehicle setPosWorld [24604.396484,18789.289063,3.291037];
        _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]];
    
        _simpleObject_1 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_uslouncherbox.p3d', [24604.580078,18788.796875,3.545416]];
        _simpleObject_1 setVectorDirAndUp [[0,1,0],[0,0,1]];
        [_simpleObject_1, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_1 setObjectScale 1;
        _simpleObject_2 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammobox.p3d', [24604.767578,18789.232422,3.582083]];
        _simpleObject_2 setVectorDirAndUp [[0,1,0],[0,0,1]];
        [_simpleObject_2, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_2 setObjectScale 1;
        _simpleObject_3 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicweaponbox.p3d', [24604.158203,18789.404297,3.442312]];
        _simpleObject_3 setVectorDirAndUp [[1,7.54979e-008,0],[0,0,1]];
        [_simpleObject_3, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_3 setObjectScale 1;
        _simpleObject_4 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammoboxbig.p3d', [24604.759766,18789.576172,3.535646]];
        _simpleObject_4 setVectorDirAndUp [[-0.00137598,0.999999,0],[0,0,1]];
        [_simpleObject_4, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_4 setObjectScale 1;
        _simpleObject_5 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammoboxsmall.p3d', [24604.154297,18789.925781,3.499193]];
        _simpleObject_5 setVectorDirAndUp [[0,1,0],[0,0,1]];
        [_simpleObject_5, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_5 setObjectScale 1;
        _simpleObject_6 = createSimpleObject ['a3\structures_f_mark\training\shootingmat_01_f.p3d', [24604.400391,18789.644531,3.388971]];
        _simpleObject_6 setVectorDirAndUp [[0.799994,0.00317998,0],[0,0,0.8]];
        [_simpleObject_6, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_6 setObjectScale 0.8;
        _simpleObject_7 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicweaponbox.p3d', [24604.183594,18789.431641,3.587127]];
        _simpleObject_7 setVectorDirAndUp [[1,7.54979e-008,0],[0,0,1]];
        [_simpleObject_7, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_7 setObjectScale 1;
        _simpleObject_8 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicweaponbox.p3d', [24604.181641,18789.429688,3.725561]];
        _simpleObject_8 setVectorDirAndUp [[1,7.54979e-008,0],[0,0,1]];
        [_simpleObject_8, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_8 setObjectScale 1;
        _simpleObject_9 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_usbasicammoboxbig.p3d', [24604.757813,18789.759766,3.540076]];
        _simpleObject_9 setVectorDirAndUp [[-0.00146181,0.999999,0],[0,0,1]];
        [_simpleObject_9, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_9 setObjectScale 1;
        _simpleObject_10 = createSimpleObject ['a3\weapons_f\ammoboxes\proxy_uslouncherbox.p3d', [24603.845703,18789.267578,3.54471]];
        _simpleObject_10 setVectorDirAndUp [[0.999999,-0.00109629,0],[0,0,1]];
        [_simpleObject_10, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_10 setObjectScale 1;
        _simpleObject_11 = createSimpleObject ['a3\structures_f_mark\training\shootingmat_01_f.p3d', [24604.40625,18788.960938,3.386952]];
        _simpleObject_11 setVectorDirAndUp [[0.799992,0.00358977,0],[0,0,0.8]];
        [_simpleObject_11, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_11 setObjectScale 0.8;
        _simpleObject_12 = createSimpleObject ['a3\weapons_f\explosives\mine_at.p3d', [24603.833984,18789.617188,3.76521]];
        _simpleObject_12 setVectorDirAndUp [[-0.192588,0.98128,-0],[0,0,1]];
        [_simpleObject_12, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_12 setObjectScale 1;
        _simpleObject_13 = createSimpleObject ['a3\weapons_f\dummyweapon_single.p3d', [24604.660156,18788.783203,3.695402]];
        _simpleObject_13 setVectorDirAndUp [[0.021857,0.999761,0],[0,0,1]];
        [_simpleObject_13, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_13 setObjectScale 1;
        _simpleObject_14 = createSimpleObject ['a3\weapons_f\explosives\mine_at.p3d', [24603.822266,18789.304688,3.76457]];
        _simpleObject_14 setVectorDirAndUp [[0.997342,-0.0728652,-0],[0,0,1]];
        [_simpleObject_14, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_14 setObjectScale 1;
        
        _vehicle addEventHandler ["HandleDamage", {
        params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
        if(_projectile isKindOf "TimeBombCore" || _projectile isKindOf "GrenadeCore" || _projectile isKindOf "BombCore" || _projectile isKindOf "RocketCore") then {
            private _bomb = "IEDUrbanBig_Remote_Ammo" createVehicle (_unit modelToWorld [0,0,0]);  
            _bomb setDamage 1;
            deleteVehicle _unit;
        };
        }];
        
        [_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

        _vehicle addEventHandler ["Killed", {
            params ["_unit"];
            {
                detach _x;
                deleteVehicle _x;
            } forEach attachedObjects _unit;
        }];

        _vehicle addEventHandler ["Deleted", {
            params ["_unit"];
            {
                detach _x;
                deleteVehicle _x;
            } forEach attachedObjects _unit;
        }];

        _vehicle setpos _pos;
        
        _vehicle
    };

    MAZ_EZM_FIAP_fnc_createBunkerModule = {

        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;

        private _vehicle = createVehicle ["Land_BagBunker_Small_F",[24599.3,18798.2,-0.0737934],[],0,"CAN_COLLIDE"];
        
        _vehicle setPosWorld [24599.3,18798.2,4.08184];
        _vehicle setVectorDirAndUp [[0.0467889,-0.998905,0],[0,0,1]];

        private _simpleObject_1 = createSimpleObject ['a3\structures_f\civ\constructions\pallet_f.p3d', [24598.583984,18799.148438,3.192037]];
        _simpleObject_1 setVectorDirAndUp [[0.0570132,-0.898192,0],[0,0,0.9]];[_simpleObject_1, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_1 setObjectScale 0.9;
        private _simpleObject_2 = createSimpleObject ['a3\structures_f\civ\constructions\pallet_f.p3d', [24598.667969,18797.814453,3.19224]];
        _simpleObject_2 setVectorDirAndUp [[0.0570132,-0.898192,0],[0,0,0.9]];[_simpleObject_2, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_2 setObjectScale 0.9;
        private _simpleObject_3 = createSimpleObject ['a3\structures_f_epb\items\military\ammobox_rounds_f.p3d', [24597.978516,18798.984375,3.390146]];
        _simpleObject_3 setVectorDirAndUp [[0.999796,0.0201752,0],[0,0,1]];[_simpleObject_3, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_3 setObjectScale 1;
        private _simpleObject_4 = createSimpleObject ['a3\structures_f_epb\items\military\ammobox_rounds_f.p3d', [24597.988281,18798.611328,3.37442]];
        _simpleObject_4 setVectorDirAndUp [[0.995723,0.0923867,0],[0,0,1]];[_simpleObject_4, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_4 setObjectScale 1;
        private _simpleObject_5 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.796875,18798.910156,3.270214]];
        _simpleObject_5 setVectorDirAndUp [[0,1,0],[0,0,1]];[_simpleObject_5, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_5 setObjectScale 1;
        private _simpleObject_6 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.873047,18798.769531,3.270214]];
        _simpleObject_6 setVectorDirAndUp [[-0.76919,-0.63902,0],[0,0,1]];[_simpleObject_6, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_6 setObjectScale 1;
        private _simpleObject_7 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.914063,18798.867188,3.270214]];
        _simpleObject_7 setVectorDirAndUp [[0.991228,-0.132164,0],[0,0,1]];[_simpleObject_7, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_7 setObjectScale 1;
        private _simpleObject_8 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.730469,18798.828125,3.270214]];
        _simpleObject_8 setVectorDirAndUp [[0.447214,-0.894427,0],[0,0,1]];[_simpleObject_8, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_8 setObjectScale 1;
        private _simpleObject_9 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.841797,18799.00195313,3.275963]];
        _simpleObject_9 setVectorDirAndUp [[-0.8,0.6,0],[0,0,1]];[_simpleObject_9, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_9 setObjectScale 1;
        private _simpleObject_10 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.998047,18798.886719,3.270214]];
        _simpleObject_10 setVectorDirAndUp [[-0.597266,0.802043,0],[0,0,1]];[_simpleObject_10, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_10 setObjectScale 1;
        private _simpleObject_11 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.960938,18798.753906,3.270214]];
        _simpleObject_11 setVectorDirAndUp [[-0.407443,-0.913231,0],[0,0,1]];[_simpleObject_11, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_11 setObjectScale 1;
        private _simpleObject_12 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.941406,18798.650391,3.272212]];
        _simpleObject_12 setVectorDirAndUp [[-0.992796,0.11982,0],[0,0,1]];[_simpleObject_12, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_12 setObjectScale 1;
        private _simpleObject_13 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.802734,18798.710938,3.274431]];
        _simpleObject_13 setVectorDirAndUp [[-0.103606,0.994618,0],[0,0,1]];[_simpleObject_13, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_13 setObjectScale 1;
        private _simpleObject_14 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.763672,18798.613281,3.275955]];
        _simpleObject_14 setVectorDirAndUp [[-0.695421,0.718603,0],[0,0,1]];[_simpleObject_14, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_14 setObjectScale 1;
        private _simpleObject_15 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24600.0683594,18798.833984,3.270214]];
        _simpleObject_15 setVectorDirAndUp [[-0.132164,-0.991228,0],[0,0,1]];[_simpleObject_15, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_15 setObjectScale 1;
        private _simpleObject_16 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.890625,18799.0644531,3.270214]];
        _simpleObject_16 setVectorDirAndUp [[-0.996338,0.0855078,0],[0,0,1]];[_simpleObject_16, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_16 setObjectScale 1;
        private _simpleObject_17 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24600.0371094,18799.126953,3.270214]];
        _simpleObject_17 setVectorDirAndUp [[0.570908,-0.821014,0],[0,0,1]];[_simpleObject_17, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_17 setObjectScale 1;
        private _simpleObject_18 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.943359,18799.177734,3.274777]];
        _simpleObject_18 setVectorDirAndUp [[0.216437,0.976296,0],[0,0,1]];[_simpleObject_18, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_18 setObjectScale 1;
        private _simpleObject_19 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.966797,18798.990234,3.270214]];
        _simpleObject_19 setVectorDirAndUp [[0.929392,0.369095,0],[0,0,1]];[_simpleObject_19, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_19 setObjectScale 1;
        private _simpleObject_20 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.802734,18799.117188,3.274688]];
        _simpleObject_20 setVectorDirAndUp [[-0.666209,-0.745765,0],[0,0,1]];[_simpleObject_20, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_20 setObjectScale 1;
        private _simpleObject_21 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.931641,18799.261719,3.270214]];
        _simpleObject_21 setVectorDirAndUp [[-0.850177,-0.526498,0],[0,0,1]];[_simpleObject_21, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_21 setObjectScale 1;
        private _simpleObject_22 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24600.0605469,18799.214844,3.27128]];
        _simpleObject_22 setVectorDirAndUp [[0.875047,-0.484038,0],[0,0,1]];[_simpleObject_22, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_22 setObjectScale 1;
        private _simpleObject_23 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24600.162109,18799.185547,3.270214]];
        _simpleObject_23 setVectorDirAndUp [[-0.204273,-0.978914,0],[0,0,1]];[_simpleObject_23, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_23 setObjectScale 1;
        private _simpleObject_24 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24600.0898438,18799.0527344,3.273468]];
        _simpleObject_24 setVectorDirAndUp [[-0.999835,-0.0181789,0],[0,0,1]];[_simpleObject_24, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_24 setObjectScale 1;
        private _simpleObject_25 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24600.183594,18799.00585938,3.27272]];
        _simpleObject_25 setVectorDirAndUp [[-0.775434,-0.631428,0],[0,0,1]];[_simpleObject_25, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_25 setObjectScale 1;
        private _simpleObject_26 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.990234,18799.328125,3.270214]];
        _simpleObject_26 setVectorDirAndUp [[0.976296,-0.216438,0],[0,0,1]];[_simpleObject_26, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_26 setObjectScale 1;
        private _simpleObject_27 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.720703,18798.945313,3.270214]];
        _simpleObject_27 setVectorDirAndUp [[-0.775434,-0.631428,0],[0,0,1]];[_simpleObject_27, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_27 setObjectScale 1;
        private _simpleObject_28 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.527344,18799.267578,3.270214]];
        _simpleObject_28 setVectorDirAndUp [[0.976296,-0.216438,0],[0,0,1]];[_simpleObject_28, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_28 setObjectScale 1;
        private _simpleObject_29 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.427734,18799.00390625,3.273167]];
        _simpleObject_29 setVectorDirAndUp [[-0.996338,0.0855078,0],[0,0,1]];[_simpleObject_29, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_29 setObjectScale 1;
        private _simpleObject_30 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.574219,18799.0664063,3.274359]];
        _simpleObject_30 setVectorDirAndUp [[0.570908,-0.821014,0],[0,0,1]];[_simpleObject_30, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_30 setObjectScale 1;
        private _simpleObject_31 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.480469,18799.117188,3.273733]];
        _simpleObject_31 setVectorDirAndUp [[0.216437,0.976296,0],[0,0,1]];[_simpleObject_31, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_31 setObjectScale 1;
        private _simpleObject_32 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.503906,18798.929688,3.272668]];
        _simpleObject_32 setVectorDirAndUp [[0.929392,0.369095,0],[0,0,1]];[_simpleObject_32, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_32 setObjectScale 1;
        private _simpleObject_33 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.339844,18799.0566406,3.270214]];
        _simpleObject_33 setVectorDirAndUp [[-0.666209,-0.745765,0],[0,0,1]];[_simpleObject_33, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_33 setObjectScale 1;
        private _simpleObject_34 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.46875,18799.201172,3.270214]];
        _simpleObject_34 setVectorDirAndUp [[-0.850177,-0.526498,0],[0,0,1]];[_simpleObject_34, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_34 setObjectScale 1;
        private _simpleObject_35 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.597656,18799.154297,3.270214]];
        _simpleObject_35 setVectorDirAndUp [[0.875047,-0.484038,0],[0,0,1]];[_simpleObject_35, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_35 setObjectScale 1;
        private _simpleObject_36 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.699219,18799.125,3.27414]];
        _simpleObject_36 setVectorDirAndUp [[-0.204273,-0.978914,0],[0,0,1]];[_simpleObject_36, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_36 setObjectScale 1;
        private _simpleObject_37 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.626953,18798.992188,3.273895]];
        _simpleObject_37 setVectorDirAndUp [[-0.999835,-0.0181789,0],[0,0,1]];[_simpleObject_37, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_37 setObjectScale 1;
        private _simpleObject_38 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.597656,18799.462891,3.274347]];
        _simpleObject_38 setVectorDirAndUp [[-0.707107,0.707107,0],[0,0,1]];[_simpleObject_38, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_38 setObjectScale 1;
        private _simpleObject_39 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.75,18799.416016,3.270214]];
        _simpleObject_39 setVectorDirAndUp [[-0.0920449,-0.995755,0],[0,0,1]];[_simpleObject_39, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_39 setObjectScale 1;
        private _simpleObject_40 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.710938,18799.515625,3.270214]];
        _simpleObject_40 setVectorDirAndUp [[0.794358,0.60745,0],[0,0,1]];[_simpleObject_40, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_40 setObjectScale 1;
        private _simpleObject_41 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.607422,18799.357422,3.27577]];
        _simpleObject_41 setVectorDirAndUp [[0.948683,-0.316228,0],[0,0,1]];[_simpleObject_41, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_41 setObjectScale 1;
        private _simpleObject_42 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.564453,18799.560547,3.270214]];
        _simpleObject_42 setVectorDirAndUp [[-0.98995,-0.141421,0],[0,0,1]];[_simpleObject_42, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_42 setObjectScale 1;
        private _simpleObject_43 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.755859,18799.587891,3.270214]];
        _simpleObject_43 setVectorDirAndUp [[-0.989461,0.1448,0],[0,0,1]];[_simpleObject_43, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_43 setObjectScale 1;
        private _simpleObject_44 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.824219,18799.46875,3.270214]];
        _simpleObject_44 setVectorDirAndUp [[0.357646,-0.933857,0],[0,0,1]];[_simpleObject_44, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_44 setObjectScale 1;
        private _simpleObject_45 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.882813,18799.380859,3.274951]];
        _simpleObject_45 setVectorDirAndUp [[-0.786738,-0.617286,0],[0,0,1]];[_simpleObject_45, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_45 setObjectScale 1;
        private _simpleObject_46 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.742188,18799.326172,3.270214]];
        _simpleObject_46 setVectorDirAndUp [[-0.776562,0.630041,0],[0,0,1]];[_simpleObject_46, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_46 setObjectScale 1;
        private _simpleObject_47 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.783203,18799.228516,3.270214]];
        _simpleObject_47 setVectorDirAndUp [[-0.999866,0.016392,0],[0,0,1]];[_simpleObject_47, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_47 setObjectScale 1;
        private _simpleObject_48 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.84375,18799.599609,3.270214]];
        _simpleObject_48 setVectorDirAndUp [[0.60745,-0.794358,0],[0,0,1]];[_simpleObject_48, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_48 setObjectScale 1;
        private _simpleObject_49 = createSimpleObject ['a3\structures_f_enoch\furniture\school_equipment\student_chair.p3d', [24598.242188,18797.755859,3.265329]];
        _simpleObject_49 setVectorDirAndUp [[-0.996044,-0.0888595,0],[0,0,1]];[_simpleObject_49, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_49 setObjectScale 1;
        private _simpleObject_50 = createSimpleObject ['a3\structures_f_epa\items\food\canteen_f.p3d', [24598.0703125,18797.369141,3.381289]];
        _simpleObject_50 setVectorDirAndUp [[0.285254,-0.958452,0],[0,0,1]];[_simpleObject_50, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_50 setObjectScale 1;
        private _simpleObject_51 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.412109,18798.736328,3.276045]];
        _simpleObject_51 setVectorDirAndUp [[-0.295482,0.955348,0],[0,0,1]];[_simpleObject_51, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_51 setObjectScale 1;
        private _simpleObject_52 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.486328,18798.662109,3.276045]];
        _simpleObject_52 setVectorDirAndUp [[-0.501918,-0.864915,0],[0,0,1]];[_simpleObject_52, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_52 setObjectScale 1;
        private _simpleObject_53 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.638672,18798.677734,3.278112]];
        _simpleObject_53 setVectorDirAndUp [[0.860762,0.509008,0],[0,0,1]];[_simpleObject_53, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_53 setObjectScale 1;
        private _simpleObject_54 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.472656,18798.578125,3.276045]];
        _simpleObject_54 setVectorDirAndUp [[0.969693,0.244327,0],[0,0,1]];[_simpleObject_54, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_54 setObjectScale 1;
        private _simpleObject_55 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.363281,18798.662109,3.276045]];
        _simpleObject_55 setVectorDirAndUp [[-0.687384,0.726294,0],[0,0,1]];[_simpleObject_55, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_55 setObjectScale 1;
        private _simpleObject_56 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.275391,18798.720703,3.276045]];
        _simpleObject_56 setVectorDirAndUp [[0.491117,0.871094,0],[0,0,1]];[_simpleObject_56, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_56 setObjectScale 1;
        private _simpleObject_57 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.384766,18798.824219,3.278117]];
        _simpleObject_57 setVectorDirAndUp [[0.958395,-0.285445,0],[0,0,1]];[_simpleObject_57, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_57 setObjectScale 1;
        private _simpleObject_58 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.310547,18798.898438,3.276045]];
        _simpleObject_58 setVectorDirAndUp [[0.930235,0.366964,0],[0,0,1]];[_simpleObject_58, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_58 setObjectScale 1;
        private _simpleObject_59 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.396484,18798.533203,3.276045]];
        _simpleObject_59 setVectorDirAndUp [[-0.864915,0.501918,0],[0,0,1]];[_simpleObject_59, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_59 setObjectScale 1;
        private _simpleObject_60 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.677734,18798.609375,3.276045]];
        _simpleObject_60 setVectorDirAndUp [[0.460781,0.887514,0],[0,0,1]];[_simpleObject_60, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_60 setObjectScale 1;
        private _simpleObject_61 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.679688,18798.449219,3.276045]];
        _simpleObject_61 setVectorDirAndUp [[-0.977115,-0.21271,0],[0,0,1]];[_simpleObject_61, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_61 setObjectScale 1;
        private _simpleObject_62 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.763672,18798.515625,3.276927]];
        _simpleObject_62 setVectorDirAndUp [[0.81883,-0.574036,0],[0,0,1]];[_simpleObject_62, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_62 setObjectScale 1;
        private _simpleObject_63 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.580078,18798.566406,3.276045]];
        _simpleObject_63 setVectorDirAndUp [[-0.0152271,-0.999884,0],[0,0,1]];[_simpleObject_63, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_63 setObjectScale 1;
        private _simpleObject_64 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.84375,18798.496094,3.276045]];
        _simpleObject_64 setVectorDirAndUp [[-0.160515,0.987033,0],[0,0,1]];[_simpleObject_64, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_64 setObjectScale 1;
        private _simpleObject_65 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.75,18798.392578,3.276045]];
        _simpleObject_65 setVectorDirAndUp [[-0.78241,-0.622763,0],[0,0,1]]; [_simpleObject_65, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_65 setObjectScale 1;
        private _simpleObject_66 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.685547,18798.310547,3.276045]];
        _simpleObject_66 setVectorDirAndUp [[-0.825909,0.563803,0],[0,0,1]]; [_simpleObject_66, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_66 setObjectScale 1;
        private _simpleObject_67 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.589844,18798.429688,3.276045]];
        _simpleObject_67 setVectorDirAndUp [[0.36635,0.930477,0],[0,0,1]]; [_simpleObject_67, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_67 setObjectScale 1;
        private _simpleObject_68 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.511719,18798.359375,3.276045]];
        _simpleObject_68 setVectorDirAndUp [[-0.286077,0.958207,0],[0,0,1]]; [_simpleObject_68, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_68 setObjectScale 1;
        private _simpleObject_69 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.882813,18798.414063,3.276045]];
        _simpleObject_69 setVectorDirAndUp [[-0.574037,-0.818829,0],[0,0,1]]; [_simpleObject_69, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_69 setObjectScale 1;
        private _simpleObject_70 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24599.972656,18798.494141,3.2771]];
        _simpleObject_70 setVectorDirAndUp [[-0.268683,0.963229,0],[0,0,1]]; [_simpleObject_70, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_70 setObjectScale 1;
        private _simpleObject_72 = createSimpleObject ['a3\structures_f\civ\constructions\pallet_f.p3d', [24599.958984,18799.234375,3.187853]];
        _simpleObject_72 setVectorDirAndUp [[0.0570132,-0.898192,0],[0,0,0.9]]; [_simpleObject_72, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_72 setObjectScale 0.9;
        private _simpleObject_73 = createSimpleObject ['a3\structures_f\civ\constructions\pallet_f.p3d', [24600.0429688,18797.900391,3.188056]];
        _simpleObject_73 setVectorDirAndUp [[0.0570132,-0.898192,0],[0,0,0.9]]; [_simpleObject_73, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_73 setObjectScale 0.9;

        [_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

        _vehicle addEventHandler ["Killed", {
            params ["_unit"];
            {
                detach _x;
                deleteVehicle _x;
            } forEach attachedObjects _unit;
        }];
        _vehicle addEventHandler ["Deleted", {
            params ["_unit"];
            {
                detach _x;
                deleteVehicle _x;
            } forEach attachedObjects _unit;
        }];

        _vehicle setpos _pos;
        
        _vehicle
    };

comment "Drones"; 
            
    MAZ_EZM_FIAP_fnc_createDarterModule = { 
        private _vehicle = ["I_UAV_01_F"] call MAZ_EZM_fnc_createVehicle;

        private _aiGroup = createGroup [opfor,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createPelicanModule = { 
        private _vehicle = ["C_IDAP_UAV_06_antimine_F"] call MAZ_EZM_fnc_createVehicle;
    
        private _aiGroup = createGroup [opfor,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader; 

        _vehicle addEventHandler ["Fired", { 
            params ["_unit", "", "", "", "", "", "_projectile", ""]; 
            private _allahsNade = "GrenadeHand" createVehicle getPos _unit; 
            deleteVehicle _projectile; 
        }]; 

        _vehicle 
    }; 

comment "Groups"; 
    
    MAZ_EZM_FIAP_fnc_createSquadModule = { 
        private _squadLead = call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_FIAP_fnc_createAmmoBearerModule', 
            'MAZ_EZM_FIAP_fnc_createCombatMedicModule', 
            'MAZ_EZM_FIAP_fnc_createRiflemanModule', 
            'MAZ_EZM_FIAP_fnc_createMarksmanModule', 
            'MAZ_EZM_FIAP_fnc_createRiflemanLATModule', 
            'MAZ_EZM_FIAP_fnc_createGrenadierModule', 
            'MAZ_EZM_FIAP_fnc_createAutoriflemanModule', 
            'MAZ_EZM_FIAP_fnc_createRiflemanModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 

    MAZ_EZM_FIAP_fnc_createPatrolModule = { 
        private _squadLead = call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_FIAP_fnc_createCombatMedicModule', 
            'MAZ_EZM_FIAP_fnc_createRiflemanModule', 
            'MAZ_EZM_FIAP_fnc_createMarksmanModule', 
            'MAZ_EZM_FIAP_fnc_createRiflemanModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 
    
    MAZ_EZM_FIAP_fnc_createSentryModule = { 
        private _squadLead = call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_FIAP_fnc_createRiflemanModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 
    
    MAZ_EZM_FIAP_fnc_createAntiAirTeamModule = { 
        private _squadLead = call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_FIAP_fnc_createAmmoBearerModule', 
            'MAZ_EZM_FIAP_fnc_createMissileSpecAAModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 
    
    MAZ_EZM_FIAP_fnc_createAntiTankTeamModule = { 
        private _squadLead = call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_FIAP_fnc_createAmmoBearerModule', 
            'MAZ_EZM_FIAP_fnc_createRiflemanLATModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 
    
    MAZ_EZM_FIAP_fnc_createSniperTeamModule = { 
        private _squadLead = call MAZ_EZM_FIAP_fnc_createMarksmanModule; 
        private _grp = group _squadLead; 
        _squadLead addPrimaryWeaponItem "optic_KHS_old"; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_FIAP_fnc_createSquadLeadModule' 
        ]; 
        
        _grp setBehaviour "AWARE"; 
    }; 
    
comment "Men"; 

    MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit = { 
        params ["_unit"]; 
        sleep 0.5; 
        private _greekVoice = [ 
            "Male01GRE", 
            "Male02GRE", 
            "Male03GRE", 
            "Male04GRE", 
            "Male05GRE", 
            "Male06GRE" 
        ]; 
        private _FIAPHeads = [ 
            "GreekHead_A3_11", 
            "GreekHead_A3_12", 
            "GreekHead_A3_13", 
            "GreekHead_A3_14", 
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
            "GreekHead_A3_02", 
            "GreekHead_A3_04", 
            "GreekHead_A3_01", 
            "GreekHead_A3_06", 
            "GreekHead_A3_08", 
            "GreekHead_A3_09" 
        ]; 
    
        [_unit,(selectRandom _greekVoice)] remoteExec ['setSpeaker']; 
        [_unit,(selectRandom _FIAPHeads)] remoteExec ['setFace']; 
    
        if((toLower (goggles _unit)) in ["g_balaclava_oli"]) then { 
            removeHeadgear _unit; 
        }; 
    
    }; 
    
    MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit = { 
        params ["_unit"]; 
        private _556Ammo = "30Rnd_556x45_Stanag"; 
        private _545Ammo = "30Rnd_545x39_Mag_F"; 
        private _762Ammo = "30Rnd_762x39_Mag_F"; 
        private _pWeapon = selectRandom [ ["arifle_AKM_FL_F", _762Ammo], ["arifle_Mk20C_F", _556Ammo], ["arifle_Mk20_F", _556Ammo], ["arifle_AKS_F", _545Ammo], ["arifle_TRG20_F", _556Ammo], ["arifle_TRG21_F", _556Ammo] ]; 
                    
        _pWeapon 
    }; 
    
    MAZ_EZM_FIAP_fnc_addFIAPBackpack = { 
        params ["_unit"]; 
        private _randomBackpack = selectRandom ["B_Messenger_Coyote_F","B_FieldPack_cbr","B_FieldPack_oli","B_TacticalPack_rgr","B_TacticalPack_blk","B_CivilianBackpack_01_Everyday_Black_F","B_CivilianBackpack_01_Everyday_Black_F"]; 
        _unit addBackpackGlobal _randomBackpack; 
    }; 
    
    MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit = { 
        params ["_unit"]; 
        private _FIAPGoggles = ["","","G_Shades_Black","G_Shades_Red","","G_Balaclava_oli","G_Bandanna_oli"]; 
        _unit addGoggles (selectRandom _FIAPGoggles); 
    }; 
    
    MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit = { 
        params ["_unit"]; 
        private _FIAPUniforms = ["U_IG_Guerilla3_1","U_C_Mechanic_01_F","U_I_C_Soldier_Para_4_F","U_I_C_Soldier_Bandit_3_F","U_BG_Guerilla1_1","U_BG_Guerilla1_1","U_IG_Guerilla2_3","U_IG_leader","U_IG_Guerrilla_6_1"]; 
        private _FIAPVests = ["V_PlateCarrierIA2_dgtl","V_PlateCarrierIA1_dgtl","V_CarrierRigKBT_01_Olive_F","V_I_G_resistanceLeader_F"]; 
        private _FIAPHeadgear = ["","","H_BandMask_blk","H_HelmetIA","H_HeadBandage_stained_F","H_Hat_Safari_sand_F","H_Booniehat_mgrn","H_PASGT_basic_olive_F","H_Watchcap_blk","H_Watchcap_camo","H_Shemag_olive_hs","H_Bandanna_gry","H_Bandanna_khk_hs","H_Cap_oli_hs","H_Cap_blk_Raven","H_HelmetIA","H_Cap_blk","H_Booniehat_dgtl","H_Cap_oli","H_Booniehat_oli"]; 
        
        _unit forceAddUniform (selectRandom _FIAPUniforms); 
        _unit addVest (selectRandom _FIAPVests); 
        _unit addHeadgear (selectRandom _FIAPHeadgear); 
        
        switch (uniform _unit) do { 
            case "U_C_Mechanic_01_F": { 
                private _textureTop = selectRandom ["a3\characters_f_gamma\civil\data\c_cloth1_brown.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_bandit_3_f_1_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_deserter_1_co.paa","a3\characters_f_orange\uniforms\data\c_cloth1_olive_co.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_para_1_f_1_co.paa","A3\Characters_F\Civil\Data\c_cloth1_bandit_co.paa","A3\Characters_F\Civil\Data\c_cloth1_kabeiroi_co.paa","a3\characters_f_gamma\Civil\Data\c_cloth1_black.paa","a3\characters_f\civil\data\poor_co.paa","a3\characters_f_orange\uniforms\data\c_mechanic_01_camo1_co.paa"]; 
                private _textureBottom = selectRandom ["a3\characters_f_orange\uniforms\data\c_mechanic_01_camo2_co.paa","a3\characters_f_gamma\guerrilla\data\ig_guerrilla3_1_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_black_2_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_skull_2_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_sport_2_co.paa","a3\characters_f_orange\uniforms\data\c_idap_man_jeansb_co.paa"]; 
                [[_unit,_textureTop,_textureBottom],{ 
                    params ["_unit","_top","_bottom"]; 
                    _unit setObjectTexture [0, _top]; 
                    _unit setObjectTexture [1, _bottom]; 
                }] remoteExec ['spawn',0,_unit]; 
            
            }; 
            case "U_I_C_Soldier_Para_4_F": { 
                private _textureTop = selectRandom ["a3\characters_f_enoch\uniforms\data\i_e_soldier_01_tanktop_co.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_bandit_5_f_1_co.paa"]; 
                private _textureBottom = selectRandom ["a3\characters_f_bootcamp\guerrilla\data\ig_guerrilla_6_1_co.paa","A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa","a3\characters_f_beta\indep\data\ia_soldier_01_clothing_co.paa"]; 
                [[_unit,_textureTop,_textureBottom],{ 
                    params ["_unit","_top","_bottom"]; 
                    _unit setObjectTexture [0, _top]; 
                    _unit setObjectTexture [1, _bottom]; 
                }] remoteExec ['spawn',0,_unit]; 
            }; 
            case "U_BG_Guerilla1_1": { 
                private _textureTop = selectRandom ["a3\characters_f_gamma\civil\data\c_cloth1_brown.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_bandit_3_f_1_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_deserter_1_co.paa","a3\characters_f_orange\uniforms\data\c_cloth1_olive_co.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_para_1_f_1_co.paa","A3\Characters_F\Civil\Data\c_cloth1_bandit_co.paa","A3\Characters_F\Civil\Data\c_cloth1_kabeiroi_co.paa","a3\characters_f_gamma\Civil\Data\c_cloth1_black.paa"]; 
                private _textureBottom = selectRandom ["a3\characters_f_bootcamp\guerrilla\data\ig_guerrilla_6_1_co.paa","A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa","a3\characters_f_beta\indep\data\ia_soldier_01_clothing_co.paa"]; 
                [[_unit,_textureTop,_textureBottom],{ 
                    params ["_unit","_top","_bottom"]; 
                    _unit setObjectTexture [0, _top]; 
                    _unit setObjectTexture [1, _bottom]; 
                }] remoteExec ['spawn',0,_unit]; 
            }; 
            case "U_I_C_Soldier_Bandit_3_F": { 
                private _textureTop = selectRandom ["a3\characters_F_exp\syndikat\data\U_I_C_Soldier_Bandit_2_F_2_co.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_bandit_3_f_1_co.paa"]; 
                private _textureBottom = selectRandom ["a3\characters_f_orange\uniforms\data\c_mechanic_01_camo2_co.paa","a3\characters_f_gamma\guerrilla\data\ig_guerrilla3_1_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_black_2_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_skull_2_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_tshirt_sport_2_co.paa","a3\characters_f_orange\uniforms\data\c_idap_man_jeansb_co.paa"]; 
                [[_unit,_textureTop,_textureBottom],{ 
                    params ["_unit","_top","_bottom"]; 
                    _unit setObjectTexture [0, _top]; 
                    _unit setObjectTexture [1, _bottom]; 
                }] remoteExec ['spawn',0,_unit]; 
            }; 
            case "U_IG_Guerilla2_3": { 
                private _textureTop = selectRandom ["a3\characters_f_gamma\guerrilla\data\ig_guerrilla2_1_co.paa","a3\characters_f_gamma\guerrilla\data\ig_guerrilla2_2_co.paa","a3\characters_f_gamma\guerrilla\data\ig_guerrilla2_3_co.paa"]; 
                
                [[_unit,_textureTop],{ 
                    params ["_unit","_top"]; 
                    _unit setObjectTexture [0, _top]; 
                }] remoteExec ['spawn',0,_unit]; 
            }; 
        }; 
    }; 
    
    MAZ_EZM_FIAP_fnc_createAmmoBearerModule = { 
        private _unit = [east,"O_G_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPBackpack; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createAutoriflemanModule = { 
        private _unit = [east,"O_G_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _M556Ammo = selectRandom ["200Rnd_556x45_Box_Red_F", "200Rnd_556x45_Box_Tracer_Red_F"]; 
        private _M65Ammo = selectRandom ["200Rnd_65x39_cased_Box_Red", "200Rnd_65x39_cased_Box_Tracer_Red"]; 
        private _pMachineGun = selectRandom [ ["LMG_Mk200_black_F",_M65Ammo],["LMG_03_F",_M556Ammo] ];  
        [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createCombatMedicModule = { 
        private _unit = [east,"O_G_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPBackpack; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit addItemToBackpack "Medikit"; 
        for "_i" from 0 to 4 do { 
            _unit addItemToBackpack "FirstAidKit"; 
        }; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createMedicModule = { 
        private _unit = [east,"O_G_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPBackpack; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
    
        _unit addVest "V_CarrierRigKBT_01_olive_F"; 
        removeGoggles _unit; 
        _unit addHeadgear "H_PASGT_basic_olive_F"; 
        _unit addItemToBackpack "Medikit"; 
        for "_i" from 0 to 4 do { 
            _unit addItemToBackpack "FirstAidKit"; 
        }; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createCrewmanModule = { 
        private _unit = [east,"O_G_engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        removeHeadgear _unit; 
        removevest _unit; 
        removeheadgear _unit; 
        _unit addHeadgear "H_Tank_black_F"; 
        _unit addVest "V_TacVest_oli"; 
        _unit addItemToVest "ToolKit"; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createEngineerModule = { 
        private _unit = [east,"O_G_engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createSquadLeadModule = { 
        private _unit = [east,"O_G_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        private _OfficerHeadgear = selectRandom ["H_Beret_blk","H_MilCap_dgtl",""]; 
        _unit addWeapon "Binocular"; 
        _unit addHeadgear _OfficerHeadgear; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        removeGoggles _unit;  
    
        _unit   
    }; 
    
    MAZ_EZM_FIAP_fnc_createGrenadierModule = { 
        private _unit = [east,"O_G_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _pGrenadier = selectRandom ["arifle_Mk20_GL_plain_F","arifle_Mk20_GL_F","arifle_TRG21_GL_F"]; 
        [_unit,[_pGrenadier,["30Rnd_556x45_Stanag",5],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createMarksmanModule = { 
        private _unit = [east,"O_G_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
                    private _pSniper = selectRandom [ "srifle_DMR_06_camo_F","srifle_DMR_06_olive_F","srifle_DMR_06_hunter_F"]; 
        [_unit,[_pSniper,["20Rnd_762x51_Mag",5],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createMissileSpecAAModule = { 
        private _unit = [east,"O_G_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPBackpack; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],["launch_I_Titan_F",["Titan_AA",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createRiflemanModule = { 
        private _unit = [east,"O_G_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createRiflemanLATModule = { 
        private _unit = [east,"O_G_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPBackpack; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _pRPG = selectRandom ["RPG32_F", "RPG32_F"]; 
        private _pRPG7 = selectRandom ["RPG7_F", "RPG7_F"]; 
        private _pAT = selectRandom [ ["launch_RPG32_camo_F",_pRPG],["launch_RPG7_F",_pRPG7] ]; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createRiflemanHATModule = { 
        private _unit = [east,"O_G_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPBackpack; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],["launch_MRAWS_olive_rail_F",["MRAWS_HEAT_F",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createRadiomanModule = { 
        private _unit = [east,"O_G_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit; 
        _unit addBackpack "B_RadioBag_01_black_F"; 
        [_unit,{ 
            (unitbackpack _this) setObjectTexture [0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]; 
        }] remoteExec ['spawn',0,_unit]; 
    
        private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_FIAP_fnc_createSurvivorModule = { 
        private _unit = [east,"O_G_Survivor_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit; 
        [_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit; 
    
        removeVest _unit; 
        removeHeadgear _unit; 
        [_unit,""] remoteExec ["switchMove"];
    
        _unit 
    }; 

comment "Reinforcement"; 

    MAZ_EZM_FIAP_fnc_createReinforcementZamakCoveredTransportModule = { 
        private _vehicle = ["I_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger16 = [] call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
            private _passanger15 = [] call MAZ_EZM_FIAP_fnc_createRiflemanLATModule; 
            private _passanger14 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger13 = [] call MAZ_EZM_FIAP_fnc_createAutoriflemanModule; 
            private _passanger12 = [] call MAZ_EZM_FIAP_fnc_createEngineerModule; 
            private _passanger11 = [] call MAZ_EZM_FIAP_fnc_createMarksmanModule; 
            private _passanger10 = [] call MAZ_EZM_FIAP_fnc_createCombatMedicModule; 
            private _passanger9 = [] call MAZ_EZM_FIAP_fnc_createGrenadierModule; 
            private _passanger8 = [] call MAZ_EZM_FIAP_fnc_createAutoriflemanModule; 
            private _passanger7 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_FIAP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_FIAP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_FIAP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_FIAP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_FIAP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
            
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
        
            private _grp = createGroup [east,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [east,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [east,true]; 
            [_passanger16,_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent _grp; 
            _grp selectLeader _passanger16; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createReinforcementOffroadCoveredModule = { 
        private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        [_vehicle,[0, selectrandom ["a3\soft_f_enoch\offroad_01\data\offroad_01_ext_grn_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_02_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_03_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_05_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_06_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_07_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_08_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_09_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_11_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_12_co.paa"]]] remoteExec ['setObjectTexture',0,_vehicle]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
            private _passanger1 = [] call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
            private _passanger2 = [] call MAZ_EZM_FIAP_fnc_createCombatMedicModule; 
            private _passanger3 = [] call MAZ_EZM_FIAP_fnc_createMarksmanModule; 
            private _passanger4 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger5 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createReinforcementOffroadModule = {
        private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        [_vehicle,[0, selectrandom ["a3\soft_f_enoch\offroad_01\data\offroad_01_ext_grn_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_01_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_02_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_03_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_04_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_05_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_06_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_07_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_08_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_09_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_10_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_11_co.paa","a3\soft_f_bootcamp\offroad_01\data\offroad_01_ext_ig_12_co.paa"]]] remoteExec ['setObjectTexture',0,_vehicle]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
    
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            private _grp = createGroup [east,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
            private _passanger1 = [] call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
            private _passanger2 = [] call MAZ_EZM_FIAP_fnc_createCombatMedicModule; 
            private _passanger3 = [] call MAZ_EZM_FIAP_fnc_createMarksmanModule; 
            private _passanger4 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger5 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_FIAP_fnc_createReinforcementRhibModule = { 
        
        private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_FIAP_fnc_createAutoriflemanModule; 
            private _passanger7 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_FIAP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_FIAP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_FIAP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_FIAP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_FIAP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
            
            _driver moveInDriver _vehicle; 
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle;
            _passanger7 moveInCargo _vehicle;
        
            private _grp = createGroup [east,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [east,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createReinforcementVanModule = { 
        private _vehicle = ["I_G_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["FIA3",1],  
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            
            private _passanger10 = [] call MAZ_EZM_FIAP_fnc_createAutoriflemanModule; 
            private _passanger9 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger8 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger7 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_FIAP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_FIAP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_FIAP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_FIAP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_FIAP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
            
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
            
            private _grp = createGroup [east,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8,_passanger9,_passanger10] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [east,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
        }; 
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_orange\van_02\data\van_body_fia_02_co.paa","a3\soft_f_orange\van_02\data\van_wheel_co.paa","a3\soft_f_orange\van_02\data\van_glass_fia_02_unfinished_ca.paa","a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa"]; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createReinforcementVanTransportModule = { 
        private _vehicle = ["I_G_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["FIA3",1],  
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            
            private _passanger10 = [] call MAZ_EZM_FIAP_fnc_createAutoriflemanModule; 
            private _passanger9 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger8 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger7 = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_FIAP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_FIAP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_FIAP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_FIAP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_FIAP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_FIAP_fnc_createSquadLeadModule; 
            
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
            
            private _grp = createGroup [east,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8,_passanger9,_passanger10] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [east,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        
        }; 
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa","a3\soft_f_orange\van_02\data\van_wheel_co.paa","a3\soft_f_orange\van_02\data\van_glass_fia_02_unfinished_ca.paa","a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa"]; 
    
        _vehicle 
    }; 
    
comment "Tanks"; 

    MAZ_EZM_FIAP_fnc_createAANyxModule = { 
        private _vehicle = ["I_LT_01_AA_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_Olive",1],  
            ["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _gunner; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_create20mmNyxModule = { 
        private _vehicle = ["I_LT_01_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]]; 
        _vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]]; 
        _vehicle removeWeaponTurret ["LMG_coax_ext", [0]]; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_Olive",1],  
            ["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [east,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _gunner; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
        
comment "Trucks"; 
    
    MAZ_EZM_FIAP_fnc_createZamakAmmoModule = {  
        private _vehicle = ["I_Truck_02_ammo_F"] call MAZ_EZM_fnc_createVehicle;
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_repair_green_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createZamakFuelModule = { 
        private _vehicle = ["I_Truck_02_fuel_F"] call MAZ_EZM_fnc_createVehicle;
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_fuel_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createZamakMedicalModule = { 
        private _vehicle = ["I_Truck_02_medical_F"] call MAZ_EZM_fnc_createVehicle;
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createZamakRepairModule = { 
        private _vehicle = ["I_Truck_02_box_F"] call MAZ_EZM_fnc_createVehicle;
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_repair_green_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createZamakTransportModule = { 
        private _vehicle = ["I_Truck_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createZamakCoveredTransportModule = { 
        private _vehicle = ["I_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createSupplyTruckModule = { 
        private _vehicle = ["O_G_Van_01_transport_F"] call MAZ_EZM_fnc_createVehicle;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
    
        _vehicle setPosWorld [24606.720703,18798.101563,5.0615072]; 
        _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]]; 
    
        private _simpleObject_1 = createSimpleObject ['a3\weapons_f\ammoboxes\ammobox.p3d', [24606.75,18796.21875,5.158334]]; 
        _simpleObject_1 setVectorDirAndUp [[-1.09943,-0.035473,0],[0,0,1.1]]; 
        [_simpleObject_1 , _vehicle] call BIS_fnc_attachToRelative; 
        _simpleObject_1 setObjectScale 1.1; 
    
        private _simpleObject_2 = createSimpleObject ['a3\soft_f\offroad_01\backpacks_f.p3d', [24606.705078,18795.0488281,3.428137]]; 
        _simpleObject_2 setVectorDirAndUp [[-0.0134496,0.99991,0],[0,0,1]]; 
        [_simpleObject_2 , _vehicle] call BIS_fnc_attachToRelative; 
        _simpleObject_2 setObjectScale 1; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
        
        _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition); 
        
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createTruckModule = { 
        private _vehicle = ["O_G_Van_01_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createTurretTruckModule = { 
        private _vehicle = ["O_G_Van_01_transport_F"] call MAZ_EZM_fnc_createVehicle;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
    
        _vehicle setPosWorld [24612.46875,18797.935547,5.0615072]; 
        _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]]; 
    
        _turret = createVehicle ["O_G_HMG_02_high_F",[24612.6,18796.2,1.27297],[],0,"CAN_COLLIDE"]; 
    
        _turret setPosWorld [24612.6,18796.2,6.14275]; 
        _turret setVectorDirAndUp [[0,1,0],[0,0,1]]; 
        
        [_turret, _vehicle] call BIS_fnc_attachToRelative; 

        private _simpleObject_2 = createSimpleObject ['a3\structures_f\civ\constructions\pallet_f.p3d', [24612.560547,18796.914063,4.401686]]; 
        _simpleObject_2 setVectorDirAndUp [[0.00716114,-1.09998,0],[0,0,1.1]]; 
        _simpleObject_2 setObjectScale 1.1; 
        [_simpleObject_2, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_3 = createSimpleObject ['a3\structures_f\civ\constructions\pallet_f.p3d', [24612.568359,18795.560547,4.399558]]; 
        _simpleObject_3 setVectorDirAndUp [[0.00716114,-1.09998,0],[0,0,1.1]]; 
        _simpleObject_3 setObjectScale 1.1; 
        [_simpleObject_3, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_4 = createSimpleObject ['a3\structures_f_epb\items\military\ammobox_rounds_f.p3d', [24611.601563,18795.644531,4.557722]]; 
        _simpleObject_4 setVectorDirAndUp [[0.999993,-0.00385014,0],[0,0,1]]; 
        _simpleObject_4 setObjectScale 1; 
        [_simpleObject_4, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_5 = createSimpleObject ['a3\structures_f_epb\items\military\ammobox_rounds_f.p3d', [24611.603516,18795.984375,4.557364]]; 
        _simpleObject_5 setVectorDirAndUp [[0.999971,0.0075872,0],[0,0,1]]; 
        _simpleObject_5 setObjectScale 1; 
        [_simpleObject_5, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_6 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.822266,18796.183594,4.503535]]; 
        _simpleObject_6 setVectorDirAndUp [[0,1,0],[0,0,1]]; 
        _simpleObject_6 setObjectScale 1; 
        [_simpleObject_6, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_7 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.898438,18796.0429688,4.503535]]; 
        _simpleObject_7 setVectorDirAndUp [[-0.76919,-0.63902,0],[0,0,1]]; 
        _simpleObject_7 setObjectScale 1; 
        [_simpleObject_7, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_8 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.939453,18796.140625,4.503535]]; 
        _simpleObject_8 setVectorDirAndUp [[0.991228,-0.132164,0],[0,0,1]]; 
        _simpleObject_8 setObjectScale 1; 
        [_simpleObject_8, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_9 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.755859,18796.101563,4.503535]]; 
        _simpleObject_9 setVectorDirAndUp [[0.447214,-0.894427,0],[0,0,1]]; 
        _simpleObject_9 setObjectScale 1; 
        [_simpleObject_9, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_10 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.867188,18796.275391,4.505602]]; 
        _simpleObject_10 setVectorDirAndUp [[-0.8,0.6,0],[0,0,1]]; 
        _simpleObject_10 setObjectScale 1; 
        [_simpleObject_10, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_11 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.0234375,18796.160156,4.503535]]; 
        _simpleObject_11 setVectorDirAndUp [[-0.597266,0.802043,0],[0,0,1]]; 
        _simpleObject_11 setObjectScale 1; 
        [_simpleObject_11, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_12 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.986328,18796.0273438,4.503535]]; 
        _simpleObject_12 setVectorDirAndUp [[-0.407443,-0.913231,0],[0,0,1]]; 
        _simpleObject_12 setObjectScale 1; 
        [_simpleObject_12, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_13 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.0800781,18796.015625,4.503535]]; 
        _simpleObject_13 setVectorDirAndUp [[-0.992796,0.11982,0],[0,0,1]]; 
        _simpleObject_13 setObjectScale 1; 
        [_simpleObject_13, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_14 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.822266,18796.00195313,4.505607]]; 
        _simpleObject_14 setVectorDirAndUp [[-0.103606,0.994618,0],[0,0,1]]; 
        _simpleObject_14 setObjectScale 1; 
        [_simpleObject_14, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_15 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.849609,18795.806641,4.503535]]; 
        _simpleObject_15 setVectorDirAndUp [[-0.695421,0.718603,0],[0,0,1]]; 
        _simpleObject_15 setObjectScale 1; 
        [_simpleObject_15, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_16 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.09375,18796.107422,4.503535]]; 
        _simpleObject_16 setVectorDirAndUp [[-0.132164,-0.991228,0],[0,0,1]]; 
        _simpleObject_16 setObjectScale 1; 
        [_simpleObject_16, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_17 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.916016,18796.337891,4.503535]]; 
        _simpleObject_17 setVectorDirAndUp [[-0.996338,0.0855078,0],[0,0,1]]; 
        _simpleObject_17 setObjectScale 1; 
        [_simpleObject_17, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_18 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.0625,18796.400391,4.503535]]; 
        _simpleObject_18 setVectorDirAndUp [[0.570908,-0.821014,0],[0,0,1]]; 
        _simpleObject_18 setObjectScale 1; 
        [_simpleObject_18, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_19 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.96875,18796.451172,4.504417]]; 
        _simpleObject_19 setVectorDirAndUp [[0.216437,0.976296,0],[0,0,1]]; 
        _simpleObject_19 setObjectScale 1; 
        [_simpleObject_19, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_20 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.992188,18796.263672,4.503535]]; 
        _simpleObject_20 setVectorDirAndUp [[0.929392,0.369095,0],[0,0,1]]; 
        _simpleObject_20 setObjectScale 1; 
        [_simpleObject_20, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_21 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.828125,18796.390625,4.504327]]; 
        _simpleObject_21 setVectorDirAndUp [[-0.666209,-0.745765,0],[0,0,1]]; 
        _simpleObject_21 setObjectScale 1; 
        [_simpleObject_21, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_22 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.912109,18796.607422,4.503535]]; 
        _simpleObject_22 setVectorDirAndUp [[-0.850177,-0.526498,0],[0,0,1]]; 
        _simpleObject_22 setObjectScale 1; 
        [_simpleObject_22, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_23 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.101563,18796.439453,4.503535]]; 
        _simpleObject_23 setVectorDirAndUp [[0.875047,-0.484038,0],[0,0,1]]; 
        _simpleObject_23 setObjectScale 1; 
        [_simpleObject_23, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_24 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.1875,18796.458984,4.503535]]; 
        _simpleObject_24 setVectorDirAndUp [[-0.204273,-0.978914,0],[0,0,1]]; 
        _simpleObject_24 setObjectScale 1; 
        [_simpleObject_24, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_25 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.115234,18796.326172,4.503535]]; 
        _simpleObject_25 setVectorDirAndUp [[-0.999835,-0.0181789,0],[0,0,1]]; 
        _simpleObject_25 setObjectScale 1; 
        [_simpleObject_25, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_26 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.208984,18796.279297,4.503535]]; 
        _simpleObject_26 setVectorDirAndUp [[-0.775434,-0.631428,0],[0,0,1]]; 
        _simpleObject_26 setObjectScale 1; 
        [_simpleObject_26, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_27 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24613.015625,18796.601563,4.503535]]; 
        _simpleObject_27 setVectorDirAndUp [[0.976296,-0.216438,0],[0,0,1]]; 
        _simpleObject_27 setObjectScale 1; 
        [_simpleObject_27, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_28 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.746094,18796.21875,4.503535]]; 
        _simpleObject_28 setVectorDirAndUp [[-0.775434,-0.631428,0],[0,0,1]]; 
        _simpleObject_28 setObjectScale 1; 
        [_simpleObject_28, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_29 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.544922,18796.576172,4.503535]]; 
        _simpleObject_29 setVectorDirAndUp [[0.976296,-0.216438,0],[0,0,1]]; 
        _simpleObject_29 setObjectScale 1; 
        [_simpleObject_29, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_30 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.453125,18796.277344,4.503535]]; 
        _simpleObject_30 setVectorDirAndUp [[-0.996338,0.0855078,0],[0,0,1]]; 
        _simpleObject_30 setObjectScale 1; 
        [_simpleObject_30, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_31 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.599609,18796.339844,4.503999]]; 
        _simpleObject_31 setVectorDirAndUp [[0.570908,-0.821014,0],[0,0,1]]; 
        _simpleObject_31 setObjectScale 1; 
        [_simpleObject_31, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_32 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.505859,18796.390625,4.504592]]; 
        _simpleObject_32 setVectorDirAndUp [[0.216437,0.976296,0],[0,0,1]]; 
        _simpleObject_32 setObjectScale 1; 
        [_simpleObject_32, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_33 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.529297,18796.203125,4.503535]]; 
        _simpleObject_33 setVectorDirAndUp [[0.929392,0.369095,0],[0,0,1]]; 
        _simpleObject_33 setObjectScale 1; 
        [_simpleObject_33, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_34 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.365234,18796.330078,4.503535]]; 
        _simpleObject_34 setVectorDirAndUp [[-0.666209,-0.745765,0],[0,0,1]]; 
        _simpleObject_34 setObjectScale 1; 
        [_simpleObject_34, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_35 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.494141,18796.474609,4.503535]]; 
        _simpleObject_35 setVectorDirAndUp [[-0.850177,-0.526498,0],[0,0,1]]; 
        _simpleObject_35 setObjectScale 1; 
        [_simpleObject_35, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_36 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.623047,18796.427734,4.503535]]; 
        _simpleObject_36 setVectorDirAndUp [[0.875047,-0.484038,0],[0,0,1]]; 
        _simpleObject_36 setObjectScale 1; 
        [_simpleObject_36, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_37 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.724609,18796.398438,4.50378]]; 
        _simpleObject_37 setVectorDirAndUp [[-0.204273,-0.978914,0],[0,0,1]]; 
        _simpleObject_37 setObjectScale 1; 
        [_simpleObject_37, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_38 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.652344,18796.265625,4.503535]]; 
        _simpleObject_38 setVectorDirAndUp [[-0.999835,-0.0181789,0],[0,0,1]]; 
        _simpleObject_38 setObjectScale 1; 
        [_simpleObject_38, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_39 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.613281,18796.75,4.503987]]; 
        _simpleObject_39 setVectorDirAndUp [[-0.707107,0.707107,0],[0,0,1]]; 
        _simpleObject_39 setObjectScale 1; 
        [_simpleObject_39, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_40 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.775391,18796.689453,4.503535]]; 
        _simpleObject_40 setVectorDirAndUp [[-0.0920449,-0.995755,0],[0,0,1]]; 
        _simpleObject_40 setObjectScale 1; 
        [_simpleObject_40, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_41 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.724609,18796.761719,4.503535]]; 
        _simpleObject_41 setVectorDirAndUp [[0.794358,0.60745,0],[0,0,1]]; 
        _simpleObject_41 setObjectScale 1; 
        [_simpleObject_41, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_42 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.632813,18796.630859,4.50541]]; 
        _simpleObject_42 setVectorDirAndUp [[0.948683,-0.316228,0],[0,0,1]]; 
        _simpleObject_42 setObjectScale 1; 
        [_simpleObject_42, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_43 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.589844,18796.833984,4.503535]]; 
        _simpleObject_43 setVectorDirAndUp [[-0.98995,-0.141421,0],[0,0,1]]; 
        _simpleObject_43 setObjectScale 1; 
        [_simpleObject_43, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_44 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.78125,18796.861328,4.503535]]; 
        _simpleObject_44 setVectorDirAndUp [[-0.989461,0.1448,0],[0,0,1]]; 
        _simpleObject_44 setObjectScale 1; 
        [_simpleObject_44, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_45 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.849609,18796.742188,4.503535]]; 
        _simpleObject_45 setVectorDirAndUp [[0.357646,-0.933857,0],[0,0,1]]; 
        _simpleObject_45 setObjectScale 1; 
        [_simpleObject_45, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_46 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.908203,18796.654297,4.504591]]; 
        _simpleObject_46 setVectorDirAndUp [[-0.786738,-0.617286,0],[0,0,1]]; 
        _simpleObject_46 setObjectScale 1; 
        [_simpleObject_46, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_47 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.767578,18796.599609,4.503535]]; 
        _simpleObject_47 setVectorDirAndUp [[-0.776562,0.630041,0],[0,0,1]]; 
        _simpleObject_47 setObjectScale 1; 
        [_simpleObject_47, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_48 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.810547,18796.466797,4.503535]]; 
        _simpleObject_48 setVectorDirAndUp [[-0.999866,0.016392,0],[0,0,1]]; 
        _simpleObject_48 setObjectScale 1; 
        [_simpleObject_48, _vehicle] call BIS_fnc_attachToRelative; 
        private _simpleObject_49 = createSimpleObject ['a3\weapons_f\ammo\cartridge_762.p3d', [24612.869141,18796.873047,4.503535]]; 
        _simpleObject_49 setVectorDirAndUp [[0.60745,-0.794358,0],[0,0,1]]; 
        _simpleObject_49 setObjectScale 1; 
        [_simpleObject_49, _vehicle] call BIS_fnc_attachToRelative; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            _gunner moveInGunner _turret; 
        }; 
        
        _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition); 
        
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createFuelTruckModule = { 
        private _vehicle = ["O_G_Van_01_fuel_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
comment "Turrets"; 

    MAZ_EZM_FIAP_fnc_createM2HMGModule = { 
        private _vehicle = ["I_G_HMG_02_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_FIAP_fnc_createM2HMGRaisedModule = { 
        private _vehicle = ["I_G_HMG_02_high_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createMk6MortarModule = { 
        private _vehicle = ["I_G_Mortar_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createAALauncherModule = { 
        private _vehicle = ["I_static_AA_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 

comment "Vans"; 
        
    MAZ_EZM_FIAP_fnc_createVanModule = { 
        private _vehicle = ["I_G_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["FIA3",1],  
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_orange\van_02\data\van_body_fia_02_co.paa","a3\soft_f_orange\van_02\data\van_wheel_co.paa","a3\soft_f_orange\van_02\data\van_glass_fia_02_unfinished_ca.paa","a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa"]; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createVanTransportModule = { 
        private _vehicle = ["I_G_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["FIA3",1],  
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa","a3\soft_f_orange\van_02\data\van_wheel_co.paa","a3\soft_f_orange\van_02\data\van_glass_fia_02_unfinished_ca.paa","a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa"]; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_FIAP_fnc_createMedicalVanModule = { 
        private _vehicle = ["I_E_Van_02_medevac_F"] call MAZ_EZM_fnc_createVehicle;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
        _vehicle setPosWorld [24668.3,18863.8,4.84614]; 
        _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]]; 
    
        private _crystal1 = createVehicle ["UserTexture1m_F",[24669.3,18863.2,1.923],[],0,"CAN_COLLIDE"]; 
        _crystal1 setObjectTextureGlobal [0,"a3\data_f\red_crystal_ca.paa"]; 
        _crystal1 setPosWorld [24669.31,18863.2,5.113]; 
        _crystal1 setVectorDirAndUp [[-0.595419,-0.00108918,-0.0739945],[-0.0739946,0,0.59542]]; 
        [_crystal1, _vehicle] call BIS_fnc_attachToRelative; 
        
        private _crystal2 = createVehicle ["UserTexture1m_F",[24667.3,18863.2,1.909],[],0,"CAN_COLLIDE"]; 
        _crystal2 setObjectTextureGlobal [0,"a3\data_f\red_crystal_ca.paa"]; 
        _crystal2 setPosWorld [24667.29,18863.2,5.099]; 
        _crystal2 setVectorDirAndUp [[0.595708,-2.62268e-008,-0.0716351],[0.0716351,0,0.595708]]; 
        [_crystal2, _vehicle] call BIS_fnc_attachToRelative; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createMedicModule; 
            _driver moveInDriver _vehicle; 
        }; 

        [ 
            _vehicle, 
            ["FIA3",1],  
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",0,"beacon_rear_hide",0] 
        ] call BIS_fnc_initVehicle; 
    
        { 
            [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle]; 
        }forEach ["a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa","a3\soft_f_orange\van_02\data\van_wheel_co.paa","a3\soft_f_orange\van_02\data\van_glass_fia_02_unfinished_ca.paa","a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa"]; 
        
        _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition); 
        
        _vehicle 
    }; 

comment "Zeus Interface";
MAZ_EZM_FIAP_fnc_modules = {
    with uiNamespace do {
        comment "FIA+ Modules"; 
				
            private _fiaLocalText = localize "$STR_A3_CFGFACTIONCLASSES_IND_G_F0";
            MAZ_FIAPTree = [MAZ_UnitsTree_OPFOR,_fiaLocalText] call MAZ_EZM_fnc_findTree;
            private _count = MAZ_UnitsTree_OPFOR tvCount [MAZ_FIAPTree]; 
            for "_i" from 0 to (_count - 1) do { 
                MAZ_UnitsTree_OPFOR tvDelete [MAZ_FIAPTree,0]; 
            }; 

            MAZ_UnitsTree_OPFOR tvSetText [[MAZ_FIAPTree], _fiaLocalText + "+"]; 
            MAZ_UnitsTree_OPFOR tvSetPictureRight [[MAZ_FIAPTree], "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_fia_ca.paa"]; 
            MAZ_UnitsTree_OPFOR tvSetTooltip [[MAZ_FIAPTree], format ["A remastered version of the FIA faction.\n\nAn Official EZM Faction.\nVersion: %1",missionNamespace getVariable "MAZ_EZM_FIAP_Ver"]]; 
        
        comment "APCs"; 
            
            MAZ_FIAPAPCsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "APCs", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPAPCsTree, 
                "AFV-4 Gorgon", 
                "Creates a FIA Gorgon.", 
                "MAZ_EZM_FIAP_fnc_createGorgonModule", 
                "\A3\armor_f_gamma\APC_Wheeled_03\Data\UI\map_APC_Wheeled_03_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPAPCsTree, 
                "AFV-4 Gorgon (No Turret)", 
                "Creates a FIA Gorgon.", 
                "MAZ_EZM_FIAP_fnc_createGorgonNoTurretModule", 
                "\A3\armor_f_gamma\APC_Wheeled_03\Data\UI\map_APC_Wheeled_03_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPAPCsTree, 
                "AFV-4 Gorgon (20mm)", 
                "Creates a FIA 20mm Gorgon. Can only be used by AI vs Players.", 
                "MAZ_EZM_FIAP_fnc_createGorgon20mmModule", 
                "\A3\armor_f_gamma\APC_Wheeled_03\Data\UI\map_APC_Wheeled_03_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
        comment "Boats"; 
        
            MAZ_FIAPBoatsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Boats", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPBoatsTree, 
                "Assault Boat", 
                "Creates a FIA Assault Boat", 
                "MAZ_EZM_FIAP_fnc_createAssaultBoatModule", 
                "\A3\boat_F\Boat_Transport_01\data\UI\map_Boat_Transport_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPBoatsTree, 
                "RHIB", 
                "Creates a FIA RHIB", 
                "MAZ_EZM_FIAP_fnc_createRhibBoatModule", 
                "\A3\Boat_F_Exp\Boat_Transport_02\Data\UI\Map_Boat_Transport_02_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Cars"; 
        
            MAZ_FIAPCarsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Cars", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Offroad", 
                "Creates a FIA Offroad.", 
                "MAZ_EZM_FIAP_fnc_createOffroadModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Offroad (AT)", 
                "Creates a FIA Offroad (AT).", 
                "MAZ_EZM_FIAP_fnc_createOffroadATModule", 
                "\A3\Soft_F_Gamma\Offroad_01\Data\UI\map_offroad_armed_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Offroad (Covered)", 
                "Creates a FIA Offroad (Covered).", 
                "MAZ_EZM_FIAP_fnc_createOffroadCoveredModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Offroad (HMG)", 
                "Creates a FIA Offroad (HMG).", 
                "MAZ_EZM_FIAP_fnc_createOffroadHMGModule", 
                "\A3\Soft_F_Gamma\Offroad_01\Data\UI\map_offroad_armed_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Offroad (Mortar)", 
                "Creates a FIA Mortar Offroad.", 
                "MAZ_EZM_FIAP_fnc_createMortarOffroadModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Offroad (Repair)", 
                "Creates a FIA Offroad (Repair).", 
                "MAZ_EZM_FIAP_fnc_createOffroadRepairModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Jeep", 
                "Creates a FIA Jeep.", 
                "MAZ_EZM_FIAP_fnc_createJeepModule", 
                "\A3\Soft_F_Exp\Offroad_02\Data\UI\map_Offroad_02_base_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Jeep (AT)", 
                "Creates a FIA Jeep (AT).", 
                "MAZ_EZM_FIAP_fnc_createJeepATModule", 
                "\A3\Soft_F_Exp\Offroad_02\Data\UI\map_Offroad_02_base_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Jeep (LMG)", 
                "Creates a FIA Jeep (LMG).", 
                "MAZ_EZM_FIAP_fnc_createJeepLMGModule", 
                "\A3\Soft_F_Exp\Offroad_02\Data\UI\map_Offroad_02_base_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCarsTree, 
                "Quadbike", 
                "Creates a FIA Quadbike", 
                "MAZ_EZM_FIAP_fnc_createQuadbikeModule", 
                "\A3\Soft_F\Quadbike_01\Data\UI\map_Quad_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
        comment "Compositions"; 
        
            MAZ_FIAPCompositionsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Compositions", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCompositionsTree, 
                "Bunker", 
                "Creates a FIA Bunker.", 
                "MAZ_EZM_FIAP_fnc_createBunkerModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCompositionsTree, 
                "Cache #1", 
                "Creates a FIA Cache.", 
                "MAZ_EZM_FIAP_fnc_createCache1Module", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPCompositionsTree, 
                "Cache #2", 
                "Creates a FIA Cache.", 
                "MAZ_EZM_FIAP_fnc_createCache2Module", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Drones"; 
        
            MAZ_FIAPDronesTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Drones", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPDronesTree, 
                "AR-2 Darter", 
                "Creates a FIA Darter.", 
                "MAZ_EZM_FIAP_fnc_createDarterModule", 
                "\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UI\Map_UAV_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPDronesTree, 
                "AL-6 Pelican (Grenade)", 
                "Creates a FIA Pelican. Can drop grenades.", 
                "MAZ_EZM_FIAP_fnc_createPelicanModule", 
                "\A3\Air_F_Orange\UAV_06\Data\UI\Map_UAV_06_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Groups"; 
        
            MAZ_FIAPSubCatTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Groups", 
                "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPSubCatTree, 
                "Anti-Air Team", 
                "Creates a FIA Anti-Air Team", 
                "MAZ_EZM_FIAP_fnc_createAntiAirTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPSubCatTree, 
                "Anti-Tank Team", 
                "Creates a FIA Anti-Tank Team", 
                "MAZ_EZM_FIAP_fnc_createAntiTankTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPSubCatTree, 
                "Squad", 
                "Creates a FIA Squad", 
                "MAZ_EZM_FIAP_fnc_createSquadModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPSubCatTree, 
                "Patrol", 
                "Creates a FIA Patrol", 
                "MAZ_EZM_FIAP_fnc_createPatrolModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPSubCatTree, 
                "Sentry", 
                "Creates a FIA Sentry", 
                "MAZ_EZM_FIAP_fnc_createSentryModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPSubCatTree, 
                "Sniper Team", 
                "Creates a FIA Sniper Team", 
                "MAZ_EZM_FIAP_fnc_createSniperTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Men"; 
            
            MAZ_FIAPMenTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Men", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Ammo Bearer", 
                "Creates a FIA Ammo Bearer.", 
                "MAZ_EZM_FIAP_fnc_createAmmoBearerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Autorifleman", 
                "Creates a FIA Autorifleman.", 
                "MAZ_EZM_FIAP_fnc_createAutoriflemanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Combat Lifesaver", 
                "Creates a FIA Combat Lifesaver.", 
                "MAZ_EZM_FIAP_fnc_createCombatMedicModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Crewman", 
                "Creates a FIA Crewman.", 
                "MAZ_EZM_FIAP_fnc_createCrewmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Engineer", 
                "Creates a FIA Engineer.", 
                "MAZ_EZM_FIAP_fnc_createEngineerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Grenadier", 
                "Creates a FIA Grenadier.", 
                "MAZ_EZM_FIAP_fnc_createGrenadierModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Marksman", 
                "Creates a FIA Marksman.", 
                "MAZ_EZM_FIAP_fnc_createMarksmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Missile Specialist (AA)", 
                "Creates a FIA Anti-Air Missile Specialist.", 
                "MAZ_EZM_FIAP_fnc_createMissileSpecAAModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Rifleman", 
                "Creates a FIA Rifleman.", 
                "MAZ_EZM_FIAP_fnc_createRiflemanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Rifleman (LAT)", 
                "Creates a FIA Light Anti-Tank Rifleman.", 
                "MAZ_EZM_FIAP_fnc_createRiflemanLATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Rifleman (HAT)", 
                "Creates a FIA Heavy Anti-Tank Rifleman.", 
                "MAZ_EZM_FIAP_fnc_createRiflemanHATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Squad Leader", 
                "Creates a FIA Squad Leader.", 
                "MAZ_EZM_FIAP_fnc_createSquadLeadModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Radio Operator", 
                "Creates a FIA Radio Operator.", 
                "MAZ_EZM_FIAP_fnc_createRadiomanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPMenTree, 
                "Survivor", 
                "Creates a FIA Survivor.", 
                "MAZ_EZM_FIAP_fnc_createSurvivorModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Reinforcement"; 
        
            MAZ_FIAPReinforcementTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Reinforcement", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPReinforcementTree, 
                "Offroad", 
                "Creates a loaded FIA Offroad", 
                "MAZ_EZM_FIAP_fnc_createReinforcementOffroadModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPReinforcementTree, 
                "Offroad (Covered)", 
                "Creates a loaded FIA Offroad (Covered)", 
                "MAZ_EZM_FIAP_fnc_createReinforcementOffroadCoveredModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPReinforcementTree, 
                "RHIB", 
                "RHIB", 
                "MAZ_EZM_FIAP_fnc_createReinforcementRhibModule", 
                "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPReinforcementTree, 
                "Transport Van", 
                "Creates a loaded FIA Transport Van.", 
                "MAZ_EZM_FIAP_fnc_createReinforcementVanTransportModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPReinforcementTree, 
                "Van", 
                "Creates a loaded FIA Van.", 
                "MAZ_EZM_FIAP_fnc_createReinforcementVanModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPReinforcementTree, 
                "Zamak", 
                "Creates a loaded FIA Zamak", 
                "MAZ_EZM_FIAP_fnc_createReinforcementZamakCoveredTransportModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Tanks"; 
            
            MAZ_FIAPTankTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Tanks", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTankTree, 
                "Anti-Air Nyx", 
                "Creates a FIA Anti-Air Nyx.", 
                "MAZ_EZM_FIAP_fnc_createAANyxModule", 
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTankTree, 
                "Autocannon Nyx", 
                "Creates a FIA 20mm Nyx.", 
                "MAZ_EZM_FIAP_fnc_create20mmNyxModule", 
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Trucks"; 
        
            MAZ_FIAPTrucksTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Trucks", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Zamak Ammo", 
                "Creates a FIA Zamak Ammo.", 
                "MAZ_EZM_FIAP_fnc_createZamakAmmoModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_box_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Zamak Fuel", 
                "Creates a FIA Zamak Fuel.", 
                "MAZ_EZM_FIAP_fnc_createZamakFuelModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_fuel_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Zamak Medical", 
                "Creates a FIA Medical Zamak.", 
                "MAZ_EZM_FIAP_fnc_createZamakMedicalModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_medevac_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Zamak Repair", 
                "Creates a FIA Zamak Repair.", 
                "MAZ_EZM_FIAP_fnc_createZamakRepairModule", 
                "\A3\Soft_F_Beta\Truck_02\Data\UI\Map_Truck_02_repair_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Zamak Transport", 
                "Creates a FIA Zamak.", 
                "MAZ_EZM_FIAP_fnc_createZamakTransportModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Zamak Transport (Covered)", 
                "Creates a FIA Zamak (Covered).", 
                "MAZ_EZM_FIAP_fnc_createZamakCoveredTransportModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Truck", 
                "Creates a FIA Truck.", 
                "MAZ_EZM_FIAP_fnc_createTruckModule", 
                "\A3\soft_f_gamma\van_01\Data\UI\map_van_01_cistern_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Turret Truck", 
                "Creates a FIA Turret Truck.", 
                "MAZ_EZM_FIAP_fnc_createTurretTruckModule", 
                "\A3\soft_f_gamma\van_01\Data\UI\map_van_01_cistern_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Fuel Truck", 
                "Creates a FIA Fuel Truck.", 
                "MAZ_EZM_FIAP_fnc_createFuelTruckModule", 
                "\A3\soft_f_gamma\van_01\Data\UI\map_van_01_cistern_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTrucksTree, 
                "Supply Truck", 
                "Creates a FIA Supply Truck.", 
                "MAZ_EZM_FIAP_fnc_createSupplyTruckModule", 
                "\A3\soft_f_gamma\van_01\Data\UI\map_van_01_cistern_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Turrets"; 
        
            MAZ_FIAPTurretTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Turrets", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTurretTree, 
                "M2 HMG", 
                "Creates a FIA M2 HMG", 
                "MAZ_EZM_FIAP_fnc_createM2HMGModule", 
                "\a3\static_f\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTurretTree, 
                "M2 HMG (Raised)", 
                "Creates a FIA M2 HMG (Raised)", 
                "MAZ_EZM_FIAP_fnc_createM2HMGRaisedModule", 
                "a3\static_f_oldman\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTurretTree, 
                "Mk6 Mortar", 
                "Creates a FIA Mk6 Mortar", 
                "MAZ_EZM_FIAP_fnc_createMk6MortarModule", 
                "\A3\Static_f\Mortar_01\data\UI\map_Mortar_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPTurretTree, 
                "Static AA Launcher", 
                "Creates a Static AA Launcher", 
                "MAZ_EZM_FIAP_fnc_createAALauncherModule", 
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AA_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
        comment "Vans"; 
        
            MAZ_FIAPVansTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                "Vans", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPVansTree, 
                "Van", 
                "Creates a FIA Van.", 
                "MAZ_EZM_FIAP_fnc_createVanModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPVansTree, 
                "Transport Van", 
                "Creates a FIA Transport Van.", 
                "MAZ_EZM_FIAP_fnc_createVanTransportModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_FIAPTree, 
                MAZ_FIAPVansTree, 
                "Medical Van", 
                "Creates a FIA Medical Van.", 
                "MAZ_EZM_FIAP_fnc_createMedicalVanModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_medevac_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
    };
};

["MAZ_EZM_FIAP_fnc_modules"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;