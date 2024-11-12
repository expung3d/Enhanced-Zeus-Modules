if(isNil "MAZ_EZM_Version") exitWith {
    systemChat "Enhanced Zeus Modules is not running!";
    playSound "addItemFailed";
};

if(isNil "MAZ_EZM_fnc_addNewFactionToDynamicFactions") exitWith {
    ["Your version of EZM is incompatible with dynamic factions. Please use the latest version!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

if(!isNil "MAZ_EZM_LDFP") exitWith {
    ["LDF+ is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_LDFP_Ver = "1.0";
MAZ_EZM_LDFP = true;

comment "Anti-Air"; 

    MAZ_EZM_LDFP_fnc_createAANyxModule = {  
        private _vehicle = ["I_LT_01_AA_F"] call MAZ_EZM_fnc_createVehicle; 
        _vehicle disableTIEquipment true;  
        _vehicle allowCrewInImmobile true; 
        [  
            _vehicle,  
            ["Indep_Olive",1],   
            ["showTools",1,"showCamonetHull",1,"showBags",0,"showSLATHull",0]  
        ] call BIS_fnc_initVehicle; 

        _vehicle setObjectTextureGlobal [2,'a3\armor_f_enoch\apc_tracked_03\data\camonet_eaf_green_co.paa'];

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _driver moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _gunner moveInGunner _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_gunner] joinSilent _grp;  
            _grp selectLeader _gunner;  
            _grp setBehaviour "AWARE";  
        };  

        _vehicle  
    };  
comment "APCs";  
    MAZ_EZM_LDFP_fnc_createOdyniecModule = {  
        private _vehicle = ["I_E_APC_tracked_03_cannon_F"] call MAZ_EZM_fnc_createVehicle; 
        _vehicle disableTIEquipment true;  
        _vehicle allowCrewInImmobile true; 
        [  
            _vehicle,  
            ["Guerilla_03",1], 
            ["showBags",0,"showBags2",1,"showCamonetHull",1,"showCamonetTurret",1,"showTools",1,"showSLATHull",0,"showSLATTurret",0]  
        ] call BIS_fnc_initVehicle;  
            
        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _driver moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _gunner moveInGunner _vehicle;  
            
            private _commander = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _commander moveInCommander _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_gunner,_commander] joinSilent _grp;  
            _grp selectLeader _commander;  
            _grp setBehaviour "AWARE";  
        };  

        _vehicle  
    };  
comment "Artillery"; 

    MAZ_EZM_LDFP_fnc_createZamakMRLModule = {  
        private _vehicle = ["I_E_Truck_02_MRL_F"] call MAZ_EZM_fnc_createVehicle; 
        _vehicle disableTIEquipment true;  
        
        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _gunner moveIngunner _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_gunner] joinSilent _grp;  
            _grp selectLeader _gunner;  
            _grp setBehaviour "AWARE";  
        };  

        _vehicle  
    };  
comment "Cars";  

    MAZ_EZM_LDFP_fnc_createOffroadModule = {  
            private _vehicle = ["I_E_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle; 

            private _carcamo = [  
                "Green",  
                "AEF"
            ]; 

            [  
                _vehicle,  
                [(selectRandom _carcamo),1],   
                ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]  
            ] call BIS_fnc_initVehicle;   
                
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
                _driver moveInDriver _vehicle;  
            };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createOffroadCommsModule = {  
        private _vehicle = ["I_E_Offroad_01_comms_F"] call MAZ_EZM_fnc_createVehicle;   
            
        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
        };  

        MAZ_EZM_LDFP_fnc_createOffroadCoveredModule = {  
        private _vehicle = ["I_E_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle; 

        private _carcamo = [  
            "Green",  
            "AEF"  
        ]; 

        [  
            _vehicle,  
            [(selectRandom _carcamo),1],   
            ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0]  
        ] call BIS_fnc_initVehicle;  

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createOffroadRepairModule = {  
        private _vehicle = ["I_E_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle; 

        private _carcamo = [  
            "Green",  
            "AEF"  
        ]; 

        [  
            _vehicle,  
            [(selectRandom _carcamo),1],   
            ["hidePolice",1,"HideServices",0,"HideCover",1,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",0,"HideSpotlight",0,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",1,"HideConstruction",1,"BeaconsStart",0]  
        ] call BIS_fnc_initVehicle;  
            
        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createOffroadHMGModule = {  
        private _vehicle = ["I_G_Offroad_01_armed_F"] call MAZ_EZM_fnc_createVehicle;
        [_vehicle,"Green"] call bis_fnc_initVehicle;


        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            _driver moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            _gunner moveInGunner _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_gunner] joinSilent _grp;  
            _grp selectLeader _driver;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createOffroadATModule = {  
        private _vehicle = ["I_G_Offroad_01_AT_F"] call MAZ_EZM_fnc_createVehicle; 
        
        [_vehicle,"Green"] call bis_fnc_initVehicle;

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            _driver moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            _gunner moveInGunner _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_gunner] joinSilent _grp;  
            _grp selectLeader _driver;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createQuadbikeModule = {  
        private _vehicle = ["I_E_Quadbike_01_F"] call MAZ_EZM_fnc_createVehicle; 
            
        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
            _passanger moveinCargo _vehicle;  
            [_driver] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
            [_passanger] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
            private _grp = createGroup [Independent,true];  
            [_driver,_passanger] joinSilent _grp;  
            _grp selectLeader _driver;  
        };  

        _vehicle  
    };
comment "Compositions"; 

    MAZ_EZM_LDFP_fnc_createCache1Module = { 
        
        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 
            
        private _vehicle = createVehicle ["Land_Pallet_F",[24583.7,19262.5,0.00658536],[],0,"CAN_COLLIDE"]; 
        _vehicle setPosWorld [24583.7,19262.5,3.28107]; 
        _vehicle setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]]; 
            
        _item25 = createVehicle ["Box_EAF_Ammo_F",[24583.2,19262.6,0.178298],[],0,"CAN_COLLIDE"]; 
        _item25 setPosWorld [24583.2,19262.6,3.63531]; 
        _item25 setVectorDirAndUp [[1,0.000220732,0],[0,0,1]]; 
        _item25 = [_item25] call BIS_fnc_replaceWithSimpleObject; 
        [_item25, _vehicle] call BIS_fnc_attachToRelative; 

        _item26 = createVehicle ["Box_EAF_Wps_F",[24583.4,19262.2,0.239546],[],0,"CAN_COLLIDE"]; 
        _item26 setPosWorld [24583.5,19262,3.53942]; 
        _item26 setVectorDirAndUp [[0,-1,0],[0,0,1]]; 
        _item26 = [_item26] call BIS_fnc_replaceWithSimpleObject; 
        [_item26, _vehicle] call BIS_fnc_attachToRelative; 
            
        _item29 = createVehicle ["Box_EAF_Wps_F",[24583.5,19262,0.512213],[],0,"CAN_COLLIDE"]; 
        _item29 setPosWorld [24583.5,19262,3.87547]; 
        _item29 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]]; 
        _item29 = [_item29] call BIS_fnc_replaceWithSimpleObject; 
        [_item29, _vehicle] call BIS_fnc_attachToRelative; 

        _item30 = createVehicle ["Box_EAF_Ammo_F",[24583.9,19262.4,0.269096],[],0,"CAN_COLLIDE"]; 
        _item30 setPosWorld [24583.9,19262.6,3.64146]; 
        _item30 setVectorDirAndUp [[0.999995,0.00322254,0],[0,0,1]]; 
        _item30 = [_item30] call BIS_fnc_replaceWithSimpleObject; 
        [_item30, _vehicle] call BIS_fnc_attachToRelative; 

        _item43 = createVehicle ["Box_EAF_WpsLaunch_F",[24583.7,19263,0.20602],[],0,"CAN_COLLIDE"]; 
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

    MAZ_EZM_LDFP_fnc_createCache2Module = { 
            
        private _pos = [true] call MAZ_EZM_fnc_getScreenPosition; 
            
        _vehicle = createVehicle ["Land_Pallet_F",[24587.7,19262.5,0.00657558],[],0,"CAN_COLLIDE"]; 
        _vehicle setPosWorld [24587.7,19262.5,3.28107]; 
        _vehicle setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]]; 

        _item19 = createVehicle ["Box_EAF_Ammo_F",[24587.2,19262.8,0.172966],[],0,"CAN_COLLIDE"]; 
        _item19 setPosWorld [24587.15,19262.8,3.62947]; 
        _item19 setVectorDirAndUp [[0,-1,0],[0,0,1]]; 
        _item19 = [_item19] call BIS_fnc_replaceWithSimpleObject; 
        [_item19, _vehicle] call BIS_fnc_attachToRelative; 

        _item20 = createVehicle ["Box_EAF_Wps_F",[24587.9,19262.6,0.232723],[],0,"CAN_COLLIDE"]; 
        _item20 setPosWorld [24587.9,19262.7,3.53942]; 
        _item20 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]]; 
        _item20 = [_item20] call BIS_fnc_replaceWithSimpleObject; 
        [_item20, _vehicle] call BIS_fnc_attachToRelative; 

        _item23 = createVehicle ["Box_EAF_Wps_F",[24587.9,19262.7,0.514064],[],0,"CAN_COLLIDE"]; 
        _item23 setPosWorld [24587.9,19262.7,3.87547]; 
        _item23 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]]; 
        _item23 = [_item23] call BIS_fnc_replaceWithSimpleObject; 
        [_item23, _vehicle] call BIS_fnc_attachToRelative; 

        _item15 = createVehicle ["Box_EAF_WpsSpecial_F",[24587.7,19262.2,0.157008],[],0,"CAN_COLLIDE"]; 
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
            
    MAZ_EZM_LDFP_fnc_createDarterModule = {  
        private _vehicle = ["I_E_UAV_01_F"] call MAZ_EZM_fnc_createVehicle; 

        private _aiGroup = createGroup [INDEP,true];  
        private _oldGroup = createVehicleCrew _vehicle;  
        private _leader = leader _oldGroup;  
        {  
            [_x] joinSilent _aiGroup;  
        }forEach units _oldGroup;  
        _aiGroup selectLeader _leader;  

        _vehicle  
    }; 

    MAZ_EZM_LDFP_fnc_createFPVAPModule = {  
        FPVDrone = ["I_E_UAV_01_F"] call MAZ_EZM_fnc_createVehicle; 
        [FPVDrone] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
        [FPVDrone] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
        FPVDrone setPosWorld [4062.44,10239.7,68.3105]; 
        FPVDrone setVectorDirAndUp [[0.73202,0.681283,0],[0,0,1]];
        FPVDrone disableTIEquipment true;  

        FPVDrone addEventHandler ["killed", {

            _pos = FPVDrone; 

            _explosion = createVehicle ['R_PG7_F', _pos, [], 0, 'CAN_COLLIDE'];

            _explosion setDamage 1; 
        
        }]; 

        private _RPG = createSimpleObject ['a3\weapons_f_tank\ammo\rocket_spg9_item.p3d', [4062.449219,10239.68457,68.320297]];
        _RPG setVectorDirAndUp [[0.665126,-0.746731,0],[0,0,1]];
        [_RPG, FPVDrone] call BIS_fnc_attachToRelative; 
        [_RPG, 1.1] remoteExec ['setObjectScale', 0, _RPG];

        private _pole = createSimpleObject ['a3\structures_f\walls\wall_tin_pole.p3d', [4062.705078,10239.911133,68.366531]];
        _pole setVectorDirAndUp [[-0.198106,0.225286,-5.88441e-006],[0.225286,0.198106,0.000404536]];
        [_pole, FPVDrone] call BIS_fnc_attachToRelative;
        [_pole, 0.3] remoteExec ['setObjectScale', 0, _pole];  

        private _aiGroup = createGroup [INDEP,true];  
        private _oldGroup = createVehicleCrew FPVDrone;  
        private _leader = leader _oldGroup;  
        {  
            [_x] joinSilent _aiGroup;  
        }forEach units _oldGroup;  
        _aiGroup selectLeader _leader;  

        FPVDrone setpos ([true] call MAZ_EZM_fnc_getScreenPosition);

        FPVDrone  
    }; 

    MAZ_EZM_LDFP_fnc_createPelicanModule = {  
        private _vehicle = ["I_E_UAV_06_F"] call MAZ_EZM_fnc_createVehicle;  

        private _aiGroup = createGroup [Independent,true];  
        private _oldGroup = createVehicleCrew _vehicle;  
        private _leader = leader _oldGroup;  
        {  
            [_x] joinSilent _aiGroup;  
        }forEach units _oldGroup;  
        _aiGroup selectLeader _leader;  

        _vehicle  
    }; 

    MAZ_EZM_LDFP_fnc_createPelicanGrenadeModule = { 
            private _vehicle = ["C_IDAP_UAV_06_antimine_F"] call MAZ_EZM_fnc_createVehicle;
        
            private _aiGroup = createGroup [Independent,true]; 
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
    
    MAZ_EZM_LDFP_fnc_createPelicanMedicalModule = {  
        private _vehicle = ["I_E_UAV_06_medical_F"] call MAZ_EZM_fnc_createVehicle;  

        private _aiGroup = createGroup [Independent,true];  
        private _oldGroup = createVehicleCrew _vehicle;  
        private _leader = leader _oldGroup;  
        {  
            [_x] joinSilent _aiGroup;  
        }forEach units _oldGroup;  
        _aiGroup selectLeader _leader;  

        _vehicle  
    };   

    MAZ_EZM_LDFP_fnc_createAbabilModule = {  
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

    MAZ_EZM_LDFP_fnc_createAbabilCASModule = {  
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

    MAZ_EZM_LDFP_fnc_createStomperModule = {  
        private _vehicle = ["I_E_UGV_01_F"] call MAZ_EZM_fnc_createVehicle; 

        private _aiGroup = createGroup [Independent,true];  
        private _oldGroup = createVehicleCrew _vehicle;  
        private _leader = leader _oldGroup;  
        {  
            [_x] joinSilent _aiGroup;  
        }forEach units _oldGroup;  
        _aiGroup selectLeader _leader; 

        _vehicle  
        };  

        MAZ_EZM_LDFP_fnc_createStomperRCWSModule = {  
        private _vehicle = ["I_E_UGV_01_rcws_F"] call MAZ_EZM_fnc_createVehicle; 

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

    MAZ_EZM_LDFP_fnc_createPawneeModule = { 
    
        private _vehicle = ["B_Heli_Light_01_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 

        [_vehicle,[0,"a3\props_f_enoch\military\decontamination\data\containmentarea_olive_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 

        if(MAZ_EZM_spawnWithCrew) then { 
                
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            _pilot moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            _gunner moveInAny _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_pilot,_gunner] joinSilent _grp;  
            _grp selectLeader _pilot;  
            _grp setBehaviour "AWARE";  
        };  
                
        _vehicle  
    }; 

    MAZ_EZM_LDFP_fnc_createCzaplaUnarmedModule = { 
        private _vehicle = ["I_E_Heli_light_03_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then { 
                
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            _pilot moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            _gunner moveInAny _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_pilot,_gunner] joinSilent _grp;  
            _grp selectLeader _pilot;  
            _grp setBehaviour "AWARE";  
        };  
        
        _vehicle  
    }; 
        
    MAZ_EZM_LDFP_fnc_createCzaplaModule = { 
        private _vehicle = ["I_E_Heli_light_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then { 
                
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            _pilot moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            _gunner moveInAny _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_pilot,_gunner] joinSilent _grp;  
            _grp selectLeader _pilot;  
            _grp setBehaviour "AWARE";  
        };  
        
        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createHummingbirdModule = { 
        private _vehicle = ["B_Heli_Light_01_F"] call MAZ_EZM_fnc_createVehicle; 

        [_vehicle,[0,"a3\props_f_enoch\military\decontamination\data\containmentarea_olive_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 

            if(MAZ_EZM_spawnWithCrew) then { 
                    
                private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
                _pilot moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
                _gunner moveInAny _vehicle;  
                
                private _grp = createGroup [Independent,true];  
                [_pilot,_gunner] joinSilent _grp;  
                _grp selectLeader _pilot;  
                _grp setBehaviour "AWARE";  
            };  
                
        _vehicle  
    };
comment "Groups";  

    MAZ_EZM_LDFP_fnc_createSquadModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createAmmoBearerModule',  
            'MAZ_EZM_LDFP_fnc_createCombatMedicModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanModule',  
            'MAZ_EZM_LDFP_fnc_createMarksmanModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanLATModule',  
            'MAZ_EZM_LDFP_fnc_createGrenadierModule',  
            'MAZ_EZM_LDFP_fnc_createAutoriflemanModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanModule'  
        ];  
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
    };  

    MAZ_EZM_LDFP_fnc_createPatrolModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createCombatMedicModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanModule',  
            'MAZ_EZM_LDFP_fnc_createMarksmanModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanModule'  
        ];  
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
    };  

    MAZ_EZM_LDFP_fnc_createSentryModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createRiflemanModule'  
        ];  
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
    };  

    MAZ_EZM_LDFP_fnc_createAntiAirTeamModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createAmmoBearerModule',  
            'MAZ_EZM_LDFP_fnc_createMissileSpecAAModule'  
        ];  
        _unit addItemToBackpack "Titan_AA"; 
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
    };  

    MAZ_EZM_LDFP_fnc_createAntiTankTeamModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createAmmoBearerModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanLATModule'  
        ];  
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
    };  

    MAZ_EZM_LDFP_fnc_createMarksmanTeamModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
        private _grp = group _squadLead;  
        _squadLead addPrimaryWeaponItem "optic_SOS";  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createSquadLeadModule'  
        ];  
            
        _grp setBehaviour "AWARE";  
        };  

        comment "Groups (Loyalist)";  

        MAZ_EZM_LDFP_fnc_createSquadPModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createAmmoBearerPModule',  
            'MAZ_EZM_LDFP_fnc_createCombatMedicPModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanPModule',  
            'MAZ_EZM_LDFP_fnc_createMarksmanPModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanLATPModule',  
            'MAZ_EZM_LDFP_fnc_createGrenadierPModule',  
            'MAZ_EZM_LDFP_fnc_createAutoriflemanPModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanPModule'  
        ];  
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  

        MAZ_EZM_LDFP_fnc_createPatrolPModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createCombatMedicPModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanPModule',  
            'MAZ_EZM_LDFP_fnc_createMarksmanPModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanPModule'  
        ];  
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
        };  

        MAZ_EZM_LDFP_fnc_createSentryPModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createRiflemanPModule'  
        ];  
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
        }; 

        MAZ_EZM_LDFP_fnc_createAntiTankTeamPModule = {  
        private _squadLead = call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
        private _grp = group _squadLead;  
        {  
            private _unit = call (missionNamespace getVariable _x);  
            [_unit] joinSilent _grp;  
        }forEach [  
            'MAZ_EZM_LDFP_fnc_createAmmoBearerPModule',  
            'MAZ_EZM_LDFP_fnc_createRiflemanLATPModule'  
        ];  
        _grp setBehaviour "AWARE";  
        {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead  
    }; 
comment "Men";  

    MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit = {  
        params ["_unit"];  
        sleep 0.5;  
        private _polishVoice = [  
            "Male01POL",  
            "Male02POL",  
            "Male03POL"
        ];    

        [_unit,(selectRandom _polishVoice)] remoteExec ['setSpeaker'];    
    };  

    MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit = {  
        params ["_unit"];  
        private _65Ammo = "30Rnd_65x39_caseless_msbs_mag"; 
        private _pWeapon = selectRandom [ ["arifle_MSBS65_black_F", _65Ammo], ["arifle_MSBS65_black_F", _65Ammo] ];  
            
        _pWeapon  
    };  

    MAZ_EZM_LDFP_fnc_addLDFPBackpack = {  
        params ["_unit"];  
        private _randomBackpack = selectRandom ["B_AssaultPack_eaf_F"];  
        _unit addBackpackGlobal _randomBackpack;  
        };  

        MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit = {  
        params ["_unit"];  
        private _LDFPGoggles = ["","","","G_Shades_Black","G_Shades_Red","","G_Bandanna_oli"];  
        _unit addGoggles (selectRandom _LDFPGoggles);  
        [_unit,"NVGoggles_INDEP"] call MAZ_EZM_fnc_addNVGs; 
    };  

    MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit = {  
        params ["_unit"];  

        private _LDFPUniforms = ["U_I_CombatUniform_shortsleeve","U_I_CombatUniform","U_I_E_Uniform_01_sweater_F"];  
        private _LDFPVests = ["V_CarrierRigKBT_01_light_EAF_F"];  
        private _LDFPHeadgear = ["H_HelmetHBK_headset_F"];  
        _unit forceAddUniform (selectRandom _LDFPUniforms);  
        _unit setObjectTextureGlobal [0,"a3\characters_f_enoch\Uniforms\Data\I_L_Uniform_01_Deserter_2_co.paa"]; 
        _unit addVest (selectRandom _LDFPVests);  
        _unit addHeadgear (selectRandom _LDFPHeadgear);  
        removeGoggles _unit;  
    };  
            
    MAZ_EZM_LDFP_fnc_createAmmoBearerModule = {  
        private _unit = [independent,"I_E_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        _unit addBackpack "B_Carryall_eaf_F";
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createAutoriflemanModule = {  
        private _unit = [independent,"I_E_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _M556Ammo = selectRandom ["200Rnd_556x45_Box_Red_F", "200Rnd_556x45_Box_Tracer_Red_F"];  
        private _M65Ammo = selectRandom ["200Rnd_65x39_cased_Box_Red", "200Rnd_65x39_cased_Box_Tracer_Red"];  
        private _pMachineGun = selectRandom [ ["LMG_Mk200_black_F",_M65Ammo],["LMG_03_F",_M556Ammo] ];   
        [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createCBRNModule = {  
    
        private _unit = [independent,"I_E_Soldier_CBRN_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        _unit addVest "V_CarrierRigKBT_01_EAF_F"; 
        _unit addUniform "U_I_E_CBRN_Suit_01_EAF_F"; 
        _unit addHeadgear "H_HelmetHBK_F"; 
        _unit addItem "G_AirPurifyingRespirator_01_F";
        _unit assignItem "G_AirPurifyingRespirator_01_F";
        _unit addBackpack "B_CombinationUnitRespirator_01_F";
        (backpackContainer _unit) setObjectTextureGlobal [1, "a3\supplies_f_enoch\bags\data\b_cur_01_co.paa"]; 
        (backpackContainer _unit) setObjectTextureGlobal [2, "a3\supplies_f_enoch\bags\data\b_cur_01_co.paa"]; 
        _unit linkItem "G_AirPurifyingRespirator_01_nofilter_F";
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_Holosight_blk_F"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;     
        _unit  
    }; 

    MAZ_EZM_LDFP_fnc_createCombatMedicModule = {  
        private _unit = [independent,"I_E_Medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit addItemToBackpack "Medikit";  
        for "_i" from 0 to 4 do {  
            _unit addItemToBackpack "FirstAidKit";  
        };  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createMedicModule = {  
        private _unit = [independent,"I_E_Medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        _unit addVest "V_CarrierRigKBT_01_EAF_F";  
        removeGoggles _unit;  
        _unit addHeadgear "H_HelmetHBK_headset_F";  
        _unit addItemToBackpack "Medikit";  
        for "_i" from 0 to 4 do {  
        _unit addItemToBackpack "FirstAidKit";  
        };  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createCrewmanModule = {  
        private _unit = [independent,"I_E_Crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        removeHeadgear _unit;  
        removevest _unit;  
        removeheadgear _unit;  
        _unit addHeadgear "H_Tank_eaf_F";  
        _unit addUniform "U_I_E_Uniform_01_sweater_F"; 
        _unit addVest "V_CarrierRigKBT_01_EAF_F";  
        _unit addItemToVest "ToolKit";  

        [_unit,["arifle_AKS_F",["30Rnd_545x39_Mag_F",2],[]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit setObjectTextureGlobal [1,""]; 
        _unit  
    }; 

    MAZ_EZM_LDFP_fnc_createEngineerModule = {  
        private _unit = [independent,"I_E_Engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit; 
        _unit addBackpack "B_Carryall_eaf_F"; 
        _unit addItemToVest "ToolKit";  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createSquadLeadModule = {  
        private _unit = [independent,"I_E_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;   
        _unit addWeapon "Binocular";  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit    
    };  

    MAZ_EZM_LDFP_fnc_createFighterPilotModule = {  
        private _unit = [independent,"I_Fighter_Pilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;    
        removeAllWeapons _unit;
        _unit  
    };

    MAZ_EZM_LDFP_fnc_createGrenadierModule = {  
        private _unit = [independent,"I_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _pGrenadier = selectRandom ["arifle_MSBS65_GL_black_F"];  
        [_unit,[_pGrenadier,["30Rnd_65x39_caseless_msbs_mag",5],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons;  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createMarksmanModule = {  
        private _unit = [independent,"I_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  

        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _pMarksman = selectRandom [ "arifle_MSBS65_Mark_black_F"];  
        [_unit,[_pMarksman,["30Rnd_65x39_caseless_msbs_mag",7],["optic_MRCO"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;   

        _unit  
    }; 

    MAZ_EZM_LDFP_fnc_createMilitaryPoliceModule = {  
        private _unit = [independent,"I_E_Officer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        _unit addVest "V_CarrierRigKBT_01_EAF_F"; 
        _unit addUniform "U_I_E_Uniform_01_sweater_F";
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_Holosight_blk_F"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit addHeadgear "H_MilCap_eaf"; 
            
        _unit  
    }; 

    MAZ_EZM_LDFP_fnc_createMilitaryScientistModule = {  
        private _unit = [independent,"I_E_Scientist_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        _unit addVest "V_Rangemaster_belt"; 
        _unit addUniform "U_C_CBRN_Suit_01_White_F";
        _unit addItem "G_AirPurifyingRespirator_01_F";
        _unit assignItem "G_AirPurifyingRespirator_01_F";
        _unit addBackpack "B_CombinationUnitRespirator_01_F";
        (backpackContainer _unit) setObjectTextureGlobal [1, "a3\supplies_f_enoch\bags\data\b_cur_01_co.paa"]; 
        (backpackContainer _unit) setObjectTextureGlobal [2, "a3\supplies_f_enoch\bags\data\b_cur_01_co.paa"]; 
        _unit linkItem "G_AirPurifyingRespirator_01_nofilter_F";
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_Holosight_blk_F"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit  
    }; 

    MAZ_EZM_LDFP_fnc_createMilitaryScientistUnarmedModule = {  
        private _unit = [independent,"I_E_Scientist_Unarmed_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        _unit addUniform "U_C_CBRN_Suit_01_White_F";
        _unit addItem "G_AirPurifyingRespirator_01_F";
        _unit assignItem "G_AirPurifyingRespirator_01_F"; 
        _unit addBackpack "B_CombinationUnitRespirator_01_F";
        (backpackContainer _unit) setObjectTextureGlobal [1, "a3\supplies_f_enoch\bags\data\b_cur_01_co.paa"]; 
        (backpackContainer _unit) setObjectTextureGlobal [2, "a3\supplies_f_enoch\bags\data\b_cur_01_co.paa"]; 
        _unit linkItem "G_AirPurifyingRespirator_01_nofilter_F";
        [_unit,""] remoteExec ["switchMove"];
        _unit  
    }; 

    MAZ_EZM_LDFP_fnc_createMissileSpecAAModule = {  
        private _unit = [independent,"I_Soldier_AA_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  

        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        _unit addBackpack "B_Carryall_eaf_F";
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],["launch_I_Titan_eaf_F",["Titan_AA",1]],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit addItemToBackpack "Titan_AA"; 
        _unit  
    }; 

    MAZ_EZM_LDFP_fnc_createMissileSpecATModule = {  
        private _unit = [independent,"I_Soldier_AT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  

        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        _unit addBackpack "B_Carryall_eaf_F"; 
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],["launch_I_Titan_short_F",["Titan_AT",1]],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit addItemToBackpack "Titan_AT"; 
        _unit  
    };

    MAZ_EZM_LDFP_fnc_createOfficerModule = {  
        private _unit = [independent,"I_E_Officer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;   
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        _unit addVest "V_CarrierRigKBT_01_EAF_F"; 
        _unit addUniform "U_I_E_Uniform_01_officer_F"; 
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_Holosight_blk_F"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit addHeadgear "H_Beret_EAF_01_F"; 
            
        _unit  
    };   

    MAZ_EZM_LDFP_fnc_createRiflemanModule = {  
        private _unit = [independent,"I_E_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createRiflemanLATModule = {  
        private _unit = [independent,"I_E_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;   
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _pRPG = selectRandom ["RPG32_F", "RPG32_F"];   
        private _pAT = selectRandom [ ["launch_RPG32_green_F",_pRPG] ];  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[_pAT select 0, [_pAT select 1,3]],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createRiflemanHATModule = {  
        private _unit = [independent,"I_E_Soldier_LAT2_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],["launch_MRAWS_green_rail_F",["MRAWS_HEAT_F",2]],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createRiflemanHATPCMLModule = {  
        private _unit = [independent,"I_E_Soldier_LAT2_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],["launch_NLAW_F",["NLAW_F",2]],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit  
    };

    MAZ_EZM_LDFP_fnc_createRadiomanModule = {  
        private _unit = [independent,"I_E_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnit;  
        _unit addBackpack "B_RadioBag_01_eaf_FAK_F";  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnit;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createUnarmedModule = {  
        private _unit = [independent,"I_E_Soldier_unarmed_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        removeVest _unit;  
        removeHeadgear _unit;  
        [_unit,""] remoteExec ["switchMove"];
        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createHelicopterCrewModule = {  
        private _unit = [independent,"I_E_Helicrew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  

        _unit  
    }; 

    MAZ_EZM_LDFP_fnc_createHelicopterPilotModule = {  
        private _unit = [independent,"I_E_Helipilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit; 

        _unit  
    }; 
comment "Men (Loyalist)";   

    MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnitL = {  
        params ["_unit"];  
        private _65Ammo = "30Rnd_65x39_caseless_msbs_mag";  
        private _545Ammo = "30Rnd_545x39_Mag_F";  
        private _762Ammo = "30Rnd_762x39_Mag_F";  
        private _pWeapon = selectRandom [ ["arifle_AKM_FL_F", _762Ammo], ["arifle_MSBS65_black_F", _65Ammo], ["arifle_AKS_F", _545Ammo] ];  
            
        _pWeapon  
    }; 

    MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnitL = {  
        params ["_unit"];  
        private _LDFPGoggles = ["","","","G_Shades_Black","G_Shades_Red","G_Bandanna_oli"];  
        _unit addGoggles (selectRandom _LDFPGoggles);  
    }; 

    MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL = {
        params ["_unit"];
        private _LDFPUniforms = ["U_BG_Guerilla1_1","U_I_CombatUniform_shortsleeve","U_I_CombatUniform","U_I_E_Uniform_01_tanktop_F","U_I_E_Uniform_01_sweater_F","U_I_E_Uniform_01_shortsleeve_F","U_I_L_Uniform_01_camo_F"];
        private _LDFPVests = ["V_CarrierRigKBT_01_EAF_F","V_CarrierRigKBT_01_light_EAF_F"];
        private _LDFPHeadgear = ["H_HelmetHBK_F","H_Booniehat_eaf","H_Cap_oli_hs","H_MilCap_eaf","H_Bandanna_khk_hs","H_Watchcap_camo"];

        _unit forceAddUniform (selectRandom _LDFPUniforms);
        _unit addVest (selectRandom _LDFPVests);
        _unit addHeadgear (selectRandom _LDFPHeadgear);

        private _uniformData = switch (uniform _unit) do {
        case "U_BG_Guerilla1_1": {
            private _textureTop = selectRandom ["a3\characters_f_gamma\civil\data\c_cloth1_brown.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_bandit_3_f_1_co.paa","a3\characters_f_enoch\uniforms\data\i_l_uniform_01_deserter_1_co.paa","a3\characters_f_orange\uniforms\data\c_cloth1_olive_co.paa","a3\characters_f_exp\syndikat\data\u_i_c_soldier_para_1_f_1_co.paa","A3\Characters_F\Civil\Data\c_cloth1_kabeiroi_co.paa","a3\characters_f_gamma\Civil\Data\c_cloth1_black.paa"];
            private _textureBottom = selectRandom ["a3\characters_f_enoch\Uniforms\Data\I_L_Uniform_01_Deserter_2_co.paa"];
            [_textureTop,_textureBottom];
        }; 

        case "U_I_CombatUniform";
        case "U_I_CombatUniform_shortsleeve": { 
            private _texture = "a3\characters_f_enoch\Uniforms\Data\I_L_Uniform_01_Deserter_2_co.paa";
            [_texture,""]
        };
        default {["",""]};
        };

        [[_unit,_uniformData],{
            params ["_unit","_uniformData"];
            {
                if(_x == "") then {continue};
                _unit setObjectTextureGlobal [_forEachIndex,_x];
            } forEach _uniformData;
        }] remoteExec ['spawn',0,_unit];
    };

    MAZ_EZM_LDFP_fnc_createAmmoBearerPModule = {  
        private _unit = [independent,"I_E_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        _unit addBackpack "B_Carryall_eaf_F";
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnitL;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnitL;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createAutoriflemanPModule = {  
        private _unit = [independent,"I_E_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnitL;  
        private _M556Ammo = selectRandom ["200Rnd_556x45_Box_Red_F", "200Rnd_556x45_Box_Tracer_Red_F"];  
        private _M65Ammo = selectRandom ["200Rnd_65x39_cased_Box_Red", "200Rnd_65x39_cased_Box_Tracer_Red"];  
        private _pMachineGun = selectRandom [ ["LMG_Mk200_black_F",_M65Ammo],["LMG_03_F",_M556Ammo] ];   
        [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createCombatMedicPModule = {  
        private _unit = [independent,"I_E_Medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnitL;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnitL;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit addItemToBackpack "Medikit";  
        for "_i" from 0 to 4 do {  
            _unit addItemToBackpack "FirstAidKit";  
        };  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createEngineerPModule = {  
        private _unit = [independent,"I_E_Engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  
        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        _unit addItemToVest "ToolKit";  
        _unit addBackpack "B_Carryall_eaf_F";
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnitL;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createSquadLeadPModule = {  
        private _unit = [independent,"I_E_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  

        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        _unit addWeapon "Binocular"; 
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnitL;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  

        removeGoggles _unit;   

        _unit    
    };  

    MAZ_EZM_LDFP_fnc_createGrenadierPModule = {  
        private _unit = [independent,"I_E_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  

        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnitL;  
        private _pGrenadier = selectRandom ["arifle_MSBS65_GL_black_F"];  
        [_unit,[_pGrenadier,["30Rnd_65x39_caseless_msbs_mag",5],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons;  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createMarksmanPModule = {  
        private _unit = [independent,"I_E_soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  

        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnitL;  
        private _pMarksman = selectRandom [ "srifle_DMR_06_olive_F"];  
        [_unit,[_pMarksman,["20Rnd_762x51_Mag",5],[]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;   

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createRiflemanPModule = {  
        private _unit = [independent,"I_E_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  

        [_unit] call MAZ_EZM_fnc_removeAllClothing;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnitL;  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnitL;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  

        _unit  
    };  

    MAZ_EZM_LDFP_fnc_createRiflemanLATPModule = {  

        private _unit = [independent,"I_E_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;  

        [_unit] call MAZ_EZM_fnc_removeAllClothing;   
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPUniformToUnitL;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPIdentitiesToUnit;  
        [_unit] call MAZ_EZM_LDFP_fnc_addLDFPBackpack;  
        [_unit] spawn MAZ_EZM_LDFP_fnc_addLDFPGogglesToUnitL;  
        private _fAT = selectRandom [ ["launch_RPG32_green_F","RPG32_F"],["launch_RPG7_F","RPG7_F"] ];  
        private _weaponInfo = [_unit] call MAZ_EZM_LDFP_fnc_getLDFPWeaponToUnitL;  
        [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ico_01_black_f"]],[_fAT select 0, [_fAT select 1,3]],["hgun_Pistol_heavy_01_green_F",["11Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;   

        _unit  
    };  
comment "Planes";

    MAZ_EZM_LDFP_fnc_createGryphonModule = {  
        private _vehicle = ["I_Plane_Fighter_04_F"] call MAZ_EZM_fnc_createVehicle; 

        [_vehicle,"CamoGrey"] call bis_fnc_initVehicle; 

        _vehicle setPylonLoadout [5,"PylonMissile_Bomb_GBU12_x1"];
        _vehicle setPylonLoadout [6,"PylonMissile_Bomb_GBU12_x1"];

        if(MAZ_EZM_spawnWithCrew) then { 
                
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createFighterPilotModule;  
            _pilot moveInDriver _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_pilot] joinSilent _grp;  
            _grp selectLeader _pilot;  
            _grp setBehaviour "AWARE";  
        };  
        
        _vehicle  
    };     

comment "Reinforcement";  

    MAZ_EZM_LDFP_fnc_createReinforcementCzaplaUnarmedModule = {  
        private _vehicle = ["I_E_Heli_light_03_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule; 

            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementCzaplaModule = {  
        private _vehicle = ["I_E_Heli_light_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule; 

            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementHummingbirdModule = {  
        
        private _vehicle = ["B_Heli_Light_01_F"] call MAZ_EZM_fnc_createVehicle; 

        [_vehicle,[0,"a3\props_f_enoch\military\decontamination\data\containmentarea_olive_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle];  

        if(MAZ_EZM_spawnWithCrew) then {  
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule; 

            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementZamakCoveredTransportModule = {  
        private _vehicle = ["I_E_Truck_02_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger16 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            private _passanger15 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATModule;  
            private _passanger14 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger13 = [] call MAZ_EZM_LDFP_fnc_createAutoriflemanModule;  
            private _passanger12 = [] call MAZ_EZM_LDFP_fnc_createEngineerModule;  
            private _passanger11 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger10 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger9 = [] call MAZ_EZM_LDFP_fnc_createGrenadierModule;  
            private _passanger8 = [] call MAZ_EZM_LDFP_fnc_createAutoriflemanModule;  
            private _passanger7 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementOffroadCoveredModule = {  
        private _vehicle = ["I_E_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle; 

        private _carcamo = [  
            "Green",  
            "AEF"
        ]; 

        [  
            _vehicle,  
            [(selectRandom _carcamo),1],   
            ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0]  
        ] call BIS_fnc_initVehicle;  

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
            _grp selectLeader _driver;  
            _grp setBehaviour "AWARE";  
            
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementOffroadModule = { 
        private _vehicle = ["I_E_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle; 

        private _carcamo = [  
            "Green",  
            "AEF"
        ]; 

        [  
            _vehicle,  
            [(selectRandom _carcamo),1],   
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]  
        ] call BIS_fnc_initVehicle;  

        if(MAZ_EZM_spawnWithCrew) then {  

            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
            private _grp = createGroup [Independent,true];  
            [_driver] joinSilent _grp;  
            _grp selectLeader _driver;  
            _grp setBehaviour "AWARE";  
            
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementVanModule = {  
        private _vehicle = ["I_E_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle; 

        [  
            _vehicle,  
            ["",1],   
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
        ] call BIS_fnc_initVehicle;  

        if(MAZ_EZM_spawnWithCrew) then {  
            
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            
            private _passanger10 = [] call MAZ_EZM_LDFP_fnc_createAutoriflemanModule;  
            private _passanger9 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger8 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger7 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementVanTransportModule = {  
        private _vehicle = ["I_E_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle; 

        [  
            _vehicle,  
            ["",1],   
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
        ] call BIS_fnc_initVehicle;  
            
        if(MAZ_EZM_spawnWithCrew) then {  
            
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            
            private _passanger10 = [] call MAZ_EZM_LDFP_fnc_createAutoriflemanModule;  
            private _passanger9 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger8 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger7 = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadModule;  
            
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
comment "Reinforcements (Loyalist)"; 

    MAZ_EZM_LDFP_fnc_createReinforcementCzaplaUnarmedPModule = {  
        private _vehicle = ["I_E_Heli_light_03_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule; 

            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerPModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierPModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATPModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementCzaplaPModule = {  
        private _vehicle = ["I_E_Heli_light_03_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule; 

            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerPModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierPModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATPModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementHummingbirdPModule = {  
        
        private _vehicle = ["B_Heli_Light_01_F"] call MAZ_EZM_fnc_createVehicle; 

        [_vehicle,[0,"a3\props_f_enoch\military\decontamination\data\containmentarea_olive_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle];  

        if(MAZ_EZM_spawnWithCrew) then {  
            private _pilot = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule;  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createHelicopterPilotModule; 
            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierPModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATPModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementZamakCoveredTransportPModule = {  
        private _vehicle = ["I_E_Truck_02_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger16 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            private _passanger15 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATPModule;  
            private _passanger14 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger13 = [] call MAZ_EZM_LDFP_fnc_createAutoriflemanPModule;  
            private _passanger12 = [] call MAZ_EZM_LDFP_fnc_createEngineerPModule;  
            private _passanger11 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger10 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger9 = [] call MAZ_EZM_LDFP_fnc_createGrenadierPModule;  
            private _passanger8 = [] call MAZ_EZM_LDFP_fnc_createAutoriflemanPModule;  
            private _passanger7 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerPModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierPModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATPModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementOffroadCoveredPModule = {  
        private _vehicle = ["I_E_Offroad_01_covered_F"] call MAZ_EZM_fnc_createVehicle; 

        [  
            _vehicle,  
            ["Green",1],   
            ["hidePolice",1,"HideServices",1,"HideCover",0,"StartBeaconLight",0,"HideRoofRack",0,"HideLoudSpeakers",1,"HideAntennas",1,"HideBeacon",1,"HideSpotlight",1,"HideDoor3",0,"OpenDoor3",0,"HideDoor1",0,"HideDoor2",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"BeaconsStart",0]  
        ] call BIS_fnc_initVehicle;  

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            _driver moveInDriver _vehicle;  
            _grp selectLeader _driver;  
            _grp setBehaviour "AWARE";  
            
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementOffroadPModule = { 
        private _vehicle = ["I_E_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle; 

        [  
            _vehicle,  
            ["Green",1],   
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]  
        ] call BIS_fnc_initVehicle;  

        if(MAZ_EZM_spawnWithCrew) then {  

            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            _driver moveInDriver _vehicle;  
            private _grp = createGroup [Independent,true];  
            [_driver] joinSilent _grp;  
            _grp selectLeader _driver;  
            _grp setBehaviour "AWARE";  
            
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementVanPModule = {  
        private _vehicle = ["I_E_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle; 

        [  
            _vehicle,  
            ["",1],   
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
        ] call BIS_fnc_initVehicle;  

        if(MAZ_EZM_spawnWithCrew) then {  
            
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            
            private _passanger10 = [] call MAZ_EZM_LDFP_fnc_createAutoriflemanPModule;  
            private _passanger9 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger8 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger7 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerPModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierPModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATPModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            
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

    MAZ_EZM_LDFP_fnc_createReinforcementVanTransportPModule = {  
        private _vehicle = ["I_E_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle; 

        [  
            _vehicle,  
            ["",1],   
            ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
        ] call BIS_fnc_initVehicle;  
            
        if(MAZ_EZM_spawnWithCrew) then {  
            
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            
            private _passanger10 = [] call MAZ_EZM_LDFP_fnc_createAutoriflemanPModule;  
            private _passanger9 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger8 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger7 = [] call MAZ_EZM_LDFP_fnc_createRiflemanPModule;  
            private _passanger6 = [] call MAZ_EZM_LDFP_fnc_createAmmoBearerPModule;  
            private _passanger5 = [] call MAZ_EZM_LDFP_fnc_createGrenadierPModule;  
            private _passanger4 = [] call MAZ_EZM_LDFP_fnc_createMarksmanPModule;  
            private _passanger3 = [] call MAZ_EZM_LDFP_fnc_createRiflemanLATPModule;  
            private _passanger2 = [] call MAZ_EZM_LDFP_fnc_createCombatMedicPModule;  
            private _passanger1 = [] call MAZ_EZM_LDFP_fnc_createSquadLeadPModule;  
            
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
comment "Tanks"; 

    MAZ_EZM_LDFP_fnc_createATNyxModule = {  
        private _vehicle = ["I_LT_01_AT_F"] call MAZ_EZM_fnc_createVehicle; 
        _vehicle disableTIEquipment true;  
        _vehicle allowCrewInImmobile true; 

        [  
            _vehicle,  
            ["Indep_Olive",1],   
            ["showTools",1,"showCamonetHull",1,"showBags",0,"showSLATHull",0]  
        ] call BIS_fnc_initVehicle;  

        [_vehicle,[2,"a3\armor_f_enoch\apc_tracked_03\data\camonet_eaf_green_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _driver moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _gunner moveInGunner _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_gunner] joinSilent _grp;  
            _grp selectLeader _gunner;  
            _grp setBehaviour "AWARE";  
        };  

        _vehicle  
    };  
        
    MAZ_EZM_LDFP_fnc_createReconNyxModule = {  
        private _vehicle = ["I_LT_01_scout_F"] call MAZ_EZM_fnc_createVehicle; 
        _vehicle disableTIEquipment true;  
        _vehicle allowCrewInImmobile true; 

        [  
            _vehicle,  
            ["Indep_Olive",1],   
            ["showTools",1,"showCamonetHull",1,"showBags",0,"showSLATHull",0]  
        ] call BIS_fnc_initVehicle;  

        [_vehicle,[2,"a3\armor_f_enoch\apc_tracked_03\data\camonet_eaf_green_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _driver moveInDriver _vehicle;  
            
            private _commander = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _commander moveInCommander _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_commander] joinSilent _grp;  
            _grp selectLeader _commander;  
            _grp setBehaviour "AWARE";  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_create20mmNyxModule = {  
        private _vehicle = ["I_LT_01_cannon_F"] call MAZ_EZM_fnc_createVehicle; 
        _vehicle disableTIEquipment true;  
        _vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]];  
        _vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]];  
        _vehicle removeWeaponTurret ["LMG_coax_ext", [0]];  
        _vehicle allowCrewInImmobile true; 

        [  
            _vehicle,  
            ["Indep_Olive",1],   
            ["showTools",1,"showCamonetHull",1,"showBags",0,"showSLATHull",0]  
        ] call BIS_fnc_initVehicle;  

        [_vehicle,[2,"a3\armor_f_enoch\apc_tracked_03\data\camonet_eaf_green_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _driver moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _gunner moveInGunner _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_gunner] joinSilent _grp;  
            _grp selectLeader _gunner;  
            _grp setBehaviour "AWARE";  
        };  

        _vehicle                 
    };  

    MAZ_EZM_LDFP_fnc_createKumaModule = {  
        private _vehicle = ["I_MBT_03_cannon_F"] call MAZ_EZM_fnc_createVehicle; 
        _vehicle disableTIEquipment true;  
        _vehicle allowCrewInImmobile true; 

        [  
            _vehicle,  
            ["Indep_02",1],   
            ["showTools",1,"showCamonetHull",1,"showCamonetTurret",1,"showBags",1,"showSLATHull",0]   
        ] call BIS_fnc_initVehicle;  

        [_vehicle,[0,"a3\props_f_enoch\military\decontamination\data\containmentarea_olive_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle];  
        [_vehicle,[1,"a3\props_f_enoch\military\decontamination\data\containmentarea_olive_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 
        [_vehicle,[2,"a3\props_f_enoch\military\decontamination\data\containmentarea_olive_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 
        [_vehicle,[3,"a3\armor_f_enoch\apc_tracked_03\data\camonet_eaf_green_co.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 
        [_vehicle,["clan","\a3\data_f_enoch\factionicons\icon_eaf_ca.paa"]] remoteExec ['setObjectTextureGlobal',0,_vehicle]; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _driver moveInDriver _vehicle;  
            
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _gunner moveInGunner _vehicle;  

            private _commander = [] call MAZ_EZM_LDFP_fnc_createCrewmanModule;  
            _commander moveInCommander _vehicle;  
            
            private _grp = createGroup [Independent,true];  
            [_driver,_gunner,_commander] joinSilent _grp;  
            _grp selectLeader _commander;  
            _grp setBehaviour "AWARE";  
        };  

        _vehicle                  
    };  
comment "Trucks";  

    MAZ_EZM_LDFP_fnc_createZamakAmmoModule = {   
        private _vehicle = ["I_E_Truck_02_Ammo_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createZamakFuelModule = {  
        private _vehicle = ["I_E_Truck_02_fuel_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createZamakMedicalModule = {  
        private _vehicle = ["I_E_Truck_02_Medical_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createZamakRepairModule = {  
        private _vehicle = ["I_E_Truck_02_Box_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createZamakTransportModule = {  
        private _vehicle = ["I_E_Truck_02_transport_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createZamakCoveredTransportModule = {  
        private _vehicle = ["I_E_Truck_02_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _driver moveInDriver _vehicle;  
        };  

        _vehicle  
    }; 
comment "Turrets";  

    MAZ_EZM_LDFP_fnc_createMPQ105Module = {  
        private _vehicle = ["I_E_Radar_System_01_F"] call MAZ_EZM_fnc_createVehicle; 

        private _aiGroup = createGroup [INDEP,true];  
        private _oldGroup = createVehicleCrew _vehicle;  
        private _leader = leader _oldGroup;  
        {  
            [_x] joinSilent _aiGroup;  
        }forEach units _oldGroup;  
        _aiGroup selectLeader _leader;  

        _vehicle  
        }; 

        MAZ_EZM_LDFP_fnc_createM2HMGModule = {  
        private _vehicle = ["I_G_HMG_02_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _gunner moveInGunner _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createM2HMGRaisedModule = {  
        private _vehicle = ["I_G_HMG_02_high_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _gunner moveInGunner _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createMIM145Module = {  
        private _vehicle = ["I_E_SAM_System_03_F"] call MAZ_EZM_fnc_createVehicle; 

        private _aiGroup = createGroup [INDEP,true];  
        private _oldGroup = createVehicleCrew _vehicle;  
        private _leader = leader _oldGroup;  
        {  
            [_x] joinSilent _aiGroup;  
        }forEach units _oldGroup;  
        _aiGroup selectLeader _leader;  

        _vehicle  
    }; 

    MAZ_EZM_LDFP_fnc_createMk6MortarModule = {  
        private _vehicle = ["I_E_Mortar_01_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _gunner moveInGunner _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createAALauncherModule = {  
        private _vehicle = ["I_E_Static_AA_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _gunner moveInGunner _vehicle;  
        };  

        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createATLauncherModule = {  
        private _vehicle = ["I_E_Static_AT_F"] call MAZ_EZM_fnc_createVehicle; 

        if(MAZ_EZM_spawnWithCrew) then {  
            private _gunner = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
            _gunner moveInGunner _vehicle;  
        };  

        _vehicle  
    };  
comment "Vans";  
    
    MAZ_EZM_LDFP_fnc_createVanCargoModule = {  
        private _vehicle = ["I_E_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle; 
        
        [  
        _vehicle,  
        ["",1],   
        ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
        ] call BIS_fnc_initVehicle;  
        
        if(MAZ_EZM_spawnWithCrew) then {  
        private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
        _driver moveInDriver _vehicle;  
        };  
    
        _vehicle  
    };  
    
    MAZ_EZM_LDFP_fnc_createVanTransportModule = {  
        private _vehicle = ["I_E_Van_02_transport_F"] call MAZ_EZM_fnc_createVehicle; 
        
        [  
        _vehicle,  
        ["",1],   
        ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",0,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",0,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",1,"beacon_rear_hide",1]  
        ] call BIS_fnc_initVehicle;  
        
        if(MAZ_EZM_spawnWithCrew) then {  
        private _driver = [] call MAZ_EZM_LDFP_fnc_createRiflemanModule;  
        _driver moveInDriver _vehicle;  
        }; 
    
        _vehicle  
    };  

    MAZ_EZM_LDFP_fnc_createVanTransportMPModule = {  
        private _vehicle = ["I_E_Van_02_transport_MP_F"] call MAZ_EZM_fnc_createVehicle; 
        
        [
            _vehicle,
            ["LDF",1], 
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",0,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",0,"beacon_rear_hide",0]
        ] call BIS_fnc_initVehicle;  
        
        if(MAZ_EZM_spawnWithCrew) then {  
        private _driver = [] call MAZ_EZM_LDFP_fnc_createMilitaryPoliceModule;  
        _driver moveInDriver _vehicle;  
        }; 
    
        _vehicle  
    }; 

    MAZ_EZM_LDFP_fnc_createVanCargoMPModule = {  
        private _vehicle = ["I_E_Van_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle; 
        
        [
            _vehicle,
            ["LDF",1], 
            ["Enable_Cargo",1,"Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",0,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",0,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",0,"beacon_rear_hide",0]
        ] call BIS_fnc_initVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {  
        private _driver = [] call MAZ_EZM_LDFP_fnc_createMilitaryPoliceModule;  
        _driver moveInDriver _vehicle;  
        }; 

        {  
        [_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTextureGlobal',0,_vehicle];  
        }forEach ["a3\soft_f_enoch\van_02\data\van_body_ldf_mp_co.paa","a3\soft_f_enoch\van_02\data\van_wheel_transport_ldf_mp_co.paa","a3\soft_f_enoch\van_02\data\van_glass_mp_ca.paa","a3\soft_f_enoch\van_02\data\van_body_ldf_mp_co.paa"];  
        
        _vehicle  
    }; 
    
    MAZ_EZM_LDFP_fnc_createVanAmbulanceModule = {  
        private _vehicle = ["I_E_Van_02_medevac_F"] call MAZ_EZM_fnc_createVehicle; 
        [  
        _vehicle,  
        ["",1],   
        ["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",0,"beacon_rear_hide",0]  
        ] call BIS_fnc_initVehicle;  
        if(MAZ_EZM_spawnWithCrew) then {  
        private _driver = [] call MAZ_EZM_LDFP_fnc_createMedicModule;  
        _driver moveInDriver _vehicle;  
        }; 
        _vehicle  
    };

comment "Zeus Interface";
MAZ_EZM_LDFP_fnc_modules = {
    with uiNamespace do {
        comment "LDF+ Modules";
     
            private _ldfLocalText = localize "$STR_A3_C_CFGFACTIONCLASSES_IND_E_F0"; 
            MAZ_LDFPTree = [MAZ_UnitsTree_INDEP,_ldfLocalText] call MAZ_EZM_fnc_findTree; 
            private _count = MAZ_UnitsTree_INDEP tvCount [MAZ_LDFPTree];  
            for "_i" from 0 to (_count - 1) do {  
                MAZ_UnitsTree_INDEP tvDelete [MAZ_LDFPTree,0];  
            };  

            MAZ_UnitsTree_INDEP tvSetText [[MAZ_LDFPTree], _ldfLocalText+ "+"];  
            MAZ_UnitsTree_INDEP tvSetPictureRight [[MAZ_LDFPTree], "\a3\data_f_enoch\logos\arma3_enoch_logo_small_ca.paa"];  
            MAZ_UnitsTree_INDEP tvSetTooltip [[MAZ_LDFPTree], format ["A remastered version of the LDF faction.\n\nAn Official EZM Faction.\nVersion: %1", missionNamespace getVariable "MAZ_EZM_LDFP_Ver"]];   
                
        comment "Anti-Air"; 

            MAZ_LDFPAntiAirTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Anti-Air",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPAntiAirTree,  
                "AWC 302 Nyx (AA)",  
                "AWC 302 Nyx (AA)",  
                "MAZ_EZM_LDFP_fnc_createAANyxModule",  
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

        comment "APCs";  

            MAZ_LDFPAPCsTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "APCs",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPAPCsTree,  
                "FV-720 Odyniec",  
                "FV-720 Odyniec",  
                "MAZ_EZM_LDFP_fnc_createOdyniecModule",  
                "\a3\armor_f_epb\apc_tracked_03\data\ui\map_apc_tracked_03_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

        comment "Artillery"; 

            MAZ_LDFPArtilleryTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Artillery",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPArtilleryTree,  
                "Zamak MRL",  
                "Zamak MRL",  
                "MAZ_EZM_LDFP_fnc_createZamakMRLModule",  
                "a3\soft_f_gamma\truck_02\data\ui\map_truck_02_mrl_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
        comment "Cars";    
        
            MAZ_LDFPCarsTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Cars",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCarsTree,  
                "Offroad",  
                "Offroad",  
                "MAZ_EZM_LDFP_fnc_createOffroadModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCarsTree,  
                "Offroad (Comms)",  
                "Offroad (Comms)",  
                "MAZ_EZM_LDFP_fnc_createOffroadCommsModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCarsTree,  
                "Offroad (AT)",  
                "Offroad (AT)",  
                "MAZ_EZM_LDFP_fnc_createOffroadATModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCarsTree,  
                "Offroad (Covered)",  
                "Offroad (Covered)",  
                "MAZ_EZM_LDFP_fnc_createOffroadCoveredModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCarsTree,  
                "Offroad (HMG)",  
                "Offroad (HMG)",  
                "MAZ_EZM_LDFP_fnc_createOffroadHMGModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCarsTree,  
                "Offroad (Repair)",  
                "Offroad (Repair)",  
                "MAZ_EZM_LDFP_fnc_createOffroadRepairModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCarsTree,  
                "Quadbike",  
                "Quadbike",  
                "MAZ_EZM_LDFP_fnc_createQuadbikeModule",  
                "\A3\Soft_F\Quadbike_01\Data\UI\map_Quad_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

        comment "Compositions";  

            MAZ_LDFPCompositionsTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Compositions",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCompositionsTree,  
                "Cache #1",  
                "Cache",  
                "MAZ_EZM_LDFP_fnc_createCache1Module",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPCompositionsTree,  
                "Cache #2",  
                "Cache",  
                "MAZ_EZM_LDFP_fnc_createCache2Module",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;    
        comment "Drones";  

            MAZ_LDFPDronesTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Drones",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPDronesTree,  
                "Pelican AL-6",  
                "Pelican AL-6",  
                "MAZ_EZM_LDFP_fnc_createPelicanModule",  
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPDronesTree,  
                "Pelican AL-6 (Grenade)",  
                "Pelican AL-6 (Grenade)",  
                "MAZ_EZM_LDFP_fnc_createPelicanGrenadeModule",  
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPDronesTree,  
                "Pelican AL-6 (Medical)",  
                "Pelican AL-6 (Medical)",  
                "MAZ_EZM_LDFP_fnc_createPelicanMedicalModule",  
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPDronesTree,  
                "AR-2 Darter",  
                "AR-2 Darter", 
                "MAZ_EZM_LDFP_fnc_createDarterModule",  
                "\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UI\Map_UAV_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPDronesTree,  
                "FPV (AP)",  
                "FPV (AP)", 
                "MAZ_EZM_LDFP_fnc_createFPVAPModule",  
                "\A3\Drones_F\Air_F_Gamma\UAV_01\Data\UI\Map_UAV_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_LDFPTree, 
                MAZ_LDFPDronesTree, 
                "K40 Ababil-3", 
                "K40 Ababil-3", 
                "MAZ_EZM_LDFP_fnc_createAbabilModule", 
                "\A3\Drones_F\Air_F_Gamma\UAV_02\Data\UI\Map_UAV_02_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [ 
                MAZ_UnitsTree_INDEP, 
                MAZ_LDFPTree, 
                MAZ_LDFPDronesTree, 
                "K40 Ababil-3 (CAS)", 
                "K40 Ababil-3 (CAS)", 
                "MAZ_EZM_LDFP_fnc_createAbabilCASModule", 
                "\A3\Drones_F\Air_F_Gamma\UAV_02\Data\UI\Map_UAV_02_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPDronesTree,  
                "UGV Stomper",  
                "UGV Stomper",  
                "MAZ_EZM_LDFP_fnc_createStomperModule",  
                "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPDronesTree,  
                "UGV Stomper RCWS",  
                "UGV Stomper RCWS",  
                "MAZ_EZM_LDFP_fnc_createStomperRCWSModule",  
                "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_rcws_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
        comment "Helicopters";  

            MAZ_LDFPHelicoptersTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Helicopters",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPHelicoptersTree,  
                "AH-9 Pawnee",  
                "AH-9 Pawnee",  
                "MAZ_EZM_LDFP_fnc_createPawneeModule",  
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_armed_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPHelicoptersTree,  
                "MH-9 Hummingbird",  
                "MH-9 Hummingbird",  
                "MAZ_EZM_LDFP_fnc_createHummingbirdModule",  
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPHelicoptersTree,  
                "WY-55 Czapla",  
                "WY-55 Czapla",  
                "MAZ_EZM_LDFP_fnc_createCzaplaModule",  
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPHelicoptersTree,  
                "WY-55 Czapla (Unarmed)",  
                "WY-55 Czapla (Unarmed)",  
                "MAZ_EZM_LDFP_fnc_createCzaplaUnarmedModule",  
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_unarmed_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;     
        comment "Groups";  

            MAZ_LDFPSubGroupTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Groups",  
                "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Anti-Air Team",  
                "Anti-Air Team",  
                "MAZ_EZM_LDFP_fnc_createAntiAirTeamModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Anti-Tank Team",  
                "Anti-Tank Team",  
                "MAZ_EZM_LDFP_fnc_createAntiTankTeamModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Marksman Team",  
                "Marksman Team",  
                "MAZ_EZM_LDFP_fnc_createMarksmanTeamModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Patrol",  
                "Patrol",  
                "MAZ_EZM_LDFP_fnc_createPatrolModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Squad",  
                "Squad",  
                "MAZ_EZM_LDFP_fnc_createSquadModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Sentry",  
                "Sentry",  
                "MAZ_EZM_LDFP_fnc_createSentryModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
        comment "Groups (Loyalist)";  

            MAZ_LDFPSubGroupTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Groups (Loyalist)",  
                "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Anti-Tank Team",  
                "Anti-Tank Team",  
                "MAZ_EZM_LDFP_fnc_createAntiTankTeamPModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Patrol",  
                "Patrol",  
                "MAZ_EZM_LDFP_fnc_createPatrolPModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Squad",  
                "Squad",  
                "MAZ_EZM_LDFP_fnc_createSquadPModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPSubGroupTree,  
                "Sentry",  
                "Sentry",  
                "MAZ_EZM_LDFP_fnc_createSentryPModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;    

        comment "Men";  

            MAZ_LDFPMenTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Men",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Ammo Bearer",  
                "Ammo Bearer",  
                "MAZ_EZM_LDFP_fnc_createAmmoBearerModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Autorifleman",  
                "Autorifleman",  
                "MAZ_EZM_LDFP_fnc_createAutoriflemanModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "CBRN Specialist",  
                "CBRN Specialist",  
                "MAZ_EZM_LDFP_fnc_createCBRNModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Combat Lifesaver",  
                "Combat Lifesaver",  
                "MAZ_EZM_LDFP_fnc_createCombatMedicModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Crewman",  
                "Crewman",  
                "MAZ_EZM_LDFP_fnc_createCrewmanModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Engineer",  
                "Engineer",  
                "MAZ_EZM_LDFP_fnc_createEngineerModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Fighter Pilot",  
                "Fighter Pilot",  
                "MAZ_EZM_LDFP_fnc_createFighterPilotModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Grenadier",  
                "Grenadier",  
                "MAZ_EZM_LDFP_fnc_createGrenadierModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Helicopter Crew",  
                "Helicopter Crew",  
                "MAZ_EZM_LDFP_fnc_createHelicopterCrewModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Helicopter Pilot",  
                "Helicopter Pilot",  
                "MAZ_EZM_LDFP_fnc_createHelicopterPilotModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Marksman",  
                "Marksman",  
                "MAZ_EZM_LDFP_fnc_createMarksmanModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Medic",  
                "Medic",  
                "MAZ_EZM_LDFP_fnc_createMedicModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Military Police",  
                "Military Police",  
                "MAZ_EZM_LDFP_fnc_createMilitaryPoliceModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Military Scientist",  
                "Military Scientist",  
                "MAZ_EZM_LDFP_fnc_createMilitaryScientistModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Military Scientist (Unarmed)",  
                "Military Scientist (Unarmed)",  
                "MAZ_EZM_LDFP_fnc_createMilitaryScientistUnarmedModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Missile Specialist (AA)",  
                "Missile Scientist (AA)",  
                "MAZ_EZM_LDFP_fnc_createMissileSpecAAModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Missile Specialist (AT)",  
                "Missile Scientist (AT)",  
                "MAZ_EZM_LDFP_fnc_createMissileSpecATModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Officer",  
                "Officer",  
                "MAZ_EZM_LDFP_fnc_createOfficerModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManOfficer_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Rifleman",  
                "Rifleman",  
                "MAZ_EZM_LDFP_fnc_createRiflemanModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Rifleman (MAAWS)",  
                "Heavy Anti-Tank Rifleman",  
                "MAZ_EZM_LDFP_fnc_createRiflemanHATModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Rifleman (RPG)",  
                "Light Anti-Tank Rifleman",  
                "MAZ_EZM_LDFP_fnc_createRiflemanLATModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Rifleman (PCML)",  
                "Heavy Anti-Tank Rifleman",  
                "MAZ_EZM_LDFP_fnc_createRiflemanHATPCMLModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Squad Leader",  
                "Squad Leader",  
                "MAZ_EZM_LDFP_fnc_createSquadLeadModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Radio Operator",  
                "Radio Operator",  
                "MAZ_EZM_LDFP_fnc_createRadiomanModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenTree,  
                "Survivor",  
                "Survivor",  
                "MAZ_EZM_LDFP_fnc_createUnarmedModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Men (Loyalist)";  

            MAZ_LDFPMenParaTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Men (Loyalist)",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Ammo Bearer",  
                "Ammo Bearer",  
                "MAZ_EZM_LDFP_fnc_createAmmoBearerPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Autorifleman",  
                "Autorifleman",  
                "MAZ_EZM_LDFP_fnc_createAutoriflemanPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Combat Lifesaver",  
                "Combat Lifesaver",  
                "MAZ_EZM_LDFP_fnc_createCombatMedicPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Engineer",  
                "Engineer",  
                "MAZ_EZM_LDFP_fnc_createEngineerPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Grenadier",  
                "Grenadier",  
                "MAZ_EZM_LDFP_fnc_createGrenadierPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Marksman",  
                "Marksman",  
                "MAZ_EZM_LDFP_fnc_createMarksmanPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Rifleman",  
                "Rifleman", 
                "MAZ_EZM_LDFP_fnc_createRiflemanPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Rifleman (LAT)",  
                "Light Anti-Tank Rifleman",  
                "MAZ_EZM_LDFP_fnc_createRiflemanLATPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPMenParaTree,  
                "Squad Leader",  
                "Squad Leader",  
                "MAZ_EZM_LDFP_fnc_createSquadLeadPModule",  
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Planes"; 

            MAZ_LDFPPlanesTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Planes",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPPlanesTree,  
                "A-149 Gryphon",  
                "A-149 Gryphon",  
                "MAZ_EZM_LDFP_fnc_createGryphonModule",  
                "\A3\Air_F_Jets\Plane_Fighter_04\Data\UI\Fighter04_icon_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;         

        comment "Reinforcement";  

            MAZ_LDFPReinforcementTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Reinforcement",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "MH-9 Hummingbird",  
                "Creates a loaded LDF MH-9 Hummingbird",  
                "MAZ_EZM_LDFP_fnc_createReinforcementHummingbirdModule",  
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Offroad",  
                "Creates a loaded LDF Offroad",  
                "MAZ_EZM_LDFP_fnc_createReinforcementOffroadModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Offroad (Covered)",  
                "Creates a loaded LDF Offroad (Covered)",  
                "MAZ_EZM_LDFP_fnc_createReinforcementOffroadCoveredModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Transport Van",  
                "Creates a loaded LDF Transport Van",  
                "MAZ_EZM_LDFP_fnc_createReinforcementVanTransportModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Van",  
                "Creates a loaded LDF Van",  
                "MAZ_EZM_LDFP_fnc_createReinforcementVanModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "WY-55 Czapla",  
                "Creates a loaded LDF WY-55 Czapla",  
                "MAZ_EZM_LDFP_fnc_createReinforcementCzaplaModule",  
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "WY-55 Czapla (Unarmed)",  
                "Creates a loaded LDF WY-55 Czapla (Unarmed)",  
                "MAZ_EZM_LDFP_fnc_createReinforcementCzaplaUnarmedModule",  
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_unarmed_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Zamak",  
                "Creates a loaded LDF Zamak",  
                "MAZ_EZM_LDFP_fnc_createReinforcementZamakCoveredTransportModule",  
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

        comment "Reinforcement (Loyalist)";  

            MAZ_LDFPReinforcementTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Reinforcement (Loyalist)",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "MH-9 Hummingbird",  
                "Creates a loaded LDF MH-9 Hummingbird",  
                "MAZ_EZM_LDFP_fnc_createReinforcementHummingbirdPModule",  
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Offroad",  
                "Creates a loaded LDF Offroad",  
                "MAZ_EZM_LDFP_fnc_createReinforcementOffroadPModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Offroad (Covered)",  
                "Creates a loaded LDF Offroad (Covered)",  
                "MAZ_EZM_LDFP_fnc_createReinforcementOffroadCoveredPModule",  
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Transport Van",  
                "Creates a loaded LDF Transport Van",  
                "MAZ_EZM_LDFP_fnc_createReinforcementVanTransportPModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Van",  
                "Creates a loaded LDF Van",  
                "MAZ_EZM_LDFP_fnc_createReinforcementVanPModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "WY-55 Czapla",  
                "Creates a loaded LDF WY-55 Czapla",  
                "MAZ_EZM_LDFP_fnc_createReinforcementCzaplaPModule",  
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "WY-55 Czapla (Unarmed)",  
                "Creates a loaded LDF WY-55 Czapla (Unarmed)",  
                "MAZ_EZM_LDFP_fnc_createReinforcementCzaplaUnarmedPModule",  
                "\a3\air_f_epb\heli_light_03\data\ui\map_heli_light_03_unarmed_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPReinforcementTree,  
                "Zamak",  
                "Creates a loaded LDF Zamak",  
                "MAZ_EZM_LDFP_fnc_createReinforcementZamakCoveredTransportPModule",  
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Tanks";  

            MAZ_LDFPTankTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Tanks",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTankTree,  
                "AWC 301 Nyx (AT)",  
                "AWC 301 Nyx (AT)",  
                "MAZ_EZM_LDFP_fnc_createATNyxModule",  
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTankTree,  
                "AWC 304 Nyx (Autocannon)",  
                "AWC 304 Nyx (Autocannon)",  
                "MAZ_EZM_LDFP_fnc_create20mmNyxModule",  
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTankTree,  
                "AWC 303 Nyx (Recon)",  
                "AWC 303 Nyx (Recon)",  
                "MAZ_EZM_LDFP_fnc_createReconNyxModule",  
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTankTree,  
                "MBT-52 Kuma",  
                "MBT-52 Kuma",  
                "MAZ_EZM_LDFP_fnc_createKumaModule",  
                "\a3\armor_f_epb\mbt_03\data\ui\map_mbt_03_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Trucks";  
            
            MAZ_LDFPTrucksTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Trucks",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTrucksTree,  
                "Zamak Ammo",  
                "Zamak Ammo",  
                "MAZ_EZM_LDFP_fnc_createZamakAmmoModule",  
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_box_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTrucksTree,  
                "Zamak Fuel",  
                "Zamak Fuel",  
                "MAZ_EZM_LDFP_fnc_createZamakFuelModule",  
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_fuel_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTrucksTree,  
                "Zamak Medical",  
                "Zamak Medical",  
                "MAZ_EZM_LDFP_fnc_createZamakMedicalModule",  
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_medevac_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTrucksTree,  
                "Zamak Repair",  
                "Zamak Repair",  
                "MAZ_EZM_LDFP_fnc_createZamakRepairModule",  
                "\A3\Soft_F_Beta\Truck_02\Data\UI\Map_Truck_02_repair_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTrucksTree,  
                "Zamak Transport",  
                "Zamak Transport",  
                "MAZ_EZM_LDFP_fnc_createZamakTransportModule",  
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTrucksTree,  
                "Zamak Transport (Covered)",  
                "Zamak Transport (Covered)",  
                "MAZ_EZM_LDFP_fnc_createZamakCoveredTransportModule",  
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

        comment "Turrets";  

            MAZ_LDFPTurretTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Turrets",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTurretTree,  
                "AN/MPQ-105 Radar",  
                "AN/MPQ-105 Radar",  
                "MAZ_EZM_LDFP_fnc_createMPQ105Module",  
                "\a3\static_f_sams\radar_system_01\data\ui\radar_system_01_icon_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTurretTree,  
                "M2 HMG",  
                "M2 HMG",  
                "MAZ_EZM_LDFP_fnc_createM2HMGModule",  
                "\a3\static_f\hmg_02\data\ui\icon_hmg_02_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTurretTree,  
                "M2 HMG (Raised)",  
                "M2 HMG (Raised)",  
                "MAZ_EZM_LDFP_fnc_createM2HMGRaisedModule",  
                "a3\static_f_oldman\hmg_02\data\ui\icon_hmg_02_ca.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTurretTree,  
                "MIM-145 Defender",  
                "MIM-145 Defender",  
                "MAZ_EZM_LDFP_fnc_createMIM145Module",  
                "\a3\static_f_sams\sam_system_03\data\ui\sam_system_03_icon_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTurretTree,  
                "Mk6 Mortar",  
                "Mk6 Mortar",  
                "MAZ_EZM_LDFP_fnc_createMk6MortarModule",  
                "\A3\Static_f\Mortar_01\data\UI\map_Mortar_01_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTurretTree,  
                "Static AA Launcher",  
                "Static AA Launcher",  
                "MAZ_EZM_LDFP_fnc_createAALauncherModule",  
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AA_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPTurretTree,  
                "Static AT Launcher",  
                "Static AT Launcher",  
                "MAZ_EZM_LDFP_fnc_createATLauncherModule",  
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AT_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 

        comment "Vans";  
        
            MAZ_LDFPVansTree = [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                "Vans",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddSubCategory;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPVansTree,  
                "Van (Ambulance)",  
                "Van (Ambulance)",  
                "MAZ_EZM_LDFP_fnc_createVanAmbulanceModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_medevac_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPVansTree,  
                "Van (Cargo)",  
                "Van (Cargo)",  
                "MAZ_EZM_LDFP_fnc_createVanCargoModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  
            
            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPVansTree,  
                "Van Transport",  
                "Van Transport",  
                "MAZ_EZM_LDFP_fnc_createVanTransportModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPVansTree,  
                "Van Cargo (MP)",  
                "Van Cargo (MP)",  
                "MAZ_EZM_LDFP_fnc_createVanCargoMPModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;  

            [  
                MAZ_UnitsTree_INDEP,  
                MAZ_LDFPTree,  
                MAZ_LDFPVansTree,  
                "Van Transport (MP)",  
                "Van Transport (MP)",  
                "MAZ_EZM_LDFP_fnc_createVanTransportMPModule",  
                "\a3\Soft_F_Orange\Van_02\Data\UI\Map_Van_02_vehicle_CA.paa"  
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP; 
    };
};

["MAZ_EZM_LDFP_fnc_modules"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;