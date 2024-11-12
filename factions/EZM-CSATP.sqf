if(isNil "MAZ_EZM_Version") exitWith {
    systemChat "Enhanced Zeus Modules is not running!";
    playSound "addItemFailed";
};

if(isNil "MAZ_EZM_fnc_addNewFactionToDynamicFactions") exitWith {
    ["Your version of EZM is incompatible with dynamic factions. Please use the latest version!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

if(!isNil "MAZ_EZM_CSATP") exitWith {
    ["CSAT+ is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_CSATP_Ver = "1.0";
MAZ_EZM_CSATP = true;

comment "CSAT (China) Units"; 

    comment "Anti-Air";	

        MAZ_EZM_CSATP_fnc_createTigris = { 
            private _vehicle = ["O_APC_Tracked_02_AA_F"] call MAZ_EZM_fnc_createVehicle;	
            _vehicle disableTIEquipment true; 

            [ 
                _vehicle, 
                ["Hex",1],  
                ["showTracks",1,"showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle;
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATP_fnc_createTigrisMissile = { 
            private _vehicle = ["O_APC_Tracked_02_AA_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 

            [ 
                _vehicle, 
                ["Hex",1],  
                ["showTracks",1,"showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle;

                _vehicle removeWeaponTurret ["missiles_titan_AA", [0]];
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };

    comment "APCs"; 
    
        MAZ_EZM_CSATP_fnc_createMarid = { 
            private _vehicle = ["O_APC_Wheeled_02_rcws_v2_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 

            [ 
                _vehicle, 
                ["Hex",1],  
                ["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",1,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle;
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _commander; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATP_fnc_createMaridNoTurret = { 
            private _vehicle = ["O_APC_Wheeled_02_rcws_v2_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle animate ["HideTurret",2]; 
            _vehicle lockTurret [[0], true]; 

            [ 
                _vehicle, 
                ["Hex",1],  
                ["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",1,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver] joinSilent _grp; 
                _grp selectLeader _commander; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };


        MAZ_EZM_CSATP_fnc_createBTRK = { 
            private _vehicle = ["O_APC_Tracked_02_cannon_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 

            [ 
                _vehicle, 
                ["Hex",1],  
                ["showTracks",1,"showCamonetHull",1,"showBags",0,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 
            
                private _commander = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _commander; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };
    
    comment "Artillery";
    
        MAZ_EZM_CSATP_fnc_createSochorModule = { 
            private _vehicle = ["O_MBT_02_arty_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            [ 
                _vehicle, 
                ["Hex",1],  
                ["showAmmobox",1,"showCanisters",1,"showCamonetTurret",1,"showCamonetHull",1,"showLog",1]
            ] call BIS_fnc_initVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 

                private _commander = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATP_fnc_createSochorNoCommanderModule = {  
            private _vehicle = ["O_MBT_02_arty_F"] call MAZ_EZM_fnc_createVehicle; 
            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true;
            
            [  
                _vehicle,  
                ["Hex",1],   
                ["showAmmobox",0,"showCanisters",1,"showCamonetTurret",1,"showCamonetHull",1,"showLog",1] 
            ] call BIS_fnc_initVehicle;  

            _vehicle setObjectTextureGlobal [3, ""]; _vehicle lockturret [[0,0],true];  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule;  
                _driver moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule;  
                _gunner moveInGunner _vehicle; 
                
                private _grp = createGroup [east,true];  
                [_driver,_gunner] joinSilent _grp;  
                _grp selectLeader _gunner;  
                _grp setBehaviour "AWARE"; 
            }; 

            _vehicle 
        };  

        MAZ_EZM_CSATP_fnc_createMRLModule = {
            
            private _vehicle = ["I_Truck_02_MRL_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInAny _vehicle; 

                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
                _grp setBehaviour "AWARE"; 
            }; 

            [ 
                _vehicle, 
                ["Opfor",1] 
            ] call BIS_fnc_initVehicle;
        
            _vehicle 
        };

    comment "Boats"; 
    
        MAZ_EZM_CSATP_fnc_createRhibBoatModule = { 
            private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
            
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        }; 
    
        MAZ_EZM_CSATP_fnc_createAssaultBoatModule = {
            private _vehicle = ["O_Boat_Transport_01_F"] call MAZ_EZM_fnc_createVehicle;
            
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createSpeedBoatModule = {
            private _vehicle = ["B_Boat_Armed_01_minigun_F",[
            "a3\boat_f\boat_armed_01\data\boat_armed_01_ext_opfor_co.paa",
            "a3\boat_f\boat_armed_01\data\boat_armed_01_int_opfor_co.paa",
            ""
            ]] call MAZ_EZM_fnc_createVehicle;
            _vehicle setObjectTextureGlobal [2, ""];
            _vehicle removeWeaponTurret ["GMG_40mm", [0]];
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                private _commander = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _commander moveInCommander _vehicle; 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _driver; 
                _vehicle disableTIEquipment true; 
            }; 
            
            _vehicle 
        };

        MAZ_EZM_CSATP_fnc_createSpeedBoatHMGModule = {
            private _vehicle = ["O_Boat_Armed_01_hmg_F"] call MAZ_EZM_fnc_createVehicle;
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                private _commander = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _commander moveInCommander _vehicle; 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _driver; 
                _vehicle disableTIEquipment true; 
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATP_fnc_createSpeedBoatMinigunModule = {
            private _vehicle = ["B_Boat_Armed_01_minigun_F",[
                "a3\boat_f\boat_armed_01\data\boat_armed_01_ext_opfor_co.paa",
                "a3\boat_f\boat_armed_01\data\boat_armed_01_int_opfor_co.paa",
                "a3\boat_f\boat_armed_01\data\boat_armed_01_crows_opfor_co.paa"
            ]] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                private _commander = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _commander moveInCommander _vehicle; 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        };
    
    comment "Cars"; 
    
        MAZ_EZM_CSATP_fnc_createIfritModule = {
            private _vehicle = ["O_MRAP_02_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createIfritHMGModule = {
            
            private _vehicle = ["O_MRAP_02_hmg_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _gunner moveInGunner _vehicle;
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createIfritGMGModule = {
            
            private _vehicle = ["O_MRAP_02_gmg_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _gunner moveInGunner _vehicle;
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createQuadbikeModule = {
            private _vehicle = ["O_Quadbike_01_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _passanger moveinCargo _vehicle; 
                [_driver] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
                [_passanger] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
                private _grp = createGroup [east,true]; 
                [_driver,_passanger] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATP_fnc_createQilinUnarmedModule = {
            private _vehicle = ["O_LSV_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createQilinMinigunModule = { 
            private _vehicle = ["O_LSV_02_armed_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _gunner moveInGunner _vehicle;
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createQilinATModule = { 
            private _vehicle = ["O_LSV_02_AT_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _gunner moveInGunner _vehicle;
            }; 
        
            _vehicle 
        }; 
        
    comment "Drones"; 

        MAZ_EZM_CSATP_fnc_createJinaahLeafletModule = { 
            private _vehicle = ["O_UAV_06_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader; 

            _vehicle setPylonLoadout [1,"Pylon_1Rnd_Leaflets_East_F"];
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createJinaahMedicalModule = { 
            private _vehicle = ["O_UAV_06_medical_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader; 
        
            _vehicle 
        }; 
                
        MAZ_EZM_CSATP_fnc_createTayranModule = { 
            private _vehicle = ["O_UAV_01_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createK40Module = { 
            private _vehicle = ["O_UAV_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader;

            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createKH3AModule = { 
            private _vehicle = ["O_T_UAV_04_CAS_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader;

            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createSaifModule = { 
            private _vehicle = ["O_UGV_01_F"] call MAZ_EZM_fnc_createVehicle;
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader;

            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createSaifRCWSModule = { 
            private _vehicle = ["O_UGV_01_rcws_F"] call MAZ_EZM_fnc_createVehicle;
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader;

            _vehicle 
        }; 
    
    comment "Groups"; 
        
        MAZ_EZM_CSATP_fnc_createSquadModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createAmmoBearerModule', 
                'MAZ_EZM_CSATP_fnc_createCombatMedicModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanModule', 
                'MAZ_EZM_CSATP_fnc_createMarksmanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanLATModule', 
                'MAZ_EZM_CSATP_fnc_createGrenadierModule', 
                'MAZ_EZM_CSATP_fnc_createAutoriflemanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
    
        MAZ_EZM_CSATP_fnc_createPatrolModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createCombatMedicModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanModule', 
                'MAZ_EZM_CSATP_fnc_createMarksmanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 

        MAZ_EZM_CSATP_fnc_createReconSquadModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createReconTeamLeaderModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createReconParamedicModule', 
                'MAZ_EZM_CSATP_fnc_createReconScoutModule', 
                'MAZ_EZM_CSATP_fnc_createReconJTACModule', 
                'MAZ_EZM_CSATP_fnc_createReconScoutATModule',
                'MAZ_EZM_CSATP_fnc_createReconDemoModule',
                'MAZ_EZM_CSATP_fnc_createReconMarksmanModule'
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATP_fnc_createSentryModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createRiflemanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATP_fnc_createAntiAirTeamModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createAmmoBearerModule', 
                'MAZ_EZM_CSATP_fnc_createMissileSpecAAModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATP_fnc_createAntiTankTeamModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createAmmoBearerModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanLATModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATP_fnc_createMarksmanTeamModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
            private _grp = group _squadLead; 
            _squadLead addPrimaryWeaponItem "optic_DMS"; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createSquadLeadModule' 
            ]; 
            
            _grp setBehaviour "AWARE"; 
        }; 

        MAZ_EZM_CSATP_fnc_createSniperTeamModule = {  
            private _squadLead = call MAZ_EZM_CSATP_fnc_createReconSniperModule;  
            private _grp = group _squadLead;  
            _squadLead addPrimaryWeaponItem "optic_DMS";  
            {  
                private _unit = call (missionNamespace getVariable _x);  
                [_unit] joinSilent _grp;  
            }forEach [  
                'MAZ_EZM_CSATP_fnc_createReconSpotterModule'  
            ];  
            
            _grp setBehaviour "AWARE";  
        };  

    comment "Compositions";

        MAZ_EZM_CSATP_fnc_createCache1Module = {
            
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
            
            private _vehicle = createVehicle ["Land_Pallet_F",[24583.7,19262.5,0.00658536],[],0,"CAN_COLLIDE"];
            _vehicle setPosWorld [24583.7,19262.5,3.28107];
            _vehicle setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];

            _item25 = createVehicle ["Box_T_East_Ammo_F",[24583.2,19262.6,0.178298],[],0,"CAN_COLLIDE"];
            _item25 setPosWorld [24583.2,19262.6,3.63531];
            _item25 setVectorDirAndUp [[1,0.000220732,0],[0,0,1]];
            _item25 = [_item25] call BIS_fnc_replaceWithSimpleObject;
            [_item25, _vehicle] call BIS_fnc_attachToRelative;

            _item26 = createVehicle ["Box_T_East_Wps_F",[24583.4,19262.2,0.239546],[],0,"CAN_COLLIDE"];
            _item26 setPosWorld [24583.5,19262,3.53942];
            _item26 setVectorDirAndUp [[0,-1,0],[0,0,1]];
            _item26 = [_item26] call BIS_fnc_replaceWithSimpleObject;
            [_item26, _vehicle] call BIS_fnc_attachToRelative;
            
            _item29 = createVehicle ["Box_T_East_Wps_F",[24583.5,19262,0.512213],[],0,"CAN_COLLIDE"];
            _item29 setPosWorld [24583.5,19262,3.87547];
            _item29 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
            _item29 = [_item29] call BIS_fnc_replaceWithSimpleObject;
            [_item29, _vehicle] call BIS_fnc_attachToRelative;

            _item30 = createVehicle ["Box_T_East_Ammo_F",[24583.9,19262.4,0.269096],[],0,"CAN_COLLIDE"];
            _item30 setPosWorld [24583.9,19262.6,3.64146];
            _item30 setVectorDirAndUp [[0.999995,0.00322254,0],[0,0,1]];
            _item30 = [_item30] call BIS_fnc_replaceWithSimpleObject;
            [_item30, _vehicle] call BIS_fnc_attachToRelative;

            _item43 = createVehicle ["Box_East_WpsLaunch_F",[24583.7,19263,0.20602],[],0,"CAN_COLLIDE"];
            _item43 setPosWorld [24583.7,19263,3.52767];
            _item43 setVectorDirAndUp [[0,1,0],[0,0,1]];
            _item43 setObjectTextureGlobal [0,"a3\supplies_f_exp\ammoboxes\data\ammobox_signs_opfor_ca.paa"]; 
            _item43 setObjectTextureGlobal [1,"a3\supplies_f_exp\ammoboxes\data\box_t_east_wps_f_co.paa"];
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
        
            [_item43] call MAZ_EZM_fnc_cacheExplodeOnExplosiveDamage;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
            [_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

            _vehicle setpos _pos;
            
            _vehicle
        };

        MAZ_EZM_CSATP_fnc_createCache2Module = {
            
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
            
            _vehicle = createVehicle ["Land_Pallet_F",[24587.7,19262.5,0.00657558],[],0,"CAN_COLLIDE"];
            _vehicle setPosWorld [24587.7,19262.5,3.28107];
            _vehicle setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
                

            _item16 = createVehicle ["Weapon_arifle_CTAR_blk_F",[24587.5,19262.2,0.532802],[],0,"CAN_COLLIDE"];
            _item16 setPosWorld [24587.5,19262.2,3.70695];
            _item16 setVectorDirAndUp [[-0.243731,0.969843,0],[0,0,1]];
            [_item16, _vehicle] call BIS_fnc_attachToRelative;
            _item16 setDamage 1;

            _item17 = createVehicle ["Weapon_srifle_DMR_07_blk_F",[24587.9,19262,0.536677],[],0,"CAN_COLLIDE"];
            _item17 setPosWorld [24587.9,19262,3.71141];
            _item17 setVectorDirAndUp [[-0.0391472,0.999233,-4.28914e-005],[-0.00129824,-9.37858e-005,-0.999999]];
            [_item17, _vehicle] call BIS_fnc_attachToRelative;
            _item17 setDamage 1;

            _item19 = createVehicle ["Box_T_East_Ammo_F",[24587.2,19262.8,0.172966],[],0,"CAN_COLLIDE"];
            _item19 setPosWorld [24587.15,19262.8,3.62947];
            _item19 setVectorDirAndUp [[0,-1,0],[0,0,1]];
            _item19 = [_item19] call BIS_fnc_replaceWithSimpleObject;
            [_item19, _vehicle] call BIS_fnc_attachToRelative;

            _item20 = createVehicle ["Box_T_East_Wps_F",[24587.9,19262.6,0.232723],[],0,"CAN_COLLIDE"];
            _item20 setPosWorld [24587.9,19262.7,3.53942];
            _item20 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
            _item20 = [_item20] call BIS_fnc_replaceWithSimpleObject;
            [_item20, _vehicle] call BIS_fnc_attachToRelative;

            _item23 = createVehicle ["Box_T_East_Wps_F",[24587.9,19262.7,0.514064],[],0,"CAN_COLLIDE"];
            _item23 setPosWorld [24587.9,19262.7,3.87547];
            _item23 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
            _item23 = [_item23] call BIS_fnc_replaceWithSimpleObject;
            [_item23, _vehicle] call BIS_fnc_attachToRelative;

            _item15 = createVehicle ["Box_T_East_WpsSpecial_F",[24587.7,19262.2,0.157008],[],0,"CAN_COLLIDE"];
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

        MAZ_EZM_CSATP_fnc_createDeadSoldierModule = {
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
            
            private _vehicle = createVehicle ["O_Soldier_F",[24602.4,19234.3,2.38419e-007],[],0,"CAN_COLLIDE"];
            _vehicle setUnitLoadout [[],[],[],["U_O_CombatUniform_ocamo",[["FirstAidKit",1],["Chemlight_red",1,1]]],["V_HarnessO_brn",[]],[],"H_HelmetO_ocamo","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];

            private _animData = selectRandom [
                ["KIA_gunner_static_low01",[24602.4,19234.4,3.19144],[24603.4,19234.9,3.20104],[24601.7,19235,3.195]],
                ["KIA_gunner_standup01",[24602.4,19234.4,3.19144],[24602.9,19233.5,3.2036],[24602.4,19234.3,3.19136]],
                ["KIA_driver_boat01",[24602.4,19234.4,3.19144],[24603,19235.2,3.19],[24602.8,19234.5,3.195]],
                ["KIA_passenger_boat_holdleft",[24602.5,19234.4,3.19144],[24603,19235.1,3.19896],[24602.8,19234.4,3.195]]
            ];
            
            _animData params ["_anim","_unitPos","_gunPos","_bloodPos"];
            [_vehicle,_anim] remoteExec ['switchMove',0,true];
            _vehicle disableAI "ALL";  
            _vehicle setCaptive true; 
            _vehicle setSpeaker "NoVoice"; 
            _vehicle allowDamage false;
            private _face = selectRandom ["AsianHead_A3_01","AsianHead_A3_02","AsianHead_A3_03","AsianHead_A3_04","AsianHead_A3_05","AsianHead_A3_06","AsianHead_A3_07"];
            _vehicle setface _face;
            _vehicle setPosWorld _unitPos;
            _vehicle setVectorDirAndUp [[0.965509,-0.26037,0],[0,0,1]];
            _vehicle setDir (random 359);
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
            [_vehicle] call MAZ_EZM_fnc_addObjectToInterface;
            [_vehicle] call MAZ_EZM_fnc_ignoreWhenCleaning;

            _vehicle spawn {
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

            private _gun = createVehicle ["Weapon_arifle_CTAR_blk_F",[24603.4,19234.9,0.0110364],[],0,"CAN_COLLIDE"];
            _gun setPosWorld _gunPos;
            _gun setDir (random 90);
            [_gun,_vehicle] call BIS_fnc_attachToRelative;

            private _blood = createVehicle ["BloodSplatter_01_Medium_New_F",[24601.7,19235,0],[],0,"CAN_COLLIDE"];
            _blood setPosWorld _bloodPos;
            _blood setVectorDirAndUp [[0,1,0],[0,0,1]];
            _blood setObjectTextureGlobal [0,"a3\props_f_orange\humanitarian\garbage\data\bloodsplatter_medium_fresh_ca.paa"];
            _blood setDir (random 359);
            [_blood, _vehicle] call BIS_fnc_attachToRelative;

            _vehicle setpos _pos;

            _vehicle
        }; 

        MAZ_EZM_CSATP_fnc_createOpenedTaruTransportPodModule = { 
            private _vehicle = ["Land_Pod_Heli_Transport_04_covered_F"] call MAZ_EZM_fnc_createVehicle;

            _vehicle animateDoor ["Door_6_source", 1];
    
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createOpenedTaruBenchPodModule = { 
            
            private _vehicle = ["Land_Pod_Heli_Transport_04_bench_F"] call MAZ_EZM_fnc_createVehicle;
    
            _vehicle 
        }; 

    comment "Groups (Urban)";

        MAZ_EZM_CSATP_fnc_createSquadUrbanModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
    
        MAZ_EZM_CSATP_fnc_createPatrolUrbanModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATP_fnc_createSentryUrbanModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATP_fnc_createAntiAirTeamUrbanModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createMissileSpecAAUrbanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATP_fnc_createAntiTankTeamUrbanModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule', 
                'MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATP_fnc_createMarksmanTeamUrbanModule = { 
            private _squadLead = call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
            private _grp = group _squadLead; 
            _squadLead addPrimaryWeaponItem "optic_DMS"; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule' 
            ]; 
            
            _grp setBehaviour "AWARE"; 
        }; 
        
    comment "Helicopters";
        
        MAZ_EZM_CSATP_fnc_createTaruModule = { 
            private _vehicle = ["O_Heli_Transport_04_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTaruAmmoModule = { 
            private _vehicle = ["O_Heli_Transport_04_ammo_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then {
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTaruBenchModule = {
            private _vehicle = ["O_Heli_Transport_04_bench_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTaruCargoModule = {
            private _vehicle = ["O_Heli_Transport_04_box_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTaruFuelModule = {
            private _vehicle = ["O_Heli_Transport_04_fuel_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTaruMedicalModule = {
            private _vehicle = ["O_Heli_Transport_04_medevac_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then {
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTaruRepairModule = {
            private _vehicle = ["O_Heli_Transport_04_repair_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTaruTransportModule = {
            private _vehicle = ["O_Heli_Transport_04_covered_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTaruKajmanModule = {
            private _vehicle = ["O_Heli_Attack_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _gunner moveInGunner _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_gunner] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createOrcaUnarmedModule = {
            private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

            [_vehicle,"Opfor"] call bis_fnc_initVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _gunner moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_gunner] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createOrcaModule = {
            private _vehicle = ["O_Heli_Light_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                _gunner moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_gunner] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

    comment "Men"; 
    
        MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit = { 
            params ["_unit"]; 
            sleep 0.5; 

            private _CSATPVoice = [
                "Male03CHI",
                "Male01CHI",
                "Male02CHI"
            ];

            [_unit,(selectRandom _CSATPVoice)] remoteExec ['setSpeaker']; 
            
            private _CSATPHeads = [ 
                "AsianHead_A3_01",
                "AsianHead_A3_02",
                "AsianHead_A3_03",
                "AsianHead_A3_04", 
                "AsianHead_A3_05", 
                "AsianHead_A3_06", 
                "AsianHead_A3_07",
                "CamoHead_Asian_02_F",
                "CamoHead_Asian_03_F",
                "CamoHead_Asian_01_F"
            ]; 

            [_unit,(selectRandom _CSATPHeads)] remoteExec ['setFace',0,_unit]; 
        
        }; 
        
        MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit = { 
            params ["_unit"]; 
            private _58Ammo = "30Rnd_580x42_Mag_F";  
            private _pWeapon = selectRandom [ ["arifle_CTAR_blk_F", _58Ammo],["arifle_CTAR_hex_F", _58Ammo] ]; 
                        
            _pWeapon 
        }; 

        MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit = { 
            params ["_unit"]; 
            private _58Ammo = "30Rnd_580x42_Mag_F";  
            private _pWeapon = selectRandom [ ["arifle_CTAR_blk_F", _58Ammo] ]; 
                        
            _pWeapon 
        }; 
        
        MAZ_EZM_CSATP_fnc_addCSATPBackpack = { 
            params ["_unit"]; 
            private _randomBackpack = selectRandom ["B_FieldPack_ocamo"]; 
            _unit addBackpackGlobal _randomBackpack; 
        }; 
        
        MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit = { 
            params ["_unit"]; 
            private _CSATPUniforms = ["U_O_CombatUniform_ocamo"]; 
            private _CSATPVests = ["V_HarnessO_brn","V_TacVest_khk"]; 
            private _CSATPHeadgear = ["H_HelmetLeaderO_ocamo","H_HelmetO_ocamo","H_HelmetSpecO_ocamo"]; 
            _unit setVariable ["BIS_enableRandomization", false];
            removeGoggles _unit;
            _unit forceAddUniform (selectRandom _CSATPUniforms); 
            _unit setObjectTextureGlobal [2,"\a3\air_f_exp\VTOL_02\Data\VTOL_02_signs_CA.paa"];
            _unit addVest (selectRandom _CSATPVests); 
            _unit addHeadgear (selectRandom _CSATPHeadgear); 
        }; 

        MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit = {
            params ["_unit"];
            _unit addEventHandler ["Killed",{
                params ["_unit", "_killer", "_instigator", "_useEffects"];
                _unit spawn {
                    private _RadioSounds = selectRandom ["\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_01_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_01_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_01_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_01_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_02_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_02_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_02_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_03_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_03_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_03_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_03_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_04_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_04_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_04_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_04_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_05_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_05_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_05_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_05_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_06_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_06_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_06_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_06_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_07_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_07_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_07_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_07_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_08_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_08_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_08_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_08_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_09_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_09_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_09_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_09_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_10_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_10_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_10_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_10_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_11_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_11_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_11_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_11_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_12_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_12_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_12_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_12_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_13_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_13_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_13_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_13_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_14_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_14_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_14_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_14_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_15_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_15_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_15_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_15_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_16_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_16_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_16_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_16_Chinese04_Processed.ogg"];
                    private _randomNumber = [8, 20] call BIS_fnc_randomNum;
                    sleep _randomNumber;
                    playSound3D [_RadioSounds, _this, false, getPosASL _this, 2, 1, 15];
                    sleep _randomNumber;
                    playSound3D [_RadioSounds, _this, false, getPosASL _this, 2, 1, 15];
                };
            }];
        };
        
        MAZ_EZM_CSATP_fnc_createAmmoBearerModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createAutoriflemanModule = { 
            private _unit = [east,"O_T_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            private _M58Ammo = selectRandom ["100Rnd_580x42_Mag_F","100Rnd_580x42_Mag_Tracer_F"];
            private _M58AmmoHex = selectRandom ["100Rnd_580x42_hex_Mag_F","100Rnd_580x42_hex_Mag_Tracer_F"]; 
            private _pMachineGun = selectRandom [ ["arifle_CTARS_blk_F",_M58Ammo],["arifle_CTARS_hex_F",_M58AmmoHex] ];  
            [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[""]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createHeavyGunnerModule = { 
            private _unit = [east,"O_T_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _M93Ammo = selectRandom ["150Rnd_93x64_Mag"]; 
            private _pMachineGun = selectRandom [ ["MMG_01_hex_F",_M93Ammo],["MMG_01_tan_F",_M93Ammo] ];  
            [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createCombatMedicModule = { 
            private _unit = [east,"O_T_Medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addItemToBackpack "Medikit"; 
            for "_i" from 0 to 4 do { 
                _unit addItemToBackpack "FirstAidKit"; 
            }; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createCrewmanModule = { 
            private _unit = [east,"O_T_Crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            removeHeadgear _unit; 
            removevest _unit; 
            removeheadgear _unit; 
            _unit addHeadgear "H_Tank_black_F"; 
            _unit addVest "V_TacVest_khk"; 
            _unit addItemToVest "ToolKit"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],[]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createEngineerModule = { 
            private _unit = [east,"O_T_Engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit addItemToBackpack "Toolkit";
            _unit
        }; 
        
        MAZ_EZM_CSATP_fnc_createSquadLeadModule = { 
            private _unit = [east,"O_T_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit;
            _unit addWeapon "Laserdesignator_02"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit   
        }; 
        
        MAZ_EZM_CSATP_fnc_createGrenadierModule = { 
            private _unit = [east,"O_T_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            _unit addVest "V_HarnessOGL_brn";
            private _pGrenadier = selectRandom ["arifle_CTAR_GL_blk_F","arifle_CTAR_GL_hex_F"]; 
            [_unit,[_pGrenadier,["30Rnd_580x42_Mag_F",5],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createMarksmanModule = { 
            private _unit = [east,"O_T_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            private _pSniper = selectRandom ["srifle_DMR_07_blk_F","srifle_DMR_07_hex_F"]; 
            [_unit,[_pSniper,["20Rnd_650x39_Cased_Mag_F",5],["optic_Arco_blk_F"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createSharpshooterModule = { 
            private _unit = [east,"O_T_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            private _pSniper = selectRandom ["srifle_DMR_05_hex_F","srifle_DMR_05_blk_F"]; 
            [_unit,[_pSniper,["10Rnd_93x64_DMR_05_Mag",5],["optic_DMS"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        };
        
        MAZ_EZM_CSATP_fnc_createMissileSpecAAModule = { 
            private _unit = [east,"O_T_Soldier_AA_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],["launch_O_Titan_F",["Titan_AA",2]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createRiflemanModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createRiflemanLightModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            _unit forceAddUniform "U_O_officer_noInsignia_hex_F";
            _unit addVest "V_TacVest_brn";
            _unit addHeadgear "H_MilCap_ocamo";
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;

            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createRiflemanLATModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _pRPG = selectRandom ["RPG32_F"];
            private _pAT = selectRandom [ ["launch_RPG32_F",_pRPG]]; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createRiflemanHATModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _pVorona = selectRandom ["Vorona_HEAT"]; 
            private _pAT = selectRandom [ ["launch_O_Vorona_brown_F",_pVorona]]; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["",[""]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createMissileSpecATModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],["launch_O_Titan_short_F",["Titan_AT",2]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createOfficerModule = { 
            private _unit = [east,"O_T_Officer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit;
            _unit addUniform "U_O_OfficerUniform_ocamo";
            _unit addMagazines ["6Rnd_45ACP_Cylinder", 3];
            _unit addWeapon "hgun_Pistol_heavy_02_F";
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit addHeadgear "H_Beret_CSAT_01_F";
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createRadiomanModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            _unit addBackpack "B_RadioBag_01_hex_F"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createHelicopterPilotModule = { 
            private _unit = [east,"O_helipilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit;
            _unit addMagazine "30Rnd_9x21_Mag_SMG_02_Tracer_Green";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            _unit addWeapon "SMG_02_F";
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createPilotModule = { 
            private _unit = [east,"O_pilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit;
            _unit addMagazine "30Rnd_9x21_Mag_SMG_02_Tracer_Green";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            _unit addWeapon "SMG_02_F";
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createFighterPilotModule = { 
            private _unit = [east,"O_Fighter_Pilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit;
            _unit addMagazine "30Rnd_9x21_Mag_SMG_02_Tracer_Green";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createHelicopterCrewModule = { 
            private _unit = [east,"O_Helicrew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            _unit addMagazine "30Rnd_9x21_Mag_SMG_02_Tracer_Green";
            _unit addWeapon "SMG_02_F";
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createSurvivorModule = { 
            private _unit = [east,"O_T_Soldier_unarmed_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            removeVest _unit; 
            removeHeadgear _unit; 
            [_unit,""] remoteExec ["switchMove"];
        
            _unit 
        }; 

    comment "Men (Special Forces)";

        MAZ_EZM_CSATP_fnc_createDiverModule = { 
            private _unit = [east,"O_T_Diver_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            _unit setUnitLoadout [["arifle_SDAR_F","","","",["20Rnd_556x45_UW_mag",20],[],""],[],["hgun_Rook40_F","muzzle_snds_L","","",["16Rnd_9x21_Mag",16],[],""],["U_O_Wetsuit",[["FirstAidKit",1],["30Rnd_556x45_Stanag_green",4,30],["20Rnd_556x45_UW_mag",3,20],["16Rnd_9x21_Mag",2,16],["SmokeShellRed",2,1]]],["V_RebreatherIR",[]],["B_FieldPack_blk",[]],"","G_O_Diving",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]]; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            _unit addHeadgear "H_HelmetSpecO_blk";
            _unit
        };

        MAZ_EZM_CSATP_fnc_createReconDemoModule = { 
            private _unit = [east,"O_T_Recon_Exp_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit addItemToBackpack "Toolkit";
            _unit
        }; 

        MAZ_EZM_CSATP_fnc_createReconJTACModule = { 
            private _unit = [east,"O_recon_JTAC_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            _unit addVest "V_HarnessOGL_brn";
            private _pGrenadier = selectRandom ["arifle_CTAR_GL_blk_F","arifle_CTAR_GL_hex_F"]; 
            [_unit,[_pGrenadier,["30Rnd_580x42_Mag_F",5],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createReconMarksmanModule = { 
            private _unit = [east,"O_recon_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            private _pSniper = selectRandom ["srifle_DMR_04_Tan_F","srifle_DMR_04_F"]; 
            [_unit,[_pSniper,["10Rnd_127x54_Mag",5],["optic_DMS_weathered_Kir_F"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F"; 
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createReconParaMedicModule = { 
            private _unit = [east,"O_recon_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit
        }; 

        MAZ_EZM_CSATP_fnc_createReconScoutModule = { 
            private _unit = [east,"O_recon_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit
        }; 

        MAZ_EZM_CSATP_fnc_createReconScoutATModule = { 
            private _unit = [east,"O_recon_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            
            private _pRPG = selectRandom ["RPG32_F"];
            private _pAT = selectRandom [ ["launch_RPG32_F",_pRPG]]; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createReconTeamLeaderModule = { 
            private _unit = [east,"O_recon_TL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit
        }; 

        MAZ_EZM_CSATP_fnc_createReconSniperModule = { 
            private _unit = [east,"O_sniper_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            _unit setUnitLoadout [["srifle_GM6_camo_F","","","optic_LRPS",["5Rnd_127x108_Mag",5],[],""],[],["hgun_Rook40_F","muzzle_snds_L","","",["16Rnd_9x21_Mag",16],[],""],["U_O_GhillieSuit",[["FirstAidKit",1],["5Rnd_127x108_Mag",2,5],["SmokeShell",1,1]]],["V_Chestrig_khk",[["5Rnd_127x108_APDS_Mag",2,5],["16Rnd_9x21_Mag",2,16],["ClaymoreDirectionalMine_Remote_Mag",1,1],["APERSTripMine_Wire_Mag",1,1],["SmokeShellRed",1,1],["SmokeShellOrange",1,1],["SmokeShellYellow",1,1],["Chemlight_red",2,1],["5Rnd_127x108_Mag",1,5]]],[],"","",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_removeCSATPGogglesToUnit;
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit addWeapon "Laserdesignator_02";
            _unit
        }; 

        MAZ_EZM_CSATP_fnc_createReconSpotterModule = { 
            private _unit = [east,"O_spotter_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_Arco_blk_F"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addUniform "U_O_GhillieSuit";
            _unit addWeapon "Laserdesignator_02";
            [_unit,"O_NVGoggles_hex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit
        }; 

    comment "Men (Urban)"; 
        
        MAZ_EZM_CSATP_fnc_addCSATPUrbanBackpack = { 
            params ["_unit"]; 
            private _randomBackpack = selectRandom ["B_FieldPack_oucamo"]; 
            _unit addBackpackGlobal _randomBackpack; 
        }; 
        
        MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit = { 
            params ["_unit"]; 
            private _CSATPUniforms = ["U_O_CombatUniform_oucamo"]; 
            private _CSATPVests = ["V_HarnessO_gry","V_TacVest_blk"]; 
            private _CSATPHeadgear = ["H_HelmetO_oucamo","H_HelmetLeaderO_oucamo"]; 
            removeGoggles _unit;
            _unit forceAddUniform (selectRandom _CSATPUniforms); 
            _unit addVest (selectRandom _CSATPVests); 
            _unit addHeadgear (selectRandom _CSATPHeadgear); 
        }; 
        
        MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanBackpack; 
            
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule = { 
            private _unit = [east,"O_T_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            private _UM58Ammo = selectRandom ["100Rnd_580x42_Mag_F","100Rnd_580x42_Mag_Tracer_F"]; 
            private _pUMachineGun = selectRandom [ ["arifle_CTARS_blk_F",_UM58Ammo] ];  
            [_unit,[_pUMachineGun select 0,[_pUMachineGun select 1,2],[""]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createHeavyGunnerUrbanModule = { 
            private _unit = [east,"O_T_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            private _UM93Ammo = selectRandom ["150Rnd_93x64_Mag"]; 
            private _pUMachineGun = selectRandom [ ["MMG_01_tan_F",_UM93Ammo] ];  
            [_unit,[_pUMachineGun select 0,[_pUMachineGun select 1,2],[]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule = { 
            private _unit = [east,"O_T_Medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanBackpack; 
            
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addItemToBackpack "Medikit"; 
            for "_i" from 0 to 4 do { 
                _unit addItemToBackpack "FirstAidKit"; 
            }; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createCrewmanUrbanModule = { 
            private _unit = [east,"O_T_Crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            removeHeadgear _unit; 
            removevest _unit; 
            removeheadgear _unit; 
            _unit addHeadgear "H_Tank_black_F"; 
            _unit addVest "Vest_V_TacVest_blk"; 
            _unit addItemToVest "ToolKit"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],[]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createEngineerUrbanModule = { 
            private _unit = [east,"O_T_Engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule = { 
            private _unit = [east,"O_T_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit;
            _unit addWeapon "Binocular"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit   
        }; 
        
        MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule = { 
            private _unit = [east,"O_T_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            private _pUGrenadier = selectRandom ["arifle_CTAR_GL_blk_F"]; 
            [_unit,[_pUGrenadier,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule = { 
            private _unit = [east,"O_T_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            private _pUMarksman = selectRandom ["srifle_DMR_07_blk_F"]; 
            [_unit,[_pUmarksman,["20Rnd_650x39_Cased_Mag_F",7],["optic_Arco_blk_F"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createSharpshooterUrbanModule = { 
            private _unit = [east,"O_T_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            private _pUSharpshooter = selectRandom ["srifle_DMR_05_blk_F"]; 
            [_unit,[_pUSharpshooter,["10Rnd_93x64_DMR_05_Mag",6],["optic_DMS"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        };
        
        MAZ_EZM_CSATP_fnc_createMissileSpecAAUrbanModule = { 
            private _unit = [east,"O_T_Soldier_AA_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanBackpack; 
            
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],["launch_O_Titan_F",["Titan_AA",2]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanBackpack; 
            
            private _pRPG = selectRandom ["RPG32_F"];
            private _pAT = selectRandom [ ["launch_RPG32_F",_pRPG]]; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATP_fnc_createRiflemanHATUrbanModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanBackpack; 
            
            private _pVorona = selectRandom ["Vorona_HEAT"]; 
            private _pAT = selectRandom [ ["launch_O_Vorona_brown_F",_pVorona]]; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["",[""]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createMissileSpecATUrbanModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanBackpack; 
            
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],["launch_O_Titan_short_F",["Titan_AT",2]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createRadiomanUrbanModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            
            _unit addBackpack "B_RadioBag_01_oucamo_F"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATP_fnc_getCSATPUrbanWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_urb_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATP_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATP_fnc_createUnarmedUrbanModule = { 
            private _unit = [east,"O_T_Soldier_unarmed_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATP_fnc_addCSATPUrbanUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATP_fnc_addCSATPIdentitiesToUnit; 
            removeVest _unit; 
            removeHeadgear _unit; 
            [_unit,""] remoteExec ["switchMove"]; 
            _unit 
        }; 
    
    comment "Reinforcement"; 
    
        MAZ_EZM_CSATP_fnc_createReinforcementZamakCoveredTransportModule = { 
            private _vehicle = ["O_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger16 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                private _passanger15 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule; 
                private _passanger14 = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger13 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanModule; 
                private _passanger12 = [] call MAZ_EZM_CSATP_fnc_createEngineerModule; 
                private _passanger11 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger9 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger8 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATP_fnc_createAmmoBearerModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                
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
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
                (group _passanger1) setBehaviour "AWARE"; 
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
                (group _passanger16) setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementTempestTransportModule = { 
            private _vehicle = ["O_Truck_03_covered_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger16 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                private _passanger15 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule; 
                private _passanger13 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanModule; 
                private _passanger11 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger9 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger8 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger7 moveInCargo _vehicle; 
                _passanger8 moveInCargo _vehicle; 
                _passanger9 moveInCargo _vehicle; 
                _passanger10 moveInCargo _vehicle; 
                _passanger11 moveInCargo _vehicle; 
                _passanger13 moveInCargo _vehicle; 
                _passanger15 moveInCargo _vehicle; 
                _passanger16 moveInCargo _vehicle; 
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16);
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementTaruModule = { 
            private _vehicle = ["O_Heli_Transport_04_covered_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                private _passanger16 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                private _passanger15 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule;
                private _passanger13 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanModule;  
                private _passanger11 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger9 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger8 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule;  
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                
                _pilot moveInDriver _vehicle; 
                _copilot moveInAny _vehicle;
                _copilot2 moveInAny _vehicle;
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

                [_copilot,_copilot2] joinSilent (group _pilot); 
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementOrcaModule = { 
            private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

            [_vehicle,"Opfor"] call bis_fnc_initVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule;  
                private _passanger8 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATP_fnc_createAmmoBearerModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                
                _pilot moveInDriver _vehicle; 
                _copilot moveInAny _vehicle;
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle; 
                _passanger7 moveInCargo _vehicle; 
                _passanger8 moveInCargo _vehicle; 

                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
                
                [_copilot] joinSilent (group _pilot); 
        
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementQilinUnarmedModule = { 
            private _vehicle = ["O_LSV_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATP_fnc_createAmmoBearerModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle;
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent (group _passanger1); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementRhibModule = { 
            
            private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createAmmoBearerModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATModule; 
                private _passanger6 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle;
                _passanger7 moveInCargo _vehicle;
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7] joinSilent (group _passanger1); 
            }; 
        
            _vehicle 
        }; 

    comment "Reinforcement (Urban)"; 
    
        MAZ_EZM_CSATP_fnc_createReinforcementZamakCoveredTransportUrbanModule = { 
            private _vehicle = ["O_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger16 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                private _passanger15 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule; 
                private _passanger14 = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger13 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule; 
                private _passanger12 = [] call MAZ_EZM_CSATP_fnc_createEngineerUrbanModule; 
                private _passanger11 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger9 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger8 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                
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
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementTempestTransportUrbanModule = { 
            private _vehicle = ["O_Truck_03_covered_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger16 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                private _passanger15 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule; 
                private _passanger13 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule; 
                private _passanger11 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger9 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger8 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger7 moveInCargo _vehicle; 
                _passanger8 moveInCargo _vehicle; 
                _passanger9 moveInCargo _vehicle; 
                _passanger10 moveInCargo _vehicle; 
                _passanger11 moveInCargo _vehicle; 
                _passanger13 moveInCargo _vehicle; 
                _passanger15 moveInCargo _vehicle; 
                _passanger16 moveInCargo _vehicle; 
            
                [_passanger1,_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
            
                [_passanger16,_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementTaruUrbanModule = { 
            private _vehicle = ["O_Heli_Transport_04_covered_F"] call MAZ_EZM_fnc_createVehicle;

            [_vehicle,"Black"] call bis_fnc_initVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                private _copilot2 = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                private _passanger16 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                private _passanger15 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule;
                private _passanger13 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule;  
                private _passanger11 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger9 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger8 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule;  
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                
                _pilot moveInDriver _vehicle; 
                _copilot moveInAny _vehicle;
                _copilot2 moveInAny _vehicle;
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
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
            
                [_copilot,_copilot2] joinSilent (group _pilot); 
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementOrcaUrbanModule = { 
            private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then {
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule; 
                private _copilot = [] call MAZ_EZM_CSATP_fnc_createHelicopterPilotModule;  
                private _passanger8 = [] call MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                
                _pilot moveInDriver _vehicle; 
                _copilot moveInAny _vehicle;
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle; 
                _passanger7 moveInCargo _vehicle; 
                _passanger8 moveInCargo _vehicle; 

                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
            
                [_copilot] joinSilent (group _pilot);  
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementQilinUnarmedUrbanModule = { 
            private _vehicle = ["O_LSV_02_unarmed_F",["a3\soft_f_exp\lsv_02\data\csat_lsv_01_black_co.paa","a3\soft_f_exp\lsv_02\data\csat_lsv_02_black_co.paa","a3\soft_f_exp\lsv_02\data\csat_lsv_03_black_co.paa"]] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle;

                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent (group _passanger1); 
            }; 

            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createReinforcementRhibUrbanModule = { 
            private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule; 
                private _passanger4 = [] call MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule; 
                private _passanger2 = [] call MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule; 
                private _passanger1 = [] call MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle;
                _passanger7 moveInCargo _vehicle;
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7] joinSilent (group _passanger1); 
            }; 
        
            _vehicle 
        }; 
        
    comment "Planes";
        
        MAZ_EZM_CSATP_fnc_createNeophronCASModule = { 
            private _vehicle = ["O_Plane_CAS_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createBuzzardCASModule = { 
            private _vehicle = ["I_Plane_Fighter_03_dynamicLoadout_F",[
                "a3\Air_F_Gamma\Plane_Fighter_03\Data\Plane_Fighter_03_body_1_brownhex_CO.paa",
                "a3\Air_F_Gamma\Plane_Fighter_03\Data\Plane_Fighter_03_body_2_brownhex_CO.paa"
            ]] call MAZ_EZM_fnc_createVehicle;
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createFighterPilotModule; 
                _pilot moveInDriver _vehicle; 

                private _grp = createGroup [east,true]; 
                [_pilot] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createShikraModule = { 
            private _vehicle = ["O_Plane_Fighter_02_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createFighterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createVTOLInfantryModule = { 
            private _vehicle = ["O_T_VTOL_02_infantry_F"] call MAZ_EZM_fnc_createVehicle;
            [_vehicle,"Hex"] call bis_fnc_initVehicle;
            _vehicle allowCrewInImmobile true;
            
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createFighterPilotModule; 
                _pilot moveInDriver _vehicle; 

                private _copilot = [] call MAZ_EZM_CSATP_fnc_createFighterPilotModule; 
                _copilot moveInGunner _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createVTOLVehicleModule = { 
            private _vehicle = ["O_T_VTOL_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle;
            [_vehicle,"Hex"] call bis_fnc_initVehicle;
            _vehicle allowCrewInImmobile true;

            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATP_fnc_createFighterPilotModule; 
                _pilot moveInDriver _vehicle;

                private _copilot = [] call MAZ_EZM_CSATP_fnc_createFighterPilotModule; 
                _copilot moveInGunner _vehicle;  
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

    comment "Tanks"; 
    
        MAZ_EZM_CSATP_fnc_createVarsukModule = { 
            private _vehicle = ["O_MBT_02_cannon_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            [ 
                _vehicle, 
                ["Hex",1],  
                ["showCamonetHull",1,"showCamonetTurret",1,"showLog",1] 
            ] call BIS_fnc_initVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 

                private _commander = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createAngaraModule = { 
            private _vehicle = ["O_MBT_04_cannon_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            [ 
                _vehicle, 
                ["Hex",1],  
                ["showCamonetHull",1,"showCamonetTurret",1] 
            ] call BIS_fnc_initVehicle; 
        
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 

                private _commander = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createAngaraKModule = { 
            private _vehicle = ["O_MBT_04_command_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            [ 
                _vehicle, 
                ["Hex",1],  
                ["showCamonetHull",1,"showCamonetTurret",1] 
            ] call BIS_fnc_initVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 

                private _commander = [] call MAZ_EZM_CSATP_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 
        
    comment "Trucks"; 

        MAZ_EZM_CSATP_fnc_createTempestDeviceModule = { 
            private _vehicle = ["O_Truck_03_device_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTempestAmmoModule = { 
            private _vehicle = ["O_Truck_03_ammo_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle setObjectTextureGlobal [3, "a3\structures_f\data\metal\containers\containers_colors_05_co.paa"];
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTempestFuelModule = { 
            private _vehicle = ["O_Truck_03_fuel_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTempestMedicalModule = { 
            private _vehicle = ["O_Truck_03_medical_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTempestRepairModule = { 
            private _vehicle = ["O_Truck_03_repair_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTempestTransportModule = { 
            private _vehicle = ["O_Truck_03_transport_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createTempestTransportCoveredModule = { 
            private _vehicle = ["O_Truck_03_covered_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createZamakAmmoModule = { 
            private _vehicle = ["O_Truck_02_Ammo_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createZamakFuelModule = {
            private _vehicle = ["O_Truck_02_fuel_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createZamakMedicalModule = { 
            private _vehicle = ["O_Truck_02_medical_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanLightModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createZamakRepairModule = { 
            private _vehicle = ["O_Truck_02_box_F"] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createZamakTransportModule = { 
            private _vehicle = ["O_Truck_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanLightModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createZamakCoveredTransportModule = { 
            private _vehicle = ["O_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATP_fnc_createRiflemanLightModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
    comment "Turrets"; 

        MAZ_EZM_CSATP_fnc_createM2HMGModule = { 
            private _vehicle = ["I_G_HMG_02_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
            
            _vehicle 
        }; 
    
        MAZ_EZM_CSATP_fnc_createM2HMGRaisedModule = { 
            private _vehicle = ["I_G_HMG_02_high_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createMk32GMGModule = { 
            private _vehicle = ["O_GMG_01_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
            _vehicle disableTIEquipment true; 
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createMk6MortarModule = { 
            private _vehicle = ["O_Mortar_01_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATP_fnc_createAALauncherModule = { 
            private _vehicle = ["O_static_AA_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATP_fnc_createATLauncherModule = { 
            private _vehicle = ["O_static_AT_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATP_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
        
            _vehicle 
        };

comment "CSAT (Pacific) Units"; 

    comment "Anti-Air";	

        MAZ_EZM_CSATPacific_fnc_createTigris = { 
            private _vehicle = ["O_T_APC_Tracked_02_AA_ghex_F"] call MAZ_EZM_fnc_createVehicle;	
            _vehicle disableTIEquipment true; 

            [ 
                _vehicle, 
                [],  
                ["showTracks",1,"showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle;
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createTigrisMissile = { 
            private _vehicle = ["O_T_APC_Tracked_02_AA_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 

            [ 
                _vehicle, 
                [],  
                ["showTracks",1,"showCamonetHull",1,"showCamonetTurret",1,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle;

                _vehicle removeWeaponTurret ["missiles_titan_AA", [0]];
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };

    comment "APCs"; 
    
        MAZ_EZM_CSATPacific_fnc_createMarid = { 
            private _vehicle = ["O_T_APC_Wheeled_02_rcws_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 

            [ 
                _vehicle, 
                [],  
                ["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",1,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle;
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _commander; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createMaridNoTurret = { 
            private _vehicle = ["O_T_APC_Wheeled_02_rcws_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle animate ["HideTurret",2]; 
            _vehicle lockTurret [[0], true]; 

            [ 
                _vehicle, 
                [],  
                ["showBags",0,"showCanisters",1,"showTools",0,"showCamonetHull",1,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver] joinSilent _grp; 
                _grp selectLeader _commander; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createBTRK = { 
            private _vehicle = ["O_T_APC_Tracked_02_cannon_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 

            [ 
                _vehicle, 
                [],  
                ["showTracks",1,"showCamonetHull",1,"showBags",0,"showSLATHull",0]
            ] call BIS_fnc_initVehicle; 
                        
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 
            
                private _commander = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _commander; 
                _grp setBehaviour "AWARE";
            }; 
        
            _vehicle 
        };
    
    comment "Artillery";
    
        MAZ_EZM_CSATPacific_fnc_createSochorModule = { 
            private _vehicle = ["O_T_MBT_02_arty_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            [ 
                _vehicle, 
                [],  
                ["showAmmobox",1,"showCanisters",1,"showCamonetTurret",1,"showCamonetHull",1,"showLog",1]
            ] call BIS_fnc_initVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 

                private _commander = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createSochorNoCommanderModule = {  
            private _vehicle = ["O_T_MBT_02_arty_ghex_F"] call MAZ_EZM_fnc_createVehicle; 
            _vehicle disableTIEquipment true;  
            _vehicle allowCrewInImmobile true;
            
            [  
                _vehicle,  
                [],   
                ["showAmmobox",0,"showCanisters",1,"showCamonetTurret",1,"showCamonetHull",1,"showLog",1] 
            ] call BIS_fnc_initVehicle;  

            _vehicle setObjectTextureGlobal [3, ""]; _vehicle lockturret [[0,0],true];  
            
            if(MAZ_EZM_spawnWithCrew) then {  
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule;  
                _driver moveInDriver _vehicle;  
                
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule;  
                _gunner moveInGunner _vehicle; 
                
                private _grp = createGroup [east,true];  
                [_driver,_gunner] joinSilent _grp;  
                _grp selectLeader _gunner;  
                _grp setBehaviour "AWARE"; 
            }; 

            _vehicle 
        }; 

    comment "Boats"; 
    
        MAZ_EZM_CSATPacific_fnc_createRhibBoatModule = { 
            private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
            
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        }; 
    
        MAZ_EZM_CSATPacific_fnc_createAssaultBoatModule = {
            private _vehicle = ["O_Boat_Transport_01_F"] call MAZ_EZM_fnc_createVehicle;
            
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createSpeedBoatModule = {
            private _vehicle = ["B_Boat_Armed_01_minigun_F",[
            "a3\boat_f\boat_armed_01\data\boat_armed_01_ext_opfor_co.paa",
            "a3\boat_f\boat_armed_01\data\boat_armed_01_int_opfor_co.paa",
            ""
            ]] call MAZ_EZM_fnc_createVehicle;
            _vehicle setObjectTextureGlobal [2, ""];
            _vehicle removeWeaponTurret ["GMG_40mm", [0]];
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                private _commander = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _commander moveInCommander _vehicle; 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _driver; 
                _vehicle disableTIEquipment true; 
            }; 
            
            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createSpeedBoatHMGModule = {
            private _vehicle = ["O_Boat_Armed_01_hmg_F"] call MAZ_EZM_fnc_createVehicle;
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                private _commander = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _commander moveInCommander _vehicle; 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _driver; 
                _vehicle disableTIEquipment true; 
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createSpeedBoatMinigunModule = {
            private _vehicle = ["B_Boat_Armed_01_minigun_F",[
                "a3\boat_f\boat_armed_01\data\boat_armed_01_ext_opfor_co.paa",
                "a3\boat_f\boat_armed_01\data\boat_armed_01_int_opfor_co.paa",
                "a3\boat_f\boat_armed_01\data\boat_armed_01_crows_opfor_co.paa"
            ]] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                private _commander = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _commander moveInCommander _vehicle; 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        };
    
    comment "Cars"; 
    
        MAZ_EZM_CSATPacific_fnc_createIfritModule = {
            private _vehicle = ["O_T_MRAP_02_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createIfritHMGModule = {
            
            private _vehicle = ["O_T_MRAP_02_hmg_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _gunner moveInGunner _vehicle;
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createIfritGMGModule = {
            
            private _vehicle = ["O_T_MRAP_02_gmg_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _gunner moveInGunner _vehicle;
                private _grp = createGroup [east,true]; 
                [_driver,_gunner] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createQuadbikeModule = {
            private _vehicle = ["O_T_Quadbike_01_ghex_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _passanger moveinCargo _vehicle; 
                [_driver] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
                [_passanger] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
                private _grp = createGroup [east,true]; 
                [_driver,_passanger] joinSilent _grp; 
                _grp selectLeader _driver; 
            }; 
        
            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createQilinUnarmedModule = {
            private _vehicle = ["O_T_LSV_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createQilinMinigunModule = { 
            private _vehicle = ["O_T_LSV_02_armed_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _gunner moveInGunner _vehicle;
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createQilinATModule = { 
            private _vehicle = ["O_T_LSV_02_AT_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
                _gunner moveInGunner _vehicle;
            }; 
        
            _vehicle 
        }; 
        
    comment "Drones"; 

        MAZ_EZM_CSATPacific_fnc_createJinaahLeafletModule = { 
            private _vehicle = ["O_UAV_06_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader; 

            _vehicle setPylonLoadout [1,"Pylon_1Rnd_Leaflets_East_F"];
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createJinaahMedicalModule = { 
            private _vehicle = ["O_UAV_06_medical_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader; 
        
            _vehicle 
        }; 
                
        MAZ_EZM_CSATPacific_fnc_createTayranModule = { 
            private _vehicle = ["O_UAV_01_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createK40Module = { 
            private _vehicle = ["O_UAV_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader;

            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createKH3AModule = { 
            private _vehicle = ["O_T_UAV_04_CAS_F"] call MAZ_EZM_fnc_createVehicle; 
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader;

            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createSaifModule = { 
            private _vehicle = ["O_T_UGV_01_ghex_F"] call MAZ_EZM_fnc_createVehicle;
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader;

            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createSaifRCWSModule = { 
            private _vehicle = ["O_T_UGV_01_rcws_ghex_F"] call MAZ_EZM_fnc_createVehicle;
        
            private _aiGroup = createGroup [opfor,true]; 
            private _oldGroup = createVehicleCrew _vehicle; 
            private _leader = leader _oldGroup; 
            { 
                [_x] joinSilent _aiGroup; 
            }forEach units _oldGroup; 
            _aiGroup selectLeader _leader;

            _vehicle 
        }; 
    
    comment "Groups"; 
        
        MAZ_EZM_CSATPacific_fnc_createSquadModule = { 
            private _squadLead = call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule', 
                'MAZ_EZM_CSATPacific_fnc_createCombatMedicModule', 
                'MAZ_EZM_CSATPacific_fnc_createRiflemanModule', 
                'MAZ_EZM_CSATPacific_fnc_createMarksmanModule', 
                'MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule', 
                'MAZ_EZM_CSATPacific_fnc_createGrenadierModule', 
                'MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule', 
                'MAZ_EZM_CSATPacific_fnc_createRiflemanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
    
        MAZ_EZM_CSATPacific_fnc_createPatrolModule = { 
            private _squadLead = call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATPacific_fnc_createCombatMedicModule', 
                'MAZ_EZM_CSATPacific_fnc_createRiflemanModule', 
                'MAZ_EZM_CSATPacific_fnc_createMarksmanModule', 
                'MAZ_EZM_CSATPacific_fnc_createRiflemanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconSquadModule = { 
            private _squadLead = call MAZ_EZM_CSATPacific_fnc_createReconTeamLeaderModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATPacific_fnc_createReconParamedicModule', 
                'MAZ_EZM_CSATPacific_fnc_createReconScoutModule', 
                'MAZ_EZM_CSATPacific_fnc_createReconJTACModule', 
                'MAZ_EZM_CSATPacific_fnc_createReconScoutATModule',
                'MAZ_EZM_CSATPacific_fnc_createReconDemoModule',
                'MAZ_EZM_CSATPacific_fnc_createReconMarksmanModule'
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createSentryModule = { 
            private _squadLead = call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATPacific_fnc_createRiflemanModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createAntiAirTeamModule = { 
            private _squadLead = call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule', 
                'MAZ_EZM_CSATPacific_fnc_createMissileSpecAAModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createAntiTankTeamModule = { 
            private _squadLead = call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
            private _grp = group _squadLead; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule', 
                'MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule' 
            ]; 
            _grp setBehaviour "AWARE"; 
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createMarksmanTeamModule = { 
            private _squadLead = call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
            private _grp = group _squadLead; 
            _squadLead addPrimaryWeaponItem "optic_DMS"; 
            { 
                private _unit = call (missionNamespace getVariable _x); 
                [_unit] joinSilent _grp; 
            }forEach [ 
                'MAZ_EZM_CSATPacific_fnc_createSquadLeadModule' 
            ]; 
            
            _grp setBehaviour "AWARE"; 
        }; 

        MAZ_EZM_CSATPacific_fnc_createSniperTeamModule = {  
            private _squadLead = call MAZ_EZM_CSATPacific_fnc_createReconSniperModule;  
            private _grp = group _squadLead;  
            _squadLead addPrimaryWeaponItem "optic_DMS";  
            {  
                private _unit = call (missionNamespace getVariable _x);  
                [_unit] joinSilent _grp;  
            }forEach [  
                'MAZ_EZM_CSATPacific_fnc_createReconSpotterModule'  
            ];  
            
            _grp setBehaviour "AWARE";  
        };  

    comment "Compositions";

        MAZ_EZM_CSATPacific_fnc_createCache1Module = {
            
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
            
            private _vehicle = createVehicle ["Land_Pallet_F",[24583.7,19262.5,0.00658536],[],0,"CAN_COLLIDE"];
            _vehicle setPosWorld [24583.7,19262.5,3.28107];
            _vehicle setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
                

            _item25 = createVehicle ["Box_T_East_Ammo_F",[24583.2,19262.6,0.178298],[],0,"CAN_COLLIDE"];
            _item25 setPosWorld [24583.2,19262.6,3.63531];
            _item25 setVectorDirAndUp [[1,0.000220732,0],[0,0,1]];
            _item25 = [_item25] call BIS_fnc_replaceWithSimpleObject;
            [_item25, _vehicle] call BIS_fnc_attachToRelative;

            _item26 = createVehicle ["Box_T_East_Wps_F",[24583.4,19262.2,0.239546],[],0,"CAN_COLLIDE"];
            _item26 setPosWorld [24583.5,19262,3.53942];
            _item26 setVectorDirAndUp [[0,-1,0],[0,0,1]];
            _item26 = [_item26] call BIS_fnc_replaceWithSimpleObject;
            [_item26, _vehicle] call BIS_fnc_attachToRelative;
            
            _item29 = createVehicle ["Box_T_East_Wps_F",[24583.5,19262,0.512213],[],0,"CAN_COLLIDE"];
            _item29 setPosWorld [24583.5,19262,3.87547];
            _item29 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
            _item29 = [_item29] call BIS_fnc_replaceWithSimpleObject;
            [_item29, _vehicle] call BIS_fnc_attachToRelative;

            _item30 = createVehicle ["Box_T_East_Ammo_F",[24583.9,19262.4,0.269096],[],0,"CAN_COLLIDE"];
            _item30 setPosWorld [24583.9,19262.6,3.64146];
            _item30 setVectorDirAndUp [[0.999995,0.00322254,0],[0,0,1]];
            _item30 = [_item30] call BIS_fnc_replaceWithSimpleObject;
            [_item30, _vehicle] call BIS_fnc_attachToRelative;

            _item43 = createVehicle ["Box_East_WpsLaunch_F",[24583.7,19263,0.20602],[],0,"CAN_COLLIDE"];
            _item43 setPosWorld [24583.7,19263,3.52767];
            _item43 setVectorDirAndUp [[0,1,0],[0,0,1]];
            _item43 enableSimulationGlobal false;
            _item43 setObjectTextureGlobal [0,"a3\supplies_f_exp\ammoboxes\data\ammobox_signs_opfor_ca.paa"]; 
            _item43 setObjectTextureGlobal [1,"a3\supplies_f_exp\ammoboxes\data\box_t_east_wps_f_co.paa"];
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

        MAZ_EZM_CSATPacific_fnc_createCache2Module = {
            
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
            
            _vehicle = createVehicle ["Land_Pallet_F",[24587.7,19262.5,0.00657558],[],0,"CAN_COLLIDE"];
            _vehicle setPosWorld [24587.7,19262.5,3.28107];
            _vehicle setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
                

            _item16 = createVehicle ["Weapon_arifle_CTAR_blk_F",[24587.5,19262.2,0.532802],[],0,"CAN_COLLIDE"];
            _item16 setPosWorld [24587.5,19262.2,3.70695];
            _item16 setVectorDirAndUp [[-0.243731,0.969843,0],[0,0,1]];
            [_item16, _vehicle] call BIS_fnc_attachToRelative;
            _item16 setDamage 1;

            _item17 = createVehicle ["Weapon_srifle_DMR_07_blk_F",[24587.9,19262,0.536677],[],0,"CAN_COLLIDE"];
            _item17 setPosWorld [24587.9,19262,3.71141];
            _item17 setVectorDirAndUp [[-0.0391472,0.999233,-4.28914e-005],[-0.00129824,-9.37858e-005,-0.999999]];
            [_item17, _vehicle] call BIS_fnc_attachToRelative;
            _item17 setDamage 1;

            _item19 = createVehicle ["Box_T_East_Ammo_F",[24587.2,19262.8,0.172966],[],0,"CAN_COLLIDE"];
            _item19 setPosWorld [24587.15,19262.8,3.62947];
            _item19 setVectorDirAndUp [[0,-1,0],[0,0,1]];
            _item19 = [_item19] call BIS_fnc_replaceWithSimpleObject;
            [_item19, _vehicle] call BIS_fnc_attachToRelative;

            _item20 = createVehicle ["Box_T_East_Wps_F",[24587.9,19262.6,0.232723],[],0,"CAN_COLLIDE"];
            _item20 setPosWorld [24587.9,19262.7,3.53942];
            _item20 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
            _item20 = [_item20] call BIS_fnc_replaceWithSimpleObject;
            [_item20, _vehicle] call BIS_fnc_attachToRelative;

            _item23 = createVehicle ["Box_T_East_Wps_F",[24587.9,19262.7,0.514064],[],0,"CAN_COLLIDE"];
            _item23 setPosWorld [24587.9,19262.7,3.87547];
            _item23 setVectorDirAndUp [[0.00257769,-0.999997,0],[0,0,1]];
            _item23 = [_item23] call BIS_fnc_replaceWithSimpleObject;
            [_item23, _vehicle] call BIS_fnc_attachToRelative;

            _item15 = createVehicle ["Box_T_East_WpsSpecial_F",[24587.7,19262.2,0.157008],[],0,"CAN_COLLIDE"];
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

        MAZ_EZM_CSATPacific_fnc_createDeadSoldierModule = {
            private _pos = [true] call MAZ_EZM_fnc_getScreenPosition;
            
            private _vehicle = createVehicle ["O_Soldier_F",[24602.4,19234.3,2.38419e-007],[],0,"CAN_COLLIDE"];
            _vehicle setUnitLoadout [[],[],[],["U_O_T_Soldier_F",[["FirstAidKit",1],["Chemlight_red",1,1]]],["V_HarnessO_ghex_F",[]],[],"H_HelmetO_ghex_F","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];

            private _animData = selectRandom [
                ["KIA_gunner_static_low01",[24602.4,19234.4,3.19144],[24603.4,19234.9,3.20104],[24601.7,19235,3.195]],
                ["KIA_gunner_standup01",[24602.4,19234.4,3.19144],[24602.9,19233.5,3.2036],[24602.4,19234.3,3.19136]],
                ["KIA_driver_boat01",[24602.4,19234.4,3.19144],[24603,19235.2,3.19],[24602.8,19234.5,3.195]],
                ["KIA_passenger_boat_holdleft",[24602.5,19234.4,3.19144],[24603,19235.1,3.19896],[24602.8,19234.4,3.195]]
            ];
            
            _animData params ["_anim","_unitPos","_gunPos","_bloodPos"];
            [_vehicle,_anim] remoteExec ['switchMove',0,true];
            _vehicle disableAI "ALL";  
            _vehicle setCaptive true; 
            _vehicle setSpeaker "NoVoice"; 
            _vehicle allowDamage false;
            private _face = selectRandom ["AsianHead_A3_01","AsianHead_A3_02","AsianHead_A3_03","AsianHead_A3_04","AsianHead_A3_05","AsianHead_A3_06","AsianHead_A3_07"];
            _vehicle setface _face;
            _vehicle setPosWorld _unitPos;
            _vehicle setVectorDirAndUp [[0.965509,-0.26037,0],[0,0,1]];
            _vehicle setDir (random 359);
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
            [_vehicle] call MAZ_EZM_fnc_addObjectToInterface;
            [_vehicle] call MAZ_EZM_fnc_ignoreWhenCleaning;

            _vehicle spawn {
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

            private _gun = createVehicle ["Weapon_arifle_CTAR_blk_F",[24603.4,19234.9,0.0110364],[],0,"CAN_COLLIDE"];
            _gun setPosWorld _gunPos;
            _gun setDir (random 90);
            [_gun,_vehicle] call BIS_fnc_attachToRelative;

            private _blood = createVehicle ["BloodSplatter_01_Medium_New_F",[24601.7,19235,0],[],0,"CAN_COLLIDE"];
            _blood setPosWorld _bloodPos;
            _blood setVectorDirAndUp [[0,1,0],[0,0,1]];
            _blood setObjectTextureGlobal [0,"a3\props_f_orange\humanitarian\garbage\data\bloodsplatter_medium_fresh_ca.paa"];
            _blood setDir (random 359);
            [_blood, _vehicle] call BIS_fnc_attachToRelative;

            _vehicle setpos _pos;

            _vehicle
        };  

        MAZ_EZM_CSATPacific_fnc_createTaruTransportPodModule = { 
            
            private _vehicle = ["Land_Pod_Heli_Transport_04_bench_black_F"] call MAZ_EZM_fnc_createVehicle;
    
            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createBlackTaruFuelPodModule = { 
            
            private _vehicle = ["Land_Pod_Heli_Transport_04_fuel_black_F"] call MAZ_EZM_fnc_createVehicle;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
            _vehicle setPosWorld [24483.5,18682.1,4.5098];
            _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]];

            private _texture = createVehicle ["UserTexture1m_F",[24482.1,18682.8,1.39497],[],0,"CAN_COLLIDE"];
            _texture setObjectTextureGlobal [0,"\a3\air_f_exp\VTOL_02\Data\VTOL_02_signs_CA.paa"];
            _texture setPosWorld [24482,18682.8,4.58497];
            _texture setVectorDirAndUp [[0.99997,0.0077517,0],[0,0,1]];
            [_texture, _vehicle] call BIS_fnc_attachToRelative; 

            _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition);

            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createBlackCargoTaruPodModule = { 
            
            private _vehicle = ["Land_Pod_Heli_Transport_04_box_black_F"] call MAZ_EZM_fnc_createVehicle;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
            _vehicle setPosWorld [24493.7,18682,4.39653];
            _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]];
            [_vehicle,"[[[[""arifle_CTAR_GL_blk_F"",""arifle_CTAR_blk_ACO_F"",""arifle_CTARS_blk_F"",""launch_RPG32_ghex_F""],[1,5,2,2]],[[""1Rnd_HE_Grenade_shell"",""Chemlight_red"",""RPG32_F"",""RPG32_HE_F"",""HandGrenade"",""30Rnd_580x42_Mag_F"",""100Rnd_580x42_Mag_F"",""20Rnd_650x39_Cased_Mag_F""],[12,5,6,2,12,48,8,24]],[[""LaserdesignatorGPS_02_ghex"",""FirstAidKit"",""acc_flashlight"",""Medikit""],[1,20,5,1]],[[""B_FieldPack_ghex_F""],[4]]],false]"] call bis_fnc_initAmmoBox;

            private _texture = createVehicle ["UserTexture1m_F",[24482.1,18682.8,1.39497],[],0,"CAN_COLLIDE"];
            _texture setObjectTextureGlobal [0,"\a3\air_f_exp\VTOL_02\Data\VTOL_02_signs_CA.paa"];
            _texture setPosWorld [24492.2,18684,4.46188];
            _texture setVectorDirAndUp [[0.999987,-0.0049999,0],[0,0,1]];
            [_texture, _vehicle] call BIS_fnc_attachToRelative; 

            _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition);

            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createBlackMedicalTaruPodModule = { 
            
            private _vehicle = ["Land_Pod_Heli_Transport_04_medevac_black_F"] call MAZ_EZM_fnc_createVehicle;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
            _vehicle setPosWorld [24504.7,18682.8,4.57477];
            _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]];
        
            private _texture = createVehicle ["UserTexture1m_F",[24482.1,18682.8,1.39497],[],0,"CAN_COLLIDE"];
            _texture setObjectTextureGlobal [0,"\a3\air_f_exp\VTOL_02\Data\VTOL_02_signs_CA.paa"];
            _texture setPosWorld [24506.2,18685.6,4.41109];
            _texture setVectorDirAndUp [[-0.999974,0.00724644,0],[0,0,1]];;
            [_texture, _vehicle] call BIS_fnc_attachToRelative; 

            _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition);

            _vehicle 
        };

        MAZ_EZM_CSATPacific_fnc_createBlackTransportTaruPodModule = { 
            
            private _vehicle = ["Land_Pod_Heli_Transport_04_covered_black_F"] call MAZ_EZM_fnc_createVehicle;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenDeleted;
            [_vehicle] call MAZ_EZM_fnc_deleteAttachedWhenKilled;
            _vehicle setPosWorld [24514.6,18681.9,4.66675];
            _vehicle setVectorDirAndUp [[0,1,0],[0,0,1]];
        
            private _texture = createVehicle ["UserTexture1m_F",[24482.1,18682.8,1.39497],[],0,"CAN_COLLIDE"];
            _texture setObjectTextureGlobal [0,"\a3\air_f_exp\VTOL_02\Data\VTOL_02_signs_CA.paa"];
            _texture setPosWorld [24514.4,18685.3,4.46188];
            _texture setVectorDirAndUp [[-3.25841e-007,-1,0],[0,0,1]];
            [_texture, _vehicle] call BIS_fnc_attachToRelative; 

            _vehicle setpos ([true] call MAZ_EZM_fnc_getScreenPosition);

            _vehicle 
        };
        
    comment "Helicopters";

        MAZ_EZM_CSATPacific_fnc_createTaruModule = { 
            private _vehicle = ["O_Heli_Transport_04_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTaruAmmoModule = { 
            private _vehicle = ["O_Heli_Transport_04_ammo_black_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then {
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTaruBenchModule = {
            private _vehicle = ["O_Heli_Transport_04_bench_black_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTaruCargoModule = {
            private _vehicle = ["O_Heli_Transport_04_box_black_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTaruFuelModule = {
            private _vehicle = ["O_Heli_Transport_04_fuel_black_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTaruMedicalModule = {
            private _vehicle = ["O_Heli_Transport_04_medevac_black_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then {
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTaruRepairModule = {
            private _vehicle = ["O_Heli_Transport_04_repair_black_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTaruTransportModule = {
            private _vehicle = ["O_Heli_Transport_04_covered_black_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot moveInAny _vehicle; 

                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _copilot2 moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot,_copilot2] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTaruKajmanModule = {
            private _vehicle = ["O_Heli_Attack_02_dynamicLoadout_black_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _gunner moveInGunner _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_gunner] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createOrcaUnarmedModule = {
            private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _gunner moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_gunner] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createOrcaModule = {
            private _vehicle = ["O_Heli_Light_02_dynamicLoadout_F"] call MAZ_EZM_fnc_createVehicle;

            [_vehicle,"Black"] call bis_fnc_initVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _pilot moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                _gunner moveInAny _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_gunner] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

    comment "Men"; 
    
        MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit = { 
            params ["_unit"]; 
            sleep 0.5; 

            private _CSATPacificVoice = [
                "Male03CHI",
                "Male01CHI",
                "Male02CHI"
            ];

            [_unit,(selectRandom _CSATPacificVoice)] remoteExec ['setSpeaker']; 
            
            private _CSATPacificHeads = [ 
                "AsianHead_A3_01",
                "AsianHead_A3_02",
                "AsianHead_A3_03",
                "AsianHead_A3_04", 
                "AsianHead_A3_05", 
                "AsianHead_A3_06", 
                "AsianHead_A3_07",
                "CamoHead_Asian_02_F",
                "CamoHead_Asian_03_F",
                "CamoHead_Asian_01_F"
            ]; 

            [_unit,(selectRandom _CSATPacificHeads)] remoteExec ['setFace',0,_unit]; 
        
        }; 
        
        MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit = { 
            params ["_unit"]; 
            private _58Ammo = "30Rnd_580x42_Mag_F";  
            private _pWeapon = selectRandom [ ["arifle_CTAR_blk_F", _58Ammo],["arifle_CTAR_ghex_F", _58Ammo] ]; 
                        
            _pWeapon 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack = { 
            params ["_unit"]; 
            private _randomBackpack = selectRandom ["B_FieldPack_ghex_F"]; 
            _unit addBackpackGlobal _randomBackpack; 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit = { 
            params ["_unit"]; 
            
            private _CSATPacificUniforms = ["U_O_T_Soldier_F"]; 
            private _CSATPacificVests = ["V_HarnessO_ghex_F"]; 
            private _CSATPacificHeadgear = ["H_HelmetLeaderO_ghex_F","H_HelmetO_ghex_F","H_HelmetSpecO_ghex_F"]; 
            removeGoggles _unit; 
            _unit forceAddUniform (selectRandom _CSATPacificUniforms); 
            _unit setObjectTextureGlobal [2,"\a3\air_f_exp\VTOL_02\Data\VTOL_02_signs_CA.paa"];
            _unit addVest (selectRandom _CSATPacificVests); 
            _unit addHeadgear (selectRandom _CSATPacificHeadgear); 
        }; 

        MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit = {
            params ["_unit"];
            _unit addEventHandler ["Killed",{
                params ["_unit", "_killer", "_instigator", "_useEffects"];
                _unit spawn {
                    private _RadioSounds = selectRandom ["\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_01_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_01_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_01_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_01_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_02_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_02_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_02_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_03_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_03_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_03_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_03_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_04_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_04_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_04_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_04_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_05_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_05_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_05_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_05_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_06_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_06_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_06_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_06_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_07_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_07_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_07_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_07_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_08_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_08_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_08_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_08_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_09_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_09_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_09_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_09_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_10_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_10_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_10_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_10_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_11_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_11_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_11_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_11_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_12_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_12_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_12_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_12_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_13_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_13_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_13_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_13_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_14_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_14_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_14_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_14_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_15_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_15_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_15_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_15_Chinese04_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_16_Chinese01_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_16_Chinese02_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_16_Chinese03_Processed.ogg","\a3\Dubbing_F_Oldman\Barks\Awareness\CSAT_Awareness_WT_16_Chinese04_Processed.ogg"];
                    private _randomNumber = [8, 20] call BIS_fnc_randomNum;
                    sleep _randomNumber;
                    playSound3D [_RadioSounds, _this, false, getPosASL _this, 2, 1, 15];
                    sleep _randomNumber;
                    playSound3D [_RadioSounds, _this, false, getPosASL _this, 2, 1, 15];
                };
            }];
        };
        
        MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule = { 
            private _unit = [east,"O_T_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
        
            private _M58Ammo = selectRandom ["100Rnd_580x42_Mag_F","100Rnd_580x42_Mag_Tracer_F"];
            private _M58AmmoHex = selectRandom ["100Rnd_580x42_hex_Mag_F","100Rnd_580x42_hex_Mag_Tracer_F"]; 
            private _pMachineGun = selectRandom [ ["arifle_CTARS_blk_F",_M58Ammo],["arifle_CTARS_ghex_F",_M58AmmoHex] ];  
            [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[""]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createHeavyGunnerModule = { 
            private _unit = [east,"O_T_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            private _M93Ammo = selectRandom ["150Rnd_93x64_Mag"]; 
            private _pMachineGun = selectRandom [ ["MMG_01_tan_F",_M93Ammo] ];  
            [_unit,[_pMachineGun select 0,[_pMachineGun select 1,2],[]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createCombatMedicModule = { 
            private _unit = [east,"O_T_Medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addItemToBackpack "Medikit"; 
            for "_i" from 0 to 4 do { 
                _unit addItemToBackpack "FirstAidKit"; 
            }; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createCrewmanModule = { 
            private _unit = [east,"O_T_Crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            removeHeadgear _unit; 
            removevest _unit; 
            removeheadgear _unit; 
            _unit addHeadgear "H_Tank_black_F"; 
            _unit addVest "V_HarnessO_ghex_F"; 
            _unit addItemToVest "ToolKit"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],[]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createEngineerModule = { 
            private _unit = [east,"O_T_Engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit addItemToBackpack "Toolkit";
            _unit
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createSquadLeadModule = { 
            private _unit = [east,"O_T_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit;
            _unit addWeapon "Laserdesignator_02_ghex_F"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit   
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createGrenadierModule = { 
            private _unit = [east,"O_T_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            _unit addVest "V_HarnessOGL_ghex_F";
            private _pGrenadier = selectRandom ["arifle_CTAR_GL_blk_F","arifle_CTAR_GL_ghex_F"]; 
            [_unit,[_pGrenadier,["30Rnd_580x42_Mag_F",5],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createMarksmanModule = { 
            private _unit = [east,"O_T_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _pSniper = selectRandom ["srifle_DMR_07_blk_F","srifle_DMR_07_ghex_F"]; 
            [_unit,[_pSniper,["20Rnd_650x39_Cased_Mag_F",5],["optic_Arco_ghex_F"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createSharpshooterModule = { 
            private _unit = [east,"O_T_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _pSniper = selectRandom ["srifle_DMR_05_blk_F"]; 
            [_unit,[_pSniper,["10Rnd_93x64_DMR_05_Mag",5],["optic_DMS"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons;  
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        };
        
        MAZ_EZM_CSATPacific_fnc_createMissileSpecAAModule = { 
            private _unit = [east,"O_T_Soldier_AA_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],["launch_O_Titan_ghex_F",["Titan_AA",2]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createRiflemanModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _pRPG = selectRandom ["RPG32_F"];
            private _pAT = selectRandom [ ["launch_RPG32_ghex_F",_pRPG]]; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createRiflemanHATModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _pVorona = selectRandom ["Vorona_HEAT"]; 
            private _pAT = selectRandom [ ["launch_O_Vorona_green_F",_pVorona]]; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["",[""]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createMissileSpecATModule = { 
            private _unit = [east,"O_T_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],["launch_O_Titan_F",["Titan_AT",2]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createOfficerModule = { 
            private _unit = [east,"O_T_Officer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            _unit addUniform "U_O_T_Officer_F";
            _unit addMagazines ["6Rnd_45ACP_Cylinder", 3];
            _unit addWeapon "hgun_Pistol_heavy_02_F";
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit addHeadgear "H_Beret_CSAT_01_F";
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createRadiomanModule = { 
            private _unit = [east,"O_T_Soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            _unit addBackpack "B_RadioBag_01_black_F"; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule = { 
            private _unit = [east,"O_helipilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit;
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            _unit addMagazine "30Rnd_9x21_Mag_SMG_02_Tracer_Green";
            _unit addWeapon "SMG_02_F";
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createPilotModule = { 
            private _unit = [east,"O_pilot_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit;
            _unit addMagazine "30Rnd_9x21_Mag_SMG_02_Tracer_Green";
            _unit addWeapon "SMG_02_F";
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createHelicopterCrewModule = { 
            private _unit = [east,"O_Helicrew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            _unit addMagazine "30Rnd_9x21_Mag_SMG_02_Tracer_Green";
            _unit addWeapon "SMG_02_F";
            _unit 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createSurvivorModule = { 
            private _unit = [east,"O_T_Soldier_unarmed_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            removeVest _unit; 
            removeHeadgear _unit; 
            [_unit,""] remoteExec ["switchMove"];
        
            _unit 
        }; 

    comment "Men (Special Forces)";

        MAZ_EZM_CSATPacific_fnc_createDiverModule = { 
            private _unit = [east,"O_T_Diver_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            _unit setUnitLoadout [["arifle_SDAR_F","","","",["20Rnd_556x45_UW_mag",20],[],""],[],["hgun_Rook40_F","muzzle_snds_L","","",["16Rnd_9x21_Mag",16],[],""],["U_O_Wetsuit",[["FirstAidKit",1],["30Rnd_556x45_Stanag_green",4,30],["20Rnd_556x45_UW_mag",3,20],["16Rnd_9x21_Mag",2,16],["SmokeShellRed",2,1]]],["V_RebreatherIR",[]],["B_FieldPack_blk",[]],"","G_O_Diving",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]]; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            _unit addHeadgear "H_HelmetSpecO_blk";
            _unit
        };

        MAZ_EZM_CSATPacific_fnc_createReconDemoModule = { 
            private _unit = [east,"O_R_recon_exp_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit addItemToBackpack "Toolkit";
            _unit
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconJTACModule = { 
            private _unit = [east,"O_R_recon_JTAC_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            _unit addVest "V_HarnessOGL_ghex_F";
            private _pGrenadier = selectRandom ["arifle_CTAR_GL_blk_F","arifle_CTAR_GL_ghex_F"]; 
            [_unit,[_pGrenadier,["30Rnd_580x42_Mag_F",5],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconMarksmanModule = { 
            private _unit = [east,"O_R_recon_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            [_unit,["srifle_DMR_04_F",["10Rnd_127x54_Mag",5],["optic_DMS_weathered_Kir_F"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F"; 
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconParaMedicModule = { 
            private _unit = [east,"O_R_recon_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconScoutModule = { 
            private _unit = [east,"O_R_recon_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconScoutATModule = { 
            private _unit = [east,"O_R_recon_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;  
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            private _pRPG = selectRandom ["RPG32_F"];
            private _pAT = selectRandom [ ["launch_RPG32_ghex_F",_pRPG]]; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[_pAT select 0, [_pAT select 1,3]],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit 
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconTeamLeaderModule = { 
            private _unit = [east,"O_R_recon_TL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificUniformToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_ACO_grn"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addHeadgear "H_HelmetSpecO_blk";
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconSniperModule = { 
            private _unit = [east,"O_T_Sniper_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit;
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            _unit setUnitLoadout [["srifle_GM6_ghex_LRPS_F","","","optic_LRPS_ghex_F",["5Rnd_127x108_Mag",5],[],""],[],["hgun_Rook40_F","muzzle_snds_L","","",["16Rnd_9x21_Mag",16],[],""],["U_O_T_Sniper_F",[["FirstAidKit",1],["5Rnd_127x108_Mag",2,5],["SmokeShell",1,1]]],["V_Chestrig_oli",[["5Rnd_127x108_APDS_Mag",2,5],["16Rnd_9x21_Mag",2,16],["ClaymoreDirectionalMine_Remote_Mag",1,1],["APERSTripMine_Wire_Mag",1,1],["SmokeShellRed",1,1],["SmokeShellOrange",1,1],["SmokeShellYellow",1,1],["Chemlight_red",2,1],["5Rnd_127x108_Mag",1,5]]],[],"","",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit addWeapon "Laserdesignator_02_ghex_F";
            _unit
        }; 

        MAZ_EZM_CSATPacific_fnc_createReconSpotterModule = { 
            private _unit = [east,"O_T_Spotter_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan; 
            [_unit] call MAZ_EZM_fnc_removeAllClothing;
            _unit addUniform "U_O_T_Sniper_F";
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificIdentitiesToUnit; 
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addCSATPacificGogglesToUnit; 
            [_unit] call MAZ_EZM_CSATPacific_fnc_addCSATPacificBackpack; 
            private _weaponInfo = [_unit] call MAZ_EZM_CSATPacific_fnc_getCSATPacificWeaponToUnit; 
            [_unit,[_weaponInfo select 0,["30Rnd_580x42_Mag_F",7],["optic_Arco_ghex_F"]],[],["hgun_Rook40_F",["30Rnd_9x21_Mag",2]],3,[["HandGrenade",1],["SmokeShell",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 
            _unit addVest "V_Chestrig_oli";
            _unit addPrimaryWeaponItem "muzzle_snds_58_blk_F";
            _unit addWeapon "Laserdesignator_02_ghex_F";
            [_unit,"O_NVGoggles_ghex_F"] call MAZ_EZM_fnc_addNVGs;
            [_unit] spawn MAZ_EZM_CSATPacific_fnc_addRadioSoundtoUnit;
            _unit
        }; 

    comment "Reinforcement"; 
    
        MAZ_EZM_CSATPacific_fnc_createReinforcementZamakCoveredTransportModule = { 
            private _vehicle = ["O_T_Truck_02_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger16 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                private _passanger15 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule; 
                private _passanger14 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger13 = [] call MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule; 
                private _passanger12 = [] call MAZ_EZM_CSATPacific_fnc_createEngineerModule; 
                private _passanger11 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger9 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger8 = [] call MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule; 
                private _passanger5 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                
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
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
                (group _passanger1) setBehaviour "AWARE"; 
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
                (group _passanger16) setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createReinforcementTaruTransportModule = { 
            private _vehicle = ["O_Heli_Transport_04_covered_black_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                private _copilot2 = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                private _passanger16 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                private _passanger15 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule;
                private _passanger13 = [] call MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule;  
                private _passanger11 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger9 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger8 = [] call MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule;  
                private _passanger5 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                
                _pilot moveInDriver _vehicle; 
                _copilot moveInAny _vehicle;
                _copilot2 moveInAny _vehicle;
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

                [_copilot,_copilot2] joinSilent (group _pilot); 
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
            }; 
        
            _vehicle 
        }; 


        MAZ_EZM_CSATPacific_fnc_createReinforcementTempestTransportModule = { 
            private _vehicle = ["O_T_Truck_03_covered_ghex_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger16 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                private _passanger15 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule; 
                private _passanger13 = [] call MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule; 
                private _passanger11 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger10 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger9 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger8 = [] call MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger7 moveInCargo _vehicle; 
                _passanger8 moveInCargo _vehicle; 
                _passanger9 moveInCargo _vehicle; 
                _passanger10 moveInCargo _vehicle; 
                _passanger11 moveInCargo _vehicle; 
                _passanger13 moveInCargo _vehicle; 
                _passanger15 moveInCargo _vehicle; 
                _passanger16 moveInCargo _vehicle; 
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
            
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16);
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createReinforcementOrcaModule = { 
            private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

            [_vehicle,"Black"] call bis_fnc_initVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule; 
                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule;  
                private _passanger8 = [] call MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule; 
                private _passanger7 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule; 
                private _passanger5 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                
                _pilot moveInDriver _vehicle; 
                _copilot moveInAny _vehicle;
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle; 
                _passanger7 moveInCargo _vehicle; 
                _passanger8 moveInCargo _vehicle; 

                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger8,_passanger12,_passanger14] joinSilent (group _passanger1); 
                
                [_copilot] joinSilent (group _pilot); 
        
                [_passanger15,_passanger10,_passanger11,_passanger9,_passanger7,_passanger13] joinSilent (group _passanger16); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createReinforcementQilinUnarmedModule = { 
            private _vehicle = ["O_T_LSV_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger6 = [] call MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule; 
                private _passanger5 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger3 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule; 
                private _passanger2 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger1 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle;
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6] joinSilent (group _passanger1); 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createReinforcementRhibModule = { 
            
            private _vehicle = ["I_C_Boat_Transport_02_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger1 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                private _passanger2 = [] call MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule; 
                private _passanger3 = [] call MAZ_EZM_CSATPacific_fnc_createGrenadierModule; 
                private _passanger4 = [] call MAZ_EZM_CSATPacific_fnc_createMarksmanModule; 
                private _passanger5 = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule; 
                private _passanger6 = [] call MAZ_EZM_CSATPacific_fnc_createCombatMedicModule; 
                private _passanger7 = [] call MAZ_EZM_CSATPacific_fnc_createSquadLeadModule; 
                
                _driver moveInDriver _vehicle; 
                _passanger1 moveInCargo _vehicle; 
                _passanger2 moveInCargo _vehicle; 
                _passanger3 moveInCargo _vehicle; 
                _passanger4 moveInCargo _vehicle; 
                _passanger5 moveInCargo _vehicle; 
                _passanger6 moveInCargo _vehicle;
                _passanger7 moveInCargo _vehicle;
            
                [_passanger2,_passanger3,_passanger4,_passanger5,_passanger6,_passanger7] joinSilent (group _passanger1); 
            }; 
        
            _vehicle 
        }; 
    
    comment "Planes";
        

        MAZ_EZM_CSATPacific_fnc_createVTOLInfantryModule = { 
            private _vehicle = ["O_T_VTOL_02_infantry_F"] call MAZ_EZM_fnc_createVehicle;
            
            _vehicle allowCrewInImmobile true;
            
            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createPilotModule; 
                _pilot moveInDriver _vehicle; 

                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createPilotModule; 
                _copilot moveInGunner _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createVTOLVehicleModule = { 
            private _vehicle = ["O_T_VTOL_02_vehicle_F"] call MAZ_EZM_fnc_createVehicle;
        
            _vehicle allowCrewInImmobile true;

            if(MAZ_EZM_spawnWithCrew) then { 
                private _pilot = [] call MAZ_EZM_CSATPacific_fnc_createPilotModule; 
                _pilot moveInDriver _vehicle;

                private _copilot = [] call MAZ_EZM_CSATPacific_fnc_createPilotModule; 
                _copilot moveInGunner _vehicle;  
            
                private _grp = createGroup [east,true]; 
                [_pilot,_copilot] joinSilent _grp; 
                _grp selectLeader _pilot; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

    comment "Tanks"; 
    
        MAZ_EZM_CSATPacific_fnc_createVarsukModule = { 
            private _vehicle = ["O_T_MBT_02_cannon_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            [ 
                _vehicle, 
                [],  
                ["showCamonetHull",1,"showCamonetTurret",1,"showLog",1] 
            ] call BIS_fnc_initVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 

                private _commander = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createAngaraModule = { 
            private _vehicle = ["O_T_MBT_04_cannon_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            [ 
                _vehicle, 
                [],  
                ["showCamonetHull",1,"showCamonetTurret",1] 
            ] call BIS_fnc_initVehicle; 
        
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 

                private _commander = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createAngaraKModule = { 
            private _vehicle = ["O_T_MBT_04_command_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true; 
            _vehicle allowCrewInImmobile true;
        
            [ 
                _vehicle, 
                [],  
                ["showCamonetHull",1,"showCamonetTurret",1] 
            ] call BIS_fnc_initVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
            
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _driver moveInDriver _vehicle; 
            
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _gunner moveInGunner _vehicle; 

                private _commander = [] call MAZ_EZM_CSATPacific_fnc_createCrewmanModule; 
                _commander moveInCommander _vehicle; 
            
                private _grp = createGroup [east,true]; 
                [_driver,_gunner,_commander] joinSilent _grp; 
                _grp selectLeader _gunner; 
                _grp setBehaviour "AWARE"; 
            }; 
        
            _vehicle 
        }; 
        
    comment "Trucks"; 

        MAZ_EZM_CSATPacific_fnc_createTempestDeviceModule = { 
            private _vehicle = ["O_T_Truck_03_device_ghex_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTempestAmmoModule = { 
            private _vehicle = ["O_T_Truck_03_ammo_ghex_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle setObjectTextureGlobal [3, "a3\structures_f\data\metal\containers\containers_colors_05_co.paa"];
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTempestFuelModule = { 
            private _vehicle = ["O_T_Truck_03_fuel_ghex_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTempestMedicalModule = { 
            private _vehicle = ["O_T_Truck_03_medical_ghex_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTempestRepairModule = { 
            private _vehicle = ["O_T_Truck_03_repair_ghex_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTempestTransportModule = { 
            private _vehicle = ["O_T_Truck_03_transport_ghex_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createTempestTransportCoveredModule = { 
            private _vehicle = ["O_T_Truck_03_covered_ghex_F"] call MAZ_EZM_fnc_createVehicle;
    
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createZamakAmmoModule = { 
            private _vehicle = ["O_T_Truck_02_Ammo_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createZamakFuelModule = {
            private _vehicle = ["O_T_Truck_02_fuel_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createZamakMedicalModule = { 
            private _vehicle = ["O_T_Truck_02_Medical_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createZamakRepairModule = { 
            private _vehicle = ["O_T_Truck_02_Box_F"] call MAZ_EZM_fnc_createVehicle; 

            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createZamakTransportModule = { 
            private _vehicle = ["O_T_Truck_02_transport_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createZamakCoveredTransportModule = { 
            private _vehicle = ["O_T_Truck_02_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then { 
                private _driver = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _driver moveInDriver _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
    comment "Turrets"; 
    
        MAZ_EZM_CSATPacific_fnc_createM2HMGModule = { 
            private _vehicle = ["I_G_HMG_02_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
            
            _vehicle 
        }; 
    
        MAZ_EZM_CSATPacific_fnc_createM2HMGRaisedModule = { 
            private _vehicle = ["I_G_HMG_02_high_F"] call MAZ_EZM_fnc_createVehicle; 
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createMk32GMGModule = { 
            private _vehicle = ["O_GMG_01_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
            _vehicle disableTIEquipment true; 
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createMk6MortarModule = { 
            private _vehicle = ["O_Mortar_01_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
        
            _vehicle 
        }; 
        
        MAZ_EZM_CSATPacific_fnc_createAALauncherModule = { 
            private _vehicle = ["O_static_AA_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
        
            _vehicle 
        }; 

        MAZ_EZM_CSATPacific_fnc_createATLauncherModule = { 
            private _vehicle = ["O_static_AT_F"] call MAZ_EZM_fnc_createVehicle;
        
            if(MAZ_EZM_spawnWithCrew) then { 
                private _gunner = [] call MAZ_EZM_CSATPacific_fnc_createRiflemanModule; 
                _gunner moveInGunner _vehicle; 
            }; 
        
            _vehicle 
        };	

comment "CSAT (Africa) Units";

    comment "Anti-Air";
    comment "APCs";
    comment "Artillery";

        MAZ_EZM_AFR_fnc_createZamakMRLModule = {
            private _vehicle = ["I_E_Truck_02_MRL_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;

                private _gunner = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _gunner moveInGunner _vehicle;

                private _grp = createGroup [east,true];
                [_driver,_gunner] joinSilent _grp;
                _grp selectLeader _driver;				
            };

            [ 
                _vehicle, 
                ["Opfor",1] 
            ] call BIS_fnc_initVehicle;

            _vehicle
        };
        
    comment "Boats";

        MAZ_EZM_AFR_fnc_createDinghyModule = {
            private _vehicle = ["O_Boat_Transport_01_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };
            _vehicle
        };			

    comment "Cars";

        MAZ_EZM_AFR_fnc_createIfritModule = {
            private _vehicle = ["O_MRAP_02_F"] call MAZ_EZM_fnc_createVehicle;	
            _vehicle allowCrewInImmobile true;				

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };
            _vehicle
        };			

        MAZ_EZM_AFR_fnc_createIfritHMGModule = {
            private _vehicle = ["O_MRAP_02_hmg_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle allowCrewInImmobile true;				
            
            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;

                private _gunner = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _gunner moveInGunner _vehicle;

                private _grp = createGroup [east,true];
                [_driver,_gunner] joinSilent _grp;
                _grp selectLeader _driver;					
            };
            
            _vehicle
        };			

        MAZ_EZM_AFR_fnc_createQilinATModule = {
            private _vehicle = ["O_LSV_02_AT_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;

                private _gunner = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _gunner moveInGunner _vehicle;

                private _grp = createGroup [east,true];
                [_driver,_gunner] joinSilent _grp;
                _grp selectLeader _driver;										
            };

            [
                _vehicle,
                ["Black",1], 
                ["Unarmed_Doors_Hide",0]
            ] call BIS_fnc_initVehicle;	

            _vehicle
        };			

        MAZ_EZM_AFR_fnc_createQilinMinigunModule = {
            private _vehicle = ["O_LSV_02_armed_black_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;

                private _gunner = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _gunner moveInGunner _vehicle;			

                private _grp = createGroup [east,true];
                [_driver,_gunner] joinSilent _grp;
                _grp selectLeader _driver;									
            };

            _vehicle
        };			

        MAZ_EZM_AFR_fnc_createQilinModule = {
            private _vehicle = ["O_LSV_02_unarmed_black_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };

            _vehicle
        };	

        MAZ_EZM_AFR_fnc_createQuadModule = {
            private _vehicle = ["C_Quadbike_01_black_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };

            _vehicle
        };		

        MAZ_EZM_AFR_fnc_createZamakAmmoModule = {
            private _vehicle = ["O_Truck_02_Ammo_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };

            _vehicle	
        };	

        MAZ_EZM_AFR_fnc_createZamakFuelModule = {
            private _vehicle = ["O_Truck_02_fuel_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };

            _vehicle	
        };	

        MAZ_EZM_AFR_fnc_createZamakMedicalModule = {
            private _vehicle = ["O_Truck_02_medical_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };

            _vehicle	
        };	

        MAZ_EZM_AFR_fnc_createZamakRepairModule = {
            private _vehicle = ["O_Truck_02_box_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };

            _vehicle	
        };	

        MAZ_EZM_AFR_fnc_createZamakTransportModule = {
            private _vehicle = ["O_Truck_02_transport_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };

            _vehicle	
        };				

        MAZ_EZM_AFR_fnc_createZamakTransportCoveredModule = {
            private _vehicle = ["O_Truck_02_covered_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
                _driver moveInDriver _vehicle;
            };

            _vehicle	
        };	

    comment "Helicopters";
    
        MAZ_EZM_AFR_fnc_createTaruModule = {
            private _vehicle = ["O_Heli_Transport_04_black_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _loadMaster = [] call MAZ_EZM_AFR_fnc_createHeliCrewModule;
                _loadMaster moveinturret [_vehicle, [1]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot,_loadMaster] joinSilent _grp;
                _grp selectLeader _driver;
            };

            _vehicle
        };

        MAZ_EZM_AFR_fnc_createTaruAmmoModule = {
            private _vehicle = ["O_Heli_Transport_04_ammo_black_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _loadMaster = [] call MAZ_EZM_AFR_fnc_createHeliCrewModule;
                _loadMaster moveinturret [_vehicle, [1]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot,_loadMaster] joinSilent _grp;
                _grp selectLeader _driver;
            };

            _vehicle
        };

        MAZ_EZM_AFR_fnc_createTaruBenchModule = {
            private _vehicle = ["O_Heli_Transport_04_bench_black_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _loadMaster = [] call MAZ_EZM_AFR_fnc_createHeliCrewModule;
                _loadMaster moveinturret [_vehicle, [1]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot,_loadMaster] joinSilent _grp;
                _grp selectLeader _driver;
            };

            _vehicle
        };

        MAZ_EZM_AFR_fnc_createTaruCargoModule = {
            private _vehicle = ["O_Heli_Transport_04_box_black_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _loadMaster = [] call MAZ_EZM_AFR_fnc_createHeliCrewModule;
                _loadMaster moveinturret [_vehicle, [1]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot,_loadMaster] joinSilent _grp;
                _grp selectLeader _driver;
            };

            _vehicle
        };

        MAZ_EZM_AFR_fnc_createTaruFuelModule = {
            private _vehicle = ["O_Heli_Transport_04_fuel_black_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _loadMaster = [] call MAZ_EZM_AFR_fnc_createHeliCrewModule;
                _loadMaster moveinturret [_vehicle, [1]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot,_loadMaster] joinSilent _grp;
                _grp selectLeader _driver;
            };

            _vehicle
        };

        MAZ_EZM_AFR_fnc_createTaruMedicalModule = {
            private _vehicle = ["O_Heli_Transport_04_medevac_black_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _loadMaster = [] call MAZ_EZM_AFR_fnc_createHeliCrewModule;
                _loadMaster moveinturret [_vehicle, [1]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot,_loadMaster] joinSilent _grp;
                _grp selectLeader _driver;
            };

            _vehicle
        };

        MAZ_EZM_AFR_fnc_createTaruRepairModule = {
            private _vehicle = ["O_Heli_Transport_04_repair_black_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _loadMaster = [] call MAZ_EZM_AFR_fnc_createHeliCrewModule;
                _loadMaster moveinturret [_vehicle, [1]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot,_loadMaster] joinSilent _grp;
                _grp selectLeader _driver;
            };

            _vehicle
        };

        MAZ_EZM_AFR_fnc_createTaruTransportModule = {
            private _vehicle = ["O_Heli_Transport_04_covered_black_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _loadMaster = [] call MAZ_EZM_AFR_fnc_createHeliCrewModule;
                _loadMaster moveinturret [_vehicle, [1]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot,_loadMaster] joinSilent _grp;
                _grp selectLeader _driver;
            };

            _vehicle
        };

        MAZ_EZM_AFR_fnc_createOrcaUnarmedModule = {
            private _vehicle = ["O_Heli_Light_02_unarmed_F"] call MAZ_EZM_fnc_createVehicle;

            [_vehicle,"Hex"] call bis_fnc_initVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot] joinSilent _grp;
                _grp selectLeader _driver;
            };

            [
                _vehicle,
                ["Blackcustom",1], 
                true
            ] call BIS_fnc_initVehicle;

            _vehicle
        };	
        
        MAZ_EZM_AFR_fnc_createOrcaModule = {
            private _vehicle = ["O_Heli_Light_02_v2_F"] call MAZ_EZM_fnc_createVehicle;

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _driver moveInDriver _vehicle;

                private _coPilot = [] call MAZ_EZM_AFR_fnc_createHeliPilotModule;
                _coPilot moveinturret [_vehicle, [0]];

                private _grp = createGroup [east,true];
                [_driver,_coPilot] joinSilent _grp;
                _grp selectLeader _driver;
            };

            [
                _vehicle,
                ["Blackcustom",1], 
                true
            ] call BIS_fnc_initVehicle;

            _vehicle
        };

    comment "Men";
        MAZ_EZM_AFR_fnc_createAmmoBearerModule = {
            private _unit = [east,"O_A_soldier_A_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createAutoriflemanModule = {
            private _unit = [east,"O_A_soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createATRiflemanModule = {
            private _unit = [east,"O_A_soldier_AT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createRiflemanModule = {
            private _unit = [east,"O_A_soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createMedicModule = {
            private _unit = [east,"O_A_medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createOfficerModule = {
            private _unit = [east,"O_A_officer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createMissleAAModule = {
            private _unit = [east,"O_A_soldier_AA_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createGrenadierModule = {
            private _unit = [east,"O_A_soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createLATRiflemanModule = {
            private _unit = [east,"O_A_soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createMarksmanModule = {
            private _unit = [east,"O_A_soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };		

        MAZ_EZM_AFR_fnc_createSquadLeaderModule = {
            private _unit = [east,"O_A_soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };			

        MAZ_EZM_AFR_fnc_createTeamLeaderModule = {
            private _unit = [east,"O_A_soldier_TL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit
        };

        MAZ_EZM_AFR_fnc_createCrewmanModule = {
            private _unit = [east,"O_A_soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit setUnitLoadout [["arifle_Katiba_C_F","","","",["30Rnd_65x39_caseless_green",30],[],""],[],[],["U_O_officer_noInsignia_hex_F",[["FirstAidKit",1],["30Rnd_65x39_caseless_green",3,30]]],["V_BandollierB_cbr",[["Chemlight_red",2,1]]],[],"H_Tank_black_F","G_Lowprofile",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
            _unit
        };

        MAZ_EZM_AFR_fnc_createHeliPilotModule = {
            private _unit = [east,"O_A_soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit setUnitLoadout [["arifle_Katiba_C_F","","","",["30Rnd_65x39_caseless_green",30],[],""],[],[],["U_O_officer_noInsignia_hex_F",[["FirstAidKit",1],["30Rnd_65x39_caseless_green",3,30]]],["V_TacVest_brn",[["Chemlight_red",2,1]]],[],"H_PilotHelmetHeli_B","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
            _unit
        };

        MAZ_EZM_AFR_fnc_createHeliCrewModule = {
            private _unit = [east,"O_A_soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
            _unit setUnitLoadout [["arifle_Katiba_C_F","","","",["30Rnd_65x39_caseless_green",30],[],""],[],[],["U_O_officer_noInsignia_hex_F",[["FirstAidKit",1],["30Rnd_65x39_caseless_green",3,30]]],["V_TacVest_brn",[["Chemlight_red",2,1]]],[],"H_CrewHelmetHeli_B","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
            _unit
        };

    comment "Tanks";

        MAZ_EZM_AFR_fnc_createT100Module = {
            private _vehicle = ["O_MBT_02_cannon_F"] call MAZ_EZM_fnc_createVehicle;
            _vehicle disableTIEquipment true;
            _vehicle allowCrewInImmobile true;				

            if(MAZ_EZM_spawnWithCrew) then {
                private _driver = [] call MAZ_EZM_AFR_fnc_createCrewmanModule;
                _driver moveInDriver _vehicle;

                private _gunner = [] call MAZ_EZM_AFR_fnc_createCrewmanModule;
                _gunner moveInGunner _vehicle;

                private _gunner = [] call MAZ_EZM_AFR_fnc_createCrewmanModule;
                _gunner moveInCommander _vehicle;

                private _grp = createGroup [east,true];
                [_driver,_gunner] joinSilent _grp;
                _grp selectLeader _gunner;
            };

            _vehicle
        };

    comment "Groups";

        MAZ_EZM_AFR_fnc_createFireTeamModule = {
            private _squadLead = call MAZ_EZM_AFR_fnc_createTeamLeaderModule;
            private _grp = group _squadLead;
            {
                private _unit = call (missionNamespace getVariable _x);
                [_unit] joinSilent _grp;
            } forEach [
                'MAZ_EZM_AFR_fnc_createAutoriflemanModule',
                'MAZ_EZM_AFR_fnc_createGrenadierModule',
                'MAZ_EZM_AFR_fnc_createATRiflemanModule'
            ];
            _grp setBehaviour "AWARE";
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead
        };

        MAZ_EZM_AFR_fnc_createRifleSquadModule = {
            private _squadLead = call MAZ_EZM_AFR_fnc_createSquadLeaderModule;
            private _grp = group _squadLead;
            {
                private _unit = call (missionNamespace getVariable _x);
                [_unit] joinSilent _grp;
            } forEach [
                'MAZ_EZM_AFR_fnc_createRiflemanModule',
                'MAZ_EZM_AFR_fnc_createATRiflemanModule',
                'MAZ_EZM_AFR_fnc_createMarksmanModule',
                'MAZ_EZM_AFR_fnc_createTeamLeaderModule',
                'MAZ_EZM_AFR_fnc_createAutoriflemanModule',
                'MAZ_EZM_AFR_fnc_createAmmobearerModule',
                'MAZ_EZM_AFR_fnc_createMedicModule'
            ];
            _grp setBehaviour "AWARE";
            {_x setunitpos MAZ_EZM_stanceForAI} foreach units _squadLead
        };

comment "Zeus Interface";
MAZ_EZM_CSATP_fnc_modules = {
    with uiNamespace do {
        comment "CSAT (China) Modules"; 
				
            MAZ_CSATPTree = [
                MAZ_UnitsTree_OPFOR,
                "CSAT (China)",
                ""
            ] call MAZ_EZM_fnc_zeusAddCategory;

            MAZ_UnitsTree_OPFOR tvSetPictureRight [[MAZ_CSATPTree], "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_csat_ca.paa"]; 
            MAZ_UnitsTree_OPFOR tvSetTooltip [[MAZ_CSATPTree], format ["Chinese CSAT with arid camouflage.\n\nAn Official EZM Faction.\nVersion: %1",missionNamespace getVariable "MAZ_EZM_CSATP_Ver"]]; 

        comment "Anti-Air";

            MAZ_CSATPAntiAirTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Anti-Air", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPAntiAirTree, 
                "Tigris ZSU-39", 
                "Tigris", 
                "MAZ_EZM_CSATP_fnc_createTigris", 
                "a3\armor_f_beta\apc_tracked_02\data\ui\map_apc_tracked_02_aa_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPAntiAirTree, 
                "Tigris ZSU-39 (No Missiles)", 
                "Tigris without missiles", 
                "MAZ_EZM_CSATP_fnc_createTigrisMissile", 
                "a3\armor_f_beta\apc_tracked_02\data\ui\map_apc_tracked_02_aa_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "APCs"; 
            
            MAZ_CSATPAPCsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "APCs", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPAPCsTree, 
                "BTR-K Kamysh", 
                "BTR-K Kamysh", 
                "MAZ_EZM_CSATP_fnc_createBTRK", 
                "a3\armor_f_beta\apc_tracked_02\data\ui\map_apc_tracked_02_cannon_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPAPCsTree, 
                "MSE-3 Marid", 
                "MSE-3 Marid", 
                "MAZ_EZM_CSATP_fnc_createMarid", 
                "a3\armor_f_beta\apc_wheeled_02\data\ui\map_apc_wheeled_02_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPAPCsTree, 
                "MSE-3 Marid (No Turret)", 
                "MSE-3 Marid (No Turret)", 
                "MAZ_EZM_CSATP_fnc_createMaridNoTurret", 
                "a3\armor_f_beta\apc_wheeled_02\data\ui\map_apc_wheeled_02_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Artillery"; 
            
            MAZ_CSATPArtilleryTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Artillery", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPArtilleryTree, 
                "2S9 Sochor", 
                "2S9 Sochor", 
                "MAZ_EZM_CSATP_fnc_createSochorModule", 
                "a3\armor_f_gamma\mbt_02\data\ui\map_mbt_arty_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [  
                MAZ_UnitsTree_OPFOR,  
                MAZ_CSATPTree,  
                MAZ_CSATPArtilleryTree,  
                "2S9 Sochor (No Commander)",  
                "2S9 Sochor (No Commander)",  
                "MAZ_EZM_CSATP_fnc_createSochorNoCommanderModule",  
                "a3\armor_f_gamma\mbt_02\data\ui\map_mbt_arty_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;  

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPArtilleryTree, 
                "Zamak MRL", 
                "Zamak MRL", 
                "MAZ_EZM_CSATP_fnc_createMRLModule", 
                "a3\soft_f_gamma\truck_02\data\ui\map_truck_02_mrl_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
        comment "Boats"; 
        
            MAZ_CSATPBoatsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Boats", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPBoatsTree, 
                "Assault Boat", 
                "Assault Boat", 
                "MAZ_EZM_CSATP_fnc_createAssaultBoatModule", 
                "a3\boat_f\boat_transport_01\data\ui\map_boat_transport_01_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPBoatsTree, 
                "RHIB", 
                "RHIB", 
                "MAZ_EZM_CSATP_fnc_createRhibBoatModule", 
                "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPBoatsTree, 
                "Speedboat (No Turret)", 
                "Speedboat (No Turret)", 
                "MAZ_EZM_CSATP_fnc_createSpeedBoatModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPBoatsTree, 
                "Speedboat HMG", 
                "Speedboat HMG", 
                "MAZ_EZM_CSATP_fnc_createSpeedBoatHMGModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPBoatsTree, 
                "Speedboat Minigun", 
                "Speedboat Minigun", 
                "MAZ_EZM_CSATP_fnc_createSpeedBoatMinigunModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Cars"; 
        
            MAZ_CSATPCarsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Cars", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCarsTree, 
                "Ifrit", 
                "Ifrit", 
                "MAZ_EZM_CSATP_fnc_createIfritModule", 
                "a3\soft_f\mrap_02\data\ui\map_mrap_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCarsTree, 
                "Ifrit GMG", 
                "Ifrit GMG", 
                "MAZ_EZM_CSATP_fnc_createIfritGMGModule", 
                "a3\soft_f\mrap_02\data\ui\map_mrap_02_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCarsTree, 
                "Ifrit HMG", 
                "Ifrit HMG", 
                "MAZ_EZM_CSATP_fnc_createIfritHMGModule", 
                "a3\soft_f\mrap_02\data\ui\map_mrap_02_hmg_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCarsTree, 
                "Qilin (AT)", 
                "Qilin (AT)", 
                "MAZ_EZM_CSATP_fnc_createQilinATModule", 
                "a3\soft_f_exp\lsv_01\data\ui\map_lsv_01_armed_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCarsTree, 
                "Qilin (Mingun)", 
                "Qilin (Mingun)", 
                "MAZ_EZM_CSATP_fnc_createQilinMinigunModule", 
                "a3\soft_f_exp\lsv_02\data\ui\map_lsv_02_armed_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCarsTree, 
                "Qilin (Unarmed)", 
                "Qilin (Unarmed)", 
                "MAZ_EZM_CSATP_fnc_createQilinUnarmedModule", 
                "a3\soft_f_exp\lsv_02\data\ui\map_lsv_02_base_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCarsTree, 
                "Quadbike", 
                "Quadbike", 
                "MAZ_EZM_CSATP_fnc_createQuadbikeModule", 
                "a3\soft_f\quadbike_01\data\ui\map_quad_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Compositions";

            MAZ_CSATPCompositionsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Compositions", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCompositionsTree, 
                "Cache #1", 
                "Cache #1", 
                "MAZ_EZM_CSATP_fnc_createCache1Module", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCompositionsTree, 
                "Cache #2", 
                "Cache #2", 
                "MAZ_EZM_CSATP_fnc_createCache2Module", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCompositionsTree, 
                "Dead Soldier", 
                "Dead Soldier", 
                "MAZ_EZM_CSATP_fnc_createDeadSoldierModule", 
                "a3\ui_f_curator\data\cfgmarkers\kia_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCompositionsTree, 
                "Taru Bench Pod", 
                "Taru Bench Pod", 
                "MAZ_EZM_CSATP_fnc_createOpenedTaruBenchPodModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\pod_heli_transport_04_bench_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPCompositionsTree, 
                "Taru Transport Pod", 
                "Taru Transport Pod", 
                "MAZ_EZM_CSATP_fnc_createOpenedTaruTransportPodModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\pod_heli_transport_04_covered_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Drones"; 
        
            MAZ_CSATPDronesTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Drones", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPDronesTree, 
                "Jinaah AL-6 (Leaflet)", 
                "Jinaah AL-6 (Leaflet)", 
                "MAZ_EZM_CSATP_fnc_createJinaahLeafletModule", 
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPDronesTree, 
                "Jinaah AL-6 (Medical)", 
                "Jinaah AL-6 (Medical)", 
                "MAZ_EZM_CSATP_fnc_createJinaahMedicalModule", 
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPDronesTree, 
                "K40 Ababil-3", 
                "K40 Ababil-3", 
                "MAZ_EZM_CSATP_fnc_createK40Module", 
                "a3\drones_f\air_f_gamma\uav_02\data\ui\map_uav_02_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPDronesTree, 
                "KH-3A Fenghuang", 
                "KH-3A Fenghuang", 
                "MAZ_EZM_CSATP_fnc_createKH3AModule", 
                "a3\air_f_exp\uav_04\data\ui\map_uav_04_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPDronesTree, 
                "Tayran AR-2", 
                "Tayran AR-2", 
                "MAZ_EZM_CSATP_fnc_createTayranModule", 
                "a3\drones_f\air_f_gamma\uav_01\data\ui\map_uav_01_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPDronesTree, 
                "UGV Saif", 
                "UGV Saif", 
                "MAZ_EZM_CSATP_fnc_createSaifModule", 
                "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPDronesTree, 
                "UGV Saif RCWS", 
                "UGV Saif RCWS", 
                "MAZ_EZM_CSATP_fnc_createSaifRCWSModule", 
                "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
        comment "Groups"; 
        
            MAZ_CSATPSubCatTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Groups", 
                "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Anti-Air Team", 
                "Anti-Air Team", 
                "MAZ_EZM_CSATP_fnc_createAntiAirTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Anti-Tank Team", 
                "Anti-Tank Team", 
                "MAZ_EZM_CSATP_fnc_createAntiTankTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [  
                MAZ_UnitsTree_OPFOR,  
                MAZ_CSATPTree,  
                MAZ_CSATPSubCatTree,  
                "Marksman Team",  
                "Marksman Team",  
                "MAZ_EZM_CSATP_fnc_createMarksmanTeamModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;  

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Patrol", 
                "Patrol", 
                "MAZ_EZM_CSATP_fnc_createPatrolModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [
                MAZ_UnitsTree_OPFOR,
                MAZ_CSATPTree,
                MAZ_CSATPSubCatTree,
                "Recon Squad",
                "Recon BIN_fnc_setAISquadID",
                "MAZ_EZM_CSATP_fnc_createReconSquadModule",
                ""
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Squad", 
                "Squad", 
                "MAZ_EZM_CSATP_fnc_createSquadModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Sentry", 
                "Sentry", 
                "MAZ_EZM_CSATP_fnc_createSentryModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Sniper Team", 
                "Sniper Team", 
                "MAZ_EZM_CSATP_fnc_createSniperTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Groups (Urban)";

            MAZ_CSATPSubCatTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Groups (Urban)", 
                "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Anti-Air Team", 
                "Anti-Air Team", 
                "MAZ_EZM_CSATP_fnc_createAntiAirTeamUrbanModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Anti-Tank Team", 
                "Anti-Tank Team", 
                "MAZ_EZM_CSATP_fnc_createAntiTankTeamUrbanModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Patrol", 
                "Patrol", 
                "MAZ_EZM_CSATP_fnc_createPatrolUrbanModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Squad", 
                "Squad", 
                "MAZ_EZM_CSATP_fnc_createSquadUrbanModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Sentry", 
                "Sentry", 
                "MAZ_EZM_CSATP_fnc_createSentryUrbanModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Marksman Team", 
                "Marksman Team", 
                "MAZ_EZM_CSATP_fnc_createMarksmanTeamUrbanModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Helicopters";
        
            MAZ_CSATPSubCatTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Helicopters", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-290 Taru", 
                "Mi-290 Taru", 
                "MAZ_EZM_CSATP_fnc_createTaruModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-290 Taru (Ammo)", 
                "Mi-290 Taru (Ammo)", 
                "MAZ_EZM_CSATP_fnc_createTaruAmmoModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_ammo_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-290 Taru (Bench)", 
                "Mi-290 Taru (Bench)", 
                "MAZ_EZM_CSATP_fnc_createTaruBenchModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_bench_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-290 Taru (Cargo)", 
                "Mi-290 Taru (Cargo)", 
                "MAZ_EZM_CSATP_fnc_createTaruCargoModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_box_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-290 Taru (Fuel)", 
                "Mi-290 Taru (Fuel)", 
                "MAZ_EZM_CSATP_fnc_createTaruFuelModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_fuel_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-290 Taru (Medical)", 
                "Mi-290 Taru (Medical)", 
                "MAZ_EZM_CSATP_fnc_createTaruMedicalModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_medevac_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-290 Taru (Repair)", 
                "Mi-290 Taru (Repair)", 
                "MAZ_EZM_CSATP_fnc_createTaruRepairModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_repair_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-290 Taru (Transport)", 
                "Mi-290 Taru (Transport)", 
                "MAZ_EZM_CSATP_fnc_createTaruTransportModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_covered_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "Mi-48 Kajman", 
                "Mi-48 Kajman", 
                "MAZ_EZM_CSATP_fnc_createTaruKajmanModule", 
                "a3\air_f_beta\heli_attack_02\data\ui\map_heli_attack_02_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "PO-30 Orca", 
                "PO-30 Orca", 
                "MAZ_EZM_CSATP_fnc_createOrcaModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSubCatTree, 
                "PO-30 Orca (Unarmed)", 
                "PO-30 Orca", 
                "MAZ_EZM_CSATP_fnc_createOrcaUnarmedModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

        comment "Men"; 
            
            MAZ_CSATPMenTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Men", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Ammo Bearer", 
                "Ammo Bearer", 
                "MAZ_EZM_CSATP_fnc_createAmmoBearerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Autorifleman", 
                "Autorifleman", 
                "MAZ_EZM_CSATP_fnc_createAutoriflemanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Combat Lifesaver", 
                "Combat Lifesaver", 
                "MAZ_EZM_CSATP_fnc_createCombatMedicModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Crewman", 
                "Crewman", 
                "MAZ_EZM_CSATP_fnc_createCrewmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Engineer", 
                "Engineer", 
                "MAZ_EZM_CSATP_fnc_createEngineerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Grenadier", 
                "Grenadier", 
                "MAZ_EZM_CSATP_fnc_createGrenadierModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Heavy Gunner", 
                "Heavy Gunner", 
                "MAZ_EZM_CSATP_fnc_createHeavyGunnerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Helicopter Crew", 
                "Helicopter Crew", 
                "MAZ_EZM_CSATP_fnc_createHelicopterCrewModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Helicopter Pilot", 
                "Helicopter Pilot", 
                "MAZ_EZM_CSATP_fnc_createHelicopterPilotModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Pilot", 
                "Pilot", 
                "MAZ_EZM_CSATP_fnc_createPilotModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Fighter Pilot", 
                "Fighter Pilot", 
                "MAZ_EZM_CSATP_fnc_createFighterPilotModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Marksman", 
                "Marksman", 
                "MAZ_EZM_CSATP_fnc_createMarksmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Missile Specialist (AA)", 
                "Anti-Air Missile Specialist", 
                "MAZ_EZM_CSATP_fnc_createMissileSpecAAModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Missile Specialist (AT)", 
                "Anti-Tank Missile Specialist", 
                "MAZ_EZM_CSATP_fnc_createMissileSpecATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Officer", 
                "Officer", 
                "MAZ_EZM_CSATP_fnc_createOfficerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManOfficer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Rifleman", 
                "Rifleman", 
                "MAZ_EZM_CSATP_fnc_createRiflemanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Rifleman (LAT)", 
                "Light Anti-Tank Rifleman", 
                "MAZ_EZM_CSATP_fnc_createRiflemanLATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Rifleman (Light)", 
                "Rifleman (Light)", 
                "MAZ_EZM_CSATP_fnc_createRiflemanLightModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Rifleman (HAT)", 
                "Heavy Anti-Tank Rifleman", 
                "MAZ_EZM_CSATP_fnc_createRiflemanHATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Sharpshooter", 
                "Sharpshooter", 
                "MAZ_EZM_CSATP_fnc_createSharpshooterModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Squad Leader", 
                "Squad Leader", 
                "MAZ_EZM_CSATP_fnc_createSquadLeadModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Radio Operator", 
                "Radio Operator", 
                "MAZ_EZM_CSATP_fnc_createRadiomanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPMenTree, 
                "Survivor", 
                "Survivor", 
                "MAZ_EZM_CSATP_fnc_createSurvivorModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Men (Special Forces)";

            MAZ_CSATPSpecialMenTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Men (Special Forces)", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Diver", 
                "Diver", 
                "MAZ_EZM_CSATP_fnc_createDiverModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Recon Demo Specialist", 
                "Recon Demo Specialist", 
                "MAZ_EZM_CSATP_fnc_createReconDemoModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Recon JTAC", 
                "Recon JTAC", 
                "MAZ_EZM_CSATP_fnc_createReconJTACModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Recon Marksman", 
                "Recon Marksman", 
                "MAZ_EZM_CSATP_fnc_createReconMarksmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Recon Paramedic", 
                "Recon Paramedic", 
                "MAZ_EZM_CSATP_fnc_createReconParamedicModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Recon Scout", 
                "Recon Scout", 
                "MAZ_EZM_CSATP_fnc_createReconScoutModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Recon Scout (AT)", 
                "Recon Scout (AT)", 
                "MAZ_EZM_CSATP_fnc_createReconScoutATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Recon Team Leader", 
                "Recon Team Leader", 
                "MAZ_EZM_CSATP_fnc_createReconTeamLeaderModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Sniper", 
                "Sniper", 
                "MAZ_EZM_CSATP_fnc_createReconSniperModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPSpecialMenTree, 
                "Spotter", 
                "Spotter", 
                "MAZ_EZM_CSATP_fnc_createReconSpotterModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Men (Urban)";

            MAZ_CSATPUrbanMenTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Men (Urban)", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Ammo Bearer", 
                "Ammo Bearer", 
                "MAZ_EZM_CSATP_fnc_createAmmoBearerUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Autorifleman", 
                "Autorifleman", 
                "MAZ_EZM_CSATP_fnc_createAutoriflemanUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Combat Lifesaver", 
                "Combat Lifesaver", 
                "MAZ_EZM_CSATP_fnc_createCombatMedicUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Crewman", 
                "Crewman", 
                "MAZ_EZM_CSATP_fnc_createCrewmanUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Engineer", 
                "Engineer", 
                "MAZ_EZM_CSATP_fnc_createEngineerUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Grenadier", 
                "Grenadier", 
                "MAZ_EZM_CSATP_fnc_createGrenadierUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Heavy Gunner", 
                "Heavy Gunner", 
                "MAZ_EZM_CSATP_fnc_createHeavyGunnerUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Marksman", 
                "Marksman", 
                "MAZ_EZM_CSATP_fnc_createMarksmanUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Missile Specialist (AA)", 
                "Anti-Air Missile Specialist", 
                "MAZ_EZM_CSATP_fnc_createMissileSpecAAUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Missile Specialist (AT)", 
                "Anti-Tank Missile Specialist", 
                "MAZ_EZM_CSATP_fnc_createMissileSpecATUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Rifleman", 
                "Rifleman", 
                "MAZ_EZM_CSATP_fnc_createRiflemanUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Rifleman (LAT)", 
                "Light Anti-Tank Rifleman.", 
                "MAZ_EZM_CSATP_fnc_createRiflemanLATUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Rifleman (HAT)", 
                "Heavy Anti-Tank Rifleman.", 
                "MAZ_EZM_CSATP_fnc_createRiflemanHATUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Sharpshooter", 
                "Sharpshooter", 
                "MAZ_EZM_CSATP_fnc_createSharpshooterUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Squad Leader", 
                "Squad Leader", 
                "MAZ_EZM_CSATP_fnc_createSquadLeadUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Radio Operator", 
                "Radio Operator", 
                "MAZ_EZM_CSATP_fnc_createRadiomanUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPUrbanMenTree, 
                "Survivor", 
                "Survivor", 
                "MAZ_EZM_CSATP_fnc_createSurvivorUrbanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Reinforcement"; 
        
            MAZ_CSATPReinforcementTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Reinforcement", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementTree, 
                "Orca (Unarmed)", 
                "Orca (Unarmed)", 
                "MAZ_EZM_CSATP_fnc_createReinforcementOrcaModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementTree, 
                "Qilin (Unarmed)", 
                "Qilin (Unarmed)", 
                "MAZ_EZM_CSATP_fnc_createReinforcementQilinUnarmedModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementTree, 
                "RHIB", 
                "RHIB", 
                "MAZ_EZM_CSATP_fnc_createReinforcementRhibModule", 
                "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementTree, 
                "Taru (Transport)", 
                "Taru (Transport)", 
                "MAZ_EZM_CSATP_fnc_createReinforcementTaruModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_covered_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementTree, 
                "Tempest Transport", 
                "Tempest Transport", 
                "MAZ_EZM_CSATP_fnc_createReinforcementTempestTransportModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_transport_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementTree, 
                "Zamak Tansport", 
                "Zamak Transport", 
                "MAZ_EZM_CSATP_fnc_createReinforcementZamakCoveredTransportModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_dump_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Reinforcement (Urban)"; 
        
            MAZ_CSATPReinforcementUrbanTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Reinforcement (Urban)", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementUrbanTree, 
                "Orca (Unarmed)", 
                "Orca (Unarmed)", 
                "MAZ_EZM_CSATP_fnc_createReinforcementOrcaUrbanModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementUrbanTree, 
                "Qilin (Unarmed)", 
                "Qilin (Unarmed)", 
                "MAZ_EZM_CSATP_fnc_createReinforcementQilinUnarmedUrbanModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementUrbanTree, 
                "RHIB", 
                "RHIB", 
                "MAZ_EZM_CSATP_fnc_createReinforcementRhibUrbanModule", 
                "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementUrbanTree, 
                "Taru (Transport)", 
                "Taru (Transport)", 
                "MAZ_EZM_CSATP_fnc_createReinforcementTaruUrbanModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_covered_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementUrbanTree, 
                "Tempest Transport", 
                "Tempest Transport", 
                "MAZ_EZM_CSATP_fnc_createReinforcementTempestTransportUrbanModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_transport_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPReinforcementUrbanTree, 
                "Zamak Tansport", 
                "Zamak Transport", 
                "MAZ_EZM_CSATP_fnc_createReinforcementZamakCoveredTransportUrbanModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_dump_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Planes";
        
            MAZ_CSATPPlanesTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Planes", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPPlanesTree, 
                "A-143 Buzzard (CAS)", 
                "A-143 Buzzard (CAS)", 
                "MAZ_EZM_CSATP_fnc_createBuzzardCASModule", 
                "a3\air_f_gamma\plane_fighter_03\data\ui\map_plane_fighter_03_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPPlanesTree, 
                "To-199 Neophron (CAS)", 
                "To-199 Neophron (CAS)", 
                "MAZ_EZM_CSATP_fnc_createNeophronCASModule", 
                "a3\air_f_epc\plane_cas_02\data\ui\map_plane_cas_02_f.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPPlanesTree, 
                "To-201 Shikra", 
                "To-201 Shikra", 
                "MAZ_EZM_CSATP_fnc_createShikraModule", 
                "a3\air_f_jets\plane_fighter_02\data\ui\fighter02_icon_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPPlanesTree, 
                "Y-32 Xi'an (Infantry Transport)", 
                "Y-32 Xi'an (Infantry Transport)", 
                "MAZ_EZM_CSATP_fnc_createVTOLInfantryModule", 
                "a3\air_f_exp\vtol_02\data\ui\map_vtol_02_vehicle_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPPlanesTree, 
                "Y-32 Xi'an (Vehicle Transport)", 
                "Y-32 Xi'an (Vehicle Transport)", 
                "MAZ_EZM_CSATP_fnc_createVTOLVehicleModule", 
                "a3\air_f_exp\vtol_02\data\ui\map_vtol_02_vehicle_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
                
        comment "Tanks"; 
            
            MAZ_CSATPTankTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Tanks", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTankTree, 
                "T-100 Varsuk", 
                "T-100 Varsuk", 
                "MAZ_EZM_CSATP_fnc_createVarsukModule", 
                "a3\armor_f_gamma\mbt_02\data\ui\map_mbt_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTankTree, 
                "T-140 Angara", 
                "T-140 Angara", 
                "MAZ_EZM_CSATP_fnc_createAngaraModule", 
                "a3\armor_f_tank\mbt_04\data\ui\map_mbt_04_cannon_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTankTree, 
                "T-140K Angara", 
                "T-140K Angara", 
                "MAZ_EZM_CSATP_fnc_createAngaraKModule", 
                "a3\armor_f_tank\mbt_04\data\ui\map_mbt_04_command_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
        comment "Trucks"; 
        
            MAZ_CSATPTrucksTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Trucks", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Tempest (Device)", 
                "Tempest Device", 
                "MAZ_EZM_CSATP_fnc_createTempestDeviceModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_device_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Tempest Ammo", 
                "Tempest Ammo", 
                "MAZ_EZM_CSATP_fnc_createTempestAmmoModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_ammo_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Tempest Fuel", 
                "Tempest Fuel", 
                "MAZ_EZM_CSATP_fnc_createTempestFuelModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_fuel_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Tempest Medical", 
                "Tempest Medical", 
                "MAZ_EZM_CSATP_fnc_createTempestMedicalModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_medevac_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Tempest Repair", 
                "Tempest Repair", 
                "MAZ_EZM_CSATP_fnc_createTempestRepairModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_ammo_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Tempest Transport", 
                "Tempest Transport", 
                "MAZ_EZM_CSATP_fnc_createTempestTransportModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_transport_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Tempest Transport (Covered)", 
                "Tempest Transport", 
                "MAZ_EZM_CSATP_fnc_createTempestTransportCoveredModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_covered_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Zamak Ammo", 
                "Zamak Ammo", 
                "MAZ_EZM_CSATP_fnc_createZamakAmmoModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_box_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Zamak Fuel", 
                "Zamak Fuel", 
                "MAZ_EZM_CSATP_fnc_createZamakFuelModule", 
                "a3\soft_f_gamma\truck_02\data\ui\map_truck_02_fuel_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Zamak Medical", 
                "Medical Zamak", 
                "MAZ_EZM_CSATP_fnc_createZamakMedicalModule", 
                "a3\soft_f_gamma\truck_02\data\ui\map_truck_02_medevac_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Zamak Repair", 
                "Zamak Repair", 
                "MAZ_EZM_CSATP_fnc_createZamakRepairModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_repair_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Zamak Transport", 
                "Zamak", 
                "MAZ_EZM_CSATP_fnc_createZamakTransportModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_dump_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTrucksTree, 
                "Zamak Transport (Covered)", 
                "Zamak (Covered)", 
                "MAZ_EZM_CSATP_fnc_createZamakCoveredTransportModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Turrets"; 
        
            MAZ_CSATPTurretTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                "Turrets", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTurretTree, 
                "M2 HMG", 
                "M2 HMG", 
                "MAZ_EZM_CSATP_fnc_createM2HMGModule", 
                "\a3\static_f\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTurretTree, 
                "M2 HMG (Raised)", 
                "M2 HMG (Raised)", 
                "MAZ_EZM_CSATP_fnc_createM2HMGRaisedModule", 
                "a3\static_f_oldman\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTurretTree, 
                "Mk32 GMG", 
                "Mk32 GMG", 
                "MAZ_EZM_CSATP_fnc_createMk32GMGModule", 
                "\a3\static_f\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;  
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTurretTree, 
                "Mk6 Mortar", 
                "Mk6 Mortar", 
                "MAZ_EZM_CSATP_fnc_createMk6MortarModule", 
                "\A3\Static_f\Mortar_01\data\UI\map_Mortar_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTurretTree, 
                "Static AT Launcher", 
                "Static AT Launcher", 
                "MAZ_EZM_CSATP_fnc_createATLauncherModule", 
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AT_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPTree, 
                MAZ_CSATPTurretTree, 
                "Static AA Launcher", 
                "Static AA Launcher", 
                "MAZ_EZM_CSATP_fnc_createAALauncherModule", 
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AA_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

    comment "CSAT (Pacific) Modules"; 

            private _csatPacificLocalText = localize "$STR_A3_CFGFACTIONCLASSES_OPF_T_F0";
            MAZ_CSATPacificTree = [MAZ_UnitsTree_OPFOR,_csatPacificLocalText] call MAZ_EZM_fnc_findTree;
            private _count = MAZ_UnitsTree_OPFOR tvCount [MAZ_CSATPacificTree]; 
            for "_i" from 0 to (_count - 1) do { 
                MAZ_UnitsTree_OPFOR tvDelete [MAZ_CSATPacificTree,0]; 
            }; 

            MAZ_UnitsTree_OPFOR tvSetText [[MAZ_CSATPacificTree],"CSAT (Pacific)"];  
            MAZ_UnitsTree_OPFOR tvSetPictureRight [[MAZ_CSATPacificTree], "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_csat_ca.paa"]; 
            MAZ_UnitsTree_OPFOR tvSetTooltip [[MAZ_CSATPacificTree], format ["Chinese CSAT with green hex camouflage.\n\nAn Official EZM Faction.\nVersion: %1",missionNamespace getVariable "MAZ_EZM_CSATP_Ver"]]

        comment "Anti-Air";

            MAZ_CSATPacificAntiAirTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Anti-Air", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificAntiAirTree, 
                "Tigris ZSU-39", 
                "Tigris ZSU-39", 
                "MAZ_EZM_CSATPacific_fnc_createTigris", 
                "a3\armor_f_beta\apc_tracked_02\data\ui\map_apc_tracked_02_aa_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificAntiAirTree, 
                "Tigris ZSU-39 (No Missiles)", 
                "Tigris ZSU-39 (No Missiles)", 
                "MAZ_EZM_CSATPacific_fnc_createTigrisMissile", 
                "a3\armor_f_beta\apc_tracked_02\data\ui\map_apc_tracked_02_aa_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "APCs"; 
            
            MAZ_CSATPacificAPCsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "APCs", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificAPCsTree, 
                "BTR-K Kamysh", 
                "BTR-K Kamysh", 
                "MAZ_EZM_CSATPacific_fnc_createBTRK", 
                "a3\armor_f_beta\apc_tracked_02\data\ui\map_apc_tracked_02_cannon_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificAPCsTree, 
                "MSE-3 Marid", 
                "MSE-3 Marid", 
                "MAZ_EZM_CSATPacific_fnc_createMarid", 
                "a3\armor_f_beta\apc_wheeled_02\data\ui\map_apc_wheeled_02_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificAPCsTree, 
                "MSE-3 Marid (No Turret)", 
                "MSE-3 Marid (No Turret)", 
                "MAZ_EZM_CSATPacific_fnc_createMaridNoTurret", 
                "a3\armor_f_beta\apc_wheeled_02\data\ui\map_apc_wheeled_02_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Artillery"; 
            
            MAZ_CSATPacificArtilleryTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Artillery", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificArtilleryTree, 
                "2S9 Sochor", 
                "2S9 Sochor", 
                "MAZ_EZM_CSATPacific_fnc_createSochorModule", 
                "a3\armor_f_gamma\mbt_02\data\ui\map_mbt_arty_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [  
                MAZ_UnitsTree_OPFOR,  
                MAZ_CSATPacificTree,  
                MAZ_CSATPacificArtilleryTree,  
                "2S9 Sochor (No Commander)",  
                "2S9 Sochor (No Commander)",  
                "MAZ_EZM_CSATPacific_fnc_createSochorNoCommanderModule",  
                "a3\armor_f_gamma\mbt_02\data\ui\map_mbt_arty_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;  

        comment "Boats"; 
        
            MAZ_CSATPacificBoatsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Boats", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificBoatsTree, 
                "Assault Boat", 
                "Assault Boat", 
                "MAZ_EZM_CSATPacific_fnc_createAssaultBoatModule", 
                "a3\boat_f\boat_transport_01\data\ui\map_boat_transport_01_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificBoatsTree, 
                "RHIB", 
                "RHIB", 
                "MAZ_EZM_CSATPacific_fnc_createRhibBoatModule", 
                "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificBoatsTree, 
                "Speedboat (No Turret)", 
                "Speedboat (No Turret)", 
                "MAZ_EZM_CSATPacific_fnc_createSpeedBoatModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificBoatsTree, 
                "Speedboat HMG", 
                "Speedboat HMG", 
                "MAZ_EZM_CSATPacific_fnc_createSpeedBoatHMGModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificBoatsTree, 
                "Speedboat Minigun", 
                "Speedboat Minigun", 
                "MAZ_EZM_CSATPacific_fnc_createSpeedBoatMinigunModule", 
                "a3\boat_f\boat_armed_01\data\ui\map_boat_armed_01_minigun.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Cars"; 
        
            MAZ_CSATPacificCarsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Cars", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCarsTree, 
                "Ifrit", 
                "Ifrit", 
                "MAZ_EZM_CSATPacific_fnc_createIfritModule", 
                "a3\soft_f\mrap_02\data\ui\map_mrap_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCarsTree, 
                "Ifrit GMG", 
                "Ifrit GMG", 
                "MAZ_EZM_CSATPacific_fnc_createIfritGMGModule", 
                "a3\soft_f\mrap_02\data\ui\map_mrap_02_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCarsTree, 
                "Ifrit HMG", 
                "Ifrit HMG", 
                "MAZ_EZM_CSATPacific_fnc_createIfritHMGModule", 
                "a3\soft_f\mrap_02\data\ui\map_mrap_02_hmg_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCarsTree, 
                "Qilin (AT)", 
                "Qilin (AT)", 
                "MAZ_EZM_CSATPacific_fnc_createQilinATModule", 
                "a3\soft_f_exp\lsv_01\data\ui\map_lsv_01_armed_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCarsTree, 
                "Qilin (Mingun)", 
                "Qilin (Mingun)", 
                "MAZ_EZM_CSATPacific_fnc_createQilinMinigunModule", 
                "a3\soft_f_exp\lsv_02\data\ui\map_lsv_02_armed_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCarsTree, 
                "Qilin (Unarmed)", 
                "Qilin (Unarmed)", 
                "MAZ_EZM_CSATPacific_fnc_createQilinUnarmedModule", 
                "a3\soft_f_exp\lsv_02\data\ui\map_lsv_02_base_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCarsTree, 
                "Quadbike", 
                "Quadbike", 
                "MAZ_EZM_CSATPacific_fnc_createQuadbikeModule", 
                "a3\soft_f\quadbike_01\data\ui\map_quad_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Compositions";

            MAZ_CSATPacificCompositionsTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Compositions", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCompositionsTree, 
                "Cache #1", 
                "Cache #1", 
                "MAZ_EZM_CSATPacific_fnc_createCache1Module", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCompositionsTree, 
                "Cache #2", 
                "Cache #2", 
                "MAZ_EZM_CSATPacific_fnc_createCache2Module", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCompositionsTree, 
                "Dead Soldier", 
                "Dead Soldier", 
                "MAZ_EZM_CSATPacific_fnc_createDeadSoldierModule", 
                "a3\ui_f_curator\data\cfgmarkers\kia_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCompositionsTree, 
                "Black Taru Bench Pod", 
                "Black Taru Bench Pod", 
                "MAZ_EZM_CSATPacific_fnc_createOpenedTaruBenchPodModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\pod_heli_transport_04_bench_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCompositionsTree, 
                "Black Taru Cargo Pod", 
                "Black Taru Cargo Pod", 
                "MAZ_EZM_CSATPacific_fnc_createBlackCargoTaruPodModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\pod_heli_transport_04_covered_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCompositionsTree, 
                "Black Taru Fuel Pod", 
                "Balck Taru Fuel Pod", 
                "MAZ_EZM_CSATPacific_fnc_createBlackTaruFuelPodModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\pod_heli_transport_04_covered_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCompositionsTree, 
                "Black Taru Medical Pod", 
                "Balck Taru Medical Pod", 
                "MAZ_EZM_CSATPacific_fnc_createBlackMedicalTaruPodModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\Pod_Heli_Transport_04_medevac_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificCompositionsTree, 
                "Black Taru Transport Pod", 
                "Black Taru Transport Pod", 
                "MAZ_EZM_CSATPacific_fnc_createBlackTransportTaruPodModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\pod_heli_transport_04_covered_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 


        comment "Drones"; 
        
            MAZ_CSATPacificDronesTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Drones", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificDronesTree, 
                "Jinaah AL-6 (Leaflet)", 
                "Jinaah AL-6 (Leaflet)", 
                "MAZ_EZM_CSATPacific_fnc_createJinaahLeafletModule", 
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificDronesTree, 
                "Jinaah AL-6 (Medical)", 
                "Jinaah AL-6 (Medical)", 
                "MAZ_EZM_CSATPacific_fnc_createJinaahMedicalModule", 
                "a3\air_f_orange\uav_06\data\ui\map_uav_06_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificDronesTree, 
                "K40 Ababil-3", 
                "K40 Ababil-3", 
                "MAZ_EZM_CSATPacific_fnc_createK40Module", 
                "a3\drones_f\air_f_gamma\uav_02\data\ui\map_uav_02_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificDronesTree, 
                "KH-3A Fenghuang", 
                "KH-3A Fenghuang", 
                "MAZ_EZM_CSATPacific_fnc_createKH3AModule", 
                "a3\air_f_exp\uav_04\data\ui\map_uav_04_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificDronesTree, 
                "Tayran AR-2", 
                "Tayran AR-2", 
                "MAZ_EZM_CSATPacific_fnc_createTayranModule", 
                "a3\drones_f\air_f_gamma\uav_01\data\ui\map_uav_01_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificDronesTree, 
                "UGV Saif", 
                "UGV Saif", 
                "MAZ_EZM_CSATPacific_fnc_createSaifModule", 
                "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificDronesTree, 
                "UGV Saif RCWS", 
                "UGV Saif RCWS", 
                "MAZ_EZM_CSATPacific_fnc_createSaifRCWSModule", 
                "a3\drones_f\soft_f_gamma\ugv_01\data\ui\map_ugv_01_rcws_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
        comment "Groups"; 
        
            MAZ_CSATPacificSubCatTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Groups", 
                "\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Anti-Air Team", 
                "Anti-Air Team", 
                "MAZ_EZM_CSATPacific_fnc_createAntiAirTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Anti-Tank Team", 
                "Anti-Tank Team", 
                "MAZ_EZM_CSATPacific_fnc_createAntiTankTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [  
                MAZ_UnitsTree_OPFOR,  
                MAZ_CSATPacificTree,  
                MAZ_CSATPacificSubCatTree,  
                "Marksman Team",  
                "Marksman Team",  
                "MAZ_EZM_CSATPacific_fnc_createMarksmanTeamModule",  
                ""  
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;  

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Patrol", 
                "Patrol", 
                "MAZ_EZM_CSATPacific_fnc_createPatrolModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [
                MAZ_UnitsTree_OPFOR,
                MAZ_CSATPacificTree,
                MAZ_CSATPacificSubCatTree,
                "Recon Squad",
                "Recon BIN_fnc_setAISquadID",
                "MAZ_EZM_CSATPacific_fnc_createReconSquadModule",
                ""
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Squad", 
                "Squad", 
                "MAZ_EZM_CSATPacific_fnc_createSquadModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Sentry", 
                "Sentry", 
                "MAZ_EZM_CSATPacific_fnc_createSentryModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Sniper Team", 
                "Sniper Team", 
                "MAZ_EZM_CSATPacific_fnc_createSniperTeamModule", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Helicopters";
        
            MAZ_CSATPacificSubCatTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Helicopters", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-48 Kajman", 
                "Mi-48 Kajman", 
                "MAZ_EZM_CSATPacific_fnc_createTaruKajmanModule", 
                "a3\air_f_beta\heli_attack_02\data\ui\map_heli_attack_02_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-290 Taru", 
                "Mi-290 Taru", 
                "MAZ_EZM_CSATPacific_fnc_createTaruModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-290 Taru (Ammo)", 
                "Mi-290 Taru (Ammo)", 
                "MAZ_EZM_CSATPacific_fnc_createTaruAmmoModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_ammo_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-290 Taru (Bench)", 
                "Mi-290 Taru (Bench)", 
                "MAZ_EZM_CSATPacific_fnc_createTaruBenchModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_bench_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-290 Taru (Cargo)", 
                "Mi-290 Taru (Cargo)", 
                "MAZ_EZM_CSATPacific_fnc_createTaruCargoModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_box_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-290 Taru (Fuel)", 
                "Mi-290 Taru (Fuel)", 
                "MAZ_EZM_CSATPacific_fnc_createTaruFuelModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_fuel_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-290 Taru (Medical)", 
                "Mi-290 Taru (Medical)", 
                "MAZ_EZM_CSATPacific_fnc_createTaruMedicalModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_medevac_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-290 Taru (Repair)", 
                "Mi-290 Taru (Repair)", 
                "MAZ_EZM_CSATPacific_fnc_createTaruRepairModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_repair_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "Mi-290 Taru (Transport)", 
                "Mi-290 Taru (Transport)", 
                "MAZ_EZM_CSATPacific_fnc_createTaruTransportModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_covered_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "PO-30 Orca", 
                "PO-30 Orca", 
                "MAZ_EZM_CSATPacific_fnc_createOrcaModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_rockets_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSubCatTree, 
                "PO-30 Orca (Unarmed)", 
                "PO-30 Orca (Unarmed)", 
                "MAZ_EZM_CSATPacific_fnc_createOrcaUnarmedModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

        comment "Men"; 
            
            MAZ_CSATPacificMenTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Men", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Ammo Bearer", 
                "Ammo Bearer", 
                "MAZ_EZM_CSATPacific_fnc_createAmmoBearerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Autorifleman", 
                "Autorifleman", 
                "MAZ_EZM_CSATPacific_fnc_createAutoriflemanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Combat Lifesaver", 
                "Combat Lifesaver", 
                "MAZ_EZM_CSATPacific_fnc_createCombatMedicModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Crewman", 
                "Crewman", 
                "MAZ_EZM_CSATPacific_fnc_createCrewmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Engineer", 
                "Engineer", 
                "MAZ_EZM_CSATPacific_fnc_createEngineerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Grenadier", 
                "Grenadier", 
                "MAZ_EZM_CSATPacific_fnc_createGrenadierModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Heavy Gunner", 
                "Heavy Gunner", 
                "MAZ_EZM_CSATPacific_fnc_createHeavyGunnerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Helicopter Crew", 
                "Helicopter Crew", 
                "MAZ_EZM_CSATPacific_fnc_createHelicopterCrewModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Helicopter Pilot", 
                "Helicopter Pilot", 
                "MAZ_EZM_CSATPacific_fnc_createHelicopterPilotModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Pilot", 
                "Pilot", 
                "MAZ_EZM_CSATPacific_fnc_createPilotModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
        
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Marksman", 
                "Marksman", 
                "MAZ_EZM_CSATPacific_fnc_createMarksmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Missile Specialist (AA)", 
                "Anti-Air Missile Specialist", 
                "MAZ_EZM_CSATPacific_fnc_createMissileSpecAAModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Missile Specialist (AT)", 
                "Anti-Tank Missile Specialist", 
                "MAZ_EZM_CSATPacific_fnc_createMissileSpecATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Officer", 
                "Officer", 
                "MAZ_EZM_CSATPacific_fnc_createOfficerModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManOfficer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Rifleman", 
                "Rifleman", 
                "MAZ_EZM_CSATPacific_fnc_createRiflemanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Rifleman (LAT)", 
                "Light Anti-Tank Rifleman", 
                "MAZ_EZM_CSATPacific_fnc_createRiflemanLATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Rifleman (HAT)", 
                "Heavy Anti-Tank Rifleman", 
                "MAZ_EZM_CSATPacific_fnc_createRiflemanHATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Sharpshooter", 
                "Sharpshooter", 
                "MAZ_EZM_CSATPacific_fnc_createSharpshooterModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Squad Leader", 
                "Squad Leader", 
                "MAZ_EZM_CSATPacific_fnc_createSquadLeadModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Radio Operator", 
                "Radio Operator", 
                "MAZ_EZM_CSATPacific_fnc_createRadiomanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificMenTree, 
                "Survivor", 
                "Survivor", 
                "MAZ_EZM_CSATPacific_fnc_createSurvivorModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "Men (Special Forces)";

            MAZ_CSATPacificSpecialMenTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Men (Special Forces)", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Diver", 
                "Diver", 
                "MAZ_EZM_CSATPacific_fnc_createDiverModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Recon Demo Specialist", 
                "Recon Demo Specialist", 
                "MAZ_EZM_CSATPacific_fnc_createReconDemoModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Recon JTAC", 
                "Recon JTAC", 
                "MAZ_EZM_CSATPacific_fnc_createReconJTACModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Recon Marksman", 
                "Recon Marksman", 
                "MAZ_EZM_CSATPacific_fnc_createReconMarksmanModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Recon Paramedic", 
                "Recon Paramedic", 
                "MAZ_EZM_CSATPacific_fnc_createReconParamedicModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Recon Scout", 
                "Recon Scout", 
                "MAZ_EZM_CSATPacific_fnc_createReconScoutModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Recon Scout (AT)", 
                "Recon Scout (AT)", 
                "MAZ_EZM_CSATPacific_fnc_createReconScoutATModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Recon Team Leader", 
                "Recon Team Leader", 
                "MAZ_EZM_CSATPacific_fnc_createReconTeamLeaderModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Sniper", 
                "Sniper", 
                "MAZ_EZM_CSATPacific_fnc_createReconSniperModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificSpecialMenTree, 
                "Spotter", 
                "Spotter", 
                "MAZ_EZM_CSATPacific_fnc_createReconSpotterModule", 
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Reinforcement"; 
        
            MAZ_CSATPacificReinforcementTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Reinforcement", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificReinforcementTree, 
                "Orca (Unarmed)", 
                "Orca (Unarmed)", 
                "MAZ_EZM_CSATPacific_fnc_createReinforcementOrcaModule", 
                "a3\air_f\heli_light_02\data\ui\map_heli_light_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificReinforcementTree, 
                "Qilin (Unarmed)", 
                "Qilin (Unarmed)", 
                "MAZ_EZM_CSATPacific_fnc_createReinforcementQilinUnarmedModule", 
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificReinforcementTree, 
                "RHIB", 
                "RHIB", 
                "MAZ_EZM_CSATPacific_fnc_createReinforcementRhibModule", 
                "a3\boat_f_exp\boat_transport_02\data\ui\map_boat_transport_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificReinforcementTree, 
                "Taru Transport", 
                "Taru Transport", 
                "MAZ_EZM_CSATPacific_fnc_createReinforcementTaruTransportModule", 
                "a3\air_f_heli\heli_transport_04\data\ui\map_heli_transport_04_covered_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificReinforcementTree, 
                "Tempest Transport", 
                "Tempest Transport", 
                "MAZ_EZM_CSATPacific_fnc_createReinforcementTempestTransportModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_transport_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificReinforcementTree, 
                "Zamak Tansport", 
                "Zamak Transport", 
                "MAZ_EZM_CSATPacific_fnc_createReinforcementZamakCoveredTransportModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_dump_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Planes";
        
            MAZ_CSATPacificPlanesTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Planes", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificPlanesTree, 
                "Y-32 Xi'an (Infantry Transport)", 
                "Y-32 Xi'an (Infantry Transport)", 
                "MAZ_EZM_CSATPacific_fnc_createVTOLInfantryModule", 
                "a3\air_f_exp\vtol_02\data\ui\map_vtol_02_vehicle_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificPlanesTree, 
                "Y-32 Xi'an (Vehicle Transport)", 
                "Y-32 Xi'an (Vehicle Transport)", 
                "MAZ_EZM_CSATPacific_fnc_createVTOLVehicleModule", 
                "a3\air_f_exp\vtol_02\data\ui\map_vtol_02_vehicle_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
                
        comment "Tanks"; 
            
            MAZ_CSATPacificTankTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Tanks", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTankTree, 
                "T-100 Varsuk", 
                "T-100 Varsuk", 
                "MAZ_EZM_CSATPacific_fnc_createVarsukModule", 
                "a3\armor_f_gamma\mbt_02\data\ui\map_mbt_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTankTree, 
                "T-140 Angara", 
                "T-140 Angara", 
                "MAZ_EZM_CSATPacific_fnc_createAngaraModule", 
                "a3\armor_f_tank\mbt_04\data\ui\map_mbt_04_cannon_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTankTree, 
                "T-140K Angara", 
                "T-140K Angara", 
                "MAZ_EZM_CSATPacific_fnc_createAngaraKModule", 
                "a3\armor_f_tank\mbt_04\data\ui\map_mbt_04_command_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
        comment "Trucks"; 
        
            MAZ_CSATPacificTrucksTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Trucks", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Tempest (Device)", 
                "Tempest Device", 
                "MAZ_EZM_CSATPacific_fnc_createTempestDeviceModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_device_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Tempest Ammo", 
                "Tempest Ammo", 
                "MAZ_EZM_CSATPacific_fnc_createTempestAmmoModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_ammo_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Tempest Fuel", 
                "Tempest Fuel", 
                "MAZ_EZM_CSATPacific_fnc_createTempestFuelModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_fuel_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Tempest Medical", 
                "Tempest Medical", 
                "MAZ_EZM_CSATPacific_fnc_createTempestMedicalModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_medevac_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Tempest Repair", 
                "Tempest Repair", 
                "MAZ_EZM_CSATPacific_fnc_createTempestRepairModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_ammo_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Tempest Transport", 
                "Tempest Transport", 
                "MAZ_EZM_CSATPacific_fnc_createTempestTransportModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_transport_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Tempest Transport (Covered)", 
                "Tempest Transport", 
                "MAZ_EZM_CSATPacific_fnc_createTempestTransportCoveredModule", 
                "a3\soft_f_epc\truck_03\data\ui\map_truck_03_covered_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Zamak Ammo", 
                "Zamak Ammo", 
                "MAZ_EZM_CSATPacific_fnc_createZamakAmmoModule", 
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_box_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Zamak Fuel", 
                "Zamak Fuel", 
                "MAZ_EZM_CSATPacific_fnc_createZamakFuelModule", 
                "a3\soft_f_gamma\truck_02\data\ui\map_truck_02_fuel_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Zamak Medical", 
                "Medical Zamak", 
                "MAZ_EZM_CSATPacific_fnc_createZamakMedicalModule", 
                "a3\soft_f_gamma\truck_02\data\ui\map_truck_02_medevac_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Zamak Repair", 
                "Zamak Repair", 
                "MAZ_EZM_CSATPacific_fnc_createZamakRepairModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_repair_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Zamak Transport", 
                "Zamak", 
                "MAZ_EZM_CSATPacific_fnc_createZamakTransportModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_dump_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTrucksTree, 
                "Zamak Transport (Covered)", 
                "Zamak (Covered)", 
                "MAZ_EZM_CSATPacific_fnc_createZamakCoveredTransportModule", 
                "a3\soft_f_beta\truck_02\data\ui\map_truck_02_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
        
        comment "Turrets"; 
        
            MAZ_CSATPacificTurretTree = [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                "Turrets", 
                "" 
            ] call MAZ_EZM_fnc_zeusAddSubCategory; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTurretTree, 
                "M2 HMG", 
                "M2 HMG", 
                "MAZ_EZM_CSATPacific_fnc_createM2HMGModule", 
                "\a3\static_f\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTurretTree, 
                "M2 HMG (Raised)", 
                "M2 HMG (Raised)", 
                "MAZ_EZM_CSATPacific_fnc_createM2HMGRaisedModule", 
                "a3\static_f_oldman\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTurretTree, 
                "Mk32 GMG", 
                "Mk32 GMG", 
                "MAZ_EZM_CSATPacific_fnc_createMk32GMGModule", 
                "\a3\static_f\hmg_02\data\ui\icon_hmg_02_ca.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;  
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTurretTree, 
                "Mk6 Mortar", 
                "Mk6 Mortar", 
                "MAZ_EZM_CSATPacific_fnc_createMk6MortarModule", 
                "\A3\Static_f\Mortar_01\data\UI\map_Mortar_01_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTurretTree, 
                "Static AT Launcher", 
                "Static AT Launcher", 
                "MAZ_EZM_CSATPacific_fnc_createATLauncherModule", 
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AT_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 
            
            [ 
                MAZ_UnitsTree_OPFOR, 
                MAZ_CSATPacificTree, 
                MAZ_CSATPacificTurretTree, 
                "Static AA Launcher", 
                "Static AA Launcher", 
                "MAZ_EZM_CSATPacific_fnc_createAALauncherModule", 
                "\A3\Static_F_Gamma\data\UI\map_StaticTurret_AA_CA.paa" 
            ] call MAZ_EZM_fnc_zeusAddModule_OPFOR; 

        comment "CSAT (Africa) Modules";

            MAZ_AFRTree = [
                MAZ_UnitsTree_OPFOR,
                "CSAT (Africa)",
                "\a3\ui_f_orange\data\displays\rscdisplayorangechoice\faction_csat_ca.paa",
                [1,1,1,1],
                format ["A new CSAT sub-faction, North African troops primarily found and garrisoned on Malden.\nLow funding from CSAT renders them to be relatively unequipped and inferior to CSAT at large,\nNATO, and the MDF.\n\nAn Official EZM Faction.\nVersion: %1",missionNamespace getVariable "MAZ_EZM_CSATP_Ver"]
            ] call MAZ_EZM_fnc_zeusAddCategory;	
        
            comment "Anti-Air";
            comment "APCs";
            comment "Artillery";

                MAZ_AFRArtilleryTree = [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    "Artillery",
                    ""
                ] call MAZ_EZM_fnc_zeusAddSubCategory;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRArtilleryTree,
                    "Zamak MRL",
                    "Creates a African CSAT MRL Zamak.",
                    "MAZ_EZM_AFR_fnc_createZamakMRLModule",
                    "\A3\Soft_F_Gamma\Truck_02\Data\UI\Map_Truck_02_MRL_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
            comment "Boats";
                MAZ_AFRBoatsTree = [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    "Boat",
                    ""
                ] call MAZ_EZM_fnc_zeusAddSubCategory;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRBoatsTree,
                    "Assault Boat",
                    "Creates a African CSAT Assault Boat.",
                    "MAZ_EZM_AFR_fnc_createDinghyModule",
                    "\A3\boat_F\Boat_Transport_01\data\UI\map_Boat_Transport_01_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            comment "Cars";

                MAZ_AFRCarsTree = [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    "Cars",
                    ""
                ] call MAZ_EZM_fnc_zeusAddSubCategory;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Ifrit",
                    "Creates a African CSAT Ifrit.",
                    "MAZ_EZM_AFR_fnc_createIfritModule",
                    "\A3\soft_f\MRAP_02\Data\UI\map_MRAP_02_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Ifrit HMG",
                    "Creates a African CSAT Ifrit HMG.",
                    "MAZ_EZM_AFR_fnc_createIfritHMGModule",
                    "\A3\soft_f\MRAP_02\Data\UI\map_MRAP_02_HMG_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Qilin (AT)",
                    "Creates a African CSAT AT Qilin.",
                    "MAZ_EZM_AFR_fnc_createQilinATModule",
                    "\A3\Soft_F_Exp\LSV_02\Data\UI\map_LSV_02_base_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Qilin (Minigun)",
                    "Creates a African CSAT Minigun Qilin.",
                    "MAZ_EZM_AFR_fnc_createQilinMinigunModule",
                    "\A3\Soft_F_Exp\LSV_02\Data\UI\map_LSV_02_base_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Qilin",
                    "Creates a African CSAT Qilin.",
                    "MAZ_EZM_AFR_fnc_createQilinModule",
                    "\A3\Soft_F_Exp\LSV_02\Data\UI\map_LSV_02_base_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Quad Bike",
                    "Creates a African CSAT quad bike.",
                    "MAZ_EZM_AFR_fnc_createQuadModule",
                    "\A3\Soft_F\Quadbike_01\Data\UI\map_Quad_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Zamak (Ammo)",
                    "Creates a African CSAT ammo Zamak.",
                    "MAZ_EZM_AFR_fnc_createZamakAmmoModule",
                    "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_box_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Zamak (Fuel)",
                    "Creates a African CSAT fuel Zamak.",
                    "MAZ_EZM_AFR_fnc_createZamakFuelModule",
                    "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_fuel_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Zamak (Medical)",
                    "Creates a African CSAT medical Zamak.",
                    "MAZ_EZM_AFR_fnc_createZamakMedicalModule",
                    "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_medevac_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Zamak (Repair)",
                    "Creates a African CSAT repair Zamak.",
                    "MAZ_EZM_AFR_fnc_createZamakRepairModule",
                    "\A3\Soft_F_Beta\Truck_02\Data\UI\Map_Truck_02_repair_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Zamak Transport",
                    "Creates a African CSAT transport Zamak.",
                    "MAZ_EZM_AFR_fnc_createZamakTransportModule",
                    "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;					

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRCarsTree,
                    "Zamak Transport (Covered)",
                    "Creates a African CSAT covered transport Zamak.",
                    "MAZ_EZM_AFR_fnc_createZamakTransportCoveredModule",
                    "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            comment "Helicopters";

                MAZ_AFRHelicoptersTree = [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    "Helicopters",
                    ""
                ] call MAZ_EZM_fnc_zeusAddSubCategory;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Mi-290 Taru",
                    "Creates a African CSAT Taru.",
                    "MAZ_EZM_AFR_fnc_createTaruModule",
                    "\A3\Air_F_Heli\Heli_Transport_04\Data\UI\Map_Heli_Transport_04_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Mi-290 Taru (Ammo)",
                    "Creates a African CSAT ammo Taru.",
                    "MAZ_EZM_AFR_fnc_createTaruAmmoModule",
                    "\A3\Air_F_Heli\Heli_Transport_04\Data\UI\Map_Heli_Transport_04_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Mi-290 Taru (Bench)",
                    "Creates a African CSAT bench Taru.",
                    "MAZ_EZM_AFR_fnc_createTaruBenchModule",
                    "\A3\Air_F_Heli\Heli_Transport_04\Data\UI\Map_Heli_Transport_04_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Mi-290 Taru (Cargo)",
                    "Creates a African CSAT cargo Taru.",
                    "MAZ_EZM_AFR_fnc_createTaruCargoModule",
                    "\A3\Air_F_Heli\Heli_Transport_04\Data\UI\Map_Heli_Transport_04_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Mi-290 Taru (Fuel)",
                    "Creates a African CSAT fuel Taru.",
                    "MAZ_EZM_AFR_fnc_createTaruFuelModule",
                    "\A3\Air_F_Heli\Heli_Transport_04\Data\UI\Map_Heli_Transport_04_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Mi-290 Taru (Medical)",
                    "Creates a African CSAT medical Taru.",
                    "MAZ_EZM_AFR_fnc_createTaruMedicalModule",
                    "\A3\Air_F_Heli\Heli_Transport_04\Data\UI\Map_Heli_Transport_04_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Mi-290 Taru (Repair)",
                    "Creates a African CSAT repair Taru.",
                    "MAZ_EZM_AFR_fnc_createTaruRepairModule",
                    "\A3\Air_F_Heli\Heli_Transport_04\Data\UI\Map_Heli_Transport_04_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Mi-290 Taru (Transport)",
                    "Creates a African CSAT transport Taru.",
                    "MAZ_EZM_AFR_fnc_createTaruTransportModule",
                    "\A3\Air_F_Heli\Heli_Transport_04\Data\UI\Map_Heli_Transport_04_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Po-30 Orca",
                    "Creates a African CSAT Orca.",
                    "MAZ_EZM_AFR_fnc_createOrcaModule",
                    "\A3\Air_F\Heli_Light_02\Data\UI\Map_Heli_Light_02_rockets_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRHelicoptersTree,
                    "Po-30 Orca (Unarmed)",
                    "Creates a African CSAT unarmed Orca.",
                    "MAZ_EZM_AFR_fnc_createOrcaUnarmedModule",
                    "\A3\Air_F\Heli_Light_02\Data\UI\Map_Heli_Light_02_CA.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	

            comment "Men";

                MAZ_AFRMenTree = [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    "Men",
                    ""
                ] call MAZ_EZM_fnc_zeusAddSubCategory;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Ammo Bearer",
                    "Creates a African CSAT Ammo Bearer.",
                    "MAZ_EZM_AFR_fnc_createAmmoBearerModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Autorifleman",
                    "Creates a African CSAT Autorifleman.",
                    "MAZ_EZM_AFR_fnc_createAutoriflemanModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Crewman",
                    "Creates a African CSAT Crewman.",
                    "MAZ_EZM_AFR_fnc_createCrewmanModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;
                
                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Grenadier",
                    "Creates a African CSAT Grenadier.",
                    "MAZ_EZM_AFR_fnc_createGrenadierModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Helicopter Crew",
                    "Creates a African CSAT Helicopter Crew.",
                    "MAZ_EZM_AFR_fnc_createHeliCrewModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Helicopter Pilot",
                    "Creates a African CSAT Helicopter Pilot.",
                    "MAZ_EZM_AFR_fnc_createHeliPilotModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Marksman",
                    "Creates a African CSAT Marksman.",
                    "MAZ_EZM_AFR_fnc_createMarksmanModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Medic",
                    "Creates a African CSAT Medic.",
                    "MAZ_EZM_AFR_fnc_createMedicModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Officer",
                    "Creates a African CSAT Officer.",
                    "MAZ_EZM_AFR_fnc_createOfficerModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconManOfficer_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Rifleman",
                    "Creates a African CSAT rifleman.",
                    "MAZ_EZM_AFR_fnc_createRiflemanModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Rifleman (AA)",
                    "Creates a African CSAT AA Rifleman.",
                    "MAZ_EZM_AFR_fnc_createMissleAAModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Rifleman (AT)",
                    "Creates a African CSAT AT rifleman.",
                    "MAZ_EZM_AFR_fnc_createATRiflemanModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "Rifleman (Light AT)",
                    "Creates a African CSAT LAT rifleman.",
                    "MAZ_EZM_AFR_fnc_createLATRiflemanModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRMenTree,
                    "SquadLeader",
                    "Creates a African CSAT SquadLeader.",
                    "MAZ_EZM_AFR_fnc_createSquadLeaderModule",
                    "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;

            comment "Tank";

                MAZ_AFRTanksTree = [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    "Tanks",
                    ""
                ] call MAZ_EZM_fnc_zeusAddSubCategory;		
                
                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRTanksTree,
                    "T-100 Varsuk",
                    "Creates a African CSAT T-100 Varsuk.",
                    "MAZ_EZM_AFR_fnc_createT100Module",
                    "\A3\armor_f_gamma\MBT_02\Data\UI\map_MBT_02_ca.paa"
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;					

            comment "Groups";

                MAZ_AFRGroupsTree = [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    "Groups",
                    ""
                ] call MAZ_EZM_fnc_zeusAddSubCategory;
                
                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRGroupsTree,
                    "Fire Team",
                    "Creates a African CSAT fire team",
                    "MAZ_EZM_AFR_fnc_createFireTeamModule",
                    ""
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;		

                [
                    MAZ_UnitsTree_OPFOR,
                    MAZ_AFRTree,
                    MAZ_AFRGroupsTree,
                    "Rifle Squad",
                    "Creates a African CSAT rifle squad",
                    "MAZ_EZM_AFR_fnc_createRifleSquadModule",
                    ""
                ] call MAZ_EZM_fnc_zeusAddModule_OPFOR;	
    };
};

["MAZ_EZM_CSATP_fnc_modules"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;