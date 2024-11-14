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

if(!isNil "MAZ_EZM_MDF") exitWith {
    ["MDF is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_MDF_Ver = "1.0";
MAZ_EZM_MDF = true;

comment "Anti-Air";

    MAZ_EZM_MDF_fnc_createCheetahModule = {
        private _vehicle = ["B_APC_Tracked_01_AA_F"] call MAZ_EZM_fnc_createVehicle;
        [
            _vehicle,
            ["Sand",1], 
            ["showCamonetTurret",1,"showCamonetHull",1,"showBags",0]
        ] call BIS_fnc_initVehicle;

        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _driver moveInDriver _vehicle;

            private _gunner = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _gunner moveInGunner _vehicle;

            private _commander = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _commander moveInCommander _vehicle;

            private _grp = createGroup [independent,true];
            [_driver,_gunner,_commander] joinSilent _grp;
            _grp selectLeader _commander;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createNyxAAModule = {
        private _vehicle = ["I_LT_01_AA_F",["a3\armor_f_tank\lt_01\data\lt_01_main_olive_co.paa","a3\armor_f_tank\lt_01\data\lt_01_at_olive_co.paa","a3\armor_f\data\camonet_aaf_digi_desert_co.paa","a3\armor_f\data\cage_olive_co.paa"]] call MAZ_EZM_fnc_createVehicle;

        _vehicle animateSource ["showCamonetHull",1];
        _vehicle animateSource ["showSLATHull",1];
        _vehicle animateSource ["showCamonetPlates1",1];
        _vehicle animateSource ["showCamonetPlates2",1];

        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _driver moveInDriver _vehicle;

            private _gunner = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _gunner moveInGunner _vehicle;

            private _grp = createGroup [independent,true];
            [_driver,_gunner] joinSilent _grp;
            _grp selectLeader _gunner;
        };

        _vehicle
    };

comment "APCs";

    MAZ_EZM_MDF_fnc_createGorgonModule = {
        private _vehicle = ["I_APC_Wheeled_03_cannon_F",["a3\data_f_tacops\data\apc_wheeled_03_ext_ig_02_co.paa","a3\data_f_tacops\data\apc_wheeled_03_ext2_ig_02_co.paa","a3\data_f_tacops\data\rcws30_ig_02_co.paa","a3\data_f_tacops\data\apc_wheeled_03_ext_alpha_ig_02_co.paa","a3\armor_f\data\camonet_aaf_fia_desert_co.paa","a3\armor_f\data\cage_sand_co.paa"]] call MAZ_EZM_fnc_createVehicle;

        _vehicle animateSource ["showCamonetHull",round (random 1)];
        _vehicle animateSource ["showBags",round (random 1)];
        _vehicle animateSource ["showBags2",round (random 1)];
        _vehicle animateSource ["showTools",round (random 1)];
        _vehicle animateSource ["showSLATHull",1];

        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _driver moveInDriver _vehicle;

            private _gunner = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _gunner moveInGunner _vehicle;

            private _commander = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _commander moveInCommander _vehicle;

            private _grp = createGroup [independent,true];
            [_driver,_gunner,_commander] joinSilent _grp;
            _grp selectLeader _commander;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createRhinoModule = {
        private _vehicle = ["B_AFV_Wheeled_01_cannon_F",["a3\armor_f_tank\afv_wheeled_01\data\afv_wheeled_01_ext1_co.paa","a3\armor_f_tank\afv_wheeled_01\data\afv_wheeled_01_ext2_co.paa","a3\armor_f_tank\afv_wheeled_01\data\afv_wheeled_01_wheel_co.paa","a3\armor_f\data\camonet_nato_desert_co.paa","a3\armor_f_tank\afv_wheeled_01\data\afv_wheeled_01_ext3_sand_co.paa"]] call MAZ_EZM_fnc_createVehicle;

        if(round (random 1) == 1) then {
            _vehicle animateSource ["showCamonetHull",1];
            _vehicle animateSource ["showCamonetTurret",round (random 1)];
        };
        _vehicle animateSource ["showSLATHull",1];

        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _driver moveInDriver _vehicle;

            private _gunner = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _gunner moveInGunner _vehicle;

            private _commander = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
            _commander moveInCommander _vehicle;

            private _grp = createGroup [independent,true];
            [_driver,_gunner,_commander] joinSilent _grp;
            _grp selectLeader _commander;
        };

        _vehicle
    };

comment "Cars";

    MAZ_EZM_MDF_fnc_createOffroadModule = {
        private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle;
        
        [
            _vehicle,
            ["Guerilla_03",1], 
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",1,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]
        ] call BIS_fnc_initVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createOffroadHMGModule = {
        private _vehicle = ["I_G_Offroad_01_armed_F"] call MAZ_EZM_fnc_createVehicle;
        
        [
            _vehicle,
            ["Guerilla_03",1], 
            ["Hide_Shield",0,"Hide_Rail",1,"HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0]
        ] call BIS_fnc_initVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;

            private _gunner = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _gunner moveInGunner _vehicle;

            private _grp = createGroup [independent,true];
            [_driver,_gunner] joinSilent _grp;
            _grp selectLeader _driver;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createOffroadATModule = {
        private _vehicle = ["I_G_Offroad_01_AT_F"] call MAZ_EZM_fnc_createVehicle;
        
        [
            _vehicle,
            ["Guerilla_03",1], 
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",1,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0]
        ] call BIS_fnc_initVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;

            private _gunner = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _gunner moveInGunner _vehicle;

            private _grp = createGroup [independent,true];
            [_driver,_gunner] joinSilent _grp;
            _grp selectLeader _driver;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createZamakAmmoModule = {
        private _vehicle = ["I_Truck_02_ammo_F",["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_repair_green_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createZamakFuelModule = {
        private _vehicle = ["I_Truck_02_fuel_F",["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_fuel_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createZamakMedicalModule = {
        private _vehicle = ["I_Truck_02_medical_F",["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]] call MAZ_EZM_fnc_createVehicle;	
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createZamakRepairModule = {
        private _vehicle = ["I_Truck_02_box_F",["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_repair_green_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]] call MAZ_EZM_fnc_createVehicle;	

        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createZamakTransportModule = {
        private _vehicle = ["I_Truck_02_transport_F",["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]] call MAZ_EZM_fnc_createVehicle;	
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createZamakTransportCoveredModule = {
        private _vehicle = ["I_Truck_02_covered_F",["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]] call MAZ_EZM_fnc_createVehicle;			
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createQuadbikeModule = {
        private _vehicle = ["I_G_Quadbike_01_F"] call MAZ_EZM_fnc_createVehicle;

        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _driver moveInDriver _vehicle;
            private _passenger = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
            _passenger moveInCargo _vehicle;
        };

        _vehicle;
    };

comment "Drones";

    MAZ_EZM_MDF_fnc_createGreyhawkModule = {
        private _vehicle = ["B_UAV_02_dynamicLoadout_F",["a3\drones_f\air_f_gamma\uav_02\data\uav_02_indp_co.paa"]] call MAZ_EZM_fnc_createVehicle;							
        private _aiGroup = createGroup [independent,true];
        private _oldGroup = createVehicleCrew _vehicle;
        private _leader = leader _oldGroup;
        {
            [_x] joinSilent _aiGroup;
        }forEach units _oldGroup;
        _aiGroup selectLeader _leader;

        _vehicle
    };

comment "Groups";

    MAZ_EZM_MDF_fnc_createRifleSquadModule = {
        private _squadLead = call MAZ_EZM_MDF_fnc_createSquadLeadModule;
        private _grp = group _squadLead;
        {
            private _unit = call (missionNamespace getVariable _x);
            [_unit] joinSilent _grp;
        }forEach [
            'MAZ_EZM_MDF_fnc_createRiflemanModule',
            'MAZ_EZM_MDF_fnc_createRiflemanATModule',
            'MAZ_EZM_MDF_fnc_createMarksmanModule',
            'MAZ_EZM_MDF_fnc_createGrenadierModule',
            'MAZ_EZM_MDF_fnc_createAutoriflemanModule',
            'MAZ_EZM_MDF_fnc_createAmmoBearerModule',
            'MAZ_EZM_MDF_fnc_createMedicModule'
        ];
        _grp setBehaviour "AWARE";
        _grp;
    };

    MAZ_EZM_MDF_fnc_createATSquadModule = {
        private _squadLead = call MAZ_EZM_MDF_fnc_createSquadLeadModule;
        private _grp = group _squadLead;
        {
            private _unit = call (missionNamespace getVariable _x);
            [_unit] joinSilent _grp;
        }forEach [
            'MAZ_EZM_MDF_fnc_createRiflemanATModule',
            'MAZ_EZM_MDF_fnc_createRiflemanATModule',
            'MAZ_EZM_MDF_fnc_createRiflemanModule'
        ];
        _grp setBehaviour "AWARE";
        _grp;
    };

    MAZ_EZM_MDF_fnc_createAASquadModule = {
        private _squadLead = call MAZ_EZM_MDF_fnc_createSquadLeadModule;
        private _grp = group _squadLead;
        {
            private _unit = call (missionNamespace getVariable _x);
            [_unit] joinSilent _grp;
        }forEach [
            'MAZ_EZM_MDF_fnc_createMissileSpecAAModule',
            'MAZ_EZM_MDF_fnc_createMissileSpecAAModule',
            'MAZ_EZM_MDF_fnc_createRiflemanModule'
        ];
        _grp setBehaviour "AWARE";
        _grp;
    };

    MAZ_EZM_MDF_fnc_createSentrySquadModule = {
        private _squadLead = call MAZ_EZM_MDF_fnc_createGrenadierModule;
        private _grp = group _squadLead;
        {
            private _unit = call (missionNamespace getVariable _x);
            [_unit] joinSilent _grp;
        }forEach [
            'MAZ_EZM_MDF_fnc_createRiflemanModule'
        ];
        _grp setBehaviour "AWARE";
        _grp;
    };

    MAZ_EZM_MDF_fnc_createPatrolSquadModule = {
        private _squadLead = call MAZ_EZM_MDF_fnc_createSquadLeadModule;
        private _grp = group _squadLead;
        {
            private _unit = call (missionNamespace getVariable _x);
            [_unit] joinSilent _grp;
        }forEach [
            'MAZ_EZM_MDF_fnc_createAutoriflemanModule',
            'MAZ_EZM_MDF_fnc_createRiflemanModule',
            'MAZ_EZM_MDF_fnc_createRiflemanLATModule'
        ];
        _grp setBehaviour "AWARE";
        _grp;
    };

comment "Helicopters";

    MAZ_EZM_MDF_fnc_createHummingbirdModule = {
        private _vehicle = ["B_Heli_Light_01_F",["A3\air_f\heli_light_01\data\skins\Heli_light_01_ext_digital_co.paa"]] call MAZ_EZM_fnc_createVehicle;					

        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createHeliPilotModule;
            _driver moveInDriver _vehicle;

            private _coPilot = [] call MAZ_EZM_MDF_fnc_createHeliPilotModule;
            _coPilot moveinturret [_vehicle, [0]];

            private _grp = createGroup [independent,true];
            [_driver,_coPilot] joinSilent _grp;
            _grp selectLeader _driver;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createPawneeModule = {
        private _vehicle = ["B_Heli_Light_01_dynamicLoadout_F",["A3\air_f\heli_light_01\data\skins\Heli_light_01_ext_digital_co.paa"]] call MAZ_EZM_fnc_createVehicle;		
                            
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createHeliPilotModule;
            _driver moveInDriver _vehicle;

            private _coPilot = [] call MAZ_EZM_MDF_fnc_createHeliPilotModule;
            _coPilot moveinturret [_vehicle, [0]];

            private _grp = createGroup [independent,true];
            [_driver,_coPilot] joinSilent _grp;
            _grp selectLeader _driver;
        };

        _vehicle
    };

comment "Men";

    MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit = {
        params ["_unit"];
        sleep 0.2;
        private _frenchVoice = [
            "Male01FRE",
            "Male02FRE",
            "Male03FRE",
            "Male01ENGFRE",
            "Male02ENGFRE"
        ];
        private _blackHeads = [
            "Barklem",
            "AfricanHead_01",
            "AfricanHead_02",
            "AfricanHead_03",
            "TanoanHead_A3_01",
            "TanoanHead_A3_02",
            "TanoanHead_A3_03",
            "TanoanHead_A3_04",
            "TanoanHead_A3_05",
            "TanoanHead_A3_06",
            "TanoanHead_A3_07",
            "TanoanHead_A3_08"
        ];
        private _whiteHeads = [
            "WhiteHead_01",
            "WhiteHead_02",
            "WhiteHead_03",
            "WhiteHead_04",
            "WhiteHead_05",
            "WhiteHead_06",
            "WhiteHead_07",
            "WhiteHead_08",
            "WhiteHead_09",
            "WhiteHead_10",
            "WhiteHead_11",
            "WhiteHead_12",
            "WhiteHead_13",
            "WhiteHead_14",
            "WhiteHead_15",
            "WhiteHead_16",
            "WhiteHead_17",
            "WhiteHead_18",
            "WhiteHead_19",
            "WhiteHead_20",
            "WhiteHead_21",
            "WhiteHead_23",
            "WhiteHead_24",
            "WhiteHead_25",
            "WhiteHead_26",
            "WhiteHead_27",
            "WhiteHead_28",
            "WhiteHead_29",
            "WhiteHead_30",
            "WhiteHead_31",
            "WhiteHead_32"
        ];

        private _head = if(random 1 > 0.1) then {selectRandom _blackHeads} else {selectRandom _whiteHeads};

        [_unit,(selectRandom _frenchVoice)] remoteExec ['setSpeaker'];
        [_unit,_head] remoteExec ['setFace'];
    };

    MAZ_EZM_MDF_fnc_addMDFUniformToUnit = {
        params ["_unit"];
        private _mdfUniforms = ["U_I_CombatUniform","U_I_CombatUniform_shortsleeve","U_BG_Guerilla1_1","U_BG_Guerrilla_6_1","U_BG_Guerilla1_2_F","U_I_C_Soldier_Para_1_F","U_I_L_Uniform_01_deserter_F"];
        private _mdfVests = ["V_PlateCarrier1_rgr_noflag_F","V_TacVest_brn","V_TacVest_brn","V_Chestrig_khk","V_TacChestrig_cbr_F"];
        private _mdfHeadgear = ["H_MilCap_OUcamo","H_Bandanna_cbr","H_Bandanna_khk_hs","H_Bandanna_khk","H_Watchcap_cbr","H_Booniehat_khk_hs","H_Booniehat_khk","H_HelmetB_light_sand"];
        private _mdfGoggles = ["G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_khk","G_Bandanna_shades","G_Bandanna_sport","G_Bandanna_tan","G_Shades_Black","G_Shades_Blue","G_Shades_Green","G_Shades_Red","G_Spectacles","G_Tactical_Clear","G_Tactical_Black"];
        
        _unit forceAddUniform (selectRandom _mdfUniforms);
        _unit addVest (selectRandom _mdfVests);
        _unit addHeadgear (selectRandom _mdfHeadgear);
        _unit addGoggles (selectRandom _mdfGoggles);
    };

    MAZ_EZM_MDF_fnc_addMDFUniformTextures = {
        params ["_unit"];
        switch (uniform _unit) do {
            case "U_BG_Guerrilla_6_1";
            case "U_C_Paramedic_01_F";
            case "U_I_CombatUniform_shortsleeve";
            case "U_I_CombatUniform": {
                _unit setObjectTextureGlobal [0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"];
            };
            case "U_BG_Guerilla1_2_F";
            case "U_I_E_Uniform_01_tanktop_F";
            case "U_I_C_Soldier_Para_1_F";
            case "U_I_L_Uniform_01_deserter_F";
            case "U_BG_Guerilla1_1": {
                _unit setObjectTextureGlobal [1,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"];
            };
        };
    };

    MAZ_EZM_MDF_fnc_createAmmoBearerModule = {
        private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        _unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["FirstAidKit",4],["200Rnd_65x39_cased_Box",1,200],["NLAW_F",1,1],["HandGrenade",2,1],["MiniGrenade",2,1],["1Rnd_HE_Grenade_shell",6,1],["20Rnd_762x51_Mag",3,20]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createAutoriflemanModule = {
        private _unit = [independent,"I_Soldier_AR_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["LMG_Mk200_F",["200Rnd_65x39_cased_Box",3],["optic_holosight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createMedicModule = {
        private _unit = [independent,"I_Medic_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],0] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit addBackpack "B_AssaultPack_cbr";
        _unit addItemToBackpack "Medikit";
        for "_i" from 0 to 4 do {
            _unit addItemToBackpack "FirstAidKit";
        };

        _unit
    };

    MAZ_EZM_MDF_fnc_createCrewmanModule = {
        private _unit = [independent,"I_crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        removeHeadgear _unit;
        _unit addHeadgear "H_HelmetCrew_I";
        removeVest _unit;
        _unit addVest "V_TacVest_brn";
        [_unit,["arifle_Mk20C_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createEngineerModule = {
        private _unit = [independent,"I_engineer_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        _unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["ToolKit",1],["MineDetector",1],["DemoCharge_Remote_Mag",2,1],["SatchelCharge_Remote_Mag",1,1]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createExplosivesSpecModule = {
        private _unit = [independent,"I_Soldier_exp_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        _unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["ToolKit",1],["MineDetector",1],["APERSBoundingMine_Range_Mag",3,1],["ClaymoreDirectionalMine_Remote_Mag",2,1],["SLAMDirectionalMine_Wire_Mag",2,1],["DemoCharge_Remote_Mag",1,1]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createGrenadierModule = {
        private _unit = [independent,"I_Soldier_GL_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_GL_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createHeliCrewModule = {
        private _unit = [independent,"I_crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        removeHeadgear _unit;
        _unit addHeadgear "H_CrewHelmetHeli_B";
        removeVest _unit;
        _unit addVest "V_TacVest_brn";
        [_unit,["arifle_Mk20C_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createHeliPilotModule = {
        private _unit = [independent,"I_crew_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        removeHeadgear _unit;
        _unit addHeadgear "H_PilotHelmetHeli_B";
        removeVest _unit;
        _unit addVest "V_TacVest_brn";
        [_unit,["arifle_Mk20C_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createMarksmanModule = {
        private _unit = [independent,"I_Soldier_M_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["srifle_DMR_03_tan_F",["20Rnd_762x51_Mag",5],["optic_hamr"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createMissileSpecAAModule = {
        private _unit = [independent,"I_Soldier_AA_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],["launch_B_Titan_F",["Titan_AA",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createPilotModule = {
        private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        _unit setUnitLoadout [["SMG_01_F","","","optic_Aco_smg",["30Rnd_45ACP_Mag_SMG_01",30],[],""],[],[],["U_I_pilotCoveralls",[["30Rnd_45ACP_Mag_SMG_01",3,30],["SmokeShellOrange",2,1]]],[],[],"H_PilotHelmetFighter_I","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;

        _unit
    };

    MAZ_EZM_MDF_fnc_createRiflemanModule = {
        private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createRiflemanATModule = {
        private _unit = [independent,"I_Soldier_LAT_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        _unit addBackpack "B_AssaultPack_cbr";
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],["launch_NLAW_F",["NLAW_F",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createRiflemanLATModule = {
        private _unit = [independent,"I_Soldier_LAT2_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        _unit addBackpack "B_AssaultPack_cbr";
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],["launch_MRAWS_sand_rail_F",["MRAWS_HEAT_F",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_MDF_fnc_createSquadLeadModule = {
        private _unit = [independent,"I_Soldier_SL_F",MAZ_EZM_stanceForAI,"AWARE","SERGEANT"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_hamr","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit addBackpack "B_RadioBag_01_black_F";
        [(unitbackpack _unit),[0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]] remoteExec ['setObjectTexture',0,_unit];

        _unit
    };

    MAZ_EZM_MDF_fnc_createSurvivorModule = {
        private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        removeVest _unit;
        removeHeadgear _unit;
        [_unit,""] remoteExec ["switchMove"];
        _unit
    };

    MAZ_EZM_MDF_fnc_createUAVOpModule = {
        private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;
        _unit setUnitLoadout [[],[],[],[],[],[],"","",[],["ItemMap","I_UavTerminal","ItemRadio","ItemCompass","ItemWatch",""]];
        [_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
        [_unit] spawn MAZ_EZM_MDF_fnc_addMDFUniformTextures;
        [_unit] call MAZ_EZM_fnc_autoResupplyAI;
        [_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit addBackpack "I_UAV_01_backpack_F";

        _unit
    };

comment "Reinforcements";

    MAZ_EZM_MDF_fnc_createZamakReinforcements = {
        private _vehicle = ["I_Truck_02_transport_F",["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]] call MAZ_EZM_fnc_createVehicle;	
        
        private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
        _driver moveInDriver _vehicle;

        private _group1 = [] call MAZ_EZM_MDF_fnc_createRifleSquadModule;
        private _group2 = [] call MAZ_EZM_MDF_fnc_createRifleSquadModule;
        {
            _x moveInAny _vehicle;
        }forEach (units _group1 + units _group2);
    };

    MAZ_EZM_MDF_fnc_createZamakCoveredReinforcements = {
        private _vehicle = ["I_Truck_02_covered_F",["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"]] call MAZ_EZM_fnc_createVehicle;	
        
        private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
        _driver moveInDriver _vehicle;

        private _group1 = [] call MAZ_EZM_MDF_fnc_createRifleSquadModule;
        private _group2 = [] call MAZ_EZM_MDF_fnc_createRifleSquadModule;
        {
            _x moveInAny _vehicle;
        }forEach (units _group1 + units _group2);
    };

    MAZ_EZM_MDF_fnc_createOffroadReinforcements = {
        private _vehicle = ["I_G_Offroad_01_F"] call MAZ_EZM_fnc_createVehicle;
        
        [
            _vehicle,
            ["Guerilla_03",1], 
            ["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",1,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]
        ] call BIS_fnc_initVehicle;
        
        private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
        _driver moveInDriver _vehicle;

        private _group = [] call MAZ_EZM_MDF_fnc_createPatrolSquadModule;
        {
            _x moveInAny _vehicle;
        }forEach (units _group);
    };

comment "Planes";

    MAZ_EZM_MDF_fnc_createGryphonModule = {
        private _vehicle = ["I_Plane_Fighter_04_F",[
            "a3\air_f_jets\plane_fighter_04\data\fighter_04_fuselage_01_co.paa",
            "a3\air_f_jets\plane_fighter_04\data\fighter_04_fuselage_02_co.paa",
            "a3\air_f_jets\plane_fighter_04\data\fighter_04_misc_01_co.paa",
            format ["a3\air_f_jets\plane_fighter_04\data\numbers\fighter_04_number_0%1_ca.paa", selectRandom [0,1,2,3,4,5,6,7,8,9]],
            format ["a3\air_f_jets\plane_fighter_04\data\numbers\fighter_04_number_0%1_ca.paa", selectRandom [0,1,2,3,4,5,6,7,8,9]],
            format ["a3\air_f_jets\plane_fighter_04\data\numbers\fighter_04_number_0%1_ca.paa", selectRandom [0,1,2,3,4,5,6,7,8,9]]
        ]] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createPilotModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

    MAZ_EZM_MDF_fnc_createBuzzardCASModule = {
        private _vehicle = ["I_Plane_Fighter_03_CAS_F",["a3\air_f_gamma\plane_fighter_03\data\plane_fighter_03_body_1_greyhex_co.paa","a3\air_f_gamma\plane_fighter_03\data\plane_fighter_03_body_2_greyhex_co.paa"]] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createPilotModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };
    
    MAZ_EZM_MDF_fnc_createBuzzardAAModule = {
        private _vehicle = ["I_Plane_Fighter_03_AA_F",["a3\air_f_gamma\plane_fighter_03\data\plane_fighter_03_body_1_greyhex_co.paa","a3\air_f_gamma\plane_fighter_03\data\plane_fighter_03_body_2_greyhex_co.paa"]] call MAZ_EZM_fnc_createVehicle;
        
        if(MAZ_EZM_spawnWithCrew) then {
            private _driver = [] call MAZ_EZM_MDF_fnc_createPilotModule;
            _driver moveInDriver _vehicle;
        };

        _vehicle
    };

comment "Zeus Interface";
MAZ_EZM_MDF_fnc_modules = {
    with uiNamespace do {
        comment "MDF Modules";

        MAZ_MDFTree = [
            MAZ_UnitsTree_INDEP,
            "Malden Defense Force",
            "A3\Data_F_argo\logos\arma3_argo_icon_ca.paa",
            [1,1,1,1],
            format ["The small military force for the island of Malden.\nPrimarily uses NATO hand-me-downs very limited military spending\mrenders them inferior to most modern militaries.\n\nAn Official EZM Faction.\nVersion: %1",missionNamespace getVariable "MAZ_EZM_MDF_Ver"]
        ] call MAZ_EZM_fnc_zeusAddCategory;

        comment "Anti-Air";
            
            MAZ_MDFAntiAirTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "Anti-Air",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFAntiAirTree,
                "IFV-6a Cheetah",
                "Creates a MDF Cheetah.",
                "MAZ_EZM_MDF_fnc_createCheetahModule",
                "\A3\armor_f_beta\APC_Tracked_01\Data\ui\map_APC_Tracked_01_aa_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFAntiAirTree,
                "AWC 302 Nyx (AA)",
                "Creates a MDF Nyx AA.",
                "MAZ_EZM_MDF_fnc_createNyxAAModule",
                "\A3\Armor_F_Tank\LT_01\data\UI\map_LT_01_aa_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "APCs";
            
            MAZ_MDFAPCsTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "APCs",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFAPCsTree,
                "AFV-4 Gorgon",
                "Creates a MDF Gorgon.",
                "MAZ_EZM_MDF_fnc_createGorgonModule",
                "\A3\armor_f_gamma\APC_Wheeled_03\Data\UI\map_APC_Wheeled_03_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFAPCsTree,
                "Rhino MGS",
                "Creates a MDF Rhino.",
                "MAZ_EZM_MDF_fnc_createRhinoModule",
                "\A3\Armor_F_Tank\AFV_Wheeled_01\Data\UI\map_AFV_Wheeled_01_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Cars";
            comment 'getText (configfile >> "CfgVehicles" >> typeOf cursorTarget >> "icon")';

            MAZ_MDFCarsTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "Cars",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Offroad",
                "Creates a MDF Offroad.",
                "MAZ_EZM_MDF_fnc_createOffroadModule",
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Offroad (AT)",
                "Creates a MDF Offroad (AT).",
                "MAZ_EZM_MDF_fnc_createOffroadATModule",
                "\A3\Soft_F_Gamma\Offroad_01\Data\UI\map_offroad_armed_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Offroad (HMG)",
                "Creates a MDF Offroad (HMG).",
                "MAZ_EZM_MDF_fnc_createOffroadHMGModule",
                "\A3\Soft_F_Gamma\Offroad_01\Data\UI\map_offroad_armed_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Quadbike",
                "Creates a MDF Quadbike.",
                "MAZ_EZM_MDF_fnc_createQuadbikeModule",
                "\A3\Soft_F\Quadbike_01\Data\UI\map_Quad_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Zamak Ammo",
                "Creates a MDF Zamak Ammo.",
                "MAZ_EZM_MDF_fnc_createZamakAmmoModule",
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_box_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Zamak Fuel",
                "Creates a MDF Zamak Fuel.",
                "MAZ_EZM_MDF_fnc_createZamakFuelModule",
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_fuel_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Zamak Medical",
                "Creates a MDF Medical Zamak.",
                "MAZ_EZM_MDF_fnc_createZamakMedicalModule",
                "\A3\soft_f_gamma\Truck_02\data\UI\Map_Truck_02_medevac_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Zamak Repair",
                "Creates a MDF Zamak Repair.",
                "MAZ_EZM_MDF_fnc_createZamakRepairModule",
                "\A3\Soft_F_Beta\Truck_02\Data\UI\Map_Truck_02_repair_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Zamak Transport",
                "Creates a MDF Zamak.",
                "MAZ_EZM_MDF_fnc_createZamakTransportModule",
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFCarsTree,
                "Zamak Transport (Covered)",
                "Creates a MDF Covered Zamak.",
                "MAZ_EZM_MDF_fnc_createZamakTransportCoveredModule",
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Drones";

            MAZ_MDFDronesTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "Drones",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFDronesTree,
                "MQ-4A Greyhawk",
                "Creates a MDF Greyhawk.",
                "MAZ_EZM_MDF_fnc_createGreyhawkModule",
                "\A3\Drones_F\Air_F_Gamma\UAV_02\Data\UI\Map_UAV_02_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Groups";

            MAZ_MDFGroupsTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "Groups",
                '\a3\ui_f_curator\data\rsccommon\rscattributeformation\wedge_ca.paa'
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFGroupsTree,
                "Air-Defense Squad",
                "Creates a MDF Air-Defense Squad.",
                "MAZ_EZM_MDF_fnc_createAASquadModule",
                ""
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFGroupsTree,
                "Anti-Tank Squad",
                "Creates a MDF Anti-Tank Squad.",
                "MAZ_EZM_MDF_fnc_createATSquadModule",
                ""
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFGroupsTree,
                "Patrol Squad",
                "Creates a MDF Patrol Squad.",
                "MAZ_EZM_MDF_fnc_createPatrolSquadModule",
                ""
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFGroupsTree,
                "Rifle Squad",
                "Creates a MDF Rifle Squad.",
                "MAZ_EZM_MDF_fnc_createRifleSquadModule",
                ""
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFGroupsTree,
                "Sentry Squad",
                "Creates a MDF Sentry Squad.",
                "MAZ_EZM_MDF_fnc_createSentrySquadModule",
                ""
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Helicopters";

            MAZ_MDFHelicopterTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "Helicopters",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFHelicopterTree,
                "MH-9 Hummingbird",
                "Creates a MDF Hummingbird.",
                "MAZ_EZM_MDF_fnc_createHummingbirdModule",
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFHelicopterTree,
                "AH-9 Pawnee",
                "Creates a MDF Pawnee.",
                "MAZ_EZM_MDF_fnc_createPawneeModule",
                "\A3\Air_F\Heli_Light_01\Data\UI\Map_Heli_Light_01_armed_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Men";
            MAZ_MDFMenTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "Men",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Ammo Bearer",
                "Creates a MDF Ammo Bearer.",
                "MAZ_EZM_MDF_fnc_createAmmoBearerModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Autorifleman",
                "Creates a MDF Autorifleman.",
                "MAZ_EZM_MDF_fnc_createAutoriflemanModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconManMG_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Combat Lifesaver",
                "Creates a MDF Combat Lifesaver.",
                "MAZ_EZM_MDF_fnc_createMedicModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconManMedic_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Crewman",
                "Creates a MDF Crewman.",
                "MAZ_EZM_MDF_fnc_createCrewmanModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Engineer",
                "Creates a MDF Engineer.",
                "MAZ_EZM_MDF_fnc_createEngineerModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconManEngineer_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Explosives Specialist",
                "Creates a MDF Explosives Specialist.",
                "MAZ_EZM_MDF_fnc_createExplosivesSpecModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconManExplosive_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Grenadier",
                "Creates a MDF Grenadier.",
                "MAZ_EZM_MDF_fnc_createGrenadierModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Helicopter Crew",
                "Creates a MDF Helicopter Crew.",
                "MAZ_EZM_MDF_fnc_createHeliCrewModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
            
            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Helicopter Pilot",
                "Creates a MDF Helicopter Pilot.",
                "MAZ_EZM_MDF_fnc_createHeliPilotModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Marksman",
                "Creates a MDF Marksman.",
                "MAZ_EZM_MDF_fnc_createMarksmanModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Missile Specialist (AA)",
                "Creates a MDF Anti-Air Missile Specialist.",
                "MAZ_EZM_MDF_fnc_createMissileSpecAAModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Pilot",
                "Creates a MDF Pilot.",
                "MAZ_EZM_MDF_fnc_createPilotModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Rifleman",
                "Creates a MDF Rifleman.",
                "MAZ_EZM_MDF_fnc_createRiflemanModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Rifleman (AT)",
                "Creates a MDF Anti-Tank Rifleman.",
                "MAZ_EZM_MDF_fnc_createRiflemanATModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Rifleman (LAT)",
                "Creates a MDF Light Anti-Tank Rifleman.",
                "MAZ_EZM_MDF_fnc_createRiflemanLATModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconManAT_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Squad Leader",
                "Creates a MDF Squad Leader.",
                "MAZ_EZM_MDF_fnc_createSquadLeadModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconManLeader_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "Survivor",
                "Creates a MDF Survivor.",
                "MAZ_EZM_MDF_fnc_createSurvivorModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFMenTree,
                "UAV Operator",
                "Creates a MDF UAV Operator.",
                "MAZ_EZM_MDF_fnc_createUAVOpModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Reinforcement";
            MAZ_MDFReinforcementTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "Reinforcement",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFReinforcementTree,
                "Offroad",
                "Creates a MDF Offroad filled with 1 patrol squad.",
                "MAZ_EZM_MDF_fnc_createOffroadReinforcements",
                "\A3\soft_f\Offroad_01\Data\UI\map_offroad_01_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFReinforcementTree,
                "Zamak Transport",
                "Creates a MDF Zamak Transport filled with 2 rifle squads.",
                "MAZ_EZM_MDF_fnc_createZamakReinforcements",
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_dump_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
            
            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFReinforcementTree,
                "Zamak Transport (Covered)",
                "Creates a MDF Zamak Transport (Covered) filled with 2 rifle squads.",
                "MAZ_EZM_MDF_fnc_createZamakCoveredReinforcements",
                "\A3\soft_f_beta\Truck_02\data\UI\Map_Truck_02_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

        comment "Planes";

            MAZ_MDFPlanesTree = [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                "Planes",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFPlanesTree,
                "A-143 Buzzard (AA)",
                "Creates a MDF AA Buzzard.",
                "MAZ_EZM_MDF_fnc_createBuzzardAAModule",
                "\A3\Air_F_Gamma\Plane_Fighter_03\Data\UI\Map_Plane_Fighter_03_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFPlanesTree,
                "A-143 Buzzard (CAS)",
                "Creates a MDF CAS Buzzard.",
                "MAZ_EZM_MDF_fnc_createBuzzardCASModule",
                "\A3\Air_F_Gamma\Plane_Fighter_03\Data\UI\Map_Plane_Fighter_03_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;

            [
                MAZ_UnitsTree_INDEP,
                MAZ_MDFTree,
                MAZ_MDFPlanesTree,
                "A-149 Gryphon",
                "Creates a MDF Gryphon.",
                "MAZ_EZM_MDF_fnc_createGryphonModule",
                "\A3\Air_F_Jets\Plane_Fighter_04\Data\UI\Fighter04_icon_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_INDEP;
    };
};

["MAZ_EZM_MDF_fnc_modules"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;