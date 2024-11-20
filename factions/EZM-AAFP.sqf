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

MAZ_EZM_AAFP_Ver = "1.1";
MAZ_EZM_AAFP = true;

comment "Anti-Air";

    MAZ_EZM_AAFP_fnc_createAANyxModule = { 
        private _vehicle = ["I_LT_01_AA_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_01"],  
            ["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _gunner; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

comment "APCs"; 

    MAZ_EZM_AAFP_fnc_createGorgonModule = { 
        private _vehicle = ["I_APC_Wheeled_03_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_01",1],  
            ["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _commander = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _commander; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createGorgon20mmModule = { 
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
            ["Indep_01",1],  
            ["showCamonetHull",1,"showBags",0,"showBags2",0,"showTools",0,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        [ 
            _turret, 
            ["Indep_01",1],  
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
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
            _driver setUnloadInCombat [false, false]; 
        
            private _commander = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
            _commander setUnloadInCombat [false, false]; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _gunner moveInGunner _turret; 
            _gunner setUnloadInCombat [false, false]; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createGorgonNoTurretModule = { 
        private _vehicle = ["I_APC_Wheeled_03_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        _vehicle animate ["HideTurret",2]; 
        _vehicle lockTurret [[0], true]; 
        [ 
            _vehicle, 
            ["",1],  
            ["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 

        _vehicle animate['HideTurret',1];
		_vehicle lockTurret [[0],true]; 
		_vehicle removeWeaponTurret ["autocannon_30mm_CTWS", [0]];
		_vehicle removeWeaponTurret ["LMG_coax_ext", [0]];
		_vehicle removeWeaponTurret ["missiles_titan", [0]];
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _commander = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
        
            private _grp = createGroup [INDEP,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _commander; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createMoraModule = { 
        private _vehicle = ["I_APC_tracked_03_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_01",1],
            ["showBags",0,"showBags2",1,"showCamonetHull",1,"showCamonetTurret",1,"showTools",1,"showSLATHull",0,"showSLATTurret",0] 
        ] call BIS_fnc_initVehicle; 
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _commander = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _commander; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

comment "Artillery";

    MAZ_EZM_AAFP_fnc_createZamakMRLModule = { 
        private _vehicle = ["I_Truck_02_MRL_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveIngunner _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _gunner; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

comment "Boats"; 

    MAZ_EZM_AAFP_fnc_createRhibBoatModule = { 
        private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createAssaultBoatModule = { 
        private _vehicle = ["I_Boat_Transport_01_F"] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createSpeedBoatModule = {
        private _vehicle = ["I_Boat_Armed_01_minigun_F",[
        "a3\boat_f\boat_armed_01\data\Boat_Armed_01_ext_INDP_CO.paa",
        "a3\boat_f\boat_armed_01\data\Boat_Armed_01_int_INDP_CO.paa",
        ""
        ]] call MAZ_EZM_fnc_createVehicle;
        _vehicle setObjectTextureGlobal [2, ""];
        _vehicle removeWeaponTurret ["GMG_40mm", [0]];
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            private _commander = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _commander moveInCommander _vehicle; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _driver; 
            _vehicle disableTIEquipment true; 
        }; 
        
        _vehicle 
    };

    MAZ_EZM_AAFP_fnc_createSpeedBoatHMGModule = {
        private _vehicle = ["O_Boat_Armed_01_hmg_F",[
            "a3\boat_f\boat_armed_01\data\boat_armed_01_ext_INDP_CO.paa",
            "a3\boat_f\boat_armed_01\data\boat_armed_01_int_INDP_CO.paa",
            "a3\boat_f\boat_armed_01\data\boat_armed_01_CROWS_INDP_CO.paa"
        ]] call MAZ_EZM_fnc_createVehicle;
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            private _commander = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _commander moveInCommander _vehicle; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _driver; 
            _vehicle disableTIEquipment true; 
        }; 
    
        _vehicle 
    };

    MAZ_EZM_AAFP_fnc_createSpeedBoatMinigunModule = {
        private _vehicle = ["I_Boat_Armed_01_minigun_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            private _commander = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _commander moveInCommander _vehicle; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    };

comment "Cars"; 

    MAZ_EZM_AAFP_fnc_createOffroadModule = { 
        private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0] 
        ] call BIS_fnc_initVehicle;  
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createMortarOffroadModule = { 
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
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            _gunner moveInGunner _turret; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createOffroadCoveredModule = { 
        private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createOffroadRepairModule = { 
        private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["hidePolice",1,"HideServices",0,"HideCover",1,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",1,"HideConstruction",1,"BeaconsStart",0] 
        ] call BIS_fnc_initVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createOffroadHMGModule = { 
        private _vehicle = ["I_G_Offroad_01_armed_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["Hide_Shield",0,"Hide_Rail",1,"HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createOffroadATModule = { 
        private _vehicle = ["I_G_Offroad_01_AT_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0] 
        ] call BIS_fnc_initVehicle; 

        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createQuadbikeModule = { 
        private _vehicle = ["I_Quadbike_01_F"] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            _passanger moveinCargo _vehicle; 
            [_driver] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
            [_passanger] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
            private _grp = createGroup [Independent,true]; 
            [_driver,_passanger] joinSilent _grp; 
            _grp selectLeader _driver; 
        }; 
    
        _vehicle 
    };
    
    MAZ_EZM_AAFP_fnc_createStriderModule = { 
        private _vehicle = ["I_MRAP_03_F"] call MAZ_EZM_fnc_createVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _commander = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle; 
            _commander moveincommander _vehicle; 
            _passanger moveincargo _vehicle;
            [_driver] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
            [_commander] call MAZ_EZM_AAFP_fnc_addAAFPBackpack;
            private _grp = createGroup [Independent,true]; 
            [_driver,_commander,_passanger] joinSilent _grp; 
            _grp selectLeader _commander; 
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        }; 
    
        _vehicle 
    };

    MAZ_EZM_AAFP_fnc_createStriderHMGModule = { 
        private _vehicle = ["I_MRAP_03_hmg_F"] call MAZ_EZM_fnc_createVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule;
            private _commander = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle; 
            _gunner moveinGunner _vehicle;
            _commander moveinCommander _vehicle;  
            [_driver] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
            [_gunner] call MAZ_EZM_AAFP_fnc_addAAFPBackpack;
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _gunner; 
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        }; 
    
        _vehicle 
    };

    MAZ_EZM_AAFP_fnc_createStriderGMGModule = { 
        private _vehicle = ["I_MRAP_03_gmg_F"] call MAZ_EZM_fnc_createVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule;
            private _commander = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            _gunner moveinGunner _vehicle; 
            _commander moveinCommander _vehicle;
            [_driver] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
            [_gunner] call MAZ_EZM_AAFP_fnc_addAAFPBackpack;
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _gunner; 
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        }; 
    
        _vehicle 
    };

comment "Compositions";

    MAZ_EZM_AAFP_fnc_createCache1Module = {
        
        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
        
        private _vehicle = createVehicle ["Land_Pallet_F",[24583.7,19262.5,0.00658536],[],0,"CAN_COLLIDE"];
        _vehicle setPosWorld [24583.7,19262.5,3.28107];
        _vehicle setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
            
        _item25 = createVehicle ["Box_IND_Ammo_F",[24583.2,19262.6,0.178298],[],0,"CAN_COLLIDE"];
        _item25 setPosWorld [24583.2,19262.6,3.63531];
        _item25 setVectorDirAndUp [[1,0.000220732,0],[0,0,1]];
        _item25 = [_item25] call BIS_fnc_replaceWithSimpleObject;
        [_item25, _vehicle] call BIS_fnc_attachToRelative;

        _item26 = createVehicle ["Box_IND_Wps_F",[24583.4,19262.2,0.239546],[],0,"CAN_COLLIDE"];
        _item26 setPosWorld [24583.5,19262,3.53942];
        _item26 setVectorDirAndUp [[0,-1,0],[0,0,1]];
        _item26 = [_item26] call BIS_fnc_replaceWithSimpleObject;
        [_item26, _vehicle] call BIS_fnc_attachToRelative;
        
        _item29 = createVehicle ["Box_IND_Wps_F",[24583.5,19262,0.512213],[],0,"CAN_COLLIDE"];
        _item29 setPosWorld [24583.5,19262,3.87547];
        _item29 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
        _item29 = [_item29] call BIS_fnc_replaceWithSimpleObject;
        [_item29, _vehicle] call BIS_fnc_attachToRelative;

        _item30 = createVehicle ["Box_IND_Ammo_F",[24583.9,19262.4,0.269096],[],0,"CAN_COLLIDE"];
        _item30 setPosWorld [24583.9,19262.6,3.64146];
        _item30 setVectorDirAndUp [[0.999995,0.00322254,0],[0,0,1]];
        _item30 = [_item30] call BIS_fnc_replaceWithSimpleObject;
        [_item30, _vehicle] call BIS_fnc_attachToRelative;

        _item43 = createVehicle ["Box_IND_WpsLaunch_F",[24583.7,19263,0.20602],[],0,"CAN_COLLIDE"];
        _item43 setPosWorld [24583.7,19263,3.52767];
        _item43 setVectorDirAndUp [[0,1,0],[0,0,1]];
        _item43 enableSimulationGlobal false;
        [_item43, _vehicle] call BIS_fnc_attachToRelative;
        clearItemCargoGlobal _item43;
        clearWeaponCargoGlobal _item43;
        clearMagazineCargoGlobal _item43;
        clearBackpackCargo _item43;
        
        _simpleObject_6 = createSimpleObject ['a3\weapons_f\launchers\rpg32\pg32v_rocket_item.p3d', [24584.0351563,19262.179688,3.694174]];
        _simpleObject_6 setVectorDirAndUp [[6.25676e-007,1,-5.97802e-005],[0.999998,-7.5623e-007,-0.00218392]];
        [_simpleObject_6, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_7 = createSimpleObject ['a3\weapons_f\launchers\rpg32\pg32v_rocket_item.p3d', [24584.0351563,19262.285156,3.69271]];
        _simpleObject_7 setVectorDirAndUp [[6.25676e-007,1,-5.97802e-005],[0.999998,-7.5623e-007,-0.00218392]];
        [_simpleObject_7, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_8 = createSimpleObject ['a3\weapons_f\launchers\rpg32\pg32v_rocket_item.p3d', [24584.0351563,19262.0722656,3.69467]];
        _simpleObject_8 setVectorDirAndUp [[6.25676e-007,1,-5.97802e-005],[0.999998,-7.5623e-007,-0.00218392]];
        [_simpleObject_8, _vehicle] call BIS_fnc_attachToRelative;
        _simpleObject_9 = createSimpleObject ['a3\weapons_f\launchers\rpg32\tbg32v_rocket_item.p3d', [24584.0546875,19261.962891,3.69224]];
        _simpleObject_9 setVectorDirAndUp [[-1.86053e-007,1,-7.78989e-005],[0.99999,-1.70764e-007,-0.00458049]];
        [_simpleObject_9, _vehicle] call BIS_fnc_attachToRelative;
    
        [_vehicle] call MAZ_EZM_fnc_cacheExplodeOnExplosiveDamage;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
        [_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

        _vehicle setpos _pos;
        
        _vehicle
    };

    MAZ_EZM_AAFP_fnc_createCache2Module = {
        
        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
        
        _vehicle = createVehicle ["Land_Pallet_F",[24587.7,19262.5,0.00657558],[],0,"CAN_COLLIDE"];
        _vehicle setPosWorld [24587.7,19262.5,3.28107];
        _vehicle setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
            
        _item16 = createVehicle ["Weapon_arifle_Mk20_F",[24587.5,19262.2,0.532802],[],0,"CAN_COLLIDE"];
        _item16 setPosWorld [24587.5,19262.2,3.70695];
        _item16 setVectorDirAndUp [[-0.243731,0.969843,0],[0,0,1]];
        [_item16, _vehicle] call BIS_fnc_attachToRelative;
        _item16 setDamage 1;

        _item17 = createVehicle ["Weapon_arifle_Mk20_F",[24587.9,19262,0.536677],[],0,"CAN_COLLIDE"];
        _item17 setPosWorld [24587.9,19262,3.71141];
        _item17 setVectorDirAndUp [[-0.0391472,0.999233,-4.28914e-005],[-0.00129824,-9.37858e-005,-0.999999]];
        [_item17, _vehicle] call BIS_fnc_attachToRelative;
        _item17 setDamage 1;

        _item19 = createVehicle ["Box_IND_Ammo_F",[24587.2,19262.8,0.172966],[],0,"CAN_COLLIDE"];
        _item19 setPosWorld [24587.15,19262.8,3.62947];
        _item19 setVectorDirAndUp [[0,-1,0],[0,0,1]];
        _item19 = [_item19] call BIS_fnc_replaceWithSimpleObject;
        [_item19, _vehicle] call BIS_fnc_attachToRelative;

        _item20 = createVehicle ["Box_IND_Wps_F",[24587.9,19262.6,0.232723],[],0,"CAN_COLLIDE"];
        _item20 setPosWorld [24587.9,19262.7,3.53942];
        _item20 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
        _item20 = [_item20] call BIS_fnc_replaceWithSimpleObject;
        [_item20, _vehicle] call BIS_fnc_attachToRelative;

        _item23 = createVehicle ["Box_IND_Wps_F",[24587.9,19262.7,0.514064],[],0,"CAN_COLLIDE"];
        _item23 setPosWorld [24587.9,19262.7,3.87547];
        _item23 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
        _item23 = [_item23] call BIS_fnc_replaceWithSimpleObject;
        [_item23, _vehicle] call BIS_fnc_attachToRelative;

        _item15 = createVehicle ["Box_IND_WpsSpecial_F",[24587.7,19262.2,0.157008],[],0,"CAN_COLLIDE"];
        _item15 setPosWorld [24587.7,19262.1,3.52];
        _item15 setVectorDirAndUp [[0.00228801,0.899997,0],[0,0,0.9]];
        _item15 = [_item15] call BIS_fnc_replaceWithSimpleObject;
        [_item15, _vehicle] call BIS_fnc_attachToRelative;

        [_vehicle] call MAZ_EZM_fnc_cacheExplodeOnExplosiveDamage;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
        [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
        [_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

        _vehicle setpos _pos;
        
        _vehicle

    };

    MAZ_EZM_AAFP_fnc_createCrashsiteGreyhawkModule = { 
        
        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 

        _pad = createVehicle ["Land_HelipadEmpty_F",[24220.5,18957,0],[],0,"CAN_COLLIDE"];
        _pad setPosWorld [24220.5,18957,3.19];
        _pad setVectorDirAndUp [[0,1,0],[0,0,1]];

        _item130 = createVehicle ["I_UAV_02_dynamicLoadout_F",[24220.6,18956.1,-0.892],[],0,"CAN_COLLIDE"];
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

    MAZ_EZM_AAFP_fnc_createCrashsiteMohawkModule = { 
        
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
                    
                private _pilot = [] call MAZ_EZM_AAFP_fnc_createHeliPilotModule;  
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

    MAZ_EZM_AAFP_fnc_createCrashsiteOrcaModule = { 
        
        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 

        _pad = createVehicle ["Land_HelipadEmpty_F",[24193.6,18921.7,0],[],0,"CAN_COLLIDE"];
        _pad setPosWorld [24193.6,18921.7,3.19];
        _pad setVectorDirAndUp [[0,1,0],[0,0,1]];

        _simpleObject_0 = createSimpleObject ['Land_Wreck_Heli_02_Wreck_04_F', [24195.445313,18920.96875,3.35]];
        _simpleObject_0 setVectorDirAndUp [[0,1,0.03],[0.36,-0.03,0.93]];
        [_simpleObject_0, _pad] call BIS_fnc_attachToRelative;
        [_simpleObject_0,1] remoteExec ['setObjectScale',0,_simpleObject_0];
        [_simpleObject_0,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];
        _simpleObject_1 = createSimpleObject ['Land_Wreck_Heli_02_Wreck_01_F', [24195.132813,18922.294922,1.6]];
        _simpleObject_1 setVectorDirAndUp [[0,1,-0.06],[0.99,0.01,0.1]];
        [_simpleObject_1, _pad] call BIS_fnc_attachToRelative;
        [_simpleObject_1,1] remoteExec ['setObjectScale',0,_simpleObject_1];
        [_simpleObject_1,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];
        _simpleObject_2 = createSimpleObject ['Land_Wreck_Heli_02_Wreck_02_F', [24191.150391,18929.0546875,2.4]];
        _simpleObject_2 setVectorDirAndUp [[-0.77,0.64,0],[-0.24,-0.29,0.93]];
        [_simpleObject_2, _pad] call BIS_fnc_attachToRelative;
        [_simpleObject_2,1] remoteExec ['setObjectScale',0,_simpleObject_2];
        [_simpleObject_2,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];
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

    MAZ_EZM_AAFP_fnc_createDeadSoldierModule = { 

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
        [_KIA] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        [_KIA] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit;  
        

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
    
        private _gun = createVehicle ["Weapon_arifle_Mk20_F",[24603.4,19234.9,0.0110364],[],0,"CAN_COLLIDE"]; 
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

    MAZ_EZM_AAFP_fnc_createDeadSoldierBaggableModule = { 

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
        private _face = selectRandom ["Ioannou","WhiteHead_11","WhiteHead_16","WhiteHead_17","GreekHead_A3_09","WhiteHead_18","Sturrock","GreekHead_A3_14"]; 
        _KIA setface _face; 
        _KIA setPosWorld _unitPos; 
        _KIA setVectorDirAndUp [[0.965509,-0.26037,0],[0,0,1]]; 
        _KIA setDir (random 359);
        [_KIA] call MAZ_EZM_fnc_deleteAttachedWhenKilled; 
        [_KIA] call MAZ_EZM_fnc_deleteAttachedWhenDeleted; 
        [_KIA] call MAZ_EZM_fnc_addObjectToInterface; 
        [_KIA] call MAZ_EZM_fnc_ignoreWhenCleaning; 
        [_KIA] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        [_KIA] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit;  
        

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
    
        private _gun = createVehicle ["Weapon_arifle_Mk20_F",[24603.4,19234.9,0.0110364],[],0,"CAN_COLLIDE"]; 
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
            
    MAZ_EZM_AAFP_fnc_createDarterModule = { 
        private _vehicle = ["I_UAV_01_F"] call MAZ_EZM_fnc_createVehicle;

        private _aiGroup = createGroup [INDEP,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createPelicanMedicalModule = { 
        private _vehicle = ["I_UAV_06_medical_F"] call MAZ_EZM_fnc_createVehicle; 
    
        private _aiGroup = createGroup [Independent,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createPelicanLeafletModule = { 
        private _vehicle = ["I_UAV_06_F"] call MAZ_EZM_fnc_createVehicle; 
    
        private _aiGroup = createGroup [Independent,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader; 

        _vehicle setPylonLoadout [1,"Pylon_1Rnd_Leaflets_Guer_F"];
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createAbabilModule = { 
        private _vehicle = ["I_UAV_02_F"] call MAZ_EZM_fnc_createVehicle; 
    
        private _aiGroup = createGroup [Independent,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader;

        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createAbabilCASModule = { 
        private _vehicle = ["I_UAV_02_CAS_F"] call MAZ_EZM_fnc_createVehicle; 
    
        private _aiGroup = createGroup [Independent,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader;

        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createStomperModule = { 
        private _vehicle = ["I_UGV_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        private _aiGroup = createGroup [Independent,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader;

        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createStomperRCWSModule = { 
        private _vehicle = ["I_UGV_01_rcws_F"] call MAZ_EZM_fnc_createVehicle;
    
        private _aiGroup = createGroup [Independent,true]; 
        private _oldGroup = createVehicleCrew _vehicle; 
        private _leader = leader _oldGroup; 
        { 
            [_x] joinSilent _aiGroup; 
        }forEach units _oldGroup; 
        _aiGroup selectLeader _leader;

        _vehicle 
    }; 

comment "Helicopters";

    MAZ_EZM_AAFP_fnc_createPawneeModule = {
        private _vehicle = ["B_Heli_Light_01_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];

        if(MAZ_EZM_spawnWithCrew) then {
            
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _pilot moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _gunner moveInAny _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    };

    MAZ_EZM_AAFP_fnc_createOrcaUnarmedModule = {
        private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];

        if(MAZ_EZM_spawnWithCrew) then {
            
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _pilot moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _gunner moveInAny _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createOrcaModule = {
        private _vehicle = ["O_Heli_Light_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];
    
        if(MAZ_EZM_spawnWithCrew) then { 
            
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _pilot moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _gunner moveInAny _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createHellcatUnarmedModule = {
        private _vehicle = ["I_Heli_light_03_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,"Green"] call bis_fnc_initVehicle;

        if(MAZ_EZM_spawnWithCrew) then {
            
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _pilot moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _gunner moveInAny _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    };
    
    MAZ_EZM_AAFP_fnc_createHellcatModule = {
        private _vehicle = ["I_Heli_light_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,"Green"] call bis_fnc_initVehicle;

        if(MAZ_EZM_spawnWithCrew) then {
            
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _pilot moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _gunner moveInAny _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createHummingbirdModule = {
        private _vehicle = ["B_Heli_Light_01_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];

        if(MAZ_EZM_spawnWithCrew) then {
            
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _pilot moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _gunner moveInAny _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    };

    MAZ_EZM_AAFP_fnc_createMohawkModule = {
        private _vehicle = ["I_Heli_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _pilot moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            _gunner moveInAny _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

comment "Groups"; 
    
    MAZ_EZM_AAFP_fnc_createSquadModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createAmmoBearerModule', 
            'MAZ_EZM_AAFP_fnc_createCombatMedicModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanModule', 
            'MAZ_EZM_AAFP_fnc_createMarksmanModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanLATModule', 
            'MAZ_EZM_AAFP_fnc_createGrenadierModule', 
            'MAZ_EZM_AAFP_fnc_createAutoriflemanModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 

    MAZ_EZM_AAFP_fnc_createPatrolModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createCombatMedicModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanModule', 
            'MAZ_EZM_AAFP_fnc_createMarksmanModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 
    
    MAZ_EZM_AAFP_fnc_createSentryModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createRiflemanModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 

    MAZ_EZM_AAFP_fnc_createAntiAirTeamModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createAmmoBearerModule', 
            'MAZ_EZM_AAFP_fnc_createMissileSpecAAModule' 
        ]; 
        _unit addItemToBackpack "Titan_AA";
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 
    
    MAZ_EZM_AAFP_fnc_createAntiTankTeamModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createAmmoBearerModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanLATModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 
    
    MAZ_EZM_AAFP_fnc_createMarksmanTeamModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
        private _grp = group _squadLead; 
        _squadLead addPrimaryWeaponItem "optic_SOS"; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createSquadLeadModule' 
        ]; 
        
        _grp setBehaviour "AWARE"; 
    }; 

comment "Groups (Paramilitary)"; 
    
    MAZ_EZM_AAFP_fnc_createSquadPModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createAmmoBearerPModule', 
            'MAZ_EZM_AAFP_fnc_createCombatMedicPModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanPModule', 
            'MAZ_EZM_AAFP_fnc_createMarksmanPModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanLATPModule', 
            'MAZ_EZM_AAFP_fnc_createGrenadierPModule', 
            'MAZ_EZM_AAFP_fnc_createAutoriflemanPModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanPModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 

    MAZ_EZM_AAFP_fnc_createPatrolPModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createCombatMedicPModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanPModule', 
            'MAZ_EZM_AAFP_fnc_createMarksmanPModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanPModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    }; 
    
    MAZ_EZM_AAFP_fnc_createSentryPModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createRiflemanPModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    };
    
    MAZ_EZM_AAFP_fnc_createAntiTankTeamPModule = { 
        private _squadLead = call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
        private _grp = group _squadLead; 
        { 
            private _unit = call (missionNamespace getVariable _x); 
            [_unit] joinSilent _grp; 
        }forEach [ 
            'MAZ_EZM_AAFP_fnc_createAmmoBearerPModule', 
            'MAZ_EZM_AAFP_fnc_createRiflemanLATPModule' 
        ]; 
        _grp setBehaviour "AWARE"; 
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
    };


    
comment "Men"; 

    MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit = { 
        params ["_unit"]; 
        sleep 0.1; 
        private _greekVoice = [ 
            "Male01GRE", 
            "Male02GRE", 
            "Male03GRE", 
            "Male04GRE", 
            "Male05GRE", 
            "Male06GRE" 
        ]; 
        private _AAFPHeads = [ 
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
        [_unit,(selectRandom _AAFPHeads)] remoteExec ['setFace']; 
    
        if((toLower (goggles _unit)) in ["g_balaclava_oli"]) then { 
            removeHeadgear _unit; 
        }; 
    
    }; 
    
    MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit = { 
        params ["_unit"]; 
        private _556Ammo = "30Rnd_556x45_Stanag";
        private _pWeapon = selectRandom [ ["arifle_Mk20C_F", _556Ammo], ["arifle_Mk20_F", _556Ammo] ]; 
                    
        _pWeapon 
    }; 
    
    MAZ_EZM_AAFP_fnc_addAAFPBackpack = { 
        params ["_unit"]; 
        private _randomBackpack = selectRandom ["B_AssaultPack_dgtl"]; 
        _unit addBackpackGlobal _randomBackpack; 
    }; 
    
    MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit = { 
        params ["_unit"]; 
        private _AAFPGoggles = ["","","G_Shades_Black","G_Shades_Red"]; 
        _unit addGoggles (selectRandom _AAFPGoggles); 
    }; 
    
    MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit = { 
        params ["_unit"]; 
        private _AAFPUniforms = ["U_I_CombatUniform_shortsleeve","U_I_CombatUniform"]; 
        private _AAFPVests = ["V_PlateCarrierIA2_dgtl","V_PlateCarrierIA1_dgtl"]; 
        private _AAFPHeadgear = ["H_HelmetIA"]; 
        _unit forceAddUniform (selectRandom _AAFPUniforms); 
        _unit addVest (selectRandom _AAFPVests); 
        _unit addHeadgear (selectRandom _AAFPHeadgear); 
        removeGoggles _unit; 
    }; 

    MAZ_EZM_AAFP_fnc_createAkhanterosModule = { 
        private _unit = [independent,"I_Story_Colonel_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        
        _unit addMagazine "9Rnd_45ACP_Mag";
        _unit addWeapon "hgun_ACPC2_F";

        [_unit] spawn {
            params ["_unit"];
            sleep 1;
            _unit action ['SWITCHWEAPON',_unit,_unit,-1];
        };
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createAmmoBearerModule = { 
        private _unit = [independent,"I_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createAutoriflemanModule = { 
        private _unit = [independent,"I_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _M556Ammo = selectRandom ["200Rnd_556x45_Box_Red_F", "200Rnd_556x45_Box_Tracer_Red_F"]; 
        private _M65Ammo = selectRandom ["200Rnd_65x39_cased_Box_Red", "200Rnd_65x39_cased_Box_Tracer_Red"]; 
        private _pMachineGun = selectRandom [ ["LMG_Mk200_black_F",_M65Ammo] ];  
        [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createCombatMedicModule = { 
        private _unit = [independent,"I_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit addItemToBackpack "Medikit"; 
        for "_i" from 0 to 4 do { 
            _unit addItemToBackpack "FirstAidKit"; 
        }; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createMedicModule = { 
        private _unit = [independent,"I_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
    
        _unit addVest "V_PlateCarrierIA1_dgtl"; 
        removeGoggles _unit; 
        _unit addHeadgear "H_HelmetIA"; 
        _unit addItemToBackpack "Medikit"; 
        for "_i" from 0 to 4 do { 
            _unit addItemToBackpack "FirstAidKit"; 
        }; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createCrewmanModule = { 
        private _unit = [independent,"I_crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        removeHeadgear _unit; 
        removevest _unit; 
        removeheadgear _unit; 
        _unit addHeadgear "H_HelmetCrew_I"; 
        _unit addUniform "U_Tank_green_F";
        _unit addVest "V_TacVest_oli"; 
        _unit addItemToVest "ToolKit"; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit setObjectTextureGlobal [1,"\a3\ui_f_orange\data\cfgunitinsignia\aaf_3rdregiment_ca.paa"];
        _unit 
    };
    
    MAZ_EZM_AAFP_fnc_createEngineerModule = { 
        private _unit = [independent,"I_engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        _unit addItemToVest "ToolKit"; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createSquadLeadModule = { 
        private _unit = [independent,"I_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit;
        private _SquadleadHeadgear = selectRandom ["H_MilCap_dgtl","H_HelmetIA"]; 
        _unit addWeapon "Binocular"; 
        removeheadgear _unit;
        _unit addHeadgear _SquadleadHeadgear; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        removeGoggles _unit;  
    
        _unit   
    }; 
    
    MAZ_EZM_AAFP_fnc_createGrenadierModule = { 
        private _unit = [independent,"I_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _pGrenadier = selectRandom ["arifle_Mk20_GL_F"]; 
        [_unit,[_pGrenadier,["30Rnd_556x45_Stanag",5],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createMarksmanModule = { 
        private _unit = [independent,"I_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _pMarksman = selectRandom [ "srifle_EBR_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_MRCO"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createMissileSpecAAModule = { 
        private _unit = [independent,"I_Soldier_AA_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],["launch_I_Titan_F",["Titan_AA",1]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit addItemToBackpack "Titan_AA";
        _unit 
    };

    MAZ_EZM_AAFP_fnc_createOfficerModule = { 
        private _unit = [independent,"I_officer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        _unit addVest "V_PlateCarrierIA1_dgtl";
        _unit addUniform "U_I_OfficerUniform";
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit addHeadgear "H_Beret_blk";
        
        _unit 
    };  
    
    MAZ_EZM_AAFP_fnc_createRiflemanModule = { 
        private _unit = [independent,"I_soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createRiflemanLATModule = { 
        private _unit = [independent,"I_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _pRPG = selectRandom ["RPG32_F", "RPG32_F"];  
        private _pAT = selectRandom [ ["launch_RPG32_green_F",_pRPG] ]; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createRiflemanHATModule = { 
        private _unit = [independent,"I_Soldier_AT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],["launch_MRAWS_olive_rail_F",["MRAWS_HEAT_F",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createRadiomanModule = { 
        private _unit = [independent,"I_soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        _unit addBackpack "B_RadioBag_01_digi_F"; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnit; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createUnarmedModule = { 
        private _unit = [independent,"I_Soldier_unarmed_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        removeVest _unit; 
        removeHeadgear _unit; 
        [_unit,""] remoteExec ["switchMove"];
        _unit 
    }; 

    MAZ_EZM_AAFP_fnc_createFighterPilotModule = { 
        private _unit = [independent,"I_Fighter_Pilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 

        [_unit] spawn {
            params ["_unit"];
            sleep 1;
            _unit action ['SWITCHWEAPON',_unit,_unit,-1];
        };
    
        _unit 
    };

    MAZ_EZM_AAFP_fnc_createHelicopterCrewModule = { 
        private _unit = [independent,"I_helicrew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
    
        _unit 
    };

    MAZ_EZM_AAFP_fnc_createHelicopterPilotModule = { 
        private _unit = [independent,"I_helipilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit;
    
        _unit 
    };

comment "Men (Paramilitary)";  
    
    MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnitP = { 
        params ["_unit"]; 
        private _556Ammo = "30Rnd_556x45_Stanag"; 
        private _545Ammo = "30Rnd_545x39_Mag_F"; 
        private _762Ammo = "30Rnd_762x39_Mag_F"; 
        private _pWeapon = selectRandom [ ["arifle_AKM_FL_F", _762Ammo], ["arifle_Mk20C_F", _556Ammo], ["arifle_Mk20_F", _556Ammo], ["arifle_AKS_F", _545Ammo] ]; 
                    
        _pWeapon 
    };
    
    MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP = { 
        params ["_unit"]; 
        private _AAFPUniforms = ["U_I_CombatUniform_shortsleeve","U_I_CombatUniform","U_I_C_Soldier_Para_4_F"]; 
        private _AAFPVests = ["V_PlateCarrierIA2_dgtl","V_PlateCarrierIA1_dgtl"]; 
        private _AAFPHeadgear = ["H_HelmetIA","H_Booniehat_dgtl","H_Cap_blk_Raven","H_MilCap_dgtl","H_Bandanna_sgg"]; 
        
        _unit forceAddUniform (selectRandom _AAFPUniforms); 
        _unit addVest (selectRandom _AAFPVests); 
        _unit addHeadgear (selectRandom _AAFPHeadgear); 
        
        private _textureData = switch (uniform _unit) do { 
            case "U_I_C_Soldier_Para_4_F": { 
                private _textureTop = selectRandom ["a3\characters_f_enoch\uniforms\data\i_e_soldier_01_tanktop_co.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_bandit_5_f_1_co.paa"]; 
                private _textureBottom = selectRandom ["a3\characters_f_bootcamp\guerrilla\data\ig_guerrilla_6_1_co.paa","A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa","a3\characters_f_beta\indep\data\ia_soldier_01_clothing_co.paa"]; 
                [_textureTop,_textureBottom]
            };
        }; 

        [_unit,_textureData] spawn {
            params ["_unit","_textureData"];
            sleep 0.1;
            {
                if(_x == "") then {continue};
                _unit setObjectTextureGlobal [_forEachIndex,_x];
            }forEach _textureData;
            _unit setObjectTextureGlobal ["clan","\a3\ui_f_tank\data\cfgunitinsignia\aaf_1stregiment_ca.paa"];
        };
    }; 
    
    MAZ_EZM_AAFP_fnc_createAmmoBearerPModule = { 
        private _unit = [independent,"I_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnitP; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createAutoriflemanPModule = { 
        private _unit = [independent,"I_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _M556Ammo = selectRandom ["200Rnd_556x45_Box_Red_F", "200Rnd_556x45_Box_Tracer_Red_F"]; 
        private _M65Ammo = selectRandom ["200Rnd_65x39_cased_Box_Red", "200Rnd_65x39_cased_Box_Tracer_Red"]; 
        private _pMachineGun = selectRandom [ ["LMG_Mk200_black_F",_M65Ammo] ];  
        [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createCombatMedicPModule = { 
        private _unit = [independent,"I_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnitP; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit addItemToBackpack "Medikit"; 
        for "_i" from 0 to 4 do { 
            _unit addItemToBackpack "FirstAidKit"; 
        }; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createEngineerPModule = { 
        private _unit = [independent,"I_engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        _unit addItemToVest "ToolKit"; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnitP; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createSquadLeadPModule = { 
        private _unit = [independent,"I_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        _unit addWeapon "Binocular";
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnitP; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        removeGoggles _unit;  
    
        _unit   
    }; 
    
    MAZ_EZM_AAFP_fnc_createGrenadierPModule = { 
        private _unit = [independent,"I_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _pGrenadier = selectRandom ["arifle_Mk20_GL_F"]; 
        [_unit,[_pGrenadier,["30Rnd_556x45_Stanag",5],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createMarksmanPModule = { 
        private _unit = [independent,"I_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _pMarksman = selectRandom [ "srifle_DMR_06_olive_F","srifle_DMR_06_hunter_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createRiflemanPModule = { 
        private _unit = [independent,"I_soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnitP; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
    
        _unit 
    }; 
    
    MAZ_EZM_AAFP_fnc_createRiflemanLATPModule = { 
        private _unit = [independent,"I_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
    
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPUniformToUnitP; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        [_unit] call MAZ_EZM_AAFP_fnc_addAAFPBackpack; 
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPGogglesToUnit; 
        private _fAT = selectRandom [ ["launch_RPG32_green_F","RPG32_F"],["launch_RPG7_F","RPG7_F"] ]; 
        private _weaponInfo = [_unit] call MAZ_EZM_AAFP_fnc_getAAFPWeaponToUnitP; 
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[_fAT select 0, [_fAT select 1,3]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
    
        _unit 
    }; 

comment "Men (Special Forces)";

    MAZ_EZM_AAFP_fnc_createDiverModule = { 
        private _unit = [independent,"I_diver_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] spawn MAZ_EZM_AAFP_fnc_addAAFPIdentitiesToUnit; 
        _unit 
    }; 

    MAZ_EZM_AAFP_fnc_createSniperModule = { 
        private _unit = [independent,"I_Sniper_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        private _pMarksman = selectRandom ["srifle_GM6_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_SOS"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit 
    }; 

    MAZ_EZM_AAFP_fnc_createSniperAridModule = { 
        private _unit = [independent,"I_ghillie_ard_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        private _pMarksman = selectRandom ["srifle_GM6_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_SOS"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit 
    };

    MAZ_EZM_AAFP_fnc_createSniperLushModule = { 
        private _unit = [independent,"I_ghillie_lsh_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        private _pMarksman = selectRandom ["srifle_GM6_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_SOS"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit 
    };

    MAZ_EZM_AAFP_fnc_createSniperSemiAridModule = { 
        private _unit = [independent,"I_ghillie_sard_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        private _pMarksman = selectRandom ["srifle_GM6_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_SOS"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit 
    };

    MAZ_EZM_AAFP_fnc_createSpotterModule = { 
        private _unit = [independent,"I_Spotter_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        removeallweapons _unit;
        private _pMarksman = selectRandom ["arifle_Mk20_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_MRCO"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit
    }; 

    MAZ_EZM_AAFP_fnc_createSpotterAridModule = { 
        private _unit = [independent,"I_ghillie_ard_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        private _pMarksman = selectRandom ["arifle_Mk20_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_MRCO"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit 
    }; 

    MAZ_EZM_AAFP_fnc_createSpotterLushModule = { 
        private _unit = [independent,"I_ghillie_lsh_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        private _pMarksman = selectRandom ["arifle_Mk20_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_MRCO"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit 
    }; 

    MAZ_EZM_AAFP_fnc_createSpotterSemiAridModule = { 
        private _unit = [independent,"I_ghillie_sard_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        private _pMarksman = selectRandom ["arifle_Mk20_F"]; 
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],["optic_MRCO"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit 
    }; 

comment "Planes";
    
    MAZ_EZM_AAFP_fnc_createGryphonModule = {
        private _vehicle = ["I_Plane_Fighter_04_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,"CamoGrey"] call bis_fnc_initVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createFighterPilotModule; 
            _pilot moveInDriver _vehicle;

            private _grp = createGroup [Independent,true]; 
            [_pilot] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        };

        _vehicle
    };

    MAZ_EZM_AAFP_fnc_createGryphonCASModule = {
        private _vehicle = ["I_Plane_Fighter_04_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,"CamoGrey"] call bis_fnc_initVehicle;

        _vehicle setPylonLoadout [1,"PylonMissile_Missile_BIM9X_x1"];
        _vehicle setPylonLoadout [2,"PylonMissile_Missile_BIM9X_x1"];
        _vehicle setPylonLoadout [3,"PylonRack_Missile_AGM_02_x1"];
        _vehicle setPylonLoadout [4,"PylonRack_Missile_AGM_02_x1"];
        _vehicle setPylonLoadout [5,"PylonMissile_Bomb_GBU12_x1"];
        _vehicle setPylonLoadout [6,"PylonMissile_Bomb_GBU12_x1"];
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createFighterPilotModule; 
            _pilot moveInDriver _vehicle;
            private _grp = createGroup [Independent,true]; 
            [_pilot] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        };

        _vehicle
    };

    MAZ_EZM_AAFP_fnc_createBuzzardModule = { 
        private _vehicle = ["I_Plane_Fighter_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle allowCrewInImmobile true;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createFighterPilotModule; 
            _pilot moveInDriver _vehicle; 

            private _grp = createGroup [Independent,true]; 
            [_pilot] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    };

comment "Reinforcement"; 

    MAZ_EZM_AAFP_fnc_createReinforcementMohawkModule = { 
        private _vehicle = ["I_Heli_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;
            private _passanger16 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            private _passanger15 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger14 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger13 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanModule; 
            private _passanger12 = [] call MAZ_EZM_AAFP_fnc_createEngineerModule; 
            private _passanger11 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger10 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger9 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
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
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_passanger16,_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent _grp; 
            _grp selectLeader _passanger16; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementHellcatUnarmedModule = { 
        private _vehicle = ["I_Heli_light_03_unarmed_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
            _pilot moveInDriver _vehicle; 
            _gunner moveInAny _vehicle;
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle; 
    
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementHellcatModule = { 
        private _vehicle = ["I_Heli_light_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,"Green"] call bis_fnc_initVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
            _pilot moveInDriver _vehicle; 
            _gunner moveInAny _vehicle;
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle; 
    
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementOrcaModule = { 
        
        private _vehicle = ["O_Heli_Light_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
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
    
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementOrcaUnarmedModule = { 
        
        private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
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
    
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilo,_gunnert] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementHummingbirdModule = { 
        
        private _vehicle = ["B_Heli_Light_01_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];

        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
            _pilot moveInDriver _vehicle; 
            _gunner moveInAny _vehicle;
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle; 

            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementZamakCoveredTransportModule = { 
        private _vehicle = ["I_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger16 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            private _passanger15 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger14 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger13 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanModule; 
            private _passanger12 = [] call MAZ_EZM_AAFP_fnc_createEngineerModule; 
            private _passanger11 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger10 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger9 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
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
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_passanger16,_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent _grp; 
            _grp selectLeader _passanger16; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createReinforcementOffroadCoveredModule = { 
        private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0] 
        ] call BIS_fnc_initVehicle; 

        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createReinforcementOffroadModule = {
        private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
    
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementRhibModule = { 
        
        private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
            _driver moveInDriver _vehicle; 
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle;
            _passanger7 moveInCargo _vehicle;
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createReinforcementVanModule = { 
        private _vehicle = ["I_G_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Black",1],  
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            
            private _passanger10 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanModule; 
            private _passanger9 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
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
            
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8,_passanger9,_passanger10] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
        }; 

        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createReinforcementVanTransportModule = { 
        private _vehicle = ["I_G_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Black",1],  
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            
            private _passanger10 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanModule; 
            private _passanger9 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadModule; 
            
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
            
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8,_passanger9,_passanger10] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        
        }; 
    
        _vehicle 
    }; 

comment "Reinforcements (Paramilitary)";

    MAZ_EZM_AAFP_fnc_createReinforcementMohawkPModule = { 
        private _vehicle = ["I_Heli_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;
            private _passanger16 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            private _passanger15 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger14 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger13 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanPModule; 
            private _passanger12 = [] call MAZ_EZM_AAFP_fnc_createEngineerPModule; 
            private _passanger11 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger10 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger9 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanPModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
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
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_passanger16,_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent _grp; 
            _grp selectLeader _passanger16; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementHellcatUnarmedPModule = { 
        private _vehicle = ["I_Heli_light_03_unarmed_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
            _pilot moveInDriver _vehicle; 
            _gunner moveInAny _vehicle;
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle; 
    
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementHellcatPModule = { 
        private _vehicle = ["I_Heli_light_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,"Green"] call bis_fnc_initVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
            _pilot moveInDriver _vehicle; 
            _gunner moveInAny _vehicle;
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle; 
    
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementOrcaPModule = { 
        
        private _vehicle = ["O_Heli_Light_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
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
    
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementOrcaUnarmedPModule = { 
        
        private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;

            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
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
    
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilo,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementHummingbirdPModule = { 
        
        private _vehicle = ["B_Heli_Light_01_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,[0,"A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"]] remoteExec ['setObjectTexture'];

        if(MAZ_EZM_spawnWithCrew) then { 
            private _pilot = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule; 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createHelicopterPilotModule;
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
            _pilot moveInDriver _vehicle; 
            _gunner moveInAny _vehicle;
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle; 

            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_pilot,_gunner] joinSilent _grp; 
            _grp selectLeader _pilot; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementZamakCoveredTransportPModule = { 
        private _vehicle = ["I_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger16 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            private _passanger15 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger14 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger13 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanPModule; 
            private _passanger12 = [] call MAZ_EZM_AAFP_fnc_createEngineerPModule; 
            private _passanger11 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger10 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger9 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanPModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
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
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_passanger16,_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent _grp; 
            _grp selectLeader _passanger16; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createReinforcementOffroadCoveredPModule = { 
        private _vehicle = ["C_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0] 
        ] call BIS_fnc_initVehicle; 

        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            _driver moveInDriver _vehicle; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createReinforcementOffroadPModule = {
        private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Green",1],  
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
    
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            _driver moveInDriver _vehicle; 
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createReinforcementRhibPModule = { 
        
        private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanPModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
            _driver moveInDriver _vehicle; 
            _passanger1 moveInCargo _vehicle; 
            _passanger2 moveInCargo _vehicle; 
            _passanger3 moveInCargo _vehicle; 
            _passanger4 moveInCargo _vehicle; 
            _passanger5 moveInCargo _vehicle; 
            _passanger6 moveInCargo _vehicle;
            _passanger7 moveInCargo _vehicle;
        
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createReinforcementVanPModule = { 
        private _vehicle = ["I_G_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Black",1],  
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            
            private _passanger10 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanPModule; 
            private _passanger9 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
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
            
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8,_passanger9,_passanger10] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
            
        }; 

        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createReinforcementVanTransportPModule = { 
        private _vehicle = ["I_G_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Black",1],  
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
        
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            
            private _passanger10 = [] call MAZ_EZM_AAFP_fnc_createAutoriflemanPModule; 
            private _passanger9 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger8 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger7 = [] call MAZ_EZM_AAFP_fnc_createRiflemanPModule; 
            private _passanger6 = [] call MAZ_EZM_AAFP_fnc_createAmmoBearerPModule; 
            private _passanger5 = [] call MAZ_EZM_AAFP_fnc_createGrenadierPModule; 
            private _passanger4 = [] call MAZ_EZM_AAFP_fnc_createMarksmanPModule; 
            private _passanger3 = [] call MAZ_EZM_AAFP_fnc_createRiflemanLATPModule; 
            private _passanger2 = [] call MAZ_EZM_AAFP_fnc_createCombatMedicPModule; 
            private _passanger1 = [] call MAZ_EZM_AAFP_fnc_createSquadLeadPModule; 
            
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
            
            private _grp = createGroup [Independent,true]; 
            [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7,_passanger8,_passanger9,_passanger10] joinSilent _grp; 
            _grp selectLeader _passanger1; 
            _grp setBehaviour "AWARE"; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        
        }; 
    
        _vehicle 
    }; 

comment "Submersibles";

    MAZ_EZM_AAFP_fnc_createSDVModule = { 
        private _vehicle = ["I_SDV_01_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createDiverModule; 
            _gunner moveInGunner _vehicle; 
        
            private _driver = [] call MAZ_EZM_AAFP_fnc_createDiverModule; 
            _driver moveInDriver _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _driver; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
comment "Tanks";

    MAZ_EZM_AAFP_fnc_createATNyxModule = { 
        private _vehicle = ["I_LT_01_AT_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_01"],  
            ["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _gunner; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    

    MAZ_EZM_AAFP_fnc_createReconNyxModule = { 
        private _vehicle = ["I_LT_01_scout_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]]; 
        _vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]]; 
        _vehicle removeWeaponTurret ["LMG_coax_ext", [0]]; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_01",1],  
            ["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _commander = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_commander] joinSilent _grp; 
            _grp selectLeader _commander; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_create20mmNyxModule = { 
        private _vehicle = ["I_LT_01_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]]; 
        _vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]]; 
        _vehicle removeWeaponTurret ["LMG_coax_ext", [0]]; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_01",1],  
            ["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner] joinSilent _grp; 
            _grp selectLeader _gunner; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
        
    }; 

    MAZ_EZM_AAFP_fnc_createKumaModule = { 
        private _vehicle = ["I_MBT_03_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        [ 
            _vehicle, 
            ["Indep_01",1],  
            ["showTools",1,"showCamonetHull",1,"showCamonetTurret",1,"showBags",1,"showSLATHull",0]  
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _gunner moveInGunner _vehicle; 

            private _commander = [] call MAZ_EZM_AAFP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
        
            private _grp = createGroup [Independent,true]; 
            [_driver,_gunner,_commander] joinSilent _grp; 
            _grp selectLeader _commander; 
            _grp setBehaviour "AWARE"; 
        }; 
    
        _vehicle 
        
    }; 

comment "Trucks"; 
    
    MAZ_EZM_AAFP_fnc_createZamakAmmoModule = {  
        private _vehicle = ["I_Truck_02_ammo_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createZamakFuelModule = { 
        private _vehicle = ["I_Truck_02_fuel_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createZamakMedicalModule = { 
        private _vehicle = ["I_Truck_02_medical_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createZamakRepairModule = { 
        private _vehicle = ["I_Truck_02_box_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createZamakTransportModule = { 
        private _vehicle = ["I_Truck_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createZamakCoveredTransportModule = { 
        private _vehicle = ["I_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 
    
        _vehicle 
    };
    
comment "Turrets"; 

    MAZ_EZM_AAFP_fnc_createM2HMGModule = { 
        private _vehicle = ["I_G_HMG_02_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,nil,["Hide_Shield",1,"Hide_Rail",1]] call BIS_fnc_initVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createM2HMGRaisedModule = { 
        private _vehicle = ["I_G_HMG_02_high_F"] call MAZ_EZM_fnc_createVehicle;

        [_vehicle,nil,["Hide_Shield",1,"Hide_Rail",1]] call BIS_fnc_initVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createMk6MortarModule = { 
        private _vehicle = ["I_G_Mortar_01_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createAALauncherModule = { 
        private _vehicle = ["I_static_AA_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createATLauncherModule = { 
        private _vehicle = ["I_static_AT_F"] call MAZ_EZM_fnc_createVehicle;
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 

comment "Vans"; 
        
    MAZ_EZM_AAFP_fnc_createVanModule = { 
        private _vehicle = ["I_G_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Black",1],  
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        }; 

        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createVanTransportModule = { 
        private _vehicle = ["I_G_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
        [ 
            _vehicle, 
            ["Black",1],  
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
        ] call BIS_fnc_initVehicle; 
        
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle; 
        };

        _vehicle 
    }; 
    
    MAZ_EZM_AAFP_fnc_createMedicalVanModule = { 
        private _vehicle = ["I_E_Van_02_medevac_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle setPosWorld [24668.3,18863.8,4.84614]; 
        _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]]; 
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_AAFP_fnc_createMedicModule; 
            _driver moveInDriver _vehicle; 
        };

        [ 
            _vehicle, 
            ["FIA3",1],  
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",0,"beacon_rear_hide",0] 
        ] call BIS_fnc_initVehicle; 
    
        _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition); 
        
        _vehicle 
    }; 	

comment "Zeus Interface";
MAZ_EZM_AAFP_fnc_modules = {
    with uiNamespace do {
        comment "AAF+ Modules"; 
				
            private _aafLocalText = localize "$STR_A3_CFGFACTIONCLASSES_IND_F0";
            MAZ_AAFPTree = [MAZ_UnitsTree_INDEP,_aafLocalText] call MAZ_EZM_fnc_findTree;
            private _count = MAZ_UnitsTree_INDEP tvCount [MAZ_AAFPTree]; 
            for "_i" from 0 to (_count - 1) do { 
                MAZ_UnitsTree_INDEP tvDelete [MAZ_AAFPTree,0]; 
            }; 
        
            MAZ_UnitsTree_INDEP tvSetText [[MAZ_AAFPTree], _aafLocalText + "+"]; 
            MAZ_UnitsTree_INDEP tvSetPictureRight [[MAZ_AAFPTree], "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_aaf_ca.paa"]; 
            MAZ_UnitsTree_INDEP tvSetTooltip [[MAZ_AAFPTree], format ["A remastered version of the AAF faction.\n\nAn Official EZM Faction.\nVersion: %1",missionNamespace getVariable "MAZ_EZM_AAFP_Ver"]]; 

        comment "Anti-Air";

            MAZ_AAFPAntiAirTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Anti-Air", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPAntiAirTree, 
                "AWC 302 Nyx (AA)", 
                "AWC 302 Nyx (AA)", 
                "MAZ_EZM_AAFP_fnc_createAANyxModule", 
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
        
        comment "APCs"; 
            
            MAZ_AAFPAPCsTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "APCs", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPAPCsTree, 
                "AFV-4 Gorgon", 
                "AFV-4 Gorgon", 
                "MAZ_EZM_AAFP_fnc_createGorgonModule", 
                "\A3\armor_f_gamma\APC_Wheeled_03\Data\UI\map_APC_Wheeled_03_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPAPCsTree, 
                "AFV-4 Gorgon (20mm)", 
                "20mm Gorgon. Can only be used by AI vs Players", 
                "MAZ_EZM_AAFP_fnc_createGorgon20mmModule", 
                "\A3\armor_f_gamma\APC_Wheeled_03\Data\UI\map_APC_Wheeled_03_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPAPCsTree, 
                "AFV-4 Gorgon (No Turret)", 
                "AFV-4 Gorgon (No Turret)", 
                "MAZ_EZM_AAFP_fnc_createGorgonNoTurretModule", 
                "\A3\armor_f_gamma\APC_Wheeled_03\Data\UI\map_APC_Wheeled_03_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPAPCsTree, 
                "FV-720 Mora", 
                "FV-720 Mora", 
                "MAZ_EZM_AAFP_fnc_createMoraModule", 
                "\a3\armor_f_epb\apc_tracked_03\data\ui\map_apc_tracked_03_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Artillery";

            MAZ_AAFPArtilleryTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Artillery", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPArtilleryTree, 
                "Zamak MRL", 
                "Zamak MRL", 
                "MAZ_EZM_AAFP_fnc_createZamakMRLModule", 
                "a3\soft_f_gamma\truck_02\data\ui\map_truck_02_mrl_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Boats"; 
        
            MAZ_AAFPBoatsTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Boats", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPBoatsTree, 
                "Assault Boat", 
                "Assault Boat", 
                "MAZ_EZM_AAFP_fnc_createAssaultBoatModule", 
                "\A3\boat_F\Boat_Transport_01\data\UI\map_Boat_Transport_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPBoatsTree, 
                "RHIB", 
                "RHIB", 
                "MAZ_EZM_AAFP_fnc_createRhibBoatModule", 
                "\A3\Boat_F_Exp\Boat_Transport_02\Data\UI\Map_Boat_Transport_02_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPBoatsTree, 
                "Speedboat (No Turret)", 
                "Speedboat (No Turret)", 
                "MAZ_EZM_AAFP_fnc_createSpeedBoatModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPBoatsTree, 
                "Speedboat HMG", 
                "Speedboat HMG", 
                "MAZ_EZM_AAFP_fnc_createSpeedBoatHMGModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPBoatsTree, 
                "Speedboat Minigun", 
                "Speedboat Minigun", 
                "MAZ_EZM_AAFP_fnc_createSpeedBoatMinigunModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
        
        comment "Cars"; 
        
            MAZ_AAFPCarsTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Cars", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Offroad", 
                "Offroad", 
                "MAZ_EZM_AAFP_fnc_createOffroadModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Offroad (Covered)", 
                "Offroad (Covered)", 
                "MAZ_EZM_AAFP_fnc_createOffroadCoveredModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
        
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Offroad (Repair)", 
                "Offroad (Repair)", 
                "MAZ_EZM_AAFP_fnc_createOffroadRepairModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Quadbike", 
                "Quadbike", 
                "MAZ_EZM_AAFP_fnc_createQuadbikeModule", 
                "\A3\Soft_F\Quadbike_01\Data\UI\map_Quad_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Strider", 
                "Strider", 
                "MAZ_EZM_AAFP_fnc_createStriderModule", 
                "\a3\soft_f_beta\mrap_03\data\ui\map_mrap_03_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Strider HMG", 
                "Strider HMG", 
                "MAZ_EZM_AAFP_fnc_createStriderHMGModule", 
                "\a3\soft_f_beta\mrap_03\data\ui\map_mrap_03_rcws_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Strider GMG", 
                "Strider GMG", 
                "MAZ_EZM_AAFP_fnc_createStriderGMGModule", 
                "\a3\soft_f_beta\mrap_03\data\ui\map_mrap_03_hmg_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

             [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Van", 
                "Van", 
                "MAZ_EZM_AAFP_fnc_createVanModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Van Transport", 
                "Van Transport", 
                "MAZ_EZM_AAFP_fnc_createVanTransportModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Van Ambulance", 
                "Van Ambulance", 
                "MAZ_EZM_AAFP_fnc_createMedicalVanModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_medevac_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Zamak Ammo", 
                "Zamak Ammo", 
                "MAZ_EZM_AAFP_fnc_createZamakAmmoModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_box_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Zamak Fuel", 
                "Zamak Fuel", 
                "MAZ_EZM_AAFP_fnc_createZamakFuelModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_fuel_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Zamak Medical", 
                "Zamak Medical", 
                "MAZ_EZM_AAFP_fnc_createZamakMedicalModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_medevac_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Zamak Repair", 
                "Zamak Repair", 
                "MAZ_EZM_AAFP_fnc_createZamakRepairModule", 
                "\A3\Soft_F_Beta\Truck_02\Data\UI\Map_Truck_02_repair_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Zamak Transport", 
                "Zamak Transport", 
                "MAZ_EZM_AAFP_fnc_createZamakTransportModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCarsTree, 
                "Zamak Transport (Covered)", 
                "Zamak Transport (Covered)", 
                "MAZ_EZM_AAFP_fnc_createZamakCoveredTransportModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
        comment "Compositions"; 
        
            MAZ_AAFPCompositionsTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Compositions", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_AAFPTree,  
                MAZ_AAFPCompositionsTree,  
                "Cache #1",  
                "Creates a AAF Cache.",  
                "MAZ_EZM_AAFP_fnc_createCache1Module",  
                "\a3\supplies_f_exp\ammoboxes\data\ui\icon_equipment_box_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_AAFPTree,  
                MAZ_AAFPCompositionsTree,  
                "Cache #2",  
                "Creates a AAF Cache.",  
                "MAZ_EZM_AAFP_fnc_createCache2Module",  
                "\a3\supplies_f_exp\ammoboxes\data\ui\icon_equipment_box_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_AAFPTree,  
                MAZ_AAFPCompositionsTree,  
                "Crashsite (Greyhawk)",  
                "Creates a Greyhawk Crashsite.",  
                "MAZ_EZM_AAFP_fnc_createCrashsiteGreyhawkModule",  
                "\A3\Drones_F\Air_F_Gamma\UAV_02\Data\UI\Map_UAV_02_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_AAFPTree,  
                MAZ_AAFPCompositionsTree,  
                "Crashsite (Mohawk)",  
                "Creates a Mohawk Crashsite.",  
                "MAZ_EZM_AAFP_fnc_createCrashsiteMohawkModule",  
                "\a3\air_f_beta\heli_transport_02\data\ui\map_heli_transport_02_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_AAFPTree,  
                MAZ_AAFPCompositionsTree,  
                "Crashsite (Orca)",  
                "Creates a Orca Crashsite.",  
                "MAZ_EZM_AAFP_fnc_createCrashsiteOrcaModule",  
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_AAFPTree,  
                MAZ_AAFPCompositionsTree,  
                "KIA",  
                "KIA",  
                "MAZ_EZM_AAFP_fnc_createDeadSoldierModule",  
                "a3\ui_f_curator\data\cfgmarkers\kia_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_AAFPTree,  
                MAZ_AAFPCompositionsTree,  
                "KIA (Baggable)",  
                "KIA (Baggable)",  
                "MAZ_EZM_AAFP_fnc_createDeadSoldierBaggableModule",  
                "a3\ui_f_curator\data\cfgmarkers\kia_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
        
        comment "Drones"; 
        
            MAZ_AAFPDronesTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Drones", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPDronesTree, 
                "AR-2 Darter", 
                "AR-2 Darter",
                "MAZ_EZM_AAFP_fnc_createDarterModule", 
                "\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UI\Map_UAV_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [
                MAZ_UnitsTree_INDEP,
                MAZ_AAFPTree,
                MAZ_AAFPDronesTree,
                "K40 Ababil-3",
                "K40 Ababil-3",
                "MAZ_EZM_AAFP_fnc_createAbabilModule",
                "\A3\Drones_F\Air_F_Gamma\UAV_02\Data\UI\Map_UAV_02_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_AAFPTree,
                MAZ_AAFPDronesTree,
                "K40 Ababil-3 (CAS)",
                "K40 Ababil-3 (CAS)",
                "MAZ_EZM_AAFP_fnc_createAbabilCASModule",
                "\A3\Drones_F\Air_F_Gamma\UAV_02\Data\UI\Map_UAV_02_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPDronesTree, 
                "Pelican AL-6 (Leaflet)", 
                "Pelican AL-6 (Leaflet)", 
                "MAZ_EZM_AAFP_fnc_createPelicanLeafletModule", 
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPDronesTree, 
                "Pelican AL-6 (Medical)", 
                "Pelican AL-6 (Medical)", 
                "MAZ_EZM_AAFP_fnc_createPelicanMedicalModule", 
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPDronesTree, 
                "UGV Stomper", 
                "UGV Stomper", 
                "MAZ_EZM_AAFP_fnc_createStomperModule", 
                "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPDronesTree, 
                "UGV Stomper RCWS", 
                "UGV Stomper RCWS", 
                "MAZ_EZM_AAFP_fnc_createStomperRCWSModule", 
                "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Groups"; 
        
            MAZ_AAFPSubGroupTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Groups", 
                "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Anti-Air Team", 
                "Anti-Air Team", 
                "MAZ_EZM_AAFP_fnc_createAntiAirTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Anti-Tank Team", 
                "Anti-Tank Team", 
                "MAZ_EZM_AAFP_fnc_createAntiTankTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Marksman Team", 
                "Marksman Team", 
                "MAZ_EZM_AAFP_fnc_createMarksmanTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Patrol", 
                "Patrol", 
                "MAZ_EZM_AAFP_fnc_createPatrolModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Squad", 
                "Squad", 
                "MAZ_EZM_AAFP_fnc_createSquadModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Sentry", 
                "Sentry", 
                "MAZ_EZM_AAFP_fnc_createSentryModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Groups (Paramilitary)"; 
        
            MAZ_AAFPSubGroupTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Groups (Paramilitary)", 
                "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Anti-Tank Team", 
                "Anti-Tank Team", 
                "MAZ_EZM_AAFP_fnc_createAntiTankTeamPModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Patrol", 
                "Patrol", 
                "MAZ_EZM_AAFP_fnc_createPatrolPModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Squad", 
                "Squad", 
                "MAZ_EZM_AAFP_fnc_createSquadPModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubGroupTree, 
                "Sentry", 
                "Sentry", 
                "MAZ_EZM_AAFP_fnc_createSentryPModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Helicopters"; 

            MAZ_AAFPHelicoptersTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Helicopters", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPHelicoptersTree, 
                "AH-9 Pawnee", 
                "AH-9 Pawnee", 
                "MAZ_EZM_AAFP_fnc_createPawneeModule", 
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_armed_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPHelicoptersTree, 
                "CH-49 Mohawk", 
                "CH-49 Mohawk", 
                "MAZ_EZM_AAFP_fnc_createMohawkModule", 
                "\a3\air_f_beta\heli_transport_02\data\ui\map_heli_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPHelicoptersTree, 
                "MH-9 Hummingbird", 
                "MH-9 Hummingbird", 
                "MAZ_EZM_AAFP_fnc_createHummingbirdModule", 
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPHelicoptersTree, 
                "PO-30 Orca", 
                "PO-30 Orca", 
                "MAZ_EZM_AAFP_fnc_createOrcaModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPHelicoptersTree, 
                "PO-30 Orca (Unarmed)", 
                "PO-30 Orca (Unarmed)", 
                "MAZ_EZM_AAFP_fnc_createOrcaUnarmedModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPHelicoptersTree, 
                "WY-55 Hellcat", 
                "WY-55 Hellcat", 
                "MAZ_EZM_AAFP_fnc_createHellcatModule", 
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPHelicoptersTree, 
                "WY-55 Hellcat (Unarmed)", 
                "WY-55 Hellcat (Unarmed)", 
                "MAZ_EZM_AAFP_fnc_createHellcatUnarmedModule", 
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_unarmed_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
        
        
        comment "Men"; 
            
            MAZ_AAFPMenTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Men", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Akhanteros", 
                "Akhanteros", 
                "MAZ_EZM_AAFP_fnc_createAkhanterosModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManOfficer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Ammo Bearer", 
                "Ammo Bearer", 
                "MAZ_EZM_AAFP_fnc_createAmmoBearerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Autorifleman", 
                "Autorifleman", 
                "MAZ_EZM_AAFP_fnc_createAutoriflemanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Combat Lifesaver", 
                "Combat Lifesaver", 
                "MAZ_EZM_AAFP_fnc_createCombatMedicModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Crewman", 
                "Crewman", 
                "MAZ_EZM_AAFP_fnc_createCrewmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Engineer", 
                "Engineer", 
                "MAZ_EZM_AAFP_fnc_createEngineerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Grenadier", 
                "Grenadier", 
                "MAZ_EZM_AAFP_fnc_createGrenadierModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Helicopter Crew", 
                "Helicopter Crew", 
                "MAZ_EZM_AAFP_fnc_createHelicopterCrewModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Helicopter Pilot", 
                "Helicopter Pilot", 
                "MAZ_EZM_AAFP_fnc_createHelicopterPilotModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Marksman", 
                "Marksman", 
                "MAZ_EZM_AAFP_fnc_createMarksmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Missile Specialist (AA)", 
                "Missile Specialist (AA)", 
                "MAZ_EZM_AAFP_fnc_createMissileSpecAAModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Officer", 
                "Officer", 
                "MAZ_EZM_AAFP_fnc_createOfficerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManOfficer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Pilot", 
                "Pilot", 
                "MAZ_EZM_AAFP_fnc_createFighterPilotModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Rifleman", 
                "Rifleman", 
                "MAZ_EZM_AAFP_fnc_createRiflemanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Rifleman (LAT)", 
                "Light Anti-Tank Rifleman", 
                "MAZ_EZM_AAFP_fnc_createRiflemanLATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Rifleman (HAT)", 
                "Heavy Anti-Tank Rifleman", 
                "MAZ_EZM_AAFP_fnc_createRiflemanHATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Radio Operator", 
                "Radio Operator", 
                "MAZ_EZM_AAFP_fnc_createRadiomanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Squad Leader", 
                "Squad Leader", 
                "MAZ_EZM_AAFP_fnc_createSquadLeadModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
        
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenTree, 
                "Survivor", 
                "Survivor", 
                "MAZ_EZM_AAFP_fnc_createUnarmedModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Men (Paramilitary)"; 
            
            MAZ_AAFPMenParaTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Men (Paramilitary)", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Ammo Bearer", 
                "Ammo Bearer", 
                "MAZ_EZM_AAFP_fnc_createAmmoBearerPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Autorifleman", 
                "Autorifleman", 
                "MAZ_EZM_AAFP_fnc_createAutoriflemanPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Combat Lifesaver", 
                "Combat Lifesaver", 
                "MAZ_EZM_AAFP_fnc_createCombatMedicPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Engineer", 
                "Engineer", 
                "MAZ_EZM_AAFP_fnc_createEngineerPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Grenadier", 
                "Grenadier", 
                "MAZ_EZM_AAFP_fnc_createGrenadierPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Marksman", 
                "Marksman", 
                "MAZ_EZM_AAFP_fnc_createMarksmanPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Rifleman", 
                "Rifleman",
                "MAZ_EZM_AAFP_fnc_createRiflemanPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Rifleman (LAT)", 
                "Light Anti-Tank Rifleman", 
                "MAZ_EZM_AAFP_fnc_createRiflemanLATPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenParaTree, 
                "Squad Leader", 
                "Squad Leader", 
                "MAZ_EZM_AAFP_fnc_createSquadLeadPModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Men (Special Forces)";

            MAZ_AAFPMenSpecialTree = [ 
                
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Men (Special Forces)", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Diver", 
                "Diver", 
                "MAZ_EZM_AAFP_fnc_createDiverModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Sniper", 
                "Sniper", 
                "MAZ_EZM_AAFP_fnc_createSniperModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Sniper (Arid)", 
                "Sniper (Arid)", 
                "MAZ_EZM_AAFP_fnc_createSniperAridModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Sniper (Lush)", 
                "Sniper (Lush)", 
                "MAZ_EZM_AAFP_fnc_createSniperLushModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Sniper (Semi-Arid)", 
                "Sniper (Semi-Arid)", 
                "MAZ_EZM_AAFP_fnc_createSniperSemiAridModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Spotter", 
                "Spotter", 
                "MAZ_EZM_AAFP_fnc_createSpotterModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Spotter (Arid)", 
                "Spotter (Arid)", 
                "MAZ_EZM_AAFP_fnc_createSpotterAridModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Spotter (Lush)", 
                "Spotter (Lush)", 
                "MAZ_EZM_AAFP_fnc_createSpotterLushModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPMenSpecialTree, 
                "Spotter (Semi-Arid)", 
                "Spotter (Semi-Arid)", 
                "MAZ_EZM_AAFP_fnc_createSpotterSemiAridModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Planes";

            MAZ_AAFPPlanesTree = [ 
                
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Planes", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPPlanesTree, 
                "A-143 Buzzard", 
                "A-143 Buzzard", 
                "MAZ_EZM_AAFP_fnc_createBuzzardModule", 
                "a3\air_f_gamma\plane_fighter_03\data\ui\map_plane_fighter_03_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPPlanesTree, 
                "A-149 Gryphon", 
                "A-149 Gryphon", 
                "MAZ_EZM_AAFP_fnc_createGryphonModule", 
                "\A3\Air_F_Jets\Plane_Fighter_04\Data\UI\Fighter04_icon_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPPlanesTree, 
                "A-149 Gryphon (CAS)", 
                "A-149 Gryphon (CAS)", 
                "MAZ_EZM_AAFP_fnc_createGryphonCASModule", 
                "\A3\Air_F_Jets\Plane_Fighter_04\Data\UI\Fighter04_icon_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
        
        comment "Reinforcement"; 
        
            MAZ_AAFPReinforcementTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Reinforcement", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "CH-49 Mohawk", 
                "Creates a loaded AAF CH-49 Mohawk", 
                "MAZ_EZM_AAFP_fnc_createReinforcementMohawkModule", 
                "\a3\air_f_beta\heli_transport_02\data\ui\map_heli_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "MH-9 Hummingbird", 
                "Creates a loaded AAF MH-9 Hummingbird", 
                "MAZ_EZM_AAFP_fnc_createReinforcementHummingbirdModule", 
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Offroad", 
                "Creates a loaded AAF Offroad", 
                "MAZ_EZM_AAFP_fnc_createReinforcementOffroadModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Offroad (Covered)", 
                "Creates a loaded AAF Offroad (Covered)", 
                "MAZ_EZM_AAFP_fnc_createReinforcementOffroadCoveredModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "PO-30 Orca (Unarmed)", 
                "Creates a loaded AAF PO-30 Orca (Unarmed)", 
                "MAZ_EZM_AAFP_fnc_createReinforcementOrcaUnarmedModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "PO-30 Orca", 
                "Creates a loaded AAF PO-30 Orca", 
                "MAZ_EZM_AAFP_fnc_createReinforcementOrcaModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "RHIB", 
                "Creates a loaded AAF RHIB", 
                "MAZ_EZM_AAFP_fnc_createReinforcementRhibModule", 
                "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Transport Van", 
                "Creates a loaded AAF Transport Van", 
                "MAZ_EZM_AAFP_fnc_createReinforcementVanTransportModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Van", 
                "Creates a loaded AAF Van", 
                "MAZ_EZM_AAFP_fnc_createReinforcementVanModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "WY-55 Hellcat", 
                "Creates a loaded AAF WY-55 Hellcat", 
                "MAZ_EZM_AAFP_fnc_createReinforcementHellcatModule", 
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "WY-55 Hellcat (Unarmed)", 
                "Creates a loaded AAF WY-55 Hellcat (Unarmed)", 
                "MAZ_EZM_AAFP_fnc_createReinforcementHellcatUnarmedModule", 
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_unarmed_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Zamak", 
                "Creates a loaded AAF Zamak", 
                "MAZ_EZM_AAFP_fnc_createReinforcementZamakCoveredTransportModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Reinforcement (Paramilitary)"; 
        
            MAZ_AAFPReinforcementTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Reinforcement (Paramilitary)", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "CH-49 Mohawk", 
                "Creates a loaded AAF CH-49 Mohawk", 
                "MAZ_EZM_AAFP_fnc_createReinforcementMohawkPModule", 
                "\a3\air_f_beta\heli_transport_02\data\ui\map_heli_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "MH-9 Hummingbird", 
                "Creates a loaded AAF MH-9 Hummingbird", 
                "MAZ_EZM_AAFP_fnc_createReinforcementHummingbirdPModule", 
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Offroad", 
                "Creates a loaded AAF Offroad", 
                "MAZ_EZM_AAFP_fnc_createReinforcementOffroadPModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Offroad (Covered)", 
                "Creates a loaded AAF Offroad (Covered)", 
                "MAZ_EZM_AAFP_fnc_createReinforcementOffroadCoveredPModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "PO-30 Orca (Unarmed)", 
                "Creates a loaded AAF PO-30 Orca (Unarmed)", 
                "MAZ_EZM_AAFP_fnc_createReinforcementOrcaUnarmedPModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "PO-30 Orca", 
                "Creates a loaded AAF PO-30 Orca", 
                "MAZ_EZM_AAFP_fnc_createReinforcementOrcaPModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "RHIB", 
                "Creates a loaded AAF RHIB", 
                "MAZ_EZM_AAFP_fnc_createReinforcementRhibPModule", 
                "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Transport Van", 
                "Creates a loaded AAF Transport Van", 
                "MAZ_EZM_AAFP_fnc_createReinforcementVanTransportPModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Van", 
                "Creates a loaded AAF Van", 
                "MAZ_EZM_AAFP_fnc_createReinforcementVanPModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "WY-55 Hellcat", 
                "Creates a loaded AAF WY-55 Hellcat", 
                "MAZ_EZM_AAFP_fnc_createReinforcementHellcatPModule", 
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "WY-55 Hellcat (Unarmed)", 
                "Creates a loaded AAF WY-55 Hellcat (Unarmed)", 
                "MAZ_EZM_AAFP_fnc_createReinforcementHellcatUnarmedPModule", 
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_unarmed_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPReinforcementTree, 
                "Zamak", 
                "Creates a loaded AAF Zamak", 
                "MAZ_EZM_AAFP_fnc_createReinforcementZamakCoveredTransportPModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Submersibles"; 
        
            MAZ_AAFPSubmersibleTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Submersibles", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPSubmersibleTree, 
                "SDV", 
                "SDV", 
                "MAZ_EZM_AAFP_fnc_createSDVModule", 
                "\a3\boat_f_beta\sdv_01\data\ui\map_sdv_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
        
        comment "Tanks"; 
            
            MAZ_AAFPTankTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Tanks", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTankTree, 
                "AWC 301 Nyx (AT)", 
                "AWC 301 Nyx (AT)", 
                "MAZ_EZM_AAFP_fnc_createATNyxModule", 
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTankTree, 
                "AWC 304 Nyx (Autocannon)", 
                "AWC 304 Nyx (Autocannon)", 
                "MAZ_EZM_AAFP_fnc_create20mmNyxModule", 
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTankTree, 
                "AWC 303 Nyx (Recon)", 
                "AWC 303 Nyx (Recon)", 
                "MAZ_EZM_AAFP_fnc_createReconNyxModule", 
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTankTree, 
                "MBT-52 Kuma", 
                "MBT-52 Kuma", 
                "MAZ_EZM_AAFP_fnc_createKumaModule", 
                "\a3\armor_f_epb\mbt_03\data\ui\map_mbt_03_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
        
        
        
        comment "Turrets"; 
        
            MAZ_AAFPTurretTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Turrets", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTurretTree, 
                "M2 HMG", 
                "M2 HMG", 
                "MAZ_EZM_AAFP_fnc_createM2HMGModule", 
                "\a3\static_f\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTurretTree, 
                "M2 HMG (Raised)", 
                "M2 HMG (Raised)", 
                "MAZ_EZM_AAFP_fnc_createM2HMGRaisedModule", 
                "a3\static_f_oldman\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTurretTree, 
                "Mk6 Mortar", 
                "Mk6 Mortar", 
                "MAZ_EZM_AAFP_fnc_createMk6MortarModule", 
                "\A3\Static_f\Mortar_01\data\UI\map_Mortar_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTurretTree, 
                "Static AA Launcher", 
                "Static AA Launcher", 
                "MAZ_EZM_AAFP_fnc_createAALauncherModule", 
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AA_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTurretTree, 
                "Static AT Launcher", 
                "Static AT Launcher", 
                "MAZ_EZM_AAFP_fnc_createATLauncherModule", 
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AT_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
    
    };
};

["MAZ_EZM_AAFP_fnc_modules"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;