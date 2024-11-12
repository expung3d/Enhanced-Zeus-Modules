if(isNil "MAZ_EZM_Version") exitWith {
    systemChat "Enhanced Zeus Modules is not running!";
    playSound "addItemFailed";
};

if(isNil "MAZ_EZM_fnc_addNewFactionToDynamicFactions") exitWith {
    ["Your version of EZM is incompatible with dynamic factions. Please use the latest version!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

if(!isNil "MAZ_EZM_AAFP") exitWith {
    ["AAF+ is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_AAFP_Ver = "1.0";
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

    MAZ_EZM_FIAP_fnc_createGorgonNoTurretModule = { 
        private _vehicle = ["I_APC_Wheeled_03_cannon_F"] call MAZ_EZM_fnc_createVehicle;
        _vehicle disableTIEquipment true; 
        _vehicle allowCrewInImmobile true;
        _vehicle animate ["HideTurret",2]; 
        _vehicle lockTurret [[0], true]; 
        private _camo = selectRandom ["Guerilla_01","Guerilla_02","Guerilla_03"]; 
        [ 
            _vehicle, 
            [_camo,1],  
            ["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",0] 
        ] call BIS_fnc_initVehicle; 
                    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _driver moveInDriver _vehicle; 
        
            private _commander = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule; 
            _commander moveInCommander _vehicle; 
        
            private _grp = createGroup [east,true]; 
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
        sleep 0.5; 
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
        _unit setObjectTextureGlobal [1,"\a3\ui_f_tank\data\cfgunitinsignia\aaf_1stregiment_ca.paa"];
        _unit addVest (selectRandom _AAFPVests); 
        _unit addHeadgear (selectRandom _AAFPHeadgear); 
        removeGoggles _unit; 
        switch (uniform _unit) do { 
            case "U_I_C_Soldier_Para_4_F": { 
                private _textureTop = selectRandom ["a3\characters_f_enoch\uniforms\data\i_e_soldier_01_tanktop_co.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_bandit_5_f_1_co.paa"]; 
                private _textureBottom = selectRandom ["a3\characters_f_bootcamp\guerrilla\data\ig_guerrilla_6_1_co.paa","A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa","a3\characters_f_beta\indep\data\ia_soldier_01_clothing_co.paa"]; 
                [[_unit,_textureTop,_textureBottom],{ 
                    params ["_unit","_top","_bottom"]; 
                    _unit setObjectTexture [0, _top]; 
                    _unit setObjectTexture [1, _bottom]; 
                }] remoteExec ['spawn',0,_unit]; 
            };
        }; 
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
        
        switch (uniform _unit) do { 
            case "U_I_C_Soldier_Para_4_F": { 
                private _textureTop = selectRandom ["a3\characters_f_enoch\uniforms\data\i_e_soldier_01_tanktop_co.paa"]; 
                private _textureBottom = selectRandom ["a3\characters_f_beta\indep\data\ia_soldier_01_clothing_co.paa"]; 
                [[_unit,_textureTop,_textureBottom],{ 
                    params ["_unit","_top","_bottom"]; 
                    _unit setObjectTexture [0, _top]; 
                    _unit setObjectTexture [1, _bottom]; 
                }] remoteExec ['spawn',0,_unit]; 
            };
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
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
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
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
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
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
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
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
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
    
        if(MAZ_EZM_spawnWithCrew) then { 
            private _gunner = [] call MAZ_EZM_AAFP_fnc_createRiflemanModule; 
            _gunner moveInGunner _vehicle; 
        }; 
    
        _vehicle 
    }; 

    MAZ_EZM_AAFP_fnc_createM2HMGRaisedModule = { 
        private _vehicle = ["I_G_HMG_02_high_F"] call MAZ_EZM_fnc_createVehicle;
    
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
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
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
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1] 
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
                "Cache", 
                "MAZ_EZM_AAFP_fnc_createCache1Module", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPCompositionsTree, 
                "Cache #2", 
                "Cache", 
                "MAZ_EZM_AAFP_fnc_createCache2Module", 
                "" 
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
                "Squad Leader", 
                "Squad Leader", 
                "MAZ_EZM_AAFP_fnc_createSquadLeadModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa" 
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
                "MAZ_EZM_AAFP_fnc_createGryphonCASModule", 
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
        
        comment "Trucks"; 
        
            MAZ_AAFPTrucksTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Trucks", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTrucksTree, 
                "Zamak Ammo", 
                "Zamak Ammo", 
                "MAZ_EZM_AAFP_fnc_createZamakAmmoModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_box_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTrucksTree, 
                "Zamak Fuel", 
                "Zamak Fuel", 
                "MAZ_EZM_AAFP_fnc_createZamakFuelModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_fuel_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTrucksTree, 
                "Zamak Medical", 
                "Zamak Medical", 
                "MAZ_EZM_AAFP_fnc_createZamakMedicalModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_medevac_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTrucksTree, 
                "Zamak Repair", 
                "Zamak Repair", 
                "MAZ_EZM_AAFP_fnc_createZamakRepairModule", 
                "\A3\Soft_F_Beta\Truck_02\Data\UI\Map_Truck_02_repair_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTrucksTree, 
                "Zamak Transport", 
                "Zamak Transport", 
                "MAZ_EZM_AAFP_fnc_createZamakTransportModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPTrucksTree, 
                "Zamak Transport (Covered)", 
                "Zamak Transport (Covered)", 
                "MAZ_EZM_AAFP_fnc_createZamakCoveredTransportModule", 
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa" 
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
            
        comment "Vans"; 
        
            MAZ_AAFPVansTree = [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                "Vans", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPVansTree, 
                "Van", 
                "Van", 
                "MAZ_EZM_AAFP_fnc_createVanModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPVansTree, 
                "Transport Van", 
                "Transport Van", 
                "MAZ_EZM_AAFP_fnc_createVanTransportModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_AAFPTree, 
                MAZ_AAFPVansTree, 
                "Medical Van", 
                "Medical Van", 
                "MAZ_EZM_AAFP_fnc_createMedicalVanModule", 
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_medevac_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
    };
};

["MAZ_EZM_AAFP_fnc_modules"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;