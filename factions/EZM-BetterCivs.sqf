if(isNil "MAZ_EZM_Version") exitWith {
    systemChat "Enhanced Zeus Modules is not running!";
    playSound "addItemFailed";
};

if(isNil "MAZ_EZM_fnc_addNewFactionToDynamicFactions") exitWith {
    ["Your version of EZM is incompatible with dynamic factions. Please use the latest version!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

if(!isNil "MAZ_EZM_BCivs") exitWith {
    ["Better Civilians is already loaded!", "addItemFailed"] call MAZ_EZM_fnc_systemMessage;
};

MAZ_EZM_BCivs_Ver = "1.0";
MAZ_EZM_BCivs = true;

comment "Better Civilians";

    MAZ_EZM_BCivs_fnc_createBetterCivilianModule = {
        private _unit = [civilian,"C_man_1","UP","SAFE"] call MAZ_EZM_fnc_createMan;

        private _civilianUniforms = ["U_C_ArtTShirt_01_v6_F","U_C_ArtTShirt_01_v1_F","U_C_Man_casual_2_F","U_C_ArtTShirt_01_v2_F","U_C_ArtTShirt_01_v4_F","U_C_Man_casual_3_F","U_C_Man_casual_1_F","U_C_ArtTShirt_01_v5_F","U_C_ArtTShirt_01_v3_F","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Uniform_Farmer_01_F","U_C_FormalSuit_01_black_F","U_C_FormalSuit_01_blue_F","U_C_FormalSuit_01_gray_F","U_C_FormalSuit_01_khaki_F","U_C_FormalSuit_01_tshirt_black_F","U_C_FormalSuit_01_tshirt_gray_F","U_BG_Guerilla2_2","U_BG_Guerilla2_1","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_C_HunterBody_grn","U_C_E_LooterJacket_01_F","U_I_L_Uniform_01_tshirt_black_F","U_I_L_Uniform_01_tshirt_skull_F","U_I_L_Uniform_01_tshirt_sport_F","U_Marshal","U_C_Mechanic_01_F","U_C_Uniform_Scientist_02_formal_F","U_C_Man_casual_6_F","U_C_Man_casual_4_F","U_C_Man_casual_5_F","U_C_Poor_1"];
        private _civilianHeadgear = ["H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_mcamo","H_Booniehat_tan","H_Booniehat_dgtl","H_Cap_red","H_Cap_blu","H_Cap_oli","H_Cap_tan","H_Cap_blk","H_Cap_blk_CMMG","H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_Cap_grn","H_Cap_grn_BI","H_Cap_blk_ION","H_Cap_usblack","H_Cap_surfer","H_Bandanna_surfer","H_Bandanna_khk","H_Bandanna_cbr","H_Bandanna_sgg","H_Bandanna_sand","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_camo","H_Bandanna_mcamo","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_khk","H_Watchcap_camo","H_StrawHat","H_StrawHat_dark","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_grey","H_Hat_checker","H_Hat_tan","H_Hat_Safari_sand_F","H_Hat_Safari_olive_F","H_HeadSet_black_F","H_Hat_Tinfoil_F","H_Booniehat_mgrn"];
        private _civilianGoggles = ["","G_Spectacles","G_Spectacles_Tinted","G_Shades_Black","G_Shades_Green","G_Shades_Red","G_Squares","G_Squares_Tinted","G_Sport_BlackWhite","G_Sport_Blackyellow","G_Sport_Greenblack","G_Sport_Checkered","G_Sport_Red","G_Shades_Blue","G_Sport_Blackred","G_Respirator_white_F","G_Respirator_yellow_F","G_Respirator_blue_F","G_WirelessEarpiece_F","G_RegulatorMask_F"];
        
        removeUniform _unit;
        removeHeadgear _unit;
        removeGoggles _unit;
        _unit forceAddUniform (selectRandom _civilianUniforms);
        _unit addHeadgear (selectRandom _civilianHeadgear);
        _unit addGoggles (selectRandom _civilianGoggles);
        [_unit,""] remoteExec ["switchMove"];
    };

    MAZ_EZM_BCivs_fnc_createBetterCivilianJournoModule = {
        private _unit = [civilian,"C_journalist_F","UP","SAFE"] call MAZ_EZM_fnc_createMan;

        private _pressUni = "U_C_Journalist";
        private _pressVest = [""];
        private _pressHeadgear = ["H_Cap_press","H_WirelessEarpiece_F",""];
        private _pressGoggles = ["","G_WirelessEarpiece_F","G_Spectacles_Tinted","G_Shades_Black","G_Aviator"];

        if((random 1) < 0.5) then {
            _pressVest = ["V_Press_F"];
            _pressHeadgear pushBack "H_PASGT_basic_blue_press_F";
            _pressHeadgear pushBack "H_PASGT_neckprot_blue_press_F";
        };

        removeUniform _unit;
        removeVest _unit;
        removeHeadgear _unit;
        removeGoggles _unit;
        _unit forceAddUniform _pressUni;
        _unit addVest (selectRandom _pressVest);
        _unit addHeadgear (selectRandom _pressHeadgear);
        _unit addGoggles (selectRandom _pressGoggles);
        [_unit,""] remoteExec ["switchMove"];
    };

comment "Zeus Interface";
MAZ_EZM_BCivs_fnc_modules = {
    with uiNamespace do {
        MAZ_BetterCivsTree = [
            MAZ_UnitsTree_CIVILIAN,
            "Better Civilians",
            "a3\ui_f\data\gui\rsc\rscdisplaymain\menu_multiplayer_ca.paa"
        ] call MAZ_EZM_fnc_zeusAddCategory;

        comment "Men";
            MAZ_BetterCivsMenTree = [
                MAZ_UnitsTree_CIVILIAN,
                MAZ_BetterCivsTree,
                "Men",
                ""
            ] call MAZ_EZM_fnc_zeusAddSubCategory;

            [
                MAZ_UnitsTree_CIVILIAN,
                MAZ_BetterCivsTree,
                MAZ_BetterCivsMenTree,
                "Civilian",
                "Creates a civilian with randomized clothing.",
                "MAZ_EZM_BCivs_fnc_createBetterCivilianModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_CIVILIAN;

            [
                MAZ_UnitsTree_CIVILIAN,
                MAZ_BetterCivsTree,
                MAZ_BetterCivsMenTree,
                "Journalist",
                "Creates a journalist with randomized clothing.",
                "MAZ_EZM_BCivs_fnc_createBetterCivilianJournoModule",
                "\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
            ] call MAZ_EZM_fnc_zeusAddModule_CIVILIAN;
    };
};

["MAZ_EZM_BCivs_fnc_modules"] call MAZ_EZM_fnc_addNewFactionToDynamicFactions;