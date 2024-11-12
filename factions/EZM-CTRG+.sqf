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

if(!isNil "MAZ_EZM_CTRGP") exitWith {
    ["CTRG+ is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_CTRGP_Ver = "1.0";
MAZ_EZM_CTRGP = true;

comment "Cars";

    MAZ_EZM_CTRGP_fnc_createLightTanProwlerModule = {
        private _vehicle = ["B_CTRG_LSV_01_light_F",["a3\soft_f_exp\lsv_01\data\nato_lsv_01_sand_co.paa","a3\soft_f_exp\lsv_01\data\nato_lsv_02_sand_co.paa","a3\soft_f_exp\lsv_01\data\nato_lsv_03_sand_co.paa","a3\soft_f_exp\lsv_01\data\nato_lsv_adds_sand_co.paa"]] call MAZ_EZM_fnc_createVehicle;

        if(MAZ_EZM_spawnWithCrew) then { 
            private _driver = [] call MAZ_EZM_CTRGP_fnc_createRiflemanModule; 
            _driver moveInDriver _vehicle;
        }; 

        _vehicle
    };

comment "Appearance";

    MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit = {
        params ["_unit"];
        private _CTRGPUniforms = ["U_B_CTRG_1","U_B_CTRG_3","U_B_CTRG_2","U_B_CTRG_Soldier_2_Arid_F"];
        private _CTRGPVests = ["V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG"];
        private _CTRGPHeadgear = ["H_Bandanna_cbr","H_Bandanna_khk_hs","H_Bandanna_khk","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_khk","H_Booniehat_khk_hs","H_Booniehat_khk","H_Cap_blk","H_Cap_oli","H_Cap_oli_hs","H_Cap_tan","H_Cap_khaki_specops_UK","H_HelmetB_black","H_HelmetB_camo","H_HelmetB_light_snakeskin","H_Cap_headphones"];
        private _CTRGPGoggles = ["","G_AirPurifyingRespirator_01_F","G_Aviator","G_Bandanna_beast","G_Bandanna_khk","G_Shades_Black","G_Shades_Blue","G_Shades_Green","G_Spectacles","G_Balaclava_TI_blk_F","G_Tactical_Clear","G_Tactical_Black","G_Spectacles_Tinted"];
        
        _unit forceAddUniform (selectRandom _CTRGPUniforms);
        _unit addVest (selectRandom _CTRGPVests);
        _unit addHeadgear (selectRandom _CTRGPHeadgear);
        _unit addGoggles (selectRandom _CTRGPGoggles);
    };

    MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnitSF = {
        params ["_unit"];
        private _CTRGPUniforms = ["U_B_CTRG_Soldier_Arid_F","U_B_CTRG_Soldier_3_Arid_F","U_B_CTRG_Soldier_Arid_F","U_B_CTRG_Soldier_3_Arid_F","U_B_CTRG_Soldier_Arid_F","U_B_CTRG_Soldier_3_Arid_F","U_B_CTRG_Soldier_2_Arid_F"];
        private _CTRGPVests = ["V_PlateCarrierL_CTRG","V_PlateCarrierH_CTRG"];
        private _CTRGPHeadgear = ["H_HelmetB_TI_arid_F"];
        private _CTRGPGoggles = ["G_Balaclava_TI_blk_F","G_Balaclava_TI_G_blk_F","G_Combat"];
        
        _unit forceAddUniform (selectRandom _CTRGPUniforms);
        _unit addVest (selectRandom _CTRGPVests);
        _unit addHeadgear (selectRandom _CTRGPHeadgear);
        _unit addGoggles (selectRandom _CTRGPGoggles);
    };

    MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit = {
        params ["_unit"];
        sleep 0.5;
        private _britishVoice = [
            "Male01ENGB",
            "Male02ENGB",
            "Male03ENGB",
            "Male04ENGB",
            "Male05ENGB"
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

        [_unit,(selectRandom _britishVoice)] remoteExec ['setSpeaker',0,_unit];
        [_unit,(selectRandom _whiteHeads)] remoteExec ['setFace',0,_unit];
        if(goggles _unit == "G_Combat") then {
            removeGoggles _unit;
        };
    };

comment "Men";

    MAZ_EZM_CTRGP_fnc_createAutoriflemanModule = {
        private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;

        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
        [_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
        (selectRandom [
            ["LMG_03_F","200Rnd_556x45_Box_F",2],
            ["arifle_MX_SW_Black_F","100Rnd_65x39_caseless_black_mag",4],
            ["arifle_SPAR_02_blk_F","150Rnd_556x45_Drum_Mag_F",4]
        ]) params ["_unitWeapon","_unitMag","_unitMagCount"];
        private _optic = selectRandom ["optic_ACO_grn","optic_Holosight_blk_F","optic_ACO",""];
        [_unit,[_unitWeapon,[_unitMag,_unitMagCount],[_optic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_CTRGP_fnc_createGrenadierModule = {
        private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;

        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
        [_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
        (selectRandom [
            ["arifle_SPAR_01_GL_blk_F","30Rnd_556x45_Stanag","1Rnd_HE_Grenade_shell"],
            ["arifle_MX_GL_Black_F","30Rnd_65x39_caseless_black_mag","3Rnd_HE_Grenade_shell"]
        ]) params ["_grenadierWeapon","_grenadierMag","_grenadierGrenade"];
        private _optic = selectRandom ["optic_ACO_grn","optic_Holosight_blk_F","optic_ACO",""];
        [_unit,[_grenadierWeapon,[_grenadierMag,5],[_optic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2],[_grenadierGrenade,4]]] call MAZ_EZM_fnc_addItemAndWeapons;
        
        _unit
    };

    MAZ_EZM_CTRGP_fnc_createMarksmanModule = {
        private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;

        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
        [_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
        (selectRandom [["srifle_DMR_03_F","20Rnd_762x51_Mag"],["srifle_EBR_F","20Rnd_762x51_Mag"],["arifle_SPAR_03_blk_F","20Rnd_762x51_Mag"]]) params ["_markWeapon","_markMag"];
        private _markOptic = selectRandom ["optic_DMS","optic_KHS_blk","optic_SOS"];
        [_unit,[_markWeapon,[_markMag,5],[_markOptic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_CTRGP_fnc_createRiflemanModule = {
        private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;

        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
        [_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
        private _pWeapon = selectRandom [["arifle_MX_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_MXM_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_SPAR_01_blk_F", "30Rnd_556x45_Stanag"]];
        private _optic = selectRandom ["optic_ACO_grn","optic_Holosight_blk_F","optic_ACO",""];
        [_unit,[_pWeapon select 0,[_pWeapon select 1,5],[_optic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;
        
        _unit
    };

    MAZ_EZM_CTRGP_fnc_createRiflemanATModule = {
        private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;

        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
        [_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
        _unit addBackpackGlobal "B_Kitbag_rgr";
        private _pWeapon = selectRandom [["arifle_MX_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_MXM_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_SPAR_01_blk_F", "30Rnd_556x45_Stanag"]];
        private _optic = selectRandom ["optic_ACO_grn","optic_Holosight_blk_F","optic_ACO",""];
        [_unit,[_pWeapon select 0,[_pWeapon select 1,5],[_optic,"acc_pointer_ir"]],["launch_NLAW_F",["NLAW_F",3]],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

        _unit
    };

    MAZ_EZM_CTRGP_fnc_createRiflemanLATModule = {
        private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;

        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
        [_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
        _unit addBackpackGlobal "B_Kitbag_rgr";
        private _pWeapon = selectRandom [["arifle_MX_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_MXM_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_SPAR_01_blk_F", "30Rnd_556x45_Stanag"]];
        private _optic = selectRandom ["optic_ACO_grn","optic_Holosight_blk_F","optic_ACO",""];
        [_unit,[_pWeapon select 0,[_pWeapon select 1,5],[_optic,"acc_pointer_ir"]],["launch_MRAWS_green_F",["MRAWS_HEAT_F",3]],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;
        _unit addItemToBackpack "MRAWS_HE_F";

        _unit
    };

comment "Men (Special Forces)";

    MAZ_EZM_CTRGP_fnc_createRiflemanSFModule = {
        private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"AWARE"] call MAZ_EZM_fnc_createMan;

        [_unit] call MAZ_EZM_fnc_removeAllClothing;
        [_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnitSF;
        [_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
        private _pWeapon = selectRandom [["arifle_MX_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_MXM_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_SPAR_01_blk_F", "30Rnd_556x45_Stanag"]];
        private _optic = selectRandom ["optic_ACO_grn","optic_Holosight_blk_F","optic_ACO",""];
        [_unit,[_pWeapon select 0,[_pWeapon select 1,5],[_optic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;
        
        _unit
    };

comment "Zeus Interface";
MAZ_EZM_CTRGP_fnc_modules = {
    with uiNamespace do {
        comment "CTRG+ Modules";

            private _ctrgLocalText = localize "$STR_A3_CFGFACTIONCLASSES_BLU_CTRG_F0";
            MAZ_CTRGPTree = [MAZ_UnitsTree_BLUFOR,_ctrgLocalText] call MAZ_EZM_fnc_findTree;
            MAZ_UnitsTree_BLUFOR tvSetText [[MAZ_CTRGPTree], (_ctrgLocalText + "+")];
            MAZ_UnitsTree_BLUFOR tvSetPictureRight [[MAZ_CTRGPTree], "\A3\missions_F_exp\data\img\lobby\ui_campaign_lobby_ctrg_tree_logo_ca.paa"];
            MAZ_UnitsTree_BLUFOR tvSetTooltip [[MAZ_CTRGPTree], format ["A remastered version of the CTRG faction.\n\nAn Official EZM Faction.\nVersion: %1",missionNamespace getVariable "MAZ_EZM_CTRGP_Ver"]];

        comment "Cars";

            MAZ_CTRGPCarsTree = 0;

            [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                MAZ_CTRGPCarsTree,
                "Prowler (Light, Tan)",
                "Creates a Lighter Prowler, but in tan.",
                "MAZ_EZM_CTRGP_fnc_createLightTanProwlerModule",
                "\A3\Soft_F_Exp\LSV_01\Data\UI\map_LSV_01_base_CA.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

        comment "Men";
            
            MAZ_CTRGPMenTree = [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                "Men (Arid)",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                MAZ_CTRGPMenTree,
                "Autorifleman",
                "Creates a CTRG Autorifleman.",
                "MAZ_EZM_CTRGP_fnc_createAutoriflemanModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

            [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                MAZ_CTRGPMenTree,
                "Grenadier",
                "Creates a CTRG Grenadier.",
                "MAZ_EZM_CTRGP_fnc_createGrenadierModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

            [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                MAZ_CTRGPMenTree,
                "Marksman",
                "Creates a CTRG Marksman.",
                "MAZ_EZM_CTRGP_fnc_createMarksmanModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

            [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                MAZ_CTRGPMenTree,
                "Rifleman",
                "Creates a CTRG Rifleman.",
                "MAZ_EZM_CTRGP_fnc_createRiflemanModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

            [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                MAZ_CTRGPMenTree,
                "Rifleman (AT)",
                "Creates a CTRG Rifleman AT.",
                "MAZ_EZM_CTRGP_fnc_createRiflemanATModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

            [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                MAZ_CTRGPMenTree,
                "Rifleman (Light AT)",
                "Creates a CTRG Rifleman Light AT.",
                "MAZ_EZM_CTRGP_fnc_createRiflemanLATModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

        comment "Men (Special Forces)";

            MAZ_CTRGPMenSFTree = [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                "Men (Special Forces) - W.I.P.",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_BLUFOR,
                MAZ_CTRGPTree,
                MAZ_CTRGPMenSFTree,
                "Rifleman",
                "Creates a CTRG Special Forces Rifleman.",
                "MAZ_EZM_CTRGP_fnc_createRiflemanSFModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_BLUFOR;

        MAZ_UnitsTree_BLUFOR tvSort [[MAZ_CTRGPTree]];
    };
};

["MAZ_EZM_CTRGP_fnc_modules"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;