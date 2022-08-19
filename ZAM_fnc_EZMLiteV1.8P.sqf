MAZ_EZM_LiteVersion = "V1.8P";
MAZ_EZM_autoAdd = profileNamespace getVariable ['MAZ_EZM_autoAddVar',true];
MAZ_EZM_spawnWithCrew = true;
MAZ_EZM_stanceForAI = "UP";
uiNamespace setVariable ["MAZ_EZM_activeWarnings",[]];
uiNamespace setVariable ['MAZ_EZM_missingRespawnWarn',nil];

comment "If being ran from mission file, set _serverEZM to true:";
private _serverEZM = false;
missionNamespace setVariable ['M9SD_serverEZM', _serverEZM];
uiNamespace setVariable ['M9SD_serverEZM', _serverEZM];
if (M9SD_serverEZM) then {MAZ_EZM_autoAdd = false;};

comment "Common Variables";
EZM_trimColor = [0, 1, 0, 1];
EZM_trimColor = if (M9SD_serverEZM) then {[0.20, 0.90, 0.40, 1.00]} else {[0.00, 0.75, 0.75, 1.00]};
uiNamespace setVariable ['EZM_trimColor', EZM_trimColor];

comment "Common Functions";

JAM_fnc_forceOpenZeus = {
	comment "ensure scheduled environment:";
	[] spawn {
		comment "do not run if already open";
		if !(isNull findDisplay 312) exitWith {};
		comment "run open command until opened";
		while {isNull findDisplay 312} do {
			openCuratorInterface;
			sleep 0.1;
		};
		comment "interface opened.";
	};
};

JAM_fnc_forceCloseZeus = {
	comment "ensure scheduled environment:";
	[] spawn {
		comment "do not run if already closed";
		if (isNull findDisplay 312) exitWith {};
		comment "run close command until closed";
		while {!isNull findDisplay 312} do {
			(findDisplay 312) closeDisplay 0;
			sleep 0.1;
		};
		comment "interface closed.";
	};
};

JAM_fnc_systemChat = {
	params [['_message', ''], ['_show', true]];
	systemChat _message;
	showChat _show;
};

comment "Dialog Creation";

	MAZ_EZM_fnc_convertToGUI_GRIDFormat = {
		params ["_mode","_value"];

		comment "Defines";
			private _GUI_GRID_WAbs = ((safeZoneW / safeZoneH) min 1.2);
			private _GUI_GRID_HAbs = (_GUI_GRID_WAbs / 1.2);
			private _GUI_GRID_W = (_GUI_GRID_WAbs / 40);
			private _GUI_GRID_H = (_GUI_GRID_HAbs / 25);
			private _GUI_GRID_X = (safeZoneX);
			private _GUI_GRID_Y = (safeZoneY + safeZoneH - _GUI_GRID_HAbs);

			private _GUI_GRID_CENTER_WAbs = _GUI_GRID_WAbs;
			private _GUI_GRID_CENTER_HAbs = _GUI_GRID_HAbs;
			private _GUI_GRID_CENTER_W = _GUI_GRID_W;
			private _GUI_GRID_CENTER_H = _GUI_GRID_H;
			private _GUI_GRID_CENTER_X = (safeZoneX + (safeZoneW - _GUI_GRID_CENTER_WAbs)/2);
			private _GUI_GRID_CENTER_Y = (safeZoneY + (safeZoneH - _GUI_GRID_CENTER_HAbs)/2);

		comment "Mode Selection";
		private _return = switch (toUpper _mode) do {
			case "X": {((_value) * _GUI_GRID_W + _GUI_GRID_CENTER_X)};
			case "Y": {((_value) * _GUI_GRID_H + _GUI_GRID_CENTER_Y)};
			case "W": {((_value) * _GUI_GRID_W)};
			case "H": {((_value) * _GUI_GRID_H)};
		};
		_return
	};
	uiNamespace setVariable ["MAZ_EZM_fnc_convertToGUI_GRIDFormat",MAZ_EZM_fnc_convertToGUI_GRIDFormat];

	MAZ_EZM_fnc_createDialogBase = {
		createDialog "RscDisplayEmpty";
		showchat true;
		private _display = findDisplay -1;

		private _label = _display ctrlCreate ["RscText",IDC_TITLE];
		_label ctrlSetPositionX (["X",6.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlSetPositionW (["W",27] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlSetPositionH (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlSetBackgroundColor [0,0.5,0.5,1];
		_label ctrlCommit 0;

		private _background = _display ctrlCreate ["RscText",IDC_BACKGROUND];
		_background ctrlSetPositionX (["X",6.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_background ctrlSetPositionW (["W",27] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_background ctrlSetBackgroundColor [0,0,0,0.7];
		_background ctrlCommit 0;

		private _contentGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars",IDC_CONTENT];
		_contentGroup ctrlSetPositionX (["X",7] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_contentGroup ctrlSetPositionW (["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_contentGroup ctrlCommit 0;

		private _okayButton = _display ctrlCreate ["RscButtonMenuOk",IDC_CONFIRM];
		_okayButton ctrlSetPositionX (["X",28.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_okayButton ctrlSetPositionW (["W",5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_okayButton ctrlSetPositionH (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_okayButton ctrlAddEventhandler ["ButtonClick",{
			params ["_control"];
			private _display = ctrlParent _control;
			(_display getVariable "MAZ_moduleMenuInfo") params ["_controls","_onConfirm","_onCancel","_args"];

			private _values = _controls apply {
				_x params ["_controlsGroup","_settings"];

				[_controlsGroup,_settings] call (_controlsGroup getVariable "controlValue");
			};

			[_values,_args,_display] call _onConfirm;
		}];
		_okayButton ctrlCommit 0;

		private _cancelButton = _display ctrlCreate ["RscButtonMenuCancel",IDC_CANCEL];
		_cancelButton ctrlSetPositionX (["X",6.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_cancelButton ctrlSetPositionW (["W",5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_cancelButton ctrlSetPositionH (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_cancelButton ctrlAddEventhandler ["ButtonClick",{
			params ["_control"];
			private _display = ctrlParent _control;
			(_display getVariable "MAZ_moduleMenuInfo") params ["_controls","_onConfirm","_onCancel","_args"];

			private _values = _controls apply {
				_x params ["_controlsGroup","_settings"];

				[_controlsGroup,_settings] call (_controlsGroup getVariable "controlValue");
			};

			[_values,_args,_display] call _onCancel;
		}];
		_cancelButton ctrlCommit 0;

		_display displayAddEventHandler ["KeyDown", {
			params ["_display", "_keyCode"];

			if (_keyCode == 1) then {
				(_display getVariable "MAZ_moduleMenuInfo") params ["_controls","_onConfirm","_onCancel","_args"];

				private _values = _controls apply {
					_x params ["_controlsGroup","_settings"];

					[_controlsGroup,_settings] call (_controlsGroup getVariable "controlValue");
				};

				[_values,_args,_display] call _onCancel;
			};

			false
		}];

		_display
	};

	MAZ_EZM_fnc_createRowBase = {
		params ["_display"];
		private _contentGroup = _display displayCtrl IDC_CONTENT;
		private _controlsGroupRow = _display ctrlCreate ["RscControlsGroupNoScrollbars",IDC_ROW_GROUP,_contentGroup];
		_controlsGroupRow ctrlSetPosition [0,0,(["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_controlsGroupRow ctrlCommit 0;

		private _rowLabel = _display ctrlCreate ["RscText",IDC_ROW_LABEL,_controlsGroupRow];
		_rowLabel ctrlSetPosition [0,0,(["W",10] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_rowLabel ctrlSetBackgroundColor [0,0,0,0.5];
		_rowLabel ctrlCommit 0;

		_controlsGroupRow
	};

	MAZ_EZM_fnc_createComboRow = {
		params ["_display","_defaultValue","_settings"];
		_settings params ["_entries"];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;

		private _combo = _display ctrlCreate ["RscCombo",IDC_ROW_COMBO,_rowControlGroup];
		_combo ctrlSetPosition [(["W",10.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),0,(["W",15.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_combo ctrlCommit 0;

		{
			_x params ["_value","_text","_tooltip","_picture","_textColor"];

			private _index = _combo lbAdd _text;
			_combo lbSetTooltip [_index,_tooltip];
			_combo lbSetPicture [_index,_picture];
			_combo lbSetColor [_index,_textColor];
			_combo setVariable [str _index,_value];

			if(_value isEqualTo _defaultValue) then {
				_combo lbSetCurSel _index;
			};
		} forEach _entries;
		_combo lbAdd "   ";
		_combo lbAdd "    ";

		_rowControlGroup setVariable ["controlValue",{
			params ["_controlsGroup"];

			private _ctrlCombo = _controlsGroup controlsGroupCtrl IDC_ROW_COMBO;
			_ctrlCombo getVariable str lbCurSel _ctrlCombo
		}];

		_rowControlGroup
	};

	MAZ_EZM_fnc_createEditRow = {
		params ["_display","_defaultValue","_settings"];
		_settings params ["_height"];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;

		private _edit = _display ctrlCreate ["RscEdit",IDC_ROW_EDIT,_rowControlGroup];
		_edit ctrlSetPosition [(["W",10.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),pixelH,(["W",15.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat) - pixelH];
		_edit ctrlSetTextColor [1,1,1,1];
		_edit ctrlSetBackgroundColor [0,0,0,0.2];
		_edit ctrlCommit 0;

		_edit ctrlSetText _defaultValue;

		_rowControlGroup setVariable ["controlValue", {
			params ["_controlsGroup"];
			ctrlText (_controlsGroup controlsGroupCtrl IDC_ROW_EDIT)
		}];

		_rowControlGroup
	};

	MAZ_EZM_fnc_createEditMultiRow = {
		params ["_display","_defaultValue","_settings"];
		_settings params [["_height",4]];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;
		_rowControlGroup ctrlSetPositionH (["H",_height + 1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowControlGroup ctrlCommit 0;

		private _label = _rowControlGroup controlsGroupCtrl IDC_ROW_LABEL;
		_label ctrlSetPositionW (["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlCommit 0;

		private _edit = _display ctrlCreate ["RscEditMulti",IDC_ROW_EDIT,_rowControlGroup];
		_edit ctrlSetPosition [pixelW,(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat) - pixelW,(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat) - pixelH];
		_edit ctrlSetPositionH (["H",_height] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_edit ctrlSetTextColor [1,1,1,1];
		_edit ctrlSetBackgroundColor [0,0,0,0.2];
		_edit ctrlSetText _defaultValue;
		_edit ctrlCommit 0;

		_rowControlGroup setVariable ["controlValue", {
			params ["_controlsGroup"];
			ctrlText (_controlsGroup controlsGroupCtrl IDC_ROW_EDIT)
		}];

		_rowControlGroup
	};

	MAZ_EZM_fnc_createEditCodeRow = {
		params ["_display","_defaultValue","_settings"];
		_settings params ["_height"];
		private _rowControlGroup = [_display,_defaultValue,[_height]] call MAZ_EZM_fnc_createEditMultiRow;

		private _execButton = _display displayCtrl IDC_CONFIRM;
		_execButton ctrlSetText "Exec";
		_execButton ctrlCommit 0;

		private _edit = _display displayCtrl IDC_ROW_EDIT;
		_edit ctrlSetTextColor [1,1,1,1];
		_edit ctrlSetBackgroundColor [0,0,0,0.5];
		_edit ctrlSetFont "EtelkaMonospacePro";
		_edit ctrlSetFontHeight 0.03;
		_edit ctrlSetText _defaultValue;
		_edit ctrlCommit 0;

		_rowControlGroup
	};

	MAZ_EZM_fnc_createListRow = {
		params ["_display","_defaultValue","_settings"];
		_settings params ["_entries","_height"];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;
		_rowControlGroup ctrlSetPositionH (["H",_height + 1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowControlGroup ctrlCommit 0;

		private _label = _rowControlGroup controlsGroupCtrl IDC_ROW_LABEL;
		_label ctrlSetPositionW (["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlCommit 0;

		private _listBox = _display ctrlCreate ["RscListBox",IDC_ROW_COMBO,_rowControlGroup];
		_listBox ctrlSetPosition [0,(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",6] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_listBox ctrlSetPositionH (["H",_height] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_listBox ctrlCommit 0;

		{
			_x params ["_value","_text","_tooltip","_picture","_textColor"];

			private _index = _listBox lbAdd _text;
			_listBox lbSetTooltip [_index,_tooltip];
			_listBox lbSetPicture [_index,_picture];
			_listBox lbSetColor [_index,_textColor];
			_listBox setVariable [str _index,_value];

			if(_value isEqualTo _defaultValue) then {
				_listBox lbSetCurSel _index;
			};
		} forEach _entries;

		_rowControlGroup setVariable ["controlValue",{
			params ["_controlsGroup"];

			private _ctrlCombo = _controlsGroup controlsGroupCtrl IDC_ROW_COMBO;
			_ctrlCombo getVariable str lbCurSel _ctrlCombo
		}];

		_rowControlGroup
	};

	MAZ_EZM_fnc_createSidesRow = {
		params ["_display","_defaultValue","_settings"];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;

		_rowControlGroup ctrlSetPositionH (["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);

		private _label = _rowControlGroup controlsGroupCtrl IDC_ROW_LABEL;
		_label ctrlSetPositionH (["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlCommit 0;

		private _background = _display ctrlCreate ["RscText",-1,_rowControlGroup];
		_background ctrlSetBackgroundColor [0,0,0,0.6];
		_background ctrlSetPosition [(["W",10] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),0,(["W",16] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_background ctrlSetTextColor [1,1,1,0.5];
		_background ctrlCommit 0;

		private _sidesGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars",IDC_ROW_SIDES,_rowControlGroup];
		_sidesGroup ctrlSetPosition [(["W",10] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),0,(["W",16] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_sidesGroup ctrlCommit 0;

		private _blufor = _display ctrlCreate ["RscActivePicture",IDC_SIDES_BLUFOR,_sidesGroup];
		_blufor ctrlSetText "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_west_ca.paa";
		_blufor ctrlSetPosition [(["W",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",0.25] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["W",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_blufor ctrlCommit 0;

		private _opfor = _display ctrlCreate ["RscActivePicture",IDC_SIDES_OPFOR,_sidesGroup];
		_opfor ctrlSetText "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_east_ca.paa";
		_opfor ctrlSetPosition [(["W",5.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",0.25] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["W",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_opfor ctrlCommit 0;

		private _indep = _display ctrlCreate ["RscActivePicture",IDC_SIDES_INDEPENDENT,_sidesGroup];
		_indep ctrlSetText "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_guer_ca.paa";
		_indep ctrlSetPosition [(["W",8.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",0.25] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["W",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_indep ctrlCommit 0;

		private _civ = _display ctrlCreate ["RscActivePicture",IDC_SIDES_CIVILIAN,_sidesGroup];
		_civ ctrlSetText "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_civ_ca.paa";
		_civ ctrlSetPosition [(["W",11.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",0.25] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["W",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_civ ctrlCommit 0;

		if (_defaultValue isEqualType []) then {
			_defaultValue = +_defaultValue;
		};

		private _allowMultiple = _defaultValue isEqualType [];
		_sidesGroup setVariable ["controlValue",_defaultValue];

		private _controls = [];
		private _IDCs = [IDC_SIDES_OPFOR,IDC_SIDES_BLUFOR,IDC_SIDES_INDEPENDENT,IDC_SIDES_CIVILIAN];
		{
			private _sideCtrl = _sidesGroup controlsGroupCtrl _x;
			private _color = [_forEachIndex] call BIS_fnc_sideColor;
			private _side = [_forEachIndex] call BIS_fnc_sideType;

			_sideCtrl ctrlSetActiveColor _color;
			if(_allowMultiple) then {
				if(_side in _defaultValue) then {
					[_sideCtrl,1.2,0] call BIS_fnc_ctrlSetScale;
				} else {
					_color set [3,0.5];
				};
			} else {
				if(_side isEqualTo _defaultValue) then {
					[_sideCtrl,1.2,0] call BIS_fnc_ctrlSetScale;
				} else {
					_color set [3,0.5];
				};
			};
			_sideCtrl ctrlSetTextColor _color;

			if(_allowMultiple) then {
				_sideCtrl ctrlAddEventHandler ["ButtonClick",{
					params ["_sideCtrl"];
					(_sideCtrl getVariable "params") params ["_color","_side"];
					private _controlGroup = ctrlParentControlsGroup _sideCtrl;
					private _value = _controlGroup getVariable "controlValue";

					private _scale = "";
					private _alpha = "";
					if(_side in _value) then {
						_value deleteAt (_value find _side);
						_scale = 1;
						_alpha = 0.5;
					} else {
						_value pushBack _side;
						_scale = 1.25;
						_alpha = 1;
					};
					_color set [3,_alpha];
					_sideCtrl ctrlSetTextColor _color;
					[_sideCtrl,_scale,0.1] call BIS_fnc_ctrlSetScale;
				}];
			} else {
				_sideCtrl ctrlAddEventHandler ["ButtonClick",{
					params ["_sideCtrl"];
					(_sideCtrl getVariable "params2") params ["_controls"];
					private _controlGroup = ctrlParentControlsGroup _sideCtrl;
					{
						_x params ["_ctrl","_color","_side"];
						private _scale = "";
						private _alpha = "";
						if(_ctrl isEqualTo _sideCtrl) then {
							_scale = 1.25;
							_alpha = 1;
							_controlGroup setVariable ["controlValue",_side];
						} else {
							_scale = 1;
							_alpha = 0.5;
						};
						_color set [3,_alpha];
						_ctrl ctrlSetTextColor _color;
						[_ctrl,_scale,0.1] call BIS_fnc_ctrlSetScale;
					}forEach _controls;
				}];

				_controls pushBack [_sideCtrl, _color, _side];
			};
			_sideCtrl setVariable ["params",[_color,_side]];
			_sideCtrl setVariable ["params2",[_controls]];
		}forEach [IDC_SIDES_OPFOR,IDC_SIDES_BLUFOR,IDC_SIDES_INDEPENDENT,IDC_SIDES_CIVILIAN];

		_rowControlGroup setVariable ["controlValue", {
			params ["_controlsGroup"];

			private _ctrlSides = _controlsGroup controlsGroupCtrl IDC_ROW_SIDES;
			_ctrlSides getVariable "controlValue"
		}];

		_rowControlGroup
	};

	MAZ_EZM_fnc_createSliderRow = {
		params ["_display","_defaultValue","_settings"];
		_settings params ["_min","_max","_isPercent","_drawRadius","_radiusCenter","_radiusColor"];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;
		_rowControlGroup setVariable ["MAZ_EZM_isPercent",_isPercent];

		private _slider = _display ctrlCreate ["RscXSliderH",IDC_ROW_SLIDER,_rowControlGroup];
		_slider ctrlSetPosition [(["W",10.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),0,(["W",13.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_slider ctrlSetTextColor [1,1,1,0.6];
		_slider ctrlSetActiveColor [1,1,1,1];
		_slider ctrlCommit 0;

		private _sliderEdit = _display ctrlCreate ["RscEdit",IDC_ROW_EDIT,_rowControlGroup];
		_sliderEdit ctrlSetPosition [(["W",23.7] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),pixelH,(["W",2.3] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),((["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat) - pixelH)];
		_sliderEdit ctrlSetTextColor [1,1,1,1];
		_sliderEdit ctrlSetBackgroundColor [0,0,0,0.2];
		_sliderEdit ctrlCommit 0;

		if(_drawRadius) then {
			["MAZ_EZM_drawSliderRadius","onEachFrame",{
				params ["_ctrlSlider","_center","_color"];
				if(isNull _ctrlSlider || {_center isEqualTo objNull}) exitWith {
					["MAZ_EZM_drawSliderRadius","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				};

				if (_center isEqualType objNull) then {
					_center = ASLToAGL getPosASLVisual _center;
				};

				private _radius = sliderPosition _ctrlSlider;
				private _count = 6 max floor (2 * pi * _radius / 15);
				private _intervals = 360 / _count;

				for "_i" from 0 to (_count - 1) do {
					private _circumferencePos = _i * _intervals;
					drawIcon3D ["\a3\ui_f\data\map\markers\military\dot_ca.paa", _color, [_radius * cos _circumferencePos + (_center # 0),_radius * sin _circumferencePos + (_center # 1),0], 0.5, 0.5, 0];
				};
			},[_slider,_radiusCenter,_radiusColor]] call BIS_fnc_addStackedEventHandler;
		};

		_slider sliderSetRange [_min, _max];
		_slider sliderSetSpeed [-1, -1];
		_slider sliderSetPosition _defaultValue;
		if(_isPercent) then {
			private _text = (str (round (_defaultValue * 100))) + "%";
			_sliderEdit ctrlSetText _text;
		} else {
			_sliderEdit ctrlSetText (str _defaultValue);
		};

		_slider ctrlAddEventHandler ["sliderPosChanged", {
			params ["_ctrlSlider", "_value"];
			private _controlGroup = ctrlParentControlsGroup _ctrlSlider;
			private _isPercent = _controlGroup getVariable ["MAZ_EZM_isPercent",false];
			private _ctrlEdit = _controlGroup controlsGroupCtrl IDC_ROW_EDIT;
			if(_isPercent) then {
				private _text = (str (round (_value * 100))) + "%";
				_ctrlEdit ctrlSetText _text;
			} else {
				private _roundedValue = round _value;
				_ctrlEdit ctrlSetText format ["%1",_roundedValue];
			};
		}];

		_sliderEdit ctrlAddEventHandler ["keyUp",{
			params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
			private _num = parseNumber (ctrlText _displayOrControl);
			private _ctrlGroup = ctrlParentControlsGroup _displayOrControl;
			private _isPercent = _ctrlGroup getVariable ["MAZ_EZM_isPercent",false];
			private _sliderCtrl = _ctrlGroup controlsGroupCtrl IDC_ROW_SLIDER;
			if(_isPercent) then {
				_sliderCtrl sliderSetPosition (_num/100);
			} else {
				_sliderCtrl sliderSetPosition _num;
			};
		}];

		_rowControlGroup setVariable ["controlValue",{
			params ["_controlsGroup"];
			sliderPosition (_controlsGroup controlsGroupCtrl IDC_ROW_SLIDER)
		}];

		_rowControlGroup
	};

	MAZ_EZM_fnc_createToolBoxRow = {
		params ["_display","_defaultValue","_settings"];
		_settings params ["_strings"];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;

		private _ctrlToolbox = _display ctrlCreate ["RscToolBox",IDC_ROW_TOOLBOX,_rowControlGroup];
		_ctrlToolbox ctrlSetPosition [(["W",10.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),0,(["W",15.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_ctrlToolbox ctrlSetTextColor [1,1,1,1];
		_ctrlToolbox ctrlSetBackgroundColor [0,0,0,0.3];
		_ctrlToolbox ctrlCommit 0;
		lbClear _ctrlToolbox;
		
		{
			_x params ["_text","_tooltip"];

			private _index = _ctrlToolbox lbAdd _text;
			_ctrlToolbox lbSetTooltip [_index, _tooltip];
		} forEach _strings;

		if(_defaultValue isEqualType false) then {
			_defaultValue = parseNumber _defaultValue;
		};
		_ctrlToolbox lbSetCurSel _defaultValue;

		_rowControlGroup setVariable ["controlValue", {
			params ["_controlsGroup", "_settings"];

			private _value = lbCurSel (_controlsGroup controlsGroupCtrl IDC_ROW_TOOLBOX);
			_value = _value > 0;

			_value
		}];
		
		_rowControlGroup
	};

	MAZ_EZM_fnc_createVectorRow = {
		params ["_display","_defaultValue","_settings"];
		_settings params ["_labelData","_numOfEdits"];
		_labelData params ["_labels","_labelColors"];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;

		private ["_width","_gap"];
		if(_numOfEdits > 3) then {
			_numOfEdits = 3;
		};
		if(_numOfEdits < 2) then {
			_numOfEdits = 2;
		};
		switch (_numOfEdits) do {
			case 2: {
				_width = 6.5;
				_gap = 0.2;
			};
			case 3: {
				_width = 4.5;
				_gap = 0.2;
			};
		};

		for "_i" from 0 to (_numOfEdits - 1) do {
			
			private _widthPosLabel = (_i * _width) + ((_i + 1) * (_gap * 3)) + 10;
			private _widthPos = _widthPosLabel + 1.2;
			_widthPos = ["W",_widthPos] call MAZ_EZM_fnc_convertToGUI_GRIDFormat;
			_widthPosLabel = ["W",_widthPosLabel] call MAZ_EZM_fnc_convertToGUI_GRIDFormat;

			private _editLabel = _display ctrlCreate ["RscStructuredText",-1,_rowControlGroup];
			_editLabel ctrlSetStructuredText parseText (format ["<t align='center'>%1</t>",_labels select _i]);
			_editLabel ctrlSetBackgroundColor (_labelColors select _i);
			_editLabel ctrlSetPosition [_widthPosLabel,0,["W",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_editLabel ctrlCommit 0;

			private _editBox  = _display ctrlCreate ["RscEdit",IDCS_ROW_VECTOR select _i,_rowControlGroup];
			_editBox ctrlSetText (str (_defaultValue select _i));
			_editBox ctrlSetPosition [_widthPos,0,["W",_width - 1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_editBox ctrlCommit 0;
		};

		_rowControlGroup ctrlSetPositionH (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowControlGroup ctrlCommit 0;

		_rowControlGroup setVariable ["numOfVectorControls",_numOfEdits];

		_rowControlGroup setVariable ["controlValue", {
			params ["_controlsGroup", "_settings"];
			private _numOfEdits = _controlsGroup getVariable "numOfVectorControls";
			private _value = [];
			for "_i" from 0 to (_numOfEdits - 1) do {
				private _editBox = _controlsGroup controlsGroupCtrl (IDCS_ROW_VECTOR select _i);
				_value pushBack (parseNumber (ctrlText _editBox));
			};

			_value
		}];
		
		_rowControlGroup
	};

	MAZ_EZM_fnc_changeDisplayHeights = {
		params ["_display"];
		private _ctrlContent = _display displayCtrl IDC_CONTENT;
		ctrlPosition _ctrlContent params ["_posX","","_posW","_posH"];

		_ctrlContent ctrlSetPositionY (0.5 - (_posH / 2));
		_ctrlContent ctrlCommit 0;

		private _ctrlTitle = _display displayCtrl IDC_TITLE;
		_ctrlTitle ctrlSetPositionY (0.5 - (_posH / 2) - (["H",1.6] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlTitle ctrlCommit 0;

		private _ctrlBG = _display displayCtrl IDC_BACKGROUND;
		_ctrlBG ctrlSetPositionY (0.5 - (_posH / 2) - (["H",0.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlBG ctrlSetPositionH (_posH + (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlBG ctrlCommit 0;

		private _ctrlOkBtn = _display displayCtrl IDC_CONFIRM;
		_ctrlOkBtn ctrlSetPositionY (0.5 + (_posH / 2) + (["H",0.6] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlOkBtn ctrlCommit 0;

		private _ctrlCancelBtn = _display displayCtrl IDC_CANCEL;
		_ctrlCancelBtn ctrlSetPositionY (0.5 + (_posH / 2) + (["H",0.6] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlCancelBtn ctrlCommit 0;
	};

	MAZ_EZM_fnc_createDialog = {
		params [
			["_title","",[""]],
			["_content",[],[[]]],
			["_onConfirm",{},[{}]],
			["_onCancel",{},[{}]],
			["_args",[]]
		];

		private _controlsData = [];
		{
			_x params [
				["_type","",[""]],
				["_name",[],["",[]]],
				["_value",[]]
			];
			_name params [["_label","",[""]],["_toolTip","",[""]]];

			(toUpper _type splitString ":") params [["_type",""],["_subType",""]];

			private ["_defaultValue","_controlType","_settings"];

			switch (_type) do {
				case "COMBO": {
					_value params [["_values",[],[[]]],["_labels",[],[[]]],["_defaultIndex",0,[0]]];
					if(_values isEqualTo []) then {
						{
							_values pushBack _forEachIndex;
						} forEach _labels;
					};

					_defaultValue = _values param [_defaultIndex];
					_controlType = MAZ_EZM_fnc_createComboRow;

					private _entries = [];
					for "_i" from 0 to (count _values - 1) do {
						(_labels select _i) params [["_text","",[""]],["_tooltip","",[""]],["_picture","",[""]],["_textColor",[1,1,1,1],[[]],4]];
						_entries pushBack [_values select _i,_text,_tooltip,_picture,_textColor];
					};

					_settings = [_entries];
				};
				case "EDIT": {
					_value params [["_default",""],["_height",5,[0]]];
					if!(_default isEqualType "") then {
						_default = str _default;
					};

					_defaultValue = _default;

					_controlType = switch (_subType) do {
						case "MULTI": {
							MAZ_EZM_fnc_createEditMultiRow
						};
						case "CODE": {
							MAZ_EZM_fnc_createEditCodeRow
						};
						default {
							MAZ_EZM_fnc_createEditRow
						};
					};

					private _isMulti = _subType in ["MULTI","CODE"];
					_settings = [_height];
				};
				case "LIST": {
					_value params [["_values",[],[[]]],["_labels",[],[[]]],["_defaultIndex",0,[0]],["_height",6,[0]],["_sort",false,[false]]];

					if(_values isEqualTo []) then {
						{
							_values pushBack _forEachIndex;
						}forEach _labels;
					};

					_defaultValue = _values param [_defaultIndex];
					_controlType = MAZ_EZM_fnc_createListRow;

					private _entries = [];
					for "_i" from 0 to (count _values - 1) do {
						(_labels select _i) params [["_text","",[""]],["_tooltip","",[""]],["_picture","",[""]],["_textColor",[1,1,1,1],[[]],4]];
						_entries pushBack [_values select _i,_text,_tooltip,_picture,_textColor];
					};

					_settings = [_entries,_height];
				};
				case "SIDES": {
					_defaultValue = [_value] param [0,west,[west,[]]];
					_controlType = MAZ_EZM_fnc_createSidesRow;
				};
				case "SLIDER": {
					_value params [
						["_min",0,[0]],
						["_max",1,[0]],
						["_default",0,[0]],
						["_radiusCenter",objNull,[objNull,[]], 3],
						["_radiusColor",[1,1,1,0.7],[[]], 4],
						["_isPercent",false,[false]]
					];

					_defaultValue = _default;
					_controlType = MAZ_EZM_fnc_createSliderRow;

					private _drawRadius = _subType == "RADIUS" && {_radiusCenter isNotEqualTo objNull};
					if(_isPercent) then {
						_radiusCenter = objNull;
					};

					_settings = [_min,_max,_isPercent,_drawRadius,_radiusCenter,_radiusColor];
				};
				case "TOOLBOX": {
					_value params [["_default",0,[0,false]],["_strings",[],[[]]]];

					switch (_subType) do {
						case "YESNO": {
							_strings = [["NO",""],["YES",""]];
						};
						case "ENABLED": {
							_strings = [["DISABLE",""],["ENABLE",""]];
						};
					};

					_defaultValue = _default;
					_controlType = MAZ_EZM_fnc_createToolBoxRow;

					_settings = [_strings];
				};
				case "VECTOR": {
					_value params [
						["_default",[0,0,0],[[]]],
						["_labels",["X","Y","Z"],[[]]],
						["_numOfEdits",3,[3]]
					];
					private _labelData = [_labels,[[0.765,0.18,0.1,1],[0.575,0.815,0.22,1],[0.26,0.52,0.92,1]]];

					_defaultValue = _default;
					_controlType = MAZ_EZM_fnc_createVectorRow;

					_settings = [_labelData,_numOfEdits];
				};
			};
			_controlsData pushBack [_controlType,_label,_tooltip,_defaultValue,_settings];
		} forEach _content;

		private _display = [] call MAZ_EZM_fnc_createDialogBase;
		_display setVariable ['MAZ_EZM_onAttribsCancel',_onCancel];
		_display setVariable ['MAZ_EZM_onAttribsConfirm',_onConfirm];

		if(isNull _display) exitWith {false};

		private _ctrlTitle = _display displayCtrl IDC_TITLE;
		_ctrlTitle ctrlSetText (toUpper _title);

		private _ctrlContent = _display displayCtrl IDC_CONTENT;
		private _contentPosY = 0;
		private _controls = [];

		{
			_x params ["_controlType","_label","_tooltip","_defaultValue","_settings"];

			private _controlsGroup = [_display,_defaultValue,_settings] call _controlType;

			private _ctrlLabel = _controlsGroup controlsGroupCtrl IDC_ROW_LABEL;
			_ctrlLabel ctrlSetText (format ["%1",_label]);
			_ctrlLabel ctrlSetTooltip _tooltip;

			_controlsGroup ctrlSetPositionY _contentPosY;
			_controlsGroup ctrlCommit 0;

			_contentPosY = (_contentPosY + (ctrlPosition _controlsGroup select 3) + (["H",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));

			_controls pushBack [_controlsGroup, _settings];
		} forEach _controlsData;

		_ctrlContent ctrlSetPositionH (_contentPosY - (["H",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlContent ctrlCommit 0;

		[_display] call MAZ_EZM_fnc_changeDisplayHeights;

		_display setVariable ["MAZ_moduleMenuInfo",[_controls,_onConfirm,_onCancel,_args]];
	};

	MAZ_defineIDCS = {
		IDC_TITLE = 201;
		IDC_BACKGROUND = 202;
		IDC_CONTENT = 203;
		IDC_CONFIRM = 204;
		IDC_CANCEL = 205;

		IDC_ROW_GROUP = 210;
		IDC_ROW_LABEL = 211;
		IDC_ROW_CHECKBOX = 212;
		IDC_ROW_COMBO = 213;
		IDC_ROW_EDIT = 214;
		IDC_ROW_SLIDER = 215;
		IDC_ROW_TOOLBOX = 216;
		IDC_ROW_SIDES = 217;
		IDC_ROW_VECTOR_X = 220;
		IDC_ROW_VECTOR_Y = 221;
		IDC_ROW_VECTOR_Z = 222;

		IDC_SIDES_BLUFOR = 250;
		IDC_SIDES_OPFOR = 251;
		IDC_SIDES_INDEPENDENT = 252;
		IDC_SIDES_CIVILIAN = 253;

		IDCS_ROW_VECTOR = [IDC_ROW_VECTOR_X,IDC_ROW_VECTOR_Y,IDC_ROW_VECTOR_Z];
	};
	[] call MAZ_defineIDCS;

comment "Attributes Dialog Creation";

	MAZ_EZM_attributesIDCDefinitions = {
		IDC_ATTRIBS_TITLE = 100;
		IDC_ATTRIBS_BG = 101;
		IDC_ATTRIBS_CONTENT = 102;
		IDC_ATTRIBS_CONFIRM = 103;
		IDC_ATTRIBS_CANCEL = 104;

		IDC_ATTRIBS_LABEL = 150;
		IDC_ATTRIBS_ROW_GROUP = 151;
		IDC_ATTRIBS_ROW_BG = 152;
		IDC_ATTRIBS_EDIT = 160;
		IDC_ATTRIBS_EDITMULTI = 161;
		IDC_ATTRIBS_SLIDER = 170;
		IDC_ATTRIBS_SLIDER_EDIT = 171;
		IDC_ATTRIBS_COMBO = 180;
		IDC_ATTRIBS_TOOLBOX = 190;

	};
	[] call MAZ_EZM_attributesIDCDefinitions;

	MAZ_EZM_createAttributesMenuBase = {
		params ["_labelText"];
		createDialog "RscDisplayEmpty";
		showchat true;
		private _display = findDisplay -1;

		private _label = _display ctrlCreate ["RscText",IDC_ATTRIBS_TITLE];
		_label ctrlSetPositionX (["X",6.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlSetPositionW (["W",27] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlSetPositionH (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_label ctrlSetBackgroundColor [0,0.5,0.5,1];
		_label ctrlSetText _labelText;
		_label ctrlCommit 0;

		private _background = _display ctrlCreate ["RscText",IDC_ATTRIBS_BG];
		_background ctrlSetPositionX (["X",6.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_background ctrlSetPositionW (["W",27] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_background ctrlSetBackgroundColor [0,0,0,0.7];
		_background ctrlCommit 0;

		private _contentGroup = _display ctrlCreate ["RscControlsGroup",IDC_ATTRIBS_CONTENT];
		_contentGroup ctrlSetPositionX (["X",7] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_contentGroup ctrlSetPositionW (["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_contentGroup ctrlCommit 0;

		private _okayButton = _display ctrlCreate ["RscButtonMenuOk",IDC_ATTRIBS_CONFIRM];
		_okayButton ctrlSetPositionX (["X",28.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_okayButton ctrlSetPositionW (["W",5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_okayButton ctrlSetPositionH (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_okayButton ctrlAddEventhandler ["ButtonClick",{
			params ["_control"];
			private _display = ctrlParent _control;
			(_display getVariable "MAZ_EZM_attributesDialogInfo") params ["_display","_controls","_args"];
			private _values = [];
			{
				private _value = [_x] call (_x getVariable "MAZ_EZM_getControlValue");
				_values pushBack _value;
			}forEach _controls;

			[_display,_values,_args] call (_display getVariable 'MAZ_EZM_onAttribsConfirm');
		}];
		_okayButton ctrlCommit 0;

		private _cancelButton = _display ctrlCreate ["RscButtonMenuCancel",IDC_ATTRIBS_CANCEL];
		_cancelButton ctrlSetPositionX (["X",6.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_cancelButton ctrlSetPositionW (["W",5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_cancelButton ctrlSetPositionH (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_cancelButton ctrlAddEventhandler ["ButtonClick",{
			params ["_control"];
			private _display = ctrlParent _control;
			(_display getVariable "MAZ_EZM_attributesDialogInfo") params ["_display","_controls","_args"];
			private _values = [];
			{
				private _value = [_x] call (_x getVariable "MAZ_EZM_getControlValue");
				_values pushBack _value;
			}forEach _controls;

			[_display,_values,_args] call (_display getVariable 'MAZ_EZM_onAttribsCancel');
		}];
		_cancelButton ctrlCommit 0;

		_display displayAddEventHandler ["KeyDown", {
			params ["_display", "_keyCode"];

			if (_keyCode == 1) then {
				private _display = ctrlParent _control;
				(_display getVariable "MAZ_EZM_attributesDialogInfo") params ["_display","_controls","_args"];
				private _values = [];
				{
					private _value = [_x] call (_x getVariable "MAZ_EZM_getControlValue");
					_values pushBack _value;
				}forEach _controls;

				[_display,_values,_args] call (_display getVariable 'MAZ_EZM_onAttribsCancel');
			};

			false
		}];

		_display
	};

	MAZ_EZM_createAttributesRowBase = {
		params ["_display","_label"];
		_text = _label;
		_tooltip = "";
		if(_label isEqualType []) then {
			_text = _label # 0;
			_tooltip = _label # 1;
		};
		private _contentGroup = _display displayCtrl IDC_ATTRIBS_CONTENT;
		private _controlsGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars",IDC_ATTRIBS_ROW_GROUP,_contentGroup];
		_controlsGroup ctrlSetPosition [0,0,(["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_controlsGroup ctrlCommit 0;

		private _rowLabel = _display ctrlCreate ["RscText",IDC_ATTRIBS_LABEL,_controlsGroup];
		_rowLabel ctrlSetPosition [0,0,(["W",9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_rowLabel ctrlSetBackgroundColor [0,0,0,0.6];
		_rowLabel ctrlSetText (format ["%1",_text]);
		_rowLabel ctrlSetTooltip _tooltip;
		_rowLabel ctrlCommit 0;

		private _rowBG = _display ctrlCreate ["RscPicture",IDC_ATTRIBS_ROW_BG,_controlsGroup];
		_rowBG ctrlSetPosition [(["W",9.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),0,(["W",16.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_rowBG ctrlSetText "#(argb,8,8,3)color(1,1,1,0.1)";
		_rowBG ctrlCommit 0;

		_controlsGroup
	};

	MAZ_EZM_createAttribEditRow = {
		params ["_display","_label","_default","_settings"];
		private _rowControlsGroup = [_display,_label] call MAZ_EZM_createAttributesRowBase;

		private _rowEditBox = _display ctrlCreate ["RscEdit",IDC_ATTRIBS_EDIT,_rowControlsGroup];
		_rowEditBox ctrlSetPosition [["W",9.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,pixelH,["W",16.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,((["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat) - pixelH)];
		_rowEditBox ctrlSetText _default;
		_rowEditBox ctrlSetBackgroundColor [0,0,0,0.3];
		_rowEditBox ctrlCommit 0;

		_rowControlsGroup setVariable ["MAZ_EZM_getControlValue",{
			params ["_controlsGroup"];
			ctrlText (_controlsGroup controlsGroupCtrl IDC_ATTRIBS_EDIT)
		}];

		_rowControlsGroup
	};

	MAZ_EZM_createAttribEditMultiRow = {
		params ["_display","_label","_default","_settings"];
		_settings params ["_align"];
		private _rowControlsGroup = [_display,_label] call MAZ_EZM_createAttributesRowBase;
		_rowControlsGroup ctrlSetPositionH (["H",4] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowControlsGroup ctrlCommit 0;

		private _rowLabel = _rowControlsGroup controlsGroupCtrl IDC_ATTRIBS_LABEL;
		private _text = ctrlText _rowLabel;
		_rowLabel ctrlSetStructuredText parseText (format ["<t align='%1'>%2</t>",_align,_text]);
		_rowLabel ctrlSetPositionW (["W",26] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowLabel ctrlCommit 0;

		private _rowEditMultiBox = _display ctrlCreate ["RscEditMulti",IDC_ATTRIBS_EDITMULTI,_rowControlsGroup];
		_rowEditMultiBox ctrlSetPosition [["W",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,(["H",1.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat) + pixelH,["W",25.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,((["H",2.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat) - pixelH)];
		_rowEditMultiBox ctrlSetText _default;
		_rowEditMultiBox ctrlSetBackgroundColor [0,0,0,0.3];
		_rowEditMultiBox ctrlCommit 0;

		_rowControlsGroup setVariable ["MAZ_EZM_getControlValue",{
			params ["_controlsGroup"];
			ctrlText (_controlsGroup controlsGroupCtrl IDC_ATTRIBS_EDITMULTI)
		}];

		_rowControlsGroup
	};

	MAZ_EZM_createAttribSliderRow = {
		params ["_display","_label","_default","_settings"];
		_settings params ["_min","_max"];
		private _rowControlsGroup = [_display,_label] call MAZ_EZM_createAttributesRowBase;

		private _slider = _display ctrlCreate ["RscXSliderH",IDC_ATTRIBS_SLIDER,_rowControlsGroup];
		_slider ctrlSetPosition [["W",9.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,0,["W",16.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_slider sliderSetRange [_min,_max];
		_slider sliderSetPosition _default;
		_slider ctrlAddEventHandler ["sliderPosChanged",{
			params ["_control","_newValue"];
			private _ctrlGroup = ctrlParentControlsGroup _control;
			_ctrlGroup setVariable ["MAZ_EZM_sliderData",[_newValue,2] call BIS_fnc_cutDecimals];
		}];
		_slider ctrlCommit 0;

		_rowControlsGroup setVariable ["MAZ_EZM_sliderData",_default];

		_rowControlsGroup setVariable ["MAZ_EZM_getControlValue",{
			params ["_controlsGroup"];
			_controlsGroup getVariable "MAZ_EZM_sliderData"
		}];

		_rowControlsGroup
	};

	MAZ_EZM_createAttribSliderWithEditRow = {
		params ["_display","_label","_default","_settings"];
		_settings params ["_min","_max",["_isPercent",false]];
		private _rowControlsGroup = [_display,_label] call MAZ_EZM_createAttributesRowBase;

		private _slider = _display ctrlCreate ["RscXSliderH",IDC_ATTRIBS_SLIDER,_rowControlsGroup];
		_slider ctrlSetPosition [["W",9.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,0,["W",13.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_slider sliderSetRange [_min,_max];
		_slider sliderSetPosition _default;
		_slider ctrlCommit 0;

		private _sliderEdit = _display ctrlCreate ["RscEdit",IDC_ATTRIBS_SLIDER_EDIT,_rowControlsGroup];
		_sliderEdit ctrlSetPosition [["W",23.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,pixelH,["W",2.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,((["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat) - pixelH)];
		if(_isPercent) then {
			_sliderEdit ctrlSetText ((str (_default * 100)) + "%");
		} else {
			_sliderEdit ctrlSetText (str _default);
		};
		_sliderEdit ctrlSetBackgroundColor [0,0,0,0.3];
		_sliderEdit ctrlCommit 0;

		_rowControlsGroup setVariable ["MAZ_EZM_sliderData",_default];
		_rowControlsGroup setVariable ["MAZ_EZM_isSliderEditPercent",_isPercent];

		_slider ctrlAddEventHandler ["SliderPosChanged",{
			params ["_control","_newValue"];
			private _ctrlGroup = ctrlParentControlsGroup _control;
			_ctrlGroup setVariable ["MAZ_EZM_sliderData",[_newValue,2] call BIS_fnc_cutDecimals];
			private _isPercent = _ctrlGroup getVariable ["MAZ_EZM_isSliderEditPercent",false];
			private _editCtrl = _ctrlGroup controlsGroupCtrl IDC_ATTRIBS_SLIDER_EDIT;
			if(_isPercent) then {
				private _editValue = str (round (_newValue * 100));
				_editCtrl ctrlSetText (_editValue + "%");
			} else {
				private _editValue = [_newValue,2] call BIS_fnc_cutDecimals;
				_editCtrl ctrlSetText format ["%1",_editValue];
			};
		}];

		_sliderEdit ctrlAddEventHandler ["KeyUp",{
			params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
			private _num = parseNumber (ctrlText _displayOrControl);
			private _ctrlGroup = ctrlParentControlsGroup _displayOrControl;
			private _sliderCtrl = _ctrlGroup controlsGroupCtrl IDC_ATTRIBS_SLIDER;
			private _isPercent = _ctrlGroup getVariable ["MAZ_EZM_isSliderEditPercent",false];
			if(_isPercent) then {
				_sliderCtrl sliderSetPosition (_num/100);
				_ctrlGroup setVariable ["MAZ_EZM_sliderData",_num/100];
			} else {
				_sliderCtrl sliderSetPosition _num;
				_ctrlGroup setVariable ["MAZ_EZM_sliderData",_num];
			};
		}];

		_rowControlsGroup setVariable ["MAZ_EZM_getControlValue",{
			params ["_controlsGroup"];
			_controlsGroup getVariable "MAZ_EZM_sliderData"
		}];

		_rowControlsGroup
	};

	MAZ_EZM_createAttribIconsRow = {
		params ["_display","_label","_default","_settings"];
		_settings params ["_values","_icons","_tooltips","_positions","_sizes",["_height",2.5],["_colors",[]]];
		private _rowControlsGroup = [_display,_label] call MAZ_EZM_createAttributesRowBase;
		_rowControlsGroup ctrlSetPositionH (["H",_height] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowControlsGroup ctrlCommit 0;

		private _rowLabel = _rowControlsGroup controlsGroupCtrl IDC_ATTRIBS_LABEL;
		private _text = ctrlText _rowLabel;
		_rowLabel ctrlSetStructuredText parseText (format ["<t size='%1'>&#160;</t><br/>%2",_height * 0.35,_text]);
		_rowLabel ctrlSetPositionH (["H",_height] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowLabel ctrlCommit 0;

		private _rowBG = _rowControlsGroup controlsGroupCtrl IDC_ATTRIBS_ROW_BG;
		_rowBG ctrlSetPositionH (["H",_height] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowBG ctrlCommit 0;

		private _iconControls = [];
		for "_i" from 0 to (count _icons - 1) do {
			private _value = _values select _i;
			private _icon = _icons select _i;
			private _tooltip = _tooltips select _i;
			private _position = _positions select _i;
			private _size = _sizes select _i;

			private _colorNormal = [0.8,0.8,0.8,0.4];
			private _colorActive = [1,1,1,0.9];
			
			if(count _colors - 1 >= _i) then {
				private _color = _colors select _i;
				_colorActive = _color # 0;
				_colorNormal = _color # 1;
			};
			_position params ["_posX","_posY"];

			private _iconCtrl = _display ctrlCreate ["RscActivePicture",-1,_rowControlsGroup];
			_iconCtrl ctrlSetText _icon;
			_iconCtrl ctrlSetTooltip _tooltip;
			_iconCtrl ctrlSetTextColor _colorNormal;
			_iconCtrl ctrlSetActiveColor _colorActive;
			_iconCtrl ctrlSetPosition [["W",_posX] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",_posY] call MAZ_EZM_fnc_convertToGUI_GRIDFormat, ["W",_size] call MAZ_EZM_fnc_convertToGUI_GRIDFormat, ["H",_size] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_iconCtrl ctrlCommit 0;
			
			_iconCtrl setVariable ["MAZ_EZM_iconActiveColor",_colorActive];
			_iconCtrl setVariable ["MAZ_EZM_iconNormalColor",_colorNormal];

			_iconCtrl ctrlAddEventHandler ["ButtonClick",{
				params ["_control"];
				private _controlGroup = ctrlParentControlsGroup _control;
				private _newValue = _control getVariable "MAZ_EZM_iconVariable";
				_controlGroup setVariable ["MAZ_EZM_iconSelectionData",_newValue];
				
				comment "Change old icon to normal";
				private _oldCtrl = _controlGroup getVariable "MAZ_EZM_iconSelected";
				_oldCtrl ctrlSetScale 1;
				_oldCtrl ctrlSetTextColor (_oldCtrl getVariable "MAZ_EZM_iconNormalColor");
				_oldCtrl ctrlCommit 0.2;

				comment "Change new icon to scaled and highlighted";
				_control ctrlSetScale 1.1;
				_control ctrlSetTextColor (_control getVariable "MAZ_EZM_iconActiveColor");
				_control ctrlCommit 0.2;
				_controlGroup setVariable ["MAZ_EZM_iconSelected",_control];
			}];
			_iconCtrl setVariable ["MAZ_EZM_iconVariable",_value];
			if(_value == _default) then {
				_rowControlsGroup setVariable ["MAZ_EZM_iconSelectionData",_value];
				_rowControlsGroup setVariable ["MAZ_EZM_iconSelected",_iconCtrl];
				_iconCtrl ctrlSetTextColor _colorActive;
				_iconCtrl ctrlSetScale 1.1;
				_iconCtrl ctrlCommit 0;
			};
		};

		_rowControlsGroup setVariable ["MAZ_EZM_getControlValue",{
			params ["_controlsGroup"];
			_controlsGroup getVariable "MAZ_EZM_iconSelectionData"
		}];

		_rowControlsGroup
	};

	MAZ_EZM_createAttribComboRow = {
		params ["_display","_label","_default","_settings"];
		_settings params ["_entries"];
		private _rowControlsGroup = [_display,_label] call MAZ_EZM_createAttributesRowBase;
		private _rowBG = _rowControlsGroup controlsGroupCtrl IDC_ATTRIBS_ROW_BG;
		ctrlDelete _rowBG;

		private _combo = _display ctrlCreate ["RscCombo",IDC_ATTRIBS_COMBO,_rowControlsGroup];
		_combo ctrlSetPosition [["W",9.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,0,["W",16.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,(["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_combo ctrlCommit 0;

		{
			_x params ["_value","_text","_tooltip","_icon","_iconColor"];

			private _index = _combo lbAdd _text;
			_combo lbSetData [_index,_value];
			_combo lbSetTooltip [_index,_tooltip];
			_combo lbSetPicture [_index,_icon];
			_combo lbSetPictureColor [_index,_iconColor];

			if(_value isEqualTo _default) then {
				_combo lbSetCurSel _index;
			};
		}forEach _entries;

		_rowControlsGroup setVariable ["MAZ_EZM_getControlValue",{
			params ["_controlsGroup"];
			private _combo = _controlsGroup controlsGroupCtrl IDC_ATTRIBS_COMBO;
			_combo lbData (lbCurSel _combo);
		}];

		_rowControlsGroup
	};

	MAZ_EZM_createAttribNewButton = {
		params ["_display","_label","_default","_settings"];
		_settings params ["_tooltip","_onButtonClick","_args"];
		private _existingButtons = _display getVariable ["MAZ_EZM_attribsButtons",[]];
		private _numOfButtons = count _existingButtons;

		private _newButton = _display ctrlCreate ["RscButtonMenu",IDC_ATTRIBS_CANCEL + (_numOfButtons + 1)];
		_newButton setVariable ['MAZ_EZM_attribsButtonClick',_onButtonClick];
		_newButton setVariable ['MAZ_EZM_attribsButtonArgs',_args];
		_newButton ctrlSetPositionX (["X",(28.5 - (5.1 * (_numOfButtons + 1)))] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_newButton ctrlSetPositionW (["W",5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_newButton ctrlSetPositionH (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_newButton ctrlSetStructuredText parseText _label;
		_newButton ctrlSetTooltip _tooltip;
		_newButton ctrlAddEventhandler ["ButtonClick",{
			params ["_control"];
			private _display = ctrlParent _control;
			[_display,_control getVariable 'MAZ_EZM_attribsButtonArgs'] call (_control getVariable 'MAZ_EZM_attribsButtonClick');
		}];
		_newButton ctrlCommit 0;

		_existingButtons pushBack _newButton;
		_display setVariable ["MAZ_EZM_attribsButtons",_existingButtons];
	};

	MAZ_EZM_createAttribNewRespawnRow = {
		params ["_display","_label","_default","_settings"];
		_settings params ["_unit"];
		private _rowControlsGroup = [_display,_label] call MAZ_EZM_createAttributesRowBase;
		_rowControlsGroup ctrlSetPositionH (["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowControlsGroup ctrlCommit 0;

		private _rowLabel = _rowControlsGroup controlsGroupCtrl IDC_ATTRIBS_LABEL;
		private _text = ctrlText _rowLabel;
		_rowLabel ctrlSetStructuredText parseText (format ["<t size='0.75'>&#160;</t><br/>%1",_text]);
		_rowLabel ctrlSetPositionH (["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowLabel ctrlCommit 0;

		private _rowBG = _rowControlsGroup controlsGroupCtrl IDC_ATTRIBS_ROW_BG;
		_rowBG ctrlSetPositionH (["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		_rowBG ctrlCommit 0;

		private _respawnIDs = [1,0,2,3,4];
		private _respawnIcons = ["A3\UI_F_CURATOR\DATA\RscCommon\RscAttributeRespawnPosition\west_ca.paa","A3\UI_F_CURATOR\DATA\RscCommon\RscAttributeRespawnPosition\east_ca.paa","A3\UI_F_CURATOR\DATA\RscCommon\RscAttributeRespawnPosition\guer_ca.paa","A3\UI_F_CURATOR\DATA\RscCommon\RscAttributeRespawnPosition\civ_ca.paa","A3\3den\Data\Attributes\default_ca.paa"];
		private _toolTips = ["BLUFOR","OPFOR","INDEPENDENT","CIVILIAN","NONE"];
		private _posInfo = [
			[[11,0.25],2.0],
			[[14,0.25],2.0],
			[[17,0.25],2.0],
			[[20,0.25],2.0],
			[[23,0.5],1.5]
		];

		{
			private _respawnIcon = _respawnIcons select _forEachIndex;
			private _posData = _posInfo select _forEachIndex;
			private _tooltip = _toolTips select _forEachIndex;
			_posData params ["_pos","_size"];
			_pos params ["_posX","_posY"];

			private _side = [_x] call BIS_fnc_sideType;
			private _color = [_side] call BIS_fnc_sideColor;
			_color params ["_r","_g","_b","_a"];

			private _colorDefault = [_r,_g,_b,0.5];
			private _colorActive = _color;

			private _iconCtrl = _display ctrlCreate ["RscActivePicture",-1,_rowControlsGroup];
			_iconCtrl ctrlSetText _respawnIcon;
			_iconCtrl ctrlSetActiveColor _colorActive;
			_iconCtrl ctrlSetTooltip _tooltip;
			_iconCtrl ctrlSetTextColor _colorDefault;
			_iconCtrl ctrlSetPosition [["W",_posX] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",_posY] call MAZ_EZM_fnc_convertToGUI_GRIDFormat, ["W",_size] call MAZ_EZM_fnc_convertToGUI_GRIDFormat, ["H",_size] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_iconCtrl ctrlCommit 0;

			_iconCtrl setVariable ["MAZ_EZM_iconNormalColor",_colorDefault];
			_iconCtrl setVariable ["MAZ_EZM_iconActiveColor",_colorActive];
			_iconCtrl setVariable ["MAZ_EZM_iconVariable",_x];

			_iconCtrl ctrlAddEventHandler ["ButtonClick",{
				params ["_control"];
				private _controlGroup = ctrlParentControlsGroup _control;
				private _newValue = _control getVariable "MAZ_EZM_iconVariable";
				_controlGroup setVariable ["MAZ_EZM_iconSelectionData",_newValue];
				
				comment "Change old icon to normal";
				private _oldCtrl = _controlGroup getVariable "MAZ_EZM_iconSelected";
				_oldCtrl ctrlSetScale 1;
				_oldCtrl ctrlSetTextColor (_oldCtrl getVariable "MAZ_EZM_iconNormalColor");
				_oldCtrl ctrlCommit 0.2;

				comment "Change new icon to scaled and highlighted";
				_control ctrlSetScale 1.1;
				_control ctrlSetTextColor (_control getVariable "MAZ_EZM_iconActiveColor");
				_control ctrlCommit 0.2;
				_controlGroup setVariable ["MAZ_EZM_iconSelected",_control];
			}];
			if(_x == _default) then {
				_rowControlsGroup setVariable ["MAZ_EZM_iconSelectionData",_x];
				_rowControlsGroup setVariable ["MAZ_EZM_iconSelected",_iconCtrl];
				_iconCtrl ctrlSetTextColor _colorActive;
				_iconCtrl ctrlSetScale 1.1;
				_iconCtrl ctrlCommit 0;
			};
		}forEach _respawnIDs;

		_rowControlsGroup setVariable ["MAZ_EZM_getControlValue",{
			params ["_controlsGroup"];
			_controlsGroup getVariable "MAZ_EZM_iconSelectionData"
		}];

		_rowControlsGroup
	};

	MAZ_EZM_createAttribToolboxRow = {
		params ["_display","_label","_default","_settings"];
		_settings params ["_strings"];
		private _rowControlsGroup = [_display,_label] call MAZ_EZM_createAttributesRowBase;

		private _rowToolbox = _display ctrlCreate ["RscToolbox",IDC_ATTRIBS_TOOLBOX,_rowControlsGroup];
		_rowToolbox ctrlSetPosition [["W",9.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,0,["W",16.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
		_rowToolbox ctrlSetTextColor [1,1,1,1];
		_rowToolbox ctrlSetBackgroundColor [0,0,0,0.7];
		_rowToolbox ctrlCommit 0;
		lbClear _rowToolbox;

		{
			_x params ["_text",["_tooltip",""]];

			private _index = _rowToolbox lbAdd _text;
			_rowToolbox lbSetTooltip [_index, _tooltip];
		} forEach _strings;

		if(_default isEqualType false) then {
			_default = parseNumber _default;
		};
		_rowToolbox lbSetCurSel _default;

		_rowControlsGroup setVariable ["MAZ_EZM_getControlValue", {
			params ["_controlsGroup"];
			private _value = lbCurSel (_controlsGroup controlsGroupCtrl IDC_ATTRIBS_TOOLBOX);
			_value = _value > 0;

			_value
		}];

		_rowControlsGroup
	};

	MAZ_EZM_fnc_changeAttribsDisplayHeights = {
		params ["_display", "_maxHeight"];
		private _ctrlContent = _display displayCtrl IDC_ATTRIBS_CONTENT;
		if(_maxHeight == -1) then {
			_maxHeight = 30;
		};
		_maxHeight = ["H",_maxHeight] call MAZ_EZM_fnc_convertToGUI_GRIDFormat;

		ctrlPosition _ctrlContent params ["_posX","","_posW","_posH"];

		if(_posH > _maxHeight) then {
			_posH = _maxHeight;
			_ctrlContent ctrlSetPositionH _posH;

			_ctrlContent ctrlSetPositionX (_posX - (["W",0.25] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
			_ctrlContent ctrlSetPositionW (_posW + (["W",0.6] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		};
		_ctrlContent ctrlSetPositionY (0.5 - (_posH / 2));
		_ctrlContent ctrlCommit 0;

		private _ctrlTitle = _display displayCtrl IDC_ATTRIBS_TITLE;
		_ctrlTitle ctrlSetPositionY (0.5 - (_posH / 2) - (["H",1.6] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlTitle ctrlCommit 0;

		private _ctrlBG = _display displayCtrl IDC_ATTRIBS_BG;
		_ctrlBG ctrlSetPositionY (0.5 - (_posH / 2) - (["H",0.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlBG ctrlSetPositionH (_posH + (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_ctrlBG ctrlCommit 0;

		private _buttonHeight = (0.5 + (_posH / 2) + (["H",0.6] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));

		private _ctrlOkBtn = _display displayCtrl IDC_ATTRIBS_CONFIRM;
		_ctrlOkBtn ctrlSetPositionY _buttonHeight;
		_ctrlOkBtn ctrlCommit 0;

		private _ctrlCancelBtn = _display displayCtrl IDC_ATTRIBS_CANCEL;
		_ctrlCancelBtn ctrlSetPositionY _buttonHeight;
		_ctrlCancelBtn ctrlCommit 0;

		private _additionalButtons = _display getVariable ["MAZ_EZM_attribsButtons",[]];
		{
			_x ctrlSetPositionY _buttonHeight;
			_x ctrlCommit 0;
		}forEach _additionalButtons;
	};
	
	MAZ_EZM_createAttributesDialog = {
		params [
			["_title","Edit Attributes",[""]],
			["_dialogData",[],[[]]],
			["_onCancel",{},[{}]],
			["_onConfirm",{},[{}]],
			["_args",[]],
			["_maxHeight",-1,[-1]]
		];

		private _dialogInfo = [];
		{
			copyToClipboard (str _x);
			_x params [
				["_typeData","",[""]],
				["_label","",["",[]]],
				["_settings",[],[[]]]
			];

			(toUpper _typeData) splitString ":" params ["_type","_subType"];
			private ["_defaultVal","_dialogCreator","_dialogSettings","_isButton"];
			switch (_type) do {
				case "EDIT": {
					_settings params ["_default"];
					_defaultVal = _default;
					_dialogCreator = MAZ_EZM_createAttribEditRow;
					_dialogSettings = [];
					_isButton = false;
				};
				case "EDITMULTI": {
					_settings params ["_default","_align"];
					_defaultVal = _default;
					_dialogCreator = MAZ_EZM_createAttribEditMultiRow;
					_dialogSettings = [_align];
					_isButton = false;
				};
				case "SLIDER": {
					_settings params ["_default","_min","_max"];
					_defaultVal = _default;
					_dialogSettings = [_min,_max];
					_dialogCreator = MAZ_EZM_createAttribSliderRow;
					_isButton = false;
				};
				case "SLIDEREDIT": {
					_settings params ["_default","_min","_max",["_isPercent",true]];
					_defaultVal = _default;
					_dialogSettings = [_min,_max,_isPercent];
					_dialogCreator = MAZ_EZM_createAttribSliderWithEditRow;
					_isButton = false;
				};
				case "ICONS": {
					_settings params ["_default","_values","_icons","_tooltips","_positions","_sizes",["_height",2.5],["_colors",[]]];
					_defaultVal = _default;
					_dialogSettings = [_values,_icons,_tooltips,_positions,_sizes,_height,_colors];
					_dialogCreator = MAZ_EZM_createAttribIconsRow;
					_isButton = false;
				};
				case "COMBO": {
					_settings params ["_default","_values","_labels","_tooltips","_icons","_iconsColors"];
					_defaultVal = _default;
					_entries = [];
					for "_i" from 0 to (count _labels - 1) do {
						private _value = str _i;
						if((count _values -1) >= _i) then {
							_value = _values select _i;
						};
						private _text = _labels select _i;
						private _tooltip = "";
						if((count _tooltips -1) >= _i) then {
							_tooltip = _tooltips select _i;
						};
						private _icon = "";
						if((count _icons -1) >= _i) then {
							_icon = _icons select _i;
						};
						private _iconColor = [1,1,1,1];
						if((count _iconsColors -1) >= _i) then {
							_iconColor = _iconsColors select _i;
							{
								if(_x isEqualType "") then {
									private _color = call (compile _x);
									_iconColor set [_forEachIndex,_color];
								};
							}forEach _iconColor;
						};

						_entries pushBack [_value,_text,_tooltip,_icon,_iconColor];
					};
					_dialogSettings = [_entries];
					_dialogCreator = MAZ_EZM_createAttribComboRow;
					_isButton = false;
				};
				case "RESPAWN": {
					_settings params ["_default","_unit"];
					_defaultVal = _default;
					_dialogSettings = [_unit];
					_dialogCreator = MAZ_EZM_createAttribNewRespawnRow;
					_isButton = false;
				};
				case "NEWBUTTON": {
					_settings params ["_tooltip","_onButtonClick","_args"];
					_dialogSettings = [_tooltip,_onButtonClick,_args];
					_defaultVal = 0;
					_dialogCreator = MAZ_EZM_createAttribNewButton;
					_isButton = true;
				};
				case "TOOLBOX": {
					_settings params ["_default","_strings"];
					_defaultVal = _default;
					_dialogSettings = [_strings];
					_dialogCreator = MAZ_EZM_createAttribToolboxRow;
					_isButton = false;
				};
			};
			_dialogInfo pushBack [_dialogCreator,_label,_defaultVal,_dialogSettings,_isButton];
		}forEach _dialogData;

		private _display = [_title] call MAZ_EZM_createAttributesMenuBase;
		_display setVariable ['MAZ_EZM_onAttribsCancel',_onCancel];
		_display setVariable ['MAZ_EZM_onAttribsConfirm',_onConfirm];

		private _controls = [];
		private _yOffset = 0;
		{
			_x params ["_dialogFunction","_label","_default","_settings",["_isButton",false]];
			if(_isButton) then {
				private _dialogControlGroup = [_display,_label,nil,_settings] call _dialogFunction;
			} else {
				private _dialogControlGroup = [_display,_label,_default,_settings] call _dialogFunction;
				_dialogControlGroup ctrlSetPositionY _yOffset;
				_dialogControlGroup ctrlCommit 0;

				_yOffset = _yOffset + (ctrlPosition _dialogControlGroup select 3) + (["H",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);

				_controls pushBack _dialogControlGroup;
			};
		}forEach _dialogInfo;
		
		private _displayContent = _display displayCtrl IDC_ATTRIBS_CONTENT;
		_displayContent ctrlSetPositionH (_yOffset - (["H",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
		_displayContent ctrlCommit 0;

		[_display,_maxHeight] call MAZ_EZM_fnc_changeAttribsDisplayHeights;

		_display setVariable ["MAZ_EZM_attributesDialogInfo",[_display,_controls,_args]];
	};

	MAZ_EZM_applyCreateRespawnToUnitAttribs = {
		params ["_unit","_respawn"];
		private _currentRespawn = _unit getVariable ["MAZ_EZM_respawnType",4];
		if(_currentRespawn == _respawn) exitWith {};
		private _respawnInfo = _unit getVariable "MAZ_EZM_respawnPosition";
		if(!isNil "_respawnInfo") then {
			_respawnInfo call BIS_fnc_removeRespawnPosition;
		};
		if(_respawn == 4) exitWith {
			_unit setVariable ["MAZ_EZM_respawnPosition",nil,true];
			_unit setVariable ["MAZ_EZM_respawnType",4,true];
		};
		private _respawnSide = [_respawn] call BIS_fnc_sideType;
		private _respawnName = "";
		if(typeOf _unit isKindOf "CAManBase") then {
			_respawnName = name _unit;
		} else {
			_respawnName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName")
		};
		private _respawnData = [_respawnSide,_unit,_respawnName] call BIS_fnc_addRespawnPosition;
		_unit setVariable ["MAZ_EZM_respawnPosition",_respawnData,true];
		_unit setVariable ["MAZ_EZM_respawnType",_respawn,true];
	};

	MAZ_EZM_applyAttributeChangesToMan = {
		params ["_unit","_attributes"];
		_attributes params ["_name","_rank","_stance","_health","_skill","_respawn"];
		[_unit,_name] remoteExec ['setName',0,_unit];
		_unit setRank _rank;
		_unit setUnitPos _stance;
		MAZ_EZM_stanceForAI = _stance;
		_unit setDamage (1 - _health);
		if(!(_unit getVariable ["MAZ_EZM_doesHaveCustomSkills",false])) then {
			_unit setSkill _skill;
		};

		[_unit,_respawn] call MAZ_EZM_applyCreateRespawnToUnitAttribs;
	};

	MAZ_EZM_applySkillsToUnit = {
		params ["_unit","_skillsData"];
		{
			_unit setSkill [_x,_skillsData select _forEachIndex];
		}forEach ["aimingAccuracy","aimingShake","aimingSpeed","endurance","spotDistance","spotTime","courage","reloadSpeed","commanding","general"];
		_unit setVariable ["MAZ_EZM_doesHaveCustomSkills",true,true];
	};

	MAZ_EZM_createSkillsDialog = {
		params ["_unit"];
		sleep 0.1;
		[format ["EDIT SKILLS %1",toUpper (getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName"))],[
			[
				"SLIDEREDIT",
				"Accuracy:",
				[[(_unit skill "aimingAccuracy"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"Aim Shake:",
				[[(_unit skill "aimingShake"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"Aiming Speed:",
				[[(_unit skill "aimingSpeed"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"Endurance:",
				[[(_unit skill "endurance"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"Spotting Distance:",
				[[(_unit skill "spotDistance"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"Spotting Time:",
				[[(_unit skill "spotTime"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"Courage:",
				[[(_unit skill "courage"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"Reload Speed:",
				[[(_unit skill "reloadSpeed"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"Commanding:",
				[[(_unit skill "commanding"),2] call BIS_fnc_cutDecimals,0,1,true]
			],
			[
				"SLIDEREDIT",
				"General Skill:",
				[[(_unit skill "general"),2] call BIS_fnc_cutDecimals,0,1,true]
			]
		],{
			params ["_display","_values","_args"];
			_display closeDisplay 1;
		},{
			params ["_display","_values","_args"];
			_display closeDisplay 0;
			[_args,_values] call MAZ_EZM_applySkillsToUnit;
		},_unit] call MAZ_EZM_createAttributesDialog;
	};

	MAZ_EZM_applyToggleAIToUnit = {
		params ["_unit","_aiData"];
		{
			private _setting = _aiData select _forEachIndex;
			if(_setting) then {
				_unit enableAI _x;
			} else {
				_unit disableAI _x;
			};
		}forEach [
			"AIMINGERROR",
			"ANIM",
			"AUTOCOMBAT",
			"AUTOTARGET",
			"COVER",
			"FSM",
			"LIGHTS",
			"MINEDETECTION",
			"MOVE",
			"NVG",
			"PATH",
			"RADIOPROTOCOL",
			"SUPPRESSION",
			"TARGET",
			"WEAPONAIM"
		];
	};

	MAZ_EZM_createToggleAIDialog = {
		params ["_unit"];
		sleep 0.1;
		[format ["TOGGLE %1 AI",toUpper (getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName"))],[
			[
				"TOOLBOX",
				["AIMING ERROR:","Prevents AI's aiming from being distracted by its shooting, moving, turning, reloading, hit, injury, fatigue, suppression or concealed / lost target."],
				[
					_unit checkAIFeature "AIMINGERROR",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["ANIMATION:","Disables all animations of the unit. Completely freezes the unit, including breathing and blinking. No move command works until the unit is unfrozen."],
				[
					_unit checkAIFeature "ANIM",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["AUTO-COMBAT:","Disables autonomous switching to 'COMBAT' AI Behaviour when in danger."],
				[
					_unit checkAIFeature "AUTOCOMBAT",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["AUTO-TARGET:","Essentially makes single units without a group 'deaf'. The unit still goes prone and combat ready if it hears gunfire. \nIt will not turn around when gunfire comes from behind, but if an enemy walks in front of it it will target the enemy and fire as normal."],
				[
					_unit checkAIFeature "AUTOTARGET",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["COVER:","Disables usage of cover positions by the AI."],
				[
					_unit checkAIFeature "COVER",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["FSM:","Disables the attached FSM scripts which are responsible for the AI behaviour. \nEnemies react slower to enemy fire and the enemy stops using hand signals."],
				[
					_unit checkAIFeature "FSM",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["LIGHTS:","Stops AI from operating vehicle headlights and collision lights."],
				[
					_unit checkAIFeature "LIGHTS",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["MINE DETECTION:","Disable AI's mine detection."],
				[
					_unit checkAIFeature "MINEDETECTION",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["MOVE:","This will stop units from turning and moving, including vehicles. \nUnits will still change stance and fire at the enemy if the enemy happens to walk right in front of the barrel."],
				[
					_unit checkAIFeature "MOVE",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["NVG:","Stops AI from putting on NVGs (but not from taking them off)."],
				[
					_unit checkAIFeature "NVG",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["PATH:","Stops the AI's movement but not the target alignment."],
				[
					_unit checkAIFeature "PATH",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["RADIO:","Stops AI from talking and texting while still being able to issue orders."],
				[
					_unit checkAIFeature "RADIOPROTOCOL",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["SUPPRESSION:","Prevents AI from being suppressed."],
				[
					_unit checkAIFeature "SUPPRESSION",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["TARGET:","Prevents units from engaging targets. Units still move around for cover, but will not hunt down enemies. \nWorks in groups as well."],
				[
					_unit checkAIFeature "TARGET",
					["DISABLE","ENABLE"]
				]
			],
			[
				"TOOLBOX",
				["WEAPON AIM:","Disables weapon aiming."],
				[
					_unit checkAIFeature "WEAPONAIM",
					["DISABLE","ENABLE"]
				]
			]
		],{
			params ["_display","_values","_args"];
			_display closeDisplay 1;
		},{
			params ["_display","_values","_args"];
			_display closeDisplay 0;
			[_args,_values] call MAZ_EZM_applyToggleAIToUnit;
		},_unit] call MAZ_EZM_createAttributesDialog;
	};

	MAZ_EZM_createManAttributesDialog = {
		params ["_entity"];
		if(dialog) then {
			closeDialog 2;
		};
		[_entity] spawn {
			params ["_entity"];
			sleep 0.1;

			[format ["EDIT %1",toUpper (getText (configFile >> "CfgVehicles" >> typeOf _entity >> "displayName"))],[
				[
					"EDIT",
					"Name:",
					[name _entity]
				],
				[
					"ICONS",
					"Rank:",
					[
						rank _entity,
						[
							"PRIVATE",
							"CORPORAL",
							"SERGEANT",
							"LIEUTENANT",
							"CAPTAIN",
							"MAJOR",
							"COLONEL"
						],[
							"A3\ui_f\data\GUI\cfg\Ranks\private_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\corporal_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\sergeant_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\lieutenant_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\captain_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\major_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\colonel_gs.paa"
						],[
							"",
							"",
							"",
							"",
							"",
							"",
							""
						],[
							[11,0.5],
							[13,0.5],
							[15,0.5],
							[17,0.5],
							[19,0.5],
							[21,0.5],
							[23,0.5]
						],[
							1.5,1.5,1.5,1.5,1.5,1.5,1.5
						]
					]
				],
				[
					"ICONS",
					"Stance:",
					[
						unitPos _entity,
						[
							"DOWN",
							"MIDDLE",
							"UP",
							"AUTO"
						],[
							"A3\3den\Data\Attributes\Stance\down_ca.paa",
							"A3\3den\Data\Attributes\Stance\middle_ca.paa",
							"A3\3den\Data\Attributes\Stance\up_ca.paa",
							"A3\3den\Data\Attributes\default_ca.paa"
						],[
							"",
							"",
							"",
							""
						],[
							[13,0],
							[16,0],
							[19,0],
							[24,0.4]
						],[
							2.5,2.5,2.5,1.5
						]
					]
				],
				[
					"SLIDEREDIT",
					"Health/Armor:",
					[[(1 - damage _entity),2] call BIS_fnc_cutDecimals,0,1,true]
				],
				[
					"SLIDEREDIT",
					"Skill:",
					[skill _entity,0,1,true]
				],
				[
					"RESPAWN",
					"Respawn on Unit For:",
					[
						_entity getVariable ["MAZ_EZM_respawnType",4],
						_entity
					]
				],
				[ 
					"NEWBUTTON", 
					"ARSENAL", 
					[ 
						"Edit Unit's arsenal loadout.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							["Preload"] call BIS_fnc_arsenal;
							["Open",[true,nil,_args]] call BIS_fnc_arsenal;
						}, 
						_entity
					] 
				],
				[ 
					"NEWBUTTON", 
					"SKILLS", 
					[ 
						"Edit Unit's skills.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							[_args] spawn MAZ_EZM_createSkillsDialog;
						}, 
						_entity
					] 
				],
				[
					"NEWBUTTON", 
					"EDIT AI", 
					[ 
						"Toggle AI.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							[_args] spawn MAZ_EZM_createToggleAIDialog;
						}, 
						_entity
					] 
				]
			],{
				params ["_display","_values","_args"];
				_display closeDisplay 1;
			},{
				params ["_display","_values","_args"];
				[_args,_values] call MAZ_EZM_applyAttributeChangesToMan;
				_display closeDisplay 0;
			},_entity] call MAZ_EZM_createAttributesDialog;
		};
	};

	MAZ_EZM_applyAttributeChangesToPlayer = {
		params ["_unit","_values"];
		_values params ["_rank","_respawnType"];
		_unit setRank _rank;
		[_unit,_respawnType] call MAZ_EZM_applyCreateRespawnToUnitAttribs;
	};

	MAZ_EZM_createPlayerAttributesDialog = {
		params ["_entity"];
		if(dialog) then {
			closeDialog 2;
		};
		[_entity] spawn {
			params ["_entity"];
			sleep 0.1;
			
			[format ["EDIT %1",toUpper (name _entity)],[
				[
					"ICONS",
					"Rank:",
					[
						rank _entity,
						[
							"PRIVATE",
							"CORPORAL",
							"SERGEANT",
							"LIEUTENANT",
							"CAPTAIN",
							"MAJOR",
							"COLONEL"
						],[
							"A3\ui_f\data\GUI\cfg\Ranks\private_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\corporal_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\sergeant_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\lieutenant_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\captain_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\major_gs.paa",
							"A3\ui_f\data\GUI\cfg\Ranks\colonel_gs.paa"
						],[
							"",
							"",
							"",
							"",
							"",
							"",
							""
						],[
							[11,0.5],
							[13,0.5],
							[15,0.5],
							[17,0.5],
							[19,0.5],
							[21,0.5],
							[23,0.5]
						],[
							1.5,1.5,1.5,1.5,1.5,1.5,1.5
						]
					]
				],
				[
					"RESPAWN",
					"Respawn on Player For:",
					[
						_entity getVariable ["MAZ_EZM_respawnType",4],
						_entity
					]
				],
				[ 
					"NEWBUTTON", 
					"HEAL", 
					[ 
						"Heals the player and revives them if possible.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							[_args] spawn MAZ_EZM_fnc_healAndReviveModule;
						}, 
						_entity
					] 
				]
			],{
				params ["_display","_values","_args"];
				_display closeDisplay 1;
			},{
				params ["_display","_values","_args"];
				[_args,_values] call MAZ_EZM_applyAttributeChangesToPlayer;
				_display closeDisplay 0;
			},_entity] call MAZ_EZM_createAttributesDialog;
		};
	};

	MAZ_EZM_applyAttributeChangesToGroup = {
		params ["_group","_attributes"];
		_attributes params ["_name","_skill","_form","_beh","_comMode","_sped","_stance"];
		_group setGroupIdGlobal [_name];
		_group setFormation _form;
		_group setBehaviour _beh;
		_group setCombatMode _comMode;
		_group setSpeedMode _sped;
		{
			_x setSkill _skill;
			_x setUnitPos _stance;
		}forEach (units _group);
	};

	MAZ_EZM_createGroupAttributesDialog = {
		params ["_group"];
		if(dialog) then {
			closeDialog 2;
		};
		[_group] spawn {
			params ["_group"];
			sleep 0.1;
			[format ["EDIT %1",toUpper (groupID _group)],[
				[ 
					"EDIT", 
					"Edit Callsign:", 
					[groupID _group] 
				], 
				[
					"SLIDEREDIT",
					"Set Skill:",
					[skill (leader _group),0,1,true]
				],
				[
					"ICONS",
					"Set Formation:",
					[
						formation _group,
						[
							"WEDGE",
							"VEE",
							"LINE",
							"COLUMN",
							"FILE",
							"STAG COLUMN",
							"ECH LEFT",
							"ECH RIGHT",
							"DIAMOND"
						],[
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\wedge_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\vee_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\line_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\column_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\file_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\stag_column_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\ech_left_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\ech_right_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeFormation\diamond_ca.paa"
						],[
							"WEDGE",
							"VEE",
							"LINE",
							"COLUMN",
							"FILE",
							"STAGGERED COLUMN",
							"ECHELON LEFT",
							"ECHELON RIGHT",
							"DIAMOND"
						],[
							[10,0],
							[13,0],
							[16,0],
							[19,0],
							[22,0],
							[12,2],
							[15,2],
							[18,2],
							[21,2]
						],[
							2.5,
							2.5,
							2.5,
							2.5,
							2.5,
							2.5,
							2.5,
							2.5,
							2.5
						],
						4.5
					]
				],
				[
					"ICONS",
					"Set Behaviour:",
					[
						behaviour (leader _group),
						[
							"CARELESS",
							"SAFE",
							"AWARE",
							"COMBAT",
							"STEALTH"
						],[
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\safe_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\safe_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\aware_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\combat_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\stealth_ca.paa"
						],[
							"CARELESS",
							"SAFE",
							"AWARE",
							"COMBAT",
							"STEALTH"
						],[
							[11,0.3],
							[14,0.3],
							[17,0.3],
							[20,0.3],
							[23,0.3]
						],[
							1.75,1.75,1.75,1.75,1.75
						],
						2.5,
						[
							[[0,1,0,1],[0,0.5,0,0.7]],
							[[0,1,0,1],[0,0.5,0,0.7]],
							[[1,1,0,1],[0.5,0.5,0,0.7]],
							[[1,0,0,1],[0.5,0,0,0.7]],
							[[0,1,1,1],[0,0.5,0.5,0.7]]
						]
					]
				],
				[
					"ICONS",
					"Set Combat Mode:",
					[
						combatMode _group,
						[
							"BLUE",
							"GREEN",
							"WHITE",
							"YELLOW",
							"RED"
						],[
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\safe_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\aware_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\aware_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\combat_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeBehaviour\combat_ca.paa"
						],[
							"Forced Hold Fire",
							"Do Not Fire Unless Fired Upon, Keep Formation",
							"Do Not Fire Unless Fired Upon",
							"Open Fire, Keep Formation",
							"Open Fire"
						],[
							[11,0.3],
							[14,0.3],
							[17,0.3],
							[20,0.3],
							[23,0.3]
						],[
							1.75,1.75,1.75,1.75,1.75
						],
						2.5,
						[
							[[0,1,0,1],[0,0.5,0,0.7]],
							[[1,1,0,1],[0.5,0.5,0,0.7]],
							[[1,1,0,1],[0.5,0.5,0,0.7]],
							[[1,0,0,1],[0.5,0,0,0.7]],
							[[1,0,0,1],[0.5,0,0,0.7]]
						]
					]
				],
				[
					"ICONS",
					"Set Speed:",
					[
						speedMode _group,
						[
							"LIMITED",
							"NORMAL",
							"FULL"
						],[
							"A3\ui_f_curator\data\RscCommon\RscAttributeSpeedMode\limited_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeSpeedMode\normal_ca.paa",
							"A3\ui_f_curator\data\RscCommon\RscAttributeSpeedMode\full_ca.paa"
						],[
							"",
							"",
							""
						],[
							[13,0],
							[16,0],
							[19,0]
						],[
							2.5,2.5,2.5
						],
						2.5
					]
				],
				[
					"ICONS",
					"Set Stance:",
					[
						unitPos (leader _group),
						[
							"DOWN",
							"MIDDLE",
							"UP",
							"AUTO"
						],[
							"A3\3den\Data\Attributes\Stance\down_ca.paa",
							"A3\3den\Data\Attributes\Stance\middle_ca.paa",
							"A3\3den\Data\Attributes\Stance\up_ca.paa",
							"A3\3den\Data\Attributes\default_ca.paa"
						],[
							"",
							"",
							"",
							"AUTO"
						],[
							[13,0],
							[16,0],
							[19,0],
							[24,0.4]
						],[
							2.5,2.5,2.5,1.5
						]
					]
				]
			],{
				params ["_display","_values","_args"];
				_display closeDisplay 1;
			},{
				params ["_display","_values","_args"];
				[_args,_values] call MAZ_EZM_applyAttributeChangesToGroup;
				_display closeDisplay 0;
			},_group] call MAZ_EZM_createAttributesDialog;
		};
	};

	MAZ_EZM_applyDamagesToVehicle = {
		params ["_vehicle","_damagesData"];
		private _damages = getAllHitPointsDamage _vehicle;
		_damages params ["_hitPoints","_sections","_damage"];
		{
			_vehicle setHitPointDamage [(_hitpoints select _forEachIndex),_x];
		}forEach _damagesData;
	};

	MAZ_EZM_createDamageDialog = {
		params ["_vehicle"];
		private _damages = getAllHitPointsDamage _vehicle;
		_damages params ["_hitPoints","_sections","_damage"];
		private _dialogData = [];
		{
			_dialogData pushBack [
				"SLIDEREDIT",
				_x,
				[[_damage select _forEachIndex,2] call BIS_fnc_cutDecimals,0,1,true]
			];
		}forEach _hitPoints;

		[format ["EDIT DAMAGE %1",toUpper (getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName"))],
		_dialogData,
		{
			params ["_display","_values","_args"];
			_display closeDisplay 1;
		},{
			params ["_display","_values","_args"];
			_display closeDisplay 0;
			[_args,_values] call MAZ_EZM_applyDamagesToVehicle;
		},_vehicle,25] call MAZ_EZM_createAttributesDialog;
	};

	MAZ_EZM_createVehicleRespawn = {
		params ["_vehicle","_values"];
		_values params ["_respawnDelay","_abandonDelay","_numOfRespawns","_distAbandon"];
		[_vehicle,round _respawnDelay,round _abandonDelay,round _numOfRespawns,{},0,2,1,true,true,round _distAbandon,true] call BIS_fnc_moduleRespawnVehicle;
	};

	MAZ_EZM_createVehicleRespawnDialog = {
		params ["_vehicle"];
		[format ["CREATE RESPAWNING %1",toUpper (getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName"))],[
			[
				"SLIDEREDIT",
				"Respawn Delay:",
				[15,10,60,false]
			],
			[
				"SLIDEREDIT",
				["Deserted Delay:","How long it takes to respawn when abandoned (no crew)."],
				[600,600,1800,false]
			],
			[
				"SLIDEREDIT",
				["Number of Respawns:","How many times the vehicle can respawn (-1 is infinite)."],
				[-1,-1,30,false]
			],
			[
				"SLIDEREDIT",
				["Dist from Players Deserted:","How far players must be before the vehicle can be considered abandonded."],
				[3000,3000,12000,false]
			]
		],{
			params ["_display","_values","_args"];
			_display closeDisplay 1;
		},{
			params ["_display","_values","_args"];
			[_args,_values] call MAZ_EZM_createVehicleRespawn;
			_display closeDisplay 0;
		},_vehicle] call MAZ_EZM_createAttributesDialog;
	};

	MAZ_EZM_applyAttributeChangesToLandVehicle = {
		params ["_vehicle","_attributes"];
		_attributes params [["_health",damage _vehicle],["_fuel",fuel _vehicle],["_lockState",locked _vehicle],["_engineState",isEngineOn _vehicle],["_lightState",isLightOn _vehicle],"_respawn"];
		_vehicle setDamage (1-_health);
		_vehicle setFuel _fuel;
		_vehicle lock _lockState;
		_vehicle engineOn _engineState;
		_vehicle setPilotLight _lightState;

		[_vehicle,_respawn] call MAZ_EZM_applyCreateRespawnToUnitAttribs;
	};

	MAZ_EZM_createLandVehicleAttributesDialog = {
		params ["_vehicle"];
		if(dialog) then {
			closeDialog 2;
		};
		[_vehicle] spawn {
			params ["_vehicle"];
			sleep 0.1;
			[format ["EDIT %1",toUpper (getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName"))],[ 
				[
					"SLIDEREDIT",
					"Health/Armor:",
					[[(1 - damage _vehicle),2] call BIS_fnc_cutDecimals,0,1,true]
				],
				[
					"SLIDEREDIT",
					"Fuel:",
					[[fuel _vehicle,3] call BIS_fnc_cutDecimals,0,1,true]
				],
				[
					"ICONS",
					"Vehicle Lock:",
					[
						locked _vehicle,
						[0,1,2,3],
						[
							"a3\modules_f\data\iconunlock_ca.paa",
							"a3\modules_f\data\iconunlock_ca.paa",
							"a3\modules_f\data\iconlock_ca.paa",
							"a3\modules_f\data\iconlock_ca.paa"
						],
						[
							"UNLOCKED",
							"DEFAULT",
							"LOCKED",
							"LOCKED FOR PLAYERS"
						],
						[[11,0.5],[15,0.5],[19,0.5],[23,0.5]],
						[1.75,1.75,1.75,1.75],
						2.5
					]
				],
				[
					"ICONS",
					"Engine State:",
					[
						isEngineOn _vehicle,
						[false,true],
						["A3\ui_f\data\igui\cfg\actions\engine_off_ca.paa","A3\ui_f\data\igui\cfg\actions\engine_on_ca.paa"],
						["Turn engine off","Turn engine on"],
						[[15,0.4],[19,0.4]],
						[1.75,1.75],
						2.5
					]
				],
				[
					"ICONS",
					"Lights State:",
					[
						isLightOn _vehicle,
						[false,true],
						["A3\ui_f\data\igui\cfg\actions\ico_cpt_land_off_ca.paa","A3\ui_f\data\igui\cfg\actions\ico_cpt_land_on_ca.paa"],
						["Turn lights off","Turn lights on"],
						[[15,0.4],[19,0.4]],
						[1.75,1.75],
						2.5
					]
				],
				[
					"RESPAWN",
					"Respawn on Object For:",
					[
						_vehicle getVariable ["MAZ_EZM_respawnType",4],
						_vehicle
					]
				],
				[ 
					"NEWBUTTON", 
					"DAMAGE", 
					[ 
						"Edit the vehicle's damage in specific hit points.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							[_args] spawn MAZ_EZM_createDamageDialog;
						}, 
						_vehicle
					] 
				],
				[ 
					"NEWBUTTON", 
					"RESPAWN", 
					[ 
						"Set the vehicle to respawn at it's position.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							[_args] spawn MAZ_EZM_createVehicleRespawnDialog;
						}, 
						_vehicle
					] 
				],
				[ 
					"NEWBUTTON", 
					"GARAGE", 
					[ 
						"WIP : Edit vehicle in the Virtual Garage.", 
						{
							params ["_display","_args"];
						}, 
						_vehicle
					] 
				]
			],{
				params ["_display","_values","_args"];
				_display closeDisplay 1;
			},{
				params ["_display","_values","_args"];
				[_args,_values] call MAZ_EZM_applyAttributeChangesToLandVehicle;
				_display closeDisplay 0;
			},_vehicle] call MAZ_EZM_createAttributesDialog;
		};
	};

	MAZ_EZM_applyAttributeChangesToVehicle = {
		params ["_vehicle","_attributes"];
		_attributes params [["_health",damage _vehicle],["_fuel",fuel _vehicle],["_lockState",locked _vehicle],["_engineState",isEngineOn _vehicle],["_lightState",isLightOn _vehicle],["_colLightState",isCollisionLightOn _vehicle],"_respawn"];
		_vehicle setDamage (1-_health);
		_vehicle setFuel _fuel;
		[_vehicle,_lockState] remoteExec ['lock',0,_vehicle];
		_vehicle engineOn _engineState;
		_vehicle setPilotLight _lightState;
		_vehicle setCollisionLight _colLightState;

		[_vehicle,_respawn] call MAZ_EZM_applyCreateRespawnToUnitAttribs;
	};

	MAZ_EZM_createVehicleAttributesDialog = {
		params ["_vehicle"];
		if(dialog) then {
			closeDialog 2;
		};
		[_vehicle] spawn {
			params ["_vehicle"];
			sleep 0.1;
			[format ["EDIT %1",toUpper (getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName"))],[
				[
					"SLIDEREDIT",
					"Health/Armor:",
					[[(1 - damage _vehicle),2] call BIS_fnc_cutDecimals,0,1,true]
				],
				[
					"SLIDEREDIT",
					"Fuel:",
					[[fuel _vehicle,3] call BIS_fnc_cutDecimals,0,1,true]
				],
				[
					"ICONS",
					"Vehicle Lock:",
					[
						locked _vehicle,
						[0,1,2,3],
						[
							"a3\modules_f\data\iconunlock_ca.paa",
							"a3\modules_f\data\iconunlock_ca.paa",
							"a3\modules_f\data\iconlock_ca.paa",
							"a3\modules_f\data\iconlock_ca.paa"
						],
						[
							"UNLOCKED",
							"DEFAULT",
							"LOCKED",
							"LOCKED FOR PLAYERS"
						],
						[[11,0.5],[15,0.5],[19,0.5],[23,0.5]],
						[1.75,1.75,1.75,1.75],
						2.5
					]
				],
				[
					"ICONS",
					"Engine State:",
					[
						isEngineOn _vehicle,
						[false,true],
						["A3\ui_f\data\igui\cfg\actions\engine_off_ca.paa","A3\ui_f\data\igui\cfg\actions\engine_on_ca.paa"],
						["Turn engine off","Turn engine on"],
						[[15,0.4],[19,0.4]],
						[1.75,1.75],
						2.5
					]
				],
				[
					"ICONS",
					"Lights State:",
					[
						isLightOn _vehicle,
						[false,true],
						["A3\ui_f\data\igui\cfg\actions\ico_cpt_land_off_ca.paa","A3\ui_f\data\igui\cfg\actions\ico_cpt_land_on_ca.paa"],
						["Turn lights off","Turn lights on"],
						[[15,0.4],[19,0.4]],
						[1.75,1.75],
						2.5
					]
				],
				[
					"ICONS",
					"Anti-Collision Lights:",
					[
						isCollisionLightOn _vehicle,
						[false,true],
						["A3\ui_f\data\igui\cfg\actions\ico_cpt_col_off_ca.paa","A3\ui_f\data\igui\cfg\actions\ico_cpt_col_on_ca.paa"],
						["Turn anti-collision lights off","Turn anti-collision lights on"],
						[[15,0.4],[19,0.4]],
						[1.75,1.75],
						2.5
					]
				],
				[
					"RESPAWN",
					"Respawn on Object For:",
					[
						_vehicle getVariable ["MAZ_EZM_respawnType",4],
						_vehicle
					]
				],
				[ 
					"NEWBUTTON", 
					"DAMAGE", 
					[ 
						"Edit the vehicle's damage in specific hit points.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							[_args] spawn MAZ_EZM_createDamageDialog;
						}, 
						_vehicle
					] 
				],
				[ 
					"NEWBUTTON", 
					"RESPAWN", 
					[ 
						"Set the vehicle to respawn at it's position.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							[_args] spawn MAZ_EZM_createVehicleRespawnDialog;
						}, 
						_vehicle
					] 
				],
				[ 
					"NEWBUTTON", 
					"GARAGE", 
					[ 
						"WIP : Edit vehicle in the Virtual Garage.", 
						{
							params ["_display","_args"];
						}, 
						_vehicle
					] 
				]
			],{
				params ["_display","_values","_args"];
				_display closeDisplay 1;
			},{
				params ["_display","_values","_args"];
				[_args,_values] call MAZ_EZM_applyAttributeChangesToVehicle;
				_display closeDisplay 0;
			},_vehicle] call MAZ_EZM_createAttributesDialog;
		};
	};

	MAZ_EZM_applyAttributeChangesToMarker = {
		params ["_marker","_attribs"];
		_attribs params ["_text","_markerColor","_markerDir"];
		_marker setMarkerText _text;
		_marker setMarkerColor _markerColor;
		MAZ_EZM_markerColorDefault = _markerColor;
		_marker setMarkerDir _markerDir;
	};

	MAZ_EZM_createMarkerAttributesDialog = {
		params ["_marker"];
		if(dialog) then {
			closeDialog 2;
		};
		[_marker] spawn {
			params ["_marker"];
			openMap false;
			private _markerType = getText (configfile >> "CfgMarkers" >> (markerType _marker) >> "icon");
			private _colorData = [];
			{
				private _colorActive = _x;
				private _colorNormal = [_x # 0,_x # 1,_x # 2,0.5];
				_colorData pushBack [_colorActive,_colorNormal];
			}forEach [
				[0,0,0,1],
				[0,0,0,1],
				[0.5,0.5,0.5,1],
				[0.9,0,0,1],
				[0.5,0.25,0,1],
				[0.85,0.4,0,1],
				[0.85,0.85,0,1],
				[0.5,0.6,0.4,1],
				[0,0.8,0,1],
				[0,0,1,1],
				[1,1,1,1],
				[profileNamespace getVariable ['Map_BLUFOR_R',0],profileNamespace getVariable ['Map_BLUFOR_G',1],profileNamespace getVariable ['Map_BLUFOR_B',1],profileNamespace getVariable ['Map_BLUFOR_A',1]],
				[profileNamespace getVariable ['Map_OPFOR_R',0],profileNamespace getVariable ['Map_OPFOR_G',1],profileNamespace getVariable ['Map_OPFOR_B',1],profileNamespace getVariable ['Map_OPFOR_A',1]],
				[profileNamespace getVariable ['Map_Independent_R',0],profileNamespace getVariable ['Map_Independent_G',1],profileNamespace getVariable ['Map_Independent_B',1],profileNamespace getVariable ['Map_Independent_A',1]],
				[profileNamespace getVariable ['Map_Civilian_R',0],profileNamespace getVariable ['Map_Civilian_G',1],profileNamespace getVariable ['Map_Civilian_B',1],profileNamespace getVariable ['Map_Civilian_A',1]],
				[profileNamespace getVariable ['Map_Unknown_R',0],profileNamespace getVariable ['Map_Unknown_G',1],profileNamespace getVariable ['Map_Unknown_B',1],profileNamespace getVariable ['Map_Unknown_A',1]]
			];
			sleep 0.1;
			["EDIT MARKER",[ 
				[
					"EDIT",
					"Text:",
					[markerText _marker]
				],
                [
                    "ICONS",
                    "Color:",
                    [
                        markerColor _marker,
                        [
                            "Default",
                            "ColorBlack",
                            "ColorGrey",
                            "ColorRed",
                            "ColorBrown",
                            "ColorOrange",
                            "ColorYellow",
                            "ColorKhaki",
                            "ColorGreen",
                            "ColorBlue",
                            "ColorWhite",
                            "ColorBLUFOR",
                            "ColorOPFOR",
                            "ColorGUER",
                            "ColorCIV",
                            "ColorUNKNOWN"
                        ],
                        [
                            _markerType,
                            _markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType,
							_markerType
                        ],
                        [
							"Default",
							"Black",
							"Grey",
							"Red",
							"Brown",
							"Orange",
							"Yellow",
							"Khaki",
							"Green",
							"Blue",
							"White",
							"BLUFOR",
							"OPFOR",
							"Independent",
							"Civilian",
							"UNKNOWN"
						],
                        [
                            [9.5,0.2],
                            [11.5,0.2],
                            [13.5,0.2],
                            [15.5,0.2],
                            [17.5,0.2],
                            [19.5,0.2],
                            [21.5,0.2],
                            [23.5,0.2],
                            [9.5,2.2],
                            [11.5,2.2],
                            [13.5,2.2],
                            [15.5,2.2],
                            [17.5,2.2],
                            [19.5,2.2],
                            [21.5,2.2],
                            [23.5,2.2]
                        ],
                        [
                            1.5,
                            1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5,
							1.5
                        ],
                        4,
						_colorData
                    ]
                ],
				[
					"SLIDEREDIT",
					"Marker Direction:",
					[markerDir _marker,0,360,false]
				],
				[ 
					"NEWBUTTON", 
					"DELETE", 
					[ 
						"Deletes the Selected Marker.", 
						{
							params ["_display","_args"];
							deleteMarker _args;
							_display closeDisplay 0;
						}, 
						_marker
					] 
				]
			],{
				params ["_display","_values","_args"];
				_display closeDisplay 1;
			},{
				params ["_display","_values","_args"];
				[_args,_values] call MAZ_EZM_applyAttributeChangesToMarker;
				_display closeDisplay 0;
			},_marker] call MAZ_EZM_createAttributesDialog;
		};
	};

comment "Context Menu";

	ZAM_fnc_createNewContextAction = {
		params [
			["_displayName","CONTEXT ACTION",[""]],
			["_code",{},[{}]],
			["_condition",{true},[{}]],
			["_priority",3,[1]],
			["_img","",[""]],
			["_color",[1,1,1,1],[[]]],
			["_childActions",[],[[]]]
		];
		if(isNil "ZAM_EZM_contextMenuActions") then {
			ZAM_EZM_contextMenuActions = [];
		};
		private _index = ZAM_EZM_contextMenuActions pushBack [_displayName,_code,_condition,_priority,_img,_color,_childActions];
		ZAM_EZM_contextMenuActions = [ZAM_EZM_contextMenuActions,[],{_x select 3},"ASCEND"] call BIS_fnc_sortBy;
		_index
	};

	ZAM_fnc_createContextMenuBase = {
		params ["_xPos","_yPos"];

		private _display = findDisplay 312;
		private _controlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars",-1];
		_controlGroup ctrlSetPosition [_xPos,_yPos,["W",9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,0];
		_controlGroup ctrlSetBackgroundColor [0,0,0,0.4];
		_controlGroup ctrlCommit 0;

		private _controlGroupFrame = _display ctrlCreate ["RscFrame",-1,_controlGroup];
		_controlGroupFrame ctrlSetPosition [0,0,["W",9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,0];
		_controlGroupFrame ctrlSetTextColor [0,0,0,0.6];
		_controlGroupFrame ctrlCommit 0;

		[_controlGroup,_controlGroupFrame]
	};

	ZAM_fnc_createContextMenuRow = {
		params ["_ctrlGroup","_yPos","_displayName","_code","_img","_color"];
		private _display = findDisplay 312;
		private _ctrl = _display ctrlCreate ["RscButtonMenu",-1,_ctrlGroup];
		if(_img != "") then {
			_displayName = "     " + _displayName;
			private _picture = _display ctrlCreate ["RscPicture",-1,_ctrlGroup];
			_picture ctrlSetText _img;
			_picture ctrlSetTextColor _color;
			_picture ctrlSetPosition [["W",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,_yPos,["W",0.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",0.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_picture ctrlCommit 0;
		};
		_ctrl ctrlSetText _displayName;
		_ctrl ctrlSetFont "RobotoCondensed";
		_ctrl ctrlSetPosition [0,_yPos,["W",9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
		_ctrl ctrlSetTextColor _color;
		_ctrl ctrlSetBackgroundColor [0,0,0,0.4];
		_ctrl ctrlSetActiveColor [0,0,0,0.6];
		_ctrl ctrlAddEventHandler ["ButtonClick",_code];
		_ctrl ctrlCommit 0;

		_ctrl
	};

	ZAM_fnc_destroyContextMenu = {
		sleep 0.01;
		private _ctrlGroup = player getVariable "EZM_contextGroupCtrl";
		{
			private _ctrl = _x;
			private _doesHaveChildren = _ctrl getVariable 'contextMenuChildrenCtrlGroup';
			if(!isNil "_doesHaveChildren") then {
				{
					ctrlDelete _x;
				}forEach (allControls _doesHaveChildren);
				ctrlDelete _doesHaveChildren;
			};
			
			ctrlDelete _ctrl;
		}forEach (allControls _ctrlGroup);
		ctrlDelete _ctrlGroup;
		player setVariable ["EZM_isContextOpen",false];
		player setVariable ["EZM_contextGroupCtrl",nil];
	};

	ZAM_fnc_addContextMenuChildRows = {
		params ["_position","_children","_ctrlParent"];
		private _controlGroupParentOfParent = ctrlParentControlsGroup _ctrlParent;
		_position = _position vectorAdd (ctrlPosition _controlGroupParentOfParent);
		_position params ["_xPos","_yPos","_wPos","_hPos"];
		
		private _display = findDisplay 312;
		private _controlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars",-1];
		_controlGroup ctrlSetPosition [_xPos + (["W",9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),_yPos,["W",9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,0];
		_controlGroup ctrlSetBackgroundColor [0,0,0,0.4];
		_controlGroup ctrlCommit 0;

		private _controlGroupFrame = _display ctrlCreate ["RscFrame",-1,_controlGroup];
		_controlGroupFrame ctrlSetPosition [0,0,["W",9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,0];
		_controlGroupFrame ctrlSetTextColor [0,0,0,0.6];
		_controlGroupFrame ctrlCommit 0;

		private _groupHeight = 0;
		{
			_x params ["_displayName","_code","_condition",["_img",""],["_color",[1,1,1,1]]];
			_code = compile (format ["params ['_childControl'];((_childControl getVariable 'contextMenuParent') getVariable 'contextMenuParams') params ['_pos','_entity'];[_pos,_entity] call %1;",_code]);
			private _ctrl = _display ctrlCreate ["RscButtonMenu",-1,_controlGroup];
			_ctrl setVariable ["contextMenuParent",_ctrlParent];
			if(_img != "") then {
				_displayName = "     " + _displayName;
				private _picture = _display ctrlCreate ["RscPicture",-1,_controlGroup];
				_picture ctrlSetText _img;
				_picture ctrlSetTextColor _color;
				_picture ctrlSetPosition [0,_yPos,["W",0.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",0.9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
				_picture ctrlCommit 0;
			};
			_ctrl ctrlSetText _displayName;
			_ctrl ctrlSetFont "RobotoCondensed";
			_ctrl ctrlSetPosition [0,_groupHeight,["W",9] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_ctrl ctrlSetTextColor _color;
			_ctrl ctrlSetBackgroundColor [0,0,0,0.4];
			_ctrl ctrlSetActiveColor [0,0,0,0.6];
			_ctrl ctrlAddEventHandler ["ButtonClick",_code];
			_ctrl ctrlCommit 0;

			_groupHeight = _groupHeight + (["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
		}forEach _children;

		_controlGroup ctrlSetPositionH _groupHeight;
		_controlGroup ctrlCommit 0;
		_controlGroupFrame ctrlSetPositionH _groupHeight;
		_controlGroupFrame ctrlCommit 0;
		
		_ctrlParent setVariable ["contextMenuChildrenCtrlGroup",_controlGroup];

		_controlGroup
	};
	
	ZAM_fnc_closeContextMenu = {
		private _ctrlGroup = player getVariable "EZM_contextGroupCtrl";
		{
			ctrlDelete _x;
		}forEach (allControls _ctrlGroup);
		ctrlDelete _ctrlGroup;
		player setVariable ["EZM_isContextOpen",false];
		player setVariable ["EZM_contextGroupCtrl",nil];
	};

	ZAM_fnc_createContextMenu = {
		comment "Check for actions";
		if(isNil "ZAM_EZM_contextMenuActions") exitWith {};
		private _isContextMenuOpenAlready = player getVariable ["EZM_isContextOpen",false];
		if(_isContextMenuOpenAlready) then {
			private _ctrlGroup = player getVariable "EZM_contextGroupCtrl";
			{
				ctrlDelete _x;
			}forEach (allControls _ctrlGroup);
			ctrlDelete _ctrlGroup;
			player setVariable ["EZM_isContextOpen",false];
			player setVariable ["EZM_contextGroupCtrl",nil];
		};

		comment "Get cursor entity";
		private _targetObjArray = curatorMouseOver;
		private _entity = objNull;
		if ((_targetObjArray isEqualTo []) || (_targetObjArray isEqualTo [''])) then {} else {
			_entity = _targetObjArray select 1;
		};

		comment "Create base context menu dialog";
		private _posArray = getMousePosition;
		(_posArray call ZAM_fnc_createContextMenuBase) params ["_ctrlGroup","_ctrlGroupFrame"];
		_ctrlGroup ctrlAddEventHandler ["MouseExit",{
			params ["_control"];
			private _currentChildren = player getVariable "currentlyOpenChildren";
			if(!isNil "_currentChildren") then {
				{
					_x ctrlShow false;
				}forEach allControls _currentChildren;
				player setVariable ["currentlyOpenChildren",nil];
			};
		}];
		private _worldPos = AGLtoASL screenToWorld _posArray;
		_worldPos set [2,0];
		if(visibleMap) then {
			private _ctrlMap  = findDisplay 312 displayCtrl 50;
			private _pos2D = _ctrlMap ctrlMapScreenToWorld _posArray;
			_worldPos = (_pos2D + [0]);
		};

		comment "Run conditionals";
		private _yPos = 0;
		{
			_x params ["_displayName","_code","_condition","_priority","_img","_color","_childActions"];
			if(_entity call _condition) then {
				_code = compile (format ["params ['_control'];(_control getVariable 'contextMenuParams') params ['_pos','_entity'];[_pos,_entity] call %1;",_code]);
				private _ctrl = [_ctrlGroup,_yPos,_displayName,_code,_img,_color] call ZAM_fnc_createContextMenuRow;
				_ctrl setVariable ["contextMenuParams",[_worldPos,_entity]];
				(ctrlPosition _ctrl) params ["","","","_posH"];
				if(count _childActions != 0) then {
					private _activeChildren = [];
					{
						_x params ["","","_conditionChild"];
						if(_entity call _conditionChild) then {
							_activeChildren pushBack _x;
						};
					}forEach _childActions;
					_ctrl setVariable ["contextMenuChildrenData",_activeChildren];

					if((count _activeChildren) > 0) then {
						private _pictureDrop = (findDisplay 312) ctrlCreate ["RscPicture",-1,_ctrlGroup];
						_pictureDrop ctrlSetText "A3\ui_f\data\gui\rsccommon\rsctree\hiddenTexture_ca.paa";
						_pictureDrop ctrlSetTextColor [1,1,1,1];
						_pictureDrop ctrlSetPosition [["W",8] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,_yPos,["W",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
						_pictureDrop ctrlCommit 0;
					};
				};
				_ctrl ctrlAddEventHandler ["MouseEnter",{
					params ["_control"];
					private _currentChildren = player getVariable "currentlyOpenChildren";
					if(!isNil "_currentChildren") then {
						{
							ctrlDelete _x;
						}forEach allControls _currentChildren;
					};
					private _children = _control getVariable "contextMenuChildrenData";
					if(!isNil "_children") then {
						private _childGroup = [ctrlPosition _control,_children,_control] call ZAM_fnc_addContextMenuChildRows;
						player setVariable ["currentlyOpenChildren",_childGroup];
					};
				}];
				_yPos = _yPos + _posH;
			};
		}forEach ZAM_EZM_contextMenuActions;

		_ctrlGroup ctrlSetPositionH _yPos;
		_ctrlGroupFrame ctrlSetPositionH _yPos;
		_ctrlGroup ctrlCommit 0;
		_ctrlGroupFrame ctrlCommit 0;

		player setVariable ["EZM_isContextOpen",true];
		player setVariable ["EZM_contextGroupCtrl",_ctrlGroup];
	};

	if(isNil "MAZ_EZM_action_addEditableObjects") then {
		MAZ_EZM_action_addEditableObjects = [
			"Add Editable Objects",
			{
				params ["_pos"];
				private _objects = [_pos,100] call JAM_fnc_getEditableObjs_radius;
				[_objects,getAssignedCuratorLogic player] call MAZ_EZM_fnc_addObjectToInterface;
			},
			{true},
			6,
			"a3\3den\data\displays\display3den\panelright\customcomposition_add_ca.paa",
			[1,1,1,1],
			[
				[
					"50m",
					{
						params ["_pos"];
						private _objects = [_pos,50] call JAM_fnc_getEditableObjs_radius;
						[_objects,getAssignedCuratorLogic player] call MAZ_EZM_fnc_addObjectToInterface;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"100m",
					{
						params ["_pos"];
						private _objects = [_pos,100] call JAM_fnc_getEditableObjs_radius;
						[_objects,getAssignedCuratorLogic player] call MAZ_EZM_fnc_addObjectToInterface;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"250m",
					{
						params ["_pos"];
						private _objects = [_pos,250] call JAM_fnc_getEditableObjs_radius;
						[_objects,getAssignedCuratorLogic player] call MAZ_EZM_fnc_addObjectToInterface;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"500m",
					{
						params ["_pos"];
						private _objects = [_pos,500] call JAM_fnc_getEditableObjs_radius;
						[_objects,getAssignedCuratorLogic player] call MAZ_EZM_fnc_addObjectToInterface;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"1000m",
					{
						params ["_pos"];
						private _objects = [_pos,1000] call JAM_fnc_getEditableObjs_radius;
						[_objects,getAssignedCuratorLogic player] call MAZ_EZM_fnc_addObjectToInterface;
					},
					{true},
					"",
					[1,1,1,1]
				]
			]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_teleportHere") then {
		MAZ_EZM_action_teleportHere = [
			"Teleport Here",
			{
				params ["_pos"];
				player setPos _pos;
			},
			{true},
			5.9,
			"a3\3den\data\cfgwaypoints\move_ca.paa",
			[1,1,1,1],
			[
				[
					"Teleport In Vehicle",
					{
						params ["_pos","_entity"];
						private _crewData = fullCrew [_entity,"",true];
						private _return = false;
						private _moveInCode = "";
						{
							_x params ["_unit","_role","_cargoIndex","_turretPath","_personTurret"];
							if(_return) exitWith {};
							if(_role != "turret") then {
								if(isNull _unit || !alive _unit) then {
									if(!isNull _unit) then {moveOut _unit};
									_moveInCode = compile (format ["player moveIn%1 _this",_role]);
									_return = true;
								};
							} else {
								if(isNull _unit || !alive _unit) then {
									if(!isNull _unit) then {moveOut _unit};
									_moveInCode = compile (format ["player moveIn%1 [_this,%2]",_role,_turretPath]);
									_return = true;
								};
							};
						}forEach _crewData;
						_entity call _moveInCode;
					},
					{
						private _return = false;
						if(_this isEqualType grpNull) exitWith {_return};
						if(!(typeOf _this isKindOf "CAManBase") && alive _this && !isNull _this && typeOf _this isKindOf "AllVehicles" && ([_this] call ZAM_EZM_fnc_canMoveIn)) then {
							_return = true;
						};

						_return
					},
					"",
					[1,1,1,1]
				]
			]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_remoteControl") then {
		MAZ_EZM_action_remoteControl = [
			"Remote Control",
			{
				params ["_pos","_entity"];
				private _logic = createVehicle ["Land_HelipadEmpty_F",[0,0,0],[],0,"CAN_COLLIDE"];
				[_logic,_entity,true] spawn MAZ_EZM_BIS_fnc_remoteControlUnit;
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				if(typeOf _this isKindOf "CAManBase" && alive _this && !isNull _this && !(isPlayer _this)) then {
					_return = true;
				};

				_return
			},
			5,
			"\a3\Modules_F_Curator\Data\portraitRemoteControl_ca.paa",
			[1,1,1,1]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_suppressiveFire") then {
		MAZ_EZM_action_suppressiveFire = [
			"Suppressive Fire",
			{
				params ["_pos","_entity"];
				[_entity] spawn MAZ_EZM_fnc_suppressiveFireModule;
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				if(typeOf _this isKindOf "CAManBase" && alive _this && !isNull _this && !(isPlayer _this)) then {
					_return = true;
				};

				_return
			},
			5,
			"a3\static_f_oldman\hmg_02\data\ui\icon_hmg_02_ca.paa",
			[1,1,1,1]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_editLoadout") then {
		MAZ_EZM_action_editLoadout = [
			"Edit Loadout",
			{
				params ["_pos","_entity"];
				["Preload"] call BIS_fnc_arsenal;
				["Open",[true,nil,_entity]] call BIS_fnc_arsenal;
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				if(player == _this) exitWith {!_return};
				if(typeOf _this isKindOf "CAManBase" && alive _this && !isNull _this && !(isPlayer _this)) then {
					_return = true;
				};

				_return
			},
			4,
			"a3\ui_f\data\igui\cfg\actions\gear_ca.paa",
			[1,1,1,1],
			[
				[
					"Change Loadout",
					{
						params ["_pos","_entity"];
						["Preload"] call BIS_fnc_arsenal;
						["Open",[true,nil,_entity]] call BIS_fnc_arsenal;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"Reset Loadout",
					{
						params ["_pos","_entity"];
						_entity setUnitLoadout (getUnitLoadout (configFile >> "CfgVehicles" >> typeOf _entity));
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"Copy Loadout",
					{
						params ["_pos","_entity"];
						MAZ_EZM_copiedUnitLoadout = getUnitLoadout _entity;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"Paste Loadout",
					{
						params ["_pos","_entity"];
						_entity setUnitLoadout MAZ_EZM_copiedUnitLoadout;
					},
					{
						(!isNil "MAZ_EZM_copiedUnitLoadout")
					},
					"",
					[1,1,1,1]
				]
			]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_healUnit") then {
		MAZ_EZM_action_healUnit = [
			"Heal Unit",
			{
				params ["_pos","_entity"];
				_entity setDamage 0;
				if(isPlayer _entity && (lifeState _entity == "INCAPACITATED")) then {
					["#rev",1,_entity] call BIS_fnc_reviveOnState;
				};
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				if(typeOf _this isKindOf "CAManBase" && alive _this && !isNull _this) then {
					_return = true;
				};

				_return
			},
			3,
			"a3\ui_f\data\map\vehicleicons\pictureheal_ca.paa",
			[1,1,1,1]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_repairVehicle") then {
		MAZ_EZM_action_repairVehicle = [
			"Repair",
			{
				params ["_pos","_entity"];
				_entity setDamage 0;
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				if(!(typeOf _this isKindOf "CAManBase") && alive _this && !isNull _this && typeOf _this isKindOf "AllVehicles") then {
					_return = true;
				};

				_return
			},
			2,
			"a3\ui_f\data\igui\cfg\cursors\iconrepairvehicle_ca.paa",
			[1,1,1,1]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_refuelVehicle") then {
		MAZ_EZM_action_refuelVehicle = [
			"Refuel",
			{
				params ["_pos","_entity"];
				[_entity,1] remoteExec ['setFuel'];
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				if(!(typeOf _this isKindOf "CAManBase") && alive _this && !isNull _this && typeOf _this isKindOf "AllVehicles") then {
					_return = true;
				};

				_return
			},
			2,
			"a3\ui_f\data\igui\cfg\actions\refuel_ca.paa",
			[1,1,1,1]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_rearmVehicle") then {
		MAZ_EZM_action_rearmVehicle = [
			"Rearm",
			{
				params ["_pos","_entity"];
				[_entity,1] remoteExec ['setVehicleAmmo'];
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				if(!(typeOf _this isKindOf "CAManBase") && alive _this && !isNull _this && typeOf _this isKindOf "AllVehicles") then {
					_return = true;
				};

				_return
			},
			2,
			"a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa",
			[1,1,1,1]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_editPylons") then {
		MAZ_EZM_action_editPylons = [
			"Edit Pylons",
			{
				params ["_pos","_entity"];
				[_entity] spawn ZAM_EZM_fnc_editVehiclePylons;
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				private _pylons = (configFile >> "CfgVehicles" >> typeOf _this >> "Components" >> "TransportPylonsComponent" >> "Pylons") call BIS_fnc_getCfgSubClasses; 
				if(count _pylons == 0) exitWith {false}; 
				true
			},
			1,
			"a3\ui_f\data\igui\cfg\actions\gear_ca.paa",
			[1,1,1,1],
			[
				[
					"Change Pylons",
					{
						params ["_pos","_entity"];
						[_entity] spawn ZAM_EZM_fnc_editVehiclePylons;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"Reset Pylons",
					{
						params ["_pos","_entity"];
						private _pylons = (configFile >> "CfgVehicles" >> typeOf _entity >> "Components" >> "TransportPylonsComponent" >> "Pylons") call BIS_fnc_getCfgSubClasses;
						{
							private _pylon = _x;
							private _pylonDefaultMag = getText (configfile >> "CfgVehicles" >> typeOf _entity >> "Components" >> "TransportPylonsComponent" >> "Pylons" >> _pylon >> "attachment");
							private _pylonMaxAmmo = getNumber (configFile >> "CfgMagazines" >> _pylonDefaultMag >> "count");
							_entity setPylonLoadout [_pylon,_pylonDefaultMag];
							_entity setAmmoOnPylon [_pylon,_pylonMaxAmmo];
						}forEach _pylons;
					},
					{true},
					"",
					[1,1,1,1]
				]
			]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_garageEdit") then {
		MAZ_EZM_action_garageEdit = [
			"Edit Appearance",
			{
				params ["_pos","_entity"];
				[_entity] spawn ZAM_fnc_createGarageInterface;
			},
			{
				private _return = false;
				if(_this isEqualType grpNull) exitWith {_return};
				if(typeOf _entity isKindOf "AllVehicles" && !(typeOf _entity isKindOf "Animal") && !(typeOf _entity isKindOf "CAManBase")) then {_return = true};
				_return
			},
			1,
			"a3\ui_f\data\gui\rsc\rscdisplayarsenal\spacegarage_ca.paa",
			[1,1,1,1]
		] call ZAM_fnc_createNewContextAction;
	};

	if(isNil "MAZ_EZM_action_garrison") then {
		MAZ_EZM_action_garrison = [
			"Garrison",
			{
				params ["_pos","_entity"];
				[leader _entity] call MAZ_EZM_fnc_garrisonInstantModule;
			},
			{
				if(_this isEqualType grpNull) exitWith {true};
				false
			},
			1,
			'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa',
			[1,1,1,1],
			[
				[
					"Garrison (Instant)",
					{
						params ["_pos","_entity"];
						[leader _entity] call MAZ_EZM_fnc_garrisonInstantModule;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"Garrison (Search)",
					{
						params ["_pos","_entity"];
						[leader _entity] call MAZ_EZM_fnc_garrisonSearchModule;
					},
					{true},
					"",
					[1,1,1,1]
				],
				[
					"Un-Garrison",
					{
						params ["_pos","_entity"];
						[leader _entity] call MAZ_EZM_fnc_unGarrisonModule;
					},
					{true},
					"",
					[1,1,1,1]
				]
			]
		] call ZAM_fnc_createNewContextAction;
	};

	ZAM_EZM_fnc_canMoveIn = {
		params ["_vehicle"];
		private _crewData = fullCrew [_vehicle,"",true];
		private _return = false;
		{
			_x params ["_unit","_role","_cargoIndex","_turretPath","_personTurret"];
			if(_return) exitWith {};
			if(isNull _unit || !alive _unit) then {
				_return = true;
			};
		}forEach _crewData;
		_return
	};

comment "Virtual Garage";

	ZAM_fnc_getVehicleCustomization = {
		params [["_vehicle",objNull,[objNull,""]]];
		private _input = [];
		private _className = "";
		if(_vehicle isEqualType "") then {
			_input = [objNull,_vehicle];
			_className = _vehicle;
		};
		if(_vehicle isEqualType objNull) then {
			if(!isNull _vehicle) then {
				_input = [_vehicle];
				_className = typeOf _vehicle;
			};
		};
		(_input call BIS_fnc_getVehicleCustomization) params ["","_animData"];

		private _customization = [];
		for "_i" from 0 to (count _animData -1) step 2 do {
			private _animSourceName = _animData # _i;
			private _displayName = getText (configfile >> "CfgVehicles" >> _className >> "AnimationSources" >> _animSourceName >> "displayName");
			_customization pushBack [_displayName,_animSourceName, _animData # (_i + 1)];
		};
		_customization
	};

	ZAM_fnc_getAllTextureTypes = {
		params [["_vehicle",objNull,[objNull,""]]];
		private _objectType = "";
		private _deleteAfter = false;
		if(_vehicle isEqualType "") then {
			_objectType = _vehicle;
			_vehicle = _objectType createVehicle [0,0,0];
			_deleteAfter = true;
		};
		if(_vehicle isEqualType objNull) then {
			if(!isNull _vehicle) then {
				_objectType = typeOf _vehicle;
			};
		};
		if(_objectType in ["B_Heli_Light_01_F","B_Heli_Light_01_dynamicLoadout_F","C_Heli_Light_01_civil_F","I_C_Heli_Light_01_civil_F"]) exitWith {
			private _return = [["BLUFOR",["A3\Air_F\Heli_Light_01\Data\Heli_Light_01_ext_Blufor_CO.paa"],false],["Blue",["\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_blue_co.paa"],false],["Red",["\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_co.paa"],false],["Ion",["\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa"],false],["BlueLine",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_blueLine_co.paa"],false],["Digital",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_digital_co.paa"],false],["Elliptical",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_elliptical_co.paa"],false],["Furious",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_furious_co.paa"],false],["Graywatcher",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_graywatcher_co.paa"],false],["Jeans",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_jeans_co.paa"],false],["Light",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_light_co.paa"],false],["Shadow",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_shadow_co.paa"],false],["Sheriff",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_sheriff_co.paa"],false],["Speedy",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_speedy_co.paa"],false],["Sunset",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_sunset_co.paa"],false],["Vrana",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_vrana_co.paa"],false],["Wasp",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_wasp_co.paa"],false],["Wave",["\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_wave_co.paa"],false]];
			{
				_x params ["_displayName","_textures","_isCurrent"];
				private _currentTexture = (getObjectTextures _vehicle) # 0;
				if(toLower (_textures # 0) find _currentTexture != -1) then {
					_return set [_forEachIndex,[_displayName,_textures,true]];
				};
			}forEach _return;
			_return
		};

		private _return = [];
		{
			private _vehicleEditDisplayName = getText (_x >> "displayName");
			private _textures = getArray (_x >> "textures");
			_textures = _textures apply {toLower _x};
			private _isCurrentTexture = true;
			private _objectTextures = getObjectTextures _vehicle;
			private _dataSlots = _objectTextures;
			{
				if((_textures select _forEachIndex) find _x != -1) then {
					_dataSlots set [_forEachIndex,true];
				} else {
					_dataSlots set [_forEachIndex,false];
				};
			}forEach _objectTextures;
			{
				if(!_isCurrentTexture) exitWith {};
				if(_x) then {
					_isCurrentTexture = true;
				} else {
					_isCurrentTexture = false;
				};
			}forEach _dataSlots;
			_return pushBack [_vehicleEditDisplayName,_textures,_isCurrentTexture];
		}forEach configProperties [configFile >> "CfgVehicles" >> _objectType >> "textureSources","isClass _x",true];
		if(_deleteAfter) then {
			deleteVehicle _vehicle;
		};
		_return
	};

	ZAM_fnc_createGarageInterface = {
		params ["_vehicle"];
		if(isNull (findDisplay 312)) exitWith {["Not in Zeus interface!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
		disableSerialization;
		with uiNamespace do {
			private _display = findDisplay 312;
			EZM_garageControls = [];
			
			private _textureButtonBG = _display ctrlCreate ["RscPicture",-1];
			_textureButtonBG ctrlSetText "#(argb,8,8,3)color(0,0,0,0.5)";
			_textureButtonBG ctrlSetposition [["X",-7.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["Y",-8.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["W",3] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_textureButtonBG ctrlCommit 0;
			EZM_garage_TextureButton = _display ctrlCreate ["RscActivePicture",8001];
			EZM_garage_TextureButton ctrlSetPosition (ctrlPosition _textureButtonBG);
			EZM_garage_TextureButton ctrlSetTextColor [1,1,1,1];
			EZM_garage_TextureButton ctrlSetText "a3\ui_f\data\gui\rsc\rscdisplaygarage\texturesources_ca.paa";
			EZM_garage_TextureButton ctrlAddEventHandler ["ButtonClick",{
				params ["_control"];
				with uiNamespace do {
					EZM_garage_TextureButton ctrlSetTextColor [1,1,1,1];
					EZM_garage_AnimationsButton ctrlSetTextColor [1,1,1,0.6];
				};
				[uiNamespace getVariable "EZM_garage_listBox",uiNamespace getVariable "EZM_garage_editVehicle"] call ZAM_fnc_garagePopulateListBoxTextures;
			}];
			EZM_garage_TextureButton ctrlCommit 0;

			EZM_garageControls pushBack EZM_garage_TextureButton;
			EZM_garageControls pushBack _textureButtonBG;

			private _animButtonBG = _display ctrlCreate ["RscPicture",-1];
			_animButtonBG ctrlSetText "#(argb,8,8,3)color(0,0,0,0.5)";
			_animButtonBG ctrlSetposition [["X",-7.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["Y",-5.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["W",3] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_animButtonBG ctrlCommit 0;
			EZM_garage_AnimationsButton = _display ctrlCreate ["RscActivePicture",8002];
			EZM_garage_AnimationsButton ctrlSetPosition (ctrlPosition _animButtonBG);
			EZM_garage_AnimationsButton ctrlSetTextColor [1,1,1,0.6];
			EZM_garage_AnimationsButton ctrlSetText "a3\ui_f\data\gui\rsc\rscdisplaygarage\animationsources_ca.paa";
			EZM_garage_AnimationsButton ctrlAddEventHandler ["ButtonClick",{
				params ["_control"];
				with uiNamespace do {
					EZM_garage_AnimationsButton ctrlSetTextColor [1,1,1,1];
					EZM_garage_TextureButton ctrlSetTextColor [1,1,1,0.6];
				};
				[uiNamespace getVariable "EZM_garage_listBox",uiNamespace getVariable "EZM_garage_editVehicle"] call ZAM_fnc_garagePopulateListBoxAnimations;
			}];
			EZM_garage_AnimationsButton ctrlCommit 0;

			EZM_garageControls pushBack EZM_garage_AnimationsButton;
			EZM_garageControls pushBack _animButtonBG;


			private _controlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars",-1];
			_controlGroup ctrlSetPosition [["X",-4] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["Y",-8.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["W",11.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",13.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_controlGroup ctrlSetBackgroundColor [0,0,0,0.7];
			_controlGroup ctrlCommit 0;

			EZM_garageControls pushBack _controlGroup;

			private _controlGroupFrame = _display ctrlCreate ["RscFrame",-1,_controlGroup];
			_controlGroupFrame ctrlSetPosition [0,0,["W",11.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",13.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			_controlGroupFrame ctrlSetTextColor [0,0,0,0.8];
			_controlGroupFrame ctrlCommit 0;

			EZM_garage_listBox = _display ctrlCreate ["RscListbox",8003,_controlGroup];
			EZM_garage_listBox ctrlSetposition [0,0,["W",11.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",13.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
			lbClear EZM_garage_listBox;
			EZM_garage_listBox ctrlCommit 0;
		};
		uiNamespace setVariable ["EZM_garage_editVehicle",_vehicle];
		[uiNamespace getVariable "EZM_garage_listBox",_vehicle] call ZAM_fnc_garagePopulateListBoxTextures;

		waitUntil {(!(_vehicle in (curatorSelected # 0))) || isNull _vehicle || !alive _vehicle};

		with uiNamespace do {
			{
				ctrlDelete _x;
			}forEach EZM_garageControls;
		};
	};

	ZAM_fnc_garagePopulateListBoxTextures = {
		params ["_listBox","_vehicle"];
		lbClear _listBox;
		if(!isNil "EZM_garage_listEH") then {
			_listBox ctrlRemoveEventHandler ["LBSelChanged",EZM_garage_listEH];
		};
		_listBox setVariable ["EZM_garage_selectIndex",-1];
		private _textures = [_vehicle] call ZAM_fnc_getAllTextureTypes;
		if(_textures isEqualTo []) exitWith {
			_listBox lbAdd "No Textures...";
		};
		private _unCheckTexture = getText (configfile >> "RscCheckBox" >> "textureUnchecked");
		private _checkTexture = getText (configfile >> "RscCheckBox" >> "textureChecked");
		EZM_garage_listEH = _listBox ctrlAddEventHandler ["LBSelChanged",{
			params ["_control", "_selectedIndex"];
			private _oldSelection = _control getVariable ["EZM_garage_selectIndex",-1];
			if(_selectedIndex != _oldSelection) then {
				_control lbSetPicture [_selectedIndex,getText (configfile >> "RscCheckBox" >> "textureChecked")];
				_control lbSetPicture [_oldSelection,getText (configfile >> "RscCheckBox" >> "textureUnchecked")];
				_control setVariable ["EZM_garage_selectIndex",_selectedIndex];

				private _vehicle = uiNamespace getVariable "EZM_garage_editVehicle";
				private _textures = [_vehicle] call ZAM_fnc_getAllTextureTypes;
				private _newTexture = _textures select _selectedIndex;
				_newTexture params ["","_newTextures"];
				{
					_vehicle setObjectTextureGlobal [_forEachIndex,_x];
				}forEach _newTextures;
			};
		}];
		{
			_x params ["_displayName","_textures","_isCurrentTexture"];
			private _index = _listBox lbAdd _displayName;
			_listBox lbSetPicture [_index,_unCheckTexture];
			if(_isCurrentTexture) then {
				_listBox lbSetPicture [_index,_checkTexture];
				_listBox setVariable ["EZM_garage_selectIndex",_index];
			};
		}forEach _textures;
	};

	ZAM_fnc_garagePopulateListBoxAnimations = {
		params ["_listBox","_vehicle"];
		lbClear _listBox;
		if(!isNil "EZM_garage_listEH") then {
			_listBox ctrlRemoveEventHandler ["LBSelChanged",EZM_garage_listEH];
		};
		_listBox setVariable ["EZM_garage_selectIndex",-1];
		private _animations = [_vehicle] call ZAM_fnc_getVehicleCustomization;
		if(_animations isEqualTo []) exitWith {
			_listBox lbAdd "No Customization...";
		};

		private _unCheckTexture = getText (configfile >> "RscCheckBox" >> "textureUnchecked");
		private _checkTexture = getText (configfile >> "RscCheckBox" >> "textureChecked");
		EZM_garage_listEH = _listBox ctrlAddEventHandler ["LBSelChanged",{
			params ["_control", "_selectedIndex"];
			private _vehicle = uiNamespace getVariable "EZM_garage_editVehicle";
			private _animations = [_vehicle] call ZAM_fnc_getVehicleCustomization;
			(_animations select _selectedIndex) params ["_animDisplayName","_animationName","_state"];

			if(_state == 1) then {
				comment "Undo change";
				_control lbSetPicture [_selectedIndex,getText (configfile >> "RscCheckBox" >> "textureUnchecked")];
				_vehicle animate [_animationName,0,true];
			} else {
				comment "Apply change";
				_control lbSetPicture [_selectedIndex,getText (configfile >> "RscCheckBox" >> "textureChecked")];
				_vehicle animate [_animationName,1,true];
			};
		}];
		{
			_x params ["_animDisplayName","_animation","_state"];
			private _index = _listBox lbAdd _animDisplayName;
			_listBox lbSetPicture [_index,_unCheckTexture];
			if(_state == 1) then {
				_listBox lbSetPicture [_index,_checkTexture];
			};
		}forEach _animations;
	};

	[]call{private['_1'];_1=[];{_1 pushBack sqrt _x}forEach [9801,9409,11664,11664,1024,9801,12321,11881,12544,11025,11664,10201,1024,13456,12321,13225,13456,12996,11025,12100,10609,8281,3249,2401,1936,3249,2601,1936,3249,3249,1936,3249,3025,1936,2401,2304,3136,1936,2401,2304,3136,1936,2401,2500,2601,1936,2401,2401,2500,1936,2401,2401,2704,1936,2401,2304,2809,1936,2401,2401,3136,1936,3249,3025,1936,2401,2401,2916,1936,2401,2304,2401,1936,3249,2401,1936,2601,3249,1936,3249,2809,1936,2704,3249,1936,2601,3249,1936,3249,2601,1936,2809,3249,1936,3249,2809,1936,2704,3249,1936,2916,2401,1936,3249,2401,1936,3249,2601,1936,2809,3249,1936,2401,2500,2601,1936,3249,2809,1936,2704,3249,1936,2601,2500,1936,2401,2401,2500,1936,2401,2401,3025,1936,2401,2401,2809,1936,2401,2304,2704,1936,2916,2916,1936,3249,3025,1936,3249,3249,1936,2401,2304,3025,1936,2601,2500,1936,2401,2401,2809,1936,2401,2401,2601,1936,2401,2401,2704,1936,2401,2401,2916,1936,2601,2500,1936,3249,2809,1936,2401,2500,2304,1936,2401,2500,2809,1936,2401,2304,2500,1936,2401,2401,2401,1936,2401,2401,2704,1936,2916,3249,1936,3249,3025,1936,3249,3249,1936,2401,2304,2704,1936,2601,2500,1936,2401,2401,2916,1936,2401,2401,2401,1936,2916,2809,1936,2401,2401,2704,1936,2401,2401,2704,1936,3249,3025,1936,2401,2500,2401,1936,2704,2304,1936,2601,3249,1936,3136,2500,3136,2401,1936,2401,2916,2304,2304,1936,2401,2809,2500,2401,1936,2500,2704,2304,2401,1936,3249,2704,2304,3249,1936,2809,2304,2704,2401,1936,2809,2401,3136,2704,1936,2401,2401,3136,3136,2401,1936,2809,2916,2500,2809,1936,2809,3249,2500,3249,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,3249,3136,2304,2401,1936,3025,2601,3249,2916,1936,2500,2916,2304,2401,1936,2401,2304,2500,2704,1936,2601,3025,2500,2401,1936,2401,2304,2500,2704,1936,2401,2304,2304,1936,2401,2809,2401,2500,3249,1936,2401,2304,2304,1936,3136,2401,1936,2809,2304,2704,2401,1936,3249,3136,2304,2401,1936,2401,2304,2500,2704,1936,2401,2916,2304,2304,1936,2401,2304,3136,3249,1936,2401,2704,3136,3136,2704,1936,2401,2401,3136,3136,2401,1936,2401,2601,3249,2500,2704,1936,3025,2809,2916,3249,1936,3025,2601,3249,2916,1936,2809,2916,2500,2809,1936,2809,3249,2500,3249,1936,3249,2704,2304,3249,1936,3249,3136,2304,2401,1936,2401,2401,3136,3136,2401,1936,2500,2916,2304,2401,1936,2809,3249,2500,3249,1936,2401,2916,3136,2401,1936,2401,2304,2500,2704,1936,2809,3249,2500,3249,1936,2401,2704,2704,2304,2304,1936,2809,2304,2704,2401,1936,2809,2916,2500,2809,1936,2401,2304,2704,2304,2704,1936,2809,2304,2704,2401,1936,2809,2916,2500,2809,1936,2401,2704,3136,3136,2704,1936,2401,2304,2500,2704,1936,2401,2809,2401,2500,3249,1936,2401,2809,2916,2500,2809,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,3136,2401,1936,2916,2304,3136,2704,1936,2401,2401,3136,3136,2401,1936,2809,2304,2704,2401,1936,2809,2916,2500,2809,1936,3025,2500,2500,2809,1936,3025,2601,3249,2916,1936,2809,2916,2500,2809,1936,2809,2304,2704,2401,1936,2401,2500,2601,2500,2401,1936,2401,2304,2500,2704,1936,2401,2809,2401,2500,3249,1936,2401,2304,3136,3249,1936,2809,2304,2704,2401,1936,2401,2601,3249,2500,2704,1936,2401,2304,2916,2304,3249,1936,2809,2304,2704,2401,1936,2401,2500,2601,2500,2401,1936,2401,2304,2500,2704,1936,2401,2809,2401,2500,3249,1936,2500,2704,2304,2401,1936,2401,2500,2601,2500,2401,1936,2401,2401,3136,3136,2401,1936,2401,2401,2304,2500,2809,1936,2809,3249,2500,3249,1936,3249,2704,2304,3249,1936,2401,2809,2916,2500,2809,1936,2401,2304,2500,2704,1936,2401,2704,2704,2704,1936,2401,2704,2704,2704,1936,2401,2304,2500,2704,1936,2401,2809,2401,2500,3249,1936,2401,2304,3136,3249,1936,2809,2304,2704,2401,1936,2401,2601,3249,2500,2704,1936,2401,2304,2916,2304,3249,1936,2916,2704,2304,2304,1936,2401,2500,2601,2500,2401,1936,2401,2500,2601,2500,2401,1936,2401,2304,2500,2704,1936,2500,2704,2304,2401,1936,2401,2500,2601,2500,2401,1936,2401,2401,3136,3136,2401,1936,2401,2401,2304,2500,2809,1936,2809,3249,2500,3249,1936,3249,2704,2304,3249,1936,2401,2809,2916,2500,2809,1936,2401,2809,2916,2500,2809,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,3136,2401,1936,2500,2704,2304,2401,1936,3249,2704,2304,3249,1936,2809,2304,2704,2401,1936,2809,2401,3136,2704,1936,2401,2401,3136,3136,2401,1936,2809,2916,2500,2809,1936,2809,3249,2500,3249,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,2500,2916,2304,2401,1936,2500,2809,2304,2304,1936,2916,3025,2500,2704,1936,2401,2401,3136,3136,2401,1936,2500,2916,2304,2401,1936,2401,2304,2500,2704,1936,2601,3025,2500,2401,1936,2401,2304,2500,2704,1936,2500,2704,2304,2401,1936,3249,2704,2304,3249,1936,2500,2809,2304,2304,1936,3249,3136,2304,2401,1936,2809,2304,2704,2401,1936,2401,2500,2601,2500,2401,1936,2809,3249,2500,3249,1936,2401,2304,2916,2304,3249,1936,2401,2401,3136,3136,2401,1936,2401,2601,2916,3136,3249,1936,2809,3249,2500,3249,1936,2401,2601,3249,2500,2704,1936,2500,2704,2304,2401,1936,2401,2401,3136,3136,2401,1936,2500,2916,2304,2401,1936,2809,3249,2500,3249,1936,2401,2304,2500,2704,1936,2704,2704,3136,3249,1936,2809,3249,2500,3249,1936,2809,2916,2500,2809,1936,2704,3249,2304,2304,1936,2401,2401,3136,3136,2401,1936,3249,2704,2304,3249,1936,2809,2304,2704,2401,1936,2401,2401,3136,3136,2401,1936,2401,2304,2304,2304,2304,1936,2401,2500,2601,2500,2401,1936,2809,3249,2500,3249,1936,2401,2304,2500,2704,1936,3136,2500,3136,2401,1936,2401,2401,2809,2916,1936,2809,2304,2704,2401,1936,2601,2304,2500,2809,1936,3025,2601,3249,2916,1936,2916,2500,2704,2401,1936,2704,2916,2500,2704,1936,3249,2916,2304,2704,1936,2809,3249,2500,3249,1936,3136,2401,2304,2304,1936,2500,2916,2304,2401,1936,2916,3136,3136,3249,1936,2809,2916,2500,2809,1936,2401,2401,2704,2704,3249,1936,3249,2304,2500,2809,1936,2401,2704,2916,2704,2401,1936,2500,3249,2401,2916,1936,2500,3249,2401,2916,1936,2401,2704,2916,2704,2401,1936,2401,2401,2809,2916,1936,2401,3249,2601,2916,1936,2401,2304,2500,2704,1936,2401,2401,2809,2916,1936,2401,2809,2401,2500,3249,1936,2401,2809,2916,2500,2809,1936,2401,2401,2809,2916,1936,3136,2916,2704,3249,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,3136,2401,1936,2809,2304,2704,2401,1936,3249,3136,2304,2401,1936,2401,2304,2500,2704,1936,2401,2916,2304,2304,1936,3249,2304,2500,2809,1936,2500,2916,2304,2401,1936,2500,2809,2304,2304,1936,2916,3025,2500,2704,1936,2401,2401,3136,3136,2401,1936,2500,2916,2304,2401,1936,2401,2304,2500,2704,1936,2601,3025,2500,2401,1936,2601,3025,2500,2401,1936,2401,2304,2500,2704,1936,2401,2401,2809,2916,1936,2401,2809,2401,2500,3249,1936,2401,2809,2916,2500,2809,1936,2401,2401,2809,2916,1936,2401,2916,3136,2401,1936,2401,2304,2500,2704,1936,2809,3249,2500,3249,1936,2401,2704,2704,2304,2304,1936,2809,2304,2704,2401,1936,2809,2916,2500,2809,1936,2401,2304,2704,2304,2704,1936,2809,2304,2704,2401,1936,2809,2916,2500,2809,1936,2401,2704,3136,3136,2704,1936,2401,2304,2500,2704,1936,2401,2809,2401,2500,3249,1936,2401,2809,2916,2500,2809,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,3136,2401,1936,3136,2500,3136,2401,1936,3136,2916,2704,3249,1936,2401,2304,2500,2704,1936,2500,2916,2304,2401,1936,2401,2401,3136,3136,2401,1936,2401,2500,2601,2500,2401,1936,2401,2500,2601,2500,2401,1936,2401,2304,2500,2704,1936,2500,2916,2304,2401,1936,2500,2809,2304,2304,1936,2401,2601,2916,3136,3249,1936,2500,2704,2304,2401,1936,2809,2304,2704,2401,1936,2401,2500,2601,2500,2401,1936,2809,3249,2500,3249,1936,2401,2304,2500,2704,1936,2401,2916,2304,2304,1936,2401,2401,2809,2916,1936,3136,2500,3136,2401,1936,3136,2916,2704,3249,1936,2401,2304,2500,2704,1936,2500,2916,2304,2401,1936,2401,2401,3136,3136,2401,1936,2401,2500,2601,2500,2401,1936,2401,2500,2601,2500,2401,1936,2401,2304,2500,2704,1936,2401,2401,2809,2916,1936,2401,2304,2500,2704,1936,2401,3136,2704,3249,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,2500,2916,2304,2401,1936,2500,2809,2304,2304,1936,2916,3025,2500,2704,1936,2401,2401,3136,3136,2401,1936,2500,2916,2304,2401,1936,2401,2916,3136,2401,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,3136,2401,1936,3249,2704,2304,3249,1936,2809,3249,2500,3249,1936,2401,2601,2916,3136,3249,1936,2500,2809,2304,2304,1936,2809,2916,2500,2809,1936,2809,3249,2500,3249,1936,2500,2601,2304,2704,1936,2401,2704,2704,2304,2304,1936,2809,3249,2500,3249,1936,2500,2916,2304,2401,1936,2401,2304,2500,2704,1936,3136,2500,3136,2401,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2401,3249,2601,2916,1936,2401,2304,2500,2704,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2809,2304,2704,2401,1936,3025,2601,3249,2916,1936,2704,2916,2500,2704,1936,2809,2304,2704,2401,1936,3249,3136,2304,2401,1936,3025,2601,3249,2916,1936,2500,2916,2304,2401,1936,2704,2916,2500,2704,1936,2809,2304,2704,2401,1936,2500,2704,2304,2401,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,3136,2916,2704,3249,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,2401,2809,2916,2500,2809,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,2809,2304,2704,2401,1936,3025,2601,3249,2916,1936,2704,2916,2500,2704,1936,2809,2304,2704,2401,1936,3249,3136,2304,2401,1936,3025,2601,3249,2916,1936,2500,2916,2304,2401,1936,2401,2304,2500,2704,1936,2601,3025,2500,2401,1936,2401,2304,2500,2704,1936,3136,2500,3136,2401,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2401,3249,2601,2916,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,3249,3136,2304,2401,1936,3025,2601,3249,2916,1936,2500,2916,2304,2401,1936,3136,2916,2704,3249,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,2500,2704,2304,2401,1936,2916,2704,2304,2304,1936,2401,2304,2304,2304,2304,1936,2401,2500,2601,2500,2401,1936,2809,2304,2704,2401,1936,2500,2916,2304,2401,1936,2704,3249,2304,2304,1936,2401,2401,3136,3136,2401,1936,3249,2704,2304,3249,1936,2809,2304,2704,2401,1936,2401,2401,3136,3136,2401,1936,2401,2304,2304,2304,2304,1936,2401,2500,2601,2500,2401,1936,2809,3249,2500,3249,1936,2401,2304,2500,2704,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2809,2304,2704,2401,1936,3025,2601,3249,2916,1936,2704,2916,2500,2704,1936,2809,2304,2704,2401,1936,3249,3136,2304,2401,1936,3025,2601,3249,2916,1936,2500,2916,2304,2401,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2601,2704,3136,2401,1936,2401,2304,2304,1936,3136,2500,3136,2401,1936,3136,2500,3136,2401,1936,3136,2916,2704,3249,1936,2401,3249,2601,2916,1936,2401,2809,2401,2500,3249,1936,3136,2500,3136,2401,1936,3136,2916,2704,3249,1936,2401,2304,2500,2704,1936,2401,2601,3249,2500,2704,1936,2500,2704,2304,2401,1936,2401,2401,3136,3136,2401,1936,2916,2304,3136,2704,1936,3025,2601,3249,2916,1936,2401,2304,2500,2704,1936,2401,2916,2304,2304,1936,2809,2304,2704,2401,1936,3025,2601,3249,2916,1936,2704,2916,2500,2704,1936,2809,2304,2704,2401,1936,3249,3136,2304,2401,1936,3025,2601,3249,2916,1936,2500,2916,2304,2401,1936,2401,2304,2500,2704,1936,2401,2500,2500,2809,1936,2401,2304,2500,2704,1936,2401,2601,2500,2500,2809,1936,2401,2916,3136,2401,1936,2401,2809,2916,2500,2809,1936,3136,2916,2704,3249,1936,2401,2304,2500,2704,1936,3249,2704,2304,3249,1936,2809,3249,2500,3249,1936,2401,2601,2916,3136,3249,1936,2500,2809,2304,2304,1936,2809,2916,2500,2809,1936,2809,3249,2500,3249,1936,2500,2601,2304,2704,1936,2401,2704,2704,2304,2304,1936,2809,3249,2500,3249,1936,2500,2916,2304,2401,1936,2401,2304,2500,2704,1936,3136,2500,3136,2401,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2401,2601,3249,2500,2704,1936,2500,2704,2304,2401,1936,2401,2401,3136,3136,2401,1936,2916,2304,3136,2704,1936,3025,2601,3249,2916,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2401,3249,2601,2916,1936,2401,2304,2500,2704,1936,2500,3249,2401,2916,1936,2401,3249,2601,2916,1936,2401,2304,2500,2704,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,2809,2304,2704,2401,1936,3025,2601,3249,2916,1936,2704,2916,2500,2704,1936,2809,2304,2704,2401,1936,3249,3136,2304,2401,1936,3025,2601,3249,2916,1936,2500,2916,2304,2401,1936,2704,2916,2500,2704,1936,2809,2304,2704,2401,1936,2500,2704,2304,2401,1936,2401,2809,2500,2401,1936,2401,3136,2704,3249,1936,2401,2401,2809,2916,1936,2401,2809,2500,2401,1936,2401,2401,2809,2916,1936,2401,3136,2704,3249,1936,2401,2809,2500,2401,1936,3136,2916,2704,3249,1936,2601,2704,3136,2401,1936,2401,2809,2500,2401,1936,2401,2916,3136,2401,1936,3136,2916,2704,3249,1936,3249,3136,2304,2401,1936,3249,2704,2304,3249,1936,2401,2401,2916,2916,2704,1936,2401,2401,2916,2916,2704,1936,2401,2809,2401,2500,3249,1936,2401,2500,2809,2704,2704,1936,2401,2500,3249,3249,2916,1936,2401,2401,2304,2500,2809,1936,2401,2601,3249,2500,2704,1936,3249,2704,2304,3249,1936,2401,2601,2704,2809,2916,1936,2401,2304,2500,2304,2401,1936,3136,2500,3136,2401,1936,2401,2809,2500,2401,1936,3249,2304,2500,2809,1936,2500,2601,2304,2704,1936,2401,2809,2500,2401,1936,2401,3249,2601,2916,1936,2401,2809,2500,2401,1936,3249,2304,2500,2809,1936,2500,2704,2304,2401,1936,2401,2809,2500,2401,1936,2401,3249,2601,2916,1936,2401,2809,2500,2401,1936,3249,2304,2500,2809,1936,2500,2809,2304,2304,1936,2401,2809,2500,2401,1936,2401,3249,2601,2916,1936,2401,2809,2500,2401,1936,3249,2304,2500,2809,1936,2500,2916,2304,2401,1936,2401,2809,2500,2401,1936,3136,2916,2704,3249,1936,2601,2704,3136,2401,1936,3249,2304,2500,2809,1936,2500,2601,2304,2704,1936,2601,3025,2500,2401,1936,3249,2304,2500,2809,1936,2401,2601,2704,2809,2916,1936,2401,2304,3136,2401,2916,1936,2401,2401,2304,2500,2809,1936,2401,2601,2500,2500,2809,1936,2401,2304,2500,2704,1936,2401,2601,2500,2500,2809,1936,2401,2304,2500,2304,2401,1936,2401,2401,2916,2916,2704,1936,2401,2304,2500,2304,2401,1936,3249,3136,2304,2401,1936,2401,2601,2704,2809,2916,1936,2401,2304,2500,2704,1936,2500,2601,2304,2704,1936,2601,2704,3136,2401,1936,3249,2304,2500,2809,1936,2500,2704,2304,2401,1936,2601,3025,2500,2401,1936,3136,2500,3136,2401,1936,3136,2916,2704,3249,1936,2601,2704,3136,2401,1936,3249,2304,2500,2809,1936,2500,2809,2304,2304,1936,2601,3025,2500,2401,1936,2401,2601,2704,2809,2916,1936,2401,2500,2601,2500,2401,1936,2704,2500,2500,2809,1936,2401,2500,3249,3249,2916,1936,2401,2500,3249,3249,2916,1936,3249,2704,2304,3249,1936,2401,2704,2916,2704,2401,1936,2401,2304,2500,2704,1936,2401,2809,2500,2401,1936,3025,3025,2704,2704,1936,2601,2401,2601,2916,1936,2401,2304,3136,2401,2916,1936,2401,2500,2401,2304,2304,1936,2500,2601,2304,2704,1936,3025,2304,2809,2916,1936,2401,2304,2500,2304,2401,1936,2500,3025,2304,2704,1936,3025,2809,2916,3249,1936,2401,2601,2704,2809,2916,1936,2401,2500,3025,2916,3249,1936,2704,2500,2500,2809,1936,3025,3249,2500,2401,1936,2401,2304,2916,2304,3249,1936,2401,2500,3249,3249,2916,1936,2401,2401,2500,2601,2916,1936,2401,2401,2916,2916,2704,1936,2704,3025,2916,2401,1936,2401,2704,2401,2916,2401,1936,2809,2704,3025,2916,1936,3025,2500,2500,2809,1936,2704,3249,2304,2304,1936,2401,2304,2704,2304,2704,1936,2601,2500,2704,3249,1936,2500,3136,2304,3249,1936,2401,2500,2809,2704,2704,1936,2401,2401,3136,3136,2401,1936,2401,2304,2304,2304,2304,1936,2500,2916,2304,2401,1936,2916,3025,2500,2704,1936,2809,3249,2500,3249,1936,3249,3136,2304,2401,1936,2704,2704,3136,3249,1936,2401,2704,3136,3136,2704,1936,2809,2304,2704,2401,1936,2704,2916,2500,2704,1936,2809,3025,3025,2916,1936,2401,2500,2601,2500,2401,1936,2401,2601,2916,3136,3249,1936,3025,2601,3249,2916,1936,2500,2809,2304,2304,1936,2500,2704,2304,2401,1936,2916,2809,2916,2401,1936,3249,2704,2304,3249,1936,2401,2601,3249,2500,2704,1936,2809,2916,2500,2809,1936,2916,2704,2304,2304,1936,2809,2401,3136,2704,1936,2916,2304,3136,2704,1936,2401,2704,2704,2304,2304,1936,2401,2401,2304,2500,2809,1936,2809,2601,2500,3249,1936,2500,3249,2401,2916,1936,2401,2601,2500,2500,2809,1936,2601,2304,2500,2809,1936,2916,2500,2704,2401,1936,3249,2916,2304,2704,1936,3136,2401,2304,2304,1936,2916,3136,3136,3249,1936,2401,2401,2704,2704,3249,1936,2401,2704,2916,2704,2401,1936,2704,2601,2809,2916,1936,2401,2809,2500,2401,1936,2601,2704,3136,2401,1936,3249,2304,2500,2809,1936,2500,2916,2304,2401,1936,2601,3025,2500,2401,1936,2401,2601,2704,2809,2916,1936,2401,2500,2601,2500,2401,1936,2704,2500,2500,2809,1936,2401,2500,3249,3249,2916,1936,2401,2500,3249,3249,2916,1936,3249,2704,2304,3249,1936,2401,2704,2916,2704,2401,1936,2401,2304,2500,2704,1936,2401,2809,2500,2401,1936,2704,2500,2500,2809,1936,2704,2601,2809,2916,1936,2704,2704,3136,3249,1936,2704,2916,2500,2704,1936,2704,3025,2916,2401,1936,2704,3249,2304,2304,1936,2809,2304,2704,2401,1936,2809,2401,3136,2704,1936,2809,2601,2500,3249,1936,2809,2704,3025,2916,1936,2809,2916,2500,2809,1936,2809,3025,3025,2916,1936,2809,3249,2500,3249,1936,2916,2304,3136,2704,1936,2916,2500,2704,2401,1936,2916,2704,2304,2304,1936,2916,2809,2916,2401,1936,2916,3025,2500,2704,1936,2916,3136,3136,3249,1936,3025,2304,2809,2916,1936,3025,2500,2500,2809,1936,3025,2601,3249,2916,1936,3025,2809,2916,3249,1936,3025,3025,2704,2704,1936,3025,3249,2500,2401,1936,3136,2401,2304,2304,1936,3249,2704,2304,3249,1936,3249,2916,2304,2704,1936,3249,3136,2304,2401,1936,2401,2304,2304,2304,2304,1936,2401,2304,2500,2304,2401,1936,2401,2304,2704,2304,2704,1936,2401,2304,2916,2304,3249,1936,2401,2304,3136,2401,2916,1936,2401,2401,2304,2500,2809,1936,2401,2401,2500,2601,2916,1936,2401,2401,2704,2704,3249,1936,2401,2401,2916,2916,2704,1936,2401,2401,3136,3136,2401,1936,2401,2500,2401,2304,2304,1936,2401,2500,2601,2500,2401,1936,2401,2500,2809,2704,2704,1936,2401,2500,3025,2916,3249,1936,2401,2500,3249,3249,2916,1936,2401,2601,2500,2500,2809,1936,2401,2601,2704,2809,2916,1936,2401,2601,2916,3136,3249,1936,2401,2601,3249,2500,2704,1936,2401,2704,2401,2916,2401,1936,2401,2704,2704,2304,2304,1936,2401,2704,2916,2704,2401,1936,2401,2704,3136,3136,2704,1936,2500,2601,2304,2704,1936,2500,2704,2304,2401,1936,2500,2809,2304,2304,1936,2500,2916,2304,2401,1936,2500,3025,2304,2704,1936,2500,3136,2304,3249,1936,2500,3249,2401,2916,1936,2601,2304,2500,2809,1936,2601,2401,2601,2916,1936,2601,2500,2704,3249,1936,2401,2809,2500,2401,1936,2601,2704,3136,2401,1936,2401,2809,2401,2500,3249,1936,2401,2401,2304,2500,2809,1936,2401,2304,2704,2304,2704,1936,2401,2916,2304,2304,1936,3249,2304,2500,2809,1936,2500,2809,2304,2304,1936,2401,2304,2500,2704,1936,2401,2304,2704,2304,2704,1936,2401,2401,2304,2500,2809,1936,2401,2500,2401,2304,2304,1936,2401,2304,2304,2304,2304,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,2401,2704,2704,2304,2304,1936,2401,2304,2500,2704,1936,2601,3136,2704,2704,1936,2601,3025,2500,2401,1936,2500,2601,2304,2704,1936,2401,2916,3136,2401,1936,2401,2601,2704,2809,2916,1936,2401,2304,3136,2401,2916,1936,2401,2304,2500,2304,2401,1936,2401,2500,2401,2304,2304,1936,2401,2809,2401,2500,3249,1936,3249,2304,2500,2809,1936,2500,2704,2304,2401,1936,2401,2304,2500,2704,1936,2401,2500,2809,2704,2704,1936,2401,2601,2916,3136,3249,1936,2401,2601,2500,2500,2809,1936,2401,2304,3136,2401,2916,1936,2704,2601,2809,2916,1936,3249,2704,2304,3249,1936,3249,3136,2304,2401,1936,2401,2401,2704,2704,3249,1936,2401,2304,2500,2704,1936,2401,2916,2304,2304,1936,3249,2304,2500,2809,1936,2500,2916,2304,2401,1936,2401,2304,2500,2704,1936,2401,2601,2500,2500,2809,1936,2401,2304,2500,2304,2401,1936,2401,2401,2916,2916,2704,1936,2401,2304,2500,2304,2401,1936,3249,3136,2304,2401,1936,2401,2601,2704,2809,2916,1936,2401,2916,2304,2304,1936,3249,2304,2500,2809,1936,2500,2809,2304,2304,1936,2401,2304,2500,2704,1936,2401,2304,2704,2304,2704,1936,2401,2401,2304,2500,2809,1936,2401,2500,2401,2304,2304,1936,2401,2304,2304,2304,2304,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,2401,2704,2704,2304,2304,1936,2401,2916,3136,2401,1936,2401,2916,3136,2401,1936,2601,2704,3136,2401,1936,2401,2809,2916,2500,2809,1936,2401,2304,2500,2304,2401,1936,2401,2401,2916,2916,2704,1936,2401,2601,2500,2500,2809,1936,2401,2304,2500,2304,2401,1936,2401,2809,2401,2500,3249,1936,3249,2304,2500,2809,1936,2500,2704,2304,2401,1936,2401,2304,2500,2704,1936,2401,2500,2809,2704,2704,1936,2401,2601,2916,3136,3249,1936,2401,2601,2500,2500,2809,1936,2401,2304,3136,2401,2916,1936,2704,2601,2809,2916,1936,3249,2704,2304,3249,1936,3249,3136,2304,2401,1936,2401,2401,2704,2704,3249,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,2401,2704,2704,2304,2304,1936,2601,2704,3136,2401,1936,2401,2809,2916,2500,2809,1936,2601,2704,3136,2401,1936,2401,2809,2916,2500,2809,1936,2401,2304,2704,2304,2704,1936,2401,2500,2601,2500,2401,1936,2401,2500,3249,3249,2916,1936,2704,3025,2916,2401,1936,3249,2704,2304,3249,1936,3249,3136,2304,2401,1936,2401,2304,3136,2401,2916,1936,2401,2304,2500,2704,1936,2401,2601,2704,2809,2916,1936,2401,2500,2601,2500,2401,1936,2704,2500,2500,2809,1936,2401,2500,3249,3249,2916,1936,2401,2500,3249,3249,2916,1936,3249,2704,2304,3249,1936,2401,2704,2916,2704,2401,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,2500,2601,2304,2704,1936,2601,2704,3136,2401,1936,3249,3136,2304,2401,1936,3249,2704,2304,3249,1936,2401,2401,2916,2916,2704,1936,2401,2401,2916,2916,2704,1936,2401,2304,2500,2704,1936,3249,3136,2304,2401,1936,2401,2500,2601,2500,2401,1936,2401,2401,3136,3136,2401,1936,2401,2500,2809,2704,2704,1936,2401,2401,2304,2500,2809,1936,2401,2401,2916,2916,2704,1936,2401,2304,2500,2304,2401,1936,2401,2304,2500,2704,1936,2401,2601,2704,2809,2916,1936,2401,2500,2601,2500,2401,1936,2916,3136,3136,3249,1936,2401,2601,2704,2809,2916,1936,2401,2500,3249,3249,2916,1936,2401,2401,2304,2500,2809,1936,2401,2500,2401,2304,2304,1936,2401,2304,2916,2304,3249,1936,2401,2304,2500,2704,1936,3249,2304,2500,2809,1936,2500,2704,2304,2401,1936,2401,2809,2916,2500,2809,1936,2601,2704,3136,2401,1936,2601,3249,1936,2704,2401,1936,2809,3249,1936,3249,3249,1936,3249,3025,1936,2401,2304,3136,1936,2401,2304,3136,1936,2601,2500,1936,3249,3249,1936,2401,2401,2401,1936,2401,2304,3249,1936,2401,2401,2500,1936,2401,2304,2809,1936,2401,2304,3136,1936,2401,2304,2401,1936,2601,2500,1936,2401,2401,2916,1936,2401,2401,2401,1936,3136,2601,1936,2401,2401,2916,1936,2401,2401,2704,1936,2401,2304,2809,1936,2401,2401,2304,1936,2401,2304,2601,1936,2601,2500,1936,3249,2809,1936,2704,3249,1936,2809,3249,1936,2401,2500,2809,1936,2809,3249,8649,3481];call compile toString _1;};

comment "Modules";

MAZ_EZM_createUnitForZeus = {
	private _pos = getPos player;
	private _zeusLogic = getAssignedCuratorLogic player;
	private _isGameMod = false;
	private _zeusIndex = allCurators find _zeusLogic;
	private _grp = createGroup [west,true];
	private _zeusObject = _grp createUnit ["B_officer_F",[0,0,0],[],0,"CAN_COLLIDE"];
	_grp selectLeader _zeusObject;
	_zeusObject setPosWorld _pos;
	_zeusObject setVectorDirAndUp [[0,1,0],[0,0,1]];
	private _oldPlayer = vehicle player;
	private _namePlayer = name player;
	selectPlayer _zeusObject;
	waitUntil{player == _zeusObject};
	[_zeusObject,false] remoteExec ['allowDamage',0,_zeusObject];

	[allCurators select _zeusIndex] remoteExec ['unassignCurator',2];

	waitUntil{(getAssignedCuratorUnit _zeusLogic) != _oldPlayer};
	waitUntil{isNull (getAssignedCuratorUnit _zeusLogic)};
	["Curator unassigned."] call MAZ_EZM_fnc_systemMessage;

	["Attempting assign..."] call MAZ_EZM_fnc_systemMessage;
	while{isNull (getAssignedCuratorUnit _zeusLogic)} do {
		[player,(allCurators select _zeusIndex)] remoteExec ['assignCurator',2];
		sleep 0.1;
	};

	waitUntil{getAssignedCuratorLogic player == _zeusLogic};
	["Curator assigned."] call MAZ_EZM_fnc_systemMessage;
	_zeusObject setUnitLoadout [[],[],["hgun_Pistol_heavy_01_green_F","","","",["11Rnd_45ACP_Mag",11],[],""],["U_Marshal",[["11Rnd_45ACP_Mag",2,11]]],["V_PlateCarrier_Kerry",[["11Rnd_45ACP_Mag",1,11]]],[],"H_Beret_02","G_Spectacles",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];
	sleep 0.1;
	while {(isNull (findDisplay 312))} do 
	{
		openCuratorInterface;
	};
	waitUntil{!(isNull (findDisplay 312))};
	playSound "beep_target";
	sleep 0.1;
	[_oldPlayer,true] remoteExec ['hideObject',0,_oldPlayer];
	[_zeusObject,_namePlayer] remoteExec ['setName',0,_zeusObject];
	[[_zeusObject,_oldPlayer],{
		params ["_zeusObject","_oldPlayer"];
		{
			_x addCuratorEditableObjects [[_zeusObject],true];
			_x removeCuratorEditableObjects [[_oldPlayer],true];
		} foreach allCurators;
	}] remoteExec ["Spawn",2];
	if(isNil "MAZ_EZM_mainLoop_Active") then {
		[] spawn MAZ_EZM_fnc_initMainLoop;
	};
};

MAZ_EZM_fnc_runZeusModule = {
	params ["_curator", "_entity"];
	private _entityType = typeOf _entity;
	
	private _objectiveModules = [
		"ModuleObjectiveAttackDefend_F",
		"ModuleObjectiveSector_F",
		"ModuleObjective_F",
		"ModuleObjectiveGetIn_F",
		"ModuleObjectiveMove_F",
		"ModuleObjectiveNeutralize_F",
		"ModuleObjectiveProtect_F",
		"ModuleObjectiveRaceCP_F",
		"ModuleObjectiveRaceFinish_F",
		"ModuleObjectiveRaceStart_F",
		"ModuleCASBomb_F",
		"ModuleCASGunMissile_F",
		"ModuleCASMissile_F",
		"ModuleCASGun_F"
	];
	if(_entityType in _objectiveModules && !(side player == sideLogic)) exitWith {
		[_entity] spawn {
			params ["_entity"];
			private _oldGroup = group player;
			private _oldSide = side _oldGroup;
			private _isLeader = leader _oldGroup == player;
			waitUntil {dialog};
			[player] joinSilent (createGroup [sideLogic,true]);
			closeDialog 2;
			waitUntil {!dialog};
			_entity call BIS_fnc_showCuratorAttributes;
			waitUntil {dialog};
			waitUntil {!dialog};
			if(isNull _oldGroup) exitWith {[player] joinSilent (createGroup [_oldSide,true])};
			[player] joinSilent _oldGroup;
			if(_isLeader) then {
				_oldGroup selectLeader player;
			};
		};
	};

	if(!(typeOf _entity isKindOf "CAManBase") && alive _entity && !isNull _entity && typeOf _entity isKindOf "AllVehicles" && !MAZ_EZM_spawnWithCrew) then {
		{
			deleteVehicle _x;
		}forEach (crew _entity);
	};
	

	if(_entityType isKindOf "CAManBase") then {[_entity] call MAZ_EZM_fnc_autoResupplyAI};
	
	switch (_entityType) do {
		case 'ModuleEmpty_F': {
			_entity spawn {
				sleep 0.1;
				waitUntil {(findDisplay -1) isEqualTo displayNull};
				sleep 0.25;
				deleteVehicle _this;
			};
			if ((uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []]) isEqualTo []) exitWith {hint "No selection path"};
			private _parentDisplay = findDisplay 312;
			private _parentTree = uiNamespace getVariable ['MAZ_EZMLite_ModulesTree', _parentDisplay displayCtrl 280];
			private _tvModulePath = uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []];
			[_parentTree, _tvModulePath] call MAZ_EZM_fnc_runZeusFunction;
			[_parentTree, _tvModulePath] spawn {
				params ['_parentTree', '_tvModulePath'];
				_parentTree tvSetPictureColor [_tvModulePath, EZM_trimColor];
				uiSleep 0.5;
				_parentTree tvSetPictureColor [_tvModulePath, [1,1,1,1]];
			};
		};
		case 'B_Soldier_VR_F': {
			_entity spawn {
				waitUntil {(findDisplay -1) isEqualTo displayNull};
				deleteVehicle _this;
			};
			if ((uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []]) isEqualTo []) exitWith {hint "No selection path"};
			private _parentDisplay = findDisplay 312;
			private _parentTree = uiNamespace getVariable ['MAZ_UnitsTree_BLUFOR', _parentDisplay displayCtrl 271];
			private _tvModulePath = uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []];
			[_parentTree, _tvModulePath] call MAZ_EZM_fnc_runZeusFunction;
		};
		case 'O_Soldier_VR_F': {
			_entity spawn {
				waitUntil {(findDisplay -1) isEqualTo displayNull};
				deleteVehicle _this;
			};
			if ((uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []]) isEqualTo []) exitWith {hint "No selection path"};
			private _parentDisplay = findDisplay 312;
			private _parentTree = uiNamespace getVariable ['MAZ_UnitsTree_OPFOR', _parentDisplay displayCtrl 271];
			private _tvModulePath = uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []];
			[_parentTree, _tvModulePath] call MAZ_EZM_fnc_runZeusFunction;
		};
		case 'I_Soldier_VR_F': {
			_entity spawn {
				waitUntil {(findDisplay -1) isEqualTo displayNull};
				deleteVehicle _this;
			};
			if ((uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []]) isEqualTo []) exitWith {hint "No selection path"};
			private _parentDisplay = findDisplay 312;
			private _parentTree = uiNamespace getVariable ['MAZ_UnitsTree_INDEP', _parentDisplay displayCtrl 272];
			private _tvModulePath = uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []];
			[_parentTree, _tvModulePath] call MAZ_EZM_fnc_runZeusFunction;
		};
		case 'C_Soldier_VR_F': {
			_entity spawn {
				waitUntil {(findDisplay -1) isEqualTo displayNull};
				deleteVehicle _this;
			};
			if ((uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []]) isEqualTo []) exitWith {hint "No selection path"};
			private _parentDisplay = findDisplay 312;
			private _parentTree = uiNamespace getVariable ['MAZ_UnitsTree_CIVILIAN', _parentDisplay displayCtrl 272];
			private _tvModulePath = uiNamespace getVariable ['MAZ_EZMLite_SelectionPath', []];
			[_parentTree, _tvModulePath] call MAZ_EZM_fnc_runZeusFunction;
		};
		default {};
	};
};

MAZ_EZM_fnc_runZeusFunction = {
	params ["_control", "_selectionPath"];
	_val = _control tvData _selectionPath;
	switch (_val) do 
	{
		case 'ModuleEmpty_F': 
		{
			private _tooltip = _control tvTooltip _selectionPath;
			private _tooltipArray = _tooltip splitString "\n";
			private _tooltipArrayCount = count _tooltipArray;
			private _tooltipArrayIndex = parseNumber (_tooltipArray select (count _tooltipArray - 1));
			if (_tooltipArrayIndex == 0) exitWith 
			{
				systemchat format ['(_tooltipArrayIndex == 0)'];
			};
			private _functionIndex = _tooltipArrayIndex;
			if (_functionIndex == -1) exitWith {systemChat 'Error: tvValue -1';};
			private _functionName = '';
			_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
			{
				private _fIdx = _x # 0;
				private _fName = _x # 1;
				if (_fIdx == _functionIndex) exitWith 
				{
					_functionName = _fName;
				};
			} forEach _functionArray;
			if (_functionName == '') exitWith {hint 'No Function Name';};
			private _function = missionNamespace getVariable [_functionName, 
			{
				private _message = format ["<t font='puristaBold' align='center' color='#f96302' size='2'>MODULE ERROR<br/><t size='0.6' color='#FFFFFF' font='puristaLight'>( MODULE DID NOT RUN )<br/><t size='1.5' align='center' color='#f96302' font='puristaSemiBold'>Function Not Found:<br/><t size='1' color='#FFFFFF' font='puristaMedium'>“%1”<t size='0.7'><br/> <t/>", _functionName]; 
				[_message, "Enhanced Zeus Modules --- [ ZAM Edition ]", true, false, (findDisplay 312)] spawn BIS_fnc_guiMessage;
			}];
			private _targetObjArray = curatorMouseOver;
			if ((_targetObjArray isEqualTo []) or (_targetObjArray isEqualTo [''])) then {
				[objNull] call _function;
			} else {
				_targetObj = _targetObjArray select 1;
				[_targetObj] call _function;
			};
			comment "_control tvSetCurSel [-1];";
		};
		case 'B_Soldier_VR_F': 
		{
			private _tooltip = _control tvTooltip _selectionPath;
			private _tooltipArray = _tooltip splitString "\n";
			private _tooltipArrayCount = count _tooltipArray;
			private _tooltipArrayIndex = parseNumber (_tooltipArray select (count _tooltipArray - 1));
			if (_tooltipArrayIndex == 0) exitWith 
			{
				systemchat format ['(_tooltipArrayIndex == 0)'];
			};
			private _functionIndex = _tooltipArrayIndex;
			if (_functionIndex == -1) exitWith {systemChat 'Error: tvValue -1';};
			private _functionName = '';
			_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
			{
				private _fIdx = _x # 0;
				private _fName = _x # 1;
				if (_fIdx == _functionIndex) exitWith 
				{
					_functionName = _fName;
				};
			} forEach _functionArray;
			if (_functionName == '') exitWith {hint 'No Function Name';};
			private _function = missionNamespace getVariable [_functionName, 
			{
				private _message = format ["<t font='puristaBold' align='center' color='#f96302' size='2'>MODULE ERROR<br/><t size='0.6' color='#FFFFFF' font='puristaLight'>( MODULE DID NOT RUN )<br/><t size='1.5' align='center' color='#f96302' font='puristaSemiBold'>Function Not Found:<br/><t size='1' color='#FFFFFF' font='puristaMedium'>“%1”<t size='0.7'><br/> <t/>", _functionName]; 
				[_message, "Enhanced Zeus Modules --- [ JAM Edition ]", true, false, (findDisplay 312)] spawn BIS_fnc_guiMessage;
			}];
			private _targetObjArray = curatorMouseOver;
			if ((_targetObjArray isEqualTo []) or (_targetObjArray isEqualTo [''])) then 
			{
				[objNull, screenToWorld getMousePosition] call _function;
			} else {
				_targetObj = _targetObjArray select 1;
				[_targetObj, screenToWorld getMousePosition] call _function;
			};
			comment "_control tvSetCurSel [-1];";	
		};
		case 'O_Soldier_VR_F': 
		{
			private _tooltip = _control tvTooltip _selectionPath;
			private _tooltipArray = _tooltip splitString "\n";
			private _tooltipArrayCount = count _tooltipArray;
			private _tooltipArrayIndex = parseNumber (_tooltipArray select (count _tooltipArray - 1));
			if (_tooltipArrayIndex == 0) exitWith 
			{
				systemchat format ['(_tooltipArrayIndex == 0)'];
			};
			private _functionIndex = _tooltipArrayIndex;
			if (_functionIndex == -1) exitWith {systemChat 'Error: tvValue -1';};
			private _functionName = '';
			_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
			{
				private _fIdx = _x # 0;
				private _fName = _x # 1;
				if (_fIdx == _functionIndex) exitWith 
				{
					_functionName = _fName;
				};
			} forEach _functionArray;
			if (_functionName == '') exitWith {hint 'No Function Name';};
			private _function = missionNamespace getVariable [_functionName, 
			{
				private _message = format ["<t font='puristaBold' align='center' color='#f96302' size='2'>MODULE ERROR<br/><t size='0.6' color='#FFFFFF' font='puristaLight'>( MODULE DID NOT RUN )<br/><t size='1.5' align='center' color='#f96302' font='puristaSemiBold'>Function Not Found:<br/><t size='1' color='#FFFFFF' font='puristaMedium'>“%1”<t size='0.7'><br/> <t/>", _functionName]; 
				[_message, "Enhanced Zeus Modules --- [ JAM Edition ]", true, false, (findDisplay 312)] spawn BIS_fnc_guiMessage;
			}];
			private _targetObjArray = curatorMouseOver;
			if ((_targetObjArray isEqualTo []) or (_targetObjArray isEqualTo [''])) then 
			{
				[objNull, screenToWorld getMousePosition] call _function;
			} else {
				_targetObj = _targetObjArray select 1;
				[_targetObj, screenToWorld getMousePosition] call _function;
			};
			comment "_control tvSetCurSel [-1];";
			
		};
		case 'I_Soldier_VR_F': 
		{
			private _tooltip = _control tvTooltip _selectionPath;
			private _tooltipArray = _tooltip splitString "\n";
			private _tooltipArrayCount = count _tooltipArray;
			private _tooltipArrayIndex = parseNumber (_tooltipArray select (count _tooltipArray - 1));
			if (_tooltipArrayIndex == 0) exitWith 
			{
				systemchat format ['(_tooltipArrayIndex == 0)'];
			};
			private _functionIndex = _tooltipArrayIndex;
			if (_functionIndex == -1) exitWith {systemChat 'Error: tvValue -1';};
			private _functionName = '';
			_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
			{
				private _fIdx = _x # 0;
				private _fName = _x # 1;
				if (_fIdx == _functionIndex) exitWith 
				{
					_functionName = _fName;
				};
			} forEach _functionArray;
			if (_functionName == '') exitWith {hint 'No Function Name';};
			private _function = missionNamespace getVariable [_functionName, 
			{
				private _message = format ["<t font='puristaBold' align='center' color='#f96302' size='2'>MODULE ERROR<br/><t size='0.6' color='#FFFFFF' font='puristaLight'>( MODULE DID NOT RUN )<br/><t size='1.5' align='center' color='#f96302' font='puristaSemiBold'>Function Not Found:<br/><t size='1' color='#FFFFFF' font='puristaMedium'>“%1”<t size='0.7'><br/> <t/>", _functionName]; 
				[_message, "Enhanced Zeus Modules --- [ JAM Edition ]", true, false, (findDisplay 312)] spawn BIS_fnc_guiMessage;
			}];
			private _targetObjArray = curatorMouseOver;
			if ((_targetObjArray isEqualTo []) or (_targetObjArray isEqualTo [''])) then 
			{
				[objNull, screenToWorld getMousePosition] call _function;
			} else {
				_targetObj = _targetObjArray select 1;
				[_targetObj, screenToWorld getMousePosition] call _function;
			};
			comment "_control tvSetCurSel [-1];";	
		};
		case 'C_Soldier_VR_F': {
			private _tooltip = _control tvTooltip _selectionPath;
			private _tooltipArray = _tooltip splitString "\n";
			private _tooltipArrayCount = count _tooltipArray;
			private _tooltipArrayIndex = parseNumber (_tooltipArray select (count _tooltipArray - 1));
			if (_tooltipArrayIndex == 0) exitWith 
			{
				systemchat format ['(_tooltipArrayIndex == 0)'];
			};
			private _functionIndex = _tooltipArrayIndex;
			if (_functionIndex == -1) exitWith {systemChat 'Error: tvValue -1';};
			private _functionName = '';
			_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
			{
				private _fIdx = _x # 0;
				private _fName = _x # 1;
				if (_fIdx == _functionIndex) exitWith 
				{
					_functionName = _fName;
				};
			} forEach _functionArray;
			if (_functionName == '') exitWith {hint 'No Function Name';};
			private _function = missionNamespace getVariable [_functionName, 
			{
				private _message = format ["<t font='puristaBold' align='center' color='#f96302' size='2'>MODULE ERROR<br/><t size='0.6' color='#FFFFFF' font='puristaLight'>( MODULE DID NOT RUN )<br/><t size='1.5' align='center' color='#f96302' font='puristaSemiBold'>Function Not Found:<br/><t size='1' color='#FFFFFF' font='puristaMedium'>“%1”<t size='0.7'><br/> <t/>", _functionName]; 
				[_message, "Enhanced Zeus Modules --- [ JAM Edition ]", true, false, (findDisplay 312)] spawn BIS_fnc_guiMessage;
			}];
			private _targetObjArray = curatorMouseOver;
			if ((_targetObjArray isEqualTo []) or (_targetObjArray isEqualTo [''])) then 
			{
				[objNull, screenToWorld getMousePosition] call _function;
			} else {
				_targetObj = _targetObjArray select 1;
				[_targetObj, screenToWorld getMousePosition] call _function;
			};
			comment "_control tvSetCurSel [-1];";	
		};
		default {};
	};
};

MAZ_EZM_fnc_updateModuleSelection = {
	params ["_selectionPath"];
	with uiNamespace do {
		if (_selectionPath isEqualTo []) exitWith {};
		MAZ_EZMLite_SelectionPath = _selectionPath;
	};
};

JAM_EZM_displayTextColorRGBA = [0,1,0,1];
uiNamespace setVariable ['JAM_EZM_displayTextColorRGBA', JAM_EZM_displayTextColorRGBA];

JAM_GUIfnc_setZeusTransparency = {
	params [['_alpha', 1]];
	with uiNamespace do {
		private _display = findDisplay 312;
			
		_display setVariable ['trimColor', EZM_trimColor];
	
		(_display displayCtrl 16304) ctrlSetBackgroundColor [0.18, 0.19, 0.21, _alpha]; 
		(_display displayCtrl 16304) ctrlCommit 0;

		(_display displayCtrl 15505) ctrlSetBackgroundColor [0.18, 0.19, 0.21, _alpha]; 
		(_display displayCtrl 15505) ctrlCommit 0;

		(_display displayCtrl 16105) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha];  
		if (M9SD_serverEZM) then {
			(_display displayCtrl 16105) ctrlSetText format ['Z.E.U.S',missionNamespace getVariable ['MAZ_EZM_LiteVersion','']];
			(_display displayCtrl 16105) ctrlSetTooltip "ZAM | Enhancements | Utilities | Scripts";
		} else {
			(_display displayCtrl 16105) ctrlSetText format ['EZM Lite %1',missionNamespace getVariable ['MAZ_EZM_LiteVersion','']];
		};
		(_display displayCtrl 16105) ctrlSetTextColor EZM_trimColor;
		(_display displayCtrl 16105) ctrlCommit 0; 

		(_display displayCtrl 16104) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha];  
		(_display displayCtrl 16104) ctrlSetTextColor EZM_trimColor;
		(_display displayCtrl 16104) ctrlCommit 0; 

		(_display displayCtrl 15513) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha];  
		(_display displayCtrl 15513) ctrlCommit 0; 

		(_display displayCtrl 16306) ctrlSetTextColor [0,0,0,1]; 
		(_display displayCtrl 16306) ctrlCommit 0; 

		(_display displayCtrl 15715) ctrlSetTextColor EZM_trimColor;
		(_display displayCtrl 15715) ctrlCommit 0; 

		(_display displayCtrl 15508) ctrlSetBackgroundColor [0.18, 0.19, 0.21, _alpha];  
		(_display displayCtrl 15508) ctrlCommit 0;

		(_display displayCtrl 15506) ctrlSetBackgroundColor [0.21, 0.22, 0.25, _alpha];  
		(_display displayCtrl 15506) ctrlCommit 0;

		(_display displayCtrl 15518) ctrlSetBackgroundColor [0.18, 0.19, 0.21, _alpha]; 
		(_display displayCtrl 15518) ctrlCommit 0;

		(_display displayCtrl 280) ctrlSetBackgroundColor [0.25, 0.27, 0.29, _alpha * 0.5]; 
		(_display displayCtrl 280) ctrlCommit 0;

		(_display displayCtrl 283) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha]; 
		(_display displayCtrl 283) ctrlCommit 0; 

		(_display displayCtrl 646) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha]; 
		(_display displayCtrl 646) ctrlCommit 0; 

		(_display displayCtrl 152) ctrlSetTextColor EZM_trimColor; 
		(_display displayCtrl 152) ctrlAddEventHandler ["MouseButtonClick",
		{
			params ["_control"];
			_control spawn 
			{
				uiSleep 0.07;
				_this ctrlSetTextColor ((ctrlParent _this) getvariable ['trimColor', [1,1,1,1]]); 
				_this ctrlCommit 0; 
			};
		}];
		(_display displayCtrl 152) ctrlCommit 0; 

		(_display displayCtrl 15515) ctrlSetTextColor EZM_trimColor;
		(_display displayCtrl 15515) ctrlCommit 0;
	};
};

MAZ_EZM_fnc_initFunction = {

		MAZ_EZM_fnc_systemMessage = {
			params ["_message",["_sound",""]];
			systemChat format ["[ Enhanced Zeus Modules ] : %1",_message];
			if(_sound != "") then {
				playSound _sound;
			};
		};
		uiNamespace setVariable ['MAZ_EZM_fnc_systemMessage',MAZ_EZM_fnc_systemMessage];

		MAZ_EZM_fnc_getScreenPosition = {
			params [["_screenPos",getMousePosition,[[]],2]];

			if(visibleMap) then {
				private _ctrlMap = findDisplay 312 displayCtrl 50;
				private _pos2D = _ctrlMap ctrlMapScreenToWorld _screenPos;
				_position = (_pos2D + [0]);
				_position
			} else {
				private _position = AGLtoASL screenToWorld _screenPos;
				{
					_x params ["_intersectPos","_surfaceNormal"];

					if(_surfaceNormal vectorDotProduct [0,0,1] > 0.5) exitWith {_position = _intersectPos;};
				}forEach lineIntersectsSurfaces [getPosASL curatorCamera,_position,objNull,objNull,true,5,"VIEW","FIRE",false];
				_position set [2,0];
				_position
			};
		};

		MAZ_EZM_fnc_selectSecondaryPosition = {
			params [
				["_text","",[""]],
				["_function",{},[{}]],
				["_objects",objNull,[objNull]],
				["_args",[]],
				["_icon","\a3\ui_f\data\igui\cfg\cursors\select_target_ca.paa",[""]],
				["_angle",45,[0]],
				["_color",[1,0,0,1],[[]],4]
			];
			if(isNil "MAZ_EZM_isSelectingSecondPos") then {
				MAZ_EZM_isSelectingSecondPos = false;
			};

			if(MAZ_EZM_isSelectingSecondPos) exitWith {
				["Already selecting a position!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;
			};

			MAZ_EZM_isSelectingSecondPos = true;

			private _display = findDisplay 312;
			private _ctrlMap  = _display displayCtrl 50;
			private _visuals = [_text,_icon,_angle,_color];

			_display setVariable ["MAZ_EZM_selectSecondPosParams",[_function,_objects,_args,_visuals]];
			_ctrlMap setVariable ["MAZ_EZM_selectSecondPosParams",[_objects,_visuals]];

			comment "ButtonClick on display";
			private _mouseEh = _display displayAddEventHandler ["MouseButtonDown",{
				params ["_display","_button","","","_shift","_ctrl","_alt"];
				(_display getVariable "MAZ_EZM_selectSecondPosParams") params ["_function","_objects","_args",""];
				if(_button != 0) exitWith {};

				private _position = [] call MAZ_EZM_fnc_getScreenPosition;
				[_objects,_position,_args,_shift,_ctrl,_alt] call _function;

				MAZ_EZM_isSelectingSecondPos = false;
			}];
			comment "Keyboard input";
			private _keyboardEH = _display displayAddEventHandler ["KeyDown",{
				params ["_display", "_key", "_shift", "_ctrl", "_alt"];
				(_display getVariable "MAZ_EZM_selectSecondPosParams") params ["_function","_objects","_args",""];
				if(_key != 1) exitWith {false};
				["Selection cancelled.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;
				MAZ_EZM_isSelectingSecondPos = false;
				true
			}];
			comment "Draw 2D icons on map";
			private _drawEH = _ctrlMap ctrlAddEventHandler ["Draw",{
				params ["_ctrlMap"];
				(_ctrlMap getVariable "MAZ_EZM_selectSecondPosParams") params ["_objects","_visuals"];
				_visuals params ["_text","_icon","_angle","_color"];
				private _pos = _ctrlMap ctrlMapScreenToWorld getMousePosition;
				_ctrlMap drawIcon [
					_icon,
					_color,
					_pos,
					24,
					24,
					_angle,
					_text,
					1,
					0.06,
					"RobotoCondensed"
				];

				if(!(_objects isEqualType [])) then {
					_objects = [_objects];
				};

				{
					_ctrlMap drawLine [_x, _pos, _color];
				}forEach _objects;
			}];
			comment "Draw 3D icons at position";
			["MAZ_EZM_selectPosEachFrame","onEachFrame",{
				params ["_objects", "_visuals", "_mouseEh", "_keyboardEH", "_drawEH"];

				if((isNull (findDisplay 312)) || !(isNull findDisplay 49)) then {
					MAZ_EZM_isSelectingSecondPos = false;
				};

				if(!MAZ_EZM_isSelectingSecondPos) then {
					private _display = findDisplay 312;
					_display displayRemoveEventHandler ["MouseButtonDown", _mouseEh];
					_display displayRemoveEventHandler ["KeyDown", _keyboardEH];
					private _ctrlMap = _display displayCtrl 50;
					_ctrlMap ctrlRemoveEventHandler ["Draw", _drawEH];
					["MAZ_EZM_selectPosEachFrame","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				};

				if(visibleMap) exitWith {};

				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				_visuals params ["_text", "_icon", "_angle", "_color"];
				drawIcon3D [
					_icon, 
					_color, 
					_pos, 
					1.5,
					1.5, 
					_angle, 
					_text,
					1
				];

				if(!(_objects isEqualType [])) then {
					_objects = [_objects];
				};

				{
					drawLine3D [ASLtoAGL getPosASL _x, _pos, _color];
				}forEach _objects;
			},[_objects,_visuals,_mouseEh,_keyboardEH,_drawEH]] call BIS_fnc_addStackedEventHandler;
		};

		MAZ_EZM_fnc_hiddenEasterEggModule = {
			[] spawn {
				titleText ["<t color='#008080' size='1.5'>Thank you for using EZM Lite by ZAM!</t>","PLAIN DOWN",2,true,true];
				_effects = [] spawn {
					0 = ["ColorCorrections", 1500, [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 0], [0.299, 0.587, 0.114, 0]]] spawn 
					{
						params ["_name", "_priority", "_effect", "_handle"];
						while {
							_handle = ppEffectCreate [_name, _priority];
							_handle < 0
						} do {
							_priority = _priority + 1;
						};
						_handle ppEffectEnable true;
						_handle ppEffectAdjust _effect;
						_handle ppEffectCommit 0.4;
					};
					uiSleep 0.4;
					0 = ["ColorCorrections", 1500, [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1], [0.299, 0.587, 0.114, 0]]] spawn 
					{
						params ["_name", "_priority", "_effect", "_handle"];
						while {
							_handle = ppEffectCreate [_name, _priority];
							_handle < 0
						} do {
							_priority = _priority + 1;
						};
						_handle ppEffectEnable true;
						_handle ppEffectAdjust _effect;
						_handle ppEffectCommit 0.4;
						waitUntil {ppEffectCommitted _handle};
						_handle ppEffectEnable false;
						ppEffectDestroy _handle;
					};
				};
				[] spawn {
					_startEffect = ["ChromAberration", 200, [0.1, 0.1, true]] spawn {
						params ["_name", "_priority", "_effect", "_handle"];
						while {
							_handle = ppEffectCreate [_name, _priority];
							_handle < 0
						} do {
							_priority = _priority + 1;
						};
						_handle ppEffectEnable true;
						_handle ppEffectAdjust _effect;
						_handle ppEffectCommit 0.3;
					};
					uiSleep 0.3;
					_stopEffect = ["ChromAberration", 200, [0, 0, true]] spawn {
						params ["_name", "_priority", "_effect", "_handle"];
						while {
							_handle = ppEffectCreate [_name, _priority];
							_handle < 0
						} do {
							_priority = _priority + 1;
						};
						_handle ppEffectEnable true;
						_handle ppEffectAdjust _effect;
						_handle ppEffectCommit 1;
						waitUntil {ppEffectCommitted _handle};
						_handle ppEffectEnable false;
						ppEffectDestroy _handle;
					};
				};
				[] spawn {
					uiSleep 0.3;
					_emp_ppEffect_01 = ppEffectCreate ["colorCorrections", 1555]; 
					_emp_ppEffect_01 ppEffectEnable true; 
					_emp_ppEffect_01 ppEffectAdjust [1.0, 1.0, 0, [0.21, 0.21, 1.0, 0.14], [1.4, 1.4, 0.14, 1.4] ,[0.299, 0.587, 0.114, 0]];  
					_emp_ppEffect_01 ppEffectCommit 0.5; 
					uiSleep 0.5;
					_emp_ppEffect_01 ppEffectAdjust [1.0, 1.0, 0, [0.0, 0.0, 0.0, 0.0], [1, 1, 1, 1] ,[0.299, 0.587, 0.114, 0],[
					-1,
					-1,
					0,
					0,
					0,
					0,
					0
					]];
					_emp_ppEffect_01 ppEffectCommit 4; 
					uiSleep 5;
					
					PPEFFECTDESTROY _emp_ppEffect_01;
				};
				[] spawn {
					enableCamShake true;
					addCamShake [2,4,16];
					uiSleep 4;
					resetCamShake;
				};
				playSound ['vr_shutdown',true];
				playSound ['vr_shutdown',false];
				sleep 6.5;
				titleFadeOut 1;
			};
		};

		MAZ_EZM_fnc_autoResupplyAI = {
			params ["_unit"];
			comment "Fix groups that don't get deleted.";
			if(!(isGroupDeletedWhenEmpty (group _unit))) then {
				(group _unit) deleteGroupWhenEmpty true;
			};
			_unit setUnitPos MAZ_EZM_stanceForAI;
			_unit addEventHandler ["Reloaded", { 
				params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"]; 
				_oldMagazine params ["_type","_count"];
				_unit addMagazine _type;
			}];
		};

		MAZ_EZM_fnc_addObjectToInterface = {
			params [
				["_objects",[],[[],objNull]],
				["_curators",allCurators]
			];
			if(_objects isEqualType objNull) then {
				_objects = [_objects];
			};
			if(!(_curators isEqualType [])) then {
				_curators = [_curators];
			};
			if(("CuratorModeratorRights" call BIS_fnc_getParamValue) == -1 && _curators isEqualTo allCurators) then {
				_curators = [getAssignedCuratorLogic player];
			};
			[[_objects,_curators],{
				params ["_objects","_curators"];
				{
					_x addCuratorEditableObjects [_objects,true];
				} foreach _curators;
			}] remoteExec ["Spawn",2];
		};

	comment "AI Modifiers";

		MAZ_EZM_fnc_setAmbientAnimationModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			["Apply Ambient Animation",[
				[
					"LIST",
					"Select animation:",
					[
						[
							"",
							"HubBriefing_loop",
							"Acts_ShieldFromSun_loop",
							"Acts_listeningToRadio_Loop",
							"Acts_AidlPercMstpSnonWnonDnon_warmup_2_loop",
							"Acts_AidlPercMstpSnonWnonDnon_warmup_3_loop",
							"Acts_ExecutionVictim_Loop",
							"Acts_JetsCrewaidLCrouch_loop",
							"Acts_carFixingWheel",
							"AidlPsitMstpSnonWnonDnon_ground00",
							"Acts_JetsCrewaidFCrouchThumbup_loop",
							"Acts_NavigatingChopper_Loop",
							"Acts_ShowingTheRightWay_loop",
							"Acts_JetsMarshallingEnginesOn_loop",
							"Acts_Dance_01",
							"Acts_Dance_02"
						],
						[
							"Remove Animation",
							"Standing: Hands on hip",
							"Standing: Shield Eyes",
							"Standing: Listen to Radio",
							"Standing: Bent over",
							"Standing: Hands on Back",
							"Crouch: Detained",
							"Crouch: One Knee",
							"Crouch: Fix Wheel",
							"Crouch: Sit",
							"Crew: Thumbs Up",
							"Crew: Move Forward",
							"Crew: This Way",
							"Crew: Take Off",
							"Special: Dance 1",
							"Special: Dance 2"
						],
						0
					]
				],
				[
					"TOOLBOX:YESNO",
					["Combat Animation:","When the AI takes fire it will quit the animation with this enabled."],
					[true]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_anim","_isCombat"];
				if(_args getVariable ["MAZ_EZM_animDone",-420] != -420) then {
					_args removeEventHandler ["AnimDone",_args getVariable "MAZ_EZM_animDone"];
				};
				if(_args getVariable ["MAZ_EZM_combatAnim",-420] != -420) then {
					_args removeEventHandler ["Suppressed",_args getVariable "MAZ_EZM_combatAnim"];
				};
				if(_args getVariable ["MAZ_EZM_removeAnimEH",-420] != -420) then {
					_args removeEventHandler ["Killed",_args getVariable "MAZ_EZM_removeAnimEH"];
				};
				if(_anim == "") then {
					[_args,"AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove"];
					_args setBehaviour "AWARE";
					[_args,"Move"]remoteExec ["enableAI",0];
					[_args,"Anim"]remoteExec ["enableAI",0];
					["Animation reset."] call MAZ_EZM_fnc_systemMessage;
				} else {
					(group _args) setBehaviour "CARELESS";
					[_args,"Move"]remoteExec ["disableAI",0];
					[_args,"Anim"]remoteExec ["disableAI",0];
					[_args,_anim] remoteExec ['switchMove',0];
					_args setVariable ["MAZ_EZM_animDone",
						_args addEventhandler ["AnimDone",{
							params ["_unit","_anim"];
							[_args,_anim] remoteExec ['switchMove'];
						}],true
					];
					if(_isCombat) then {
						_args setVariable ["MAZ_EZM_combatAnim",
							_args addEventHandler ["Suppressed", {
								params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
								[_unit,"AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove"];
								_unit setBehaviour "COMBAT";
								[_unit,"Move"]remoteExec ["enableAI",0];
								[_unit,"Anim"]remoteExec ["enableAI",0];
							}],true
						];
					};
					_args setVariable ["MAZ_EZM_removeAnimEH",
						_args addEventhandler ["Killed",{
							params ["_unit", "_killer", "_instigator", "_useEffects"];
							if(_unit getVariable ["MAZ_EZM_animDone",-420] != -420) then {
								_unit removeEventHandler ["AnimDone",_unit getVariable "MAZ_EZM_animDone"];
							};
							if(_unit getVariable ["MAZ_EZM_combatAnim",-420] != -420) then {
								_unit removeEventHandler ["Suppressed",_unit getVariable "MAZ_EZM_combatAnim"];
							};
						}],true
					];
					["Animation set."] call MAZ_EZM_fnc_systemMessage;
				};
				playSound 'addItemOk';
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_entity] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_toggleCarelessModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			if((behaviour _entity) == "CARELESS") then {
				[group _entity,"AWARE"] remoteExec ['setBehaviour'];
				[format ["%1's group is now aware.",name _entity],"addItemOk"] call MAZ_EZM_fnc_systemMessage;
			} else {
				[group _entity,"CARELESS"] remoteExec ['setBehaviour'];
				[format ["%1's group is now careless.",name _entity],"addItemOk"] call MAZ_EZM_fnc_systemMessage;
			};
		};

		MAZ_EZM_fnc_easyModeModule = {
			params ["_entity"];
			if(isNil "MAZ_EZM_EZMode") then {
				MAZ_EZM_EZMode = false;
			};
			if(MAZ_EZM_EZMode) then {
				MAZ_EZM_EZMode = false;
				["EZ Mode turned off.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			} else {
				MAZ_EZM_EZMode = true;
				["EZ Mode turned on.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
				[] spawn {
					while {MAZ_EZM_EZMode} do {
						[[],{
							{
								_x setSkill 0;
								_x setSkill ['aimingAccuracy', 0];
								_x setSkill ['aimingShake', 0];
								_x setSkill ['aimingSpeed', 0];
								_x setSkill ['endurance', 0];
								_x setSkill ['spotDistance', 0];
								_x setSkill ['spotTime', 0];
								_x setSkill ['courage', 0];
								_x setSkill ['reloadSpeed', 0];
								_x setSkill ['commanding', 0];
								_x setSkill ['general', 0];
								_x setUnitPos 'UP';

								private _unit = _x;
								private _group = group _unit;
								_vehicle = vehicle _unit;
								_group enableIRLasers true;
								_unit enableIRLasers true;
								_group enableGunLights "ForceOn";
								_unit enableGunLights "ForceOn";
								_vehicle setPilotLight true;
								_vehicle setCollisionLight true;
								
								_unit action ["IRLaserOn", _unit];
								_unit action ["GunLightOn", _unit];
								_unit action ["CollisionLightOn", _vehicle];
								_unit action ["lightOn", _vehicle];
								_unit action ["SearchlightOn", _vehicle];
							} forEach (allUnits - allPlayers);
						}] remoteExec ['spawn'];
						sleep 3;
					};
				};
			};
		};

		MAZ_EZM_fnc_garrisonInstantModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "CAManBase")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[_entity] spawn {
				params ["_entity"];
				private _group = group _entity;
				if (_group isEqualType objNull) then {_group = group _group};
				private _leader = leader _group;
				private _previousBehaviour = behaviour _leader;

				private _arrayShuffle = {
					private _array = _this select 0;
					private _count = count _array;
					private _arrayN = [];
					private _arrayT = [];
					private _c = 0;
					private _r = 0;

					while {_c < _count} do
					{
						while {_r in _arrayT} do
						{_r = floor (random _count);
						};
						_arrayT pushBack _r;
						_arrayN set [_c, _array select _r];
						_c = _c + 1;
					};

					_arrayN
				};

				private _fnc_getHousePositions = {
					params ["_index","_houses"];
					private _nearestBuilding = _houses select _index;
					private _positionsInBuilding = [_nearestBuilding] call BIS_fnc_buildingPositions;
					_positionsInBuilding = [_positionsInBuilding] call _arrayShuffle;
					_positionsInBuilding
				};

				private _fnc_orderToPositions = {
					params ["_units","_positions","_houseIndex"];
					private _newUnits = _units;
					{
						private _unit = objNull;
						if((count _units) -1 >= _forEachIndex) then {
							private _unit = _units select _forEachIndex;
							_unit setPos _x;
							_newUnits = _newUnits - [_unit];
							_unit forceSpeed 0;
						};
					}forEach _positions;
					if((count _buildingPoses) < (count _units)) then {
						_houseIndex = _houseIndex + 1;
						_buildingPoses = [_houseIndex,_nearestBuildings] call _fnc_getHousePositions;
						[_newUnits,_buildingPoses,_houseIndex] call _fnc_orderToPositions;
					};
				};

				{
					deleteWaypoint [_group,_forEachIndex];
				}forEach (waypoints _group);

				private _nearestBuildings = nearestObjects [getPos _entity, ["building"], 50, true];

				if (_nearestBuildings isEqualTo []) exitWith { false };
				_group setbehaviour "AWARE";

				private _houseIndex = 0;

				private _buildingPoses = [_houseIndex,_nearestBuildings] call _fnc_getHousePositions;

				private _units = (units _group) select {!isNull _x && alive _x};

				[_units,_buildingPoses,_houseIndex] call _fnc_orderToPositions;

				true
			};
		};

		MAZ_EZM_fnc_garrisonSearchModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[_entity] spawn {
				params ["_entity"];
				private _group = group _entity;
				if (_group isEqualType objNull) then {_group = group _group};
				private _leader = leader _group;
				private _previousBehaviour = behaviour _leader;

				private _arrayShuffle = {
					private _array = _this select 0;
					private _count = count _array;
					private _arrayN = [];
					private _arrayT = [];
					private _c = 0;
					private _r = 0;

					while {_c < _count} do
					{
						while {_r in _arrayT} do
						{_r = floor (random _count);
						};
						_arrayT pushBack _r;
						_arrayN set [_c, _array select _r];
						_c = _c + 1;
					};

					_arrayN
				};

				private _fnc_getHousePositions = {
					params ["_index","_houses"];
					private _nearestBuilding = _houses select _index;
					private _positionsInBuilding = [_nearestBuilding] call BIS_fnc_buildingPositions;
					_positionsInBuilding = [_positionsInBuilding] call _arrayShuffle;
					_positionsInBuilding
				};

				private _fnc_disableMoveAfterReachPos = {
					params ["_unit","_pos"];
					waitUntil {_unit distance _pos < 1};
					_unit forceSpeed 0;
					_unit setBehaviour "SAFE";
				};

				private _fnc_orderToPositions = {
					params ["_units","_positions","_houseIndex"];
					private _newUnits = _units;
					{
						private _unit = objNull;
						if((count _units) -1 >= _forEachIndex) then {
							private _unit = _units select _forEachIndex;
							_unit doMove _x;
							_newUnits = _newUnits - [_unit];
							_unit forceSpeed -1;
							[_unit,_x] spawn _fnc_disableMoveAfterReachPos;
						};
					}forEach _positions;
					if((count _buildingPoses) < (count _units)) then {
						_houseIndex = _houseIndex + 1;
						_buildingPoses = [_houseIndex,_nearestBuildings] call _fnc_getHousePositions;
						[_newUnits,_buildingPoses,_houseIndex] call _fnc_orderToPositions;
					};
				};

				{
					deleteWaypoint [_group,_forEachIndex];
				}forEach (waypoints _group);

				private _nearestBuildings = nearestObjects [getPos _entity, ["building"], 50, true];

				if (_nearestBuildings isEqualTo []) exitWith { false };
				_group setbehaviour "AWARE";
				
				private _houseIndex = 0;
				
				private _buildingPoses = [_houseIndex,_nearestBuildings] call _fnc_getHousePositions;

				private _units = (units _group) select {!isNull _x && alive _x};

				[_units,_buildingPoses,_houseIndex] call _fnc_orderToPositions;

				true
			};
		};

		MAZ_EZM_fnc_getSafePos = {
			params ["_pos", ["_range", ""], ["_objDist", getNumber(configFile >> "CfgWorlds" >> worldName >> "safePositionRadius")], ["_waterMode", 1], ["_maxGradient", 1]];

			private _minDist = -1;
			private _maxDist = -1;
			switch (typeName _range) do {
				case "ARRAY" : {
					_minDist = _range select 0;
					_maxDist = _range select 1;
				};
				case "SCALAR" : {
					_minDist = 0;
					_maxDist = _range;
				};
				default {
					_minDist = 0;
					_maxDist = getNumber(configFile >> "CfgWorlds" >> worldName >> "safePositionRadius");
				};
			};

			if(_objDist < 0) then {
				_objDist = getNumber(configFile >> "CfgWorlds" >> worldName >> "safePositionRadius");
			};

			private _newPos = [];
			private _posX = _pos select 0;
			private _posY = _pos select 1;
			private _attempts = 0;

			while {_attempts < 1000} do {
				private _newX = _posX + (_maxDist - (random (_maxDist * 2)));
				private _newY = _posY + (_maxDist - (random (_maxDist * 2)));
				private _testPos = [_newX, _newY];

				if ( (_pos distance _testPos) >= _minDist) then {
					if !((_testPos isFlatEmpty [_objDist, 0, _maxGradient, _objDist max 5, _waterMode, !(_waterMode == 0), objNull]) isEqualTo []) exitWith {
						_newPos = _testPos;
					};
				};
				_attempts = _attempts + 1;
			};

			if (_newPos isEqualTo []) then {
				_newPos = _pos;
			};
			_newPos
		};

		MAZ_EZM_fnc_unGarrisonModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[_entity] spawn {
				_object =  _this select 0;
				_groupUnderCursor = group _object;
				if (local (leader _groupUnderCursor)) then{
					private _outsidePos = [getPos (leader _groupUnderCursor), [3,15], 2, 0] call MAZ_EZM_fnc_getSafePos;
					{
						_x setUnitPos "AUTO";
						_x forceSpeed -1;
						_x doWatch objNull;
						_x doMove _outsidePos;
					} forEach(units _groupUnderCursor);
				};
				["AI are leaving the building.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			};
		};

		MAZ_EZM_fnc_toggleLightsModule = {
			params ["_entity"];
			[[],{
				{
					private _unit = _x;
					private _group = group _unit;
					private _vehicle = vehicle _unit;
					_group enableIRLasers true;
					_unit enableIRLasers true;
					_group enableGunLights "ForceOn";
					_unit enableGunLights "ForceOn";
					_vehicle setPilotLight true;
					_vehicle setCollisionLight true;
					
					_unit action ["IRLaserOn", _unit];
					_unit action ["GunLightOn", _unit];
					_unit action ["CollisionLightOn", _vehicle];
					_unit action ["lightOn", _vehicle];
					_unit action ["SearchlightOn", _vehicle];
				} forEach (allUnits - allPlayers);
			}] remoteExec ['spawn'];
			["Units have their lasers/lights turned on.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_toggleOffLightsModule = {
			params ["_entity"];
			[[],{
				{
					private _unit = _x;
					private _group = group _unit;
					private _vehicle = vehicle _unit;
					_group enableIRLasers false;
					_unit enableIRLasers false;
					_group enableGunLights "ForceOff";
					_unit enableGunLights "ForceOff";
					_vehicle setPilotLight false;
					_vehicle setCollisionLight false;
					
					_unit action ["IRLaserOff", _unit];
					_unit action ["GunLightOff", _unit];
					_unit action ["CollisionLightOff", _vehicle];
					_unit action ["lightOff", _vehicle];
					_unit action ["SearchlightOff", _vehicle];
				} forEach (allUnits - allPlayers);
			}] remoteExec ['spawn'];
			["Units have their lasers/lights turned off.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_makeHostageModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			[_entity,true] remoteExec ["setCaptive",0];
			[_entity,"Move"]remoteExec ["disableAI",0];
			[_entity,"Acts_AidlPsitMstpSsurWnonDnon_loop"] remoteExec["switchMove",0];
			private _holdActionIndex = [
				_entity,											
				"Free Hostage",										
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",	
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",	
				"_this distance _target < 3 && _target != _this",
				"_caller distance _target < 3",						
				{},
				{},
				{ 
					_unit = (_this select 0);
					[_unit,false] remoteExec ["setCaptive",0];
					[_unit,"Move"]remoteExec ["enableAI",0];
					[_unit,"AmovPercMstpSnonWnonDnon"] remoteExec["playMove",0];
					[_unit] remoteExec ["removeAllActions",0];
				},
				{},
				[],
				6,
				0,
				true,												
				false												
			] remoteExec ["BIS_fnc_holdActionAdd",0, _entity];

			if(_entity getVariable ["MAZ_EZM_hostageEH",-1] == -1) then {
				_entity setVariable ['MAZ_EZM_hostageEH',_entity addEventHandler ["Killed",{
					params ["_unit", "_killer", "_instigator", "_useEffects"];
					[_unit] remoteExec ["removeAllActions",0];
					["TaskFailed",["",format ["Hostage (%1) was killed by %2",name _unit,name _killer]]] remoteExec ['BIS_fnc_showNotification',0];
					[_unit,[
						"Take Dogtag",
						{
							params ["_target", "_caller", "_actionId", "_arguments"];
							["TaskSucceeded",["",format ["Hostage (%1) dogtag was taken by %2",name _target,name _caller]]] remoteExec ['BIS_fnc_showNotification',0];
							[_target] remoteExec ["removeAllActions",0];
						},
						nil,
						1.5,
						true,
						true,
						"",
						"_target distance _this < 5"
					]] remoteExec ['addAction',0];
				}]];
			};

			["Unit is now a hostage, they can be freed by scrolling on them.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_makeHVTModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			[[_entity],{
				params ["_nearestMan"];
				_nearestMan addEventHandler ["Killed",{
					params ["_unit", "_killer", "_instigator", "_useEffects"];
					["TaskSucceeded",["",format ["%1 was killed by %2",name _unit,name _killer]]] remoteExec ['BIS_fnc_showNotification',0];
				}];
			}] remoteExec ['spawn',0,_entity];
			["HVT created, all players will be notified of their death.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_changeDifficultyModule = {
			params ["_entity"];
			["Set Difficulty",[
				[
					"LIST",
					"Difficulty",
					[
						[
							"easy",
							"medium",
							"hard"
						],
						[
							"Easy",
							"Medium",
							"Hard"
						],
						0
					]
				]
			],{
				params ["_values","_args","_display"];
				private _value = _values select 0;
				switch (_value) do {
					case "easy": {
						[[], {
							{
								_x setSkill 0;
							} forEach allUnits;
						}] remoteExec ["spawn"];
						["Difficulty set to EASY."] call MAZ_EZM_fnc_systemMessage;
					};
					case "medium": {
						[[], {
							{
								_x setSkill 0.5;
							} forEach allUnits;
						}] remoteExec ["spawn"];
						["Difficulty set to MEDIUM."] call MAZ_EZM_fnc_systemMessage;
					};
					case "hard": {
						[[], {
							{
								_x setSkill 1;
							} forEach allUnits;
						}] remoteExec ["spawn"];
						["Difficulty set to HARD."] call MAZ_EZM_fnc_systemMessage;
					};
				};
				playSound 'addItemOk';
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_changeStanceModule = {
			params ["_entity"];

			["Set Stance",[
				[
					"LIST",
					"Stance Mode",
					[
						[
							"AUTO",
							"UP",
							"MIDDLE",
							"DOWN"
						],
						[
							"Automatic Stance",
							"Forced Standing",
							"Forced Crouching",
							"Forced Prone"
						],
						0
					]
				]
			],{
				params ["_values","_args","_display"];
				private _value = _values select 0;
				MAZ_EZM_stanceForAI = _value;
				[[_value],{
					params ["_mode"];
					{
						_x setUnitPos _mode;
					}forEach allunits;
				}] remoteExec ['spawn'];
				[format ["All units stance mode set to %1.",_value],"addItemOk"] call MAZ_EZM_fnc_systemMessage;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_toggleSurrenderModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			private _isSurrendered = _entity getVariable ['EZM_isSurrendered',false];
			if(_isSurrendered) then {
				[_entity,"AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove"];
				[_entity,false] remoteExec ["setCaptive",0];
				_entity setVariable ['EZM_isSurrendered',false,true];
				
				["Unit is no longer surrendered.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			} else {
				[_entity,["Surrender",_entity]] remoteExec ["action"];
				[_entity,true] remoteExec ["setCaptive",0];
				_entity setVariable ['EZM_isSurrendered',true,true];
				[_entity] spawn {
					_dude = (_this select 0);
					_weapon = currentWeapon _dude; 
					if(_weapon isEqualTo "") exitWith{};
					[_dude, _weapon] remoteExec ['removeWeapon'];
					sleep 0.1;
					_weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0];
					_weaponHolder addWeaponCargoGlobal [_weapon,1];
					_weaponHolder setPos (_dude modelToWorld [0,.2,1.2]);
					_weaponHolder disableCollisionWith _dude;
					_dir = random(360);
					_speed = 1.5;
					_weaponHolder setVelocity [_speed * sin(_dir), _speed * cos(_dir),4]; 
				};

				["Unit is now surrendered.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			};
		};

		MAZ_EZM_fnc_suppressiveFireModule = {
			params ["_entity"];
			if(!(_entity isKindOf "CAManBase") && !(_entity isKindOf "StaticMGWeapon")) exitWith {["Object is not a man!.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			if(_entity isKindOf "StaticMGWeapon") then {
				if(gunner _entity == objNull) exitWith {["No gunner!.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
				_entity = gunner _entity;
			};
			if(_entity getVariable ["MAZ_EZM_isSuppressing",false]) exitWith {["Unit is already suppressing!.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			["Suppressive Fire",[
				[
					"SLIDER",
					"Duration of Suppress",
					[5,20,10]
				]
			],{
				params ["_values","_entity","_display"];
				_values params ["_duration"];
				_display closeDisplay 1;

				["Position to Suppress",{
					params ["_objects","_position","_args","_shift","_ctrl","_alt"];
					_args params ["_entity","_duration"];

					private _target = (createGroup [east,true]) createUnit ["O_Soldier_unarmed_F",_position,[],0,"CAN_COLLIDE"];
					_target disableAI "MOVE";
					_target hideObject true;
					comment "ZACO: You need to hide him from everyone!";
					[_target, true] remoteExec ['hideObjectGlobal', 2];
					_target setUnitPOs "UP";
					_target addRating -100000000000;

					[_entity,_duration,_target] spawn {
						params ["_entity","_duration","_target"];
						_entity setVariable ["MAZ_EZM_isSuppressing",true,true];
						_entity doSuppressiveFire _target;
						_entity suppressFor _duration;
						sleep _duration;
						_entity doWatch objNull;
						deleteVehicle _target;
						_entity setVariable ["MAZ_EZM_isSuppressing",false,true];
					};
				},_entity,[_entity,_duration],"a3\ui_f\data\igui\cfg\cursors\attack_ca.paa",45] call MAZ_EZM_fnc_selectSecondaryPosition;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_entity] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_removeNVGsAddFlashlightsModule = {
			["Remove/Add AI Equipment",[
				[
					"TOOLBOX",
					"Night Vision:",
					[false,[["REMOVE","Removes NVGs from the selected side's AI."],["EQUIP","Adds NVGs to the selected side's AI."]]]
				],
				[
					"TOOLBOX",
					"Flashlights:",
					[true,[["REMOVE","Removes flashlights from the selected side's AI."],["EQUIP","Adds flashlights to the selected side's AI."]]]
				],
				[
					"TOOLBOX",
					["Smokes:","Helps performance when lots of AI may be throwing smoke."],
					[false,[["REMOVE","Removes smoke grenades from the selected side's AI."],["EQUIP","This doesn't do anything, I'm lazy..."]]]
				],
				[
					"SIDES",
					"Sides Effected:",
					[east,independent]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_nvgs","_flashlights","_smokes","_sides"];
				private _sidesNew = [_sides] call MAZ_EZM_fnc_getSidesFromString;
				{
					if((!isPlayer _x) && (side _x in _sidesNew)) then {
						private _unit = _x;
						private _NVGArray = [
							"NVGoggles",
							"NVGoggles_OPFOR",
							"NVGoggles_INDEP",
							"NVGoggles_tna_F",
							"O_NVGoggles_ghex_F",
							"O_NVGoggles_grn_F",
							"O_NVGoggles_hex_F",
							"O_NVGoggles_urb_F",
							"NVGogglesB_blk_F",
							"NVGogglesB_grn_F",
							"NVGogglesB_gry_F",
							"Integrated_NVG_TI_1_F"
						];
						if(_nvgs) then {
							private _default = getUnitLoadout (configFile >> "CfgVehicles" >> typeOf _unit);
							_unit linkItem (_default # 9 # 5);
						} else {
							{
								if(_x in _NVGArray) then {
									_unit unlinkItem _x;
								};
							}forEach assignedItems _unit;
						};

						if(_flashlights) then {
							_unit addWeaponItem [primaryWeapon _unit,"acc_flashlight",true];
						} else {
							_unit addWeaponItem [primaryWeapon _unit,"acc_pointer_ir",true];
						};

						private _smokesArray = ["SmokeShellBlue","SmokeShellGreen","SmokeShellOrange","SmokeShellPurple","SmokeShellRed","SmokeShell","SmokeShellYellow"];
						if(!_smokes) then {
							{
								if(_x in _smokesArray) then {
									_unit removeMagazine _x;
								};
							}forEach magazines _unit;
						};
					};
				}forEach allUnits;
				["AI Equipment updated.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

	comment "AI Supports";

		MAZ_airDropSupportModule = {
			params ["_pos","_mode","_direction","_vehType","_sideOf","_sfx"];
			private ["_typeMode","_dropType","_dropLoad","_dir","_vehPos","_doorAnim"];
			private _typeMode = _mode select 0; _dropType = nil; if(count _mode == 2) then {_dropType = _mode select 1;};
			_typeMode = toLower _typeMode; if(count _mode == 2) then {_dropType = toLower _dropType;}; _vehType = toLower _vehType;
			private _grp = createGroup [_sideOf,true];
			switch (_typeMode) do {
				case "arsenal": {_dropLoad = 'B_CargoNet_01_ammo_F';};
				case "vehicle": {_dropLoad = _dropType;};
			};

			switch (_vehType) do {
				case "blackfish": {_vehType = 'B_T_VTOL_01_vehicle_F'; _doorAnim = 'Door_1_source';};
				case "huron": {_vehType = 'B_Heli_Transport_03_F'; _doorAnim = 'Door_rear_source';};
				case "xian": {_vehType = 'O_T_VTOL_02_vehicle_F'; _doorAnim = 'Door_1_source';};
				case "mohawk": {_vehType = 'I_Heli_Transport_02_F'; _doorAnim = 'CargoRamp_Open';};
			};

			switch (_direction) do {
				case "NW": {_dir = 135; _vehPos = _pos getPos [3500,315];};
				case "N": {_dir = 180; _vehPos = _pos getPos [3500,0];};
				case "NE": {_dir = 225; _vehPos = _pos getPos [3500,45];};
				case "E": {_dir = 270; _vehPos = _pos getPos [3500,90];};
				case "SE": {_dir = 315; _vehPos = _pos getPos [3500,135];};
				case "S": {_dir = 0; _vehPos = _pos getPos [3500,180];};
				case "SW": {_dir = 45; _vehPos = _pos getPos [3500,225];};
				case "W": {_dir = 90; _vehPos = _pos getPos [3500,270];};
			};

			private _result = [[_vehPos select 0,_vehPos select 1,(_pos select 2) + 300],_dir,_vehType,_grp] call BIS_fnc_spawnVehicle;
			private _spawnedVeh = _result select 0;

			waitUntil {!isNull driver _spawnedVeh};
			_spawnedVeh flyInHeight 250;
			_spawnedVeh addEventHandler ["Killed",{
				params ["_unit", "_killer", "_instigator", "_useEffects"];
				private _sideOf = side (driver _unit);
				private _textLine = selectRandom [
					"Mayday mayday! We're going down!",
					"We're going down! Auto-rotating!",
					"I always knew this is how I'd go...",
					"I guess a captain goes down with his ship...",
					"We're hit! Going down!",
					"We're not making it to the LZ!"
				];

				private _sideName = [_sideOf] call BIS_fnc_sideName;
				[
					format ["%1 Airdrop Pilot",_sideName],
					_textLine
				] remoteExec ['BIS_fnc_showSubtitle',_sideOf];
				{
					deleteVehicle _x;
				}forEach (crew _unit);
			}];
			_grp setBehaviour "CARELESS";

			_spawnedVeh animateDoor [_doorAnim,1,true];
			private _textLine = selectRandom [
				"We're inbound with your supplies.",
				"Supplies are inbound, wait one.",
				"We're on our way with your supplies.",
				"Your package is being shipped."
			];
			private _sideName = [_sideOf] call BIS_fnc_sideName;
			[
				format ["%1 Airdrop Pilot",_sideName],
				_textLine
			] remoteExec ['BIS_fnc_showSubtitle',_sideOf];
			if(_sfx) then {
				private _radioChatter = selectRandom ["RadioAmbient2","RadioAmbient6","RadioAmbient8"];
				[[_radioChatter],{
					params ['_radioChatter'];
					switch (_radioChatter) do {
						case "RadioAmbient2": {playSound _radioChatter;};
						case "RadioAmbient6": {playSound _radioChatter; sleep 6; playSound "RadioAmbient2";};
						case "RadioAmbient8": {playSound _radioChatter;};
					};
				}] remoteExec ['spawn',0];
			};

			private _wayPointMove = _grp addWaypoint [[(_pos select 0),(_pos select 1),300],0];
			_wayPointMove setWaypointType "MOVE";
			private _nextWaypointPos = _pos getPos [6000,_dir];
			private _wayPointLeave = _grp addWaypoint [[(_nextWaypointPos select 0),(_nextWaypointPos select 1),300],0];
			_wayPointLeave setWaypointType "MOVE";

			waitUntil {(_spawnedVeh distance2D _pos) < 150};
			if(!alive _spawnedVeh) exitWith {
				sleep 120;
				deleteVehicle _spawnedVeh;
			};
			sleep 1.5;
			_textLine = selectRandom [
				"Supplies have been dropped.",
				"Supplies are coming down.",
				"Your supplies are on their way down.",
				"Watch out above! Your supplies are coming down."
			];
			[
				format ["%1 Airdrop Pilot",_sideName],
				_textLine
			] remoteExec ['BIS_fnc_showSubtitle',_sideOf];
			if(_sfx) then {
				_radioChatter = selectRandom ["RadioAmbient2","RadioAmbient6","RadioAmbient8"];
				[[_radioChatter],{
					params ['_radioChatter'];
					switch (_radioChatter) do {
						case "RadioAmbient2": {playSound _radioChatter;};
						case "RadioAmbient6": {playSound _radioChatter; sleep 6; playSound "RadioAmbient2";};
						case "RadioAmbient8": {playSound _radioChatter;};
					};
				}] remoteExec ['spawn',0];
			};

			private _dropPos = position _spawnedVeh getPos [10,getDir _spawnedVeh+180];
			private _para = createVehicle ["B_Parachute_02_F", [0,0,300], [], 0, ""];
			_para setPosATL [(_dropPos select 0),(_dropPos select 1),(getPosATL _spawnedVeh select 2)];
			private _veh = createVehicle [_dropLoad, [0,0,80], [], 0, ""];
			_veh attachTo [_para,[0,0,0]]; 

			WaitUntil {((((position _veh) select 2) < 0.6) || (isNil "_para"))};
			detach _veh;
			_veh SetVelocity [0,0,-5];           
			sleep 0.3;
			_veh setPos [(position _veh) select 0, (position _veh) select 1, 0.6];
			private _smoke = "SmokeShellRed" createVehicle position _veh;
			_smoke attachTo [_veh,[0,0,0]];
			private _light = "Chemlight_green" createVehicle position _veh;
			_light attachTo [_veh,[0,0,0]];
			detach _smoke;
			detach _light;
			if(_mode select 0 == 'arsenal') then {
				["AmmoboxInit",[_veh,true]] spawn BIS_fnc_arsenal;
			};
			if(_vehType == 'B_Heli_Transport_03_F') then {
				sleep 20;
				{
					deleteVehicle _x;
				} forEach crew _spawnedVeh;
				deleteVehicle _spawnedVeh;
			} else {

				{
					deleteVehicle _x;
				} forEach crew _spawnedVeh;
				deleteVehicle _spawnedVeh;
			};
		};

		MAZ_EZM_fnc_callAirdropModule = {
			["Call an Airdrop",[
				[
					"TOOLBOX",
					"Airdrop Type",
					[false,["Arsenal","Vehicle"]]
				],
				[
					"LIST",
					["Payload","Loaded vehicle in the airdrop, only applicable to VEHICLE airdrops."],
					[
						[],
						[
							"Hunter",
							"Hunter HMG",
							"Hunter GMG",
							"Ifrit",
							"Ifrit HMG",
							"Ifrit GMG",
							"Strider",
							"Strider HMG",
							"Strider GMG",
							"Prowler",
							"Prowler HMG",
							"Prowler AT",
							"Qilin",
							"Qilin Minigun",
							"Qilin AT",
							"AWC 302 Nyx (Recon)",
							"AWC 302 Nyx (Autocannon)",
							"AWC 302 Nyx (AT)",
							"AWC 302 Nyx (AA)",
							"AMV-7 Marshall",
							"Rhino",
							"Rhino MGS UP",
							"MSE-3 Marid",
							"AFV-4 Gorgon",
							"FV-720 Mora"
						],
						0
					]
				],
				[
					"LIST",
					["Direction","Direction the airdrop aircraft comes from."],
					[
						['NW','N','NE','E','SE','S','SW','W'],
						['NW','N','NE','E','SE','S','SW','W'],
						0
					]
				],
				[
					"LIST",
					["Airdrop Aircraft Type","The aircraft type that the airdrop will be carried in."],
					[
						['blackfish','huron','xian','mohawk'],
						["V-44X Blackfish","CH-67 Huron","Y-32 Xi'an","CH-49 Mohawk"],
						0,
						4
					]
				],
				[
					"SIDES",
					"Side of Airdrop",
					west
				],
				[
					"TOOLBOX:YESNO",
					["Radio SFX","Whether to play radio sound effects when the airdrop is called."],
					[false]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_type","_payloadType","_dir","_aircraft","_side","_radioSFX"];
				private _sideNew = [[_side]] call MAZ_EZM_fnc_getSidesFromString;
				_sideNew = _sideNew # 0;

				private _typeArray = [];
				if(_type) then {
					_typeArray pushBack 'Vehicle';
					switch (_payloadType) do {
						case 0: {_typeArray pushBack 'B_MRAP_01_F';};
						case 1: {_typeArray pushBack 'B_MRAP_01_hmg_F';};
						case 2: {_typeArray pushBack 'B_MRAP_01_gmg_F';};
						case 3: {_typeArray pushBack 'O_MRAP_02_F';};
						case 4: {_typeArray pushBack 'O_MRAP_02_hmg_F';};
						case 5: {_typeArray pushBack 'O_MRAP_02_gmg_F';};
						case 6: {_typeArray pushBack 'I_MRAP_03_F';};
						case 7: {_typeArray pushBack 'I_MRAP_03_hmg_F';};
						case 8: {_typeArray pushBack 'I_MRAP_03_gmg_F';};
						case 9: {_typeArray pushBack 'B_LSV_01_unarmed_F';};
						case 10: {_typeArray pushBack 'B_LSV_01_armed_F';};
						case 11: {_typeArray pushBack 'B_LSV_01_AT_F';};
						case 12: {_typeArray pushBack 'O_LSV_02_unarmed_F';};
						case 13: {_typeArray pushBack 'O_LSV_02_armed_F';};
						case 14: {_typeArray pushBack 'O_LSV_02_AT_F';};
						case 15: {_typeArray pushBack 'I_LT_01_scout_F';};
						case 16: {_typeArray pushBack 'I_LT_01_cannon_F';};
						case 17: {_typeArray pushBack 'I_LT_01_AT_F';};
						case 18: {_typeArray pushBack 'I_LT_01_AA_F';};
						case 19: {_typeArray pushBack 'B_APC_Wheeled_01_cannon_F';};
						case 20: {_typeArray pushBack 'B_AFV_Wheeled_01_cannon_F';};
						case 21: {_typeArray pushBack 'B_AFV_Wheeled_01_up_cannon_F';};
						case 22: {_typeArray pushBack 'O_APC_Wheeled_02_rcws_v2_F';};
						case 23: {_typeArray pushBack 'I_APC_Wheeled_03_cannon_F';};
						case 24: {_typeArray pushBack 'I_APC_tracked_03_cannon_F';};
					};
				} else {
					_typeArray pushBack 'Arsenal';
				};

				[_args,_typeArray,_dir,_aircraft,_sideNew,_radioSFX] spawn MAZ_airDropSupportModule; 
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[] call MAZ_EZM_fnc_getScreenPosition] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_heliEvacExec = {
			params ["_pos","_direction","_sideOf","_type","_destination",["_passengerNeeded",3]];
			private ["_vehType","_crewCount","_dir","_vehPos","_heliPad1","_heliPad2","_wayPointPickup","_wayPointMove","_wayPointReturn","_pilot","_textLine","_byePos"];
			private _grp = createGroup [_sideOf,true];
			private _direction = toLower _direction;
			private _type = toLower _type;
			switch (_type) do {
				case "hummingbird": {_vehType = "B_Heli_Light_01_F"; _crewCount = _passengerNeeded + 2;};
				case "ghosthawk": {_vehType = "B_Heli_Transport_01_F"; _crewCount = _passengerNeeded + 4;};
				case "ghosthawk ctrg": {if(worldName == 'Tanoa') then {_vehType = "B_CTRG_Heli_Transport_01_tropic_F";} else {_vehType = "B_CTRG_Heli_Transport_01_sand_F";}; _crewCount = _passengerNeeded + 4;};
				case "huron": {_vehType = "B_Heli_Transport_03_F"; _crewCount = _passengerNeeded + 4;};
				case "orca": {_vehType = "O_Heli_Light_02_unarmed_F"; _crewCount = _passengerNeeded + 2;};
				case "taru": {_vehType = "O_Heli_Transport_04_F"; _crewCount = _passengerNeeded + 3;};
				case "hellcat": {_vehType = "I_Heli_light_03_unarmed_F"; _crewCount = _passengerNeeded + 2;};
				case "mohawk": {_vehType = "I_Heli_Transport_02_F"; _crewCount = _passengerNeeded + 2;};
			};
			switch (_direction) do {
				case "north": {_dir = 180; _vehPos = _pos getPos [2000,0];};
				case "south": {_dir = 0; _vehPos = _pos getPos [2000,180];};
				case "east": {_dir = 270; _vehPos = _pos getPos [2000,90];};
				case "west": {_dir = 90; _vehPos = _pos getPos [2000,270];};
			};
			
			private _result = [[_vehPos select 0,_vehPos select 1,100],_dir,_vehType,_grp] call BIS_fnc_spawnVehicle;
			private _spawnedVeh = _result select 0;

			waitUntil {!isNull driver _spawnedVeh};
			_grp setBehaviour "CARELESS";
			{
				_x allowDamage false;
			}forEach (crew _spawnedVeh);

			_spawnedVeh addEventHandler ["Killed",{
				params ["_unit", "_killer", "_instigator", "_useEffects"];
				private _sideOf = side (driver _unit);
				private _textLine = selectRandom [
					"Mayday mayday! We're going down!",
					"We're going down! Auto-rotating!",
					"I always knew this is how I'd go...",
					"I guess a captain goes down with his ship...",
					"We're hit! Going down!",
					"We're not making it to the LZ!"
				];

				private _sideName = [_sideOf] call BIS_fnc_sideName;
				[
					format ["%1 Evac Pilot",_sideName],
					_textLine
				] remoteExec ['BIS_fnc_showSubtitle',_sideOf];
				{
					deleteVehicle _x;
				}forEach (crew _unit);
			}];

			private _heliPad1 = "Land_HelipadEmpty_F" createVehicle _pos;
			_waypointPickup = _grp addWaypoint [position _heliPad1,0];
			_waypointPickup setWaypointType "SCRIPTED";
			_waypointPickup setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";

			private _textLine = selectRandom [
				"Evac is on the way, hang tight.",
				"Location received, evac is inbound.",
				"Coordinates received, your ride is on the way.",
				"Your Uber driver is on their way.",
				"We're on our way, stay put."
			];

			private _sideName = [_sideOf] call BIS_fnc_sideName;
			[
				format ["%1 Evac Pilot",_sideName],
				_textLine
			] remoteExec ['BIS_fnc_showSubtitle',_sideOf];

			waitUntil {isTouchingGround _spawnedVeh};

			if(_vehType == "B_Heli_Transport_01_F" || _vehType == "B_CTRG_Heli_Transport_01_tropic_F" || _vehType == "B_CTRG_Heli_Transport_01_sand_F") then {
				_spawnedVeh animateDoor ["Door_L",1,false]; _spawnedVeh animateDoor ["Door_R",1,false];
				_spawnedVeh lockTurret [[1],true];
				_spawnedVeh lockTurret [[2],true];
			};
			if(_vehType == "B_Heli_Transport_03_F") then {
				_spawnedVeh animateDoor ['Door_rear_source',1,false];
				_spawnedVeh lockTurret [[1],true];
				_spawnedVeh lockTurret [[2],true];
			};
			if(_vehType == "O_Heli_Light_02_unarmed_F") then {
				_spawnedVeh animate ["dvere1_posunZ",1]; _spawnedVeh animate ["dvere2_posunZ",1];
			};

			if(!alive _spawnedVeh) exitWith {
				sleep 120;
				deleteVehicle _spawnedVeh;
				deleteVehicle _heliPad1;
			};
			_textLine = selectRandom [
				"Your Uber has arrived.",
				"Let's get you guys outta here.",
				"We're here, load up.",
				"We haven't got all day, get in the heli.",
				"Touchdown. Everyone, load up.",
				"Pile in, there's plenty of space for all of you."
			];
			[
				format ["%1 Evac Pilot",_sideName],
				_textLine
			] remoteExec ['BIS_fnc_showSubtitle',_sideOf];

			waitUntil {count crew _spawnedVeh >= _crewCount};
			
			_textLine = selectRandom [
				"Prepping for takeoff, if you wanna get out of here get loaded up.",
				"We're leaving in 20 seconds, hurry up.",
				"Get a move on, we're leaving in 20 seconds.",
				"We're not waiting much longer, leaving in 20 seconds.",
				"In 20 seconds we're RTB, hurry up.",
				"We want our RnR, if you're not here in 20 seconds you'll be stuck out here!"
			];
			[
				format ["%1 Evac Pilot",_sideName],
				_textLine
			] remoteExec ['BIS_fnc_showSubtitle',_sideOf];
			sleep 20;
			deleteVehicle _heliPad1;
			if(_vehType == "B_Heli_Transport_01_F") then {
				_spawnedVeh animateDoor ["Door_L",0,false]; _spawnedVeh animateDoor ["Door_R",0,false];
			};
			if(_vehType == "B_Heli_Transport_03_F") then {
				_spawnedVeh animateDoor ['Door_rear_source',0,false];
			};
			if(_vehType == "O_Heli_Light_02_unarmed_F") then {
				_spawnedVeh animate ["dvere1_posunZ",0]; _spawnedVeh animate ["dvere2_posunZ",0];
			};
			_textLine = selectRandom [
				"Alright, lets get outta here.",
				"Dusting off now. Hold on to something.",
				"And we're off. Fasten your seatbelts.",
				"We're outta here. Hope you guys aren't prone to being motion sick.",
				"Taking off now. Don't fall off now.",
				"We're heading out. And, please, don't touch the rotors blades, we've had... accidents."
			];
			[
				format ["%1 Evac Pilot",_sideName],
				_textLine
			] remoteExec ['BIS_fnc_showSubtitle',_sideOf];
			private _heliPad2 = "Land_HelipadEmpty_F" createVehicle _destination;
			_wayPointMove = _grp addWaypoint [[(getPosATL _heliPad2 select 0),(getPosATL _heliPad2 select 1),(getPosATL _heliPad2 select 2)+40],0];
			_wayPointMove setWaypointType "MOVE";
			sleep 5;
			private _waypointReturn = _grp addWaypoint [position _heliPad2,0];
			_waypointReturn setWaypointType "SCRIPTED";
			_waypointReturn setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";
			waitUntil {isTouchingGround _spawnedVeh && _spawnedVeh distance _heliPad2 < 200};
			if(_vehType == "B_Heli_Transport_01_F") then {
				_spawnedVeh animateDoor ["Door_L",1,false]; _spawnedVeh animateDoor ["Door_R",1,false];
			};
			if(_vehType == "B_Heli_Transport_03_F") then {
				_spawnedVeh animateDoor ['Door_rear_source',1,false];
			};
			if(_vehType == "O_Heli_Light_02_unarmed_F") then {
				_spawnedVeh animate ["dvere1_posunZ",1]; _spawnedVeh animate ["dvere2_posunZ",1];
			};
			_textLine = selectRandom [
				"Hope you enjoyed the ride.",
				"Oh, now that landing was butter!",
				"Thanks for riding with us, if you'd like you can leave us a tip.",
				"And to think this is my first day flying!",
				"Thanks for giving us something to do.",
				"Now get out of my bird."
			];
			[
				format ["%1 Evac Pilot",_sideName],
				_textLine
			] remoteExec ['BIS_fnc_showSubtitle',_sideOf];
			switch (_type) do {
				case "hummingbird": {waitUntil {count crew _spawnedVeh == 2};};
				case "ghosthawk": {waitUntil {count crew _spawnedVeh == 4};};
				case "huron": {waitUntil {count crew _spawnedVeh == 4};};
				case "orca": {waitUntil {count crew _spawnedVeh == 2};};
				case "taru": {waitUntil {count crew _spawnedVeh == 3};};
				case "hellcat": {waitUntil {count crew _spawnedVeh == 2};};
				case "mohawk": {waitUntil {count crew _spawnedVeh == 2};};
			};
			deleteVehicle _heliPad2;
			if(_vehType == "B_Heli_Transport_01_F") then {
				_spawnedVeh animateDoor ["Door_L",0,false]; _spawnedVeh animateDoor ["Door_R",0,false];
			};
			if(_vehType == "B_Heli_Transport_03_F") then {
				_spawnedVeh animateDoor ['Door_rear_source',0,false];
			};
			if(_vehType == "O_Heli_Light_02_unarmed_F") then {
				_spawnedVeh animate ["dvere1_posunZ",0]; _spawnedVeh animate ["dvere2_posunZ",0];
			};
			private _byePos = _spawnedVeh getPos [1500,(getDir _spawnedVeh)];
			private _wayPointLeave = _grp addWaypoint [[(_byePos select 0),(_byePos select 1),60],0];
			_wayPointLeave setWaypointType "MOVE";
			sleep 50;
			{
				deleteVehicle _x;
			} forEach crew _spawnedVeh;
			deleteVehicle _spawnedVeh;
		};

		MAZ_EZM_fnc_callEvacModule = {
			["Call Helicopter Evac",[
				[
					"COMBO",
					"Direction of Evac",
					[
						[],
						["N","S","E","W"],
						0
					]
				],
				[
					"SIDES",
					"Side of Evac",
					west
				],
				[
					"LIST",
					"Helicopter Type",
					[
						["Hummingbird","Orca","Ghosthawk","Ghosthawk CTRG","Hellcat","Huron","Mohawk","Taru"],
						["MH-9 Hummingbird","PO-30 Orca","UH-80 Ghosthawk","UH-80 Ghosthawk (CTRG)","WY-55 Hellcat (Unarmed)","CH-67 Huron","CH-49 Mohawk","Mi-290 Taru"],
						0
					]
				],
				[
					"SLIDER",
					["Number of Passengers","The number of passengers required before the AI will take off and move to the destination."],
					[1,8,3]
				]
			],{
				params ["_values","_pos","_display"];
				_values params ["_directionIndex","_side","_helicopterType","_numToLeave"];
				_display closeDisplay 1;
				private _dir = switch (_directionIndex) do {
					case 0: {'North'};
					case 1: {'South'};
					case 2: {'East'};
					case 3: {'West'};
				};
				private _sideNew = [[_side]] call MAZ_EZM_fnc_getSidesFromString;
				_sideNew = _sideNew # 0;
				private _heliParams = [_pos,_dir,_sideNew,_helicopterType,[],_numToLeave];

				private _helipadMarker = createVehicle ["Land_HelipadEmpty_F",_pos,[],0,"CAN_COLLIDE"];

				["Helicopter Destination",{
					params ["_objects","_position","_args","_shift","_ctrl","_alt"];
					deleteVehicle _units;

					_args set [4,_position];
					_args spawn MAZ_EZM_fnc_heliEvacExec;
				},_helipadMarker,_heliParams] call MAZ_EZM_fnc_selectSecondaryPosition;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[] call MAZ_EZM_fnc_getScreenPosition] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_spawnReinforcements = {
			private _fnc_processParams = {
				params ["_pos","_side","_dir","_numOfUnits","_atCount","_endPos"];
				private _sideType = switch (_side) do {
					case 0: {"NATO"};
					case 1: {"CTRG"};
					case 2: {"CSAT"};
					case 3: {"VIPER"};
					case 4: {"SPETZ"};
					case 5: {"AAF"};
					case 6: {"LDF"};
					case 7: {"FIA"};
					case 8: {"SYNDIK"};
				};
				private _heliType = switch (_side) do {
					case 0: {"B_Heli_Transport_01_F"};
					case 1: {"B_Heli_Transport_01_F"};
					case 2: {"O_Heli_Light_02_unarmed_F"};
					case 3: {"O_Heli_Light_02_unarmed_F"};
					case 4: {"O_Heli_Light_02_unarmed_F"};
					case 5: {"I_Heli_Transport_02_F"};
					case 6: {"I_Heli_Transport_02_F"};
					case 7: {"O_Heli_Light_02_unarmed_F"};
					case 8: {"O_Heli_Light_02_unarmed_F"};
				};
				_side = switch (_side) do {
					case 0: {west};
					case 1: {west};
					case 2: {east};
					case 3: {east};
					case 4: {east};
					case 5: {independent};
					case 6: {independent};
					case 7: {independent};
					case 8: {independent};
				};
				_dir = switch (_dir) do {
					case 0: {0};
					case 1: {180};
					case 2: {90};
					case 3: {270};
				};
				private _startPos = _pos getPos [5000,_dir];
				_numOfUnits = _numOfUnits - _atCount - 1;

				[_startPos,_heliType,_pos,_side,_sideType,_dir,_numOfUnits,_atCount,_endPos]
			};
			(_this call _fnc_processParams) params ["_startPos","_heliType","_pos","_side","_sideType","_dir","_numOfUnits","_atCount","_endPos"];
			_startPos set [2,150];
			private _grp = createGroup [_side,true];
			private _result = [_startPos,_dir+180,_heliType,_grp] call BIS_fnc_spawnVehicle;
			private _spawnedVeh = _result # 0;

			waitUntil{!isNull driver _spawnedVeh};
			_grp setBehaviour "CARELESS";
			[_spawnedVeh,2] remoteExec ['lock'];

			private _heliParams = switch (_heliType) do {
				case "B_Heli_Transport_01_F": {
					[4,["Door_L","Door_R"]]
				};
				case "O_Heli_Light_02_unarmed_F": {
					[2,["dvere1_posunZ","dvere2_posunZ"]]
				};
				case "I_Heli_Transport_02_F": {
					[2,["Door_Back_L","Door_Back_R"]]
				};
			};
			_heliParams params ["_crewCount","_doorAnims"];

			private _fnc_getUnits = {
				params ["_side","_sideType","_numOfUnits","_atCount"];
				private _aridMaps = ["Altis","Malden","Stratis","VR"];
				private _tropicMaps = ["Enoch","Tanoa"];
				private _world = worldName;
				private _return = switch (_sideType) do {
					case "NATO": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = "B_Soldier_SL_F";
						private _unitRandomType = [
							"B_Soldier_A_F",
							"B_Soldier_AR_F",
							"B_Medic_F",
							"B_Soldier_GL_F",
							"B_Soldier_M_F",
							"B_Soldier_F"
						];
						private _atTypes = [
							"B_Soldier_LAT_F",
							"B_Soldier_LAT2_F"
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};
						if(_world in _tropicMaps) then {
							{
								private _newType = _x insert [1,"_W"];
								_unitList set [_forEachIndex,_newType];
							}forEach _unitList;
							_SLType = _SLType insert [1,"_W"];
						};

						private _groupLeader = _unitGroup createUnit [_SLType,[0,0,0],[],0,"FORM"];
						_unitGroup selectLeader _groupLeader;
						{
							_unitGroup createUnit [_x,[0,0,0],[],0,"FORM"];
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]

					};
					case "CTRG": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = ["B_Soldier_SL_F",[["arifle_SPAR_02_blk_F","","acc_pointer_IR","optic_Hamr",["150Rnd_556x45_Drum_Mag_F",150],[],"bipod_01_F_blk"],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_3",[["FirstAidKit",1],["Chemlight_green",1,1],["150Rnd_556x45_Drum_Mag_F",1,150]]],["V_PlateCarrierH_CTRG",[["16Rnd_9x21_Mag",2,16],["HandGrenade",2,1],["B_IR_Grenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1],["SmokeShellBlue",1,1],["SmokeShellOrange",1,1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",6,30]]],[],"H_HelmetSpecB_blk","G_Tactical_Black",["Binocular","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]];
						private _unitRandomType = [
							["B_Soldier_A_F",[["arifle_SPAR_01_blk_F","","acc_pointer_IR","optic_Aco",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_1",[["FirstAidKit",1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",3,30]]],["V_PlateCarrierL_CTRG",[["16Rnd_9x21_Mag",2,16],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",5,30]]],["B_Carryall_khk",[["FirstAidKit",4],["NLAW_F",1,1],["HandGrenade",2,1],["MiniGrenade",2,1],["1Rnd_HE_Grenade_shell",3,1],["3Rnd_HE_Grenade_shell",1,3],["10Rnd_338_Mag",2,10],["20Rnd_762x51_Mag",2,20]]],"H_HelmetB_snakeskin","G_Tactical_Black",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]],
							["B_Soldier_AR_F",[["LMG_03_F","","acc_pointer_IR","optic_Holosight_blk_F",["200Rnd_556x45_Box_F",200],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_2",[["FirstAidKit",1],["HandGrenade",1,1],["SmokeShell",1,1],["SmokeShellGreen",1,1],["Chemlight_green",1,1]]],["V_PlateCarrierH_CTRG",[["16Rnd_9x21_Mag",2,16],["Chemlight_green",1,1],["200Rnd_556x45_Box_F",2,200]]],[],"H_HelmetB_camo","G_Tactical_Clear",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]],
							["B_Medic_F",[["arifle_SPAR_01_blk_F","","acc_pointer_IR","optic_Holosight_blk_F",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_1",[["FirstAidKit",1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",3,30]]],["V_PlateCarrierH_CTRG",[["16Rnd_9x21_Mag",2,16],["SmokeShell",1,1],["SmokeShellGreen",1,1],["SmokeShellBlue",1,1],["SmokeShellOrange",1,1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",5,30]]],["B_AssaultPack_rgr_Medic",[["Medikit",1],["FirstAidKit",10]]],"H_HelmetB_light_snakeskin","G_Respirator_blue_F",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]],
							["B_Soldier_GL_F",[["arifle_SPAR_01_GL_blk_F","","","optic_Holosight_blk_F",["30Rnd_556x45_Stanag",30],["1Rnd_HE_Grenade_shell",1],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_1",[["FirstAidKit",2],["Chemlight_green",1,1]]],["V_PlateCarrierH_CTRG",[["16Rnd_9x21_Mag",2,16],["30Rnd_556x45_Stanag",5,30],["1Rnd_HE_Grenade_shell",4,1],["1Rnd_Smoke_Grenade_shell",2,1],["HandGrenade",2,1],["SmokeShell",2,1]]],[],"H_HelmetSpecB_blk","G_Tactical_Clear",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]],
							["B_Soldier_M_F",[["arifle_SPAR_03_blk_F","","acc_pointer_IR","optic_DMS",["20Rnd_762x51_Mag",20],[],"bipod_01_F_blk"],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_1",[["FirstAidKit",1],["Chemlight_green",1,1]]],["V_PlateCarrierL_CTRG",[["16Rnd_9x21_Mag",2,16],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1],["Chemlight_green",1,1],["20Rnd_762x51_Mag",3,20]]],[],"H_HelmetB_camo","G_Bandanna_khk",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]],
							["B_Soldier_F",[["arifle_SPAR_01_blk_F","","acc_pointer_IR","optic_Aco",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_1",[["FirstAidKit",1],["Chemlight_green",1,1]]],["V_PlateCarrierL_CTRG",[["16Rnd_9x21_Mag",2,16],["SmokeShell",1,1],["SmokeShellGreen",1,1],["Chemlight_green",1,1],["HandGrenade",2,1],["30Rnd_556x45_Stanag",5,30]]],[],"H_HelmetB_snakeskin","G_Tactical_Clear",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]]
						];
						private _atTypes = [
							["B_Soldier_LAT_F",[["arifle_SPAR_01_blk_F","","acc_pointer_IR","optic_Holosight_blk_F",["30Rnd_556x45_Stanag",30],[],""],["launch_NLAW_F","","","",["NLAW_F",1],[],""],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_1",[["FirstAidKit",1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",3,30]]],["V_PlateCarrierH_CTRG",[["16Rnd_9x21_Mag",2,16],["SmokeShell",1,1],["SmokeShellGreen",1,1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",3,30]]],["B_AssaultPack_rgr_LAT",[["NLAW_F",2,1]]],"H_HelmetB_black","G_Tactical_Clear",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]],
							["B_Soldier_LAT2_F",[["arifle_SPAR_01_blk_F","","acc_pointer_IR","optic_Holosight_blk_F",["30Rnd_556x45_Stanag",30],[],""],["launch_MRAWS_green_F","","","",["MRAWS_HEAT_F",1],[],""],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_1",[["FirstAidKit",1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",3,30]]],["V_PlateCarrierH_CTRG",[["16Rnd_9x21_Mag",2,16],["SmokeShell",1,1],["SmokeShellGreen",1,1],["Chemlight_green",1,1],["30Rnd_556x45_Stanag",3,30]]],["B_AssaultPack_rgr_LAT2",[["MRAWS_HEAT_F",2,1]]],"H_HelmetB_black","G_Tactical_Clear",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]]]
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};

						private _groupLeader = _unitGroup createUnit [_SLType # 0,[0,0,0],[],0,"FORM"];
						_groupLeader setUnitLoadout (_SLType # 1);
						_unitGroup selectLeader _groupLeader;
						{
							_x params ["_unitType","_loadout"];
							private _unit = _unitGroup createUnit [_unitType,[0,0,0],[],0,"FORM"];
							_unit setUnitLoadout _loadout;
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]
					};
					case "CSAT": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = "O_Soldier_SL_F";
						private _unitRandomType = [
							"O_Soldier_A_F",
							"O_Soldier_AR_F",
							"O_Medic_F",
							"O_Soldier_GL_F",
							"O_Soldier_M_F",
							"O_Soldier_F"
						];
						private _atTypes = [
							"O_Soldier_LAT_F"
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};
						if(_world in _tropicMaps) then {
							{
								private _newType = _x insert [1,"_T"];
								_unitList set [_forEachIndex,_newType];
							}forEach _unitList;
							_SLType = _SLType insert [1,"_T"];
						};

						private _groupLeader = _unitGroup createUnit [_SLType,[0,0,0],[],0,"FORM"];
						_unitGroup selectLeader _groupLeader;
						{
							_unitGroup createUnit [_x,[0,0,0],[],0,"FORM"];
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]
					};
					case "VIPER": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = "O_V_Soldier_TL_hex_F";
						private _unitRandomType = [
							"O_V_Soldier_hex_F",
							"O_V_Soldier_M_hex_F",
							"O_V_Soldier_Medic_hex_F"
						];
						private _atTypes = [
							"O_V_Soldier_LAT_hex_F"
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};
						if(_world in _tropicMaps) then {
							{
								private _newType = _x insert [(_x find "hex_F"),"g"];
								_unitList set [_forEachIndex,_newType];
							}forEach _unitList;
						};

						private _groupLeader = _unitGroup createUnit [_SLType,[0,0,0],[],0,"FORM"];
						_unitGroup selectLeader _groupLeader;
						{
							_unitGroup createUnit [_x,[0,0,0],[],0,"FORM"];
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]
					};
					case "SPETZ": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = "O_R_Soldier_TL_F";
						private _unitRandomType = [
							"O_R_JTAC_F",
							"O_R_Soldier_AR_F",
							"O_R_Medic_F",
							"O_R_Soldier_GL_F",
							"O_R_Soldier_M_F"
						];
						private _atTypes = [
							"O_R_Soldier_LAT_F"
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};

						private _groupLeader = _unitGroup createUnit [_SLType,[0,0,0],[],0,"FORM"];
						_unitGroup selectLeader _groupLeader;
						{
							_unitGroup createUnit [_x,[0,0,0],[],0,"FORM"];
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]
					};
					case "AAF": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = "I_Soldier_SL_F";
						private _unitRandomType = [
							"I_Soldier_A_F",
							"I_Soldier_AR_F",
							"I_Medic_F",
							"I_Soldier_GL_F",
							"I_Soldier_M_F",
							"I_Soldier_F"
						];
						private _atTypes = [
							"I_Soldier_LAT_F",
							"I_Soldier_LAT2_F"
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};

						private _groupLeader = _unitGroup createUnit [_SLType,[0,0,0],[],0,"FORM"];
						_unitGroup selectLeader _groupLeader;
						{
							_unitGroup createUnit [_x,[0,0,0],[],0,"FORM"];
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]
					};
					case "LDF": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = "I_E_Soldier_TL_F";
						private _unitRandomType = [
							"I_E_Soldier_A_F",
							"I_E_Soldier_AR_F",
							"I_E_Medic_F",
							"I_E_Soldier_GL_F",
							"I_E_Soldier_M_F",
							"I_E_Soldier_F"
						];
						private _atTypes = [
							"I_E_Soldier_LAT_F",
							"I_E_Soldier_LAT2_F"
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};

						private _groupLeader = _unitGroup createUnit [_SLType,[0,0,0],[],0,"FORM"];
						_unitGroup selectLeader _groupLeader;
						{
							_unitGroup createUnit [_x,[0,0,0],[],0,"FORM"];
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]
					};
					case "FIA": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = "I_G_Soldier_SL_F";
						private _unitRandomType = [
							"I_G_Soldier_A_F",
							"I_G_Soldier_AR_F",
							"I_G_Medic_F",
							"I_G_Soldier_GL_F",
							"I_G_Soldier_M_F",
							"I_G_Soldier_F"
						];
						private _atTypes = [
							"I_G_Soldier_LAT_F",
							"I_G_Soldier_LAT2_F"
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};

						private _groupLeader = _unitGroup createUnit [_SLType,[0,0,0],[],0,"FORM"];
						_unitGroup selectLeader _groupLeader;
						{
							_unitGroup createUnit [_x,[0,0,0],[],0,"FORM"];
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]
					};
					case "SYNDIK": {
						private _unitGroup = createGroup [_side,true];
						private _SLType = "I_C_Soldier_Para_2_F";
						private _unitRandomType = [
							"I_C_Soldier_Para_7_F",
							"I_C_Soldier_Para_3_F",
							"I_C_Soldier_Para_4_F",
							"I_C_Soldier_Para_6_F",
							"I_C_Soldier_Para_8_F",
							"I_C_Soldier_Para_1_F"
						];
						private _atTypes = [
							"I_C_Soldier_Para_5_F"
						];

						private _unitList = [];
						for "_i" from 0 to (_numOfUnits - 1) do {
							_unitList pushBack (selectRandom _unitRandomType);
						};
						for "_i" from 0 to (_atCount - 1) do {
							_unitList pushBack (selectRandom _atTypes);
						};

						private _groupLeader = _unitGroup createUnit [_SLType,[0,0,0],[],0,"FORM"];
						_unitGroup selectLeader _groupLeader;
						{
							_unitGroup createUnit [_x,[0,0,0],[],0,"FORM"];
						}forEach _unitList;

						[_unitGroup,(units _unitGroup)]
					};
				};
				_return
			};
			([_side,_sideType,_numOfUnits,_atCount] call _fnc_getUnits) params ["_group","_units"];
			{
				_x moveInCargo _spawnedVeh;
				_x setUnitPos "UP";
			}forEach _units;

			private _heliPad1 = "Land_HelipadEmpty_F" createVehicle _pos;
			private _waypointPickup = _grp addWaypoint [position _heliPad1,0];
			_waypointPickup setWaypointType "TR UNLOAD";

			private _wayPointGetOut = _group addWaypoint [_pos,0];
			_wayPointGetOut setWaypointType "GETOUT";

			waitUntil {isTouchingGround _spawnedVeh};

			if(_heliType == "O_Heli_Light_02_unarmed_F") then {
				{
					_spawnedVeh animate [_x,1];
				}forEach _doorAnims;
			} else {
				{
					_spawnedVeh animateDoor [_x,1,false];
				}forEach _doorAnims;
			};

			sleep 1.5;
			commandGetOut _units;

			waitUntil {count (crew _spawnedVeh) <= _crewCount};

			if(_heliType == "O_Heli_Light_02_unarmed_F") then {
				{
					_spawnedVeh animate [_x,0];
				}forEach _doorAnims;
			} else {
				{
					_spawnedVeh animateDoor [_x,0,false];
				}forEach _doorAnims;
			};

			private _moveWaypoint = _group addWaypoint [_endPos,0];
			_moveWaypoint setWaypointType "SAD";
			_moveWaypoint setWaypointCombatMode "YELLOW";
			_moveWaypoint setWaypointBehaviour "AWARE";
			_moveWaypoint setWaypointSpeed "FULL";

			sleep 1.5;

			private _wayPointHeliLeave = _grp addWayPoint [_startPos,0];
			_wayPointHeliLeave setWayPointType "MOVE";
			sleep 50;
			{
				deleteVehicle _x;
			} forEach crew _spawnedVeh;
			deleteVehicle _spawnedVeh;
			deleteVehicle _heliPad1;
		};

		MAZ_EZM_fnc_callReinforcements = {
			["Spawn Reinforcements",[
				[
					"COMBO",
					"Side of Reinforcements",
					[
						[],
						[
							["NATO (BLUFOR)","","A3\UI_F\data\Map\Markers\Flags\NATO_ca.paa"],
							["CTRG (BLUFOR)","","A3\UI_F\data\Map\Markers\Flags\CTRG_ca.paa"],
							["CSAT (OPFOR)","","A3\UI_F\data\Map\Markers\Flags\CSAT_ca.paa"],
							["Viper (OPFOR)","","A3\UI_F\data\Map\Markers\Flags\Viper_ca.paa"],
							["Spetznaz (OPFOR)","","A3\UI_F_Enoch\data\CfgMarkers\Spetsnaz_ca.paa"],
							["AAF (INDEPENDENT)","","A3\UI_F\data\Map\Markers\Flags\AAF_ca.paa"],
							["LDF (INDEPENDENT)","","A3\UI_F_Enoch\data\CfgMarkers\LDF_ca.paa"],
							["FIA (INDEPENDENT)","","A3\UI_F\data\Map\Markers\Flags\FIA_ca.paa"],
							["Syndicat (INDEPENDENT)","","A3\UI_F\data\Map\Markers\Flags\syndicat_ca.paa"]
						],
						0
					]
				],
				[
					"COMBO",
					"Direction of Reinforcements",
					[
						[],
						[
							"N",
							"S",
							"E",
							"W"
						],
						0
					]
				],
				[
					"SLIDER",
					["Number of Units","The number of units that will be spawned as reinforcements."],
					[1,8,5]
				],
				[
					"SLIDER",
					["Number of AT Units","The number of units that will be spawned as reinforcements."],
					[0,2,1]
				]
			],{
				params ["_values","_pos","_display"];
				_values params ["_sideReinforcements","_dir","_numOfUnits","_atCount"];
				_display closeDisplay 1;
				
				private _reinforcementsParams = [_pos,_sideReinforcements,_dir,_numOfUnits,_atCount,[]];
				private _helipadMarker = createVehicle ["Land_HelipadEmpty_F",_pos,[],0,"CAN_COLLIDE"];

				["Reinforcements Destination on Foot",{
					params ["_objects","_position","_args","_shift","_ctrl","_alt"];
					deleteVehicle _units;
					_args set [5,_position];
					_args spawn MAZ_EZM_fnc_spawnReinforcements;
				},_helipadMarker,_reinforcementsParams] call MAZ_EZM_fnc_selectSecondaryPosition;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[] call MAZ_EZM_fnc_getScreenPosition] call MAZ_EZM_fnc_createDialog;
		};

	comment "Arsenal";

		MAZ_EZM_fnc_createArsenalModule = {
			params ["_entity"];
			private _arsenalObject = nil;
			if(!isNull _entity) then {
				_arsenalObject = _entity;
			} else {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				_arsenalObject = createVehicle ["B_supplyCrate_F",_pos,[],0,"CAN_COLLIDE"];
			};
			[_arsenalObject] call MAZ_EZM_fnc_addObjectToInterface;
			
			clearItemCargoGlobal _arsenalObject;
			clearWeaponCargoGlobal _arsenalObject;
			clearMagazineCargoGlobal _arsenalObject;
			clearBackpackCargoGlobal _arsenalObject;

			private _secondObject = "Land_HelipadEmpty_F" createVehicle position _arsenalObject;
			_secondObject setPos (getPos _arsenalObject);
			[_secondObject,_arsenalObject] call BIS_fnc_attachToRelative;
			_arsenalObject setVariable ['attachedObjArsenal',_secondObject,true];

			private _thirdObject = "Land_HelipadEmpty_F" createVehicle position _arsenalObject;
			_thirdObject setPos (getPos _arsenalObject);
			[_thirdObject,_arsenalObject] call BIS_fnc_attachToRelative;
			_arsenalObject setVariable ['attachedObjArsenal2',_thirdObject,true];
			[
				_arsenalObject,
				[
					"<t color='#FFFFFF' size='0.9'><img image='a3\ui_f\data\logos\a_64_ca.paa'></img><t color='#1a7e00' size='1'> Open Full Arsenal</t>",
					{
						params ["_target", "_caller", "_actionId", "_arguments"];
						["Preload"] call BIS_fnc_arsenal;
						["Open", true] call BIS_fnc_arsenal;
						showChat true;
						playSound 'addItemOk';
					},
					nil,
					6,
					true,
					true,
					"",
					"_target distance _this < 6"
				]
			] remoteExec ['addAction',0,_arsenalObject];
			[
				_arsenalObject,
				[
					"<t color='#FFFFFF' size='1'><img image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_gear_ca.paa'></img><t color='#1a7e00' size='1'> Save Respawn Loadout</t>",
					{
						params ["_target", "_caller", "_actionId", "_arguments"];
						if(!isNil "MAZ_customArsenalRespawnEH") then {
							player removeEventHandler ["Respawn",MAZ_customArsenalRespawnEH];
						};
						MAZ_customArsenalRespawnEH = player addEventHandler ["Respawn",{
							[] spawn {
								private _unitLoadout = player getVariable 'MAZ_customLoadoutFromModule';
								if(!isNil "_unitLoadout") then {
									if(count (_unitLoadout select 1) != 0) then {
										_unitLoadout set [1,[]];
										titleText [ "<t color='#004c99' size='1.5'>Arsenal</t><t color='#FFFFFF' size='1.5'>: You lost your launcher during the respawn. You can get a new one at an arsenal.</t>","PLAIN DOWN",2,true,true];
									};
									player setUnitLoadout _unitLoadout;
									systemChat "[ Enhanced Zeus Modules ] : Respawn loadout applied.";
									playSound 'addItemOk';
								};
							};
						}];
						[player,"PutDown"] remoteExec ["playAction",0];
						player setVariable ['MAZ_customLoadoutFromModule',getUnitLoadout player];
						playSound 'addItemOk';
						systemChat "[ Enhanced Zeus Modules ] : Respawn loadout saved.";
					},
					nil,
					6,
					true,
					true,
					"",
					"_target distance _this < 6"
				]
			] remoteExec ['addAction',0,_secondObject];
			[
				_arsenalObject,
				[
					"<t color='#FFFFFF' size='1'><img image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_gear_ca.paa'></img><t color='#1a7e00' size='1'> Get Saved Loadout</t>",
					{
						params ["_target", "_caller", "_actionId", "_arguments"];
						[player,"PutDown"] remoteExec ["playAction",0];
						private _loadout = player getVariable ['MAZ_customLoadoutFromModule',getUnitLoadout player];
						player setUnitLoadout _loadout;
						playSound 'addItemOk';
						systemChat "[ Enhanced Zeus Modules ] : Saved loadout re-equipped.";
					},
					nil,
					6,
					true,
					true,
					"",
					"_target distance _this < 6 && (count (player getVariable ['MAZ_customLoadoutFromModule',[]]) != 0)"
				]
			] remoteExec ['addAction',0,_thirdObject];
			_arsenalObject addEventHandler ["Deleted", {
				params ["_entity"];
				private _secondObject = _entity getVariable 'attachedObjArsenal';
				private _thirdObject = _entity getVariable 'attachedObjArsenal2';
				deleteVehicle _secondObject;
				deleteVehicle _thirdObject;
			}];

			["Full Arsenal Created.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};


		if (M9SD_serverEZM) then 
		{
			JAM_EZM_fnc_createAIOArsenalModule = 
			{
				params [['_entity', objnull]];
				M9SD_AIO_shouldCreateBox = false;
				if (isNull _entity) then {
					M9SD_AIO_shouldCreateBox = true;
				};
				_pos = screenToWorld getMousePosition;
				M9SD_AIO_SupplyBox = objnull;
				if (M9SD_AIO_shouldCreateBox) then 
				{
					M9SD_AIO_SupplyBox = createVehicle ["B_supplyCrate_F", _pos, [], 0, "CAN_COLLIDE"];
					M9SD_AIO_SupplyBox setVehicleVarName "M9SD_AIO_SupplyBox";
					M9SD_AIO_SupplyBox allowdamage false;;
					M9SD_AIO_HelipadLight = createVehicle["PortableHelipadLight_01_green_F", _pos, [], 0, "CAN_COLLIDE"];
					M9SD_AIO_HelipadLight = [M9SD_AIO_HelipadLight] call BIS_fnc_replaceWithSimpleObject;
					M9SD_AIO_HelipadLight setVehicleVarName "M9SD_AIO_HelipadLight";
					M9SD_AIO_HelipadLight attachTo[M9SD_AIO_SupplyBox, [0, 0, 0.5]];;
					
					M9SD_AIO_glowLight1 = createVehicle ['#lightpoint', _pos,[],0,'CAN_COLLIDE'];
					M9SD_AIO_glowLight1 attachto [M9SD_AIO_SupplyBox,[0,0,0.5]];
					
					_fnc =  { 
						if (!hasInterface) exitWith {}; 
						params ['_light','_vic']; 
						if (!isNull _light) then 
						{ 
							_light setLightBrightness 0.14; 
							_color = [0.1,1,0.1];
							_light setLightAmbient _color; 
							_light setLightColor _color; 
						}; 
					};
					M9SD_AIO_REfnc_initArsenalLight = ['b2', _fnc]; 
					publicVariable 'M9SD_AIO_REfnc_initArsenalLight'; 
					
					[ 
						[ 
							M9SD_AIO_glowLight1,  
							Tesla_testVehicle 
						], 
						{ 
							_this spawn (M9SD_AIO_REfnc_initArsenalLight select 1); 
						} 
					] remoteExec ['spawn', 0, M9SD_AIO_glowLight1];
					
					
					[[M9SD_AIO_SupplyBox, M9SD_AIO_HelipadLight, M9SD_AIO_glowLight1], {
						params['_M9SD_AIO_SupplyBox', '_M9SD_AIO_HelipadLight', '_M9SD_AIO_glowLight1'];
						waitUntil {
							sleep 1;
							(!alive _M9SD_AIO_SupplyBox)
						};
						deleteVehicle _M9SD_AIO_SupplyBox;
						deleteVehicle _M9SD_AIO_HelipadLight;
						deleteVehicle _M9SD_AIO_glowLight1;
					}] remoteExec['spawn', 2];
					clearWeaponCargoGlobal M9SD_AIO_SupplyBox;
					clearBackpackCargoGlobal M9SD_AIO_SupplyBox;
					clearMagazineCargoGlobal M9SD_AIO_SupplyBox;
					clearItemCargoGlobal M9SD_AIO_SupplyBox;
				} else {
					M9SD_AIO_SupplyBox = _entity;
				};
				if (isNull M9SD_AIO_SupplyBox) exitWith {};

				["AmmoboxInit", [M9SD_AIO_SupplyBox, true]] call BIS_fnc_arsenal;
				publicVariable 'M9SD_AIO_SupplyBox';
				M9SD_fnc_addSmallArsenalActions = {
					params[['_supplyCrate', objNull]];
					if (isNull _supplyCrate) exitWith {};
					if (_supplyCrate getVariable['M9SD_hasArsenalActions', false]) exitWith {};
					_supplyCrate setVariable['M9SD_hasArsenalActions', true, true];
					if (isNil 'M9SD_AIOArsenal_JIPCount') then {
						M9SD_AIOArsenal_JIPCount = 0;
					};
					M9SD_AIOArsenal_JIPCount = M9SD_AIOArsenal_JIPCount + 1;
					publicVariable 'M9SD_AIOArsenal_JIPCount';
					private _uniqueJIP = format['M9SD_JIP_AIOArsenalActions_%1', M9SD_AIOArsenal_JIPCount];
					[
						[_supplyCrate, _uniqueJIP], {
							if (!hasInterface) exitWith {};
							params[['_supplyCrate', objNull], ['_uniqueJIP', '']];
							if (isNull _supplyCrate) exitWith {
								remoteExec['', _uniqueJIP]
							};
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='a3\ui_f\data\logos\a_64_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Full Arsenal</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									['Preload'] call BIS_fnc_arsenal;
									comment "['Open', [true]] call BIS_fnc_arsenal; <-- WTF IS THE DIFFERENCE?";
									['Open', true] spawn BIS_fnc_arsenal;
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification1'
										cutText["<br/><t color='#00ff00' size='2.1' shadow='2' font='puristaMedium'>AIO Arsenal</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 1;
										if !(isNull findDisplay - 1) then {
											'arsenalNotification2'
											cutFadeOut 0;
											'arsenalNotification2'
											cutText["<br/><br/><br/><t color='#00a6ff' size='1.2' shadow='2' font='puristaSemiBold'>by <t color='#00c9ff'>M9-SD</t>", "PLAIN DOWN", -1, true, true];
										};
										uiSleep 7;
										'arsenalNotification1'
										cutFadeOut 2.1;
										'arsenalNotification2'
										cutFadeOut 2.1;
									};
									private _arsenalAnims = [{
										player playActionNow "Salute";
									}, {
										[player, 'acts_civilidle_1'] remoteExec['switchMove'];
									}, {
										[player, 'acts_civilListening_2'] remoteExec['switchMove'];
									}, {
										[player, 'acts_commenting_on_fight_loop'] remoteExec['switchMove'];
									}, {
										[player, 'acts_gallery_visitor_01'] remoteExec['switchMove'];
									}, {
										[player, 'acts_gallery_visitor_02'] remoteExec['switchMove'];
									}, {
										[player, 'acts_hilltop_calibration_loop'] remoteExec['switchMove'];
									}, {
										[player, 'acts_kore_talkingoverradio_loop'] remoteExec['switchMove'];
									}, {
										[player, 'acts_staticPose_photo'] remoteExec['switchMove'];
									}, {
										player playActionNow 'gear';
									}, {
										[player, 'Acts_Taking_Cover_From_Jets'] remoteExec['switchMove'];
									}, {
										[player, 'Acts_standingSpeakingUnarmed'] remoteExec['switchMove'];
									}, {
										player playMoveNow 'acts_Mentor_Freeing_Player';
									}, {
										[player, 'acts_kore_talkingOverRadio_In'] remoteExec['switchMove'];
									}, {
										[player, 'acts_kore_idleNoWeapon_In'] remoteExec['switchMove'];
									}, {
										[player, 'Acts_JetsOfficerSpilling'] remoteExec['switchMove'];
									}, {
										player playMoveNow 'Acts_Hilltop_Calibration_Pointing_Left';
									}, {
										player playMoveNow 'Acts_Hilltop_Calibration_Pointing_Right';
									}, {
										[player, 'Acts_Grieving'] remoteExec['switchMove'];
									}];
									private _arsenalAnimsAdd =
									switch (currentWeapon player) do {
										case '':{
												[]
											};
										case (primaryWeapon player):{
												[{
													[player, 'acts_briefing_SA_loop'] remoteExec['switchMove'];
												}, {
													[player, 'acts_getAttention_loop'] remoteExec['switchMove'];
												}, {
													[player, 'acts_millerIdle'] remoteExec['switchMove'];
												}, {
													player playMoveNow 'Acts_SupportTeam_Right_ToKneelLoop';
												}, {
													player playMoveNow 'Acts_SupportTeam_Left_ToKneelLoop';
												}, {
													player playMoveNow 'Acts_SupportTeam_Front_ToKneelLoop';
												}, {
													player playMoveNow 'Acts_SupportTeam_Back_ToKneelLoop';
												}, {
													[player, 'Acts_starGazer'] remoteExec['switchMove'];
												}, {
													player playMoveNow 'acts_RU_briefing_Turn';
												}, {
													player playMoveNow 'acts_RU_briefing_point';
												}, {
													player playMoveNow 'acts_RU_briefing_point_tl';
												}, {
													player playMoveNow 'acts_RU_briefing_move';
												}, {
													[player, 'acts_rifle_operations_zeroing'] remoteExec['switchMove'];
												}, {
													player playMoveNow 'acts_rifle_operations_right';
												}, {
													player playMoveNow 'acts_rifle_operations_left';
												}, {
													player playMoveNow 'acts_rifle_operations_front';
												}, {
													player playMoveNow 'acts_rifle_operations_checking_chamber';
												}, {
													player playMoveNow 'acts_rifle_operations_barrel';
												}, {
													player playMoveNow 'acts_rifle_operations_back';
												}, {
													player playMoveNow 'acts_pointing_up';
												}, {
													player playMoveNow 'acts_pointing_down';
												}, {
													player playMoveNow 'acts_peering_up';
												}, {
													player playMoveNow 'acts_peering_down';
												}, {
													player playMoveNow 'acts_peering_front';
												}, {
													[player, 'Acts_Helping_Wake_Up_1'] remoteExec['switchMove'];
												}]
											};
										case (handgunWeapon player):{
												[{
													[player, 'acts_examining_device_player'] remoteExec['switchMove'];
												}, {
													[player, 'acts_executioner_standingloop'] remoteExec['switchMove'];
												}, {
													player playMoveNow 'Acts_ViperMeeting_A_End';
												}, {
													player playMoveNow 'Acts_UGV_Jamming_Loop';
												}, {
													player playMoveNow 'Acts_starterPistol_Fire';
												}]
											};
										default {
											[]
										};
									};
									_arsenalAnims = _arsenalAnims + _arsenalAnimsAdd;
									private _playAnim = selectRandom _arsenalAnims;
									call _playAnim;
									if !(isNil "M9SD_EH_ResetPlayerAnimsOnArsenalClosed") then {
										(findDisplay 46) displayRemoveEventHandler['keyDown', M9SD_EH_ResetPlayerAnimsOnArsenalClosed];
									};
									M9SD_EH_ResetPlayerAnimsOnArsenalClosed = (findDisplay 46) displayAddEventHandler['keyDown', {
										params["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
										private _w = 17;
										private _a = 30;
										private _s = 31;
										private _d = 32;
										private _keys = [_w, _a, _s, _d];
										if (_key in _keys) then {
											comment
												" 
											playSound['addItemOK', true];
											playSound['addItemOK', false];
											"; 
											if !(isNil "M9SD_EH_ResetPlayerAnimsOnArsenalClosed") then {
												(findDisplay 46) displayRemoveEventHandler['keyDown', M9SD_EH_ResetPlayerAnimsOnArsenalClosed];
											};
											player enableSimulation true;
											player playActionNow '';
											player playMoveNow '';
											player switchMove '';
											if (isMultiplayer) then {
												[player, ''] remoteExec['switchMove']
											};
											'arsenalNotification1'
											cutFadeOut 0;
											'arsenalNotification2'
											cutFadeOut 0;
											comment
												" 
											playSound['hintCollapse', true];
											playSound['hintCollapse', false];
											"; 
										};
									}];
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							
							
							
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Quick Rearm</t>", {
									playSound['hintExpand', true];
									playSound['hintExpand', false];
									player playActionNow 'putdown';
									comment "player action ['rearm', arsenal];";
									comment "reload player;";
									0 = [] spawn {
										for '_i'
										from 1 to 11 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification7'
										cutFadeOut 0;
										'arsenalNotification7'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Rearming...</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 1.4;
										'arsenalNotification7'
										cutFadeOut 0;
										'arsenalNotification7'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Rearmed.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.5;
										'arsenalNotification7'
										cutFadeOut 0.35;
									};
									comment "Put mags in weapons";
									private _primaryMagsLoaded = primaryWeaponMagazine player;
									private _secondaryMagsLoaded = secondaryWeaponMagazine player;
									private _handgunMagsLoaded = handgunMagazine player;
									if (_primaryMagsLoaded isEqualTo[]) then {
										private _weapon = primaryWeapon player;
										if (_weapon != '') then {
											private _magazines = getArray(configFile / "CfgWeapons" / _weapon / "magazines");
											private _magazineClass = _magazines# 0;
											player addPrimaryWeaponItem _magazineClass;
										};
									};
									if (_secondaryMagsLoaded isEqualTo[]) then {
										private _weapon = secondaryWeapon player;
										if (_weapon != '') then {
											private _magazines = getArray(configFile / "CfgWeapons" / _weapon / "magazines");
											private _magazineClass = _magazines# 0;
											player addSecondaryWeaponItem _magazineClass;
										};
									};
									if (_handgunMagsLoaded isEqualTo[]) then {
										private _weapon = handgunWeapon player;
										if (_weapon != '') then {
											private _magazines = getArray(configFile / "CfgWeapons" / _weapon / "magazines");
											private _magazineClass = _magazines# 0;
											player addHandgunItem _magazineClass;
										};
									};
									comment "Refill magazines";
									_primaryMagsLoaded = primaryWeaponMagazine player;
									_secondaryMagsLoaded = secondaryWeaponMagazine player;
									_handgunMagsLoaded = handgunMagazine player; {
										player addPrimaryWeaponItem _x;
									}
									forEach _primaryMagsLoaded; {
										player addSecondaryWeaponItem _x;
									}
									forEach _secondaryMagsLoaded; {
										player addHandgunItem _x;
									}
									forEach _handgunMagsLoaded;
									private _allMags = [];
									private _allUniqueMags = []; {
										private _magData = _x;
										private _cName = _x# 0;
										private _rCount = _x# 1;
										private _isLoaded = _x# 2;
										private _mType = _x# 3;
										private _mLocation = _x# 4;
										comment "private _maxAmmo = getNumber (configfile >> 'CfgMagazines' >> _cName >> 'count');";
										_allMags pushBack _cName;
										_allUniqueMags pushBackUnique _cName;
									}
									forEach(magazinesAmmoFull player); {
										private _thisMag = _x;
										private _mCount = 0; {
											if (_thisMag == _x) then {
												_mCount = _mCount + 1;
											};
										}
										forEach _allMags;
										for '_i'
										from 1 to _mCount do {
											player removeMagazine _thisMag;
										};
										for '_i'
										from 1 to _mCount do {
											player addMagazine _thisMag;
										};
										comment "Add +1 mag";
										player addMagazine _thisMag;
									}
									forEach _allUniqueMags;
									comment "Add Magazines";
									comment "TODO: How can I only add the mags if there is available space and fatigue?";
									comment "For now I will add 1 of each mag.";
									comment "Add FAK";
									if !('FirstAidKit' in (items player)) then {
										if ((getFatigue player) <= 0.9) then {
											player addItem 'FirstAidKit';
										};
									};
									comment "Add Smoke";
									if !('SmokeShell' in (magazines player)) then {
										if ((getFatigue player) <= 0.9) then {
											player addMagazine 'SmokeShell';
										};
									};
									comment "Add Grenade";
									if !('HandGrenade' in (magazines player)) then {
										if ((getFatigue player) <= 0.9) then {
											player addMagazine 'HandGrenade';
										};
									};
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							
								
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='\A3\ui_f\data\map\diary\icons\taskCustom_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Copy Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playmovenow 'AinvPknlMstpSnonWnonDnon_1';
									if (false) then {
										private _nearMen = nearestObjects[player, ['Man'], 21];
										if ((count _nearMen) <= 1) exitWith {
											playSound['AddItemFailed', true];
											playSound['AddItemFailed', false];
											0 = [] spawn {
												for '_i'
												from 1 to 12 do {
													(format['arsenalNotification%1', _i]) cutFadeOut 0;
												};
												'arsenalNotification8'
												cutFadeOut 0;
												'arsenalNotification8'
												cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>ERROR:<br/>No unit is close enough.</t>", "PLAIN DOWN", -1, true, true];
												uiSleep 3.5;
												'arsenalNotification8'
												cutFadeOut 0.35;
											};
										};
										private _nearestMan = _nearMen# 1;
										private _loadout = getUnitLoadout _nearestMan;
										player setUnitLoadout _loadout;
										private _unitName = name _nearestMan;
										private _notifText = format["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Nearest unitâ€™s loadout copied:<br/><br/><t color='#FFFFFF' font='puristaSemiBold'>â€œ%1â€</t>", _unitName];
										0 = _notifText spawn {
											for '_i'
											from 1 to 12 do {
												(format['arsenalNotification%1', _i]) cutFadeOut 0;
											};
											'arsenalNotification8'
											cutFadeOut 0;
											'arsenalNotification8'
											cutText[_this, "PLAIN DOWN", -1, true, true];
											uiSleep 3.5;
											'arsenalNotification8'
											cutFadeOut 0.35;
										};
										playSound['hintExpand', true];
										playSound['hintExpand', false];
									} else {
										[] spawn {
											with uinamespace do {
												disableSerialization;
												comment "_display = (findDisplay 46) createDisplay 'RscDisplayEmpty';";
												createDialog 'RscDisplayEmpty';
												_display = findDisplay - 1;
												missionNamespace setVariable['LP_loadout_01', getUnitLoadout player];
												missionNamespace setVariable['LP_loadoutApplied', false];
												showChat true;
												_display displayAddEventHandler['Unload', {
													params["_display", "_exitCode"];
													[] spawn {
														if (missionNamespace getVariable['LP_loadoutApplied', false]) exitWith {};
														player setUnitLoadout(missionNamespace getVariable['LP_loadout_01', getUnitLoadout player]);
													};
													playSound['hintExpand', true];
													playSound['hintExpand', false];
												}];
												
												player switchCamera 'external';
												
												_ctrl = _display ctrlCreate['IGUIBack', -1];
												_ctrl ctrlSetPosition[0.159687 * safezoneW + safezoneX, 0.313 * safezoneH + safezoneY, 0.128906 * safezoneW, 0.363 * safezoneH];
												_ctrl ctrlSetBackgroundColor[0.0, 0.0, 0, 0.8];
												_ctrl ctrlSetFade 1;
												_ctrl ctrlCommit 0;
												_ctrl ctrlSetFade 0;
												_ctrl ctrlCommit 1;
												_ctrl = _display ctrlCreate['RscStructuredText', -1];
												_ctrl ctrlSetPosition[0.159687 * safezoneW + safezoneX, 0.269 * safezoneH + safezoneY, 0.128906 * safezoneW, 0.033 * safezoneH];
												_ctrl ctrlSetBackgroundColor[0.8, 0.5, 0.1, 1];
												_ctrl ctrlSetStructuredText parseText format["<t size='%1' shadow='2'>%2<t/>", safezoneH * 0.5 * 1.5, "  Loadout Previewer"];
												_ctrl ctrlSetFade 1;
												_ctrl ctrlCommit 0;
												_ctrl ctrlSetFade 0;
												_ctrl ctrlCommit 1;
												_ctrl = _display ctrlCreate['RscButtonMenu', -1];
												_ctrl ctrlSetPosition[0.267969 * safezoneW + safezoneX, 0.269 * safezoneH + safezoneY, 0.020625 * safezoneW, 0.033 * safezoneH];
												_ctrl ctrlSetBackgroundColor[0.0, 0.0, 0.0, 0.0];
												_ctrl ctrlSetStructuredText parseText format["<t size='%1' align='center' shadow='0'>%2<t/>", safezoneH * 0.5 * 1.5, "X"];
												_ctrl ctrlAddEventHandler['ButtonClick', {
													params['_ctrl'];
													_disp = ctrlParent _ctrl;
													missionNamespace setVariable['LP_loadoutApplied', false];
													_disp closeDisplay 0;
												}];
												_ctrl ctrlSetFade 1;
												_ctrl ctrlCommit 0;
												_ctrl ctrlSetFade 0;
												_ctrl ctrlCommit 1;
												_ctrl = _display ctrlCreate['RscListbox', -1];
												_ctrl ctrlSetPosition[0.164844 * safezoneW + safezoneX, 0.324 * safezoneH + safezoneY, 0.118594 * safezoneW, 0.297 * safezoneH];
												_tooltip = "Click to preview loadout"; {
													_name = name _x;
													_index = _ctrl lbAdd _name;
													_ctrl lbSetTooltip[_index, format["Click to preview %1's loadout", _name]];
												}
												forEach allPlayers;
												_ctrl ctrlAddEventHandler['LBSelChanged', {
													params["_control", "_selectedIndex"];
													_name = _control lbText _selectedIndex; {
														if (name _x == _name) then {
															player setUnitLoadout(getUnitLoadout _x);
														};
													}
													forEach allPlayers;
												}];
												_ctrl ctrlSetFade 1;
												_ctrl ctrlCommit 0;
												_ctrl ctrlSetFade 0;
												_ctrl ctrlCommit 1;
												_ctrl lbSetCurSel 0;
												_ctrl = _display ctrlCreate['RscButtonMenu', -1];
												_ctrl ctrlSetPosition[0.164844 * safezoneW + safezoneX, 0.632 * safezoneH + safezoneY, 0.118594 * safezoneW, 0.033 * safezoneH];
												_ctrl ctrlSetBackgroundColor[1, 0.6, 0.0, 1];
												_ctrl ctrlSetStructuredText parseText format["<t size='%1' color='#000000' align='center'>%2<t/>", safezoneH * 0.5 * 1.5, "APPLY LOADOUT"];
												_ctrl ctrlAddEventHandler['ButtonClick', {
													params['_ctrl'];
													_disp = ctrlParent _ctrl;
													missionNamespace setVariable['LP_loadoutApplied', true];
													_disp closeDisplay 0;
													playSound['beep_target', true];
													playSound['beep_target', false];
													player playActionNow 'putdown';
												}];
												_ctrl ctrlSetFade 1;
												_ctrl ctrlCommit 0;
												_ctrl ctrlSetFade 0;
												_ctrl ctrlCommit 1;
											};;
										};
									};
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_gear_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Empty Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playmovenow 'AinvPknlMstpSnonWnonDnon_1';
									removeAllWeapons player;
									removeAllItems player;
									removeAllAssignedItems player;
									removeUniform player;
									removeVest player;
									removeBackpack player;
									removeHeadgear player;
									removeGoggles player;
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification4'
										cutFadeOut 0;
										'arsenalNotification4'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Loadout removed.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.5;
										'arsenalNotification4'
										cutFadeOut 0.35;
									};
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='a3\3den\data\displays\Display3DEN\ToolBar\save_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Save Respawn Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playActionNow 'putdown';
									[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_saveInventory;
									if (!isNil "M9SD_EH_arsenalRespawnLoadout") then {
										player removeEventHandler["Respawn", M9SD_EH_arsenalRespawnLoadout];
									};
									M9SD_EH_arsenalRespawnLoadout = player addEventHandler[
										"Respawn", {
											0 = [] spawn {
												waitUntil {
													(alive player)
												};
												sleep 0.07;
												[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_loadInventory;
											};
										}
									];
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification6'
										cutFadeOut 0;
										'arsenalNotification6'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Respawn loadout set.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.5;
										'arsenalNotification6'
										cutFadeOut 0.35;
									};
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='a3\3den\data\displays\Display3DEN\ToolBar\open_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Load Respawn Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playActionNow 'putdown';
									if (isNil 'M9SD_EH_arsenalRespawnLoadout') then {
										playSound['AddItemFailed', true];
										playSound['AddItemFailed', false];
										0 = [] spawn {
											for '_i'
											from 1 to 12 do {
												(format['arsenalNotification%1', _i]) cutFadeOut 0;
											};
											'arsenalNotification12'
											cutFadeOut 0;
											'arsenalNotification12'
											cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>ERROR:<br/>No respawn loadout saved.</t>", "PLAIN DOWN", -1, true, true];
											uiSleep 3.5;
											'arsenalNotification12'
											cutFadeOut 0.35;
										};
									} else {
										[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_loadInventory;
										0 = [] spawn {
											for '_i'
											from 1 to 12 do {
												(format['arsenalNotification%1', _i]) cutFadeOut 0;
											};
											'arsenalNotification12'
											cutFadeOut 0;
											'arsenalNotification12'
											cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Respawn loadout applied.</t>", "PLAIN DOWN", -1, true, true];
											uiSleep 3.5;
											'arsenalNotification12'
											cutFadeOut 0.35;
										};
										playSound['hintExpand', true];
										playSound['hintExpand', false];
									};
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='\a3\3den\data\Cfg3DEN\History\deleteItems_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Delete Respawn Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playActionNow 'putdown';
									if (!isNil "M9SD_EH_arsenalRespawnLoadout") then {
										player removeEventHandler["Respawn", M9SD_EH_arsenalRespawnLoadout];
									};
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification5'
										cutFadeOut 0;
										'arsenalNotification5'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Respawn loadout disabled.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.5;
										'arsenalNotification5'
										cutFadeOut 0.35;
									};
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							
							
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='\A3\ui_f\data\igui\cfg\cursors\select_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Edit Group Loadouts</t>", {
									comment "playSound ['beep_target', true]; ";
									playSound['beep_target', false];
									if (leader group player == player) then {
										player playActionNow 'GestureHi';
										JAM_fnc_openGroupArsenal = {
											findDisplay 312 closeDisplay 0;
											findDisplay 49 closeDisplay 0;
											["Preload"] call BIS_fnc_arsenal;
											GAthisWorldSize = worldSize;
											GAthisPosX = random GAthisWorldSize;
											GAthisPosY = random GAthisWorldSize;
											GAthisPosZ = 1999;
											GAthisCenterPos = [GAthisPosX, GAthisPosY, GAthisPosZ];
											GAthisCenterObj = createSimpleObject['Box_NATO_AmmoVeh_F', GAthisCenterPos, true];
											GAthisAgent = createAgent[typeOf player, GAthisCenterPos, [], 0, "FORM"];
											GAthisAgent setVariable['JAM_isEditable', false, true];
											GAthisAgent setUnitLoadout(getUnitLoadout JAM_groupArsenalTarget);
											GAthisAgent allowDamage false;
											GAthisAgent attachTo[GAthisCenterObj, [0, 0, 0.7]];
											GAthisVR = "Land_VR_Block_04_F"
											createVehicleLocal GAthisCenterPos;
											GAthisVR attachTo[GAthisCenterObj, [0, 0, -5.29]];
											GAthisVR setObjectTexture[0, 'A3\map_vr\data\picturemap_ca.paa'];
											GAthisVR2 = "Land_VR_Block_04_F"
											createVehicleLocal GAthisCenterPos;
											GAthisVR2 attachTo[GAthisCenterObj, [0, 10.37, 3.58]];
											GAthisVR2 setObjectTexture[0, 'A3\map_vr\data\picturemap_ca.paa'];
											GAthisVR3 = "Land_VR_Block_04_F"
											createVehicleLocal GAthisCenterPos;
											GAthisVR3 attachTo[GAthisCenterObj, [0, -10.37, 3.58]];
											GAthisVR3 setObjectTexture[0, 'A3\map_vr\data\picturemap_ca.paa'];
											GAthisVR4 = "Land_VR_Block_04_F"
											createVehicleLocal GAthisCenterPos;
											GAthisVR4 attachTo[GAthisCenterObj, [10.37, 0, 3.58]];
											GAthisVR4 setObjectTexture[0, 'A3\map_vr\data\picturemap_ca.paa'];
											GAthisVR5 = "Land_VR_Block_04_F"
											createVehicleLocal GAthisCenterPos;
											GAthisVR5 attachTo[GAthisCenterObj, [-10.37, 0, 3.58]];
											GAthisVR5 setObjectTexture[0, 'A3\map_vr\data\picturemap_ca.paa'];
											GAthisVR6 = "Land_VR_Block_04_F"
											createVehicleLocal GAthisCenterPos;
											GAthisVR6 attachTo[GAthisCenterObj, [0, 0, 12.51]];
											GAthisVR6 setObjectTexture[0, 'A3\map_vr\data\picturemap_ca.paa'];
											GAthisLight = "Land_PortableLight_single_F"
											createVehicleLocal GAthisCenterPos;
											GAthisLight attachTo[GAthisCenterObj, [-4.75, 4.75, 0.3]];
											GAthisLight setDir 315;
											GAthisLight setObjectTexture[0, 'A3\map_vr\data\picturemap_ca.paa'];
											GAthisLight2 = "Land_PortableLight_single_F"
											createVehicleLocal GAthisCenterPos;
											GAthisLight2 attachTo[GAthisCenterObj, [4.75, -4.75, 0.3]];
											GAthisLight2 setDir 135;
											GAthisLight attachTo[GAthisCenterObj, [-4.75, 4.75, 0.3]];
											GAthisLight2 attachTo[GAthisCenterObj, [4.75, -4.75, 0.3]];
											GAthisLight setDir 315;
											GAthisLight2 setDir 135;
											if (!isNIl "JAM_EH_groupArsenalClosed") then {
												[missionNamespace, "ArsenalClosed", JAM_EH_groupArsenalClosed] call BIS_fnc_removeScriptedEventHandler;
											};
											JAM_EH_groupArsenalClosed = [missionNamespace, "ArsenalClosed", {
												playSound "hintCollapse";
												systemChat "[Arsenal] : Closed.";
												if (!isNIl "JAM_EH_groupArsenalClosed") then {
													[missionNamespace, "ArsenalClosed", JAM_EH_groupArsenalClosed] call BIS_fnc_removeScriptedEventHandler;
												};
												_fncDelete = {
													deleteVehicle GAthisCenterObj;
													deleteVehicle GAthisAgent;
													deleteVehicle GAthisVR;
													deleteVehicle GAthisVR2;
													deleteVehicle GAthisVR3;
													deleteVehicle GAthisVR4;
													deleteVehicle GAthisVR5;
													deleteVehicle GAthisVR6;
													deleteVehicle GAthisLight;
													deleteVehicle GAthisLight2;
												};
												_group = group player;
												if !(leader _group == player) exitWith {
													call _fncDelete;
													systemChat '[Arsenal] : You are not squad leader. Loadout not applied.';
												};
												if ((isNull JAM_groupArsenalTarget)) exitWith {
													call _fncDelete;
													systemChat '[Arsenal] : Unit not found. Loadout not applied.';
												};
												_groupUnits = units _group;
												_isUnitInGroup =
												if (JAM_groupArsenalTarget in _groupUnits) then {
													true
												} else {
													false
												};
												if (!(_isUnitInGroup)) exitWith {
													call _fncDelete;
													systemChat '[Arsenal] : Unit not in group. Loadout not applied.';
												};
												if (!alive JAM_groupArsenalTarget) exitWith {
													call _fncDelete;
													systemChat '[Arsenal] : Unit is dead. Loadout not applied.';
												};
												if (((vehicle player) distance(vehicle JAM_groupArsenalTarget)) > 20) exitWith {
													call _fncDelete;
													systemChat '[Arsenal] : Unit too far away (>20m). Loadout not applied.';
												};
												_loadout = getUnitLoadout GAthisAgent;
												[JAM_groupArsenalTarget, _loadout] remoteExec['setUnitLoadout'];
												call _fncDelete;
												_text = format['[Arsenal] : Loadout applied to %1.', name JAM_groupArsenalTarget];
												systemChat _text;
												_text = format['[Arsenal]\nLoadout applied to %1', name JAM_groupArsenalTarget];
												'arsenalNotification'
												cutFadeOut 0;
												'arsenalNotification'
												cutText[_text, "PLAIN DOWN", 0];
											}] call BIS_fnc_addScriptedEventHandler;
											["Open", [true, nil, GAthisAgent]] call bis_fnc_arsenal;
											playsound "hintExpand";
											systemChat "[Arsenal] : Opened.";
											showChat true;
											_text = format["[ This loadout will be applied to %1 ]<br /> <t color='#00ff00' size='2'>-Press ESC to exit Arsenal-</t>", name JAM_groupArsenalTarget];
											'arsenalNotification'
											cutFadeOut 0;
											'arsenalNotification'
											cutText[_text, "PLAIN DOWN", -1, true, true];
											_text = format["[Arsenal] : This loadout will be applied to %1.", name JAM_groupArsenalTarget];
											systemChat _text;
										};
										JAM_GUIfnc_openGroupArsenalSelector = {
											JAM_groupArsenalTarget = objNull;
											findDisplay 312 closeDisplay 0;
											findDisplay 49 closeDisplay 0;
											disableSerialization;
											with uiNamespace do {
												_display = findDisplay 46 createDisplay 'RscDisplayEmpty';
												showChat true;
												_bkCtrl = _display ctrlCreate['IGUIBack', -1];
												_bkCtrl ctrlSetPosition[0.427812 * safezoneW + safezoneX, 0.291 * safezoneH + safezoneY, 0.159844 * safezoneW, 0.363 * safezoneH];
												_bkCtrl ctrlSetBackgroundColor[0, 0.1, 0, 0.75];
												_bkCtrl ctrlCommit 0;
												_lbCtrl = _display ctrlCreate['RscListBox', -1];
												_display setVariable['lbCtrl', _lbCtrl];
												_lbCtrl ctrlSetPosition[0.432969 * safezoneW + safezoneX, 0.302 * safezoneH + safezoneY, 0.149531 * safezoneW, 0.286 * safezoneH];
												_pictureColor = [side group player, false] call BIS_fnc_sideColor;
												if ((isNil '_pictureColor') or(_pictureColor isEqualTo[])) then {
													_pictureColor = [1, 1, 1, 1];
												}; {
													_index = _lbCtrl lbAdd name _x;
													_lbCtrl lbSetTooltip[_index, 'Select unit'];
													_lbCtrl lbSetPicture[_index, '\A3\ui_f\data\igui\cfg\cursors\select_ca.paa'];
													_lbCtrl lbSetPictureRight[_index, '\a3\ui_f\data\map\VehicleIcons\iconMan_ca.paa'];
													_lbCtrl lbSetPictureRightColor[_index, _pictureColor];
												}
												forEach units group player;
												_lbCtrl ctrlCommit 0;
												_lbCtrl lbSetCurSel 0;
												_btnCtrl = _display ctrlCreate['RscButtonMenu', -1];
												_btnCtrl ctrlSetTooltip 'Edit loadout';
												_btnCtrl ctrlSetStructuredText parseText("<t valign='middle' align='center' font='PuristaLight' shadow='2' size='" + (str((safeZoneH * 0.5) * 2.2)) + "'><img image='\A3\ui_f\data\logos\arsenal_1024_ca.paa'></img></t>");
												_btnCtrl ctrlSetPosition[0.432969 * safezoneW + safezoneX, 0.599 * safezoneH + safezoneY, 0.149531 * safezoneW, 0.044 * safezoneH];
												_btnCtrl ctrlAddEventHandler['ButtonClick', {
													params["_control"];
													_parentDisplay = ctrlParent _control;
													_lbCtrl = _parentDisplay getVariable 'lbCtrl';
													_index = lbCurSel _lbCtrl;
													_name = _lbCtrl lbText _index;
													_unit = objNull;
													_group = group player;
													_groupUnits = units _group;
													_isUnitInGroup = false; {
														if (name _x == _name) exitWith {
															_isUnitInGroup = true;
															_unit = _x;
														};
													}
													forEach _groupUnits;
													if ((isNull _unit) or(!(_isUnitInGroup))) exitWith {
														systemChat '[Arsenal] : Unit not found. Close the menu with ESC and try again.';
													};
													if (!alive _unit) exitWith {
														systemChat '[Arsenal] : Unit is dead. Close the menu with ESC and try again.';
													};
													if (((vehicle player) distance(vehicle _unit)) > 20) exitWith {
														systemChat '[Arsenal] : Unit too far away (>20m). Close the menu with ESC and try again.';
													};
													_display closeDisplay 0;
													JAM_groupArsenalTarget = _unit;
													[] spawn JAM_fnc_openGroupArsenal;
												}];
												_btnCtrl ctrlSetBackgroundColor[0, 0, 0, 0.35];
												_btnCtrl ctrlCommit 0;
											};
										};
										[] spawn JAM_GUIfnc_openGroupArsenalSelector;
										systemChat "[Arsenal] : Select a group member to open the arsenal on.";
										systemChat "[Arsenal] : Their loadout will be updated when you close the arsenal.";
										playSound "beep_target";
									} else {
										["<t align='center' color='#FFFFFF'><br/>“NOT GROUP LEADER”<br/><br/><t align='center' color='#FFFFFF'>You must be group leader<br/>to edit squad loadouts.<br/><br/><t/>", "Arsenal:", true, false] spawn BIS_fnc_guiMessage;
										playSound 'AddItemFailed';
									};
									comment "playSound ['hintExpand', true]; 
									playSound['hintExpand', false];
									";
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							
							
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\heal_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Heal</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playActionNow 'Medic';
									[player] call BIS_fnc_reviveEhRespawn;
									player setDamage 0;
									player setUnconscious false;
									player setCaptive false;
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification3'
										cutFadeOut 0;
										'arsenalNotification3'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Healing...</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 6.33;
										playSound['hintCollapse', true];
										playSound['hintCollapse', false];
										'arsenalNotification3'
										cutFadeOut 0;
										'arsenalNotification3'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Healed.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.33;
										'arsenalNotification3'
										cutFadeOut 0.35;
									};
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "((_this == vehicle _this) && (damage _this > 0))", 7
							];
						}
					] remoteExec['call', 0, _uniqueJIP];
				};
				[M9SD_AIO_SupplyBox] call M9SD_fnc_addSmallArsenalActions;
				M9SD_fnc_smallArsenalMarkers = {
					params[['_supplyCrate', objNull]];
					if (isNull _supplyCrate) exitWith {};
					if (_supplyCrate getVariable['M9SD_hasMarkers', false]) exitWith {};
					_supplyCrate setVariable['M9SD_hasMarkers', true, true];
					if (isNil 'M9SD_smallArsenals') then {
						M9SD_smallArsenals = [];
					};
					M9SD_smallArsenals pushBackUnique _supplyCrate;
					publicVariable 'M9SD_smallArsenals';
					[M9SD_smallArsenals, {
						if (!hasInterface) exitWith {};
						waitUntil {
							!isNil {
								player
							} && {!isNull player
							}
						};
						waitUntil {
							!isNull(findDisplay 46)
						};
						if (isNil 'M9SD_smallArsenals') then {
							M9SD_smallArsenals = _this;
						};
						M9SD_smallArsenalIcons_texture = '\a3\3den\data\displays\display3den\entitymenu\arsenal_ca.paa';
						M9SD_smallArsenalIcons_width = 0.7;
						M9SD_smallArsenalIcons_height = 0.7;
						M9SD_smallArsenalIcons_angle = 0;
						M9SD_smallArsenalIcons_text = 'Virtual Arsenal';
						M9SD_smallArsenalIcons_shadow = 2;
						M9SD_smallArsenalIcons_textSize = 0.04;
						M9SD_smallArsenalIcons_font = 'PuristaSemiBold';
						M9SD_smallArsenalIcons_textAlign = 'center';
						M9SD_smallArsenalIcons_drawSideArrows = false;
						M9SD_smallArsenalIcons_offsetX = 0;
						M9SD_smallArsenalIcons_offsetY = -0.07;
						M9SD_smallArsenalIcons_offset = 2.1;
						if (not(isNil 'M9SD_EH_drawSmallArsenal3D')) then {
							removeMissionEventHandler['Draw3D', M9SD_EH_drawSmallArsenal3D];
						};
						M9SD_EH_drawSmallArsenal3D = addMissionEventHandler['Draw3D', {
							if (count M9SD_smallArsenals == 0) exitWith {}; {
								if (!isNull _x) then {
									if (_x in [cursorTarget, cursorObject]) then {
										if ((_x distance(vehicle player)) <= 28) then {
											private _position = getPos _x;
											_position set[2, (_position# 2) + M9SD_smallArsenalIcons_offset];
											drawIcon3D
												[
													M9SD_smallArsenalIcons_texture, [1, 1, 1, 1],
													_position,
													M9SD_smallArsenalIcons_width,
													M9SD_smallArsenalIcons_height,
													M9SD_smallArsenalIcons_angle,
													'',
													M9SD_smallArsenalIcons_shadow,
													M9SD_smallArsenalIcons_textSize,
													M9SD_smallArsenalIcons_font,
													M9SD_smallArsenalIcons_textAlign,
													M9SD_smallArsenalIcons_drawSideArrows,
													M9SD_smallArsenalIcons_offsetX,
													M9SD_smallArsenalIcons_offsetY
												];
											drawIcon3D
												[
													'', [0, 1, 0, 1],
													_position,
													M9SD_smallArsenalIcons_width,
													M9SD_smallArsenalIcons_height,
													M9SD_smallArsenalIcons_angle,
													M9SD_smallArsenalIcons_text,
													M9SD_smallArsenalIcons_shadow,
													M9SD_smallArsenalIcons_textSize,
													M9SD_smallArsenalIcons_font,
													M9SD_smallArsenalIcons_textAlign,
													M9SD_smallArsenalIcons_drawSideArrows,
													M9SD_smallArsenalIcons_offsetX,
													M9SD_smallArsenalIcons_offsetY
												];
										};
									};
								};
							}
							forEach M9SD_smallArsenals;
						}];
						waitUntil {
							!isNull(findDisplay 12 displayCtrl 51)
						};
						
						
						
						
						
						if (!isNil "M9SD_EH_drawSmallArsenal2D") then {
							(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler["Draw", M9SD_EH_drawSmallArsenal2D];
						};
						
						
						M9SD_AIO_color1 = [0, 1, 0, 1];
						M9SD_AIO_color2 = [1, 1, 1, 1];
						M9SD_AIO_iconPath = 'a3\ui_f\data\logos\a_64_ca.paa';
						
						M9SD_EH_drawSmallArsenal2D = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler["Draw", 
						{
							_map = _this select 0;
							if (count M9SD_smallArsenals == 0) exitWith {}; 
							{
								if (!isNull _x) then 
								{
									_pos = _x modelToWorldVisual [0, 0, 0];
									_iconText =
									if (((_map ctrlMapWorldToScreen (_x modelToWorldVisual[0, 0, 0])) distance2D getMousePosition) > 0.02) then {
										""
									} else {
										'Virtual Arsenal'
									};
									_map drawIcon
									[
										M9SD_AIO_iconPath,
										M9SD_AIO_color1,
										_pos,
										20,
										20,
										0,
										_iconText,
										1,
										0.05,
										"PuristaBold",
										"left"
									];
									_map drawIcon
									[
										M9SD_AIO_iconPath,
										M9SD_AIO_color2,
										_pos,
										20,
										20,
										0,
										'',
										1,
										0.05,
										"PuristaSemiBold",
										"left"
									];
								};
							} forEach M9SD_smallArsenals;
						}];
					}] remoteExec['spawn', 0, 'M9SD_JIP_smallArsenalIcons'];
					comment " 
					M9SD_smallArsenals = [];
					publicVariable 'M9SD_smallArsenals';
					remoteExec['', 'M9SD_JIP_smallArsenalIcons'];
					"; 
				};
				[M9SD_AIO_SupplyBox] call M9SD_fnc_smallArsenalMarkers;
				[M9SD_AIO_SupplyBox, false] remoteExec['allowDamage']; 
				{
					[_x, false] remoteExec['allowDamage'];
				}forEach attachedObjects M9SD_AIO_SupplyBox;
				{
					[_x, [
						[M9SD_AIO_SupplyBox], true
					]] remoteExec['addCuratorEditableObjects', owner _x];
					[_x, [attachedObjects M9SD_AIO_SupplyBox, true]] remoteExec['addCuratorEditableObjects', owner _x];
				}forEach allCurators;
				["AIO Arsenal Created.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			};

		} else 
		{
			JAM_EZM_fnc_createAIOArsenalModule = 
			{
				comment "
				playsound 'addItemFailed';
				systemChat 'Use the version compatible with Official zeus servers!';
				systemChat 'Composition: AIO Arsenal (Supply Box)';
				systemChat 'https://steamcommunity.com/sharedfiles/filedetails/?id=2764558652';
				showChat true;
				";
				params [['_entity', objnull]];
				M9SD_AIO_shouldCreateBox = false;
				if (isNull _entity) then {
					M9SD_AIO_shouldCreateBox = true;
				};
				_pos = screenToWorld getMousePosition;
				M9SD_AIO_SupplyBox = objnull;
				if (M9SD_AIO_shouldCreateBox) then 
				{
					M9SD_AIO_SupplyBox = createVehicle ["B_supplyCrate_F", _pos, [], 0, "CAN_COLLIDE"];
					M9SD_AIO_SupplyBox setVehicleVarName "M9SD_AIO_SupplyBox";
					M9SD_AIO_SupplyBox allowdamage false;;
					M9SD_AIO_HelipadLight = createVehicle["PortableHelipadLight_01_green_F", _pos, [], 0, "CAN_COLLIDE"];
					M9SD_AIO_HelipadLight = [M9SD_AIO_HelipadLight] call BIS_fnc_replaceWithSimpleObject;
					M9SD_AIO_HelipadLight setVehicleVarName "M9SD_AIO_HelipadLight";
					M9SD_AIO_HelipadLight attachTo[M9SD_AIO_SupplyBox, [0, 0, 0.5]];;
					
					M9SD_AIO_glowLight1 = createVehicle ['#lightpoint', _pos,[],0,'CAN_COLLIDE'];
					M9SD_AIO_glowLight1 attachto [M9SD_AIO_SupplyBox,[0,0,0.5]];
					
					_fnc =  { 
						if (!hasInterface) exitWith {}; 
						params ['_light','_vic']; 
						if (!isNull _light) then 
						{ 
							_light setLightBrightness 0.14; 
							_color = [0.1,1,0.1];
							_light setLightAmbient _color; 
							_light setLightColor _color; 
						}; 
					};
					M9SD_AIO_REfnc_initArsenalLight = ['b2', _fnc]; 
					publicVariable 'M9SD_AIO_REfnc_initArsenalLight'; 
					
					[ 
						[ 
							M9SD_AIO_glowLight1,  
							Tesla_testVehicle 
						], 
						{ 
							_this spawn (M9SD_AIO_REfnc_initArsenalLight select 1); 
						} 
					] remoteExec ['spawn', 0, M9SD_AIO_glowLight1];
					
					
					[[M9SD_AIO_SupplyBox, M9SD_AIO_HelipadLight, M9SD_AIO_glowLight1], {
						params['_M9SD_AIO_SupplyBox', '_M9SD_AIO_HelipadLight', '_M9SD_AIO_glowLight1'];
						waitUntil {
							sleep 1;
							(!alive _M9SD_AIO_SupplyBox)
						};
						deleteVehicle _M9SD_AIO_SupplyBox;
						deleteVehicle _M9SD_AIO_HelipadLight;
						deleteVehicle _M9SD_AIO_glowLight1;
					}] remoteExec['spawn', 2];
					clearWeaponCargoGlobal M9SD_AIO_SupplyBox;
					clearBackpackCargoGlobal M9SD_AIO_SupplyBox;
					clearMagazineCargoGlobal M9SD_AIO_SupplyBox;
					clearItemCargoGlobal M9SD_AIO_SupplyBox;
				} else {
					M9SD_AIO_SupplyBox = _entity;
				};
				if (isNull M9SD_AIO_SupplyBox) exitWith {};

				["AmmoboxInit", [M9SD_AIO_SupplyBox, true]] call BIS_fnc_arsenal;
				publicVariable 'M9SD_AIO_SupplyBox';
				M9SD_fnc_addSmallArsenalActions = {
					params[['_supplyCrate', objNull]];
					if (isNull _supplyCrate) exitWith {};
					if (_supplyCrate getVariable['M9SD_hasArsenalActions', false]) exitWith {};
					_supplyCrate setVariable['M9SD_hasArsenalActions', true, true];
					if (isNil 'M9SD_AIOArsenal_JIPCount') then {
						M9SD_AIOArsenal_JIPCount = 0;
					};
					M9SD_AIOArsenal_JIPCount = M9SD_AIOArsenal_JIPCount + 1;
					publicVariable 'M9SD_AIOArsenal_JIPCount';
					private _uniqueJIP = format['M9SD_JIP_AIOArsenalActions_%1', M9SD_AIOArsenal_JIPCount];
					[
						[_supplyCrate, _uniqueJIP], {
							if (!hasInterface) exitWith {};
							params[['_supplyCrate', objNull], ['_uniqueJIP', '']];
							if (isNull _supplyCrate) exitWith {
								remoteExec['', _uniqueJIP]
							};
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='a3\ui_f\data\logos\a_64_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Full Arsenal</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									['Preload'] call BIS_fnc_arsenal;
									comment "['Open', [true]] call BIS_fnc_arsenal; <-- WTF IS THE DIFFERENCE?";
									['Open', true] spawn BIS_fnc_arsenal;
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification1'
										cutText["<br/><t color='#00ff00' size='2.1' shadow='2' font='puristaMedium'>AIO Arsenal</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 1;
										if !(isNull findDisplay - 1) then {
											'arsenalNotification2'
											cutFadeOut 0;
											'arsenalNotification2'
											cutText["<br/><br/><br/><t color='#00a6ff' size='1.2' shadow='2' font='puristaSemiBold'>by <t color='#00c9ff'>M9-SD</t>", "PLAIN DOWN", -1, true, true];
										};
										uiSleep 7;
										'arsenalNotification1'
										cutFadeOut 2.1;
										'arsenalNotification2'
										cutFadeOut 2.1;
									};
									private _arsenalAnims = [{
										player playActionNow "Salute";
									}, {
										[player, 'acts_civilidle_1'] remoteExec['switchMove'];
									}, {
										[player, 'acts_civilListening_2'] remoteExec['switchMove'];
									}, {
										[player, 'acts_commenting_on_fight_loop'] remoteExec['switchMove'];
									}, {
										[player, 'acts_gallery_visitor_01'] remoteExec['switchMove'];
									}, {
										[player, 'acts_gallery_visitor_02'] remoteExec['switchMove'];
									}, {
										[player, 'acts_hilltop_calibration_loop'] remoteExec['switchMove'];
									}, {
										[player, 'acts_kore_talkingoverradio_loop'] remoteExec['switchMove'];
									}, {
										[player, 'acts_staticPose_photo'] remoteExec['switchMove'];
									}, {
										player playActionNow 'gear';
									}, {
										[player, 'Acts_Taking_Cover_From_Jets'] remoteExec['switchMove'];
									}, {
										[player, 'Acts_standingSpeakingUnarmed'] remoteExec['switchMove'];
									}, {
										player playMoveNow 'acts_Mentor_Freeing_Player';
									}, {
										[player, 'acts_kore_talkingOverRadio_In'] remoteExec['switchMove'];
									}, {
										[player, 'acts_kore_idleNoWeapon_In'] remoteExec['switchMove'];
									}, {
										[player, 'Acts_JetsOfficerSpilling'] remoteExec['switchMove'];
									}, {
										player playMoveNow 'Acts_Hilltop_Calibration_Pointing_Left';
									}, {
										player playMoveNow 'Acts_Hilltop_Calibration_Pointing_Right';
									}, {
										[player, 'Acts_Grieving'] remoteExec['switchMove'];
									}];
									private _arsenalAnimsAdd =
									switch (currentWeapon player) do {
										case '':{
												[]
											};
										case (primaryWeapon player):{
												[{
													[player, 'acts_briefing_SA_loop'] remoteExec['switchMove'];
												}, {
													[player, 'acts_getAttention_loop'] remoteExec['switchMove'];
												}, {
													[player, 'acts_millerIdle'] remoteExec['switchMove'];
												}, {
													player playMoveNow 'Acts_SupportTeam_Right_ToKneelLoop';
												}, {
													player playMoveNow 'Acts_SupportTeam_Left_ToKneelLoop';
												}, {
													player playMoveNow 'Acts_SupportTeam_Front_ToKneelLoop';
												}, {
													player playMoveNow 'Acts_SupportTeam_Back_ToKneelLoop';
												}, {
													[player, 'Acts_starGazer'] remoteExec['switchMove'];
												}, {
													player playMoveNow 'acts_RU_briefing_Turn';
												}, {
													player playMoveNow 'acts_RU_briefing_point';
												}, {
													player playMoveNow 'acts_RU_briefing_point_tl';
												}, {
													player playMoveNow 'acts_RU_briefing_move';
												}, {
													[player, 'acts_rifle_operations_zeroing'] remoteExec['switchMove'];
												}, {
													player playMoveNow 'acts_rifle_operations_right';
												}, {
													player playMoveNow 'acts_rifle_operations_left';
												}, {
													player playMoveNow 'acts_rifle_operations_front';
												}, {
													player playMoveNow 'acts_rifle_operations_checking_chamber';
												}, {
													player playMoveNow 'acts_rifle_operations_barrel';
												}, {
													player playMoveNow 'acts_rifle_operations_back';
												}, {
													player playMoveNow 'acts_pointing_up';
												}, {
													player playMoveNow 'acts_pointing_down';
												}, {
													player playMoveNow 'acts_peering_up';
												}, {
													player playMoveNow 'acts_peering_down';
												}, {
													player playMoveNow 'acts_peering_front';
												}, {
													[player, 'Acts_Helping_Wake_Up_1'] remoteExec['switchMove'];
												}]
											};
										case (handgunWeapon player):{
												[{
													[player, 'acts_examining_device_player'] remoteExec['switchMove'];
												}, {
													[player, 'acts_executioner_standingloop'] remoteExec['switchMove'];
												}, {
													player playMoveNow 'Acts_ViperMeeting_A_End';
												}, {
													player playMoveNow 'Acts_UGV_Jamming_Loop';
												}, {
													player playMoveNow 'Acts_starterPistol_Fire';
												}]
											};
										default {
											[]
										};
									};
									_arsenalAnims = _arsenalAnims + _arsenalAnimsAdd;
									private _playAnim = selectRandom _arsenalAnims;
									call _playAnim;
									if !(isNil "M9SD_EH_ResetPlayerAnimsOnArsenalClosed") then {
										(findDisplay 46) displayRemoveEventHandler['keyDown', M9SD_EH_ResetPlayerAnimsOnArsenalClosed];
									};
									M9SD_EH_ResetPlayerAnimsOnArsenalClosed = (findDisplay 46) displayAddEventHandler['keyDown', {
										params["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
										private _w = 17;
										private _a = 30;
										private _s = 31;
										private _d = 32;
										private _keys = [_w, _a, _s, _d];
										if (_key in _keys) then {
											comment
												" 
											playSound['addItemOK', true];
											playSound['addItemOK', false];
											"; 
											if !(isNil "M9SD_EH_ResetPlayerAnimsOnArsenalClosed") then {
												(findDisplay 46) displayRemoveEventHandler['keyDown', M9SD_EH_ResetPlayerAnimsOnArsenalClosed];
											};
											player enableSimulation true;
											player playActionNow '';
											player playMoveNow '';
											player switchMove '';
											if (isMultiplayer) then {
												[player, ''] remoteExec['switchMove']
											};
											'arsenalNotification1'
											cutFadeOut 0;
											'arsenalNotification2'
											cutFadeOut 0;
											comment
												" 
											playSound['hintCollapse', true];
											playSound['hintCollapse', false];
											"; 
										};
									}];
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							
							_supplyCrate addAction
							[
								"<t color='#FFFFFF' size='1.2'><img image='\A3\ui_f\data\map\diary\icons\taskCustom_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Copy Loadout</t>", 
								{
									playSound ['beep_target', true]; 
									playSound ['beep_target', false]; 
									player playmovenow 'AinvPknlMstpSnonWnonDnon_1'; 
									private _nearMen = nearestObjects [player, ['Man'], 21]; 
									if ((count _nearMen) <= 1) exitWith  
									{ 
									 playSound ['AddItemFailed', true]; 
									 playSound ['AddItemFailed', false]; 
									 0 = [] spawn  
									 { 
									  for '_i' from 1 to 12 do  
									  { 
									   (format ['arsenalNotification%1', _i]) cutFadeOut 0; 
									  }; 
									  'arsenalNotification8' cutFadeOut 0;  
									  'arsenalNotification8' cutText ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>ERROR:<br/>No unit is close enough.</t>", "PLAIN DOWN", -1, true, true]; 
									  uiSleep 3.5; 
									  'arsenalNotification8' cutFadeOut 0.35; 
									 }; 
									}; 
									private _nearestMan = _nearMen # 1; 
									private _loadout = getUnitLoadout _nearestMan; 
									player setUnitLoadout _loadout; 
									private _unitName = name _nearestMan; 
									private _notifText = format ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>Nearest unit’s loadout copied:<br/><br/><t color='#FFFFFF' font='puristaSemiBold'>“%1”</t>", _unitName]; 
									0 = _notifText spawn  
									{ 
									 for '_i' from 1 to 12 do  
									 { 
									  (format ['arsenalNotification%1', _i]) cutFadeOut 0; 
									 }; 
									 'arsenalNotification8' cutFadeOut 0;  
									 'arsenalNotification8' cutText [_this, "PLAIN DOWN", -1, true, true]; 
									 uiSleep 3.5; 
									 'arsenalNotification8' cutFadeOut 0.35; 
									}; 
									playSound ['hintExpand', true]; 
									playSound ['hintExpand', false]; 
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_gear_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Empty Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playmovenow 'AinvPknlMstpSnonWnonDnon_1';
									removeAllWeapons player;
									removeAllItems player;
									removeAllAssignedItems player;
									removeUniform player;
									removeVest player;
									removeBackpack player;
									removeHeadgear player;
									removeGoggles player;
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification4'
										cutFadeOut 0;
										'arsenalNotification4'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Loadout removed.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.5;
										'arsenalNotification4'
										cutFadeOut 0.35;
									};
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='a3\3den\data\displays\Display3DEN\ToolBar\save_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Save Respawn Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playActionNow 'putdown';
									[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_saveInventory;
									if (!isNil "M9SD_EH_arsenalRespawnLoadout") then {
										player removeEventHandler["Respawn", M9SD_EH_arsenalRespawnLoadout];
									};
									M9SD_EH_arsenalRespawnLoadout = player addEventHandler[
										"Respawn", {
											0 = [] spawn {
												waitUntil {
													(alive player)
												};
												sleep 0.07;
												[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_loadInventory;
											};
										}
									];
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification6'
										cutFadeOut 0;
										'arsenalNotification6'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Respawn loadout set.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.5;
										'arsenalNotification6'
										cutFadeOut 0.35;
									};
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='a3\3den\data\displays\Display3DEN\ToolBar\open_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Load Respawn Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playActionNow 'putdown';
									if (isNil 'M9SD_EH_arsenalRespawnLoadout') then {
										playSound['AddItemFailed', true];
										playSound['AddItemFailed', false];
										0 = [] spawn {
											for '_i'
											from 1 to 12 do {
												(format['arsenalNotification%1', _i]) cutFadeOut 0;
											};
											'arsenalNotification12'
											cutFadeOut 0;
											'arsenalNotification12'
											cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>ERROR:<br/>No respawn loadout saved.</t>", "PLAIN DOWN", -1, true, true];
											uiSleep 3.5;
											'arsenalNotification12'
											cutFadeOut 0.35;
										};
									} else {
										[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_loadInventory;
										0 = [] spawn {
											for '_i'
											from 1 to 12 do {
												(format['arsenalNotification%1', _i]) cutFadeOut 0;
											};
											'arsenalNotification12'
											cutFadeOut 0;
											'arsenalNotification12'
											cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Respawn loadout applied.</t>", "PLAIN DOWN", -1, true, true];
											uiSleep 3.5;
											'arsenalNotification12'
											cutFadeOut 0.35;
										};
										playSound['hintExpand', true];
										playSound['hintExpand', false];
									};
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='\a3\3den\data\Cfg3DEN\History\deleteItems_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Delete Respawn Loadout</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playActionNow 'putdown';
									if (!isNil "M9SD_EH_arsenalRespawnLoadout") then {
										player removeEventHandler["Respawn", M9SD_EH_arsenalRespawnLoadout];
									};
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification5'
										cutFadeOut 0;
										'arsenalNotification5'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Respawn loadout disabled.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.5;
										'arsenalNotification5'
										cutFadeOut 0.35;
									};
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
							];
							
							
							_supplyCrate addAction[
								"<t color='#FFFFFF' size='1.2'><img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\heal_ca.paa'></img><t color='#00ff00' size='1.2' font='puristaBold'> Heal</t>", {
									playSound['beep_target', true];
									playSound['beep_target', false];
									player playActionNow 'Medic';
									[player] call BIS_fnc_reviveEhRespawn;
									player setDamage 0;
									player setUnconscious false;
									player setCaptive false;
									0 = [] spawn {
										for '_i'
										from 1 to 12 do {
											(format['arsenalNotification%1', _i]) cutFadeOut 0;
										};
										'arsenalNotification3'
										cutFadeOut 0;
										'arsenalNotification3'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Healing...</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 6.33;
										playSound['hintCollapse', true];
										playSound['hintCollapse', false];
										'arsenalNotification3'
										cutFadeOut 0;
										'arsenalNotification3'
										cutText["<t color='#00ff00' font='puristaMedium' shadow='2' size='1.2'>Healed.</t>", "PLAIN DOWN", -1, true, true];
										uiSleep 3.33;
										'arsenalNotification3'
										cutFadeOut 0.35;
									};
									playSound['hintExpand', true];
									playSound['hintExpand', false];
								}, nil, 7777, true, true, "", "((_this == vehicle _this) && (damage _this > 0))", 7
							];
						}
					] remoteExec['call', 0, _uniqueJIP];
				};
				[M9SD_AIO_SupplyBox] call M9SD_fnc_addSmallArsenalActions;
				M9SD_fnc_smallArsenalMarkers = {
					params[['_supplyCrate', objNull]];
					if (isNull _supplyCrate) exitWith {};
					if (_supplyCrate getVariable['M9SD_hasMarkers', false]) exitWith {};
					_supplyCrate setVariable['M9SD_hasMarkers', true, true];
					if (isNil 'M9SD_smallArsenals') then {
						M9SD_smallArsenals = [];
					};
					M9SD_smallArsenals pushBackUnique _supplyCrate;
					publicVariable 'M9SD_smallArsenals';
					[M9SD_smallArsenals, {
						if (!hasInterface) exitWith {};
						waitUntil {
							!isNil {
								player
							} && {!isNull player
							}
						};
						waitUntil {
							!isNull(findDisplay 46)
						};
						if (isNil 'M9SD_smallArsenals') then {
							M9SD_smallArsenals = _this;
						};
						M9SD_smallArsenalIcons_texture = '\a3\3den\data\displays\display3den\entitymenu\arsenal_ca.paa';
						M9SD_smallArsenalIcons_width = 0.7;
						M9SD_smallArsenalIcons_height = 0.7;
						M9SD_smallArsenalIcons_angle = 0;
						M9SD_smallArsenalIcons_text = 'Virtual Arsenal';
						M9SD_smallArsenalIcons_shadow = 2;
						M9SD_smallArsenalIcons_textSize = 0.04;
						M9SD_smallArsenalIcons_font = 'PuristaSemiBold';
						M9SD_smallArsenalIcons_textAlign = 'center';
						M9SD_smallArsenalIcons_drawSideArrows = false;
						M9SD_smallArsenalIcons_offsetX = 0;
						M9SD_smallArsenalIcons_offsetY = -0.07;
						M9SD_smallArsenalIcons_offset = 2.1;
						if (not(isNil 'M9SD_EH_drawSmallArsenal3D')) then {
							removeMissionEventHandler['Draw3D', M9SD_EH_drawSmallArsenal3D];
						};
						M9SD_EH_drawSmallArsenal3D = addMissionEventHandler['Draw3D', {
							if (count M9SD_smallArsenals == 0) exitWith {}; {
								if (!isNull _x) then {
									if (_x in [cursorTarget, cursorObject]) then {
										if ((_x distance(vehicle player)) <= 28) then {
											private _position = getPos _x;
											_position set[2, (_position# 2) + M9SD_smallArsenalIcons_offset];
											drawIcon3D
												[
													M9SD_smallArsenalIcons_texture, [1, 1, 1, 1],
													_position,
													M9SD_smallArsenalIcons_width,
													M9SD_smallArsenalIcons_height,
													M9SD_smallArsenalIcons_angle,
													'',
													M9SD_smallArsenalIcons_shadow,
													M9SD_smallArsenalIcons_textSize,
													M9SD_smallArsenalIcons_font,
													M9SD_smallArsenalIcons_textAlign,
													M9SD_smallArsenalIcons_drawSideArrows,
													M9SD_smallArsenalIcons_offsetX,
													M9SD_smallArsenalIcons_offsetY
												];
											drawIcon3D
												[
													'', [0, 1, 0, 1],
													_position,
													M9SD_smallArsenalIcons_width,
													M9SD_smallArsenalIcons_height,
													M9SD_smallArsenalIcons_angle,
													M9SD_smallArsenalIcons_text,
													M9SD_smallArsenalIcons_shadow,
													M9SD_smallArsenalIcons_textSize,
													M9SD_smallArsenalIcons_font,
													M9SD_smallArsenalIcons_textAlign,
													M9SD_smallArsenalIcons_drawSideArrows,
													M9SD_smallArsenalIcons_offsetX,
													M9SD_smallArsenalIcons_offsetY
												];
										};
									};
								};
							}
							forEach M9SD_smallArsenals;
						}];
						waitUntil {
							!isNull(findDisplay 12 displayCtrl 51)
						};
						
						
						
						
						
						if (!isNil "M9SD_EH_drawSmallArsenal2D") then {
							(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler["Draw", M9SD_EH_drawSmallArsenal2D];
						};
						
						
						M9SD_AIO_color1 = [0, 1, 0, 1];
						M9SD_AIO_color2 = [1, 1, 1, 1];
						M9SD_AIO_iconPath = 'a3\ui_f\data\logos\a_64_ca.paa';
						
						M9SD_EH_drawSmallArsenal2D = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler["Draw", 
						{
							_map = _this select 0;
							if (count M9SD_smallArsenals == 0) exitWith {}; 
							{
								if (!isNull _x) then 
								{
									_pos = _x modelToWorldVisual [0, 0, 0];
									_iconText =
									if (((_map ctrlMapWorldToScreen (_x modelToWorldVisual[0, 0, 0])) distance2D getMousePosition) > 0.02) then {
										""
									} else {
										'Virtual Arsenal'
									};
									_map drawIcon
									[
										M9SD_AIO_iconPath,
										M9SD_AIO_color1,
										_pos,
										20,
										20,
										0,
										_iconText,
										1,
										0.05,
										"PuristaBold",
										"left"
									];
									_map drawIcon
									[
										M9SD_AIO_iconPath,
										M9SD_AIO_color2,
										_pos,
										20,
										20,
										0,
										'',
										1,
										0.05,
										"PuristaSemiBold",
										"left"
									];
								};
							} forEach M9SD_smallArsenals;
						}];
					}] remoteExec['spawn', 0, 'M9SD_JIP_smallArsenalIcons'];
					comment " 
					M9SD_smallArsenals = [];
					publicVariable 'M9SD_smallArsenals';
					remoteExec['', 'M9SD_JIP_smallArsenalIcons'];
					"; 
				};
				[M9SD_AIO_SupplyBox] call M9SD_fnc_smallArsenalMarkers;
				[M9SD_AIO_SupplyBox, false] remoteExec['allowDamage']; 
				{
					[_x, false] remoteExec['allowDamage'];
				}forEach attachedObjects M9SD_AIO_SupplyBox;
				{
					[_x, [
						[M9SD_AIO_SupplyBox], true
					]] remoteExec['addCuratorEditableObjects', owner _x];
					[_x, [attachedObjects M9SD_AIO_SupplyBox, true]] remoteExec['addCuratorEditableObjects', owner _x];
				}forEach allCurators;
				["AIO Arsenal Created.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			};

			
		};


	comment "Automatic Missions";

		MAZ_EZM_fnc_newHelicrashMission = {
			MAZ_EZM_fnc_crashSetPosition = {
				params ["_crater"];
				private _crashLocations = switch (worldName) do {
					case "Altis": {[[4426,14856.8,0],[4798.99,12639.2,0],[4877.75,20329.2,0],[5231.58,14871.2,0],[5578.27,17465.8,0],[6163.38,19324.6,0],[6449.08,13172.7,0],[6543.98,11516.5,0],[6718.32,19145.1,0],[7752.5,15274.9,0],[8158.96,20422.5,0],[8397.1,12966.5,0],[8819.66,11798.1,0],[8791.14,14868,0],[8870,18726,0],[9221.45,22106.7,0],[9279.24,16893.5,0],[9595.95,18836.4,0],[10056.8,8474.84,0],[10412.4,15523.6,0],[10447,12258,0],[10673.2,8163.02,0],[10643.5,16961,0],[10664,14861.2,0],[10905,13319,0],[11107.4,20417.6,0],[11265.5,6763.46,0],[11418.7,8021.57,0],[11555.3,9178.9,0],[11652.9,16580.6,0],[11822.7,21807.9,0],[11970.8,17921.5,0],[12292.4,8427.08,0],[12290.6,14908.5,0],[12272.3,16782.4,0],[12707.5,20893,0],[12818,19687,0],[13025.3,21797.8,0],[13788.3,18012.9,0],[14277.1,22192.4,0],[14352.3,21860.1,0],[14630.3,21582.1,0],[15139,18725,0],[16196.8,20505.8,0],[16511,9939,0],[16633,16039,0],[16757.5,18699.3,0],[16823,17206,0],[17268,17010,0],[17489,12283,0],[17680,15862.8,0],[18060.6,17167.3,0],[18200,10589,0],[18449.8,7986.42,0],[18442.5,14388.5,0],[18836.6,11992,0],[18850.1,17212,0],[19274,14905,0],[19455.6,7522.52,0],[19433,15434,0],[19616.9,8790.04,0],[19673.1,18544.6,0],[19896.6,6270.58,0],[20087,11211,0],[20075.9,19464.4,0],[20148.9,17218,0],[20283.4,13243.4,0],[20763,14738,0],[20747.2,18601.4,0],[20799.7,19459.5,0],[20959.8,10528.6,0],[20940.1,16583.9,0],[21099,13434,0],[21290.6,19486.8,0],[21491.1,8666.78,0],[21628.6,21366.1,0],[21746.5,16236.1,0],[21844.3,7684.46,0],[21975.9,18559.1,0],[21993,15601.4,0],[22062.4,21577.7,0],[22049.4,20284.7,0],[22190.1,15193,0],[22280.9,20129.4,0],[22604.7,22341.4,0],[22693.9,22075.5,0],[23106.8,21565.2,0],[23538.1,20580.1,0],[23755.2,22248.2,0],[23718.1,23545.8,0],[23900.7,23003.5,0],[24009.6,21359.9,0],[24143.3,23747.1,0],[24365,22093,0],[24527.1,23024.5,0],[24692.7,20078,0],[24708,21195.1,0],[24721.8,23393,0],[24952,20877,0],[25226,19954,0],[25563.3,19567.9,0],[25551.8,22500.9,0],[25574.9,20376.8,0],[25687,21512,0],[25765,22222,0],[26024.9,19984.3,0],[26259.4,20418.7,0],[26685.8,21184.4,0],[27493.4,21481.1,0],[27631.7,23592.4,0],[27672.3,23252.4,0],[27887.2,22497.3,0]]};
					case "Stratis": {[[1928.22,3534.36,0],[1977.5,2723.25,0],[2068.9,5612.03,0],[2112.91,3835.67,0],[2684.1,1259.8,0],[2678.56,4478.38,0],[2729.22,2977.94,0],[2792.35,1755.79,0],[2726.1,5830.9,0],[2986.6,1872.88,0],[2947.12,6035.31,0],[3356.14,2910.95,0],[3449.37,5377.28,0],[3559.39,4898.91,0],[3782.19,5584.72,0],[4081.06,4566.71,0],[4282.01,3705.89,0],[4231.02,6768.26,0],[4388.32,4428.61,0],[4617.95,5293.65,0],[5025.48,5905.11,0],[5207.32,5032.42,0],[5333.03,5230.53,0],[5585.59,4669.99,0],[6464.77,5312.47,0],[6559.19,5070.86,0]]};
					case "Tanoa": {[[1994.01,3318.69,0],[1977.91,6149.22,0],[2406.13,13314,0],[2635.34,11693.8,0],[2731.29,5743.97,0],[2963.1,9292.33,0],[3372.5,6528.03,0],[3857.02,13448.1,0],[4714.84,3566.41,0],[4802.19,5109.05,0],[5260.83,8748.35,0],[5282.02,11607.9,0],[5605.38,11187.2,0],[5791.82,4161.52,0],[6055.39,10381.1,0],[6247.1,9359.79,0],[6535.95,12748.7,0],[6761.22,7269.57,0],[6948.91,13296,0],[7036.33,4106.12,0],[7567.5,8102.3,0],[7562.46,12551.3,0],[8366.63,9835.1,0],[8726.58,4350.14,0],[8913.88,13772,0],[9096.26,10198.7,0],[9312.51,7382.55,0],[9419.4,4160.3,0],[9858.19,13305.3,0],[9896.49,12066.1,0],[10543.3,6618.74,0],[10684.3,8703.72,0],[10962.4,9778.89,0],[11013.3,3984.29,0],[11271.9,5088.14,0],[11439.7,12379.6,0],[11757,10253.7,0],[11901.4,3219.96,0],[11915.4,12982.1,0],[12167.1,2558.17,0],[12507.7,8126.96,0],[12495.4,8120.56,0],[12621.3,12159.2,0],[12885.6,4726.58,0],[13547.7,12353.7,0]]};
					case "Malden": {[[1173.52,553.341,0],[2574.27,3384.17,0],[2583.97,4498.49,0],[3166.79,6499.55,0],[3384.68,5855.92,0],[3499.89,8463.32,0],[3660.96,5224.26,0],[3726.6,3343.97,0],[3967.86,7360.91,0],[4135.1,6178.93,0],[4183.96,6838.41,0],[4356.08,2664.51,0],[4574.04,3726.52,0],[4478.59,9502.34,0],[4739.8,9874.42,0],[5078.69,7370.66,0],[5215.15,4752.49,0],[5228.77,6113.76,0],[5353.05,4125.18,0],[5374.87,4474.32,0],[5363.94,8711.72,0],[5543.19,11192.8,0],[5657.82,7003.13,0],[5907.66,3348.21,0],[5972.87,9644.25,0],[6004.93,6552.75,0],[6192.93,8605.72,0],[6206.64,10717,0],[6595.55,3999.55,0],[6853.07,5497.6,0],[6971.02,4776.37,0],[6925.04,11188.2,0],[6952.59,9921.21,0],[7005.67,8298.7,0],[7173.55,5916.48,0],[7332.62,6976.11,0],[7553.26,10731,0],[7803.76,4451.71,0],[7788.3,7683.12,0],[8138.48,3109.62,0],[8146.16,10031.8,0],[8280.43,2937.81,0],[8327.22,5660.38,0],[8526.92,3246.26,0]]};
					case "Enoch": {[[3094.28,6975.88,0],[3042.18,5372.35,0],[3208.97,2258.87,0],[3439.1,8982.46,0],[3434.31,11016.1,0],[3642.56,8689.51,0],[4137.82,7578.32,0],[4179.18,10347.8,0],[4541.4,4743.86,0],[5256.73,2160.37,0],[5130.52,10421.7,0],[5598.42,8704.12,0],[5911.77,7912.09,0],[6130.03,8106.55,0],[6426.88,10990.5,0],[6881.97,1203.95,0],[7293.8,2718.96,0],[7628.54,5652.17,0],[7887.01,9806.89,0],[7930.4,10720.5,0],[8132.23,11082.9,0],[8272.61,8822.85,0],[8424.41,10082,0],[8940.26,6589.97,0],[9107.57,1685.31,0],[9033.24,4388.54,0],[9284.32,11058,0],[9731.2,7845.74,0],[9889.61,8624.03,0],[10400.6,6797.57,0],[11122.2,2492.39,0],[11305.6,9583.08,0]]};
					case "VR": {[[7520.18,7513.92,0]]};
				};
				private _position = selectRandom _crashLocations;
				_crater setPosATL _position;
				_crater setVectorUp surfaceNormal position _crater;
				private _randomDir = round (random 360);
				_crater setDir _randomDir;
				_position;
			};

			MAZ_EZM_fnc_createSoldierMission = {
				params ["_location","_groupSize"];
				private _position = [[[_location,50]],[]] call BIS_fnc_randomPos;
				private _unitLoadouts = [
					[["arifle_Katiba_F","","acc_pointer_IR","optic_ACO_grn",["30Rnd_65x39_caseless_green",30],[],""],[],[],["U_O_CombatUniform_ocamo",[["FirstAidKit",5]]],["V_HarnessO_brn",[["HandGrenade",2,1],["SmokeShell",2,1],["SmokeShellGreen",1,1],["30Rnd_65x39_caseless_green",11,30]]],[],"H_HelmetLeaderO_ocamo","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_hex_F"]],
					[["arifle_AK12U_F","","acc_pointer_IR","optic_ACO_grn",["30Rnd_762x39_AK12_Mag_F",30],[],""],[],[],["U_O_CombatUniform_ocamo",[["FirstAidKit",5]]],["V_HarnessO_brn",[["HandGrenade",2,1],["SmokeShell",2,1],["SmokeShellGreen",1,1],["30Rnd_762x39_AK12_Mag_F",5,30]]],[],"H_HelmetLeaderO_ocamo","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_hex_F"]],
					[["arifle_CTAR_hex_F","","acc_pointer_IR","optic_Arco",["30Rnd_580x42_Mag_F",30],[],""],[],[],["U_O_CombatUniform_ocamo",[["FirstAidKit",5]]],["V_HarnessO_brn",[["HandGrenade",2,1],["SmokeShell",2,1],["SmokeShellGreen",1,1],["30Rnd_580x42_Mag_F",5,30]]],[],"H_HelmetLeaderO_ocamo","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_hex_F"]],
					[["srifle_DMR_01_F","","","optic_DMS",["10Rnd_762x54_Mag",10],[],""],[],[],["U_O_CombatUniform_ocamo",[["FirstAidKit",5]]],["V_HarnessO_brn",[["HandGrenade",2,1],["SmokeShell",2,1],["SmokeShellGreen",1,1],["10Rnd_762x54_Mag",5,10]]],[],"H_HelmetLeaderO_ocamo","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_hex_F"]],
					[["LMG_Zafir_F","","","optic_Holosight",["150Rnd_762x54_Box",150],[],""],[],[],["U_O_CombatUniform_ocamo",[["FirstAidKit",5]]],["V_HarnessO_brn",[["HandGrenade",2,1],["SmokeShell",2,1],["SmokeShellGreen",1,1],["150Rnd_762x54_Box",1,150]]],[],"H_HelmetLeaderO_ocamo","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","O_NVGoggles_hex_F"]]
				];

				private _soldiersCreated = [];
				private _soldierGroup = createGroup [east,true];
				for "_i" from 0 to (_groupSize-1) do {
					private _soldier = _soldierGroup createUnit ["O_Soldier_F",[23405.7,17895.8,0],[],0,"CAN_COLLIDE"];
					_soldier setPosATL _position;
					_soldier setVectorDirAndUp [[0,1,0],[0,0,1]];
					_soldier setUnitLoadout (selectRandom _unitLoadouts);
					_soldier setUnitPos "UP";

					[_soldierGroup,0] setWaypointPosition [position leader _soldierGroup,0];
					_soldierGroup setGroupID ["Alpha 1-1"];;

					_soldiersCreated pushBack _soldier;
				};
				_soldierGroup selectLeader (_soldiersCreated select 0);
				_soldierGroup allowFleeing 0;

				comment "Add waypoints";
				_position = [[[_location,35]],[]] call BIS_fnc_randomPos;
				private _moveWaypoint = _soldierGroup addWaypoint [_position,0];
				_moveWaypoint setWaypointType "MOVE";
				_moveWaypoint setWaypointBehaviour "SAFE";
				_moveWaypoint setWaypointSpeed "LIMITED";

				_position = [[[_location,35]],[]] call BIS_fnc_randomPos;
				_moveWaypoint = _soldierGroup addWaypoint [_position,0];
				_moveWaypoint setWaypointType "MOVE";
				_moveWaypoint setWaypointBehaviour "SAFE";
				_moveWaypoint setWaypointSpeed "LIMITED";

				_position = [[[_location,35]],[]] call BIS_fnc_randomPos;
				_moveWaypoint = _soldierGroup addWaypoint [_position,0];
				_moveWaypoint setWaypointType "MOVE";
				_moveWaypoint setWaypointBehaviour "SAFE";
				_moveWaypoint setWaypointSpeed "LIMITED";

				_position = [[[_location,35]],[]] call BIS_fnc_randomPos;
				_moveWaypoint = _soldierGroup addWaypoint [_position,0];
				_moveWaypoint setWaypointType "MOVE";
				_moveWaypoint setWaypointBehaviour "SAFE";
				_moveWaypoint setWaypointSpeed "LIMITED";

				_position = [[[_location,35]],[]] call BIS_fnc_randomPos;
				_moveWaypoint = _soldierGroup addWaypoint [_position,0];
				_moveWaypoint setWaypointType "MOVE";
				_moveWaypoint setWaypointBehaviour "SAFE";
				_moveWaypoint setWaypointSpeed "LIMITED";

				_position = [[[_location,35]],[]] call BIS_fnc_randomPos;
				private _cycleWaypoint = _soldierGroup addWaypoint [_position,0];
				_cycleWaypoint setWaypointType "CYCLE";
				_cycleWaypoint setWaypointBehaviour "SAFE";
				_cycleWaypoint setWaypointSpeed "LIMITED";


				_soldiersCreated;
			};

			MAZ_EZM_fnc_createSmokeForCrash = {
				params ["_position"];
				private _smokeNfire = createVehicle ["test_EmptyObjectForSmoke",_position,[],0,"CAN_COLLIDE"];
				_smokeNfire
			};

			MAZ_EZM_fnc_createReward = {
				params ["_location","_type"];
				private _position = [[[_location,15]],[]] call BIS_fnc_randomPos;
				
				private _crate = nil;
				switch (_type) do {
					case "guns": {
						_crate = createVehicle ["Box_NATO_Ammo_F",[16876.3,12244,0],[],0,"CAN_COLLIDE"];
						_crate setPos _position;
						_crate setVectorDirAndUp [[0,1,0],[-0.0346379,0,0.9994]];
						[_crate,"[[[[""arifle_Katiba_F"",""arifle_ARX_blk_F"",""arifle_CTAR_hex_F"",""arifle_RPK12_F"",""arifle_MSBS65_black_F"",""LMG_Zafir_F"",""srifle_DMR_01_F"",""srifle_DMR_04_F"",""srifle_DMR_05_blk_F"",""launch_O_Vorona_brown_F""],[5,2,5,1,2,2,3,2,2,1]],[[""30Rnd_65x39_caseless_green"",""30Rnd_762x39_AK12_Mag_F"",""75rnd_762x39_AK12_Mag_F"",""10Rnd_50BW_Mag_F"",""30Rnd_580x42_Mag_F"",""30Rnd_65x39_caseless_msbs_mag"",""150Rnd_762x54_Box"",""10Rnd_762x54_Mag"",""10Rnd_127x54_Mag"",""10Rnd_93x64_DMR_05_Mag"",""Vorona_HEAT""],[20,4,2,3,12,8,4,12,5,8,1]],[[""muzzle_snds_B"",""optic_Arco"",""optic_Aco"",""optic_ACO_grn"",""optic_Holosight"",""acc_flashlight"",""acc_pointer_IR"",""optic_DMS"",""optic_AMS"",""optic_KHS_hex"",""muzzle_snds_58_hex_F"",""muzzle_snds_65_TI_blk_F"",""optic_Holosight_blk_F"",""optic_ico_01_black_f"",""optic_Arco_AK_blk_F"",""optic_DMS_weathered_Kir_F"",""Laserdesignator_02"",""FirstAidKit""],[2,4,4,4,4,5,5,4,4,3,3,3,4,3,2,3,10,20]],[[],[]]],false]"] call bis_fnc_initAmmoBox;;
					};
					case "equip": {
						_crate = createVehicle ["Box_NATO_Equip_F",[16877,12245,0],[],0,"CAN_COLLIDE"];
						_crate setPos _position;
						_crate setVectorDirAndUp [[0.774188,0.632387,0.0268383],[-0.0346456,0,0.9994]];
						[_crate,"[[[[],[]],[[],[]],[[""H_Cap_tan_specops_US"",""H_MilCap_mcamo"",""H_Booniehat_mcamo"",""H_Booniehat_tan"",""H_HelmetB_light"",""H_HelmetB_light_black"",""H_HelmetB_light_desert"",""H_HelmetB_light_grass"",""H_HelmetB_light_sand"",""H_HelmetB_light_snakeskin"",""H_HelmetB_black"",""H_HelmetB_camo"",""H_HelmetB_desert"",""H_HelmetB_grass"",""H_HelmetB_sand"",""H_HelmetB_snakeskin"",""H_HelmetSpecB"",""H_HelmetSpecB_blk"",""H_HelmetSpecB_paint2"",""H_HelmetSpecB_paint1"",""H_HelmetSpecB_sand"",""H_HelmetSpecB_snakeskin"",""H_HelmetCrew_B"",""H_PilotHelmetFighter_B"",""H_PilotHelmetHeli_B"",""H_CrewHelmetHeli_B"",""H_HelmetB_TI_tna_F"",""H_HelmetB_tna_F"",""H_HelmetB_Enh_tna_F"",""H_HelmetB_Light_tna_F"",""H_Booniehat_tna_F"",""V_Rangemaster_belt"",""V_BandollierB_blk"",""V_BandollierB_rgr"",""V_Chestrig_blk"",""V_Chestrig_rgr"",""V_TacVest_blk"",""V_PlateCarrier1_blk"",""V_PlateCarrier1_rgr"",""V_PlateCarrier2_rgr"",""V_PlateCarrier2_blk"",""V_PlateCarrierGL_blk"",""V_PlateCarrierGL_rgr"",""V_PlateCarrierGL_mtp"",""V_PlateCarrierSpec_blk"",""V_PlateCarrierSpec_rgr"",""V_PlateCarrierSpec_mtp"",""V_RebreatherB"",""V_TacChestrig_grn_F"",""V_PlateCarrier1_tna_F"",""V_PlateCarrier2_tna_F"",""V_PlateCarrierSpec_tna_F"",""V_PlateCarrierGL_tna_F"",""V_BandollierB_ghex_F"",""V_PlateCarrier1_rgr_noflag_F"",""V_PlateCarrier2_rgr_noflag_F""],[2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2]],[[],[]]],false]"] call bis_fnc_initAmmoBox;;
					};
				};
				_crate;
			};

			MAZ_EZM_fnc_crashSounds = {
				params ["_helicopter","_newPos"];
				[_helicopter,_newPos] spawn {
					params ["_helicopter","_newPos"];
					playSound3D ["A3\sounds_f\vehicles\crashes\helis\heli_crash_ground_ext_4.wss",_helicopter,false,_newPos, 5, 1, 5500];
					sleep 0.5;
					playSound3D ["A3\sounds_f\vehicles\air\noises\heli_damage_rotor_ext_2.wss",_helicopter,false,_newPos, 5, 1, 1000];
					while {!(isNull _helicopter)} do {
						playSound3D ["A3\sounds_f\vehicles\air\noises\heli_alarm_bluefor.wss",_helicopter,false,getPosASL _helicopter, 5, 1, 30];
						sleep 2.05;
					};
				};
			};

			private _craterCrash = createVehicle ["CraterLong",[23413.8,17893.8,0],[],0,"CAN_COLLIDE"];
			_craterCrash setPosWorld [23413.8,17893.8,3.25423];
			_craterCrash setVectorDirAndUp [[0,1,0],[0,0,1]];

			private _crashGhosthawk = createVehicle ["B_Heli_Transport_01_F",[23415.3,17894.2,-1.035],[],0,"CAN_COLLIDE"];
			_crashGhosthawk setPosWorld [23414.6,17894.2,4.17478];
			_crashGhosthawk setVectorDirAndUp [[0,0.95921,-0.282693],[0.46759,0.249885,0.84789]];
			_crashGhosthawk setDamage [0.62284,false];
			_crashGhosthawk lock 2;
			_crashGhosthawk enableSimulation false;
			[_crashGhosthawk,_craterCrash] call BIS_fnc_attachToRelative;
			private _newPos = [_craterCrash] call MAZ_EZM_fnc_crashSetPosition;
			[_crashGhosthawk,_newPos] call MAZ_EZM_fnc_crashSounds;

			private _positionOfCrash = getPos _craterCrash;
			private _smokeObject = [_positionOfCrash] call MAZ_EZM_fnc_createSmokeForCrash;
			private _crashObjects = [_craterCrash,_crashGhosthawk,_smokeObject];
			["TaskAssignedIcon",["A3\UI_F\Data\Map\Markers\Military\warning_CA.paa","Helicopter Crash"]] remoteExec ['BIS_fnc_showNotification',0];
			private _heliCrashMarker = createMarker ["heliCrashMarker_0",_positionOfCrash];
			_heliCrashMarker setMarkerText "Helicopter Crash";
			_heliCrashMarker setMarkerType "mil_objective";
			_heliCrashMarker setMarkerColor "ColorEAST";

			private _randomAmountOfEnemies = round (random [10,15,20]);
			private _groupSize = round (random [1,2,3]);
			_randomAmountOfEnemies = round (_randomAmountOfEnemies/_groupSize);
			private _soldiersArray = [];
			for "_i" from 0 to _randomAmountOfEnemies do {
				private _soldiersCreated = [_positionOfCrash,_groupSize] call MAZ_EZM_fnc_createSoldierMission;
				{
					_soldiersArray pushBack _x;
				}forEach _soldiersCreated;
			};


			[_soldiersArray,_heliCrashMarker,_crashObjects] spawn {
				params ["_soldiersArray","_heliCrashMarker","_crashObjects"];
				private _timer = 900;
				while {_timer > 0 && (({alive _x} count _soldiersArray) != 0)} do {
					_timer = _timer - 1;
					sleep 1;
				};
				if(({alive _x} count _soldiersArray) == 0) then {
					["TaskSucceeded",["","Helicopter Crash Secured"]] remoteExec ['BIS_fnc_showNotification',0];
					private _randomAmount = selectRandom [1,2];
					private _rewardBoxes = [];
					for "_i" from 0 to (_randomAmount-1) do {
						private _rewardType = selectRandom ["guns","equip"];
						private _rewardBox = [getPos (_crashObjects select 0),_rewardType] call MAZ_EZM_fnc_createReward;
						_rewardBoxes pushBack _rewardBox;
					};
					deleteMarker _heliCrashMarker;
					sleep 90;
					waitUntil {{isPlayer _x} count ((_crashObjects select 0) nearEntities ["Man",1600]) == 0};
					{
						deleteVehicle _x;
					} forEach _crashObjects + _soldiersArray + _rewardBoxes;
				};
				if(_timer <= 0 && (({alive _x} count _soldiersArray) != 0)) then {
					["TaskFailed",["","Helicopter Crash Not Secured"]] remoteExec ['BIS_fnc_showNotification',0];
					deleteMarker _heliCrashMarker;
					{
						deleteVehicle _x;
					} forEach _crashObjects + _soldiersArray;
				};
				sleep 600;
				if(MAZ_EZM_autoHelicrash) then {
					[] call MAZ_EZM_fnc_newHelicrashMission;
				};
			};
		};

		MAZ_EZM_fnc_newConvoyMission = {

			private _fnc_getUnitTypes = {
				params [
					"_side"
				];
				private _return = [];
				switch (_side) do {
					case west: {
						switch (worldName) do {
							case "Stratis";
							case "Malden";
							case "Altis": {
								_return = [
									"B_Soldier_A_F",
									"B_Soldier_AR_F",
									"B_Medic_F",
									"B_Soldier_GL_F",
									"B_Soldier_M_F",
									"B_Soldier_F",
									"B_Soldier_LAT_F",
									"B_Soldier_LAT2_F"
								];
							};
							case "Tanoa": {
								_return = [
									"B_T_Soldier_A_F",
									"B_T_Soldier_AR_F",
									"B_T_Medic_F",
									"B_T_Soldier_GL_F",
									"B_T_Soldier_M_F",
									"B_T_Soldier_F",
									"B_T_Soldier_LAT_F",
									"B_T_Soldier_LAT2_F"
								];
							};
							case "Enoch": {
								_return = [
									"B_W_Soldier_A_F",
									"B_W_Soldier_AR_F",
									"B_W_Medic_F",
									"B_W_Soldier_GL_F",
									"B_W_Soldier_M_F",
									"B_W_Soldier_F",
									"B_W_Soldier_LAT_F",
									"B_W_Soldier_LAT2_F"
								];
							};
						};
					};
					case east: {
						switch (worldName) do {
							case "Stratis";
							case "Malden";
							case "Altis": {
								_return = [
									"O_Soldier_A_F",
									"O_Soldier_AR_F",
									"O_Medic_F",
									"O_Soldier_GL_F",
									"O_Soldier_M_F",
									"O_Soldier_F",
									"O_Soldier_LAT_F"
								];
							};
							case "Tanoa": {
								_return = [
									"O_T_Soldier_A_F",
									"O_T_Soldier_AR_F",
									"O_T_Medic_F",
									"O_T_Soldier_GL_F",
									"O_T_Soldier_M_F",
									"O_T_Soldier_F",
									"O_T_Soldier_LAT_F"
								];
							};
							case "Enoch": {
								_return = [
									"O_R_JTAC_F",
									"O_R_Soldier_AR_F",
									"O_R_Medic_F",
									"O_R_Soldier_GL_F",
									"O_R_Soldier_M_F",
									"O_R_Soldier_LAT_F"
								]
							};
						};
					};
					case independent: {
						switch (worldName) do {
							case "Stratis";
							case "Malden";
							case "Altis": {
								_return = [
									"I_Soldier_A_F",
									"I_Soldier_AR_F",
									"I_Medic_F",
									"I_Soldier_GL_F",
									"I_Soldier_M_F",
									"I_Soldier_F",
									"I_Soldier_LAT_F",
									"I_Soldier_LAT2_F"
								];
							};
							case "Tanoa": {
								_return = [
									"I_C_Soldier_Para_7_F",
									"I_C_Soldier_Para_3_F",
									"I_C_Soldier_Para_4_F",
									"I_C_Soldier_Para_6_F",
									"I_C_Soldier_Para_8_F",
									"I_C_Soldier_Para_1_F",
									"I_C_Soldier_Para_5_F"
								];
							};
							case "Enoch": {
								_return = [
									"I_E_Soldier_A_F",
									"I_E_Soldier_AR_F",
									"I_E_Medic_F",
									"I_E_Soldier_GL_F",
									"I_E_Soldier_M_F",
									"I_E_Soldier_F",
									"I_E_Soldier_LAT_F",
									"I_E_Soldier_LAT2_F"
								];
							};
						};
					};
				};
				_return
			};

			MAZ_EZM_fnc_getConvoyInfo = {
				params ["_convoyType"];
				private _returnInfo = [];
				switch (_convoyType) do {
					case 0: {
						comment "Vehicle Types";
						_returnInfo pushBack [
							"O_APC_Wheeled_02_rcws_v2_F",
							"O_Truck_03_ammo_F",
							"O_APC_Wheeled_02_rcws_v2_F"
						];

						comment "Starting location";
						_returnInfo pushBack [10801.153,10591.354];

						comment "Starting locations";
						_returnInfo pushBack [
							[10800.998,10625.687],
							[10801.449,10578.907],
							[10799.197,10537.174]
						];

						comment "Starting direction";
						_returnInfo pushBack [0,0,0];

						comment "Waypoints";
						_returnInfo pushBack [
							[11003.723,15674.568],
							[15139.83,17539.145],
							[15797.84,16290.967],
							[15374.077,16232.825],
							[15477.943,15886.842]
						];

						comment "Ending location";
						_returnInfo pushBack [15483.02,15867.24];

						comment "Marker Locations";
						_returnInfo pushBack [
							[11256.663,13165.631],
							[11330.834,14107.15],
							[11334.651,15318.223],
							[12872.64,15937.588],
							[14940.22,17353.176],
							[15929.533,16978.57]
						];

						comment "Convoy Side";
						_returnInfo pushBack east;
					};
					case 1: {
						comment "Vehicle Types";
						_returnInfo pushBack [
							"I_APC_Wheeled_03_cannon_F",
							"I_Truck_02_ammo_F",
							selectRandom ["I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"]
						];

						comment "Starting location";
						_returnInfo pushBack [21580.479,7823.819];

						comment "Starting locations";
						_returnInfo pushBack [
							[21572.172,7857.319],
							[21584.908,7820.114],
							[21598.602,7780.707]
						];
						
						comment "Starting direction";
						_returnInfo pushBack [344.183,341.303,339.796];

						comment "Waypoints";
						_returnInfo pushBack [
							[19363.201,13328.431],
							[19378.586,15294.969],
							[25343.486,21053.148],
							[24317.18,21512.117],
							[22506.36,20784.482],
							[22019.516,21063.064]
						];

						comment "Ending location";
						_returnInfo pushBack [22024.95,21072.063];

						comment "Marker Locations";
						_returnInfo pushBack [
							[19912.098,11622.105],
							[19340.213,14848.896],
							[20502.85,16353.783],
							[22899.82,19291.697],
							[25281.32,21018.078],
							[24252.854,21534.236],
							[22653.04,20858.324]
						];

						comment "Convoy Side";
						_returnInfo pushBack independent;
					};
					case 2: {
						comment "Vehicle Types";
						_returnInfo pushBack [
							"O_APC_Tracked_02_cannon_F",
							"O_Truck_03_device_F",
							"O_APC_Wheeled_02_rcws_v2_F"
						];

						comment "Starting location";
						_returnInfo pushBack [17506.146,13205.87];

						comment "Starting locations";
						_returnInfo pushBack [
							[17488.219,13224.532],
							[17519.352,13192.043],
							[17548.129,13161.36]
						];
						
						comment "Starting direction";
						_returnInfo pushBack [316.789,316.911,313.466];

						comment "Waypoints";
						_returnInfo pushBack [
							[17284.742,13438.548],
							[15813.545,17391.84],
							[10317.244,19004.494],
							[7437.338,17151.658],
							[6188.207,16181.874],
							[6171.746,16300.393]
						];

						comment "Ending location";
						_returnInfo pushBack [6175.534,16252.588];

						comment "Marker Locations";
						_returnInfo pushBack [
							[16886.854,15487.035],
							[15497.099,17511.123],
							[12414.757,18786.67],
							[8403.481,18231.346]
						];

						comment "Convoy Side";
						_returnInfo pushBack east;
					};
					case 3: {
						comment "Vehicle Types";
						_returnInfo pushBack [
							"I_APC_Wheeled_03_cannon_F",
							"I_Truck_02_ammo_F",
							"I_APC_Wheeled_03_cannon_F",
							selectRandom ["I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"]
						];

						comment "Starting location";
						_returnInfo pushBack [3260.870,12509.276];

						comment "Starting locations";
						_returnInfo pushBack [
							[3254.868,12504.7],
							[3237.267,12498.41],
							[3220.510,12492.701],
							[3203.243,12486.627]
						];
						
						comment "Starting direction";
						_returnInfo pushBack [72.490,72.509,72.572,72.178];

						comment "Waypoints";
						_returnInfo pushBack [
							[9289.280,15856.197],
							[17870.432,18199.361]
						];

						comment "Ending location";
						_returnInfo pushBack [17870.432,18199.361];

						comment "Marker Locations";
						_returnInfo pushBack [
							[6299.041,15151.183],
							[9218.906,15837.3],
							[14542.193,16940.186],
							[17211.178,17898.922]
						];

						comment "Convoy Side";
						_returnInfo pushBack independent;
					};
				};
				_returnInfo;
			};

			MAZ_EZM_fnc_createVehicleUnitConvoy = {
				params ["_group","_unitType"];
				private _soldier = _group createUnit [_unitType,[23405.7,17895.8,0],[],0,"CAN_COLLIDE"];
				_soldier setVectorDirAndUp [[0,1,0],[0,0,1]];
				_soldier setUnitPos "UP";
				_soldier;
			};

			MAZ_EZM_fnc_createConvoyVehicle = {
				params ["_type","_vehPos","_vehDir","_group"];
				private _veh = createVehicle [_type,_vehPos,[],0,"None"];
				_veh setDir _vehDir;
				private _unitType = selectRandom ([side _group] call _fnc_getUnitTypes);
				private _vehDriver = [_group,_unitType] call MAZ_EZM_fnc_createVehicleUnitConvoy;
				_vehDriver moveInDriver _veh;
				_vehDriver limitSpeed 57;
				_vehDriver setSkill ["courage",1];
				_vehDriver setSkill ["commanding",1];
				if(_type isKindOf "Truck_F") then {
					_unitType = selectRandom ([side _group] call _fnc_getUnitTypes);
					private _vehCargo = [_group,_unitType] call MAZ_EZM_fnc_createVehicleUnitConvoy;
					_vehCargo moveInCargo _veh;
				} else {
					_unitType = selectRandom ([side _group] call _fnc_getUnitTypes);
					private _vehGunner = [_group,_unitType] call MAZ_EZM_fnc_createVehicleUnitConvoy;
					_vehGunner moveInGunner _veh;
					if (_veh emptyPositions "commander" > 0) then {
						_unitType = selectRandom ([side _group] call _fnc_getUnitTypes);
						private _vehCommander = [_group,_unitType] call MAZ_EZM_fnc_createVehicleUnitConvoy;
						_vehCommander moveInCommander _veh;
					};
				};
				_veh;
			};

			private _convoyType = selectRandom [3];
			private _convoyInfo = [_convoyType] call MAZ_EZM_fnc_getConvoyInfo;
			
			private _vehTypes = _convoyInfo select 0;
			private _startPos = _convoyInfo select 1;
			private _startLocations = _convoyInfo select 2;
			private _startDirs = _convoyInfo select 3;
			private _wayPoints = _convoyInfo select 4;
			private _endPos = _convoyInfo select 5;
			private _markerLocations = _convoyInfo select 6;
			private _convoySide = _convoyInfo select 7;

			private _convoyGroup = createGroup _convoySide;
			private _vehicles = [];
			for "_i" from 0 to (count _vehTypes-1) do {
				private _vehType = _vehTypes select _i;
				private _vehPos = _startLocations select _i;
				private _vehDir = _startDirs select _i;
				private _return = [_vehType,_vehPos,_vehDir,_convoyGroup] call MAZ_EZM_fnc_createConvoyVehicle;
				_vehicles pushBack _return;
			};

			private _leader = effectiveCommander (_vehicles select 0);
			_convoyGroup selectLeader _leader;
			_leader setSkill ["courage",1];
			_leader setSkill ["commanding",1];

			_convoyGroup setCombatMode "YELLOW";
			_convoyGroup setBehaviour "SAFE";
			_convoyGroup setFormation "COLUMN";
			_convoyGroup setSpeedMode "LIMITED";

			enableEnvironment [false,true];
			[[false,true]] remoteExec ['enableEnvironment',2];

			{
				private _waypoint = _convoyGroup addWaypoint [_x, 0];
				_waypoint setWaypointType "MOVE";
				_waypoint setWaypointCompletionRadius 35;
				_waypoint setWaypointCombatMode "YELLOW";
				_waypoint setWaypointBehaviour "SAFE";
				_waypoint setWaypointFormation "COLUMN";
				_waypoint setWaypointSpeed "LIMITED";
			} forEach _wayPoints;
			private _numWaypoints = count waypoints _convoyGroup;

			private _cargoVehicles = [];
			{
				_x allowCrewInImmobile true;
				[_x,2] remoteExec ['lock',0,_x];
				_x limitSpeed 57;
				(driver _x) limitSpeed 57;
				_x forceSpeed 15.84;
				_x setConvoySeparation 90;
				private _driverVeh = driver _x;
				_driverVeh allowFleeing 0;
				_driverVeh disableAI "AUTOCOMBAT";
				_driverVeh disableAI "TARGET";
				_driverVeh disableAI "MINEDETECTION";
				if(typeOf _x isKindOf "Truck_F") then {
					_cargoVehicles pushBack _x;
				};
			}forEach _vehicles;

			{
				_x limitSpeed 57;
				_x disableAI "MINEDETECTION";
			}forEach (units _convoyGroup);

			private _markers = [];

			private _markerColor = "ColorEAST";
			switch (_convoySide) do {
				case east: {_markerColor = "ColorEAST";};
				case independent: {_markerColor = "ColorGUER";};
			};
			private _convoyStartMarker = createMarker ["convoyStart_MAZ",_startPos];
			_convoyStartMarker setMarkerType "mil_marker";
			_convoyStartMarker setMarkerColor _markerColor;
			_convoyStartMarker setMarkerText "Convoy Start";
			_markers pushBack _convoyStartMarker;

			{
				private _checkpointMarker = createMarker [format ["checkPointMarker_MAZ_%1",_forEachIndex],_x];
				_checkpointMarker setMarkerType "mil_marker";
				_checkpointMarker setMarkerColor _markerColor;
				_checkpointMarker setMarkerText format ["Checkpoint #%1",_forEachIndex+1];
				_markers pushBack _checkpointMarker;
			}forEach _markerLocations;

			["TaskAssignedIcon",["A3\UI_F\Data\Map\Markers\Military\warning_CA.paa","A Convoy is Moving"]] remoteExec ['BIS_fnc_showNotification',0];

			[_vehicles] spawn {
				params ["_vehicles"];
				while {({alive _x} count _vehicles) != 0} do {
					{
						_x limitSpeed 57;
						(driver _x) limitSpeed 57;
						_x forceSpeed 15.84;
						_x setConvoySeparation 90;
					}forEach _vehicles;
					sleep 1;
				};
			};

			[_markers,_vehicles] spawn {
				params ["_markers","_vehicles"];
				for "_i" from 0 to (count _markers - 2) do {
					waitUntil {
						(
							({
								(_x distance (getMarkerPos (_markers select (_i + 1)))) < 30
							} count _vehicles) != 0
						)
					};
					["TaskAssignedIcon",["A3\UI_F\Data\Map\Markers\Military\warning_CA.paa",format ["The Convoy Has Reached Checkpoint %1",_i + 1]]] remoteExec ['BIS_fnc_showNotification',0];
				};
			};

			[_convoyGroup,_numWaypoints,_vehicles,_markers,_cargoVehicles] spawn {
				params ["_convoyGroup","_numWaypoints","_vehicles","_markers","_trucks"];
				private _soldiersArray = units _convoyGroup;
				waitUntil {currentWaypoint _convoyGroup >= _numWaypoints || (({alive _x} count _soldiersArray) == 0) || (({alive _x} count _trucks) == 0)};
				if(({alive _x} count _soldiersArray) == 0) exitWith {
					comment "Success";
					["TaskSucceeded",["","Convoy Stopped!"]] remoteExec ['BIS_fnc_showNotification',0];
					{
						deleteMarker _x;
					}forEach _markers;
					sleep 90;
					waitUntil {{isPlayer _x} count ((_vehicles select 0) nearEntities ["Man",1600]) == 0};
					{
						deleteVehicle _x;
					} forEach _vehicles + _soldiersArray;
					sleep 600;
					if(MAZ_EZM_autoConvoy) then {
						[] call MAZ_EZM_fnc_newConvoyMission;
					};
				};
				if(currentWaypoint _convoyGroup >= _numWaypoints) exitWith {
					comment "Failure";
					["TaskFailed",["","Convoy Reached Their End"]] remoteExec ['BIS_fnc_showNotification',0];
					{
						deleteMarker _x;
					}forEach _markers;
					{
						deleteVehicle _x;
					} forEach _vehicles + _soldiersArray;
					sleep 600;
					if(MAZ_EZM_autoConvoy) then {
						[] call MAZ_EZM_fnc_newConvoyMission;
					};
				};
				if(({alive _x} count _trucks) == 0) exitWith {
					comment "Failure";
					["TaskFailed",["","Convoy Cargo Destroyed!"]] remoteExec ['BIS_fnc_showNotification',0];
					{
						deleteMarker _x;
					}forEach _markers;
					sleep 90;
					waitUntil {{isPlayer _x} count ((_vehicles select 0) nearEntities ["Man",1600]) == 0};
					{
						deleteVehicle _x;
					} forEach _vehicles + _soldiersArray;
					sleep 600;
					if(MAZ_EZM_autoConvoy) then {
						[] call MAZ_EZM_fnc_newConvoyMission;
					};
				};
			};
		};

		MAZ_EZM_fnc_createRandomHelicrashModule = {
			MAZ_EZM_autoHelicrash = true;
			publicVariable 'MAZ_EZM_autoHelicrash';
			[] call MAZ_EZM_fnc_newHelicrashMission;
		};

		MAZ_EZM_fnc_turnOffRandomHelicrashModule = {
			MAZ_EZM_autoHelicrash = false;
			publicVariable 'MAZ_EZM_autoHelicrash';
			["Automated Helicopter Crashes disabled.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_createRandomConvoyModule = {
			if(worldName != "Altis") exitWith {["Currently only configured for Altis! You can create your own by contacting Expung3d!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			MAZ_EZM_autoConvoy = true;
			publicVariable 'MAZ_EZM_autoConvoy';
			[] call MAZ_EZM_fnc_newConvoyMission;
		};

		MAZ_EZM_fnc_turnOffRandomConvoyModule = {
			if(worldName != "Altis") exitWith {["Currently only configured for Altis.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			MAZ_EZM_autoConvoy = false;
			publicVariable 'MAZ_EZM_autoConvoy';
			["Automated Convoy Missions disabled.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_createGarrisonTownDialog = {
			["Garrison Town",[
				[
					"EDIT",
					["Town Name:","Enter a town name, like 'Kavala' or 'Athira'."],
					["None"]
				],
				[
					"SIDES",
					"Side of Garrison:",
					east
				],
				[
					"SLIDER",
					"Percent of Garrison:",
					[0.1,0.4,0.2,objNull,[0,0,0,0],true]
				],
				[
					"SLIDER",
					"Number of Patrols",
					[2,4,3]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_town","_side","_garrPercent","_patrols"];
				private _locationNames = [];
				{	
					private _lct = _forEachIndex;
					{	
						_locationNames pushBack (toUpper (text _x));
					} forEach nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), [_x], worldSize];	
				} forEach ["NameVillage", "NameCity", "NameCityCapital"];
				if(!(toUpper _town in _locationNames) && ((toUpper _town) != "NONE" && (toUpper _town) != "")) exitWith {["No such town!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
				private _sideNew = [[_side]] call MAZ_EZM_fnc_getSidesFromString;
				_sideNew = _sideNew # 0;
				[_town,_sideNew,_garrPercent,_patrols] spawn MAZ_EZM_fnc_garrisonTown; 
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_garrisonGroup = {
			params [
				["_group",grpNull,[grpNull]]
			];
			if(isNull _group) exitWith {};

			private _leader = leader _group;
			private _previousBehaviour = behaviour _leader;

			private _arrayShuffle = {
				private _array = _this select 0;
				private _count = count _array;
				private _arrayN = [];
				private _arrayT = [];
				private _c = 0;
				private _r = 0;

				while {_c < _count} do
				{
					while {_r in _arrayT} do
					{_r = floor (random _count);
					};
					_arrayT pushBack _r;
					_arrayN set [_c, _array select _r];
					_c = _c + 1;
				};

				_arrayN
			};

			private _fnc_getHousePositions = {
				params ["_index","_houses"];
				private _nearestBuilding = _houses select _index;
				if(isNil "_nearestBuilding") exitWith {};
				private _positionsInBuilding = [_nearestBuilding] call BIS_fnc_buildingPositions;
				_positionsInBuilding = [_positionsInBuilding] call _arrayShuffle;
				_positionsInBuilding
			};

			private _fnc_orderToPositions = {
				params ["_units","_positions","_houseIndex"];
				private _newUnits = _units;
				{
					private _unit = objNull;
					if((count _units) -1 >= _forEachIndex) then {
						private _unit = _units select _forEachIndex;
						_unit setPos _x;
						_newUnits = _newUnits - [_unit];
						_unit forceSpeed 0;
					};
				}forEach _positions;
				if((count _buildingPoses) < (count _units)) then {
					_houseIndex = _houseIndex + 1;
					_buildingPoses = [_houseIndex,_nearestBuildings] call _fnc_getHousePositions;
					[_newUnits,_buildingPoses,_houseIndex] call _fnc_orderToPositions;
				};
			};

			{
				deleteWaypoint [_group,_forEachIndex];
			}forEach (waypoints _group);

			private _nearestBuildings = nearestObjects [getPos _leader, ["building"], 50, true];

			if (_nearestBuildings isEqualTo []) exitWith { false };
			_group setbehaviour "AWARE";

			private _houseIndex = 0;
			private _buildingPoses = [_houseIndex,_nearestBuildings] call _fnc_getHousePositions;

			private _units = (units _group) select {!isNull _x && alive _x};

			[_units,_buildingPoses,_houseIndex] call _fnc_orderToPositions;

			true
		};

		MAZ_EZM_fnc_garrisonTown = {
			params [
				["_town","NONE",[""]],
				["_side",east,[east]],
				["_percentGarrison",0.2,[0.2]],
				["_numOfPatrols",selectRandom [2,3,4],[3]]
			];
			if(_side isEqualTo civilian) exitWith {false};

			private ["_position","_sizeTown"];
			_town = toUpper _town;
			private _locations = [];
			{	
				{	
					_locations pushBack [toUpper (text _x), locationPosition _x,size _x];
				} forEach nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), [_x], worldSize];	
			} forEach ["NameVillage", "NameCity", "NameCityCapital"];
			if(_town == "NONE" || _town == "") then {
				_position = [] call MAZ_EZM_fnc_getScreenPosition;
				_sizeTown = 200;
			} else {
				private _index = _locations findIf {(_x select 0) == _town};
				_townData = _locations select _index;
				_town = _townData select 0;
				_position = _townData select 1;
				(_townData select 2) params ["_x","_y"];
				_sizeTown = (_x max _y) * 0.75;
			};
			private _townAlert = format ["%1 IS UNDER ATTACK",toUpper _town];
			if(toUpper _town == "NONE") then {
				_townAlert = "A TOWN IS UNDER ATTACK";
			};

			private _fnc_getUnitTypes = {
				params [
					"_side"
				];
				private _return = [];
				switch (_side) do {
					case west: {
						switch (worldName) do {
							case "Stratis";
							case "Malden";
							case "Altis": {
								_return = [
									"B_Soldier_A_F",
									"B_Soldier_AR_F",
									"B_Medic_F",
									"B_Soldier_GL_F",
									"B_Soldier_M_F",
									"B_Soldier_F",
									"B_Soldier_LAT_F",
									"B_Soldier_LAT2_F"
								];
							};
							case "Tanoa": {
								_return = [
									"B_T_Soldier_A_F",
									"B_T_Soldier_AR_F",
									"B_T_Medic_F",
									"B_T_Soldier_GL_F",
									"B_T_Soldier_M_F",
									"B_T_Soldier_F",
									"B_T_Soldier_LAT_F",
									"B_T_Soldier_LAT2_F"
								];
							};
							case "Enoch": {
								_return = [
									"B_W_Soldier_A_F",
									"B_W_Soldier_AR_F",
									"B_W_Medic_F",
									"B_W_Soldier_GL_F",
									"B_W_Soldier_M_F",
									"B_W_Soldier_F",
									"B_W_Soldier_LAT_F",
									"B_W_Soldier_LAT2_F"
								];
							};
						};
					};
					case east: {
						switch (worldName) do {
							case "Stratis";
							case "Malden";
							case "Altis": {
								_return = [
									"O_Soldier_A_F",
									"O_Soldier_AR_F",
									"O_Medic_F",
									"O_Soldier_GL_F",
									"O_Soldier_M_F",
									"O_Soldier_F",
									"O_Soldier_LAT_F"
								];
							};
							case "Tanoa": {
								_return = [
									"O_T_Soldier_A_F",
									"O_T_Soldier_AR_F",
									"O_T_Medic_F",
									"O_T_Soldier_GL_F",
									"O_T_Soldier_M_F",
									"O_T_Soldier_F",
									"O_T_Soldier_LAT_F"
								];
							};
							case "Enoch": {
								_return = [
									"O_R_JTAC_F",
									"O_R_Soldier_AR_F",
									"O_R_Medic_F",
									"O_R_Soldier_GL_F",
									"O_R_Soldier_M_F",
									"O_R_Soldier_LAT_F"
								]
							};
						};
					};
					case independent: {
						switch (worldName) do {
							case "Stratis";
							case "Malden";
							case "Altis": {
								_return = [
									"I_Soldier_A_F",
									"I_Soldier_AR_F",
									"I_Medic_F",
									"I_Soldier_GL_F",
									"I_Soldier_M_F",
									"I_Soldier_F",
									"I_Soldier_LAT_F",
									"I_Soldier_LAT2_F"
								];
							};
							case "Tanoa": {
								_return = [
									"I_C_Soldier_Para_7_F",
									"I_C_Soldier_Para_3_F",
									"I_C_Soldier_Para_4_F",
									"I_C_Soldier_Para_6_F",
									"I_C_Soldier_Para_8_F",
									"I_C_Soldier_Para_1_F",
									"I_C_Soldier_Para_5_F"
								];
							};
							case "Enoch": {
								_return = [
									"I_E_Soldier_A_F",
									"I_E_Soldier_AR_F",
									"I_E_Medic_F",
									"I_E_Soldier_GL_F",
									"I_E_Soldier_M_F",
									"I_E_Soldier_F",
									"I_E_Soldier_LAT_F",
									"I_E_Soldier_LAT2_F"
								];
							};
						};
					};
				};
				_return
			};
			private _unitTypes = [_side] call _fnc_getUnitTypes;
			private _buildings = nearestTerrainObjects [_position,["BUILDING","HOUSE"],_sizeTown];
			private _units = [];
			{
				if((random 1) < _percentGarrison) then {
					private _randomNumOfUnits = [2,5] call BIS_fnc_randomInt;
					private _grp = createGroup [_side,true];
					for "_i" from 1 to _randomNumOfUnits do {
						private _unitType = selectRandom _unitTypes;
						private _unit = _grp createUnit [_unitType,_x,[],0,"CAN_COLLIDE"];
						_unit setSkill 0.4;
						_unit setUnitPos "UP";
						_units pushBack _unit;
					};
					[_grp] call MAZ_EZM_fnc_garrisonGroup;
				};
			}forEach _buildings;

			for "_i" from 0 to _numOfPatrols do {
				private _randPos = [[[_position,150]]] call BIS_fnc_randomPos;
				private _nearRoads = _randPos nearRoads 150;
				private _nearRoad = getPos (selectRandom _nearRoads);
				private _randomNumOfUnits = [4,6] call BIS_fnc_randomInt;

				private _grp = createGroup [_side,true];
				for "_j" from 1 to _randomNumOfUnits do {
					private _unitType = selectRandom _unitTypes;
					private _unit = _grp createUnit [_unitType, _nearRoad,[],0,"CAN_COLLIDE"];
					_unit setSkill 0.4;
					_unit setUnitPos "UP";
					_units pushBack _unit;
				};

				for "_j" from 0 to 5 do {
					private _waypoint = _grp addWaypoint [getPos (selectRandom _nearRoads),0];
					_waypoint setWaypointType "MOVE";
					_waypoint setWaypointBehaviour "SAFE";
					_waypoint setWaypointSpeed "LIMITED";
				};
				private _waypoint = _grp addWaypoint [_nearRoad,0];
				_waypoint setWaypointType "CYCLE";
				_waypoint setWaypointBehaviour "SAFE";
				_waypoint setWaypointSpeed "LIMITED";
			};

			[_units] call MAZ_EZM_fnc_addObjectToInterface;

			["TaskAssignedIcon",["A3\UI_F\Data\Map\Markers\Military\warning_CA.paa",_townAlert]] remoteExec ['BIS_fnc_showNotification',0];

			true
		};

	comment "Cinematics";

		[]call{private['_1'];_1=[];{_1 pushBack sqrt _x}forEach [8281,1600,1521,13924,7225,6400,9025,2401,2916,10609,9025,5184,9409,6241,4900,13689,9409,3249,4900,11664,9409,11881,4900,14400,14400,3025,2916,10404,5184,1024,3721,1024,15129,100,81,10201,3025,14400,12100,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,14641,13225,1024,15129,100,81,81,3025,2401,1024,1600,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,12100,3025,2916,14400,1024,1156,13924,11664,11664,13225,11664,3364,1024,2809,13225,1024,2704,11025,14161,1024,7921,13225,3136,2916,14641,1024,3025,2916,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1089,1156,3481,15625,3481,100,81,81,9025,5184,4900,14400,14400,3025,2916,10404,5184,4489,11664,11664,9409,4225,1024,3721,1024,8281,8649,3481,100,81,81,15129,100,81,81,81,9025,5184,4900,14400,14400,3025,2916,10404,5184,4489,11664,11664,9409,4225,1024,2304,3136,5184,12100,12544,9409,10609,14884,1024,7396,12544,13689,3136,11664,11881,4900,7396,1024,9025,12321,3481,100,81,81,15625,1024,2401,13225,11664,4900,9409,10609,12100,1024,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,3481,100,81,81,2304,11664,13225,2401,3025,7396,4900,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13924,7225,6400,13689,9409,3249,4900,11664,9409,2704,11025,14161,11881,4900,14400,14400,3025,2916,10404,5184,4489,11664,11664,9409,4225,1156,1936,9025,5184,4900,14400,14400,3025,2916,10404,5184,4489,11664,11664,9409,4225,8649,3481,100,81,81,2304,11664,13225,2401,3025,7396,4900,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13924,7225,6400,13689,9409,3249,4900,11664,9409,2704,11025,14161,5929,3025,14400,7396,4900,5929,4900,12321,14400,1156,1936,10609,14400,11664,7396,5929,4900,12321,14400,1024,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,13924,14641,3025,14400,10816,13225,12321,8649,3481,100,100,81,81,3249,3025,5184,5184,3025,13225,2916,2809,9409,3249,4900,11881,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,1156,1936,10609,14400,11664,7396,5929,4900,12321,14400,1024,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,13924,14641,3025,14400,10816,13225,12321,1936,14400,11664,3136,4900,8649,3481,100,81,81,3249,3025,5184,5184,3025,13225,2916,2809,9409,3249,4900,11881,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,13689,13225,7396,13225,11664,1156,1936,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,13689,13225,7396,13225,11664,13689,13225,3249,12544,13225,1024,7396,12544,5776,9409,14400,9409,1024,1600,7396,12544,13689,3136,11664,11881,4900,7396,1024,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,13689,13225,7396,13225,11664,13689,13225,3249,12544,13225,1681,1936,14400,11664,3136,4900,8649,3481,100,81,81,3249,3025,5184,5184,3025,13225,2916,2809,9409,3249,4900,11881,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,1156,1936,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,13689,13225,3249,12544,13225,1024,7396,12544,5041,9409,7396,3136,4900,1024,1600,7396,12544,13689,3136,11664,11881,4900,7396,1024,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,13689,13225,3249,12544,13225,1681,1936,14400,11664,3136,4900,8649,3481,100,81,81,3249,3025,5184,5184,3025,13225,2916,2809,9409,3249,4900,11881,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,1156,1936,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,13689,13225,3249,12544,13225,1024,7396,12544,5041,9409,7396,3136,4900,1024,1600,7396,12544,13689,3136,11664,11881,4900,7396,1024,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,13689,13225,3249,12544,13225,1681,1936,14400,11664,3136,4900,8649,3481,100,81,81,3249,3025,5184,5184,3025,13225,2916,2809,9409,3249,4900,11881,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13689,9409,3249,2704,11025,14161,5776,3025,5184,14400,9409,2916,10609,4900,7921,11664,13225,3249,13689,4900,2916,14400,4900,11664,1156,1936,13689,9409,3249,2704,11025,14161,5776,3025,5184,14400,9409,2916,10609,4900,7921,11664,13225,3249,13689,4900,2916,14400,4900,11664,13689,13225,3249,12544,13225,1024,7396,12544,5041,9409,7396,3136,4900,1024,1600,7396,12544,13689,3136,11664,11881,4900,7396,1024,13689,9409,3249,2704,11025,14161,5776,3025,5184,14400,9409,2916,10609,4900,7921,11664,13225,3249,13689,4900,2916,14400,4900,11664,13689,13225,3249,12544,13225,1681,1936,14400,11664,3136,4900,8649,3481,100,81,81,3249,3025,5184,5184,3025,13225,2916,2809,9409,3249,4900,11881,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13689,9409,3249,2704,11025,14161,12769,4900,3025,10404,12100,14400,4489,12544,13225,6241,4900,13689,4900,2916,14400,4900,11664,1156,1936,13689,9409,3249,2704,11025,14161,12769,4900,3025,10404,12100,14400,4489,12544,13225,6241,4900,13689,4900,2916,14400,4900,11664,13689,13225,3249,12544,13225,1024,7396,12544,5041,9409,7396,3136,4900,1024,1600,7396,12544,13689,3136,11664,11881,4900,7396,1024,13689,9409,3249,2704,11025,14161,12769,4900,3025,10404,12100,14400,4489,12544,13225,6241,4900,13689,4900,2916,14400,4900,11664,13689,13225,3249,12544,13225,1681,1936,14400,11664,3136,4900,8649,3481,100,81,81,3249,3025,5184,5184,3025,13225,2916,2809,9409,3249,4900,11881,2304,9409,10609,4900,1024,5184,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,8281,1156,13689,9409,3249,2704,11025,14161,8100,13225,14400,9409,14400,3025,13225,2916,5776,3025,11664,4900,10609,14400,3025,13225,2916,1156,1936,13689,9409,3249,2704,11025,14161,8100,13225,14400,9409,14400,3025,13225,2916,5776,3025,11664,4900,10609,14400,3025,13225,2916,13689,13225,3249,12544,13225,1024,7396,12544,5776,9409,14400,9409,1024,1600,7396,12544,13689,3136,11664,11881,4900,7396,1024,13689,9409,3249,2704,11025,14161,8100,13225,14400,9409,14400,3025,13225,2916,5776,3025,11664,4900,10609,14400,3025,13225,2916,13689,13225,3249,12544,13225,1681,1936,14400,11664,3136,4900,8649,3481,100,81,15625,3481,100,15625,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,7396,13225,9409,14641,13689,9409,3249,4900,11664,9409,11881,4900,14400,14400,3025,2916,10404,5184,1024,3721,1024,15129,100,81,10201,3025,14400,12100,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,14641,13225,1024,15129,100,81,81,3025,2401,1024,1600,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,12100,3025,2916,14400,1024,1156,13924,11664,11664,13225,11664,3364,1024,2809,13225,1024,2704,11025,14161,1024,7921,13225,3136,2916,14641,1024,3025,2916,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1089,1156,3481,15625,3481,100,81,81,9025,5184,4900,14400,14400,3025,2916,10404,5184,4489,11664,11664,9409,4225,1024,3721,1024,2304,11664,13225,2401,3025,7396,4900,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,10404,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,13689,9409,3249,4900,11664,9409,2704,11025,14161,11881,4900,14400,14400,3025,2916,10404,5184,4489,11664,11664,9409,4225,1156,3481,100,81,81,9025,14400,3025,14400,7396,4900,5929,4900,12321,14400,1024,3721,1024,2304,11664,13225,2401,3025,7396,4900,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,10404,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,13689,9409,3249,4900,11664,9409,2704,11025,14161,5929,3025,14400,7396,4900,5929,4900,12321,14400,1156,3481,100,81,81,3025,2401,1024,1600,3025,5184,2809,3025,7396,1024,1156,9025,5184,4900,14400,14400,3025,2916,10404,5184,4489,11664,11664,9409,4225,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,81,3025,2401,1024,1600,3025,5184,2809,3025,7396,1024,1156,9025,14400,3025,14400,7396,4900,5929,4900,12321,14400,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,81,15129,100,81,81,81,9025,10609,13225,3249,12544,13225,1024,3721,1024,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1024,5184,4900,7396,4900,10609,14400,1024,9025,2401,13225,11664,4900,9409,10609,12100,14161,2916,14641,4900,12321,3481,100,81,81,81,9025,10609,13225,3249,12544,13225,1024,7396,12544,11881,4900,14400,13689,3136,11664,11881,4900,7396,1024,9025,12321,3481,100,81,81,15625,1024,2401,13225,11664,4900,9409,10609,12100,1024,9025,5184,4900,14400,14400,3025,2916,10404,5184,4489,11664,11664,9409,4225,3481,100,81,81,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,13924,14641,3025,14400,10816,13225,12321,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,9025,14400,3025,14400,7396,4900,5929,4900,12321,14400,3481,100,81,15625,3481,100,15625,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,10609,9409,3249,4900,11664,9409,2704,11025,14161,1024,3721,1024,15129,100,81,10201,3025,14400,12100,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,14641,13225,1024,15129,100,81,81,10609,11664,4900,9409,14400,4900,5776,3025,9409,7396,13225,10404,1024,1156,8100,5184,10609,5776,3025,5184,2304,7396,9409,4225,13924,3249,2304,14400,4225,1156,3481,100,81,81,5184,12100,13225,10201,10609,12100,9409,14400,1024,14400,11664,3136,4900,3481,100,81,81,9025,14641,3025,5184,2304,7396,9409,4225,1024,3721,1024,1600,2401,3025,2916,14641,5776,3025,5184,2304,7396,9409,4225,1024,2025,7056,1681,3481,100,100,81,81,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1024,3721,1024,8281,8649,3481,100,81,81,13924,7225,6400,11881,4900,7396,4900,10609,14400,4900,14641,6400,3136,5184,3025,10609,11025,14161,1024,3721,1024,1156,1156,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,1024,7056,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,6084,3025,10609,14400,3136,11664,4900,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,2601,6561,11449,6561,6561,6561,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,7056,6561,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4624,7056,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,6889,11449,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,1225,1600,9409,11664,10404,12544,1936,4761,1936,4761,1936,2601,1681,10609,13225,7396,13225,11664,1600,7056,1936,7056,1936,7056,1936,7056,1681,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,1936,4356,1936,4356,2116,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,1024,4624,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,6084,3025,10609,14400,3136,11664,4900,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,7056,12996,6889,2601,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,4624,4356,6889,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,6561,6889,4761,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,6889,7056,6889,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,1225,1600,9409,11664,10404,12544,1936,4761,1936,4761,1936,2601,1681,10609,13225,7396,13225,11664,1600,7056,1936,7056,1936,7056,1936,7056,1681,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,1936,4356,1936,4356,2116,5476,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,5929,3025,14400,7396,4900,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,11881,14400,11664,3136,10609,14400,3136,11664,4900,14641,5929,4900,12321,14400,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,2601,6561,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,7056,6889,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4624,7056,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,11881,14400,11664,3136,10609,14400,3136,11664,4900,14641,5929,4900,12321,14400,1024,2304,9409,11664,5184,4900,5929,4900,12321,14400,1024,1600,1156,3600,14400,1024,9409,7396,3025,10404,2916,3721,1521,1849,1156,1521,1156,1849,1521,7396,4900,2401,14400,1521,1849,1156,1521,1156,1849,1521,3844,13689,3025,2916,4900,3249,9409,14400,3025,10609,1024,11881,4900,14400,14400,3025,2916,10404,5184,3600,2209,14400,3844,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,5929,3025,14400,7396,4900,1024,13689,9409,11664,14641,1024,2025,1024,14400,4900,12321,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,4624,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,5929,3025,14400,7396,4900,1024,13689,9409,11664,14641,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,5929,3025,14400,7396,4900,1024,13689,9409,11664,14641,1024,2025,1024,4900,14641,3025,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,13924,14641,3025,14400,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,4624,11449,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,11449,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,7056,1936,7056,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,4356,2116,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,13924,14641,3025,14400,10816,13225,12321,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,7921,9409,14641,4900,1024,13689,13225,7396,13225,11664,1024,2025,1024,14400,4900,12321,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,2601,4356,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4356,6561,7056,4761,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,7921,9409,14641,4900,1024,13689,13225,7396,13225,11664,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,7921,9409,14641,4900,1024,11881,2304,4900,4900,14641,1024,2025,1024,14400,4900,12321,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,2601,4356,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4356,6561,7056,4761,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,7921,9409,14641,4900,1024,11881,2304,4900,4900,14641,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,7921,9409,14641,4900,1024,13689,13225,7396,13225,11664,1024,2025,1024,10609,13225,3249,12544,13225,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,13689,13225,3249,12544,13225,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,2601,2601,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4356,6561,7056,4761,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,7056,1936,7056,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,4356,2116,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,10816,7396,9409,10609,14884,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5776,9409,14400,9409,1024,8281,9025,3025,2916,14641,4900,12321,1936,1156,10816,9801,4489,13689,10000,1156,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,5329,12100,3025,14400,4900,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5776,9409,14400,9409,1024,8281,9025,3025,2916,14641,4900,12321,1936,1156,5329,12769,14161,5929,13924,1156,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,13689,3136,11664,11881,4900,7396,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,13689,13225,7396,13225,11664,13689,13225,3249,12544,13225,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,7921,9409,14641,4900,1024,11881,2304,4900,4900,14641,1024,2025,1024,10609,13225,3249,12544,13225,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,13689,13225,3249,12544,13225,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,2601,2601,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4356,6561,7056,4761,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,7056,1936,7056,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,4356,2116,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,6400,4900,14641,3025,3136,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,12996,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,7921,9409,5184,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,4624,12996,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,11881,7396,13225,10201,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,5476,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,13689,3136,11664,11881,4900,7396,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,13689,13225,3249,12544,13225,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,4489,14641,14641,1024,6400,3136,5184,3025,10609,1024,2025,1024,10816,3136,14400,14400,13225,2916,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,2601,5476,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,11449,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,4489,14641,14641,1024,6400,3136,5184,3025,10609,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,4489,14641,14641,6400,3136,5184,3025,10609,10816,3136,14400,14400,13225,2916,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,4489,14641,14641,13924,6241,4900,2916,14400,12769,9409,2916,14641,7396,4900,11664,1024,8281,1156,10816,3136,14400,14400,13225,2916,5776,13225,10201,2916,1156,1936,15129,100,81,81,81,2304,9409,11664,9409,3249,5184,8281,1156,9025,12544,3136,14400,14400,13225,2916,1156,8649,3481,100,81,81,81,10201,3025,14400,12100,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,14641,13225,1024,15129,100,81,81,81,81,9025,14641,3025,5184,2304,7396,9409,4225,1024,3721,1024,1600,2401,3025,2916,14641,5776,3025,5184,2304,7396,9409,4225,1024,2025,7056,1681,3481,100,81,81,81,81,13924,6400,4489,7225,7396,7396,6400,3136,5184,3025,10609,13689,13225,2916,14400,11664,13225,7396,5184,1024,3721,1024,8281,8649,3481,100,81,81,81,81,13924,6400,4489,7225,7396,7396,13689,9409,3249,4900,11664,9409,2704,11025,14161,13689,13225,2916,14400,11664,13225,7396,5184,1024,3721,1024,9409,7396,7396,13689,13225,2916,14400,11664,13225,7396,5184,1024,9025,14641,3025,5184,2304,7396,9409,4225,3481,100,81,81,81,81,15129,9025,12321,1024,10609,14400,11664,7396,11881,12100,13225,10201,1024,2401,9409,7396,5184,4900,3481,15625,1024,2401,13225,11664,4900,9409,10609,12100,1024,13924,6400,4489,7225,7396,7396,13689,9409,3249,4900,11664,9409,2704,11025,14161,13689,13225,2916,14400,11664,13225,7396,5184,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,6084,3025,10609,14400,3136,11664,4900,1156,1936,2025,7056,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,2601,5476,12996,2601,7056,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,4624,2601,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4624,11449,6561,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,12996,6889,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,1225,1600,9409,11664,10404,12544,1936,4761,1936,4761,1936,2601,1681,10609,13225,7396,13225,11664,1600,7056,1936,7056,1936,7056,1936,7056,1681,1156,1681,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,1936,4356,1936,4356,2116,12996,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,81,81,13924,6400,4489,7225,7396,7396,6400,3136,5184,3025,10609,13689,13225,2916,14400,11664,13225,7396,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,6084,3025,10609,14400,3136,11664,4900,1156,1936,2025,7056,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,2601,4761,7056,4761,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,4624,11449,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4624,2601,6889,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,12996,2601,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,1225,1600,9409,11664,10404,12544,1936,4761,1936,4761,1936,2601,1681,10609,13225,7396,13225,11664,1600,7056,1936,7056,1936,7056,1936,7056,1681,1156,1681,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,1936,4356,1936,4356,2116,12996,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,1024,100,81,81,81,81,13924,6400,4489,7225,7396,7396,6400,3136,5184,3025,10609,13689,13225,2916,14400,11664,13225,7396,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,11881,14400,11664,3136,10609,14400,3136,11664,4900,14641,5929,4900,12321,14400,1156,1936,2025,7056,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,2601,5476,12996,2601,7056,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,4624,4356,6889,6561,4624,6889,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4624,11449,4761,4761,12996,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,11881,14400,11664,3136,10609,14400,3136,11664,4900,14641,5929,4900,12321,14400,1024,2304,9409,11664,5184,4900,5929,4900,12321,14400,1024,1600,1156,6400,3136,5184,3025,10609,1024,11881,4900,7396,4900,10609,14400,3025,13225,2916,1156,1681,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,7056,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,81,81,13924,6400,4489,7225,7396,7396,6400,3136,5184,3025,10609,13689,13225,2916,14400,11664,13225,7396,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,9801,3025,5184,14400,10816,13225,12321,1156,1936,2025,7056,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,2601,4761,4761,11449,2601,5476,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,4624,6889,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4624,4624,2601,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,11449,2601,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,81,81,13924,7225,6400,6400,3136,5184,3025,10609,9801,3025,5184,14400,10816,13225,12321,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,81,81,13924,6400,4489,7225,7396,7396,6400,3136,5184,3025,10609,13689,13225,2916,14400,11664,13225,7396,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,4489,14641,14641,13924,6241,4900,2916,14400,12769,9409,2916,14641,7396,4900,11664,1024,8281,1156,9801,10816,11881,4900,7396,13689,12100,9409,2916,10404,4900,14641,1156,1936,15129,100,81,81,81,81,81,2304,9409,11664,9409,3249,5184,1024,8281,1156,9025,10609,13225,2916,14400,11664,13225,7396,1156,1936,1024,1156,9025,5184,4900,7396,4900,10609,14400,4900,14641,14161,2916,14641,4900,12321,1156,8649,3481,100,81,81,81,81,81,9025,3249,3136,5184,3025,10609,13689,7396,9409,5184,5184,1024,3721,1024,9025,10609,13225,2916,14400,11664,13225,7396,1024,7396,12544,5776,9409,14400,9409,1024,9025,5184,4900,7396,4900,10609,14400,4900,14641,14161,2916,14641,4900,12321,3481,100,81,81,81,81,81,2304,7396,9409,4225,6400,3136,5184,3025,10609,1024,9025,3249,3136,5184,3025,10609,13689,7396,9409,5184,5184,3481,100,81,81,81,81,15625,8649,3481,100,81,81,81,81,9025,9409,7396,7396,6400,3136,5184,3025,10609,13689,7396,9409,5184,5184,4900,5184,1024,3721,1024,1600,10609,13225,2916,2401,3025,10404,7921,3025,7396,4900,1024,3844,3844,1024,1156,13689,2401,10404,6400,3136,5184,3025,10609,1156,1681,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,10404,4900,14400,13689,2401,10404,11881,3136,12544,13689,7396,9409,5184,5184,4900,5184,3481,100,81,81,81,81,15129,100,81,81,81,81,81,9025,2916,9409,3249,4900,1024,3721,1024,10404,4900,14400,5929,4900,12321,14400,1600,10609,13225,2916,2401,3025,10404,7921,3025,7396,4900,1024,3844,3844,1024,1156,13689,2401,10404,6400,3136,5184,3025,10609,1156,1024,3844,3844,1024,9025,12321,1024,3844,3844,1024,1156,2916,9409,3249,4900,1156,1681,3481,100,81,81,81,81,81,3025,2401,1600,9025,2916,9409,3249,4900,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,1156,1156,1681,1024,14400,12100,4900,2916,1024,15129,9025,2916,9409,3249,4900,1024,3721,1024,9025,12321,3481,15625,3481,100,81,81,81,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,1600,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,9025,2916,9409,3249,4900,1681,3481,100,81,81,81,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5776,9409,14400,9409,1024,8281,9025,3025,2916,14641,4900,12321,1936,9025,12321,8649,3481,100,81,81,81,81,15625,1024,2401,13225,11664,4900,9409,10609,12100,1024,9025,9409,7396,7396,6400,3136,5184,3025,10609,13689,7396,9409,5184,5184,4900,5184,3481,100,81,81,81,81,7396,12544,11881,13225,11664,14400,1024,9025,10609,14400,11664,7396,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,2601,4761,4761,11449,2601,5476,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,5476,7056,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4624,4624,2601,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,12996,6889,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,11881,14400,11664,3136,10609,14400,3136,11664,4900,14641,5929,4900,12321,14400,1024,2304,9409,11664,5184,4900,5929,4900,12321,14400,1024,1600,1156,4489,5776,5776,1024,6400,11025,11881,14161,13689,1156,1681,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,81,81,13924,6400,4489,7225,7396,7396,6400,3136,5184,3025,10609,13689,13225,2916,14400,11664,13225,7396,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,81,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,4489,14641,14641,13924,6241,4900,2916,14400,12769,9409,2916,14641,7396,4900,11664,1024,8281,1156,10816,3136,14400,14400,13225,2916,5776,13225,10201,2916,1156,1936,15129,100,81,81,81,81,81,2304,9409,11664,9409,3249,5184,1024,8281,1156,9025,10609,13225,2916,14400,11664,13225,7396,1156,8649,3481,100,81,81,81,81,81,9025,7396,3025,5184,14400,10816,13225,12321,1024,3721,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,10404,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,6400,3136,5184,3025,10609,9801,3025,5184,14400,10816,13225,12321,1156,3481,100,81,81,81,81,81,9025,3249,3136,5184,3025,10609,13689,7396,9409,5184,5184,1024,3721,1024,9025,7396,3025,5184,14400,10816,13225,12321,1024,7396,12544,5776,9409,14400,9409,1024,1600,7396,12544,13689,3136,11664,11881,4900,7396,1024,9025,7396,3025,5184,14400,10816,13225,12321,1681,3481,100,81,81,81,81,81,10201,3025,14400,12100,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,14641,13225,1024,15129,100,81,81,81,81,81,81,13924,7225,6400,11881,4900,7396,4900,10609,14400,4900,14641,6400,3136,5184,3025,10609,11025,14161,1024,3721,1024,9025,3249,3136,5184,3025,10609,13689,7396,9409,5184,5184,3481,100,81,81,81,81,81,81,15129,10609,14400,11664,7396,5776,4900,7396,4900,14400,4900,1024,9025,12321,3481,15625,1024,2401,13225,11664,4900,9409,10609,12100,1024,13924,6400,4489,7225,7396,7396,6400,3136,5184,3025,10609,13689,13225,2916,14400,11664,13225,7396,5184,3481,100,81,81,81,81,81,81,15129,9025,12321,1024,10609,14400,11664,7396,11881,12100,13225,10201,1024,14400,11664,3136,4900,3481,15625,1024,2401,13225,11664,4900,9409,10609,12100,1024,13924,6400,4489,7225,7396,7396,13689,9409,3249,4900,11664,9409,2704,11025,14161,13689,13225,2916,14400,11664,13225,7396,5184,3481,100,81,81,81,81,81,15625,3481,100,81,81,81,81,81,2304,7396,9409,4225,6400,3136,5184,3025,10609,1024,1156,1156,3481,100,81,81,81,81,81,13924,7225,6400,11881,4900,7396,4900,10609,14400,4900,14641,6400,3136,5184,3025,10609,1024,3721,1024,1600,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,10404,4900,14400,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,11881,4900,7396,4900,10609,14400,4900,14641,6400,3136,5184,3025,10609,11025,14161,1156,1681,3481,100,81,81,81,81,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,11881,4900,7396,4900,10609,14400,4900,14641,6400,3136,5184,3025,10609,1156,3481,100,81,81,81,81,15625,8649,3481,100,81,81,81,15625,3481,100,81,81,15625,8649,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,9801,4900,2916,10404,14400,12100,1024,13225,2401,1024,13689,3025,2916,4900,3249,9409,14400,3025,10609,1024,2025,1024,14400,4900,12321,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,11449,2601,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,9801,4900,2916,10404,14400,12100,1024,13225,2401,1024,13689,3025,2916,4900,3249,9409,14400,3025,10609,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,13225,13225,7396,14400,3025,2304,1024,1156,12769,13225,10201,1024,7396,13225,2916,10404,1024,3025,2916,1024,5184,4900,10609,13225,2916,14641,5184,1024,14400,12100,4900,1024,10609,3025,2916,4900,3249,9409,14400,3025,10609,1024,10201,3025,7396,7396,1024,7396,9409,5184,14400,2116,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,9801,4900,2916,10404,14400,12100,1024,13225,2401,1024,13689,3025,2916,4900,3249,9409,14400,3025,10609,1024,2025,1024,10609,13225,3249,12544,13225,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,13689,13225,3249,12544,13225,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,11449,12996,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,7056,1936,7056,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,4356,2116,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,7056,4356,5184,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,7056,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,12996,5184,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,12996,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,7056,12996,5184,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,7056,12996,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,2601,4356,5184,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,2601,4356,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,13689,3136,11664,11881,4900,7396,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,13689,13225,3249,12544,13225,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,5776,3025,5184,14400,9409,2916,10609,4900,1024,7921,11664,13225,3249,1024,13689,4900,2916,14400,4900,11664,1024,2025,1024,14400,4900,12321,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,5776,3025,5184,14400,9409,2916,10609,4900,1024,7921,11664,13225,3249,1024,13689,4900,2916,14400,4900,11664,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,5776,3025,5184,14400,9409,2916,10609,4900,1024,7921,11664,13225,3249,1024,13689,4900,2916,14400,4900,11664,1024,2025,1024,10609,13225,3249,12544,13225,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,13689,13225,3249,12544,13225,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,12996,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,7056,1936,7056,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,4356,2116,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,7056,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,7056,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,12996,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,12996,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,7056,4356,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,7056,4356,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,4624,12996,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,4624,12996,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,12996,4356,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,12996,4356,4356,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,13689,3136,11664,11881,4900,7396,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,5776,3025,5184,14400,9409,2916,10609,4900,7921,11664,13225,3249,13689,4900,2916,14400,4900,11664,13689,13225,3249,12544,13225,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,12769,4900,3025,10404,12100,14400,1024,4489,12544,13225,6241,4900,1024,13689,4900,2916,14400,4900,11664,1024,2025,1024,14400,4900,12321,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,12996,5476,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,12769,4900,3025,10404,12100,14400,1024,4489,12544,13225,6241,4900,1024,13689,4900,2916,14400,4900,11664,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,12769,4900,3025,10404,12100,14400,1024,4489,12544,13225,6241,4900,1024,13689,4900,2916,14400,4900,11664,1024,2025,1024,10609,13225,3249,12544,13225,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,13689,13225,3249,12544,13225,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,12996,6561,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,7056,1936,7056,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,4356,2116,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,7056,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,7056,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,12996,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,12996,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,7056,4356,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,7056,4356,4356,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,7056,12996,4356,3249,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5041,9409,7396,3136,4900,1024,8281,9025,3025,2916,14641,4900,12321,1936,7056,12996,4356,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,13689,3136,11664,11881,4900,7396,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,12769,4900,3025,10404,12100,14400,4489,12544,13225,6241,4900,13689,4900,2916,14400,4900,11664,13689,13225,3249,12544,13225,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,8100,13225,14400,9409,14400,3025,13225,2916,1024,5776,3025,11664,4900,10609,14400,3025,13225,2916,1024,2025,1024,14400,4900,12321,14400,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,6889,11449,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,8100,13225,14400,9409,14400,3025,13225,2916,1024,5776,3025,11664,4900,10609,14400,3025,13225,2916,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,8100,13225,14400,9409,14400,3025,13225,2916,1024,5776,3025,11664,4900,10609,14400,3025,13225,2916,1024,2025,1024,10609,13225,3249,12544,13225,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,13689,13225,3249,12544,13225,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,6889,6889,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,4624,4761,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,7056,1936,7056,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,2116,12996,1936,7056,1936,4356,2116,12996,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,13689,7396,13225,10609,14884,10201,3025,5184,4900,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5776,9409,14400,9409,1024,8281,9025,3025,2916,14641,4900,12321,1936,1156,13689,7396,13225,10609,14884,10201,3025,5184,4900,1156,8649,3481,100,81,81,9025,3025,2916,14641,4900,12321,1024,3721,1024,9025,10609,14400,11664,7396,1024,7396,12544,4489,14641,14641,1024,1156,13689,13225,3136,2916,14400,4900,11664,2025,13689,7396,13225,10609,14884,10201,3025,5184,4900,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,5776,9409,14400,9409,1024,8281,9025,3025,2916,14641,4900,12321,1936,1156,13689,13225,3136,2916,14400,4900,11664,2025,13689,7396,13225,10609,14884,10201,3025,5184,4900,1156,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,7396,12544,11881,4900,14400,13689,3136,11664,11881,4900,7396,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,8100,13225,14400,9409,14400,3025,13225,2916,5776,3025,11664,4900,10609,14400,3025,13225,2916,13689,13225,3249,12544,13225,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,13689,9409,3249,4900,11664,9409,2704,11025,14161,4489,7396,7396,13689,13225,3249,12544,13225,11881,4900,14400,14400,3025,2916,10404,5184,1024,2304,3136,5184,12100,10816,9409,10609,14884,1024,9025,10609,14400,11664,7396,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,11881,9409,6241,4900,1024,11881,4900,14400,14400,3025,2916,10404,5184,1024,2025,1024,10816,3136,14400,14400,13225,2916,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,5476,7056,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,11449,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,11881,9409,6241,4900,1024,11881,4900,14400,14400,3025,2916,10404,5184,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,4489,14641,14641,13924,6241,4900,2916,14400,12769,9409,2916,14641,7396,4900,11664,1024,8281,1156,10816,3136,14400,14400,13225,2916,5776,13225,10201,2916,1156,1936,15129,100,81,81,81,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,9409,6241,4900,13689,9409,3249,4900,11664,9409,11881,4900,14400,14400,3025,2916,10404,5184,3481,100,81,81,81,5184,4225,5184,14400,4900,3249,13689,12100,9409,14400,1024,1156,13689,9409,3249,4900,11664,9409,1024,5184,4900,14400,14400,3025,2916,10404,5184,1024,5184,9409,6241,4900,14641,1156,3481,100,81,81,81,2304,7396,9409,4225,11881,13225,3136,2916,14641,1024,1156,12100,3025,2916,14400,1156,3481,100,81,81,15625,8649,3481,100,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,6084,11664,4900,6241,3025,4900,10201,1024,2025,1024,10816,3136,14400,14400,13225,2916,1156,3481,100,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,10816,3136,14400,14400,13225,2916,6400,4900,2916,3136,1156,1936,2025,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,11449,4356,4761,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,5476,6889,6889,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,7056,4761,2601,5476,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,11449,4624,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,13689,13225,7396,13225,11664,1024,8281,7056,1936,7056,1936,7056,1936,7056,8649,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,5929,4900,12321,14400,1024,1600,1156,6084,11664,4900,6241,3025,4900,10201,1156,1681,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,13689,9409,3249,2704,11025,14161,6084,11664,4900,6241,3025,4900,10201,10816,3136,14400,14400,13225,2916,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,4489,14641,14641,13924,6241,4900,2916,14400,12769,9409,2916,14641,7396,4900,11664,1024,8281,1156,10816,3136,14400,14400,13225,2916,5776,13225,10201,2916,1156,1936,15129,100,81,81,81,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,9409,6241,4900,13689,9409,3249,4900,11664,9409,11881,4900,14400,14400,3025,2916,10404,5184,3481,100,81,81,81,8281,15129,15625,1936,8281,8649,1936,14400,11664,3136,4900,8649,1024,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,14400,9409,11664,14400,13689,3025,2916,4900,3249,9409,14400,3025,10609,11881,4900,7569,3136,4900,2916,10609,4900,2704,7396,13225,12544,9409,7396,3481,100,81,81,81,10609,7396,13225,5184,4900,5776,3025,9409,7396,13225,10404,1024,7056,3481,100,81,81,15625,8649,3481,100,81,15625,3481,100,81,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,7396,13225,9409,14641,13689,9409,3249,4900,11664,9409,11881,4900,14400,14400,3025,2916,10404,5184,3481,100,15625,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,13689,9409,3249,4900,11664,9409,6084,11664,4900,6241,3025,4900,10201,6400,13225,14641,4900,5929,4900,12321,14400,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,1024,8281,1156,9025,4900,2916,9409,12544,7396,4900,1156,8649,3481,100,81,10201,3025,14400,12100,1024,3136,3025,2809,9409,3249,4900,5184,2304,9409,10609,4900,1024,14641,13225,1024,15129,100,81,81,3025,2401,1600,9025,4900,2916,9409,12544,7396,4900,1681,1024,14400,12100,4900,2916,1024,100,81,81,15129,100,81,81,81,9025,14641,3025,5184,2304,7396,9409,4225,1024,3721,1024,2401,3025,2916,14641,5776,3025,5184,2304,7396,9409,4225,1024,11449,6889,3481,100,81,81,81,9025,10609,14400,11664,7396,1024,3721,1024,9025,14641,3025,5184,2304,7396,9409,4225,1024,10609,14400,11664,7396,13689,11664,4900,9409,14400,4900,1024,8281,1156,8100,5184,10609,11881,14400,11664,3136,10609,14400,3136,11664,4900,14641,5929,4900,12321,14400,1156,1936,2025,7056,8649,3481,100,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,6084,13225,5184,3025,14400,3025,13225,2916,1024,8281,4356,2116,2601,4761,4761,11449,2601,5476,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,9604,1936,4356,2116,6561,4356,6889,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,1024,1849,1024,5184,9409,2401,4900,6724,13225,2916,4900,7744,1936,4356,2116,4624,4624,2601,7056,4624,12996,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,5329,1936,4356,2116,4356,5476,1024,1764,1024,5184,9409,2401,4900,6724,13225,2916,4900,12769,8649,3481,100,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,11881,14400,11664,3136,10609,14400,3136,11664,4900,14641,5929,4900,12321,14400,1024,2304,9409,11664,5184,4900,5929,4900,12321,14400,1024,1600,1156,3600,14400,1024,9409,7396,3025,10404,2916,3721,1521,1849,1156,1521,1156,1849,1521,10609,4900,2916,14400,4900,11664,1521,1849,1156,1521,1156,1849,1521,1024,5184,3025,6724,4900,3721,1521,1849,1156,1521,1156,1849,1521,4624,1521,1849,1156,1521,1156,1849,1521,3844,6084,8100,13924,5041,14161,13924,5329,1024,6400,5625,5776,13924,3600,2209,14400,3844,1156,1681,3481,100,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,11881,4900,14400,10816,9409,10609,14884,10404,11664,13225,3136,2916,14641,13689,13225,7396,13225,11664,1024,8281,4356,1936,4356,1936,4356,1936,4356,8649,3481,100,81,81,81,9025,10609,14400,11664,7396,1024,10609,14400,11664,7396,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,81,81,13924,7225,6400,13689,9409,3249,2704,11025,14161,6084,11664,4900,6241,3025,4900,10201,6400,13225,14641,4900,5929,4900,12321,14400,1024,3721,1024,9025,10609,14400,11664,7396,3481,100,81,81,15625,100,81,81,4900,7396,5184,4900,1024,100,81,81,15129,100,81,81,81,3025,2401,1024,1600,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,13689,9409,3249,2704,11025,14161,6084,11664,4900,6241,3025,4900,10201,6400,13225,14641,4900,5929,4900,12321,14400,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,81,81,10609,14400,11664,7396,5776,4900,7396,4900,14400,4900,1024,13924,7225,6400,13689,9409,3249,2704,11025,14161,6084,11664,4900,6241,3025,4900,10201,6400,13225,14641,4900,5929,4900,12321,14400,3481,100,81,81,15625,3481,100,81,15625,3481,100,15625,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,5184,4900,14400,13689,9409,3249,4900,11664,9409,5041,4900,10609,14400,13225,11664,14161,2916,2401,13225,2704,7396,13225,12544,9409,7396,1024,3721,1024,15129,100,81,9025,2304,13225,5184,1024,3721,1024,4489,11881,9801,5929,13225,4489,2704,9801,1600,10404,4900,14400,6084,13225,5184,4489,11881,9801,1024,10609,3136,11664,9409,14400,13225,11664,13689,9409,3249,4900,11664,9409,1681,3481,100,81,9025,6241,4900,10609,14400,13225,11664,11025,2304,1024,3721,1024,6241,4900,10609,14400,13225,11664,11025,2304,1024,10609,3136,11664,9409,14400,13225,11664,13689,9409,3249,4900,11664,9409,3481,100,81,9025,6241,4900,10609,14400,13225,11664,5776,3025,11664,1024,3721,1024,6241,4900,10609,14400,13225,11664,5776,3025,11664,1024,10609,3136,11664,9409,14400,13225,11664,13689,9409,3249,4900,11664,9409,3481,100,81,13924,7225,6400,13689,9409,3249,4900,11664,9409,6084,13225,5184,3025,14400,3025,13225,2916,1024,3721,1024,9025,2304,13225,5184,3481,100,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,5041,4900,10609,14400,13225,11664,5776,9409,14400,9409,1024,3721,1024,8281,9025,6241,4900,10609,14400,13225,11664,5776,3025,11664,1936,9025,6241,4900,10609,14400,13225,11664,11025,2304,8649,3481,100,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,5041,4900,10609,14400,13225,11664,5776,9409,14400,9409,1156,3481,100,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,13689,9409,3249,4900,11664,9409,6084,13225,5184,3025,14400,3025,13225,2916,1156,3481,100,15625,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,10609,11664,4900,9409,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,3721,1024,15129,100,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,9025,10609,9409,3249,1024,3721,1024,1156,10609,9409,3249,4900,11664,9409,1156,1024,10609,9409,3249,13689,11664,4900,9409,14400,4900,1024,8281,4356,1936,4356,1936,4356,8649,3481,100,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,3721,1024,9025,10609,9409,3249,3481,100,81,9025,10609,9409,3249,1024,5184,4900,14400,6084,13225,5184,1024,13924,7225,6400,13689,9409,3249,4900,11664,9409,6084,13225,5184,3025,14400,3025,13225,2916,3481,100,81,9025,10609,9409,3249,1024,5184,4900,14400,5041,4900,10609,14400,13225,11664,5776,3025,11664,4489,2916,14641,11025,2304,1024,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,5041,4900,10609,14400,13225,11664,5776,9409,14400,9409,3481,100,81,9025,10609,9409,3249,100,15625,3481,100,100,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,10609,11664,4900,9409,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,8100,13924,1521,1849,1156,1521,1156,1849,1521,1936,1024,13924,7225,6400,9025,2401,2916,10609,9025,10609,11664,4900,9409,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,8649,3481,100,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,10609,11664,4900,9409,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1521,1849,1156,1521,1156,1849,1521,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,5184,4900,14400,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,3721,1024,15129,100,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,3025,2401,1600,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,8281,8649,1024,5184,2304,9409,10201,2916,1024,15129,100,81,81,1600,2401,3025,2916,14641,5776,3025,5184,2304,7396,9409,4225,1024,2601,7056,4624,1681,1024,10609,7396,13225,5184,4900,5776,3025,5184,2304,7396,9409,4225,1024,7056,3481,100,81,81,5184,7396,4900,4900,2304,1024,7056,3481,100,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,4900,11664,9409,13924,2401,2401,4900,10609,14400,1024,8281,1156,14161,2916,14400,4900,11664,2916,9409,7396,1156,1936,1156,10816,9409,10609,14884,1156,8649,3481,100,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,81,15625,3481,100,15625,3481,100,100,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,4900,14400,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,8100,13924,1521,1849,1156,1521,1156,1849,1521,1936,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,4900,14400,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,8649,3481,100,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,4900,14400,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1521,1849,1156,1521,1156,1849,1521,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,14641,4900,7396,4900,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,3721,1024,15129,100,81,3025,2401,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,4900,11664,9409,13924,2401,2401,4900,10609,14400,1024,8281,1156,5929,4900,11664,3249,3025,2916,9409,14400,4900,1156,1936,1156,10816,9409,10609,14884,1156,8649,3481,100,81,3025,2401,1024,1089,1600,2304,7396,9409,4225,4900,11664,1024,3025,2916,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,7396,3025,5184,14400,13689,3136,11664,9409,14400,13225,11664,6084,7396,9409,4225,4900,11664,5184,1681,1024,14400,12100,4900,2916,1024,100,81,15129,100,81,81,10609,3136,11664,9409,14400,13225,11664,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,4900,11664,9409,13924,2401,2401,4900,10609,14400,1024,8281,1156,14161,2916,14400,4900,11664,2916,9409,7396,1156,1936,1156,10816,9409,10609,14884,1156,8649,3481,100,81,15625,3481,100,81,10609,9409,3249,5776,4900,5184,14400,11664,13225,4225,1024,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,3481,100,81,3025,2401,1600,1089,9409,7396,3025,6241,4900,1024,2304,7396,9409,4225,4900,11664,1681,1024,14400,12100,4900,2916,1024,15129,13225,2304,4900,2916,6400,9409,2304,1024,14400,11664,3136,4900,3481,15625,3481,100,81,8281,8649,1024,5184,2304,9409,10201,2916,1024,15129,100,81,81,1600,2401,3025,2916,14641,5776,3025,5184,2304,7396,9409,4225,1024,2601,7056,4624,1681,1024,10609,7396,13225,5184,4900,5776,3025,5184,2304,7396,9409,4225,1024,7056,3481,100,81,81,5184,7396,4900,4900,2304,1024,7056,3481,100,81,81,13225,2304,4900,2916,13689,3136,11664,9409,14400,13225,11664,14161,2916,14400,4900,11664,2401,9409,10609,4900,3481,100,81,15625,3481,100,15625,3481,100,100,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,14641,4900,7396,4900,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,8100,13924,1521,1849,1156,1521,1156,1849,1521,1936,1024,13924,7225,6400,9025,2401,2916,10609,9025,14641,4900,7396,4900,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,8649,3481,100,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,14641,4900,7396,4900,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1521,1849,1156,1521,1156,1849,1521,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,9801,13225,10609,9409,7396,6084,7396,9409,4225,4900,11664,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,8281,1156,9025,4900,2916,9409,12544,7396,4900,1156,8649,3481,100,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,2304,7396,9409,4225,4900,11664,1024,9409,7396,7396,13225,10201,5776,9409,3249,9409,10404,4900,1024,9025,4900,2916,9409,12544,7396,4900,3481,100,81,2304,7396,9409,4225,4900,11664,1024,5184,4900,14400,13689,9409,2304,14400,3025,6241,4900,1024,1089,9025,4900,2916,9409,12544,7396,4900,3481,100,81,3025,2401,1024,1089,1600,1600,6241,4900,12100,3025,10609,7396,4900,1024,2304,7396,9409,4225,4900,11664,1681,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,2304,7396,9409,4225,4900,11664,1681,1024,14400,12100,4900,2916,1024,100,81,15129,100,81,81,3025,2401,1600,1600,14641,11664,3025,6241,4900,11664,1024,6241,4900,12100,3025,10609,7396,4900,1024,2304,7396,9409,4225,4900,11664,1681,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,2304,7396,9409,4225,4900,11664,1681,1024,14400,12100,4900,2916,1024,100,81,81,15129,100,81,81,81,6241,4900,12100,3025,10609,7396,4900,1024,2304,7396,9409,4225,4900,11664,1024,4900,2916,9409,12544,7396,4900,11881,3025,3249,3136,7396,9409,14400,3025,13225,2916,1024,9025,4900,2916,9409,12544,7396,4900,3481,100,81,81,15625,3481,100,81,15625,3481,100,15625,3481,100,100,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,9801,13225,10609,9409,7396,6084,7396,9409,4225,4900,11664,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,8100,13924,1521,1849,1156,1521,1156,1849,1521,1936,1024,13924,7225,6400,9025,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,9801,13225,10609,9409,7396,6084,7396,9409,4225,4900,11664,8649,3481,100,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,9801,13225,10609,9409,7396,6084,7396,9409,4225,4900,11664,1521,1849,1156,1521,1156,1849,1521,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,1024,8281,1156,9025,12544,13225,11664,14641,4900,11664,6400,13225,14641,4900,1156,1936,1156,9025,2401,9409,14641,4900,6400,13225,14641,4900,1156,8649,3481,100,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,3721,1024,1600,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,2209,7056,4356,1681,3481,100,81,9025,2401,9409,14641,4900,13689,13225,7396,13225,11664,1024,3721,1024,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,13689,13225,7396,13225,11664,3481,100,81,9025,12544,13225,11664,14641,4900,11664,12769,9409,2916,14641,7396,4900,1024,3721,1024,4356,1024,5184,2304,9409,10201,2916,1024,15129,15625,3481,100,81,9025,2401,9409,14641,4900,12769,9409,2916,14641,7396,4900,1024,3721,1024,4356,1024,5184,2304,9409,10201,2916,1024,15129,15625,3481,100,81,9025,3025,5184,5776,11664,3025,6241,4900,11664,1024,3721,1024,2401,9409,7396,5184,4900,3481,100,100,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,5776,11664,3025,6241,4900,11664,1024,5625,6241,4900,11664,11664,3025,14641,4900,1156,3481,100,81,3025,2401,1600,1600,9025,12544,13225,11664,14641,4900,11664,6400,13225,14641,4900,1024,3721,3721,1024,7056,1681,1024,1444,1444,1024,1600,9025,2401,9409,14641,4900,6400,13225,14641,4900,1024,3721,3721,1024,7056,1681,1024,1444,1444,1024,1089,1600,6241,4900,12100,3025,10609,7396,4900,1024,2304,7396,9409,4225,4900,11664,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,2304,7396,9409,4225,4900,11664,1681,1681,1024,14400,12100,4900,2916,1024,100,81,15129,100,81,81,3025,2401,1024,1600,1600,14641,11664,3025,6241,4900,11664,1024,6241,4900,12100,3025,10609,7396,4900,1024,2304,7396,9409,4225,4900,11664,1681,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,2304,7396,9409,4225,4900,11664,1681,1024,14400,12100,4900,2916,1024,100,81,81,15129,100,81,81,81,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,3721,1024,4356,2116,7056,3481,100,81,81,81,9025,3025,5184,5776,11664,3025,6241,4900,11664,1024,3721,1024,14400,11664,3136,4900,3481,100,81,81,15625,3481,100,81,15625,3481,100,81,3025,2401,1024,1600,9025,12544,13225,11664,14641,4900,11664,6400,13225,14641,4900,1024,1089,3721,1024,2025,7056,1681,1024,14400,12100,4900,2916,1024,15129,9025,12544,13225,11664,14641,4900,11664,12769,9409,2916,14641,7396,4900,1024,3721,1024,8281,9025,12544,13225,11664,14641,4900,11664,6400,13225,14641,4900,1936,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1936,2401,9409,7396,5184,4900,1936,2401,9409,7396,5184,4900,8649,1024,5184,2304,9409,10201,2916,1024,10816,14161,11881,9025,2401,2916,10609,9025,10609,3025,2916,4900,3249,9409,10816,13225,11664,14641,4900,11664,3481,15625,3481,100,81,3025,2401,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1089,3721,1024,2025,7056,1681,1024,14400,12100,4900,2916,1024,15129,9025,2401,9409,14641,4900,12769,9409,2916,14641,7396,4900,1024,3721,1024,8281,9025,2401,9409,14641,4900,6400,13225,14641,4900,1936,9025,2401,9409,14641,4900,13689,13225,7396,13225,11664,1936,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1936,4356,8649,1024,5184,2304,9409,10201,2916,1024,10816,14161,11881,9025,2401,2916,10609,9025,2401,9409,14641,4900,13924,2401,2401,4900,10609,14400,3481,15625,3481,100,81,3025,2401,1024,1600,9025,3025,5184,5776,11664,3025,6241,4900,11664,1681,1024,14400,12100,4900,2916,1024,15129,5184,7396,4900,4900,2304,1024,2601,3481,1024,8281,14400,11664,3136,4900,8649,1024,10609,9409,7396,7396,1024,1600,13924,7225,6400,7921,2916,10609,4489,11664,11664,9409,4225,1024,5184,4900,7396,4900,10609,14400,1024,11449,1681,3481,15625,3481,100,81,3025,2401,1024,1600,1600,9025,2401,9409,14641,4900,6400,13225,14641,4900,1024,3721,3721,1024,7056,1681,1024,1444,1444,1024,1600,9025,12544,13225,11664,14641,4900,11664,6400,13225,14641,4900,1024,1089,3721,1024,7056,1681,1681,1024,14400,12100,4900,2916,1024,15129,100,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,5184,10609,11664,3025,2304,14400,5776,13225,2916,4900,1024,9025,2401,9409,14641,4900,12769,9409,2916,14641,7396,4900,15625,3481,100,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,11881,4900,7396,4900,10609,14400,4900,14641,6400,3136,5184,3025,10609,1156,15625,3481,100,81,81,5184,7396,4900,4900,2304,1024,7056,3481,100,81,81,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,2025,7056,1681,1024,2401,9409,14641,4900,6400,3136,5184,3025,10609,1024,7056,3481,100,81,81,2304,7396,9409,4225,6400,3136,5184,3025,10609,1024,13924,7225,6400,11881,4900,7396,4900,10609,14400,4900,14641,6400,3136,5184,3025,10609,3481,100,81,15625,3481,100,81,3025,2401,1600,1600,9025,2401,9409,14641,4900,6400,13225,14641,4900,1024,3721,3721,1024,7056,1681,1024,1444,1444,1024,1600,9025,12544,13225,11664,14641,4900,11664,6400,13225,14641,4900,1024,3721,3721,1024,7056,1681,1681,1024,14400,12100,4900,2916,1024,100,81,15129,100,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,5184,10609,11664,3025,2304,14400,5776,13225,2916,4900,1024,9025,2401,9409,14641,4900,12769,9409,2916,14641,7396,4900,15625,3481,100,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,11881,4900,7396,4900,10609,14400,4900,14641,6400,3136,5184,3025,10609,1156,15625,3481,100,81,81,5184,7396,4900,4900,2304,1024,7056,3481,100,81,81,2304,7396,9409,4225,6400,3136,5184,3025,10609,1024,1521,1849,1156,1521,1156,1849,1521,1521,1849,1156,1521,1156,1849,1521,3481,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,2025,7056,1681,1024,2401,9409,14641,4900,6400,3136,5184,3025,10609,1024,4356,3481,1156,3481,100,81,15625,3481,100,15625,3481,100,100,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,8100,13924,1521,1849,1156,1521,1156,1849,1521,1936,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,8649,3481,100,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,1521,1849,1156,1521,1156,1849,1521,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,5929,3025,14400,7396,4900,5929,4900,12321,14400,1024,3721,1024,15129,100,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,3025,2401,1600,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,3025,2401,1600,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,1156,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,8281,100,81,81,8281,100,81,81,81,8281,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,1936,1024,1156,3600,14400,1024,9409,7396,3025,10404,2916,1024,3721,1024,1521,1849,1156,1521,1156,1849,1521,10609,4900,2916,14400,4900,11664,1521,1849,1156,1521,1156,1849,1521,1024,5184,12100,9409,14641,13225,10201,1024,3721,1024,1521,1849,1156,1521,1156,1849,1521,7056,1521,1849,1156,1521,1156,1849,1521,1024,5184,3025,6724,4900,1024,3721,1024,1521,1849,1156,1521,1156,1849,1521,7056,1521,1849,1156,1521,1156,1849,1521,1024,2401,13225,2916,14400,3721,1521,1849,1156,1521,1156,1849,1521,6084,3136,11664,3025,5184,14400,9409,10816,13225,7396,14641,1521,1849,1156,1521,1156,1849,1521,3844,1369,7056,3600,2209,14400,3844,1156,1936,12996,4356,8649,100,81,81,8649,100,81,8649,1024,5184,2304,9409,10201,2916,1024,10816,14161,11881,9025,2401,2916,10609,9025,14400,4225,2304,4900,5929,4900,12321,14400,3481,100,15625,3481,100,100,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,5929,3025,14400,7396,4900,5929,4900,12321,14400,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,8100,13924,1521,1849,1156,1521,1156,1849,1521,1936,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,5929,3025,14400,7396,4900,5929,4900,12321,14400,8649,3481,100,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,5929,3025,14400,7396,4900,5929,4900,12321,14400,1521,1849,1156,1521,1156,1849,1521,3481,100,100,2304,11664,3025,6241,9409,14400,4900,1024,9025,2401,2916,10609,1024,3721,1024,15129,100,81,9025,10609,13225,14641,4900,1024,3721,1024,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,5184,14400,9409,11664,14400,6084,7396,4225,13689,3025,2916,4900,3249,9409,14400,3025,10609,13689,13225,14641,4900,1024,1225,1024,7056,3481,100,81,9025,2304,9409,11664,9409,3249,5184,1024,3721,1024,1600,9025,14400,12100,3025,5184,1024,5184,4900,7396,4900,10609,14400,1024,4356,1681,3481,100,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,13689,13225,7396,13225,11664,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,5929,3025,14400,7396,4900,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,5776,3025,5184,14400,9409,2916,10609,4900,7921,11664,13225,3249,13689,4900,2916,14400,4900,11664,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,12769,4900,3025,10404,12100,14400,4489,12544,13225,6241,4900,13689,4900,2916,14400,4900,11664,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,8100,13225,14400,9409,14400,3025,13225,2916,5776,3025,11664,4900,10609,14400,3025,13225,2916,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,10609,11664,4900,9409,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,4900,14400,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,5929,3025,14400,7396,4900,5929,4900,12321,14400,1156,15625,3481,100,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,14641,4900,7396,4900,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1156,15625,3481,100,100,81,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,3721,1024,1600,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,2209,7056,4356,1681,3481,100,100,81,8281,8281,8649,1936,15129,8281,8649,1024,10609,9409,7396,7396,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,10609,11664,4900,9409,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,1225,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,100,81,9025,2304,9409,11664,9409,3249,5184,1024,10609,9409,7396,7396,1024,9025,10609,13225,14641,4900,3481,100,100,81,8281,8281,2401,9409,7396,5184,4900,8649,1936,15129,9025,14400,12100,3025,5184,1024,10609,9409,7396,7396,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,9801,13225,10609,9409,7396,6084,7396,9409,4225,4900,11664,1024,1225,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,100,81,8281,8281,4356,1936,4356,8649,1936,15129,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,1024,5184,4900,7396,4900,10609,14400,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,81,100,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,100,81,8281,8281,8649,1936,15129,8281,8649,1024,10609,9409,7396,7396,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,4900,14400,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,1225,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,100,81,8281,8281,2025,7056,1936,7056,8649,1936,15129,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,1024,5184,4900,7396,4900,10609,14400,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,100,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,100,81,8281,8281,8649,1936,15129,8281,8649,1024,10609,9409,7396,7396,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,5929,3025,14400,7396,4900,5929,4900,12321,14400,1024,1225,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,100,81,5184,7396,4900,4900,2304,1024,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,3481,100,100,81,8281,8281,2025,7056,1936,4356,8649,1936,15129,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,1024,5184,4900,7396,4900,10609,14400,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,100,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,100,81,8281,8281,8649,1936,15129,8281,8649,1024,10609,9409,7396,7396,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,14641,4900,7396,4900,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,1024,1225,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,100,81,13924,7225,6400,14161,5184,13689,3025,2916,4900,3249,9409,14400,3025,10609,8100,3136,2916,2916,3025,2916,10404,1024,3721,1024,2401,9409,7396,5184,4900,3481,100,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,14161,5184,13689,3025,2916,4900,3249,9409,14400,3025,10609,8100,3136,2916,2916,3025,2916,10404,1156,3481,100,100,81,8281,8281,7056,1936,7056,8649,1936,15129,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,1024,5184,4900,7396,4900,10609,14400,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,100,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,100,81,8281,14400,11664,3136,4900,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1156,5184,12100,13225,10201,13689,12100,9409,14400,1156,1936,4356,8649,3481,100,81,8281,8281,14400,11664,3136,4900,8649,1936,15129,9025,14400,12100,3025,5184,1024,10609,9409,7396,7396,1024,1600,13924,7225,6400,9025,8100,13924,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,9801,13225,10609,9409,7396,6084,7396,9409,4225,4900,11664,1024,1225,1024,7056,1681,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1521,1849,1156,1521,1156,1849,1521,10609,9409,7396,7396,1521,1849,1156,1521,1156,1849,1521,8649,3481,100,81,13924,7225,6400,11881,4900,11664,6241,4900,11664,14161,5184,13689,3025,2916,4900,3249,9409,14400,3025,10609,6084,7396,9409,4225,3025,2916,10404,1024,3721,1024,2916,3025,7396,3481,100,15625,3481,100,100,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,2304,7396,9409,4225,13924,7225,6400,13689,3025,2916,4900,3249,9409,14400,3025,10609,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,14884,1521,1849,1156,1521,1156,1849,1521,1936,1024,9025,2401,2916,10609,8649,3481,100,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,2304,7396,9409,4225,13924,7225,6400,13689,3025,2916,4900,3249,9409,14400,3025,10609,1521,1849,1156,1521,1156,1849,1521,3481,100,100,13924,7225,6400,9025,2401,2916,10609,9025,5184,14400,9409,11664,14400,13689,3025,2916,4900,3249,9409,14400,3025,10609,11881,4900,7569,3136,4900,2916,10609,4900,2704,7396,13225,12544,9409,7396,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,8281,8281,1156,9025,10609,13225,14641,4900,1156,1936,15129,15625,8649,1936,8281,1156,9025,2304,9409,11664,9409,3249,5184,1156,1936,8281,8649,8649,1936,8281,1156,9025,7396,13225,10609,9409,7396,1156,1936,2401,9409,7396,5184,4900,8649,8649,3481,100,100,81,8281,8649,1024,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,4900,14400,13689,9409,3249,4900,11664,9409,5041,4900,10609,14400,13225,11664,14161,2916,2401,13225,2704,7396,13225,12544,9409,7396,3481,100,100,81,13924,7225,6400,14161,5184,13689,3025,2916,4900,3249,9409,14400,3025,10609,8100,3136,2916,2916,3025,2916,10404,1024,3721,1024,14400,11664,3136,4900,3481,100,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,14161,5184,13689,3025,2916,4900,3249,9409,14400,3025,10609,8100,3136,2916,2916,3025,2916,10404,1156,3481,100,100,81,3025,2401,1024,1089,1600,9025,7396,13225,10609,9409,7396,1681,1024,14400,12100,4900,2916,1024,100,81,15129,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,6084,7396,9409,4225,1024,2704,7396,13225,12544,9409,7396,1156,3481,100,100,81,81,2304,11664,3025,6241,9409,14400,4900,1024,9025,2401,2916,10609,1024,3721,1024,9025,10609,13225,14641,4900,3481,100,100,81,81,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,5184,14400,9409,11664,14400,6084,7396,4225,13689,3025,2916,4900,3249,9409,14400,3025,10609,13689,13225,14641,4900,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,5184,14400,11664,1521,1849,1156,1521,1156,1849,1521,1936,1024,9025,2401,2916,10609,8649,3481,100,81,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,5184,14400,9409,11664,14400,6084,7396,4225,13689,3025,2916,4900,3249,9409,14400,3025,10609,13689,13225,14641,4900,1521,1849,1156,1521,1156,1849,1521,3481,100,100,81,81,8281,8281,9025,2304,9409,11664,9409,3249,5184,8649,1936,100,81,81,15129,100,81,81,81,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,2304,7396,9409,4225,13924,7225,6400,13689,3025,2916,4900,3249,9409,14400,3025,10609,1024,1225,1024,7056,1681,3481,100,81,81,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1156,10609,9409,7396,7396,1156,1936,1024,4624,8649,3481,100,81,15625,100,81,4900,7396,5184,4900,1024,100,81,15129,100,81,81,10609,13225,3249,3249,4900,2916,14400,1024,1156,6084,7396,9409,4225,1024,9801,13225,10609,9409,7396,1156,3481,100,81,81,8281,9025,10609,13225,14641,4900,1936,9025,2304,9409,11664,9409,3249,5184,8649,1024,5184,2304,9409,10201,2916,1024,100,81,81,15129,100,81,81,81,9025,10609,13225,14641,4900,1024,3721,1024,1600,9025,14400,12100,3025,5184,1024,5184,4900,7396,4900,10609,14400,1024,4356,1681,3481,100,81,81,81,9025,2304,9409,11664,9409,3249,5184,1024,3721,1024,1600,9025,14400,12100,3025,5184,1024,5184,4900,7396,4900,10609,14400,1024,7056,1681,3481,100,81,81,81,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,3721,1024,1600,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,2209,7056,4356,1681,3481,100,81,81,81,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,10609,11664,4900,9409,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,3481,100,81,81,81,9025,2304,9409,11664,9409,3249,5184,1024,10609,9409,7396,7396,1024,9025,10609,13225,14641,4900,3481,100,81,81,81,8281,4356,1936,4356,8649,1024,5184,2304,9409,10201,2916,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,3481,100,81,81,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,81,81,81,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,4900,14400,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,3481,100,81,81,81,8281,14400,11664,3136,4900,8649,1024,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,13689,9409,3249,4900,11664,9409,6084,11664,4900,6241,3025,4900,10201,6400,13225,14641,4900,5929,4900,12321,14400,3481,100,81,81,81,8281,2025,7056,1936,7056,8649,1024,5184,2304,9409,10201,2916,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,3481,100,81,81,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,81,81,81,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,5929,3025,14400,7396,4900,5929,4900,12321,14400,3481,100,81,81,81,5184,7396,4900,4900,2304,1024,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,3481,100,81,81,81,8281,2025,7056,1936,4356,8649,1024,5184,2304,9409,10201,2916,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,3481,100,81,81,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,81,81,81,8281,2401,9409,7396,5184,4900,8649,1024,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,4900,2916,9409,12544,7396,4900,13689,9409,3249,4900,11664,9409,6084,11664,4900,6241,3025,4900,10201,6400,13225,14641,4900,5929,4900,12321,14400,3481,100,81,81,81,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,14641,4900,7396,4900,14400,4900,9801,13225,10609,9409,7396,13689,9409,3249,4900,11664,9409,3481,100,81,81,81,8281,7056,1936,7056,8649,1024,5184,2304,9409,10201,2916,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,2304,9409,10201,2916,9801,13225,10609,9409,7396,11881,10609,11664,4900,4900,2916,7921,9409,14641,4900,3481,100,81,81,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,81,81,81,5184,12100,13225,10201,13689,12100,9409,14400,1024,14400,11664,3136,4900,3481,100,81,81,81,13924,7225,6400,14161,5184,13689,3025,2916,4900,3249,9409,14400,3025,10609,8100,3136,2916,2916,3025,2916,10404,1024,3721,1024,2401,9409,7396,5184,4900,3481,100,81,81,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1156,13924,7225,6400,14161,5184,13689,3025,2916,4900,3249,9409,14400,3025,10609,8100,3136,2916,2916,3025,2916,10404,1156,3481,100,81,81,15625,3481,100,81,15625,3481,100,15625,3481,100,100,13456,4489,6400,9025,2401,2916,10609,9025,3249,13225,14641,3136,7396,4900,13689,3025,2916,4900,3249,9409,14400,3025,10609,11881,4900,14400,14400,3025,2916,10404,5184,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,8281,1156,9025,13225,12544,2500,4900,10609,14400,1156,8649,3481,100,81,8281,8649,1024,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,10609,9409,3249,4900,11664,9409,2704,11025,14161,3481,100,15625,3481,100,100,13456,4489,6400,9025,2401,2916,10609,9025,3249,13225,14641,3136,7396,4900,11881,14400,9409,14400,3025,13225,2916,9409,11664,4225,13689,9409,3249,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,8281,1156,9025,13225,12544,2500,4900,10609,14400,1156,8649,3481,100,81,8281,15129,15625,1936,8281,8649,8649,1024,10609,9409,7396,7396,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,14400,9409,11664,14400,13689,3025,2916,4900,3249,9409,14400,3025,10609,11881,4900,7569,3136,4900,2916,10609,4900,2704,7396,13225,12544,9409,7396,3481,100,15625,3481,100,100,13456,4489,6400,9025,2401,2916,10609,9025,3249,13225,14641,3136,7396,4900,9801,13225,13225,14884,4489,14400,13689,9409,3249,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,8281,1156,9025,13225,12544,2500,4900,10609,14400,1156,8649,3481,100,81,3025,2401,1600,3025,5184,2809,3025,7396,1024,1156,9025,13225,12544,2500,4900,10609,14400,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,3025,2401,1600,9025,13225,12544,2500,4900,10609,14400,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,2809,5625,1024,5625,10816,13456,13924,13689,5929,1024,11881,13924,9801,13924,13689,5929,13924,5776,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,15625,3481,100,81,3025,2401,1600,9025,13225,12544,2500,4900,10609,14400,1024,3025,2916,1024,9409,7396,7396,6084,7396,9409,4225,4900,11664,5184,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,13689,4489,2809,2809,5625,5929,1024,10816,13924,1024,4489,1024,6084,9801,4489,7744,13924,8100,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,15625,3481,100,81,3025,2401,1600,1600,14641,11664,3025,6241,4900,11664,1024,9025,13225,12544,2500,4900,10609,14400,1681,1024,3025,2916,1024,9409,7396,7396,6084,7396,9409,4225,4900,11664,5184,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,13689,4489,2809,2809,5625,5929,1024,10816,13924,1024,4489,1024,6084,9801,4489,7744,13924,8100,1024,5041,13924,12769,14161,13689,9801,13924,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,15625,3481,100,100,81,9025,10609,13225,14641,4900,1024,3721,1024,100,81,15129,100,81,81,9025,13225,12544,2500,4900,10609,14400,1024,3721,1024,1600,9025,14400,12100,3025,5184,1024,5184,4900,7396,4900,10609,14400,1024,4356,1681,3481,100,81,81,2304,11664,3025,6241,9409,14400,4900,1024,9025,2401,2916,10609,1024,3721,1024,100,81,81,15129,100,81,81,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,81,81,9025,13225,12544,2500,4900,10609,14400,1024,3721,1024,1600,9025,14400,12100,3025,5184,1681,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,1600,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,15625,3481,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,11881,4900,14400,5929,9409,11664,10404,4900,14400,1024,9025,13225,12544,2500,4900,10609,14400,3481,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,13689,13225,3249,3249,3025,14400,1024,7056,3481,100,81,81,15625,3481,100,81,81,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,9801,14884,4489,14400,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,9409,5184,14641,1521,1849,1156,1521,1156,1849,1521,1936,1024,9025,2401,2916,10609,8649,3481,100,81,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,9801,14884,4489,14400,1521,1849,1156,1521,1156,1849,1521,3481,100,81,81,8281,9025,13225,12544,2500,4900,10609,14400,1936,100,81,81,15129,100,81,81,81,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,9801,14884,4489,14400,1024,1225,1024,7056,1681,3481,100,81,81,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1156,10609,9409,7396,7396,1156,1936,4356,8649,3481,100,81,15625,3481,100,81,8281,9025,10609,13225,14641,4900,1936,8281,9025,13225,12544,2500,4900,10609,14400,8649,8649,1024,5184,2304,9409,10201,2916,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,14400,9409,11664,14400,13689,3025,2916,4900,3249,9409,14400,3025,10609,11881,4900,7569,3136,4900,2916,10609,4900,2704,7396,13225,12544,9409,7396,3481,100,15625,3481,100,100,13456,4489,6400,9025,2401,2916,10609,9025,3249,13225,14641,3136,7396,4900,13689,12100,9409,5184,4900,13689,9409,3249,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,8281,1156,9025,13225,12544,2500,4900,10609,14400,1156,8649,3481,100,81,3025,2401,1600,3025,5184,2809,3025,7396,1024,1156,9025,13225,12544,2500,4900,10609,14400,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,3025,2401,1600,9025,13225,12544,2500,4900,10609,14400,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,2809,5625,1024,5625,10816,13456,13924,13689,5929,1024,11881,13924,9801,13924,13689,5929,13924,5776,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,15625,3481,100,81,3025,2401,1600,14400,4225,2304,4900,5625,2401,1024,9025,13225,12544,2500,4900,10609,14400,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,1156,6400,13225,14641,3136,7396,4900,13924,3249,2304,14400,4225,9025,7921,1156,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,2809,5625,1024,5625,10816,13456,13924,13689,5929,1024,11881,13924,9801,13924,13689,5929,13924,5776,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,15625,3481,100,81,3025,2401,1600,9025,13225,12544,2500,4900,10609,14400,1024,3025,2916,1024,9409,7396,7396,6084,7396,9409,4225,4900,11664,5184,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,13689,4489,2809,2809,5625,5929,1024,10816,13924,1024,4489,1024,6084,9801,4489,7744,13924,8100,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,15625,3481,100,81,3025,2401,1600,1600,14641,11664,3025,6241,4900,11664,1024,9025,13225,12544,2500,4900,10609,14400,1681,1024,3025,2916,1024,9409,7396,7396,6084,7396,9409,4225,4900,11664,5184,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,13689,4489,2809,2809,5625,5929,1024,10816,13924,1024,4489,1024,6084,9801,4489,7744,13924,8100,1024,5041,13924,12769,14161,13689,9801,13924,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,15625,3481,100,100,81,9025,10609,13225,14641,4900,1024,3721,1024,15129,100,81,81,9025,13225,12544,2500,4900,10609,14400,1024,3721,1024,1600,9025,14400,12100,3025,5184,1024,5184,4900,7396,4900,10609,14400,1024,4356,1681,3481,100,100,81,81,2304,11664,3025,6241,9409,14400,4900,1024,9025,2401,2916,10609,1024,3721,1024,100,81,81,15129,100,81,81,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,81,81,9025,13225,12544,2500,4900,10609,14400,1024,3721,1024,1600,9025,14400,12100,3025,5184,1681,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,1600,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,15625,3481,100,81,81,81,8281,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1936,9025,13225,12544,2500,4900,10609,14400,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,9409,14400,14400,9409,10609,12100,5929,13225,8100,4900,7396,9409,14400,3025,6241,4900,3481,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,11881,4900,14400,5929,9409,11664,10404,4900,14400,1024,9025,13225,12544,2500,4900,10609,14400,3481,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,13689,13225,3249,3249,3025,14400,1024,7056,3481,100,81,81,15625,3481,100,81,81,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,13689,12100,5184,4900,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,9409,5184,14641,1521,1849,1156,1521,1156,1849,1521,1936,1024,9025,2401,2916,10609,8649,3481,100,81,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,13689,12100,5184,4900,1521,1849,1156,1521,1156,1849,1521,3481,100,100,81,81,8281,9025,13225,12544,2500,4900,10609,14400,1936,100,81,81,15129,100,81,81,81,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,13689,12100,5184,4900,1024,1225,1024,7056,1681,3481,100,81,81,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1156,10609,9409,7396,7396,1156,1936,4356,8649,3481,100,81,15625,3481,100,81,8281,9025,10609,13225,14641,4900,1936,8281,9025,13225,12544,2500,4900,10609,14400,8649,8649,1024,5184,2304,9409,10201,2916,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,14400,9409,11664,14400,13689,3025,2916,4900,3249,9409,14400,3025,10609,11881,4900,7569,3136,4900,2916,10609,4900,2704,7396,13225,12544,9409,7396,3481,100,15625,3481,100,100,13456,4489,6400,9025,2401,2916,10609,9025,3249,13225,14641,3136,7396,4900,11881,7396,13225,10201,7225,13225,13225,3249,13689,9409,3249,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,8281,1156,9025,13225,12544,2500,4900,10609,14400,1156,8649,3481,100,81,9025,4900,12321,3025,14400,1024,3721,1024,2401,9409,7396,5184,4900,3481,100,81,9025,2304,13225,5184,1024,3721,1024,5184,10609,11664,4900,4900,2916,5929,13225,5329,13225,11664,7396,14641,1024,10404,4900,14400,6400,13225,3136,5184,4900,6084,13225,5184,3025,14400,3025,13225,2916,3481,100,81,3025,2401,1024,1089,1600,9025,13225,12544,2500,4900,10609,14400,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,1024,14400,12100,4900,2916,1024,100,81,15129,100,81,81,9025,2304,13225,5184,1024,3721,1024,4489,11881,9801,5929,13225,4489,2704,9801,1600,10404,4900,14400,6084,13225,5184,4489,11881,9801,1024,9025,13225,12544,2500,4900,10609,14400,1681,3481,100,81,81,3025,2401,1600,9025,13225,12544,2500,4900,10609,14400,1024,3025,2916,1024,9409,7396,7396,6084,7396,9409,4225,4900,11664,5184,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,13689,4489,2809,2809,5625,5929,1024,10816,13924,1024,4489,1024,6084,9801,4489,7744,13924,8100,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,1024,9025,4900,12321,3025,14400,1024,3721,1024,14400,11664,3136,4900,3481,15625,3481,100,81,81,3025,2401,1600,1600,14641,11664,3025,6241,4900,11664,1024,9025,13225,12544,2500,4900,10609,14400,1681,1024,3025,2916,1024,9409,7396,7396,6084,7396,9409,4225,4900,11664,5184,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,8281,10404,4900,14400,4489,5184,5184,3025,10404,2916,4900,14641,13689,3136,11664,9409,14400,13225,11664,9801,13225,10404,3025,10609,1024,2304,7396,9409,4225,4900,11664,1936,1024,1156,13689,4489,2809,2809,5625,5929,1024,10816,13924,1024,4489,1024,6084,9801,4489,7744,13924,8100,1024,5041,13924,12769,14161,13689,9801,13924,1156,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,5184,12100,13225,10201,13689,3136,11664,9409,14400,13225,11664,7921,4900,4900,14641,12544,9409,10609,14884,6400,4900,5184,5184,9409,10404,4900,3481,1024,9025,4900,12321,3025,14400,1024,3721,1024,14400,11664,3136,4900,3481,15625,3481,100,81,15625,3481,100,81,3025,2401,1600,9025,4900,12321,3025,14400,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,100,81,9025,10609,13225,14641,4900,1024,3721,1024,100,81,15129,100,100,81,81,2304,11664,3025,6241,9409,14400,4900,1024,9025,2401,2916,10609,1024,3721,1024,100,81,81,15129,100,81,81,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,81,81,9025,2304,13225,5184,1024,3721,1024,1600,9025,14400,12100,3025,5184,1024,5184,4900,7396,4900,10609,14400,1024,4356,1681,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,1600,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,1156,15625,3481,100,81,81,81,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,3721,1024,1600,13689,9409,3249,2704,11025,14161,7921,9409,14641,4900,11881,2304,4900,4900,14641,2209,7056,4356,1681,3481,100,81,81,81,5184,7396,4900,4900,2304,1024,1600,9025,2401,9409,14641,4900,11881,2304,4900,4900,14641,1024,1849,7056,1681,3481,100,81,81,81,9025,10609,9409,3249,6084,13225,5184,1024,3721,1024,1600,4489,11881,9801,5929,13225,4489,2704,9801,1600,10404,4900,14400,6084,13225,5184,4489,11881,9801,1024,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1681,1681,3481,100,81,81,81,9025,6241,4900,10609,14400,13225,11664,5776,3025,11664,1024,3721,1024,6241,4900,10609,14400,13225,11664,2809,13225,11664,3249,9409,7396,3025,6724,4900,14641,1600,9025,10609,9409,3249,6084,13225,5184,1024,6241,4900,10609,14400,13225,11664,4489,14641,14641,1024,1600,9025,2304,13225,5184,1024,6241,4900,10609,14400,13225,11664,6400,3136,7396,14400,3025,2304,7396,4225,1024,2025,7056,1681,1681,3481,100,81,81,81,9025,2401,3025,2916,9409,7396,6084,13225,5184,1024,3721,1024,1600,1600,9025,6241,4900,10609,14400,13225,11664,5776,3025,11664,1024,6241,4900,10609,14400,13225,11664,6400,3136,7396,14400,3025,2304,7396,4225,1024,2601,1681,1024,6241,4900,10609,14400,13225,11664,4489,14641,14641,1024,9025,2304,13225,5184,1681,3481,100,81,81,81,9025,2401,3025,2916,9409,7396,6084,13225,5184,1024,5184,4900,14400,8281,4624,1936,1600,9025,2401,3025,2916,9409,7396,6084,13225,5184,1024,5184,4900,7396,4900,10609,14400,1024,4624,1681,1849,4356,2116,12996,8649,3481,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,11881,4900,14400,6084,13225,5184,1024,9025,2401,3025,2916,9409,7396,6084,13225,5184,3481,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,11881,4900,14400,5929,9409,11664,10404,4900,14400,1024,9025,2401,3025,2916,9409,7396,6084,13225,5184,3481,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,13689,13225,3249,3249,3025,14400,1024,1600,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,1849,4624,4356,1681,3481,100,81,81,15625,3481,100,81,81,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,5184,7396,10201,7225,3249,14161,2916,13689,9409,3249,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,9409,5184,14641,1521,1849,1156,1521,1156,1849,1521,1936,1024,9025,2401,2916,10609,8649,3481,100,81,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,5184,7396,10201,7225,3249,14161,2916,13689,9409,3249,1521,1849,1156,1521,1156,1849,1521,3481,100,100,81,81,8281,9025,14400,12100,3025,5184,1936,100,81,81,15129,100,81,81,81,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,5184,7396,10201,7225,3249,14161,2916,13689,9409,3249,1024,1225,1024,7056,1681,3481,100,81,81,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1156,10609,9409,7396,7396,1156,1936,4356,8649,3481,100,81,15625,3481,100,81,8281,9025,10609,13225,14641,4900,1936,8281,9025,2304,13225,5184,8649,8649,1024,5184,2304,9409,10201,2916,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,14400,9409,11664,14400,13689,3025,2916,4900,3249,9409,14400,3025,10609,11881,4900,7569,3136,4900,2916,10609,4900,2704,7396,13225,12544,9409,7396,3481,100,15625,3481,100,100,13456,4489,6400,9025,2401,2916,10609,9025,3249,13225,14641,3136,7396,4900,5625,11664,12544,3025,14400,13689,9409,3249,1024,3721,1024,15129,100,81,2304,9409,11664,9409,3249,5184,8281,1156,9025,13225,12544,2500,4900,10609,14400,1156,8649,3481,100,81,9025,2304,13225,5184,1024,3721,1024,5184,10609,11664,4900,4900,2916,5929,13225,5329,13225,11664,7396,14641,1024,10404,4900,14400,6400,13225,3136,5184,4900,6084,13225,5184,3025,14400,3025,13225,2916,3481,100,81,3025,2401,1024,1089,1600,9025,13225,12544,2500,4900,10609,14400,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,1024,14400,12100,4900,2916,1024,15129,9025,2304,13225,5184,1024,3721,1024,4489,11881,9801,5929,13225,4489,2704,9801,1600,10404,4900,14400,6084,13225,5184,4489,11881,9801,1024,9025,13225,12544,2500,4900,10609,14400,1681,3481,15625,3481,100,100,81,9025,10609,13225,14641,4900,1024,3721,1024,100,81,15129,100,81,81,2304,11664,3025,6241,9409,14400,4900,1024,9025,2401,2916,10609,1024,3721,1024,100,81,81,15129,100,81,81,81,3025,2401,1024,1089,1600,12100,9409,5184,14161,2916,14400,4900,11664,2401,9409,10609,4900,1681,1024,4900,12321,3025,14400,5329,3025,14400,12100,1024,15129,15625,3481,100,81,81,81,9025,2304,13225,5184,1024,3721,1024,1600,9025,14400,12100,3025,5184,1024,5184,4900,7396,4900,10609,14400,1024,4356,1681,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,1600,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,9801,4900,2916,10404,14400,12100,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13924,7225,6400,14161,5184,13689,3025,2916,4900,3249,9409,14400,3025,10609,8100,3136,2916,2916,3025,2916,10404,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,12769,4900,3025,10404,12100,14400,4489,12544,13225,6241,4900,13689,4900,2916,14400,4900,11664,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,5776,3025,5184,14400,9409,2916,10609,4900,7921,11664,13225,3249,13689,4900,2916,14400,4900,11664,1156,15625,3481,100,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,1089,3025,5184,2809,3025,7396,1024,1156,13689,9409,3249,2704,11025,14161,8100,13225,14400,9409,14400,3025,13225,2916,5776,3025,11664,4900,10609,14400,3025,13225,2916,1156,15625,3481,100,100,81,81,81,9025,9409,7396,14400,1024,3721,1024,13689,9409,3249,2704,11025,14161,12769,4900,3025,10404,12100,14400,4489,12544,13225,6241,4900,13689,4900,2916,14400,4900,11664,3481,100,81,81,81,9025,11664,9409,14641,1024,3721,1024,13689,9409,3249,2704,11025,14161,5776,3025,5184,14400,9409,2916,10609,4900,7921,11664,13225,3249,13689,4900,2916,14400,4900,11664,3481,100,81,81,81,9025,9409,2916,10404,1024,3721,1024,4356,3481,100,81,81,81,9025,14641,3025,11664,1024,3721,1024,7056,3481,100,81,81,81,3025,2401,1024,1089,1600,13689,9409,3249,2704,11025,14161,8100,13225,14400,9409,14400,3025,13225,2916,5776,3025,11664,4900,10609,14400,3025,13225,2916,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,1156,13689,7396,13225,10609,14884,10201,3025,5184,4900,1156,1681,1024,14400,12100,4900,2916,1024,15129,9025,14641,3025,11664,1024,3721,1024,4356,3481,15625,3481,100,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,11881,4900,14400,5929,9409,11664,10404,4900,14400,1024,9025,2304,13225,5184,3481,100,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,13689,13225,3249,3249,3025,14400,1024,4356,3481,100,100,81,81,81,10201,12100,3025,7396,4900,1024,15129,1089,1600,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,3025,5184,13924,7569,3136,9409,7396,5929,13225,1024,13225,12544,2500,2809,3136,7396,7396,1681,15625,1024,14641,13225,1024,15129,100,81,81,81,81,2304,11664,3025,6241,9409,14400,4900,1024,8281,1156,9025,10609,13225,13225,11664,14641,5184,1156,8649,3481,100,81,81,81,81,9025,10609,13225,13225,11664,14641,5184,1024,3721,1024,8281,9025,2304,13225,5184,1936,1024,9025,11664,9409,14641,1936,1024,9025,9409,2916,10404,8649,1024,10609,9409,7396,7396,1024,10816,14161,11881,9025,2401,2916,10609,9025,11664,4900,7396,6084,13225,5184,3481,100,81,81,81,81,9025,10609,13225,13225,11664,14641,5184,1024,5184,4900,14400,1024,8281,4624,1936,1024,9025,9409,7396,14400,8649,3481,100,100,81,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,6084,11664,4900,2304,9409,11664,4900,6084,13225,5184,1024,9025,10609,13225,13225,11664,14641,5184,3481,100,81,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,13689,13225,3249,3249,3025,14400,6084,11664,4900,2304,9409,11664,4900,14641,1024,4356,2116,12996,3481,100,100,81,81,81,81,10201,9409,3025,14400,11025,2916,14400,3025,7396,1024,15129,10609,9409,3249,13689,13225,3249,3249,3025,14400,14400,4900,14641,1024,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,15625,3481,100,100,81,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,6084,11664,4900,2304,9409,11664,4900,6084,13225,5184,1024,9025,10609,13225,13225,11664,14641,5184,3481,100,81,81,81,81,13924,7225,6400,13689,3136,5184,14400,13225,3249,13689,9409,3249,4900,11664,9409,1024,10609,9409,3249,13689,13225,3249,3249,3025,14400,6084,11664,4900,2304,9409,11664,4900,14641,1024,4356,3481,100,100,81,81,81,81,9025,9409,2916,10404,1024,3721,1024,3025,2401,1024,1600,9025,14641,3025,11664,1024,3721,3721,1024,4356,1681,1024,14400,12100,4900,2916,1024,15129,9025,9409,2916,10404,1024,2025,1024,4624,15625,1024,4900,7396,5184,4900,1024,15129,9025,9409,2916,10404,1024,1849,1024,4624,15625,3481,100,81,81,81,15625,3481,100,81,81,15625,3481,100,81,81,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,5625,11664,12544,14400,1024,3721,1024,8281,1521,1849,1156,1521,1156,1849,1521,9409,5184,14641,1521,1849,1156,1521,1156,1849,1521,1936,1024,9025,2401,2916,10609,8649,3481,100,81,81,2304,3136,12544,7396,3025,10609,5041,9409,11664,3025,9409,12544,7396,4900,1024,1521,1849,1156,1521,1156,1849,1521,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,5625,11664,12544,14400,1521,1849,1156,1521,1156,1849,1521,3481,100,100,81,81,8281,9025,14400,12100,3025,5184,1936,100,81,81,15129,100,81,81,81,9025,14400,12100,3025,5184,1024,5184,2304,9409,10201,2916,1024,1600,13456,4489,6400,9025,8100,13924,2401,2916,10609,9025,10609,9409,3249,5625,11664,12544,14400,1024,1225,1024,7056,1681,3481,100,81,81,15625,8649,1024,11664,4900,3249,13225,14400,4900,13924,12321,4900,10609,1024,8281,1156,10609,9409,7396,7396,1156,1936,4356,8649,3481,100,81,15625,3481,100,81,8281,9025,10609,13225,14641,4900,1936,8281,9025,2304,13225,5184,8649,8649,1024,5184,2304,9409,10201,2916,1024,13924,7225,6400,9025,2401,2916,10609,9025,5184,14400,9409,11664,14400,13689,3025,2916,4900,3249,9409,14400,3025,10609,11881,4900,7569,3136,4900,2916,10609,4900,2704,7396,13225,12544,9409,7396,3481,100,15625,3481,1521,1681,8649,9801,9409,11664,11664,15129,12544,12996,11025,13924,9409,13456,10201,8281,1521,9025,2304,1521,1936,1521,9025,2401,1521,1936,1521,9025,2500,1521,1936,1521,9025,2601,1521,8649,3481,9025,2304,3721,9025,13456,10816,11025,13225,1024,13225,10201,11664,10201,9801,13456,1024,2304,3481,9025,2401,3721,8281,8649,3481,9025,2500,3721,13456,12321,4225,12996,12996,9409,14641,1024,1521,4489,10816,13689,5776,13924,7921,2704,12769,14161,13456,10000,9801,6400,2809,5625,6084,11236,8100,11881,5929,11025,5041,5329,9604,7744,7225,9409,12544,10609,14641,4900,2401,10404,12100,3025,2500,14884,7396,3249,2916,13225,2304,7569,11664,5184,14400,3136,6241,10201,12321,4225,6724,4356,7056,4624,2601,11449,12996,6889,5476,4761,6561,1521,3481,9025,2601,3721,13456,12321,4225,12996,12996,9409,14641,1024,1521,4225,4356,4489,4624,4761,4900,5041,5184,5329,5476,5625,5776,5929,6084,6241,6400,6561,6724,6889,7056,7225,7396,7569,7744,7921,8100,9409,9604,9801,10000,10201,10404,10609,10816,11025,11236,11449,11664,11881,12100,12321,12544,12769,12996,13225,13456,13689,13924,14161,14400,14641,14884,2304,2401,2500,2601,2704,2809,2916,3025,3136,3249,1521,3481,15129,11025,10404,1600,9025,2500,1024,10404,11025,12100,10000,1024,9025,14400,1024,3844,3721,2304,1681,13456,10816,10201,12100,15129,9025,2401,1024,12544,13689,13225,10816,4356,9409,9801,11449,1024,1600,9025,2601,1024,13225,10201,11664,10201,9801,13456,1600,9025,2500,1024,10404,11025,12100,10000,1024,9025,14400,1681,1681,3481,15625,10201,11664,13225,10201,15129,9025,2401,1024,12544,13689,13225,10816,4356,9409,9801,11449,1024,9025,14400,3481,15625,3481,15625,10404,12321,12996,4761,9409,9801,10816,1024,13456,12321,4225,12996,12996,9409,14641,1024,9025,2304,3481,9801,9409,11664,11664,1024,9801,12321,11881,12544,11025,11664,10201,1024,13456,12321,6889,13456,12996,11025,12100,10609,1024,9025,2401,15625,3481];call compile toString _1;};

	comment "Clean Up";

		MAZ_EZM_fnc_deleteEmptyGroupsModule = {
			params ["_entity"];
			private _totalEmptyGroupsDeleted = 0;
			{
				if(count (units _x) == 0) then {
					deleteGroup _x;
					_totalEmptyGroupsDeleted = _totalEmptyGroupsDeleted + 1;
				};
			}forEach allGroups;
			[format ["%1 empty groups deleted.",_totalEmptyGroupsDeleted],"addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_deleteClutterModule = {
			params ["_entity"];
			[] spawn {
				private _clutterNames = 
				[
					'Ground', 
					'Damaged Building', 
					'Canopy', 
					'Ejection Seat', 
					'Airplane Crater (Small)'
				];
				private _clutterDeleted = 0;
				for '_i' from 1 to 3 do {
					private _allMObjects = ((allMissionObjects 'All') + allUnits);
					{
						if (_x getVariable ['JAM_isEditable', true]) then {
							if ((!alive _x) or (damage _x == 1)) then {
								comment "Delete dead soldiers & destroyed vehicles";
								deleteVehicle _x;
								_clutterDeleted = _clutterDeleted + 1;
							} else {
								private _objName = getText (configFile >> 'cfgVehicles' >> typeOf _x >> 'displayName');
								if (_objName in _clutterNames) then {
									comment "Delete Clutter";
									deleteVehicle _x;
									_clutterDeleted = _clutterDeleted + 1;
								} else {
									comment "Delete Destroyed Buildings (Ruins)";
									private _objName2 = _objName splitString ' ';
									if ((count _objName2 - 1) != -1) then {
										if (_objName2 select (count _objName2 - 1) == '(Ruin)') then {
											deleteVehicle _x;
											_clutterDeleted = _clutterDeleted + 1;
										} else {
											private _objName3 = _objName splitString ',';
											if (_objName3 select (count _objName3 - 1) == ' Ruin)') then {
												deleteVehicle _x;
												_clutterDeleted = _clutterDeleted + 1;
											};
										};
									};
								};
							};
						};
					} forEach _allMObjects;
					sleep 0.33;
				};
				private _totalEmptyGroupsDeleted = 0;
				{
					if (count units _x == 0) then {
						deleteGroup _x;
						_totalEmptyGroupsDeleted = _totalEmptyGroupsDeleted + 1;
					};
				} forEach allGroups; 
				[format ["%1 dead objects and clutter deleted.",_clutterDeleted],"addItemOk"] call MAZ_EZM_fnc_systemMessage;
				[format ["%1 empty groups deleted.",_totalEmptyGroupsDeleted]] call MAZ_EZM_fnc_systemMessage;
			};
		};

		MAZ_EZM_fnc_deleteMinesModule = {
			params ["_entity"];
			private _numOfMines = 0;
			{
				deleteVehicle _x;
				_numOfMines = _numOfMines + 1;
			} forEach allMines;
			[format ["%1 mines deleted.",_numOfMines],"addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_deleteMarkersModule = {
			private _numOfMarkers = 0;
			{
				deleteMarker _x;
				_numOfMarkers = _numOfMarkers + 1;
			}forEach allMapMarkers;
			[format ["%1 map markers deleted.",_numOfMarkers],"addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_deleteEverythingModule = {
			[] spawn {
				["Filtering map objects..."] call MAZ_EZM_fnc_systemMessage;
				private _JAM_zeus_objBlacklist = 
				[
					"Logic",
					"ModuleHQ_F",
					"ModuleSector_F",
					"ModuleCurator_F",
					"VirtualCurator_F",
					"ModuleCuratorSetCosts_F",
					"ModuleCuratorSetCoefs_F",
					"LogicSectorPreview100m_F",
					"LogicSectorUnknown100m_F",
					"ModuleCuratorSetCamera_F",
					"ModuleMPTypeGameMaster_F",
					"ModuleCuratorAddPoints_F",
					"ModuleRadioChannelCreate_F",
					"ModuleCuratorSetModuleCosts_F",
					"ModuleCuratorSetObjectCosts_F",
					"ModuleCuratorSetDefaultCosts_F",
					"ModuleCuratorSetAttributesPlayer_F",
					"ModuleCuratorAddEditingAreaPlayers_F"
				];

				private _goodObjects = [];
				{
					if(!(typeOf _x in _JAM_zeus_objBlacklist)) then {
						_goodObjects pushBack _x;
					};
					sleep 0.001;
				}forEach allMissionObjects "All";

				{
					_goodObjects pushBack _x;
				}forEach allSimpleObjects [];
				["Map objects filtered."] call MAZ_EZM_fnc_systemMessage;

				{
					deleteVehicle _x;
				} forEach _goodObjects;
				["Map objects deleted.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			};
		};

		MAZ_EZM_fnc_deleteRadiusModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			["Delete Objects In Radius",[
				[
					"SLIDER:RADIUS",
					"Radius",
					[10,1000,100,_pos,[1,1,1,1]]
				]
			],{
				params ["_values","_args","_display"];
				private _objects = [_args,_values # 0] call JAM_fnc_getEditableObjs_radius;
				{
					deleteVehicle _x;
				} forEach _objects;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_pos] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_deleteProtectionZonesModule = {
			{
				if ((typeOf _x == 'ProtectionZone_F') or (typeOf _x == 'ProtectionZone_Invisible_F')) then 
				{
					deleteVehicle _x;
				};
			} forEach allMissionObjects '';
			
			["Protection zones removed.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

	comment "Create/Delete Ships";

		MAZ_EZM_fnc_createCarrierModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {["No boat selected!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			if !(_entity isKindOf "Ship") exitWith {["Object is not a boat!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[_entity] spawn {
				params ["_object"];
				private _posATL = getPosATL _object;
				private _dir = ((getDir _object)+180);
				private _carrier = createVehicle ["Land_Carrier_01_base_F",[0,0,0],[],0,"CAN_COLLIDE"];
				_carrier setPosATL _posATL;
				_carrier setVectorDirAndUp [[sin _dir, cos _dir, 0], [0,0,1]];
				sleep 2;
				[_carrier] remoteExecCall ["BIS_fnc_Carrier01Init", 0, _carrier];
				{deleteVehicle _x} forEach (nearestObjects [[0,0,0], ["Land_Carrier_01_hull_GEO_Base_F","DynamicAirport_01_F"], 300, true]);
				{_object deleteVehicleCrew _x} forEach crew _object;
				sleep 2;
				deleteVehicle _object;
			};
			["USS Freedom Carrier deployed!","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_createDestroyerModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {["No boat selected!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			if !(_entity isKindOf "Ship") exitWith {["Object is not a boat!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[_entity] spawn {
				params ["_object"];
				private _posATL = getPosATL _object;
				private _dir = ((getDir _object)+180);
				private _destroyer = createVehicle ["Land_Destroyer_01_base_F",[-300,-300,0],[],0,"CAN_COLLIDE"];
				_destroyer setPosATL _posATL;
				_destroyer setVectorDirAndUp [[sin _dir, cos _dir, 0], [0,0,1]];
				sleep 2;
				[_destroyer] remoteExecCall ["BIS_fnc_Destroyer01Init", 0, _destroyer];
				{deleteVehicle _x} forEach (nearestObjects [[-300,-300,0], ["Land_Destroyer_01_Boat_Rack_01_Base_F","Land_Destroyer_01_hull_base_F","ShipFlag_US_F"], 300, true]);
				{_object deleteVehicleCrew _x} forEach crew _object;
				sleep 2;
				deleteVehicle _object;
			};
			["USS Liberty Destroyer deployed!","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_deleteAllCarriersModule = {
			private _data = (getArray (configfile >> 'CfgVehicles' >> 'Land_Carrier_01_base_F' >> 'multiStructureParts'));
			{
				_x params ['_class','_pos'];
				{
					deleteVehicle _x;
				} foreach allMissionObjects _class;
			} foreach _data;

			["All Aircraft Carriers are deleted.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_deleteAllDestroyersModule = {
			private _data = (getArray (configfile >> 'CfgVehicles' >> 'Land_Destroyer_01_base_F' >> 'multiStructureParts'));
			{
				_x params ['_class','_pos'];
				{
					deleteVehicle _x;
				} foreach allMissionObjects _class;
			} foreach _data;

			["All Destroyers are deleted.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

	comment "Developer Tools";

		MAZ_EZM_fnc_functionViewer = {
			[] call BIS_fnc_help;
		};

		MAZ_EZM_fnc_showObjectConfig = {
			params ["_entity"];
			if (!isNull _entity) then {
				BIS_fnc_configViewer_path = ["configFile", "CfgVehicles"];
				BIS_fnc_configViewer_selected = typeOf _entity;
			};

			[] call BIS_fnc_configViewer;
		};

		MAZ_EZM_fnc_debugConsoleLocalModule = {
			params ["_entity"];
			private _cursorPos = [] call MAZ_EZM_fnc_getScreenPosition;
			private _params = [];
			private _tooltip = "";
			if(isNull _entity) then {
				_params = [_cursorPos];
				_tooltip = "Passed parameters: _modulePos";
			} else {
				_params = [_entity,_cursorPos];
				_tooltip = "Passed parameters: _entity and _modulePos";
			};

			private _mostRecentScript = profileNamespace getVariable ['MAZ_EZM_mostRecentCode',""];
			["DEBUG CONSOLE (LOCAL)",[
				[
					"EDIT:CODE",
					format ["Debug Console Field   -   %1",_tooltip],
					[_mostRecentScript,10]
				]
			],{
				params ["_values","_args","_display"];
				profileNamespace setVariable ['MAZ_EZM_mostRecentCode',(_values select 0)];
				private _string = "";
				if(count _args == 1) then {
					_string = "private _modulePos = _this select 0;";
				};
				if(count _args == 2) then {
					_string = "private _entity = _this select 0; private _modulePos = _this select 1;";
				};
				private _codeSource = _string + (_values select 0);
				private _code = compile _codeSource;
				
				_args call _code;
			},{
				params ["_values","_args","_display"];
				if((_values select 0) == "") then {
					profileNamespace setVariable ['MAZ_EZM_mostRecentCode',""];
				};
				_display closeDisplay 2;
			},_params] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_openAnimViewerModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {
				[] call BIS_fnc_animViewer;
			};
			if(_entity isKindOf "CAManBase" && alive _entity) exitWith {
				[[typeOf _entity, animationState _entity]] call BIS_fnc_animViewer;
			};
			[] call BIS_fnc_animViewer;
		};

		MAZ_EZM_fnc_openGUIEditor = {
			[] spawn {
				(findDisplay 312) closeDisplay 0;
				sleep 0.5;
				call BIS_fnc_GUIeditor;
			};
		};

		MAZ_EZM_fnc_getCompositionData = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			private _helipadCenter = createVehicle ["Land_HelipadEmpty_F",_pos,[],0,"CAN_COLLIDE"];
			_helipadCenter setPosATL [(getPosATL _helipadCenter) select 0,(getPosATL _helipadCenter) select 1,0];

			private _returnData = [];
			{
				if(typeOf _x in ["ModuleEmpty_F","ModuleCurator_F","Land_HelipadEmpty_F","CamCurator"] || "soldier" in tolower (typeOf _x) || typeOf _x isKindOf "Animal") then {} else {
					private _objectType = typeOf _x;
					systemChat (str (boundingBox _x));
					(boundingBox _x) params ["_min","_max",""];
					private _bottomCenterPosition = (abs (_min select 2) + abs (_max select 2)) / 2;
					private _worldPos = _x modelToWorld [0,0,_bottomCenterPosition * -1];
					private _relPosition = _helipadCenter worldToModel _worldPos;
					private _vectorDirAndUp = [vectorDir _x,vectorUp _x];
					private _isSimpleObject = isSimpleObject _x;
					if(_isSimpleObject) then {
						_objectType = (getModelInfo _x) select 1;
					};
					_returnData pushBack [_objectType,_relPosition,_vectorDirAndUp,_isSimpleObject];
				};
			}forEach (_helipadCenter nearObjects 15);
			deleteVehicle _helipadCenter;

			copyToClipboard (str _returnData);
			MAZ_EZM_LASTCOMPDATA = _returnData;
			_returnData
		};

		MAZ_EZM_fnc_createCompositionFromData = {
			params ["_compData"];
			_compData = MAZ_EZM_LASTCOMPDATA;
			private _didComplete = true;
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			private _helipadCenter = createVehicle ["Land_HelipadEmpty_F",_pos,[],0,"CAN_COLLIDE"];
			{
				_x params ["_objType","_relPos","_vectors","_isSimple"];
				private _object = objNull;
				if(_isSimple) then {
					_object = createSimpleObject [_objType, _pos];
				} else {
					_object = createVehicle [_objType, _pos, [], 0, "CAN_COLLIDE"];
				};
				if(isNull _object) exitWith {_didComplete = false};

				_object attachTo [_helipadCenter,_relPos];
				_object setVectorDirAndUp _vectors;
			}forEach _compData;

			_didComplete
		};

	comment "Environment";

		MAZ_EZM_fnc_changeDateModule = {
			date params ["_year", "_month", "_day", "_hours", "_minutes"];
			["Change Date",[
				[
					"SLIDER",
					"Hour",
					[0,24,_hours]
				],
				[
					"SLIDER",
					"Minute",
					[0,60,_minutes]
				]
			],{
				params ["_values","_pos","_display"];
				[_values,{
					params ["_hr","_min"];
					date params ["_year", "_month", "_day", "_hours", "_minutes"];
					setDate [_year,_month,_day,_hr,_min];
				}] remoteExec ['spawn',2];

				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_editWeatherConditionsModule = {
			fogParams params ["_fogValue","_fogDecay","_fogBase"];
			["Edit Weather Conditions",[
				[
					"SLIDER",
					["Time for Effect","The time it takes for the changes to take effect, in in-game minutes."],
					[0,60,0]
				],
				[
					"SLIDER",
					["Cloud Cover","Amount of cloud cover, in percent."],
					[0,100,round (overcast * 100)]
				],
				[
					"SLIDER",
					["Fog","Amount of fog in percent."],
					[0,100,round (_fogValue * 100)]
				],
				[
					"SLIDER",
					["Fog Decay","How fast the fog decays as it moves upwards in the atmosphere, a percentage."],
					[0,10,round (_fogDecay * 100)]
				],
				[
					"SLIDER",
					["Fog Base","The base of the fog, in meters."],
					[-1000,1000,_fogBase]
				],
				[
					"SLIDER",
					["Rain Chance","The chance for it to rain, in percent.\nIn clear skies it will not rain."],
					[0,100,round (rain * 100)]
				],
				[
					"SLIDER",
					["Waves Strength","Strengths of the ocean waves, in percent."],
					[0,100,round (waves * 100)]
				],
				[
					"SLIDER",
					["Wind Strength","Strength of the wind, in percent."],
					[0,100,round (windStr * 100)]
				],
				[
					"SLIDER",
					["Gusts Strength","Strength of the wind gusts, in percent."],
					[0,100,round (gusts * 100)]
				],
				[
					"SLIDER",
					["Wind Direction","Direction of the wind and gusts, in degrees."],
					[0,360,round windDir]
				]
			],{
				params ["_values","_pos","_display"];
				_display closeDisplay 1;
				[_values,{
					params ["_time","_overcast","_fog","_fogDecay","_fogBase","_rain","_waves","_windStr","_gustStr","_windDir"];
					_time setOverCast (_overcast/100);
					_time setFog [(_fog/100),(_fogDecay/100),_fogBase];
					_time setRain (_rain/100);
					_time setWaves (_waves/100);
					_time setWindStr (_windStr/100);
					_time setGusts (_gustStr/100);
					_time setWindDir _windDir;
					if(_time == 0) then {
						forceWeatherChange;
					};
				}] remoteExec ['spawn',2];

			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

	comment "Explosives";

		MAZ_EZM_fnc_createMinefieldModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			["Create Minefield",[
				[
					"COMBO",
					"Mine Type",
					[
						["APERSMine","APERSBoundingMine","ATMine"],
						["APERS Mine","APERS Bounding Mine","AT Mine"],
						0
					]
				],
				[
					"SLIDER:RADIUS",
					"Mines Radius",
					[10,50,25,_pos,[1,0,0,1]]
				],
				[
					"SLIDER",
					"Mines Amount",
					[5,35,15]
				]
			],{
				params ["_values","_pos","_display"];
				_values params ["_mineType","_radius","_amount"];
				private _mines = [];
				for "_i" from 1 to _amount do {
					private _randomPos = [
						[[_pos,_radius]],
						[]
					] call BIS_fnc_randomPos;

					private _mine = createMine [_mineType,_randomPos,[],0];
					_mines pushBack _mine;
				};
				[_mines] call MAZ_EZM_fnc_addObjectToInterface;

				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_pos] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_createIEDModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			["Create IED",[
				[
					"COMBO",
					"IED Disguise Type",
					[
						[],
						["Cardboard Box","Suitcases","Trash Can","Barrels","Vehicle Wrecks"],
						0
					]
				],
				[
					"SLIDER:RADIUS",
					"IED Explosive Radius",
					[3,15,7,_pos,[1,0,0,1]]
				],
				[
					"SIDES",
					["Sides That Trigger","Sides that when entering the radius the IED will detonate."],
					[west,east,independent]
				]
			],{
				params ["_values","_pos","_display"];
				_values params ["_iedType","_radius","_side"];
				private _sides = _side call MAZ_EZM_fnc_getSidesFromString;
				private _trashCanTypes = ["Land_GarbageBin_01_F","TrashBagHolder_01_F"];
				private _cardboardBox = ["Land_PaperBox_01_small_destroyed_brown_F"];
				private _luggageTypes = ["Land_LuggageHeap_01_F","Land_LuggageHeap_03_F"];
				private _barrelTypes = ["Land_MetalBarrel_empty_F","Land_BarrelEmpty_grey_F","Land_BarrelEmpty_F"];
				private _vehicleWreckTypes = ["Land_Wreck_Skodovka_F","Land_Wreck_CarDismantled_F","Land_Wreck_Truck_F","Land_Wreck_Van_F","Land_Wreck_Offroad_F","Land_Wreck_Truck_dropSide_F","Land_Wreck_Offroad2_F","Land_Wreck_Car3_F","Land_Wreck_Car_F","Land_Wreck_Car2_F"];

				_iedType = switch (_iedType) do {
					case 0: {selectRandom _cardboardBox};
					case 1: {selectRandom _luggageTypes};
					case 2: {selectRandom _trashCanTypes};
					case 3: {selectRandom _barrelTypes};
					case 4: {selectRandom _vehicleWreckTypes};
				};

				private _iedObject = createVehicle [_iedType,_pos,[],0,"CAN_COLLIDE"];
				[_iedObject] call MAZ_EZM_fnc_addObjectToInterface;
				["IED created.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
				[_iedObject,_radius,_sides] spawn {
					params ["_obj","_radius","_sides"];
					waitUntil {
						(
							(count (nearestObjects [_obj,["CAManBase"],_radius])) > 0
						) &&
						(
							((nearestObjects [_obj,["CAManBase"],_radius]) findIf {alive _x}) != -1
						) &&
						(
							((nearestObjects [_obj,["CAManBase"],_radius]) findIf {side (group _x) in _sides}) != -1
						)
					};
					private _ied = createMine ["IEDLandBig_F", position _obj,[],0];
					deleteVehicle _obj;
					_ied setDamage 1;
				};

				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_pos] call MAZ_EZM_fnc_createDialog;
		};

	comment "Gameplay";

		MAZ_EZM_fnc_createCountdownModule = {
			["Create Countdown",[
				[
					"SLIDER",
					"Hours:",
					[0,3,0]
				],
				[
					"SLIDER",
					"Minutes:",
					[0,60,15]
				],
				[
					"SIDES",
					"Sides Who See The Message",
					[west,east,independent,civilian]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_hours","_minutes","_side"];
				private _sides = _side call MAZ_EZM_fnc_getSidesFromString;
				_sides = _sides + [sideLogic];
				_hours = round _hours; _minutes = round _minutes;
				private _timer = (_hours * 3600) + (_minutes * 60);
				[[[_hours,_minutes],_timer],{
					params ["_timeData","_timer"];
					_timeData params ["_hours","_minutes"];
					if(!(player getVariable ["MAZ_EZM_timerActive",false])) then {
						private _timerInt = 0;
						player setVariable ["MAZ_EZM_timerActive",true,true];
						while {_timer > 0} do {
							if(_timerInt == 60) then {
								_minutes = _minutes - 1;
							};
							if(_minutes == 0 && _hours != 0) then {_hours = _hours - 1; _minutes = 59;};
							if(_hours > 0) then {
								[format ["<t color='#FFFFFF' size='1.25'>%1 hrs, %2 min left.</t>",_hours,_minutes],-1,-0.3,1,0,0] spawn BIS_fnc_dynamicText;
							} else {
								if(_minutes > 1) then {
									[format ["<t color='#FFFFFF' size='1.25'>%1 minutes left.</t>",_minutes],-1,-0.3,1,0,0] spawn BIS_fnc_dynamicText;
								} else {
									[format ["<t color='#FFFFFF' size='1.25'>%1 seconds left!</t>",_timer],-1,-0.3,1,0,0] spawn BIS_fnc_dynamicText;
								};
							};
							_timerInt = _timerInt + 1;
							_timer = _timer - 1;
							sleep 1;
						};
						player setVariable ["MAZ_EZM_timerActive",false,true];
					};
				}]remoteExec ['spawn',_sides];
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

	comment "Send Messages";

		MAZ_EZM_fnc_checkForBlacklistedWords = {
			params ["_message"];
			private _isFound = false;
			private _return = _message;
			private _badWords = [
				["s","h","i","t"] joinString "",
				["n","i","g","g","e"] joinString "",
				["n","i","g","g","a"] joinString "",
				["n","i","g","g","e","r"] joinString "",
				["n","i","g","g"] joinString "",
				["f","u","c","k"] joinString "",
				["c","u","n","t"] joinString "",
				["f","a","g"] joinString "",
				["g","a","y"] joinString "",
				["z","a","m"] joinString ""
			];

			{
				if(((toLower _return) find _x) != -1) then {
					_isFound = true;
					private _length = count _x;
					private _index = (toLower _return) find _x;
					_return = _return splitString "";
					for "_i" from _index to (_index + _length - 1) do {
						_return set [_i,"*"];
					};
					_return = _return joinString "";
				};
			}forEach _badWords;
			if(_isFound) then {
				_return = [_return] call MAZ_EZM_fnc_checkForBlacklistedWords;
			};
			_return
		};

		MAZ_EZM_fnc_sendMessageModule = {
			["Send Server Message",[
				[
					"EDIT",
					"Sender Name",
					[missionNamespace getVariable ["EZM_senderName","High Command"]]
				],
				[
					"EDIT:MULTI",
					"Message",
					["Message..."]
				],
				[
					"SIDES",
					"Sides Who See The Message",
					[west,east,independent,civilian]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_sender","_message","_side"];
				private _sides = _side call MAZ_EZM_fnc_getSidesFromString;
				_sides = _sides + [sideLogic];
				private _targets = [];
				{
					if(side (group _x) in _sides) then {
						_targets pushBack _x;
					};
				}forEach allPlayers;
				if(count _message > 300) exitWith {
					["Message too long! Cannot send, max characters is 300.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;
				};
				_message = [_message] call MAZ_EZM_fnc_checkForBlacklistedWords;
				[
					[
						format ["<t color='#2596be' size='2'>%1:</t><br/><t color='#FFF' size='1.75'>%2</t>",_sender,_message],
						"PLAIN DOWN",
						2,
						true,
						true
					]
				] remoteExec ['titleText',_targets];
				missionNamespace setVariable ["EZM_senderName",_sender];
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_sendSubtitleModule = {
			["Send Subtitle Message",[
				[
					"EDIT",
					"Sender Name",
					[missionNamespace getVariable ["EZM_senderName","High Command"]]
				],
				[
					"EDIT:MULTI",
					"Message",
					["Message..."]
				],
				[
					"SIDES",
					"Sides Who See The Message",
					[west,east,independent,civilian]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_sender","_message","_side"];
				private _sides = _side call MAZ_EZM_fnc_getSidesFromString;
				_sides = _sides + [sideLogic];
				private _targets = [];
				{
					if(side (group _x) in _sides) then {
						_targets pushBack _x;
					};
				}forEach allPlayers;
				if(count _message > 300) exitWith {
					["Message too long! Cannot send, max characters is 300.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;
				};
				_message = [_message] call MAZ_EZM_fnc_checkForBlacklistedWords;
				[
					_sender,
					_message
				] remoteExec ['BIS_fnc_showSubtitle',_targets];
				missionNamespace setVariable ["EZM_senderName",_sender];
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

	comment "Object Modifiers";

		MAZ_EZM_fnc_attachToNearestModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {["No object selected.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			private _nearestObjects = nearestObjects [_entity,["AllVehicles"],50];
			_nearestObjects = (_nearestObjects - [_entity]);
			_nearestObject = _nearestObjects select 0;
			if(isNil "_nearestObject") exitWith {["No near objects.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[_entity,_nearestObject] call BIS_fnc_attachToRelative;
			["Object attached.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_detachModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {["No object selected.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			{detach _x;} foreach attachedObjects _entity;
			{detach _x;} foreach attachedObjects attachedTo _entity;

			["Object detached.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_editObjectAttributesModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {["Place the module onto an object!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			if(isNil "MAZ_EZM_editObjAtribsMenu") then {
				MAZ_EZM_editObjAtribsMenu = {
					params ["_editObj"];
					editObj = _editObj;
					with uiNamespace do {
						createDialog "RscDisplayEmpty";
						showchat true;
						objEditDisplay = findDisplay -1;
						private _editObj = missionNamespace getVariable 'editObj';
						private _objTextures = getObjectTextures _editObj;
						private _objLocked = locked _editObj;
						private _objGod = _editObj getVariable ['objEditGM',false];
						private _objHide = _editObj getVariable ['objEditHide',false];
						private _objSim = _editObj getVariable ['objEditSim',true];

						if(getText (configfile >> "CfgVehicles" >> (typeOf (missionNamespace getVariable 'editObj')) >> "displayname") == "Ground") exitWith {
							["Invalid object selected, try again.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;
							with uiNamespace do {objEditDisplay closeDisplay 0;};
						};
						comment "Labels";

							editObjectAtribsLabel = objEditDisplay ctrlCreate ["RscStructuredText", 1100];
							editObjectAtribsLabel ctrlSetStructuredText parseText format ["Edit Object Attributes<t align='right'>(%1)</t>",getText (configfile >> "CfgVehicles" >> (typeOf (missionNamespace getVariable 'editObj')) >> "displayname")];
							editObjectAtribsLabel ctrlSetPosition [0.31953 * safezoneW + safezoneX, 0.319 * safezoneH + safezoneY, 0.360937 * safezoneW, 0.022 * safezoneH];
							editObjectAtribsLabel ctrlSetTextColor [1,1,1,1];
							editObjectAtribsLabel ctrlSetBackgroundColor [0.1,0.5,0,1];
							editObjectAtribsLabel ctrlCommit 0;

							editObjAtribsBG = objEditDisplay ctrlCreate ["RscPicture", 1200];
							editObjAtribsBG ctrlSetText "#(argb,8,8,3)color(0,0,0,0.6)";
							editObjAtribsBG ctrlSetPosition [0.319529 * safezoneW + safezoneX, 0.346 * safezoneH + safezoneY, 0.360937 * safezoneW, 0.33 * safezoneH];
							editObjAtribsBG ctrlCommit 0;

							editObjAtribsFrame = objEditDisplay ctrlCreate ["RscFrame", 1800];
							editObjAtribsFrame ctrlSetPosition [0.319531 * safezoneW + safezoneX, 0.346 * safezoneH + safezoneY, 0.360937 * safezoneW, 0.33 * safezoneH];
							editObjAtribsFrame ctrlCommit 0;

							editObjAtribsText1Label = objEditDisplay ctrlCreate ["RscStructuredText", 1101];
							editObjAtribsText1Label ctrlSetStructuredText parseText "Texture #0";
							editObjAtribsText1Label ctrlSetPosition [0.324687 * safezoneW + safezoneX, 0.357 * safezoneH + safezoneY, 0.103125 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText1Label ctrlSetTextColor [1,1,1,1];
							editObjAtribsText1Label ctrlSetBackgroundColor [0,0,0,0];
							editObjAtribsText1Label ctrlCommit 0;

							editObjAtribsText2Label = objEditDisplay ctrlCreate ["RscStructuredText", 1102];
							editObjAtribsText2Label ctrlSetStructuredText parseText "Texture #1";
							editObjAtribsText2Label ctrlSetPosition [0.324687 * safezoneW + safezoneX, 0.401 * safezoneH + safezoneY, 0.103125 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText2Label ctrlSetTextColor [1,1,1,1];
							editObjAtribsText2Label ctrlSetBackgroundColor [0,0,0,0];
							editObjAtribsText2Label ctrlCommit 0;

							editObjAtribsText3Label = objEditDisplay ctrlCreate ["RscStructuredText", 1103];
							editObjAtribsText3Label ctrlSetStructuredText parseText "Texture #2";
							editObjAtribsText3Label ctrlSetPosition [0.324687 * safezoneW + safezoneX, 0.445 * safezoneH + safezoneY, 0.103125 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText3Label ctrlSetTextColor [1,1,1,1];
							editObjAtribsText3Label ctrlSetBackgroundColor [0,0,0,0];
							editObjAtribsText3Label ctrlCommit 0;

							editObjAtribsText4Label = objEditDisplay ctrlCreate ["RscStructuredText", 1104];
							editObjAtribsText4Label ctrlSetStructuredText parseText "Texture #3";
							editObjAtribsText4Label ctrlSetPosition [0.324687 * safezoneW + safezoneX, 0.489 * safezoneH + safezoneY, 0.103125 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText4Label ctrlSetTextColor [1,1,1,1];
							editObjAtribsText4Label ctrlSetBackgroundColor [0,0,0,0];
							editObjAtribsText4Label ctrlCommit 0;

							editObjAtribsText5Label = objEditDisplay ctrlCreate ["RscStructuredText", 1105];
							editObjAtribsText5Label ctrlSetStructuredText parseText "Texture #4";
							editObjAtribsText5Label ctrlSetPosition [0.324687 * safezoneW + safezoneX, 0.533 * safezoneH + safezoneY, 0.103125 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText5Label ctrlSetTextColor [1,1,1,1];
							editObjAtribsText5Label ctrlSetBackgroundColor [0,0,0,0];
							editObjAtribsText5Label ctrlCommit 0;

							editObjAtribsTextFrame = objEditDisplay ctrlCreate ["RscFrame", 1801];
							editObjAtribsTextFrame ctrlSetPosition [0.324687 * safezoneW + safezoneX, 0.357 * safezoneH + safezoneY, 0.139219 * safezoneW, 0.231 * safezoneH];
							editObjAtribsTextFrame ctrlCommit 0;

							editObjAtribsInitFrame = objEditDisplay ctrlCreate ["RscFrame", 1802];
							editObjAtribsInitFrame ctrlSetPosition [0.469062 * safezoneW + safezoneX, 0.357 * safezoneH + safezoneY, 0.20625 * safezoneW, 0.231 * safezoneH];
							editObjAtribsInitFrame ctrlCommit 0;

							editObjAtribsInitLabel = objEditDisplay ctrlCreate ["RscStructuredText", 1106];
							editObjAtribsInitLabel ctrlSetStructuredText parseText "Object Init:";
							editObjAtribsInitLabel ctrlSetPosition [0.474219 * safezoneW + safezoneX, 0.357 * safezoneH + safezoneY, 0.103125 * safezoneW, 0.022 * safezoneH];
							editObjAtribsInitLabel ctrlSetTextColor [1,1,1,1];
							editObjAtribsInitLabel ctrlSetBackgroundColor [0,0,0,0];
							editObjAtribsInitLabel ctrlCommit 0;

							editObjAtribsModiBtnFrame = objEditDisplay ctrlCreate ["RscFrame", 1803];
							editObjAtribsModiBtnFrame ctrlSetPosition [0.324687 * safezoneW + safezoneX, 0.599 * safezoneH + safezoneY, 0.190781 * safezoneW, 0.066 * safezoneH];
							editObjAtribsModiBtnFrame ctrlCommit 0;

							editObjAtribsLockFrame = objEditDisplay ctrlCreate ["RscFrame", 1804];
							editObjAtribsLockFrame ctrlSetPosition [0.520625 * safezoneW + safezoneX,0.599 * safezoneH + safezoneY,0.0979687 * safezoneW,0.066 * safezoneH];
							editObjAtribsLockFrame ctrlCommit 0;

							editObjAtribsLockLabel = objEditDisplay ctrlCreate ["RscStructuredText", 1107];
							editObjAtribsLockLabel ctrlSetStructuredText parseText "Lock:";
							editObjAtribsLockLabel ctrlSetPosition [0.520625 * safezoneW + safezoneX,0.599 * safezoneH + safezoneY,0.0876563 * safezoneW,0.033 * safezoneH];
							editObjAtribsLockLabel ctrlSetTextColor [1,1,1,1];
							editObjAtribsLockLabel ctrlSetBackgroundColor [0,0,0,0];
							editObjAtribsLockLabel ctrlCommit 0;

							editObjAtribsApplyFrame = objEditDisplay ctrlCreate ["RscFrame", 1805];
							editObjAtribsApplyFrame ctrlSetPosition [0.62375 * safezoneW + safezoneX,0.599 * safezoneH + safezoneY,0.0515625 * safezoneW,0.066 * safezoneH];
							editObjAtribsApplyFrame ctrlCommit 0;

						comment "Edit Texture Edit";

							editObjAtribsText1Edit = objEditDisplay ctrlCreate ["RscEdit", 1400];
							editObjAtribsText1Edit ctrlSetPosition [0.329844 * safezoneW + safezoneX, 0.379 * safezoneH + safezoneY, 0.128906 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText1Edit ctrlSetBackgroundColor [0,0,0,0.5];
							if(count _objTextures >= 1) then {
								editObjAtribsText1Edit ctrlSetText (_objTextures select 0);
							};
							editObjAtribsText1Edit ctrlSetTooltip "Changes the texture of designated index.";
							editObjAtribsText1Edit ctrlCommit 0;

							editObjAtribsText2Edit = objEditDisplay ctrlCreate ["RscEdit", 1401];
							editObjAtribsText2Edit ctrlSetPosition [0.329844 * safezoneW + safezoneX, 0.423 * safezoneH + safezoneY, 0.128906 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText2Edit ctrlSetBackgroundColor [0,0,0,0.5];
							if(count _objTextures >= 2) then {
								editObjAtribsText2Edit ctrlSetText (_objTextures select 1);
							};
							editObjAtribsText2Edit ctrlSetTooltip "Changes the texture of designated index.";
							editObjAtribsText2Edit ctrlCommit 0;

							editObjAtribsText3Edit = objEditDisplay ctrlCreate ["RscEdit", 1402];
							editObjAtribsText3Edit ctrlSetPosition [0.329844 * safezoneW + safezoneX, 0.467 * safezoneH + safezoneY, 0.128906 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText3Edit ctrlSetBackgroundColor [0,0,0,0.5];
							if(count _objTextures >= 3) then {
								editObjAtribsText3Edit ctrlSetText (_objTextures select 2);
							};
							editObjAtribsText3Edit ctrlSetTooltip "Changes the texture of designated index.";
							editObjAtribsText3Edit ctrlCommit 0;

							editObjAtribsText4Edit = objEditDisplay ctrlCreate ["RscEdit", 1403];
							editObjAtribsText4Edit ctrlSetPosition [0.329844 * safezoneW + safezoneX, 0.511 * safezoneH + safezoneY, 0.128906 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText4Edit ctrlSetBackgroundColor [0,0,0,0.5];
							if(count _objTextures >= 4) then {
								editObjAtribsText4Edit ctrlSetText (_objTextures select 3);
							};
							editObjAtribsText4Edit ctrlSetTooltip "Changes the texture of designated index.";
							editObjAtribsText4Edit ctrlCommit 0;

							editObjAtribsText5Edit = objEditDisplay ctrlCreate ["RscEdit", 1404];
							editObjAtribsText5Edit ctrlSetPosition [0.329844 * safezoneW + safezoneX, 0.555 * safezoneH + safezoneY, 0.128906 * safezoneW, 0.022 * safezoneH];
							editObjAtribsText5Edit ctrlSetBackgroundColor [0,0,0,0.5];
							if(count _objTextures >= 5) then {
								editObjAtribsText5Edit ctrlSetText (_objTextures select 4);
							};
							editObjAtribsText5Edit ctrlSetTooltip "Changes the texture of designated index.";
							editObjAtribsText5Edit ctrlCommit 0;

							if(count _objTextures >= 6) then {
								["There are more textures on this object than shown.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;
							};

						comment "Init Field";

							editObjAtribsInitEdit = objEditDisplay ctrlCreate ["RscEditMulti", 1405];
							editObjAtribsInitEdit ctrlSetPosition [0.474219 * safezoneW + safezoneX, 0.379 * safezoneH + safezoneY, 0.195937 * safezoneW, 0.198 * safezoneH];
							editObjAtribsInitEdit ctrlSetBackgroundColor [0,0,0,0.5];
							editObjAtribsInitEdit ctrlSetTooltip "Edit the init of this object. '_this' refers to the local object.\n**Running code can get you kicked from the server if you are inexperienced, use at your own risk.**";
							editObjAtribsInitEdit ctrlCommit 0;

						comment "Modifiers Buttons";

							editObjAtribsGMBtn = objEditDisplay ctrlCreate ["RscButtonMenu", 2400];
							editObjAtribsGMBtn ctrlSetStructuredText parseText "<t align='center'>God Mode</t>";
							editObjAtribsGMBtn ctrlSetPosition [0.329844 * safezoneW + safezoneX, 0.61 * safezoneH + safezoneY, 0.0464063 * safezoneW, 0.044 * safezoneH];
							if(_objGod) then {
								editObjAtribsGMBtn ctrlSetTextColor [0.1,0.5,0,1];
							} else {
								editObjAtribsGMBtn ctrlSetTextColor [1,1,1,1];
							};
							editObjAtribsGMBtn ctrlSetBackgroundColor [0,0,0,0.6];
							editObjAtribsGMBtn ctrlAddEventHandler ["ButtonClick",{
								private _objGod = editObj getVariable ['objEditGM',false];
								if(_objGod) then {
									with uiNamespace do {
										editObjAtribsGMBtn ctrlSetTextColor [1,1,1,1];
										editObjAtribsGMBtn ctrlCommit 0;
									};
									editObj setVariable ['objEditGM',false];
								} else {
									with uiNamespace do {
										editObjAtribsGMBtn ctrlSetTextColor [0.1,0.5,0,1];
										editObjAtribsGMBtn ctrlCommit 0;
									};
									editObj setVariable ['objEditGM',true];
								};
							}];
							editObjAtribsGMBtn ctrlSetTooltip "Sets the object to god mode (Cannot be destroyed).";
							editObjAtribsGMBtn ctrlCommit 0;

							editObjAtribsHideBtn = objEditDisplay ctrlCreate ["RscButtonMenu", 2401];
							editObjAtribsHideBtn ctrlSetStructuredText parseText "<t align='center'>Hide Object</t>";
							editObjAtribsHideBtn ctrlSetPosition [0.396875 * safezoneW + safezoneX, 0.61 * safezoneH + safezoneY, 0.0464063 * safezoneW, 0.044 * safezoneH];
							if(_objHide) then {
								editObjAtribsHideBtn ctrlSetTextColor [0.1,0.5,0,1];
							} else {
								editObjAtribsHideBtn ctrlSetTextColor [1,1,1,1];
							};
							editObjAtribsHideBtn ctrlSetBackgroundColor [0,0,0,0.6];
							editObjAtribsHideBtn ctrlAddEventHandler ["ButtonClick",{
								private _objHide = editObj getVariable ['objEditHide',false];
								if(_objHide) then {
									with uiNamespace do {
										editObjAtribsHideBtn ctrlSetTextColor [1,1,1,1];
										editObjAtribsHideBtn ctrlCommit 0;
									};
									editObj setVariable ['objEditHide',false];
								} else {
									with uiNamespace do {
										editObjAtribsHideBtn ctrlSetTextColor [0.1,0.5,0,1];
										editObjAtribsHideBtn ctrlCommit 0;
									};
									editObj setVariable ['objEditHide',true];
								};
							}];
							editObjAtribsHideBtn ctrlSetTooltip "Sets the object to hidden (Invisible).";
							editObjAtribsHideBtn ctrlCommit 0;

							editObjAtribsSimBtn = objEditDisplay ctrlCreate ["RscButtonMenu", 2402];
							editObjAtribsSimBtn ctrlSetStructuredText parseText "<t align='center'>Enable Sim</t>";
							editObjAtribsSimBtn ctrlSetPosition [0.463906 * safezoneW + safezoneX, 0.61 * safezoneH + safezoneY, 0.0464063 * safezoneW, 0.044 * safezoneH];
							if(_objSim) then {
								editObjAtribsSimBtn ctrlSetTextColor [0.1,0.5,0,1];
							} else {
								editObjAtribsSimBtn ctrlSetTextColor [1,1,1,1];
							};
							editObjAtribsSimBtn ctrlSetBackgroundColor [0,0,0,0.6];
							editObjAtribsSimBtn ctrlAddEventHandler ["ButtonClick",{
								private _objSim = editObj getVariable ['objEditSim',true];
								if(_objSim) then {
									with uiNamespace do {
										editObjAtribsSimBtn ctrlSetTextColor [1,1,1,1];
										editObjAtribsSimBtn ctrlCommit 0;
									};
									editObj setVariable ['objEditSim',false];
								} else {
									with uiNamespace do {
										editObjAtribsSimBtn ctrlSetTextColor [0.1,0.5,0,1];
										editObjAtribsSimBtn ctrlCommit 0;
									};
									editObj setVariable ['objEditSim',true];
								};
							}];
							editObjAtribsSimBtn ctrlSetTooltip "Sets the object simulation (Does it have physics and interaction).";
							editObjAtribsSimBtn ctrlCommit 0;

							editObjAtribsLockCombo = objEditDisplay ctrlCreate ["RscCombo", 2100];
							editObjAtribsLockCombo ctrlSetPosition [0.525781 * safezoneW + safezoneX,0.621 * safezoneH + safezoneY,0.0825 * safezoneW,0.022 * safezoneH];
							editObjAtribsLockCombo ctrlSetTooltip "Makes the object locked or unlocked.";
							editObjAtribsLockCombo ctrlCommit 0;

							editObjAtribsLockCombo lbAdd "Unlocked";
							editObjAtribsLockCombo lbAdd "Default";
							editObjAtribsLockCombo lbAdd "Locked";
							editObjAtribsLockCombo lbAdd "Locked to Players";

							if(_editObj isKindOf "Building") then {
								private _buildingLock = _editObj getVariable "bis_disabled_Door_1";
								if(_buildingLock == 1) then {
									editObjAtribsLockCombo lbSetCurSel 2;
								} else {
									editObjAtribsLockCombo lbSetCurSel 0;
								};
							} else {
								editObjAtribsLockCombo lbSetCurSel _objLocked;
							};

						comment "Apply";

							editObjAtribsApplyBtn = objEditDisplay ctrlCreate ["RscButtonMenu", 2403];
							editObjAtribsApplyBtn ctrlSetStructuredText parseText "<t size='0.2'>&#160;</t><br/><t align='center' size='1.25'>Apply</t>";
							editObjAtribsApplyBtn ctrlSetPosition [0.628906 * safezoneW + safezoneX,0.61 * safezoneH + safezoneY,0.04125 * safezoneW,0.044 * safezoneH];
							editObjAtribsApplyBtn ctrlSetTextColor [1,1,1,1];
							editObjAtribsApplyBtn ctrlSetBackgroundColor [0.1,0.5,0,1];
							editObjAtribsApplyBtn ctrlAddEventHandler ["ButtonClick",{
								[editObj] spawn MAZ_EZM_editObjAtribsApply;
							}];
							editObjAtribsApplyBtn ctrlSetTooltip "Applies the settings set and runs the code provided.";
							editObjAtribsApplyBtn ctrlCommit 0;
					};
					["Object Attributes Menu opened.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
				};
			};
			if(isNil "MAZ_EZM_editObjAtribsApply") then {
				MAZ_EZM_editObjAtribsApply = {
					params ["_obj"];
					private _texture1 = ctrlText (uiNamespace getVariable 'editObjAtribsText1Edit');
					private _texture2 = ctrlText (uiNamespace getVariable 'editObjAtribsText2Edit');
					private _texture3 = ctrlText (uiNamespace getVariable 'editObjAtribsText3Edit');
					private _texture4 = ctrlText (uiNamespace getVariable 'editObjAtribsText4Edit');
					private _texture5 = ctrlText (uiNamespace getVariable 'editObjAtribsText5Edit');
					private _textures = [_texture1,_texture2,_texture3,_texture4,_texture5];
					private _objGod = _obj getVariable ['objEditGM',false];
					private _objHide = _obj getVariable ['objEditHide',false];
					private _objSim = _obj getVariable ['objEditSim',true];
					private _lockSetting = lbCurSel (uiNamespace getVariable 'editObjAtribsLockCombo');

					for "_i" from 0 to 4 do {
						[_obj,[_i,_textures select _i]] remoteExec ['setObjectTexture',0,_obj];
					};
					if(_objGod) then {
						_obj allowDamage false;
					} else {
						_obj allowDamage true;
					};
					if(_objHide) then {
						[_obj,true] remoteExec ['hideObject',0,_obj];
					} else {
						[_obj,false] remoteExec ['hideObject',0,_obj];
					};
					if(_objSim) then {
						[_obj,true] remoteExec ['enableSimulation',0,_obj];
					} else {
						[_obj,false] remoteExec ['enableSimulation',0,_obj];
					};
					[_obj,_lockSetting] remoteExec ['lock',0,_obj];
					if(_obj isKindOf "Building") then {
						if(_lockSetting in [2,3]) then {
							private _numberOfDoors = GetNumber(ConfigFile >> "CfgVehicles" >> (typeOf _obj) >> "numberOfDoors");
							if(_numberOfDoors <= 0) exitWith {};
							
							for "_i" from 1 to _numberOfDoors do
							{
								_obj setVariable [format["bis_disabled_Door_%1",_i], 1, true];
							};
						};
						if(_lockSetting in [0,1]) then {
							private _numberOfDoors = GetNumber(ConfigFile >> "CfgVehicles" >> (typeOf _obj) >> "numberOfDoors");
							if(_numberOfDoors <= 0) exitWith {};
							
							for "_i" from 1 to _numberOfDoors do
							{
								_obj setVariable [format["bis_disabled_Door_%1",_i], 0, true];
							};
						};
					};

					private _initField = ctrlText (uiNamespace getVariable 'editObjAtribsInitEdit');
					if(_initField != "") then {
						private _codeCompiled = compile _initField;
						_obj call _codeCompiled;
					};
					["Object attributes applied.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
					with uiNamespace do {objEditDisplay closeDisplay 0;};
				};
			};
			[_entity] call MAZ_EZM_editObjAtribsMenu;
		};

		MAZ_EZM_fnc_toggleSimulationModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {["No object selected.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			if(simulationEnabled _entity) then {
				[_entity,false] remoteExec ["enableSimulationGlobal",2];
				["Simulation disabled."] call MAZ_EZM_fnc_systemMessage;
			} else {
				[_entity,true] remoteExec ["enableSimulationGlobal",2];
				["Simulation enabled."] call MAZ_EZM_fnc_systemMessage;
			};
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_toggleInvincibleModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {["No object selected.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			if(isDamageAllowed _entity) then {
				[_entity,false] remoteExec ["allowDamage",0];
				["Object is god moded."] call MAZ_EZM_fnc_systemMessage;
			} else {
				[_entity,true] remoteExec ["allowDamage",0];
				["Object is no longer god moded."] call MAZ_EZM_fnc_systemMessage;
			};
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_hideObjectModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {["No object selected.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			[_entity,true] remoteExec ["hideObjectGlobal",2];
			if(isNil "MAZ_EZM_hiddenObjects") then {
				MAZ_EZM_hiddenObjects = [_entity];
			} else {
				MAZ_EZM_hiddenObjects pushBack _entity;
			};

			["Object is hidden.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_unHideObjectModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {["No object selected.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			[_entity,false] remoteExec ["hideObjectGlobal",2];
			MAZ_EZM_hiddenObjects = (MAZ_EZM_hiddenObjects - [_entity]);

			["Object is no longer hidden.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_unHideObjectAllModule = {
			params ["_entity"];
			if(isNil "MAZ_EZM_hiddenObjects") exitWith {};
			{
				[_x,false] remoteExec ['hideObjectGlobal',2];
			}forEach MAZ_EZM_hiddenObjects;
			MAZ_EZM_hiddenObjects = [];

			["All hidden objects are revealed.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_replaceWithSimpleObject = {
			params ["_object"];
			if(isPlayer _object  || (typeOf _object) isKindOf "CAManBase") exitWith {["Not an object!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			private _typeOf = typeOf _object;
			private _objPos = getPosASL _object;
			private _vectorDir = vectorDir _object;
			private _vectorUp = vectorUp _object;

			deleteVehicle _object;
			private _newSimpleObj = createSimpleObject [_typeOf,_objPos];
			_newSimpleObj setVectorDirAndUp [_vectorDir,_vectorUp];
			private _logic = createVehicle ["Land_HelipadEmpty_F",_objPos,[],0,"CAN_COLLIDE"];
			[_logic] call MAZ_EZM_fnc_addObjectToInterface;
			[_newSimpleObj,_logic] call BIS_fnc_attachToRelative;
			[_newSimpleObj,_logic] spawn {
				params ["_newSimpleObj","_logic"];
				[[_newSimpleObj,_logic],{
					params ["_newSimpleObj","_logic"];
					waitUntil {isNull _logic};
					deleteVehicle _newSimpleObj;
				}] remoteExec ["Spawn",_logic];
			};
			["Object replaced with simple object.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

	comment "Player Modifiers";

		MAZ_EZM_fnc_disarmModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			_entity remoteExec ['removeAllWeapons'];

			["Weapons have been removed from the unit.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_healAndReviveModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			if(isPlayer _entity) then {
				[[],{
					player setDamage 0;
					["#rev",1,player] call BIS_fnc_reviveOnState;
				}] remoteExec ['spawn',_entity];
			} else {
				_entity setDamage 0; 
			};

			["The unit has been healed, and revived if possible.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_changeSideModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {["Unit is not suitable.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			["Change Unit Side",[
				[
					"SIDES",
					"New Side",
					(side _entity)
				]
			],{
				params ["_values","_args","_display"];
				private _grp = (createGroup [(_values # 0),true]);

				if((typeOf _args) isKindOf "Man") then {
					private _count = {alive _x} count (units (group _args)); 
					if(_count > 1 && !isPlayer _args) then {
						private _leader = leader (group _args);
						(units (group _args)) joinSilent _grp;
						_grp selectLeader _leader;
						["Unit group side is changed."] call MAZ_EZM_fnc_systemMessage;
					} else {
						[_args] joinSilent _grp;
						["Unit side is changed."] call MAZ_EZM_fnc_systemMessage;
					};
				};
				if((typeOf _args) isKindOf "LandVehicle" || (typeOf _args) isKindOf "Air" || (typeOf _args) isKindOf "Ship") then {
					(crew _args) joinSilent _grp;
					["Vehicle crew side is changed."] call MAZ_EZM_fnc_systemMessage;
				};
				playSound 'addItemOk';
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_entity] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_forceEjectModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {["No object selected.","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			{
				moveOut _x;
			} foreach (crew _entity);

			["Units have been ejected from the vehicle.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_muteServerModule = {
			if(isNil "EZM_canMute") then {
				EZM_canMute = true;
			};
			if(!EZM_canMute) exitWith {["You can't mute again this quickly!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			private _curatorUnits = [];
			{
				_curatorUnits pushBack (getAssignedCuratorUnit _x);
			}forEach allCurators;

			[[],{
				0 enableChannel [true,false];
				1 enableChannel [true,false]; 
				2 enableChannel [true,false];
				3 enableChannel [true,false];
			}] remoteExec ['spawn',(allPlayers - _curatorUnits)];

			["All players have been muted. You won't be able to mute them again for another 5 minutes.","addItemOk"] call MAZ_EZM_fnc_systemMessage;

			[] spawn {
				EZM_canMute = false;
				sleep (60*5);
				EZM_canMute = true;
			};

			_curatorUnits spawn {
				sleep 60;
				[[],{
					0 enableChannel [true,true];
					1 enableChannel [true,true]; 
					2 enableChannel [true,true];
					3 enableChannel [true,true];
				}] remoteExec ['spawn',(allPlayers - _this)];
			};
		};

		MAZ_EZM_fnc_unmuteServerModule = {
			private _curatorUnits = [];
			{
				_curatorUnits pushBack (getAssignedCuratorUnit _x);
			}forEach allCurators;

			[[],{
				0 enableChannel [true,true];
				1 enableChannel [true,true]; 
				2 enableChannel [true,true];
				3 enableChannel [true,true];
			}] remoteExec ['spawn',(allPlayers - _curatorUnits)];

			["All players have been unmuted.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

	comment "Server Settings";

		MAZ_EZM_fnc_getFriendlyTo = { 
			params ["_side"]; 
			private _friendlySides = []; 
			{ 
				private _isFriendly = _side getFriend _x; 
				if(_isFriendly > 0.6) then { 
					comment "Friendly"; 
					_friendlySides pushBack _x; 
				} else { 
					comment "Hostile"; 
					
				}; 
			} forEach ([west,east,independent,civilian] - [_side]); 
			_friendlySides 
		}; 

		MAZ_EZM_fnc_getSidesFromString = {
			params [["_sides",[],[west,[]]]];
			if(_sides isEqualType west) then {_sides = [_sides];};
			private _newArray = [];
			{
				switch (str _x) do {
					case "WEST": {
						_newArray pushBack ([1] call BIS_fnc_sideType);
					};
					case "EAST": {
						_newArray pushBack ([0] call BIS_fnc_sideType);
					};
					case "GUER": {
						_newArray pushBack ([2] call BIS_fnc_sideType);
					};
					case "CIV": {
						_newArray pushBack ([3] call BIS_fnc_sideType);
					};
				};
			}forEach _sides;
			_newArray
		};

		MAZ_EZM_fnc_changeSideRelationsModule = {
			["Change Side Relations",[
				[
					"SIDES",
					"Sides BLUFOR are friendly to:",
					[west] call MAZ_EZM_fnc_getFriendlyTo
				],
				[
					"SIDES",
					"Sides OPFOR is friendly to:",
					[east] call MAZ_EZM_fnc_getFriendlyTo
				],
				[
					"SIDES",
					"Sides INDEPENDENT is friendly to:",
					[independent] call MAZ_EZM_fnc_getFriendlyTo
				],
				[
					"SIDES",
					"Sides CIVILIANS are friendly to:",
					[civilian] call MAZ_EZM_fnc_getFriendlyTo
				]
			],{
				params ["_values","_args","_display"];
				{
					private _sides = [_x] call MAZ_EZM_fnc_getSidesFromString;

					private _side = switch (_forEachIndex) do {
						case 0: {west};
						case 1: {east};
						case 2: {independent};
						case 3: {civilian};
					};

					{
						[[_side,_x],{
							params ["_sideChange","_sideFriendly"];
							_sideChange setFriend [_sideFriendly,1];
						}] remoteExec ['spawn',2];
					}forEach _sides;
					
					private _enemySides = ([west,east,independent,civilian] - [_side]) - _sides;

					{
						[[_side,_x],{
							params ["_sideChange","_sideFriendly"];
							_sideChange setFriend [_sideFriendly,0.5];
						}] remoteExec ['spawn',2];
					}forEach _enemySides;
				}forEach _values;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_setRespawnTimerModule = {
			["Set Respawn Timer",[
				[
					"SLIDER",
					"Timer",
					[1,15,15]
				]
			],{
				params ["_values","_args","_display"];
				private _timer = round (_values # 0);
				MAZ_EZM_respawnTimer = _timer + 5;
				publicVariable 'MAZ_EZM_respawnTimer';
				[[],{
					if(!isNil "MAZ_EZM_respawnTimerEH") then {
						player removeEventHandler ["Respawn",MAZ_EZM_respawnTimerEH];
					};
					setPlayerRespawnTime MAZ_EZM_respawnTimer;
					MAZ_EZM_respawnTimerEH = player addEventHandler ["Respawn",{
						[] spawn {
							sleep 3;
							setPlayerRespawnTime MAZ_EZM_respawnTimer;
						};
					}];
				}] remoteExec ['spawn',0,'MAZ_EZM_respawnTimer'];
				["Respawn timer applied.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_setViewDistance = {
			["Set View Distance",[
				[
					"SLIDER",
					"View Distance",
					[1600,8000,3000]
				],
				[
					"TOOLBOX",
					"Global or Local",
					[true,[["Local","Changes view distance for you only."],["Global","Changes view distance for everyone."]]]
				]
			],{
				params ["_values","_args","_display"];
				private _viewDistance = round (_values # 0);
				private _isGlobal = _values # 1;
				if(_viewDistance > 8000) then {_viewDistance = 8000};
				if(_isGlobal) then {
					MAZ_EZM_viewDistance = _viewDistance;
					_viewDistance remoteExec ['setViewDistance',0,'MAZ_newViewDistance'];
				} else {
					setViewDistance _viewDistance;
				};
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_noTeamKillersModule = {
			[[],{
				player addRating 10000000000;
			}] remoteExec ['spawn',allPlayers];
		};

		MAZ_EZM_fnc_disableMortarsModule = {
			MAZ_EZM_mortarTypes = ["I_Mortar_01_F","O_Mortar_01_F","I_E_Mortar_01_F","B_G_Mortar_01_F","I_G_Mortar_01_F","O_G_Mortar_01_F","B_Mortar_01_F","B_T_Mortar_01_F"];
			publicVariable 'MAZ_EZM_mortarTypes';

			if(isNil "MAZ_EZM_mortarsDisabled") then {
				MAZ_EZM_mortarsDisabled = false;
				publicVariable 'MAZ_EZM_mortarsDisabled';
			};

			if(MAZ_EZM_mortarsDisabled) then {
				[[],{
					if(!isNil "MAZ_EZM_disableMortarEH") then {
						player removeEventhandler ["GetInMan",MAZ_EZM_disableMortarEH];
					};
				}] remoteExec ['spawn',0,"MAZ_EZM_toggleMortars"];
				["Mortars have been re-enabled.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
				MAZ_EZM_mortarsDisabled = false;
				publicVariable 'MAZ_EZM_mortarsDisabled';
			} else {
				[[],{
					if(!isNil "MAZ_EZM_disableMortarEH") then {
						player removeEventhandler ["GetInMan",MAZ_EZM_disableMortarEH];
					};
					MAZ_EZM_disableMortarEH = player addEventHandler ["GetInMan",{
						params ["_unit", "_role", "_vehicle", "_turret"];
						if((typeOf _vehicle) in MAZ_EZM_mortarTypes) then {
							player action ["getOut", _vehicle];
							hint "Sorry! Mortars have been disabled by the Zeus!";
						};
					}];
				}] remoteExec ['spawn',0,"MAZ_EZM_toggleMortars"];
				["Mortars have been disabled.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
				MAZ_EZM_mortarsDisabled = true;
				publicVariable 'MAZ_EZM_mortarsDisabled';
			};
		};
		

		JAM_EZM_fnc_moduleGameplaySettings = {
			[
				"Gameplay Settings",
				[
					[
						"TOOLBOX:YESNO",
						["Self-Revive:","When a player becomes incapacitated, he, she, or they, will have the option to heal their own injuries, provided the wounds are not too severe and there are no enemies in sight."],
						[(missionNamespace getVariable ['ZEUS_param_selfRevive', true])]
					]
				],
				{
					comment "OK BUTTON CODE";
					params ["_values","_args","_display"];
					_values params ["_settingSelfRevive"];
					_display closeDisplay 2;
					_messages = [];
					if ((missionNamespace getVariable ['ZEUS_param_selfRevive', true]) != _settingSelfRevive) then 
					{
						ZEUS_param_selfRevive = _settingSelfRevive;
						publicVariable 'ZEUS_param_selfRevive';
						_messageAddon = if (_settingSelfRevive) then {"enabled"} else {"disabled"};
						_message = format ["[ Enhanced Zeus Modules ] :  Self-Revive %1.", _messageAddon];
						_messages pushback _message;
					};
					{
						_x remoteExec ['systemChat'];
					} forEach _messages;
					showChat true;
					playSound 'addItemOk';
				},
				{
					comment "CANCEL BUTTON CODE (+DisplayClosed)";
					params ["_values","_args","_display"];
					comment "
					private _result = ['Are you sure you want to discard these changes?', 'Cancel?', 'Yes', 'No', findDisplay 49, false, false] spawn BIS_fnc_guiMessage;
					if (_result) then {
						findDisplay 49 closeDisplay 2;
					} else {
						
					};
					";
					_display closeDisplay 2;
				},
				_entity
			] call MAZ_EZM_fnc_createDialog;
		};

	comment "Special Effects";

		MAZ_EZM_fnc_ambientFlyByModule = {

		};

		MAZ_EZM_fnc_toggleLampsModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			["Toggle City Lights",[
				[
					"SLIDER:RADIUS",
					"Radius",
					[10,250,100,_pos,[1,1,1,1]]
				],
				[
					"TOOLBOX",
					"Toggle Mode",
					[true,["Turn On","Turn Off"]]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_radius","_mode"];
				private _types = [
					"Lamps_Base_F",
					"Land_LampAirport_F",
					"Land_LampSolar_F",
					"Land_LampStreet_F",
					"Land_LampStreet_small_F",
					"PowerLines_base_F",
					"Land_LampDecor_F",
					"Land_LampHalogen_F",
					"Land_LampHarbour_F",
					"Land_LampShabby_F",
					"Land_PowerPoleWooden_L_F",
					"Land_NavigLight",
					"Land_runway_edgelight",
					"Land_runway_edgelight_blue_F",
					"Land_Flush_Light_green_F",
					"Land_Flush_Light_red_F",
					"Land_Flush_Light_yellow_F",
					"Land_Runway_PAPI",
					"Land_Runway_PAPI_2",
					"Land_Runway_PAPI_3",
					"Land_Runway_PAPI_4",
					"Land_fs_roof_F",
					"Land_fs_sign_F"
				];
				private _nearestLamps = nearestObjects [_args,_types, _radius];
				private _damage = [0.0,0.97] select _mode;
				{_x setDamage _damage;} forEach _nearestLamps;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_pos] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_fireEffectModule = {
			params ["_entity"];
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

			private _smokeNfire = createVehicle ["test_EmptyObjectForFireBig",_pos,[],0,"CAN_COLLIDE"];
			private _light = createVehicle ["#lightpoint",_pos,[],0,"CAN_COLLIDE"];
			[_light,1.5] remoteExec ["setLightBrightness",0,_light];
			[_light,[0.75, 0.25, 0.1]] remoteExec ["setLightAmbient",0,_light];
			[_light,[0.75, 0.25, 0.1]] remoteExec ["setLightColor",0,_light];
			_light attachTo [_smokeNfire,[0,0,0]];

			[_smokeNfire] call MAZ_EZM_fnc_addObjectToInterface;

			if !(_entity isEqualTo objNull) then {_smokeNfire attachTo [_entity,[0,0,0]]};
			[_smokeNfire,_light] spawn {
				params ["_entity","_light"];
				waitUntil{sleep 1; isNull _entity};
				deleteVehicle _light;
			};

			["Fire created.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_smokeEffectModule = {
			params ["_entity"];
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			private _smokeNfire = createVehicle ["test_EmptyObjectForSmoke",_pos,[],0,"CAN_COLLIDE"];

			[_smokeNfire] call MAZ_EZM_fnc_addObjectToInterface;

			if !(_entity isEqualTo objNull) then {_smokeNfire attachTo [_entity,[0,0,0]]};

			["Smoke pillar created.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_earthquakeEffectModule = {
			[4] remoteExec ['BIS_fnc_earthquake'];
			["Yo momma farded.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_empCarEffect = {
			params ["_car"];
			for [{_i=0},{_i<7},{_i=_i+1}] do {
				_car setPilotLight true;
				sleep 0.5;
				_car setPilotLight false;
				sleep 0.5;
			};
		};

		MAZ_EZM_empLightEffect = {
			params ["_lamps"];
			{_x setDamage 0.95} forEach _lamps;
			sleep 0.1;
			{_x setDamage 0} forEach _lamps;
			sleep 0.1;
			{_x setDamage 0.95} forEach _lamps;
			sleep 0.1;
			{_x setDamage 0} forEach _lamps;
			sleep 0.1;
			{_x setDamage 0.95} forEach _lamps;
		};

		MAZ_EZM_empExplosionEffect = {
			params ["_pos"];
			private _explosionVeh = createVehicle ["B_MRAP_01_F",_pos,[],0,""];
			_explosionVeh setDamage 1;
			sleep 0.1;
			deleteVehicle _explosionVeh;
		};

		MAZ_EZM_fnc_EMPEffectModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			["Deploy EMP",[
				[
					"SLIDER:RADIUS",
					"Radius",
					[10,250,100,_pos,[1,1,1,1]]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_radius","_mode"];
				private _types = [
					"Lamps_Base_F",
					"Land_LampAirport_F",
					"Land_LampSolar_F",
					"Land_LampStreet_F",
					"Land_LampStreet_small_F",
					"PowerLines_base_F",
					"Land_LampDecor_F",
					"Land_LampHalogen_F",
					"Land_LampHarbour_F",
					"Land_LampShabby_F",
					"Land_PowerPoleWooden_L_F",
					"Land_NavigLight",
					"Land_runway_edgelight",
					"Land_runway_edgelight_blue_F",
					"Land_Flush_Light_green_F",
					"Land_Flush_Light_red_F",
					"Land_Flush_Light_yellow_F",
					"Land_Runway_PAPI",
					"Land_Runway_PAPI_2",
					"Land_Runway_PAPI_3",
					"Land_Runway_PAPI_4",
					"Land_fs_roof_F",
					"Land_fs_sign_F"
				];
				private _nearestLamps = nearestObjects [_args,_types, _radius];
				private _damage = [0.0,0.97] select _mode;
				private _empCars = _args nearObjects ["LandVehicle",_radius]; 
				{
					playSound3D ["a3\sounds_f_orange\MissionSFX\Car_Alarm_6s.wss",_x,false,_x,1,1,250];
					[_x] spawn MAZ_EZM_empCarEffect;
					_x setHitPointDamage ["HitEngine", 1,false];
				} forEach _empCars;
				[_nearestLamps] spawn MAZ_EZM_empLightEffect;
				playSound3D ["A3\Missions_F_EPA\data\sounds\lights_off.ogg",_args,false,_args,3,1,_radius + 500];
				[_args] spawn MAZ_EZM_empExplosionEffect;
				
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_pos] call MAZ_EZM_fnc_createDialog;
		};

	comment "Terrain Modifiers";

		MAZ_EZM_fnc_openDoorsModule = {
			MAZ_EZM_fnc_doorConfig = {
				params ["_building"];
				private _doors = [_building] call MAZ_EZM_fnc_getDoors;
				if(_doors isEqualTo []) exitWith {};

				private _display = findDisplay 312;
				private _existingControls = [];

				private _icon = [
					"\a3\modules_f\data\editterrainobject\icon3d_doorclosed32_ca.paa",
					"\a3\modules_f\data\editterrainobject\icon3d_doorlocked32_ca.paa",
					"\a3\modules_f\data\editterrainobject\icon3d_dooropened32_ca.paa"
				];
				{
					if((ctrlText _x) in _icon) then {
						ctrlDelete _x;
					};
				}forEach allControls _display;

				private _controls = [];
				{
					private _control = _display ctrlCreate ["RscActivePicture",-1];

					_control setVariable ["params",[_building,_forEachIndex + 1]];
					_control ctrlAddEventHandler ["ButtonClick",{
						params ["_control"];
						(_control getVariable "params") params ["_building","_door"];
						[_building,_door] call MAZ_EZM_fnc_doorSetState;
					}];
					_control ctrlCommit 0;

					_controls pushBack _control;
				}forEach _doors;

				["MAZ_updateDoorsEachFrame","onEachFrame",{
					params ["_building","_doors","_controls"];
					if(isNull (findDisplay 312)) exitWith {
						["MAZ_updateDoorsEachFrame","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
					};

					if(curatorCamera distance _building > 200) then {
						["MAZ_updateDoorsEachFrame","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
						{ctrlDelete _x} forEach _controls;
					};
					
					{
						private _control = _controls select _forEachIndex;

						private _position = _building modelToWorldVisual _x;
						private _distance = curatorCamera distance _position;
						private _screenPos = worldToScreen _position;
						
						if(_screenPos isEqualTo [] || {_distance > 100}) then {
							_control ctrlShow false;
						} else {
							_control ctrlShow true;

							private _state = [_building,_forEachIndex + 1] call MAZ_EZM_fnc_doorGetState;
							private _icon = [
								"\a3\modules_f\data\editterrainobject\icon3d_doorclosed32_ca.paa",
								"\a3\modules_f\data\editterrainobject\icon3d_doorlocked32_ca.paa",
								"\a3\modules_f\data\editterrainobject\icon3d_dooropened32_ca.paa"
							] select _state;
							private _color = [
								[1,1,1,1],
								[0,0.5,0.5,1],
								[0,0.5,0.5,1]
							] select _state;

							_control ctrlSetText _icon;
							_control ctrlSetActiveColor _color;

							_color set [3,0.8];
							_control ctrlSetTextColor _color;

							_screenPos params ["_posX","_posY"];

							private _size = linearConversion [0,100,_distance,1.75,1,true];
							private _posW = ["W",_size] call MAZ_EZM_fnc_convertToGUI_GRIDFormat;
							private _posH = ["H",_size] call MAZ_EZM_fnc_convertToGUI_GRIDFormat;

							_control ctrlSetPosition [_posX - _posW / 2, _posY - _posH / 2,_posW,_posH];
							_control ctrlCommit 0;
						};
					} forEach _doors;
				},[_building,_doors,_controls]] call BIS_fnc_addStackedEventHandler;
			};

			MAZ_EZM_fnc_getDoors = {
				params ["_building"];
				private _cfg = (configOf _building >> "UserActions");
				if !(isClass _cfg) exitWith {[]};

				private _positions = [];
				private _position = "";

				for "_doorID" from 1 to 24 do {
					_position = getText(_cfg >> format["OpenDoor_%1",_doorID] >> "position");
					if (_position == "") exitWith {};
					_positions pushBack (_building selectionPosition _position);
				};

				if (count _positions == 0) exitWith {[]};

				_positions
			};

			MAZ_EZM_fnc_doorSetState = {
				params ["_building","_door"];
				private _state = [_building,_door] call MAZ_EZM_fnc_doorGetState;

				_building setVariable [format ["bis_disabled_door_%1",_door],[1, 0, 0] select _state, true];
				_building animateSource [format ["door_%1_sound_source", _door], [0, 1, 0] select _state, false];
				_building animateSource [format ["door_%1_noSound_source", _door], [0, 1, 0] select _state, false];
			};

			MAZ_EZM_fnc_doorGetState = {
				params ["_building","_door"];
				private _var = _building getVariable [(format ["bis_disabled_door_%1",_door]),0];

				comment "If locked, exit function";
				if(_var == 1) exitWith {1};
				comment "Get animationSourcePhase from door, if closed return 0, if open return 2.";
				[0,2] select (_building animationSourcePhase (format ["door_%1_sound_source", _door]) > 0.5)
			};

			MAZ_EZM_fnc_initDoorModule = {
				params ["_pos"];
				private _building = nearestObject [_pos, "Building"];

				if(isNull _building) exitWith {["No near buildings!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
				[_building] call MAZ_EZM_fnc_doorConfig;
			};

			[[] call MAZ_EZM_fnc_getScreenPosition] call MAZ_EZM_fnc_initDoorModule;
		};

		MAZ_EZM_fnc_godModeFencesModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			["God Mode Fences",[
				[
					"SLIDER:RADIUS",
					"Fences Radius:",
					[10,200,25,_pos,[1,1,1,1]]
				]
			],{
				params ["_values","_pos","_display"];
				_values params ["_radius"];
				
				private ["_modelString","_newObj","_vectorDirUp","_position","_hideTerrain","_type","_blackListFences"];
				_blackListFences = [
					"land_pipewall_conretel_8m_f","land_mil_wiredfence_gate_f","land_mil_concretewall_f","land_cncbarrier_f","land_cncbarrier_stripes_f",
					"land_concrete_smallwall_8m_f","land_concrete_smallwall_4m_f","land_wallcity_01_pillar_whiteblue_f","land_wallcity_01_pillar_yellow_f",
					"land_brickwall_04_l_pole_f","land_brickwall_03_l_pole_f",
					"land_polewall_01_pole_f","land_wallcity_01_pillar_blue_f","land_brickwall_04_l_5m_d_f","land_slums01_pole","land_city_pillar_f",
					"land_canal_wall_stairs_f","land_wallcity_01_pillar_grey_f","land_mil_wallbig_4m_damaged_left_f","land_backalley_01_l_1m_f",
					"land_brickwall_04_l_5m_old_d_f","land_brickwall_02_l_5m_d_f","land_brickwall_03_l_5m_v2_d_f","land_wallcity_01_pillar_pink_f",
					"land_mil_wallbig_gate_f","land_canal_wall_d_center_f","land_backalley_01_l_gap_f","land_bamboofence_01_s_d_f",
					"land_brickwall_04_l_pole_old_f","land_backalley_01_l_gate_f","land_concretewall_01_m_d_f","land_concretewall_01_l_d_f",
					"land_hbarrier_01_wall_4_green_f","land_concretewall_02_m_d_f","land_brickwall_02_l_corner_v2_f","land_brickwall_03_l_5m_v1_d_f",
					"land_gravefence_02_f","land_mil_wallbig_debris_f","land_stone_pillar_f","land_stone_gate_f","land_stone_8md_f",
					"land_canal_wallsmall_10m_f","land_canal_wall_10m_f","land_new_wiredfence_10m_dam_f","land_new_wiredfence_pole_f","land_slums02_pole",
					"land_canal_wall_d_left_f","land_city_8md_f","land_city2_8md_f","land_city2_pillard_f","land_wall_tin_pole","land_mil_wiredfenced_f","land_ancient_wall_8m_f",
					"land_ancient_wall_4m_f","land_wall_indcnc_pole_f","land_canal_wall_d_right_f","land_wall_indcnc_end_2_f","land_indfnc_pole_f",
					"land_indfnc_3_d_f","land_bamboofence_01_s_pole_f","land_backalley_02_l_1m_f","land_woodenwall_02_s_pole_f",
					"land_concretewall_02_m_pole_f","land_hbarrier_01_wall_6_green_f","land_wiredfence_01_pole_45_f","land_brickwall_01_l_end_f",
					"land_gravefence_01_f","land_brickwall_01_l_pole_f","land_wallcity_01_8m_dmg_whiteblue_f","land_pipefence_01_m_d_f",
					"land_wallcity_01_8m_dmg_pink_f","land_concretewall_01_l_pole_f","land_concretewall_03_m_pole_f","land_netfence_03_m_pole_f",
					"land_mil_wallbig_4m_damaged_center_f","land_pipefence_01_m_pole_f","land_wiredfence_01_8m_d_f","land_gravefence_04_f",
					"land_brickwall_01_l_5m_d_f","land_brickwall_02_l_end_f","land_silagewall_01_l_pole_f","land_wiredfence_01_pole_f",
					"land_camoconcretewall_01_pole_v1_f","land_woodenwall_01_m_pole_f","land_netfence_02_m_pole_f","land_camoconcretewall_01_l_end_v1_f",
					"land_wiredfence_01_gate_f","land_tinwall_01_m_pole_f","land_gameprooffence_01_l_d_f","land_hbarrier_01_wall_corner_green_f",
					"land_mil_wallbig_4m_damaged_right_f","land_netfence_03_m_3m_d_f","land_tinwall_02_l_pole_f","land_wallcity_01_8m_dmg_yellow_f",
					"land_netfence_02_m_d_f","land_gravefence_03_f","land_wallcity_01_8m_dmg_grey_f","land_wallcity_01_8m_dmg_blue_f",
					"land_quayconcrete_01_20m_wall_f","land_fortress_01_innercorner_90_f","land_fortress_01_innercorner_70_f","land_fortress_01_5m_f",
					"land_woodenwall_03_s_d_5m_v1_f","land_fortress_01_outtercorner_80_f","land_pipefence_02_s_8m_f","land_woodenwall_05_m_d_4m_f",
					"land_fortress_01_d_r_f","land_woodenwall_02_s_8m_f","land_woodenwall_04_s_pole_f","land_petroglyphwall_01_f",
					"land_hbarrierwall_corner_f","land_basaltwall_01_4m_f","land_hbarrierwall4_f","land_wired_fence_4m_f","land_wired_fence_8m_f",
					"land_mound02_8m_f","land_mound01_8m_f","land_wall_tin_4_2","land_hbarrier_1_f","land_mil_wiredfence_f","land_razorwire_f",
					"land_slums01_8m","land_slums02_4m","land_hbarrier_5_f","land_hbarrier_big_f","land_pipe_fence_4m_f","land_sportground_fence_f",
					"land_hbarrier_3_f","land_net_fenced_8m_f","land_net_fence_pole_f","land_net_fence_8m_f","land_net_fence_4m_f",
					"land_wired_fence_4md_f","land_wired_fence_8md_f","land_pipefence_02_s_4m_f","land_woodenwall_05_m_4m_v2_f",
					"land_woodenwall_04_s_end_v2_f","land_woodenwall_04_s_d_5m_f","land_basaltwall_01_d_right_f","land_woodenwall_01_m_4m_f",
					"land_woodenwall_02_s_4m_f","land_woodenwall_05_m_end_f","land_woodenwall_03_s_pole_f","land_woodenwall_04_s_end_v1_f",
					"land_woodenwall_03_s_5m_v1_f","land_petroglyphwall_02_f","land_woodenwall_03_s_d_5m_v2_f","land_woodenwall_01_m_8m_f",
					"land_tinwall_02_l_4m_f","land_vineyardfence_01_f","land_slumwall_01_s_2m_f","land_hbarrierwall_corridor_f",
					"land_basaltwall_01_gate_f","land_tinwall_01_m_4m_v2_f","land_plasticnetfence_01_long_f","land_plasticnetfence_01_short_f",
					"land_plasticnetfence_01_short_d_f","land_fortress_01_outtercorner_50_f","land_fortress_01_innercorner_110_f",
					"land_polewall_03_5m_v1_f","land_hbarrierwall6_f","land_slumwall_01_s_4m_f","land_hedge_01_s_4m_f","land_polewall_03_5m_v2_f",
					"land_gameprooffence_01_l_pole_f","land_woodenwall_03_s_5m_v2_f","land_woodenwall_04_s_5m_f","land_woodenwall_05_m_pole_f",
					"land_bamboofence_01_s_4m_f","land_bamboofence_01_s_8m_f","land_plasticnetfence_01_pole_f","land_plasticnetfence_01_long_d_f",
					"land_castleruins_01_wall_d_l_f","land_hedge_01_s_2m_f","land_stonewall_01_s_10m_f","land_tinwall_01_m_4m_v1_f",
					"land_polewall_03_end_f","land_hbarriertower_f","land_woodenwall_02_s_2m_f","land_tinwall_02_l_8m_f","land_wall_tin_4",
					"land_stonewall_01_s_d_f","land_woodenwall_01_m_d_f","land_gameprooffence_01_l_gate_f","land_fortress_01_10m_f",
					"land_stonewall_02_s_10m_f","land_woodenwall_05_m_4m_v1_f","land_woodenwall_03_s_d_pole_f","land_woodenwall_02_s_d_f",
					"land_gameprooffence_01_l_5m_f","land_mound04_8m_f","land_fortress_01_outtercorner_90_f","land_mound03_8m_f",
					"land_castleruins_01_wall_d_r_f","land_castleruins_01_wall_10m_f","land_fortress_01_d_l_f","land_basaltwall_01_8m_f",
					"land_basaltwall_01_d_left_f","land_castle_01_wall_01_f","land_castle_01_wall_02_f","land_castle_01_wall_03_f",
					"land_castle_01_wall_04_f","land_castle_01_wall_05_f","land_castle_01_wall_06_f","land_castle_01_wall_07_f","land_castle_01_wall_08_f",
					"land_castle_01_wall_09_f","land_castle_01_wall_10_f","land_castle_01_wall_11_f","land_castle_01_wall_12_f","land_castle_01_wall_13_f",
					"land_castle_01_wall_14_f","land_castle_01_wall_15_f","land_castle_01_wall_16_f","land_pipe_fence_4mnolc_f","land_crash_barrier_f",
					"land_crashbarrier_01_4m_f","land_crashbarrier_01_8m_f","land_crashbarrier_01_end_l_f","land_crashbarrier_01_end_r_f",
					"land_castle_01_church_ruin_f","land_castle_01_church_b_ruin_f","land_castle_01_step_f","land_pier_wall_f","land_castle_01_house_ruin_f",
					"land_new_wiredfence_5m_f","land_new_wiredfence_10m_f","land_cncbarriermedium_f","land_sportground_fence_nolc_f","land_cncwall1_f",
					"land_cncwall4_f","land_cncshelter_f"
				];
				private  _count = 0;
				{
					_modelString = (str _x) splitString " .";
					_type = format ['land_%1',_modelString select (count _modelString) - 2];
					
					if((toLower _type) in _blackListFences) then {} else {
						_count = _count + 1;
						_position = getPosASL _x;
						_vectorDirUp = [vectorDir _x,vectorUp _x];
						_newObj = createSimpleObject [format ["%1",_type],_position];
						_newObj setVectorDirAndUp [vectorDir _x,vectorUp _x];
						[_x,true] remoteExec ['hideObject',0,true];
						[_x,false] remoteExec ['allowDamage',0,true];
					};
				}forEach (nearestTerrainObjects [_pos,["WALL","FENCE"],_radius]);

				[format ["%1 fences replaced!",_count],"addItemOk"] call MAZ_EZM_fnc_systemMessage;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_pos] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_hideTerrainRadiusModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			["Hide Terrain Objects",[
				[
					"SLIDER:RADIUS",
					"Radius",
					[1,250,50,_pos,[1,1,1,1]]
				],
				[
					"TOOLBOX",
					"Hide or Show",
					[true,[["SHOW","Reveals the terrain objects within the radius."],["HIDE","Hides terrain objects within the radius."]]]
				]
			],{
				params ["_values","_args","_display"];
				_values params ["_radius","_hide"];
				private _nearestObjects = nearestTerrainObjects [_args,[],_radius];
				if(_hide) then {
					{
						[_x,true] remoteExec ['hideObject',0,_x];
						_x allowDamage false;
					} forEach _nearestObjects;
				} else {
					{
						[_x,false] remoteExec ['hideObject',0,_x];
						_x allowDamage true;
					} forEach _nearestObjects;
				};
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_pos] call MAZ_EZM_fnc_createDialog;
		};

	comment "Teleportation";

		MAZ_EZM_fnc_teleportSelfModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			player setPos _pos;

			["Teleported.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_teleportAllPlayersModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			{
				_x setPos _pos;
			}forEach allPlayers;

			["All players teleported.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_teleportPlayerModule = {
			["Teleport Player",[
				[
					"LIST",
					"Player to Teleport",
					[
						[],
						(allPlayers apply {name _x}),
						0
					]
				]
			],{
				params ["_values","_args","_display"];
				private _value = _values # 0;
				(allPlayers select _value) setPos _args;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[] call MAZ_EZM_fnc_getScreenPosition] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_teleportSideModule = {
			["Teleport Side",[
				[
					"SIDES",
					"Side to teleport:",
					[west,east,independent,civilian]
				]
			],{
				params ["_values","_args","_display"];
				_values = _values # 0;
				_values apply {
					private _return = _x;
					if(str _x == "GUER") then {
						_return = independent;
					};
					if(str _x == "CIV") then {
						_return = civilian;
					};
				};
				private _allUnits = [];
				{
					{
						if(isPlayer _x) then {
							_allUnits pushback _x;
						};
					}forEach (units _x);
				}forEach _values;
				{
					_x setPos _args;
				}forEach _allUnits;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[] call MAZ_EZM_fnc_getScreenPosition] call MAZ_EZM_fnc_createDialog;
		};

	comment "Utilities";

		JAM_zeus_objBlacklist = [
			"Logic",
			"ModuleHQ_F",
			"ModuleSector_F",
			"ModuleCurator_F",
			"VirtualCurator_F",
			"ModuleCuratorSetCosts_F",
			"ModuleCuratorSetCoefs_F",
			"LogicSectorPreview100m_F",
			"LogicSectorUnknown100m_F",
			"ModuleCuratorSetCamera_F",
			"ModuleMPTypeGameMaster_F",
			"ModuleCuratorAddPoints_F",
			"ModuleRadioChannelCreate_F",
			"ModuleCuratorSetModuleCosts_F",
			"ModuleCuratorSetObjectCosts_F",
			"ModuleCuratorSetDefaultCosts_F",
			"ModuleCuratorSetAttributesPlayer_F",
			"ModuleCuratorAddEditingAreaPlayers_F"
		];
		JAM_zeus_objWhitelist = [
			"ModuleLightning_F",
			"ModuleRemoteControl_F",
			"ModuleArsenal_F",
			"ModuleHint_F",
			"ModulePunishment_F",
			"ModuleBootcampStage_F",
			"ModuleSmokeYellow_F",
			"ModuleSmokeWhite_F",
			"ModuleSmokeRed_F",
			"ModuleSmokePurple_F",
			"ModuleSmokeOrange_F",
			"ModuleSmokeGreen_F",
			"ModuleSmokeBlue_F",
			"ModuleMissionName_F",
			"ModuleRespawnTickets_F",
			"ModuleEndMission_F",
			"ModuleCountdown_F",
			"ModuleDiary_F",
			"ModuleVehicleRespawnPositionEast_F",
			"ModuleVehicleRespawnPositionGuer_F",
			"ModuleVehicleRespawnPositionCiv_F",
			"ModuleVehicleRespawnPositionWest_F",
			"ModuleRespawnPositionEast_F",
			"ModuleRespawnPositionGuer_F",
			"ModuleRespawnPositionCiv_F",
			"ModuleRespawnPositionWest_F",
			"ModuleRespawnInventory_F",
			"ModuleObjectiveRaceStart_F",
			"ModuleObjectiveRaceFinish_F",
			"ModuleObjectiveRaceCP_F",
			"ModuleObjectiveProtect_F",
			"ModuleObjectiveNeutralize_F",
			"ModuleObjectiveMove_F",
			"ModuleObjectiveGetIn_F",
			"ModuleObjective_F",
			"ModuleObjectiveSector_F",
			"ModuleObjectiveAttackDefend_F",
			"ModuleFlareGreen_F",
			"ModuleFlareRed_F",
			"ModuleFlareWhite_F",
			"ModuleFlareYellow_F",
			"ModuleCASMissile_F",
			"ModuleCASGun_F",
			"ModuleCASGunMissile_F",
			"ModuleCASBomb_F",
			"ModuleOrdnanceMortar_F",
			"ModuleOrdnanceRocket_F",
			"ModuleOrdnanceHowitzer_F",
			"ModuleWeather_F",
			"ModuleTimeMultiplier_F",
			"ModuleSkiptime_F",
			"ModulePostprocess_F",
			"ModuleTracers_F",
			"ModuleIRGrenade_F",
			"ModuleChemlightBlue_F",
			"ModuleChemlightGreen_F",
			"ModuleChemlightRed_F",
			"ModuleChemlightYellow_F",
			"ModuleMusic_F",
			"ModuleRadio_F",
			"ModuleSound_F",
			"ModuleAnimalsButterflies_F",
			"ModuleAnimalsGoats_F",
			"ModuleAnimalsPoultry_F",
			"ModuleAnimalsSeagulls_F",
			"ModuleAnimalsSheep_F"
		];

		MAZ_EZM_fnc_addObjectsToInterfaceModule = {
			[] spawn {
				["Filtering map objects..."] call MAZ_EZM_fnc_systemMessage;
				private _goodObjects = [];
				{
					if(!(typeOf _x in JAM_zeus_objBlacklist)) then {
						_goodObjects pushBack _x;
					};
					sleep 0.00001;
				}forEach allMissionObjects "All";
				["Map objects filtered."] call MAZ_EZM_fnc_systemMessage;
				[_goodObjects,MAZ_EZM_inferfaceAdd] call MAZ_EZM_fnc_addObjectToInterface;
				["Map objects added.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			};
		};

		JAM_fnc_getEditableObjs_radius = {
			params ['_addPos', '_addRadius'];
			_allObjs = nearestObjects [_addPos, ['ALL'], _addRadius, true];
			_objsToAdd = [];
			{
				_addObject = false;
				_className = typeOf _x;
				_isKindOfLogic = _x isKindOf 'Logic';
				_isInWhitelist = _className in JAM_zeus_objWhitelist;
				_isInBlacklist = _className in JAM_zeus_objBlacklist;
				if (_isKindOfLogic) then 
				{
					if ((!_isInBlacklist) OR (_isInWhitelist)) then 
					{
						_addObject = true;
					};
				} else 
				{
					if (!_isInBlacklist) then 
					{
						_addObject = true;
					};
				};
				if !(_x getVariable ['JAM_isEditable', true]) then 
				{
					_addObject = false;
				};
				if (_addObject) then 
				{
					_objsToAdd pushBack _x;
				};
			} forEach _allObjs;
			_objsToAdd;
		};

		MAZ_EZM_fnc_addObjectsToInterfaceRadiusModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			["Add Objects to Interface",[
				[
					"SLIDER:RADIUS",
					"Radius",
					[10,2000,250,_pos,[1,1,1,1]]
				],
				[
					"TOOLBOX",
					"Global or Local",
					[true,[["Local","Adds to interface for you only."],["Global","Adds to interface for every zeus."]]]
				]
			],{
				params ["_values","_args","_display"];
				private _radius = round (_values # 0);
				private _isGlobal = _values # 1;
				_isGlobal = [getAssignedCuratorLogic player, allCurators] select _isGlobal;
				private _objects = [_args,_radius] call JAM_fnc_getEditableObjs_radius;
				[_objects,_isGlobal] call MAZ_EZM_fnc_addObjectToInterface;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_pos] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_toggleAutoAddToInterface = {
			if(MAZ_EZM_autoAdd) then {
				MAZ_EZM_autoAdd = false;
				profileNamespace setVariable ['MAZ_EZM_autoAddVar',false];
				["Automatic adding to interface disabled!","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			} else {
				MAZ_EZM_autoAdd = true;
				profileNamespace setVariable ['MAZ_EZM_autoAddVar',true];
				["Automatic adding to interface enabled!","addItemOk"] call MAZ_EZM_fnc_systemMessage;
			};
		};

		MAZ_EZM_BIS_fnc_remoteControlUnit = {
			params ["_logic","_unit","_activated"];
			if (_activated && local _logic && !isnull curatorcamera) then {

				if !(isnull (missionnamespace getvariable ["bis_fnc_moduleRemoteControl_unit",objnull])) exitwith {};

				private _targetObjArray = curatorMouseOver;
				_unit = _targetObjArray select 1;
				_unit = effectivecommander _unit;

				private _tempOwner = _unit getvariable ["bis_fnc_moduleRemoteControl_owner", objnull];

				_error = "";
				if !(side group _unit in [east,west,resistance,civilian]) then {_error = localize "str_a3_cfgvehicles_moduleremotecontrol_f_errorEmpty";};
				if (isplayer _unit) then {_error = localize "str_a3_cfgvehicles_moduleremotecontrol_f_errorPlayer";};
				if !(alive _unit) then {_error = localize "str_a3_cfgvehicles_moduleremotecontrol_f_errorDestroyed";};
				if (isnull _unit) then {_error = localize "str_a3_cfgvehicles_moduleremotecontrol_f_errorNull";};
				if (!isnull _tempOwner && {_tempOwner in allPlayers}) then {_error = localize "str_a3_cfgvehicles_moduleremotecontrol_f_errorControl";};
				if (isuavconnected vehicle _unit) then {_error = localize "str_a3_cfgvehicles_moduleremotecontrol_f_errorControl";};

				if (_error == "") then {
					_unit spawn {
						scriptname "bis_fnc_moduleRemoteControl: Loop";
						_unit = _this;
						_vehicle = vehicle _unit;
						_vehicleRole = str assignedvehiclerole _unit;

						bis_fnc_moduleRemoteControl_unit = _unit;
						_unit setvariable ["bis_fnc_moduleRemoteControl_owner",player,true];

						[format ["wind%1",ceil random 5],"bis_fnc_playsound"] call bis_fnc_mp;

						_blur = ppeffectcreate ["RadialBlur",144];
						_blur ppeffectenable true;
						_blur ppeffectadjust [0,0,0.3,0.3];
						_blur ppeffectcommit 0;
						_blur ppeffectadjust [0.03,0.03,0.1,0.1];
						_blur ppeffectcommit 1;

						_cam = "camera" camcreate getposatl curatorcamera;
						_cam cameraeffect ["internal","back"];
						_cam campreparetarget (screentoworld [0.5,0.5]);
						_cam camcommitprepared 0;
						_cam campreparetarget _unit;
						_cam campreparefov 0.1;
						_cam camcommitprepared 1;
						sleep 0.75;

						("bis_fnc_moduleRemoteCurator" call bis_fnc_rscLayer) cuttext ["","black out",0.25];
						sleep 0.25;

						(finddisplay 312) closedisplay 2;
						waituntil {isnull curatorcamera};

						player remotecontrol _unit;
						if (cameraon != _vehicle) then {
							_vehicle switchcamera cameraview;
						};

						ppeffectdestroy _blur;
						_cam cameraeffect ["terminate","back"];
						camdestroy _cam;

						_color = ppeffectcreate ["colorCorrections",1896];
						_color ppeffectenable true;
						_color ppeffectadjust [1,1,0,[0,0,0,1],[1,1,1,1],[0,0,0,0],[0.9,0.0,0,0,0,0.5,1]];
						_color ppeffectcommit 0;

						_curator = getassignedcuratorlogic player;
						[_curator,"curatorObjectRemoteControlled",[_curator,player,_unit,true]] call bis_fnc_callScriptedEventHandler;
						[["Curator","RemoteControl"],nil,nil,nil,nil,nil,nil,true] call bis_fnc_advHint;

						sleep 0.3;
						_color ppeffectadjust [1,1,0,[0,0,0,1],[1,1,1,1],[0,0,0,0],[0.9,0.85,0,0,0,0.5,1]];
						_color ppeffectcommit 0.3;
						("bis_fnc_moduleRemoteCurator" call bis_fnc_rscLayer) cuttext ["","black in",0.5];

						_vehicle = vehicle _unit;
						_vehicleRole = str assignedvehiclerole _unit;
						_rating = rating player;
						waituntil {
							if ((vehicle _unit != _vehicle || str assignedvehiclerole _unit != _vehicleRole) && {alive _unit}) then {
								player remotecontrol _unit;
								_vehicle = vehicle _unit;
								_vehicleRole = str assignedvehiclerole _unit;
							};
							if (rating player < _rating) then {
								player addrating (-rating player + _rating);
							};
							sleep 0.01;
							!isnull curatorcamera
							||
							{cameraon == vehicle player}
							||
							{!alive _unit}
							||
							{!alive player}
							||
							{isnull getassignedcuratorlogic player}
						};

						player addrating (-rating player + _rating);
						objnull remotecontrol _unit;
						_unit setvariable ["bis_fnc_moduleRemoteControl_owner",nil,true];

						if (alive player) then {
							if (
								isnull curatorcamera
								&&
								{cameraon != vehicle player}
								&&
								{!isnull _unit}
								&&
								{!isnull getassignedcuratorlogic player}
							) then {
								sleep 2;
								("bis_fnc_moduleRemoteCurator" call bis_fnc_rscLayer) cuttext ["","black out",1];
								sleep 1;
							};
							if !(isnull _unit) then {
								_unitPos = getposatl _unit;
								_camPos = [_unitPos,10,direction _unit + 180] call bis_fnc_relpos;
								_camPos set [2,(_unitPos select 2) + (getterrainheightasl _unitPos) - (getterrainheightasl _camPos) + 10];
								(getassignedcuratorlogic player) setvariable ["bis_fnc_modulecuratorsetcamera_params",[_camPos,_unit]];
							};

							sleep 0.1;
							("bis_fnc_moduleRemoteCurator" call bis_fnc_rscLayer) cuttext ["","black in",1e10];
							opencuratorinterface;
							ppeffectdestroy _color;

							waituntil {!isnull curatorcamera};
						} else {
							ppeffectdestroy _color;
						};
						player switchcamera cameraview;
						bis_fnc_moduleRemoteControl_unit = nil;
						("bis_fnc_moduleRemoteCurator" call bis_fnc_rscLayer) cuttext ["","black in",1];
						[_curator,"curatorObjectRemoteControlled",[_curator,player,_unit,false]] call bis_fnc_callScriptedEventHandler;
						sleep 0.01;
					};
				} else {
					[objnull,_error] call bis_fnc_showCuratorFeedbackMessage;
				};
				deletevehicle _logic;
			};
		};

	comment "Vehicle Modifications";

		MAZ_EZM_fnc_unflipVehicleModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {["No object!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};

			_entity setVectorUp surfaceNormal getPos _entity;
			_entity setPosATL [getPosATL _entity select 0, getPosATL _entity select 1, 0.2];

			["Vehicle unflipped.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_rearmVehicleModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {["No object!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[[_entity],{
				params ["_entity"];
				[[_entity],{
					params ["_entity"];
					_entity setVehicleAmmo 1;
				}] remoteExec ['spawn',owner _entity];
			}] remoteExec ['spawn',2];

			["Vehicle rearmed.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_refuelVehicleModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {["No object!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[_entity,{
				[_this,1] remoteExec ['setFuel',owner _this];
			}] remoteExec ['spawn',2];

			["Vehicle refueled.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

		MAZ_EZM_fnc_repairVehicleModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {["No object!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			[_entity,{
				_this setDamage 0;
			}] remoteExec ['spawn',_entity];

			["Vehicle repaired.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
		};

	comment "Auto-Add to Interface";
	
		MAZ_EZM_fnc_addToInterface = {
			[] spawn {
				if(!MAZ_EZM_autoAdd) exitWith {};
				if (!M9SD_serverEZM) then {
					["Filtering map objects..."] call MAZ_EZM_fnc_systemMessage;
				};
				private _goodObjects = [];
				{
					if(!(typeOf _x in JAM_zeus_objBlacklist)) then {
						_goodObjects pushBack _x;
					};
					sleep 0.001;
				}forEach allMissionObjects "All";
				if (!M9SD_serverEZM) then {
					["Map objects filtered."] call MAZ_EZM_fnc_systemMessage;
				};
				[_goodObjects] call MAZ_EZM_fnc_addObjectToInterface;
				if (!M9SD_serverEZM) then {
					["Map objects added.","addItemOk"] call MAZ_EZM_fnc_systemMessage;
				};
			};
		};

	comment "Faction Functions";

		MAZ_EZM_fnc_removeAllClothing = {
			params ["_unit"];
			_unit setUnitLoadout [[],[],[],[],[],[],"","",["","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];
			removeGoggles _unit;
		};

		MAZ_EZM_fnc_createMan = {
			params [
				["_side",west,[west]],
				["_unitType","B_Soldier_F",[""]],
				["_unitPos","UP",[""]],
				["_behaviour","AWARE",[""]],
				["_rank","PRIVATE",[""]],
				["_pos",[] call MAZ_EZM_fnc_getScreenPosition,[[]]]
			];
			private _grp = createGroup [_side,true];
			private _unit = _grp createUnit [_unitType,_pos,[],0,"CAN_COLLIDE"];
			_unit setUnitPos _unitPos;
			_unit setRank _rank;
			_grp setBehaviour _behaviour;
			[_unit] call MAZ_EZM_fnc_addObjectToInterface;

			_unit
		};

		MAZ_EZM_fnc_addItemAndWeapons = {
			params [
				["_unit",objNull,[objNull]],
				["_primWeapon",[],[[]]],
				["_secWeapon",[],[[]]],
				["_handgunWeapon",[],[[]]],
				["_numFirstAidKits",3,[3]],
				["_grenadeInfo",[],[[]]],
				["_extraItems",[],[[]]]
			];

			for "_i" from 1 to _numFirstAidKits do {
				_unit addItem "FirstAidKit";
			};

			{
				_x params ["_grenadeType","_grenadeQuantity"];
				for "_i" from 1 to _grenadeQuantity do {
					_unit addMagazine _grenadeType;
				};
			}forEach _grenadeInfo;

			if(!(_primWeapon isEqualTo [])) then {
				_primWeapon params [["_primWeaponType","",[""]],["_magInfo","",[[]]],["_primAttachments",[]]];
				for "_i" from 1 to (_magInfo select 1) do {
					_unit addMagazine (_magInfo select 0);
				};
				_unit addWeapon _primWeaponType;
				{
					_unit addPrimaryWeaponItem _x;
				}forEach _primAttachments;
			};

			if(!(_secWeapon isEqualTo [])) then {
				_secWeapon params [["_secWeaponType","",[""]],["_secMagInfo","",[[]]],["_secAttachments",[]]];
				for "_i" from 1 to (_secMagInfo select 1) do {
					_unit addMagazine (_secMagInfo select 0);
				};
				_unit addWeapon _secWeaponType;
				{
					_unit addSecondaryWeaponItem _x;
				}forEach _secAttachments;
			};

			if(!(_handgunWeapon isEqualTo [])) then {
				_handgunWeapon params [["_hGunWeaponType","",[""]],["_hGunMagInfo","",[[]]],["_hGunAttachments",[]]];
				for "_i" from 1 to (_hGunMagInfo select 1) do {
					_unit addMagazine (_hGunMagInfo select 0);
				};
				_unit addWeapon _hGunWeaponType;
				{
					_unit addSecondaryWeaponItem _x;
				}forEach _hGunAttachments;
			};

			{
				_x params ["_itemType","_itemQuantity"];
				for "_i" from 1 to _itemQuantity do {
					_unit addItem _itemType;
				};
			}forEach _extraItems;
		};

	comment "Better Civilians";

		MAZ_EZM_fnc_createBetterCivilianModule = {
			private _unit = [civilian,"C_man_1","UP","SAFE"] call MAZ_EZM_fnc_createMan;

			private _civilianUniforms = ["U_C_ArtTShirt_01_v6_F","U_C_ArtTShirt_01_v1_F","U_C_Man_casual_2_F","U_C_ArtTShirt_01_v2_F","U_C_ArtTShirt_01_v4_F","U_C_Man_casual_3_F","U_C_Man_casual_1_F","U_C_ArtTShirt_01_v5_F","U_C_ArtTShirt_01_v3_F","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Uniform_Farmer_01_F","U_C_FormalSuit_01_black_F","U_C_FormalSuit_01_blue_F","U_C_FormalSuit_01_gray_F","U_C_FormalSuit_01_khaki_F","U_C_FormalSuit_01_tshirt_black_F","U_C_FormalSuit_01_tshirt_gray_F","U_BG_Guerilla2_2","U_BG_Guerilla2_1","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_C_HunterBody_grn","U_C_E_LooterJacket_01_F","U_I_L_Uniform_01_tshirt_black_F","U_I_L_Uniform_01_tshirt_skull_F","U_I_L_Uniform_01_tshirt_sport_F","U_Marshal","U_C_Mechanic_01_F","U_C_Uniform_Scientist_02_formal_F","U_C_Man_casual_6_F","U_C_Man_casual_4_F","U_C_Man_casual_5_F","U_C_Poor_1"];
			private _civilianHeadgear = ["H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_mcamo","H_Booniehat_tan","H_Booniehat_dgtl","H_Cap_red","H_Cap_blu","H_Cap_oli","H_Cap_tan","H_Cap_blk","H_Cap_blk_CMMG","H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_Cap_grn","H_Cap_grn_BI","H_Cap_blk_ION","H_Cap_usblack","H_Cap_surfer","H_Bandanna_surfer","H_Bandanna_khk","H_Bandanna_cbr","H_Bandanna_sgg","H_Bandanna_sand","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_camo","H_Bandanna_mcamo","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_khk","H_Watchcap_camo","H_StrawHat","H_StrawHat_dark","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_grey","H_Hat_checker","H_Hat_tan","H_Hat_Safari_sand_F","H_Hat_Safari_olive_F","H_HeadSet_black_F","H_Hat_Tinfoil_F","H_Booniehat_mgrn"];
			private _civilianGoggles = ["H_WirelessEarpiece_F","G_Spectacles","G_Spectacles_Tinted","G_Shades_Black","G_Shades_Green","G_Shades_Red","G_Squares","G_Squares_Tinted","G_Sport_BlackWhite","G_Sport_Blackyellow","G_Sport_Greenblack","G_Sport_Checkered","G_Sport_Red","G_Shades_Blue","G_Sport_Blackred","G_Respirator_white_F","G_Respirator_yellow_F","G_Respirator_blue_F","G_WirelessEarpiece_F","G_RegulatorMask_F"];
			
			removeUniform _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
			_unit forceAddUniform (selectRandom _civilianUniforms);
			_unit addHeadgear (selectRandom _civilianHeadgear);
			_unit addGoggles (selectRandom _civilianGoggles);
			[_unit,""] remoteExec ["switchMove"];
		};

		MAZ_EZM_fnc_createBetterCivilianJournoModule = {
			private _unit = [civilian,"C_journalist_F","UP","SAFE"] call MAZ_EZM_fnc_createMan;

			private _pressUni = "U_C_Journalist";
			private _pressVest = [""];
			private _pressHeadgear = ["H_Cap_press","H_WirelessEarpiece_F",""];
			private _pressGoggles = ["G_WirelessEarpiece_F","G_Spectacles_Tinted","G_Shades_Black","G_Aviator"];

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

	comment "MDF";

		comment "Anti-Air";

			MAZ_EZM_MDF_fnc_createCheetahModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_APC_Tracked_01_AA_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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

		comment "APCs";

			MAZ_EZM_MDF_fnc_createGorgonModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_APC_Wheeled_03_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				[
					_vehicle,
					["Guerilla_02",1], 
					["showCamonetHull",0,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",1]
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

			MAZ_EZM_MDF_fnc_createRhinoModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_AFV_Wheeled_01_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				[
					_vehicle,
					["Sand",1], 
					["showCamonetHull",1,"showCamonetTurret",0,"showSLATHull",1]
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

		comment "Cars";

			MAZ_EZM_MDF_fnc_createOffroadModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_armed_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_AT_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_ammo_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_repair_green_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakFuelModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_fuel_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_fuel_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakMedicalModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_medical_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakRepairModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_box_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_repair_green_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakTransportModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_transport_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakTransportCoveredModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_covered_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

		comment "Drones";

			MAZ_EZM_MDF_fnc_createGreyhawkModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_UAV_02_dynamicLoadout_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\drones_f\air_f_gamma\uav_02\data\uav_02_indp_co.paa"];

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
			};

		comment "Helicopters";

			MAZ_EZM_MDF_fnc_createHummingbirdModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_Heli_Light_01_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				[_vehicle,[0,"A3\air_f\heli_light_01\data\skins\Heli_light_01_ext_digital_co.paa"]] remoteExec ['setObjectTexture',0,_vehicle];
				
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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_Heli_Light_01_dynamicLoadout_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				[_vehicle,[0,"A3\air_f\heli_light_01\data\skins\Heli_light_01_ext_digital_co.paa"]] remoteExec ['setObjectTexture',0,_vehicle];
				
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
				sleep 0.5;
				private _frenchVoice = [
					"Male01FRE",
					"Male02FRE",
					"Male03FRE",
					"Male01ENGFRE",
					"Male02ENGFRE"
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

				[_unit,(selectRandom _frenchVoice)] remoteExec ['setSpeaker',0,_unit];
				[_unit,(selectRandom _whiteHeads)] remoteExec ['setFace',0,_unit];
			};

			MAZ_EZM_MDF_fnc_addMDFUniformToUnit = {
				params ["_unit"];
				private _mdfUniforms = ["U_I_CombatUniform","U_I_CombatUniform_shortsleeve","U_BG_Guerilla1_1"];
				private _mdfVests = ["V_PlateCarrier1_rgr_noflag_F","V_TacVest_brn"];
				private _mdfHeadgear = ["H_MilCap_OUcamo","H_Bandanna_cbr","H_Bandanna_khk_hs","H_Bandanna_khk","H_Watchcap_cbr","H_Booniehat_khk_hs","H_Booniehat_khk","H_HelmetB_light_sand"];
				private _mdfGoggles = ["G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_khk","G_Bandanna_shades","G_Bandanna_sport","G_Bandanna_tan","G_Shades_Black","G_Shades_Blue","G_Shades_Green","G_Shades_Red","G_Spectacles","G_Tactical_Clear","G_Tactical_Black"];
				
				_unit forceAddUniform (selectRandom _mdfUniforms);
				_unit addVest (selectRandom _mdfVests);
				_unit addHeadgear (selectRandom _mdfHeadgear);
				_unit addGoggles (selectRandom _mdfGoggles);
			};

			MAZ_EZM_MDF_fnc_loopCheckForMDFTexture = {
				params ["_unit"];
				while {alive _unit} do {
					switch (uniform _unit) do {
						case "U_I_CombatUniform_shortsleeve": {
							if((getObjectTextures _unit # 0) != "A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa") then {
								[_unit,{
									_this setObjectTextureGlobal [0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"];
								}] remoteExec ['spawn',0,_unit];
							};
						};
						case "U_I_CombatUniform": {
							if((getObjectTextures _unit # 0) != "A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa") then {
								[_unit,{
									_this setObjectTextureGlobal [0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"];
								}] remoteExec ['spawn',0,_unit];
							};
						};
						case "U_BG_Guerilla1_1": {
							if((getObjectTextures _unit # 1) != "A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa") then {
								[_unit,{
									_this setObjectTextureGlobal [1,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"];
								}] remoteExec ['spawn',0,_unit];
							};
						};
					};
					sleep 1;
				};
			};

			MAZ_EZM_MDF_fnc_createAmmoBearerModule = {
				private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				_unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["FirstAidKit",4],["200Rnd_65x39_cased_Box",1,200],["NLAW_F",1,1],["HandGrenade",2,1],["MiniGrenade",2,1],["1Rnd_HE_Grenade_shell",6,1],["20Rnd_762x51_Mag",3,20]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createAutoriflemanModule = {
				private _unit = [independent,"I_Soldier_AR_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["LMG_Mk200_F",["200Rnd_65x39_cased_Box",3],["optic_holosight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createMedicModule = {
				private _unit = [independent,"I_Medic_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
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
				private _unit = [independent,"I_crew_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				removeHeadgear _unit;
				_unit addHeadgear "H_HelmetCrew_I";
				removeVest _unit;
				_unit addVest "V_TacVest_brn";
				[_unit,["arifle_Mk20C_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createEngineerModule = {
				private _unit = [independent,"I_engineer_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				_unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["ToolKit",1],["MineDetector",1],["DemoCharge_Remote_Mag",2,1],["SatchelCharge_Remote_Mag",1,1]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createExplosivesSpecModule = {
				private _unit = [independent,"I_Soldier_exp_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				_unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["ToolKit",1],["MineDetector",1],["APERSBoundingMine_Range_Mag",3,1],["ClaymoreDirectionalMine_Remote_Mag",2,1],["SLAMDirectionalMine_Wire_Mag",2,1],["DemoCharge_Remote_Mag",1,1]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createGrenadierModule = {
				private _unit = [independent,"I_Soldier_GL_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["arifle_Mk20_GL_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createHeliCrewModule = {
				private _unit = [independent,"I_crew_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				removeHeadgear _unit;
				_unit addHeadgear "H_CrewHelmetHeli_B";
				removeVest _unit;
				_unit addVest "V_TacVest_brn";
				[_unit,["arifle_Mk20C_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createHeliPilotModule = {
				private _unit = [independent,"I_crew_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				removeHeadgear _unit;
				_unit addHeadgear "H_PilotHelmetHeli_B";
				removeVest _unit;
				_unit addVest "V_TacVest_brn";
				[_unit,["arifle_Mk20C_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createMarksmanModule = {
				private _unit = [independent,"I_Soldier_M_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["srifle_DMR_03_tan_F",["20Rnd_762x51_Mag",5],["optic_hamr"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createMissileSpecAAModule = {
				private _unit = [independent,"I_Soldier_AA_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],["launch_B_Titan_F",["Titan_AA",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createPilotModule = {
				private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				_unit setUnitLoadout [["SMG_01_F","","","optic_Aco_smg",["30Rnd_45ACP_Mag_SMG_01",30],[],""],[],[],["U_I_pilotCoveralls",[["30Rnd_45ACP_Mag_SMG_01",3,30],["SmokeShellOrange",2,1]]],[],[],"H_PilotHelmetFighter_I","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				_unit
			};

			MAZ_EZM_MDF_fnc_createRiflemanModule = {
				private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createRiflemanATModule = {
				private _unit = [independent,"I_Soldier_LAT_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				_unit addBackpack "B_AssaultPack_cbr";
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],["launch_NLAW_F",["NLAW_F",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createRiflemanLATModule = {
				private _unit = [independent,"I_Soldier_LAT2_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				_unit addBackpack "B_AssaultPack_cbr";
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],["launch_MRAWS_sand_rail_F",["MRAWS_HEAT_F",2]],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_MDF_fnc_createSquadLeadModule = {
				private _unit = [independent,"I_Soldier_SL_F",MAZ_EZM_stanceForAI,"SAFE","SERGEANT"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_hamr","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit addBackpack "B_RadioBag_01_black_F";
				[(unitbackpack _unit),[0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]] remoteExec ['setObjectTexture',0,_unit];

				_unit
			};

			MAZ_EZM_MDF_fnc_createSurvivorModule = {
				private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				removeVest _unit;
				removeHeadgear _unit;
				[_unit,""] remoteExec ["switchMove"];
				_unit
			};

			MAZ_EZM_MDF_fnc_createUAVOpModule = {
				private _unit = [independent,"I_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				_unit setUnitLoadout [[],[],[],[],[],[],"","",[],["ItemMap","I_UavTerminal","ItemRadio","ItemCompass","ItemWatch",""]];
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				[_unit,["arifle_Mk20_plain_F",["30Rnd_556x45_Stanag",5],["optic_holosight","acc_flashlight"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3] call MAZ_EZM_fnc_addItemAndWeapons;
				_unit addBackpack "I_UAV_01_backpack_F";

				_unit
			};

		comment "Planes";

			MAZ_EZM_MDF_fnc_createGryphonModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Plane_Fighter_04_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
				[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach [
					"a3\air_f_jets\plane_fighter_04\data\fighter_04_fuselage_01_co.paa",
					"a3\air_f_jets\plane_fighter_04\data\fighter_04_fuselage_02_co.paa",
					"a3\air_f_jets\plane_fighter_04\data\fighter_04_misc_01_co.paa",
					format ["a3\air_f_jets\plane_fighter_04\data\numbers\fighter_04_number_0%1_ca.paa", selectRandom [0,1,2,3,4,5,6,7,8,9]],
					format ["a3\air_f_jets\plane_fighter_04\data\numbers\fighter_04_number_0%1_ca.paa", selectRandom [0,1,2,3,4,5,6,7,8,9]],
					format ["a3\air_f_jets\plane_fighter_04\data\numbers\fighter_04_number_0%1_ca.paa", selectRandom [0,1,2,3,4,5,6,7,8,9]]
				];
				
				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_MDF_fnc_createPilotModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

	comment "FIA+";

		comment "APCs";

			MAZ_EZM_FIAP_fnc_createGorgonModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_APC_Wheeled_03_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				private _camo = selectRandom ["Guerilla_01","Guerilla_02","Guerilla_03"];
				[
					_vehicle,
					[_camo,1], 
					["showCamonetHull",1,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",0]
				] call BIS_fnc_initVehicle;

				_vehicle disableTIEquipment true;
               
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

				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_APC_Wheeled_03_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				private _turret = createVehicle ["I_LT_01_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				_vehicle animate ["HideTurret",1];

				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;
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
               
			   	if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule;
					_driver moveInDriver _vehicle;
					_driver setUnloadInCombat [false, false];

					private _commander = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule;
					_commander moveInCommander _vehicle;
					_commander setUnloadInCombat [false, false];

					private _gunner = [] call MAZ_EZM_FIAP_fnc_createCrewmanModule;
					_gunner moveInCommander _turret;
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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_C_Boat_Transport_02_F",_pos,[],0,"CAN_COLLIDE"];
				
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;
				
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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Boat_Transport_01_F",_pos,[],0,"CAN_COLLIDE"];
				
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;
				
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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_F",_pos,[],0,"CAN_COLLIDE"];
				private _turret = createVehicle ["I_Mortar_01_F",_pos,[],0,"CAN_COLLIDE"];
				private _box = createVehicle ["Box_Syndicate_WpsLaunch_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;
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

				_vehicle
			};

			MAZ_EZM_FIAP_fnc_createOffroadCoveredModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["C_Offroad_01_covered_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["C_Offroad_01_covered_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_armed_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_AT_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_C_Offroad_02_unarmed_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_C_Offroad_02_LMG_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_C_Offroad_02_AT_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Quadbike_01_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
			
		comment "Drones";
            
			MAZ_EZM_FIAP_fnc_createDarterModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_UAV_01_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
                private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
                private _vehicle = createVehicle ["C_IDAP_UAV_06_antimine_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				{_x setunitpos "AUTO"} foreach units _squadLead
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
				{_x setunitpos "AUTO"} foreach units _squadLead
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
				{_x setunitpos "AUTO"} foreach units _squadLead
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
				{_x setunitpos "AUTO"} foreach units _squadLead
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
				{_x setunitpos "AUTO"} foreach units _squadLead
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

				[_unit,(selectRandom _greekVoice)] remoteExec ['setSpeaker',0,_unit];
				[_unit,(selectRandom _FIAPHeads)] remoteExec ['setFace',0,_unit];

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
				private _unit = [east,"O_G_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
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
				private _unit = [east,"O_G_Soldier_AR_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
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
				private _unit = [east,"O_G_medic_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
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
				private _unit = [east,"O_G_medic_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
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
				private _unit = [east,"O_G_engineer_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
				[_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit;
				private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit;
				[_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;
				_unit
			};

			MAZ_EZM_FIAP_fnc_createSquadLeadModule = {
				private _unit = [east,"O_G_Soldier_SL_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

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
				private _unit = [east,"O_G_Soldier_GL_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit;
				private _pGrenadier = selectRandom ["arifle_Mk20_GL_plain_F","arifle_Mk20_GL_F","arifle_TRG21_GL_F"];
				[_unit,[_pGrenadier,["30Rnd_556x45_Stanag",5],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1],["1Rnd_HE_Grenade_shell",6],["1Rnd_Smoke_Grenade_shell",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_FIAP_fnc_createMarksmanModule = {
				private _unit = [east,"O_G_Soldier_M_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit;
                private _pSniper = selectRandom [ "srifle_DMR_06_camo_F","srifle_DMR_06_olive_F","srifle_DMR_06_hunter_F"];
				[_unit,[_pSniper,["20Rnd_762x51_Mag",5],[]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons; 

				_unit
			};

			MAZ_EZM_FIAP_fnc_createMissileSpecAAModule = {
				private _unit = [east,"O_G_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

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
				private _unit = [east,"O_G_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
			    [_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPGogglesToUnit;
				private _weaponInfo = [_unit] call MAZ_EZM_FIAP_fnc_getFIAPWeaponToUnit;
				[_unit,[_weaponInfo select 0,[_weaponInfo select 1,6],["optic_ACO_grn"]],[],["hgun_ACPC2_F",["9Rnd_45ACP_Mag",2]],3,[["HandGrenade",1]]] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_FIAP_fnc_createRiflemanLATModule = {
				private _unit = [east,"O_G_Soldier_LAT_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

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
				private _unit = [east,"O_G_Soldier_LAT_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

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
				private _unit = [east,"O_G_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

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
				private _unit = [east,"O_G_Survivor_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_FIAP_fnc_addFIAPUniformToUnit;
				[_unit] spawn MAZ_EZM_FIAP_fnc_addFIAPIdentitiesToUnit;

				removeVest _unit;
				removeHeadgear _unit;
				[_unit,""] remoteExec ["switchMove"];

				_unit
			};
			
		comment "Tanks";

		    MAZ_EZM_FIAP_fnc_createAANyxModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_LT_01_AA_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				[
					_vehicle,
					["Indep_Olive",1], 
					["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",0]
				] call BIS_fnc_initVehicle;

				_vehicle disableTIEquipment true;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_LT_01_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				[
					_vehicle,
					["Indep_Olive",1], 
					["showTools",1,"showCamonetHull",1,"showBags",1,"showSLATHull",0]
				] call BIS_fnc_initVehicle;

				_vehicle disableTIEquipment true;

				_vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]];
				_vehicle addMagazineTurret ["60Rnd_20mm_HE_shells",[0]];
				_vehicle removeWeaponTurret ["LMG_coax_ext", [0]];

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_ammo_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_fuel_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_medical_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_box_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_transport_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_covered_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_FIAP_fnc_createTruckModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_G_Van_01_transport_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["Van_01_adds_IG_01_CO.paa","Van_02_adds_IG_01_CO.paa","Van_03_adds_IG_01_CO.paa","Van_04_adds_IG_01_CO.paa","Van_05_adds_IG_01_CO.paa","Van_06_adds_IG_01_CO.paa","Van_07_adds_IG_01_CO.paa","Van_01_adds_IG_08_CO.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_FIAP_fnc_createFuelTruckModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_G_Van_01_fuel_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["van_01_tank_ig_03_co.paa","van_01_tank_ig_02_co.paa","van_01_tank_ig_01_co.paa"];

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};

				_vehicle
			};
			
		comment "Turrets";

		    MAZ_EZM_FIAP_fnc_createM2HMGModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_HMG_02_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule;
					_gunner moveInGunner _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_FIAP_fnc_createM2HMGRaisedModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_HMG_02_high_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule;
					_gunner moveInGunner _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_FIAP_fnc_createMk6MortarModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Mortar_01_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule;
					_gunner moveInGunner _vehicle;
				};

				_vehicle
			};

			MAZ_EZM_FIAP_fnc_createAALauncherModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_static_AA_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _gunner = [] call MAZ_EZM_FIAP_fnc_createRiflemanModule;
					_gunner moveInGunner _vehicle;
				};

				_vehicle
			};

		comment "Vans";
        
		    MAZ_EZM_FIAP_fnc_createVanModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Van_02_vehicle_F",_pos,[],0,"CAN_COLLIDE"];
				
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Van_02_transport_F",_pos,[],0,"CAN_COLLIDE"];
				
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_E_Van_02_medevac_F",[24668.3,18863.8,-4.76837e-007],[],0,"CAN_COLLIDE"];

				_vehicle setPosWorld [24668.3,18863.8,4.84614];
				_vehicle setVectorDirAndUp [[0,1,0],[0,0,1]];

                private _crystal1 = createVehicle ["UserTexture1m_F",[24669.3,18863.2,1.923],[],0,"CAN_COLLIDE"];
				_crystal1 setObjectTextureGlobal [0,"a3\data_f\red_crystal_ca.paa"];
				_crystal1 setPosWorld [24669.31,18863.2,5.113];
	            _crystal1 setVectorDirAndUp [[-0.595419,-0.00108918,-0.0739945],[-0.0739946,0,0.59542]];
				[_crystal1, _vehicle] call BIS_fnc_attachToRelative;
				_crystal1 setObjectScale 0.6;

				private _crystal2 = createVehicle ["UserTexture1m_F",[24667.3,18863.2,1.909],[],0,"CAN_COLLIDE"];
				_crystal2 setObjectTextureGlobal [0,"a3\data_f\red_crystal_ca.paa"];
				_crystal2 setPosWorld [24667.29,18863.2,5.099];
	            _crystal2 setVectorDirAndUp [[0.595708,-2.62268e-008,-0.0716351],[0.0716351,0,0.595708]];
				[_crystal2, _vehicle] call BIS_fnc_attachToRelative;
				_crystal2 setObjectScale 0.6;
				
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

				[
					_vehicle,
					["FIA3",1], 
					["Door_1_source",0,"Door_2_source",0,"Door_3_source",0,"Door_4_source",0,"Hide_Door_1_source",0,"Hide_Door_2_source",0,"Hide_Door_3_source",0,"Hide_Door_4_source",0,"lights_em_hide",0,"ladder_hide",1,"spare_tyre_holder_hide",1,"spare_tyre_hide",1,"reflective_tape_hide",1,"roof_rack_hide",1,"LED_lights_hide",1,"sidesteps_hide",1,"rearsteps_hide",1,"side_protective_frame_hide",0,"front_protective_frame_hide",0,"beacon_front_hide",0,"beacon_rear_hide",0]
				] call BIS_fnc_initVehicle;
				
				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_FIAP_fnc_createMedicModule;
					_driver moveInDriver _vehicle;
				};

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa","a3\soft_f_orange\van_02\data\van_wheel_co.paa","a3\soft_f_orange\van_02\data\van_glass_fia_02_unfinished_ca.paa","a3\soft_f_orange\van_02\data\van_body_fia_03_co.paa"];
				
				_vehicle setpos _pos;
				
				_vehicle
			};
	comment "CTRG+";
	
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
				private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

                [_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
				[_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
				(selectRandom [
					["LMG_03_F","200Rnd_556x45_Box_F",2],
					["arifle_MX_SW_Black_F","100Rnd_65x39_caseless_black_mag",4],
					["arifle_SPAR_02_blk_F","150Rnd_556x45_Drum_Mag_F",4]
				]) params ["_unitWeapon","_unitMag","_unitMagCount"];
				private _optic = selectRandom ["optic_MRCO","optic_Holosight_blk_F","optic_ACO","optic_HAMR"];
				[_unit,[_unitWeapon,[_unitMag,_unitMagCount],[_optic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_CTRGP_fnc_createGrenadierModule = {
				private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

                [_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
				[_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
				(selectRandom [
					["arifle_SPAR_01_GL_blk_F","30Rnd_556x45_Stanag","1Rnd_HE_Grenade_shell"],
					["arifle_MX_GL_Black_F","30Rnd_65x39_caseless_black_mag","3Rnd_HE_Grenade_shell"]
				]) params ["_grenadierWeapon","_grenadierMag","_grenadierGrenade"];
				private _optic = selectRandom ["optic_MRCO","optic_Holosight_blk_F","optic_ACO","optic_HAMR"];
				[_unit,[_grenadierWeapon,[_grenadierMag,5],[_optic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2],[_grenadierGrenade,4]]] call MAZ_EZM_fnc_addItemAndWeapons;
				
				_unit
			};

			MAZ_EZM_CTRGP_fnc_createMarksmanModule = {
				private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

                [_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
				[_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
				(selectRandom [["srifle_DMR_03_F","20Rnd_762x51_Mag"],["srifle_EBR_F","20Rnd_762x51_Mag"],["arifle_SPAR_03_blk_F","20Rnd_762x51_Mag"]]) params ["_markWeapon","_markMag"];
				private _markOptic = selectRandom ["optic_DMS","optic_KHS_blk","optic_SOS"];
				[_unit,[_markWeapon,[_markMag,5],[_markOptic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_CTRGP_fnc_createRiflemanModule = {
				private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

                [_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
				[_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
				private _pWeapon = selectRandom [["arifle_MX_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_MXM_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_SPAR_01_blk_F", "30Rnd_556x45_Stanag"]];
				private _optic = selectRandom ["optic_MRCO","optic_Holosight_blk_F","optic_ACO","optic_HAMR"];
				[_unit,[_pWeapon select 0,[_pWeapon select 1,5],[_optic,"acc_pointer_ir"]],[],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;
				
				_unit
			};

			MAZ_EZM_CTRGP_fnc_createRiflemanATModule = {
				private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

                [_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
				[_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
				_unit addBackpackGlobal "B_Kitbag_rgr";
				private _pWeapon = selectRandom [["arifle_MX_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_MXM_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_SPAR_01_blk_F", "30Rnd_556x45_Stanag"]];
				private _optic = selectRandom ["optic_MRCO","optic_Holosight_blk_F","optic_ACO","optic_HAMR"];
				[_unit,[_pWeapon select 0,[_pWeapon select 1,5],[_optic,"acc_pointer_ir"]],["launch_NLAW_F",["NLAW_F",3]],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;

				_unit
			};

			MAZ_EZM_CTRGP_fnc_createRiflemanLATModule = {
				private _unit = [west,"B_Soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;

                [_unit] call MAZ_EZM_fnc_removeAllClothing;
				[_unit] call MAZ_EZM_CTRGP_fnc_addCTRGPUniformToUnit;
				[_unit] spawn MAZ_EZM_CTRGP_fnc_addCTRGIdentitiesToUnit;
				_unit addBackpackGlobal "B_Kitbag_rgr";
				private _pWeapon = selectRandom [["arifle_MX_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_MXM_Black_F", "30Rnd_65x39_caseless_black_mag"], ["arifle_SPAR_01_blk_F", "30Rnd_556x45_Stanag"]];
				private _optic = selectRandom ["optic_MRCO","optic_Holosight_blk_F","optic_ACO","optic_HAMR"];
				[_unit,[_pWeapon select 0,[_pWeapon select 1,5],[_optic,"acc_pointer_ir"]],["launch_MRAWS_green_F",["MRAWS_HEAT_F",3]],["hgun_Pistol_heavy_01_F",["11Rnd_45ACP_Mag",2],["optic_MRD"]],3,[["HandGrenade",2]]] call MAZ_EZM_fnc_addItemAndWeapons;
				_unit addItemToBackpack "MRAWS_HE_F";

				_unit
			};

	comment "CSAT (African)";
		comment "Anti-Air";
		comment "APCs";
		comment "Artillery";

			MAZ_EZM_AFR_fnc_createZamakMRLModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_E_Truck_02_MRL_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Boat_Transport_01_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle
			};			

		comment "Cars";

			MAZ_EZM_AFR_fnc_createIfritModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_MRAP_02_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle
			};			

			MAZ_EZM_AFR_fnc_createIfritHMGModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_MRAP_02_hmg_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_LSV_02_AT_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_LSV_02_armed_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_LSV_02_unarmed_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle	
			};	

			MAZ_EZM_AFR_fnc_createQuadModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["C_Quadbike_01_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle
			};		

			MAZ_EZM_AFR_fnc_createZamakAmmoModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Truck_02_Ammo_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle	
			};	

			MAZ_EZM_AFR_fnc_createZamakFuelModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Truck_02_fuel_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle	
			};	

			MAZ_EZM_AFR_fnc_createZamakMedicalModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Truck_02_medical_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle	
			};	

			MAZ_EZM_AFR_fnc_createZamakRepairModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Truck_02_box_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle	
			};	

			MAZ_EZM_AFR_fnc_createZamakTransportModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Truck_02_transport_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle	
			};				


			MAZ_EZM_AFR_fnc_createZamakTransportCoveredModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Truck_02_covered_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createRiflemanModule;
					_driver moveInDriver _vehicle;
				};
				_vehicle	
			};							
		comment "Helicopters";
		
			MAZ_EZM_AFR_fnc_createTaruModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Transport_04_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Transport_04_ammo_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Transport_04_bench_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Transport_04_box_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Transport_04_fuel_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Transport_04_medevac_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Transport_04_repair_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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

			MAZ_EZM_AFR_fnc_createTaruTransportModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Transport_04_covered_black_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Light_02_unarmed_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				_vehicle disableTIEquipment true;

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
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_Heli_Light_02_v2_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				_vehicle disableTIEquipment true;

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

			comment "Appearance";
	
				MAZ_EZM_AFR_fnc_addAFRUniformToUnit = {
					params ["_unit"];
					private _AFRUniforms = [];
					private _AFRVests = [];
					private _AFRHeadgear = [];
					private _AFRGoggles = [];
					
					_unit forceAddUniform (selectRandom _AFRUniforms);
					_unit addVest (selectRandom _AFRVests);
					_unit addHeadgear (selectRandom _AFRHeadgear);
					_unit addGoggles (selectRandom _AFRGoggles);
				};

				MAZ_EZM_AFR_fnc_addAFRIdentitiesToUnit = {
					params ["_unit"];
					sleep 0.5;
					private _africanVoice = [

					];
					private _africanHeads = [

					];

					[_unit,(selectRandom _africanVoice)] remoteExec ['setSpeaker',0,_unit];
					[_unit,(selectRandom _africanHeads)] remoteExec ['setFace',0,_unit];
					if(goggles _unit == "G_Combat") then {
						removeGoggles _unit;
					};
				};

			comment "Men";

				MAZ_EZM_AFR_fnc_createAmmoBearerModule = {
					private _unit = [east,"O_A_soldier_A_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createAutoriflemanModule = {
					private _unit = [east,"O_A_soldier_AR_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createATRiflemanModule = {
					private _unit = [east,"O_A_soldier_AT_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createRiflemanModule = {
					private _unit = [east,"O_A_soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createMedicModule = {
					private _unit = [east,"O_A_medic_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createOfficerModule = {
					private _unit = [east,"O_A_officer_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createMissleAAModule = {
					private _unit = [east,"O_A_soldier_AA_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createGrenadierModule = {
					private _unit = [east,"O_A_soldier_GL_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createLATRiflemanModule = {
					private _unit = [east,"O_A_soldier_LAT_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createMarksmanModule = {
					private _unit = [east,"O_A_soldier_M_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};		

				MAZ_EZM_AFR_fnc_createSquadLeaderModule = {
					private _unit = [east,"O_A_soldier_SL_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};			

				MAZ_EZM_AFR_fnc_createTeamLeaderModule = {
					private _unit = [east,"O_A_soldier_TL_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit
				};

				MAZ_EZM_AFR_fnc_createCrewmanModule = {
					private _unit = [east,"O_A_soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit setUnitLoadout [["arifle_Katiba_C_F","","","",["30Rnd_65x39_caseless_green",30],[],""],[],[],["U_O_officer_noInsignia_hex_F",[["FirstAidKit",1],["30Rnd_65x39_caseless_green",3,30]]],["V_BandollierB_cbr",[["Chemlight_red",2,1]]],[],"H_Tank_black_F","G_Lowprofile",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
					_unit
				};

				MAZ_EZM_AFR_fnc_createHeliPilotModule = {
					private _unit = [east,"O_A_soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit setUnitLoadout [["arifle_Katiba_C_F","","","",["30Rnd_65x39_caseless_green",30],[],""],[],[],["U_O_officer_noInsignia_hex_F",[["FirstAidKit",1],["30Rnd_65x39_caseless_green",3,30]]],["V_TacVest_brn",[["Chemlight_red",2,1]]],[],"H_PilotHelmetHeli_B","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
					_unit
				};

				MAZ_EZM_AFR_fnc_createHeliCrewModule = {
					private _unit = [east,"O_A_soldier_F",MAZ_EZM_stanceForAI,"SAFE"] call MAZ_EZM_fnc_createMan;
					_unit setUnitLoadout [["arifle_Katiba_C_F","","","",["30Rnd_65x39_caseless_green",30],[],""],[],[],["U_O_officer_noInsignia_hex_F",[["FirstAidKit",1],["30Rnd_65x39_caseless_green",3,30]]],["V_TacVest_brn",[["Chemlight_red",2,1]]],[],"H_CrewHelmetHeli_B","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
					_unit
				};

		comment "Tanks";

			MAZ_EZM_AFR_fnc_createT100Module = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["O_MBT_02_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				[_vehicle] call MAZ_EZM_fnc_addObjectToInterface;

				_vehicle disableTIEquipment true;

				if(MAZ_EZM_spawnWithCrew) then {
					private _driver = [] call MAZ_EZM_AFR_fnc_createCrewmanModule;
					_driver moveInDriver _vehicle;

					private _gunner = [] call MAZ_EZM_AFR_fnc_createCrewmanModule;
					_gunner moveInGunner _vehicle;

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
				{_x setunitpos "AUTO"} foreach units _squadLead
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
				{_x setunitpos "AUTO"} foreach units _squadLead
			};

	comment "Pylon Editor";

		ZAM_EZM_fnc_editVehiclePylons = {
			params ["_veh"];
			private _pylons = [];
			{
				if(_x find "pylon" != -1 && _x find "proxy" != -1) then {
					_pylons pushBack _x;
				};
			}forEach (_veh selectionNames "FireGeometry");

			private _pylonSlotsUnfiltered = (configFile >> "CfgVehicles" >> typeOf _veh >> "Components" >> "TransportPylonsComponent" >> "Pylons") call BIS_fnc_getCfgSubClasses;
			private _pylonSlots = [];
			{
				if((toLower _x) find "bay" == -1) then {
					_pylonSlots pushBack _x;
				};
			}forEach _pylonSlotsUnfiltered;
			private _pylonsNew = [];
			{
				private _numberOfPylon = _x splitString ".";
				private _pylonIndex = -1;
				if(count _numberOfPylon != 2) then {} else {
					_pylonIndex = (parseNumber (_numberOfPylon # 1)) - 1;
					if(_pylonIndex <= (count _pylonSlots -1)) then {
						_pylonsNew set [_pylonIndex,_veh selectionPosition _x]; 
					};
				};
			}forEach _pylons;


			private _currentMags = getPylonMagazines _veh;
			private _pylonWeapons = [];
			private _pylonDisplayNames = [];

			{
				private _pylon = _x;
				private _compatMags = _veh getCompatiblePylonMagazines _x;
				private _temp = [];
				{
					_temp pushBack (getText (configFile >> "CfgMagazines" >> _x >> "displayName"));
				}forEach _compatMags;
				_pylonWeapons pushBack _compatMags;
				_pylonDisplayNames pushBack _temp;
			}forEach _pylonSlots;

			private _display = findDisplay 312;
			private _controls = [];
			{
				private _control = _display ctrlCreate ["RscCombo",-1];
				_control setVariable ["pylonEditorPylon",_x];
				private _pylonNames = _pylonDisplayNames select _forEachIndex;
				private _pylonConfigNames = _pylonWeapons select _forEachIndex;
				private _currentMag = _currentMags select _forEachIndex;
				private _indexPylon = _pylonConfigNames find _currentMag;
				{
					private _index = _control lbAdd _x;
					_control lbSetData [_index,_pylonConfigNames select _forEachIndex];
				}forEach _pylonNames;
				_control setVariable ["pylonEditorVehicle",_veh];
				_control ctrlAddEventHandler ["LBSelChanged",{
					params ["_control", "_selectedIndex"];
					private _vehicle = _control getVariable 'pylonEditorVehicle';
					private _pylonSlot = _control getVariable "pylonEditorPylon";
					private _pylonNew = _control lbData _selectedIndex;
					private _pylonMaxAmmo = getNumber (configFile >> "CfgMagazines" >> _pylonNew >> "count");
					_vehicle setPylonLoadout [_pylonSlot,_pylonNew];
					_vehicle setAmmoOnPylon [_pylonSlot,_pylonMaxAmmo];
				}];
				_control lbSetCurSel _indexPylon;

				_controls pushBack _control;
			}forEach _pylonSlots;

			if(!isNil "MAZ_updateEachFramePylons") then {
				private _pylonEditorControls = player getVariable ["pylonEditorControls",[]];
				{
					ctrlDelete _x;
				}forEach _pylonEditorControls;
				player setVariable ["pylonEditorControls",[]];
				[MAZ_updateEachFramePylons,"onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			};
			player setVariable ["pylonEditorControls",_controls];

			MAZ_updateEachFramePylons = ["MAZ_updatePylonsEachFrame","onEachFrame",{
				params ["_vehicle","_pylons","_controls"];
				if(isNull findDisplay 312) exitWith {
					[MAZ_updateEachFramePylons,"onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				};

				if(curatorCamera distance _vehicle > 125) then {
					[MAZ_updateEachFramePylons,"onEachFrame"] call BIS_fnc_removeStackedEventHandler;
					{ctrlDelete _x} forEach _controls;
				};

				{
					private _control = _controls select _forEachIndex;

					private _position = _vehicle modelToWorldVisual _x;
					private _distance = curatorCamera distance _position;
					private _screenPos = worldToScreen _position;

					if(_screenPos isEqualTo [] || {_distance > 75}) then {
						_control ctrlShow false;
					} else {
						_control ctrlShow true;

						_screenPos params ["_posX","_posY"];

						private _size = linearConversion [0,100,_distance,1.75,1,true];
						private _posW = ["W",(_size*4)] call MAZ_EZM_fnc_convertToGUI_GRIDFormat;
						private _posH = ["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat;

						_control ctrlSetPosition [_posX - _posW / 2, _posY - _posH / 2,_posW,_posH];
						_control ctrlCommit 0;
					};
				} forEach _pylons;

			},[_veh,_pylonsNew,_controls]] call BIS_fnc_addStackedEventHandler;
		};

	comment "Area Markers";

		MAZ_EZM_fnc_createAreaMarker = {
			if(!visibleMap) exitWith {["Cannot place a marker without the map open!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;};
			private _position = [] call MAZ_EZM_fnc_getScreenPosition;
			if(isNil "MAZ_EZM_areaMarkers") then {
				MAZ_EZM_areaMarkers = [];
				publicVariable 'MAZ_EZM_areaMarkers';
			};
			private _marker = createMarker [format ["ZAM_EZM_marker_%1",count MAZ_EZM_areaMarkers],_position];
			_marker setMarkerSize [50,50];
			_marker setMarkerShape "ELLIPSE";
			MAZ_EZM_areaMarkers pushBack _marker;
			publicVariable 'MAZ_EZM_areaMarkers';
			[_marker] call MAZ_EZM_fnc_createEditAreaMarkerDialog;
		};

		MAZ_EZM_fnc_editAreaMarker = {
			params ["_marker","_values"];
			_values params ["_markerText","_markerPos","_markerSize","_markerBrush","_markerColor","_markerShape"];
			_marker setMarkerText _markerText;
			_marker setMarkerPos _markerPos;
			_marker setMarkerSize _markerSize;
			_marker setMarkerBrush _markerBrush;
			_marker setMarkerColor _markerColor;
			_marker setMarkerShape (["ELLIPSE","RECTANGLE"] select _markerShape);
		};

		MAZ_EZM_fnc_createEditAreaMarkerDialog = {
			params ["_marker"];
			(getMarkerSize _marker) params ["_sizeX","_sizeY"];
			(getMarkerPos _marker) params ["_posX","_posY"];
			private _markerShapeSelect = [false,true] select (markerShape _marker == "RECTANGLE");
			private _dataList = [];
			{
				private _color = getArray (configFile >> "CfgMarkerColors" >> _x >> "color");
				if([0,0,0,1] isEqualTo _color) then {_color = [1,1,1,1]};
				if((_color select 0) isEqualType "") then {
					{
						_color set [_forEachIndex,call (compile _x)];
					}forEach _color;
				};
				_dataList pushback [getText (configFile >> "CfgMarkerColors" >> _x >> "name"), "", "",_color];
			}forEach ["Default","ColorBlack","ColorGrey","ColorRed","ColorBrown","ColorOrange","ColorYellow","ColorKhaki","ColorGreen","ColorBlue","ColorPink","ColorWhite","ColorWest","ColorEAST","ColorGUER","ColorCIV","ColorUNKNOWN"];

			private _brushList = [];
			{
				_brushList pushBack [getText (configFile >> "CfgMarkerBrushes" >> _x >> "name"), "", getText (configFile >> "CfgMarkerBrushes" >> _x >> "texture")];
			}forEach ["Solid","SolidFull","SolidBorder","Border","Horizontal","Vertical","Grid","FDiagonal","BDiagonal","Diaggrid","Cross"];

			["Edit Area Marker",[
				[
					"EDIT",
					"Marker Text:",
					[markerText _marker]
				],
				[
					"VECTOR",
					"Position:",
					[[_posX,_posY],["X","Y"],2]
				],
				[
					"VECTOR",
					"Size:",
					[[_sizeX,_sizeY],["X","Y"],2]
				],
				[
					"COMBO",
					"Marker Brush:",
					[
						["Solid","SolidFull","SolidBorder","Border","Horizontal","Vertical","Grid","FDiagonal","BDiagonal","Diaggrid","Cross"],
						_brushList,
						(["Solid","SolidFull","SolidBorder","Border","Horizontal","Vertical","Grid","FDiagonal","BDiagonal","Diaggrid","Cross"] find (markerBrush _marker))
					]
				],
				[
					"COMBO",
					"Marker Color:",
					[
						["Default","ColorBlack","ColorGrey","ColorRed","ColorBrown","ColorOrange","ColorYellow","ColorKhaki","ColorGreen","ColorBlue","ColorPink","ColorWhite","ColorWest","ColorEAST","ColorGUER","ColorCIV","ColorUNKNOWN"],
						_dataList,
						(["Default","ColorBlack","ColorGrey","ColorRed","ColorBrown","ColorOrange","ColorYellow","ColorKhaki","ColorGreen","ColorBlue","ColorPink","ColorWhite","ColorWest","ColorEAST","ColorGUER","ColorCIV","ColorUNKNOWN"] find (markerColor _marker))
					]
				],
				[
					"TOOLBOX",
					"Marker Shape:",
					[_markerShapeSelect,[["ELLIPSE","Circle marker type."],["RECTANGLE","Rectangle marker type."]]]
				]
			],{
				params ["_values","_args","_display"];
				[_args,_values] call MAZ_EZM_fnc_editAreaMarker;
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},_marker] call MAZ_EZM_fnc_createDialog;
		};

	comment "Collapse Expand Trees";

		MAZ_EZM_fnc_collapseAllTrees = {
			private _display = (findDisplay 312);
			{
				for '_n' from 0 to 50 do {
					(_display displayCtrl _x) tvCollapse [_n];
				};
			} forEach [270,271,272,273,274,275,276,277,278,280];
		};

		MAZ_EZM_fnc_expandAllTrees = {
			private _display = (findDisplay 312);
			{
				for '_n' from 0 to 50 do {
					(_display displayCtrl _x) tvExpand [_n];
				};
			} forEach [270,271,272,273,274,275,276,277,278,280];
		};

	comment "End";

};
[] call MAZ_EZM_fnc_initFunction;

JAM_MAZ_EZM_editZeusInterface = {
	comment " 👽 ";
	if (isNull (findDisplay 312)) exitWith {};
	private _fnc_editInterface = {
		disableSerialization;
		with uiNamespace do {
			private _display = displayNull;
			_display = findDisplay 312;
			if(isNull _display) exitWith {};
			
			if (M9SD_serverEZM) then {
				comment "hide zeus watermark";
				
				_display displayAddEventHandler ['KeyDown', {
					if (_this select 1 == 14) then { 
						comment "backspace";
						private _display = findDisplay 312;
						[_display] spawn {
							params [['_display', displayNull]];
							uiSleep 0.01;
							if (isNull _display) exitWith {};
							private _ctrl = _display displayCtrl 15717;
							_ctrl ctrlShow false;
						};
					};
				}];
			} else {
				comment "Re-Color Zeus Watermark";
			
				_display displayAddEventHandler ['KeyDown', {
					if (_this select 1 == 14) then {
						private _display = findDisplay 312;
						[_display] spawn {
							params [['_display', displayNull]];
							uiSleep 0.01;
							if (isNull _display) exitWith {};
							(_display displayCtrl 15717) ctrlSetTextColor [0,0.6,0.6,0.7];
						};
					};
				}];
			};
			
			comment "Transparency & Function Defines";

				missionNamespace setVariable ['MAZ_zeusModulesWithFunction', []];
				private _transparency = profilenamespace getVariable ['JAM_zeusTransparency_currentValue', 100];
				_transparency = _transparency / 100;
				[_transparency] call (missionNamespace getvariable ['JAM_GUIfnc_setZeusTransparency', {}]);

				MAZ_EZM_fnc_zeusAddCategory = {
					params [
						['_parentTree', findDisplay 312 displayCtrl 280],
						['_categoryName', '[ Category ]'],
						['_iconPath', '\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa'],
						['_textColor', [1,1,1,1]],
						['_toolTip', '']
					];
					private _pindex = _parentTree tvAdd [[], _categoryName];
					_parentTree tvSetPictureRight [[_pindex], _iconPath];
					_parentTree tvSetColor [[_pindex], _textColor];
					_parentTree tvSetTooltip [[_pindex], _toolTip];
					_pindex;
				};
				
				_EZM_fnc_zeusAddCategory = MAZ_EZM_fnc_zeusAddCategory;

				MAZ_EZM_fnc_zeusAddSubCategory = {
					params [
						['_parentTree', findDisplay 312 displayCtrl 280],
						['_parentCategory', 1],
						['_categoryName', '[ Subcategory ]'],
						['_iconPath', '\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa']
					];
					private _cindex = _parentTree tvAdd [[_parentCategory], _categoryName];
					_parentTree tvSetPictureRight [[_parentCategory,_cindex], _iconPath];
					_cindex;
				};

				MAZ_EZM_fnc_zeusAddModule = {
					params [
						['_parentTree', findDisplay 312 displayCtrl 280],
						['_parentCategory', 1],
						['_moduleName', '[ Module ]'],
						['_moduleTip', '[ Placeholder ]'],
						['_moduleFunction', 'JAM_fnc_nullFunction'],
						['_iconPath', '\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa'],
						['_textColor', [1,1,1,1]],
						['_iconColor', [1,1,1,1]],
						['_iconColorSelected', [0,0,0,1]],
						['_iconColorDisabled', [0.8,0,0,0.8]]
					];
					
					comment "Setup functions";
					private _functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
					private _functionCount = count _functionArray; 
					private _functionIndex = 7000 + (_functionCount + 1);
					private _moduleTip = format ['%1\n\nFunction ID:\n%2', _moduleTip, str _functionIndex];
					_functionArray pushBack [_functionIndex, _moduleFunction];
					missionNamespace setVariable ['MAZ_zeusModulesWithFunction', _functionArray];
					
					comment "Add modules";
					private _cindex = _parentTree tvAdd [[_parentCategory], _moduleName];
					private _path = [_parentCategory,_cindex];
					_parentTree tvSetTooltip [_path,_moduleTip];
					_parentTree tvSetPicture [_path, _iconPath];
					_parentTree tvSetData [_path, 'ModuleEmpty_F'];
					_parentTree tvSetPictureColor [_path, _iconColor];
					_parentTree tvSetColor [_path, _textColor];
					comment "_parentTree tvSetPictureColorSelected [_path, _iconColorSelected];";
					comment "_parentTree tvSetPictureColorDisabled [_path, _iconColorDisabled];";
					_parentTree ctrlCommit 0;
					_path;
				};
				
				_EZM_fnc_zeusAddModule = MAZ_EZM_fnc_zeusAddModule;

				MAZ_EZM_fnc_zeusAddModule_BLUFOR = {
					params [
						['_parentTree', findDisplay 312 displayCtrl 280],
						['_parentCategory', 1],
						['_parentSubcategory',1],
						['_moduleName', '[ Module ]'],
						['_moduleTip', '[ Placeholder ]'],
						['_moduleFunction', 'JAM_fnc_nullFunction'],
						['_iconPath', '\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa'],
						['_textColor', [1,1,1,1]],
						['_iconColor', [1,1,1,1]],
						['_iconColorSelected', [0,0,0,1]],
						['_iconColorDisabled', [0.8,0,0,0.8]]
					];
					
					comment "Setup functions";
					_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
					private _functionCount = count _functionArray; 
					private _functionIndex = 7000 + (_functionCount + 1);
					private _moduleTip = format ['%1\n\nFunction ID:\n%2', _moduleTip, str _functionIndex];
					_functionArray pushBack [_functionIndex, _moduleFunction];
					missionNamespace setVariable ['MAZ_zeusModulesWithFunction', _functionArray];
					
					comment "Add modules";
					private _cindex = _parentTree tvAdd [[_parentCategory,_parentSubcategory], _moduleName];
					private _path = [_parentCategory,_parentSubcategory,_cindex];
					_parentTree tvSetTooltip [_path,_moduleTip];
					_parentTree tvSetPicture [_path, _iconPath];
					_parentTree tvSetData [_path, 'B_Soldier_VR_F'];
					_parentTree tvSetPictureColor [_path, _iconColor];
					_parentTree tvSetColor [_path, _textColor];
					comment "_parentTree tvSetPictureColorSelected [_path, _iconColorSelected];";
					comment "_parentTree tvSetPictureColorDisabled [_path, _iconColorDisabled];";
					_parentTree ctrlCommit 0;
					_path;
				};

				MAZ_EZM_fnc_zeusAddModule_OPFOR = {
					params [
						['_parentTree', findDisplay 312 displayCtrl 280],
						['_parentCategory', 1],
						['_parentSubcategory',1],
						['_moduleName', '[ Module ]'],
						['_moduleTip', '[ Placeholder ]'],
						['_moduleFunction', 'JAM_fnc_nullFunction'],
						['_iconPath', '\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa'],
						['_textColor', [1,1,1,1]],
						['_iconColor', [1,1,1,1]],
						['_iconColorSelected', [0,0,0,1]],
						['_iconColorDisabled', [0.8,0,0,0.8]]
					];
					
					comment "Setup functions";
					_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
					private _functionCount = count _functionArray; 
					private _functionIndex = 7000 + (_functionCount + 1);
					private _moduleTip = format ['%1\n\nFunction ID:\n%2', _moduleTip, str _functionIndex];
					_functionArray pushBack [_functionIndex, _moduleFunction];
					missionNamespace setVariable ['MAZ_zeusModulesWithFunction', _functionArray];
					
					comment "Add modules";
					private _cindex = _parentTree tvAdd [[_parentCategory,_parentSubcategory], _moduleName];
					private _path = [_parentCategory,_parentSubcategory,_cindex];
					_parentTree tvSetTooltip [_path,_moduleTip];
					_parentTree tvSetPicture [_path, _iconPath];
					_parentTree tvSetData [_path, 'O_Soldier_VR_F'];
					_parentTree tvSetPictureColor [_path, _iconColor];
					_parentTree tvSetColor [_path, _textColor];
					comment "_parentTree tvSetPictureColorSelected [_path, _iconColorSelected];";
					comment "_parentTree tvSetPictureColorDisabled [_path, _iconColorDisabled];";
					_parentTree ctrlCommit 0;
					_path;
				};

				MAZ_EZM_fnc_zeusAddModule_INDEP = {
					params [
						['_parentTree', findDisplay 312 displayCtrl 280],
						['_parentCategory', 1],
						['_parentSubcategory',1],
						['_moduleName', '[ Module ]'],
						['_moduleTip', '[ Placeholder ]'],
						['_moduleFunction', 'JAM_fnc_nullFunction'],
						['_iconPath', '\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa'],
						['_textColor', [1,1,1,1]],
						['_iconColor', [1,1,1,1]],
						['_iconColorSelected', [0,0,0,1]],
						['_iconColorDisabled', [0.8,0,0,0.8]]
					];
					
					comment "Setup functions";
					_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
					private _functionCount = count _functionArray; 
					private _functionIndex = 7000 + (_functionCount + 1);
					private _moduleTip = format ['%1\n\nFunction ID:\n%2', _moduleTip, str _functionIndex];
					_functionArray pushBack [_functionIndex, _moduleFunction];
					missionNamespace setVariable ['MAZ_zeusModulesWithFunction', _functionArray];
					
					comment "Add modules";
					private _cindex = _parentTree tvAdd [[_parentCategory,_parentSubcategory], _moduleName];
					private _path = [_parentCategory,_parentSubcategory,_cindex];
					_parentTree tvSetTooltip [_path,_moduleTip];
					_parentTree tvSetPicture [_path, _iconPath];
					_parentTree tvSetData [_path, 'I_Soldier_VR_F'];
					_parentTree tvSetPictureColor [_path, _iconColor];
					_parentTree tvSetColor [_path, _textColor];
					comment "_parentTree tvSetPictureColorSelected [_path, _iconColorSelected];";
					comment "_parentTree tvSetPictureColorDisabled [_path, _iconColorDisabled];";
					_parentTree ctrlCommit 0;
					_path;
				};

				MAZ_EZM_fnc_zeusAddModule_CIVILIAN = {
					params [
						['_parentTree', findDisplay 312 displayCtrl 280],
						['_parentCategory', 1],
						['_parentSubcategory',1],
						['_moduleName', '[ Module ]'],
						['_moduleTip', '[ Placeholder ]'],
						['_moduleFunction', 'JAM_fnc_nullFunction'],
						['_iconPath', '\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa'],
						['_textColor', [1,1,1,1]],
						['_iconColor', [1,1,1,1]],
						['_iconColorSelected', [0,0,0,1]],
						['_iconColorDisabled', [0.8,0,0,0.8]]
					];
					
					comment "Setup functions";
					_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
					private _functionCount = count _functionArray; 
					private _functionIndex = 7000 + (_functionCount + 1);
					private _moduleTip = format ['%1\n\nFunction ID:\n%2', _moduleTip, str _functionIndex];
					_functionArray pushBack [_functionIndex, _moduleFunction];
					missionNamespace setVariable ['MAZ_zeusModulesWithFunction', _functionArray];
					
					comment "Add modules";
					private _cindex = _parentTree tvAdd [[_parentCategory,_parentSubcategory], _moduleName];
					private _path = [_parentCategory,_parentSubcategory,_cindex];
					_parentTree tvSetTooltip [_path,_moduleTip];
					_parentTree tvSetPicture [_path, _iconPath];
					_parentTree tvSetData [_path, 'C_Soldier_VR_F'];
					_parentTree tvSetPictureColor [_path, _iconColor];
					_parentTree tvSetColor [_path, _textColor];
					comment "_parentTree tvSetPictureColorSelected [_path, _iconColorSelected];";
					comment "_parentTree tvSetPictureColorDisabled [_path, _iconColorDisabled];";
					_parentTree ctrlCommit 0;
					_path;
				};

				MAZ_EZM_fnc_addZeusPreviewEvents = {
					private _zeusDisplay = findDisplay 312;
					if (isNull _zeusDisplay) exitWith {};
					if (_zeusDisplay getVariable ['MAZ_zeusPreviewInitialized', false]) exitWith {};
					private _idcs = [270,271,272,273,274];
					{
						private _ctrl = _zeusDisplay displayCtrl _x;
						_ctrl ctrlAddEventHandler ['TreeMouseMove',{
							params ['_control', '_path'];
							private _data = _control tvData _path;
							private _img = getText (configfile >> 'CfgVehicles' >> _data >> 'editorPreview');
							if (_data == '' || _img == '') then {
								with uiNamespace do {
									{
										_x ctrlShow false;
									} forEach MAZ_zeusPreviewCtrls;
								};
							} else {
								getMousePosition params ['_mouseX', '_mouseY'];
								_mouseY = _mouseY - 0.11;
								(getTextureInfo _img) params ["_width","_height"];
								private _ratio = (_width / _height);
								private _posEdgeX = switch (getResolution # 5) do {
									case 0.47 : {52.5};
									case 0.55 : {47.5};
									case 0.7 : {42.5};
									case 0.85 : {37.5};
									case 1 : {32.5};
									default {47.5};
								};
								private _previewImage = uiNamespace getVariable "MAZ_ctrl_previewImage";
								private _previewBackground = uiNamespace getVariable "MAZ_ctrl_previewBackground";
								private _previewFrame = uiNamespace getVariable "MAZ_ctrl_previewFrame";
    							_previewImage ctrlSetPositionW (["W",(5.5 * _ratio)] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
								_previewImage ctrlSetPositionX (["X",((_posEdgeX - 0.5) - (5.5*_ratio))] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
								_previewImage ctrlSetPositionY (_mouseY + 0.019);
								_previewImage ctrlSetText _img;
								_previewImage ctrlCommit 0;

								{
									_x ctrlSetPositionW (["W",(5.5 * _ratio) + 1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
									_x ctrlSetPositionX (["X",((_posEdgeX - 1) - (5.5*_ratio))] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
									_x ctrlSetPositionY _mouseY;
									_x ctrlCommit 0;
								}forEach [_previewBackground,_previewFrame];

								(ctrlPosition _previewBackground) params ["","_posY","","_posH"];
								private _extendsTooLow = (_posY + _posH) > (["Y",35] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
								private _modifyPos = (_posY + _posH) - (["Y",35] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
								if(_extendsTooLow) then {
									{
										comment "35 Y pos";
										private _y = (ctrlPosition _x) select 1;
										_x ctrlSetPositionY (_y - _modifyPos);
									}forEach [_previewImage,_previewBackground,_previewFrame];
								};
								
								{
									_x ctrlShow true;
									_x ctrlCommit 0;
								} forEach [_previewImage,_previewBackground,_previewFrame];
							};
						}];
						_ctrl ctrlAddEventHandler ['TreeMouseExit',{
							params ['_control'];
							with uiNamespace do {
								{
									_x ctrlShow false;
								} forEach MAZ_zeusPreviewCtrls;
							};
						}];
					} forEach _idcs;
					_zeusDisplay getVariable ['MAZ_zeusPreviewInitialized', true];
				};

				MAZ_EZM_fnc_zeusPreviewImage = {
					with uiNamespace do {
						_display = findDisplay 312;
						MAZ_ctrl_previewBackground = _display ctrlCreate ['RscPicture', 1200];
						MAZ_ctrl_previewBackground ctrlSetText '#(argb,8,8,3)color(0,0,0,0.6)';
						MAZ_ctrl_previewBackground ctrlSetPosition [["X",32.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["Y",28] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["W",15] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",6.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
						MAZ_ctrl_previewBackground ctrlCommit 0;
						MAZ_ctrl_previewImage = _display ctrlCreate ['RscPicture', 1201];
						MAZ_ctrl_previewImage ctrlSetText '#(argb,8,8,3)color(0,0,0,0)';
						MAZ_ctrl_previewImage ctrlSetPosition [["X",33] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["Y",28.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["W",14] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",5.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
						MAZ_ctrl_previewImage ctrlCommit 0;
						MAZ_ctrl_previewFrame = _display ctrlCreate ['RscFrame', 1800];
						MAZ_ctrl_previewFrame ctrlSetPosition [["X",32.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["Y",28] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["W",15] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",6.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
						MAZ_ctrl_previewFrame ctrlCommit 0;
						MAZ_zeusPreviewCtrls = [
							MAZ_ctrl_previewBackground,
							MAZ_ctrl_previewImage,
							MAZ_ctrl_previewFrame
						];
						{
							_x ctrlShow false;
						} forEach MAZ_zeusPreviewCtrls;
					};
				};

				MAZ_EZM_fnc_drawEventhandlerAreaMarkers = {
					private _ctrlMap  = findDisplay 312 displayCtrl 50;
					_ctrlMap ctrlAddEventHandler ["Draw",{
						params ["_map"];
						{
							if((markerShape _x == "ELLIPSE") || (markerShape _x == "RECTANGLE")) then {
								private _color = getArray (configFile >> "CfgMarkerColors" >> markerColor _x >> "color");
								if((_color select 0) isEqualType "") then {
									{
										_color set [_forEachIndex,call (compile _x)];
									}forEach _color;
								};
								_map drawIcon ["\a3\3den\data\cfg3den\marker\texturecenter_ca.paa",_color,getMarkerPos _x,10,10,0];
							};
						}forEach allMapMarkers;
					}];
				};

			comment "Quality of Life Stuff";

				MAZ_EZM_fnc_addCollapseExpandButtons = {
					private _display = (findDisplay 312);
					private _zeusSearchBar = _display displayCtrl 283;
					private _zeusSearchButton = _display displayCtrl 646;
					(ctrlPosition _zeusSearchBar) params ["_searchPosX","_searchPosY","_searchPosW","_searchPosH"];
					_zeusSearchBar ctrlSetPositionW (_searchPosW - (["W",2.2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
					_zeusSearchBar ctrlCommit 0;

					private _ctrlGroup = ctrlParentControlsGroup _zeusSearchButton;
					(ctrlPosition _zeusSearchButton) params ["_searchButtonPosX","_searchButtonPosY","_searchButtonPosW","_searchButtonPosH"];
					_zeusSearchButton ctrlSetPositionX (_searchButtonPosX - (["W",2.2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
					_zeusSearchButton ctrlCommit 0;

					private _zeusCollapse = _display ctrlCreate ["RscActivePicture",-1,_ctrlGroup];
					_zeusCollapse ctrlSetText "a3\3den\data\displays\display3den\tree_collapse_ca.paa";
					_zeusCollapse ctrlSetTextColor [1,1,1,0.8];
					_zeusCollapse ctrlSetActiveColor [1,1,1,1];
					_zeusCollapse ctrlSetBackgroundColor [0,0,0,0.5];
					_zeusCollapse ctrlSetPosition [(_searchButtonPosX - (["W",1.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)),_searchButtonPosY,_searchButtonPosW,_searchButtonPosH];
					_zeusCollapse ctrlAddEventHandler ["ButtonClick",{
						[] call MAZ_EZM_fnc_collapseAllTrees;
					}];
					_zeusCollapse ctrlCommit 0;

					private _zeusExpand = _display ctrlCreate ["RscActivePicture",-1,_ctrlGroup];
					_zeusExpand ctrlSetText "a3\3den\data\displays\display3den\tree_expand_ca.paa";
					_zeusExpand ctrlSetTextColor [1,1,1,0.8];
					_zeusExpand ctrlSetActiveColor [1,1,1,1];
					_zeusExpand ctrlSetBackgroundColor [0,0,0,0.5];
					_zeusExpand ctrlSetPosition [_searchButtonPosX,_searchButtonPosY + (["Y",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),_searchButtonPosW,_searchButtonPosH - (["Y",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
					_zeusExpand ctrlAddEventHandler ["ButtonClick",{
						[] call MAZ_EZM_fnc_expandAllTrees;
					}];
					_zeusExpand ctrlCommit 0;
				};
				[] call MAZ_EZM_fnc_addCollapseExpandButtons;

				MAZ_EZM_fnc_removeFactionStuffFromEmpty = {
					private _display = (findDisplay 312);
					private _civilianUnitTree = (_display displayCtrl 274);
					private _factionNames = ["AAF","Civilians","CSAT","CSAT (Pacific)","CTRG","FIA","Gendarmerie","IDAP","LDF","NATO","NATO (Pacific)","NATO (Woodland)","Syndikat"];
					private _treePaths = [];
					for '_n' from 0 to 40 do {
						private _text = _civilianUnitTree tvText [_n];
						if(_text in _factionNames) then {
							_treePaths pushBack _n;
						};
					};
					{
						_civilianUnitTree tvDelete [_x - _forEachIndex];
					}forEach _treePaths;
				};
				[] call MAZ_EZM_fnc_removeFactionStuffFromEmpty;

				MAZ_EZM_fnc_addSpawnWithoutCrewButton = {
					private _display = (findDisplay 312);
					private _spawnBannerCtrl = (_display displayCtrl 270);
					private _ctrlGroup = ctrlParentControlsGroup _spawnBannerCtrl;
					(ctrlPosition _spawnBannerCtrl) params ["_posX","_posY","_posW","_posH"];
					private _yPosButton = _posY + _posH - (["H",1.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);

					private _zeusCheckBoxBG = _display ctrlCreate ["RscPicture",-1,_ctrlGroup];
					_zeusCheckBoxBG ctrlSetText "#(argb,8,8,3)color(0.18,0.19,0.21,1)"; 
					_zeusCheckBoxBG ctrlSetPosition [_posX,_yPosButton - (["H",0.2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),_posW,["H",1.2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
					_zeusCheckBoxBG ctrlEnable false;
					_zeusCheckBoxBG ctrlCommit 0;

					private _zeusCheckBoxFrame = _display ctrlCreate ["RscFrame",-1,_ctrlGroup];
					_zeusCheckBoxFrame ctrlSetTextColor [0,0,0,1];
					_zeusCheckBoxFrame ctrlSetPosition [_posX,_yPosButton - (["H",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),_posW,["H",1.2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
					_zeusCheckBoxFrame ctrlEnable false;
					_zeusCheckBoxFrame ctrlCommit 0;
					
					private _zeusCheckBoxText = _display ctrlCreate ["RscText",-1,_ctrlGroup];
					_zeusCheckBoxText ctrlSetText "Spawn vehicles with crew";
					_zeusCheckBoxText ctrlSetTextColor [1,1,1,1];
					_zeusCheckBoxText ctrlSetPosition [(_posX + (["W",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)),_yPosButton - (["H",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),_posW - (["W",1.2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
					_zeusCheckBoxText ctrlEnable false;
					_zeusCheckBoxText ctrlCommit 0;

					private _zeusCheckBox = _display ctrlCreate ["RscCheckbox",-1,_ctrlGroup];
					_zeusCheckBox ctrlSetTextColor [1,1,1,0.8];
					_zeusCheckBox ctrlSetActiveColor [1,1,1,1];
					_zeusCheckBox cbSetChecked (missionNamespace getVariable ["MAZ_EZM_spawnWithCrew",true]);
					_zeusCheckBox ctrlSetPosition [(_posX + (["W",0.1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)),_yPosButton,["W",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
					_zeusCheckBox ctrlAddEventHandler ["ButtonClick",{
						if(MAZ_EZM_spawnWithCrew) then {
							MAZ_EZM_spawnWithCrew = false;
						} else {
							MAZ_EZM_spawnWithCrew = true;
						};
					}];
					_zeusCheckBox ctrlCommit 0;

					{
						(ctrlPosition (_display displayCtrl _x)) params ["","_posY","","_posH"];
						(_display displayCtrl _x) ctrlSetPositionH (_posH - (["H",1.2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat));
						(_display displayCtrl _x) ctrlCommit 0;
					} forEach [270,271,272,273,274,275,276,277,278,280];
				};
				[] call MAZ_EZM_fnc_addSpawnWithoutCrewButton;

			comment "Warning System";

				MAZ_EZM_fnc_getActiveWarnings = {
					private _count = 0;
					{
						if(_x select 2) then {_count = _count + 1;}
					}forEach (uiNamespace getVariable ["MAZ_EZM_activeWarnings",[]]);
					_count
				};

				MAZ_EZM_fnc_addWarningElement = {
					params ["_text",["_icon","A3\UI_F\Data\Map\Markers\Military\warning_ca.paa"],["_color",[1,0,0,1]]];

					with uiNamespace do {
						private _warningPicture = (findDisplay 312) ctrlCreate ["RscPicture",-1];
						_warningPicture ctrlSetPosition [["X",46] call MAZ_EZM_fnc_convertToGUI_GRIDFormat, ["Y",-8] call MAZ_EZM_fnc_convertToGUI_GRIDFormat, ["W",1.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
						_warningPicture ctrlSetText _icon;
						_warningPicture ctrlSetTooltip _text;
						_warningPicture ctrlSetTextColor _color;
						_warningPicture ctrlSetPositionY (["Y",-8 + (2 * ([] call MAZ_EZM_fnc_getActiveWarnings))] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
						_warningPicture ctrlCommit 0;

						playSound "addItemFailed";

						MAZ_EZM_activeWarnings pushBack [_warningPicture,[_text,_icon,_color],true];
					};
				};

				MAZ_EZM_fnc_removeWarningElement = {
					params ["_warningIndex"];
					private _warningData = (uiNamespace getVariable ["MAZ_EZM_activeWarnings",[]]) select _warningIndex;
					_warningData params ["_warningPicture","_warningInfo","_isActive"];
					(uiNamespace getVariable ["MAZ_EZM_activeWarnings",[]]) set [_warningIndex,[_warningPicture,_warningInfo,false]];
					ctrlDelete _warningPicture;
					private _count = 0;
					{
						_x params ["_ctrl","_warningInfo","_isActive"];
						if(!_isActive) then {continue};
						_ctrl ctrlSetPositionY (["Y",-8 + (2 * _count)] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
						_ctrl ctrlCommit 0;
						_count = _count + 1;
					}forEach (uiNamespace getVariable ["MAZ_EZM_activeWarnings",[]]);
				};

				MAZ_EZM_fnc_showAllWarnings = {
					if(count (uiNamespace getVariable ["MAZ_EZM_activeWarnings",[]]) < 0) exitWith {};
					if(isNull (findDisplay 312)) exitWith {};
					with uiNamespace do {
						private _count = 0;
						{
							_x params ["_ctrl","_warningInfo","_isActive"];
							_warningInfo params ["_text","_icon","_color"];
							if(!_isActive) then {continue};
							private _ctrl = (findDisplay 312) ctrlCreate ["RscPicture",-1];
							_ctrl ctrlSetPosition [["X",46] call MAZ_EZM_fnc_convertToGUI_GRIDFormat, ["Y",-8] call MAZ_EZM_fnc_convertToGUI_GRIDFormat, ["W",1.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat,["H",1.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat];
							_ctrl ctrlSetText _icon;
							_ctrl ctrlSetTooltip _text;
							_ctrl ctrlSetTextColor _color;
							_ctrl ctrlSetPositionY (["Y",-8 + (2 * _count)] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);
							_ctrl ctrlCommit 0;
							_count = _count + 1;

							MAZ_EZM_activeWarnings set [_forEachIndex,[_ctrl,_warningInfo,_isActive]];
						}forEach MAZ_EZM_activeWarnings;
					};
				};

				[] call MAZ_EZM_fnc_showAllWarnings;

				MAZ_EZM_fnc_detectRespawnsUnavailable = {
					with uiNamespace do {
						private _warningText = "";
						private _sideStrings = ["BLUFOR","OPFOR","INDEPENDENT","CIVILIAN"];
						{
							private _sideOf = _x;
							private _numPlayers = {side (group _x) == _sideOf} count allPlayers;
							if(_numPlayers <= 0) then {continue};

							private _respawnCountSide = count ([_sideOf] call BIS_fnc_getRespawnPositions);
							if(_respawnCountSide != 0) then {continue};

							_warningText = _warningText + "There is no respawn for " + (_sideStrings select _forEachIndex) + " players!\n";
						}forEach [west,east,independent,civilian];

						if(_warningText == "") exitWith {
							if(!isNil "MAZ_EZM_missingRespawnWarn") then {
								[MAZ_EZM_missingRespawnWarn] call MAZ_EZM_fnc_removeWarningElement;
								MAZ_EZM_missingRespawnWarn = nil;
							};
						};

						if(!isNil "MAZ_EZM_missingRespawnWarn") exitWith {
							private _currentWarnText = MAZ_EZM_activeWarnings select MAZ_EZM_missingRespawnWarn select 1 select 0;
							if(_currentWarnText != _warningText) then {
								[MAZ_EZM_missingRespawnWarn] call MAZ_EZM_fnc_removeWarningElement;
								MAZ_EZM_missingRespawnWarn = [_warningText] call MAZ_EZM_fnc_addWarningElement;
							};
						};

						MAZ_EZM_missingRespawnWarn = [_warningText] call MAZ_EZM_fnc_addWarningElement;
					};
				};

				[] spawn {
					while {!isNull (findDisplay 312)} do {
						[] call MAZ_EZM_fnc_detectRespawnsUnavailable;
						sleep 3;
					};
				};

			comment "Define Trees";
			
				MAZ_UnitsTree_BLUFOR	 = (_display displayCtrl 270);
				MAZ_UnitsTree_OPFOR		 = (_display displayCtrl 271);
				MAZ_UnitsTree_INDEP		 = (_display displayCtrl 272);
				MAZ_UnitsTree_CIVILIAN	 = (_display displayCtrl 273);
				MAZ_UnitsTree_EMPTY      = (_display displayCtrl 274);
				MAZ_zeusModulesTree 	 = (_display displayCtrl 280);
				
				_UnitsTree_BLUFOR = MAZ_UnitsTree_BLUFOR;
				_UnitsTree_OPFOR = MAZ_UnitsTree_OPFOR;
				_UnitsTree_INDEP = MAZ_UnitsTree_INDEP;
				_UnitsTree_CIVILIAN = MAZ_UnitsTree_CIVILIAN;
				_UnitsTree_EMPTY = MAZ_UnitsTree_EMPTY;
				_zeusModulesTree = MAZ_zeusModulesTree;
				
				for '_n' from 0 to 32 do 
				{
					_UnitsTree_BLUFOR tvCollapse [_n];
					_UnitsTree_OPFOR tvCollapse [_n];
					_UnitsTree_INDEP tvCollapse [_n];
					_UnitsTree_CIVILIAN tvCollapse [_n];
					_UnitsTree_EMPTY tvCollapse [_n];
					_zeusModulesTree tvCollapse [_n];
					comment "
						MAZ_GroupsTree_BLUFOR tvCollapse [_n];
						MAZ_GroupsTree_OPFOR tvCollapse [_n];
						MAZ_GroupsTree_INDEP tvCollapse [_n];
						MAZ_GroupsTree_CIVILIAN tvCollapse [_n];
					";
				};
				
				{
					_x ctrlSetEventHandler ["TreeSelChanged","[(_this select 1)] call MAZ_EZM_fnc_updateModuleSelection"];
				} forEach [MAZ_UnitsTree_BLUFOR,MAZ_UnitsTree_OPFOR,MAZ_UnitsTree_INDEP,MAZ_UnitsTree_CIVILIAN,MAZ_UnitsTree_EMPTY,MAZ_zeusModulesTree];

			comment "Add Divider";

				[MAZ_zeusModulesTree,"------------------------------------------------------","",EZM_trimColor] call MAZ_EZM_fnc_zeusAddCategory;

				if (M9SD_serverEZM) then {
					MAZ_EZMLabelTree = [_zeusModulesTree,"Enhanced Zeus Modules:",'\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa',EZM_trimColor] call _EZM_fnc_zeusAddCategory;
					_zeusModulesTree tvSetPictureRightColor [[MAZ_EZMLabelTree], EZM_trimColor];
					[
						_zeusModulesTree,
						MAZ_EZMLabelTree,
						format ["CREDITS",missionNamespace getVariable ['MAZ_EZM_LiteVersion','']],
						"GamesByChris, M9-SD, & Expung3d",
						"MAZ_EZM_fnc_hiddenEasterEggModule"
					] call _EZM_fnc_zeusAddModule;
				} else {
					
					MAZ_EZMLabelTree = [_zeusModulesTree,"Enhanced Zeus Modules (Lite)",'\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa',EZM_trimColor] call _EZM_fnc_zeusAddCategory;
					_zeusModulesTree tvSetPictureRightColor [[MAZ_EZMLabelTree], EZM_trimColor];
					[
						_zeusModulesTree,
						MAZ_EZMLabelTree,
						format ["ZAM Edition - %1",missionNamespace getVariable ['MAZ_EZM_LiteVersion','']],
						"Originally created by: M9-SD & GamesByChris\nAdapted by: Expung3d to enhance Public Zeus.",
						"MAZ_EZM_fnc_hiddenEasterEggModule"
					] call _EZM_fnc_zeusAddModule;
				};
				
				[MAZ_zeusModulesTree,"------------------------------------------------------","",EZM_trimColor] call MAZ_EZM_fnc_zeusAddCategory;
			
			comment "AI Modifers";
				MAZ_EditAITree = [
					MAZ_zeusModulesTree,
					"AI Modifiers",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\intel_ca.paa'
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Easy Mode",
					"Decreases difficulty and makes AI stand.",
					"MAZ_EZM_fnc_easyModeModule",
					'\A3\ui_f\data\IGUI\Cfg\mptable\infantry_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Garrison (Instant)",
					"Places AI's group in randomized position in nearest building.",
					"MAZ_EZM_fnc_garrisonInstantModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Garrison (Search)",
					"Places AI's group in randomized position in nearest building.",
					"MAZ_EZM_fnc_garrisonSearchModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\getin_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Un-Garrison",
					"Removes AI from their garrisoned position.",
					"MAZ_EZM_fnc_unGarrisonModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\getout_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Edit AI Equipment",
					"Remove or equip AI with NVGs or flashlights.",
					"MAZ_EZM_fnc_removeNVGsAddFlashlightsModule",
					"a3\ui_f\data\igui\cfg\actions\gear_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Enable AI Lasers",
					"Makes AI turn on their lasers and lights.",
					"MAZ_EZM_fnc_toggleLightsModule",
					"a3\ui_f_curator\data\cfgcurator\laser_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Disable AI Lasers",
					"Makes AI turn off their lasers and lights.",
					"MAZ_EZM_fnc_toggleOffLightsModule",
					"a3\ui_f\data\map\markers\military\dot_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Make Hostage",
					"Makes AI into a restrained hostage.",
					"MAZ_EZM_fnc_makeHostageModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\help_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Make HVT",
					"Makes AI an HVT that, when killed, everyone will be notified.",
					"MAZ_EZM_fnc_makeHVTModule",
					"a3\modules_f_curator\data\portraitobjectiveneutralize_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;
				
				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Set Ambient Animation",
					"Set Ambient Animations",
					"MAZ_EZM_fnc_setAmbientAnimationModule",
					"a3\ui_f_curator\data\rsccommon\rscattributepunishmentanimation\pushupslegs.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Set Difficulty",
					"Adjust all AI's difficulty.",
					"MAZ_EZM_fnc_changeDifficultyModule",
					'\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_stand_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Set Stance",
					"Makes AI forced into stance mode. i.e. prone, crouch, standing, auto.",
					"MAZ_EZM_fnc_changeStanceModule",
					'\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_stand_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Suppressive Fire",
					"Makes the AI suppress the position you select.",
					"MAZ_EZM_fnc_suppressiveFireModule",
					"a3\static_f_oldman\hmg_02\data\ui\icon_hmg_02_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Toggle Unit Carelessness",
					"Makes the unit careless or uncareless, ignores contact and doesn't engage.",
					"MAZ_EZM_fnc_toggleCarelessModule",
					"a3\ui_f_curator\data\rsccommon\rscattributebehaviour\safe_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EditAITree,
					"Toggle Unit Surrender",
					"Makes AI surrender or un-surrender.",
					"MAZ_EZM_fnc_toggleSurrenderModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\help_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "AI Supports";
				MAZ_AISupportTree = [
					MAZ_zeusModulesTree,
					"AI Supports",
					"a3\modules_f_curator\data\portraitradio_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_AISupportTree,
					"Airdrop",
					"Calls an airdrop to module position.",
					"MAZ_EZM_fnc_callAirdropModule",
					"a3\air_f_beta\parachute_01\data\ui\portrait_parachute_01_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_AISupportTree,
					"Evac Helicopter",
					"HOW TO USE:\n1: Place module on position to which a helicopter will fly and land to pickup players.\n2: Select secondary position that the helicopter will drop them off at.",
					"MAZ_EZM_fnc_callEvacModule",
					"a3\air_f\heli_light_01\data\ui\map_heli_light_01_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_AISupportTree,
					"Call Reinforcements",
					"HOW TO USE:\n1: Place module on position to which a helicopter will fly and drop off troops.\n2: Select reinforcements parameters in menu.\n3: Select secondary position that reinforcements will move to on foot.",
					"MAZ_EZM_fnc_callReinforcements",
					'\A3\ui_f\data\gui\rsc\rscdisplayarsenal\radio_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Arsenal (s)";

				MAZ_ArsenalTree = [
					MAZ_zeusModulesTree,
					"Arsenal Creator",
					'\A3\ui_f\data\Logos\a_64_ca.paa'
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				MAZ_zeusModulesTree tvSetTooltip [[MAZ_ArsenalTree], ""];
				
				[
					MAZ_zeusModulesTree,
					MAZ_ArsenalTree,
					"Full Arsenal *",
					"----------------------------------------------------------------------------------------------------------------------------------------------------------------------\nFull Arsenal (by Expung3d)\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------\n\nDescription:\n There are two ways to use this module:\n(1) Place onto another object to make it a full arsenal.\n(2) Place on ground to spawn supply box full arsenal.\n\nIncludes the following options:\n- Open Full Arsenal\n- Save Respawn Loadout\n\n* Warning: Incompatible with AIO arsenal by M9-SD.",
					"MAZ_EZM_fnc_createArsenalModule",
					'\A3\ui_f\data\Logos\a_64_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				if (M9SD_serverEZM || TRUE) then 
				{
					[
						MAZ_zeusModulesTree,
						MAZ_ArsenalTree,
						"AIO Arsenal *",
						"----------------------------------------------------------------------------------------------------------------------------------------------------------------------\nAll-In-One Arsenal (by M9-SD)\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------\n\nDescription:\n There are two ways to use this module:\n(1) Place onto another object to make it an AIO arsenal.\n(2) Place on ground to spawn supply box AIO arsenal.\n\nIncludes the following options:\n- Full Arsenal\n- Quick Rearm\n- Copy Loadout\n- Empty Loadout\n- Save Respawn Loadout\n- Load Respawn Loadout\n- Delete Respawn Loadout\n- Edit Group Loadouts\n\n* Warning: Incompatible with full arsenal by Expung3d.",
						"JAM_EZM_fnc_createAIOArsenalModule",
						'\A3\ui_f\data\Logos\a_64_ca.paa'
					] call MAZ_EZM_fnc_zeusAddModule;
				};

			comment "Automatic Missions";

				MAZ_AutoMissionTree = [
					MAZ_zeusModulesTree,
					"Automatic Missions",
					"a3\ui_f\data\map\markers\military\objective_ca.paa",
					[1,1,1,1],
					"Automated Missions that can be spawned on different maps."
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_AutoMissionTree,
					"Auto Heli Crash (On)",
					"Enables randomized helicopter crash missions.\nWill spawn and last for 15 minutes before despawning.\nAfter a mission despawns or is completed another will spawn in 10 minutes.",
					"MAZ_EZM_fnc_createRandomHelicrashModule",
					"a3\modules_f_curator\data\portraitobjectiveneutralize_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_AutoMissionTree,
					"Auto Heli Crash (Off)",
					"Disables randomized helicopter crash missions.",
					"MAZ_EZM_fnc_turnOffRandomHelicrashModule",
					"a3\ui_f\data\map\markers\military\objective_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_AutoMissionTree,
					"Auto Convoy Mission (On)",
					"Enables randomized convoy missions.\nPlayers must capture the truck moving within the convoy.\nWill spawn and last until killed or reaching its destination.\nAfter a mission despawns or is completed another will spawn in 10 minutes.",
					"MAZ_EZM_fnc_createRandomConvoyModule",
					"a3\modules_f_curator\data\portraitobjectivemove_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_AutoMissionTree,
					"Auto Convoy Mission (Off)",
					"Disables randomized convoy missions.",
					"MAZ_EZM_fnc_turnOffRandomConvoyModule",
					"a3\ui_f\data\map\markers\military\objective_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_AutoMissionTree,
					"Auto Garrison Town",
					"Automatically garrisons a named town or the town where the module is placed.",
					"MAZ_EZM_fnc_createGarrisonTownDialog",
					"a3\modules_f_curator\data\portraitobjectiveneutralize_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Cinematic Modules";
			
				COMMENT "  
				
					~*` POOF! `*~   
				
				";
				
			comment "Clean Up Stuff";
				MAZ_CleanUpTree = [
					MAZ_zeusModulesTree,
					"Clean-Up Tools",
					"a3\3den\data\displays\display3den\panelleft\entitylist_delete_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_CleanUpTree,
					"Delete Clutter",
					"Deletes all clutter on the ground.",
					"MAZ_EZM_fnc_deleteClutterModule",
					"a3\3den\data\displays\display3den\panelleft\entitylist_delete_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_CleanUpTree,
					"Delete Empty Groups",
					"Deletes all empty groups.",
					"MAZ_EZM_fnc_deleteEmptyGroupsModule",
					"a3\ui_f_curator\data\displays\rscdisplaycurator\modegroups_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;
				
				[
					MAZ_zeusModulesTree,
					MAZ_CleanUpTree,
					"Delete Everything",
					"Deletes all mission objects.",
					"MAZ_EZM_fnc_deleteEverythingModule",
					"a3\3den\data\displays\display3den\panelleft\entitylist_delete_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_CleanUpTree,
					"Delete Markers",
					"Deletes all markers.",
					"MAZ_EZM_fnc_deleteMarkersModule",
					"a3\3den\data\displays\display3den\panelright\submode_marker_icon_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_CleanUpTree,
					"Delete Mines",
					"Deletes all mines.",
					"MAZ_EZM_fnc_deleteMinesModule",
					"a3\ui_f_curator\data\cfgmarkers\minefieldap_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_CleanUpTree,
					"Delete Protection Zones",
					"Deletes all protection zones.",
					"MAZ_EZM_fnc_deleteProtectionZonesModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_CleanUpTree,
					"Delete Radius",
					"Deletes all objects in a radius.",
					"MAZ_EZM_fnc_deleteRadiusModule",
					"a3\3den\data\displays\display3den\panelleft\entitylist_delete_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Create/Delete Ships";
				MAZ_DeleteShipTree = [
					MAZ_zeusModulesTree,
					"Create/Delete Ships",
					"a3\ui_f\data\map\vehicleicons\iconship_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_DeleteShipTree,
					"Create Carrier",
					"When placed on a boat, creates the USS Freedom at its position.",
					"MAZ_EZM_fnc_createCarrierModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DeleteShipTree,
					"Create Destroyer",
					"When placed on a boat, creates the USS Liberty at its position.",
					"MAZ_EZM_fnc_createDestroyerModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DeleteShipTree,
					"Delete All Carriers",
					"Deletes all carriers on the map.",
					"MAZ_EZM_fnc_deleteAllCarriersModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DeleteShipTree,
					"Delete All Destroyers",
					"Deletes all destroyers on the map.",
					"MAZ_EZM_fnc_deleteAllDestroyersModule"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Developer Tools";

				MAZ_DevToolsTree = [
					MAZ_zeusModulesTree,
					"Developer Tools",
					"a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_debug_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_DevToolsTree,
					"Animation Viewer",
					"Opens the Animation Viewer, if placed on a unit it will open using that unit and its current animation.",
					"MAZ_EZM_fnc_openAnimViewerModule",
					"a3\ui_f\data\gui\cfg\keyframeanimation\iconcamera_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DevToolsTree,
					"Open Debug Console (Local)",
					"Opens the Debug Console.",
					"MAZ_EZM_fnc_debugConsoleLocalModule",
					"a3\3den\data\displays\display3den\entitymenu\findconfig_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DevToolsTree,
					"Find in Config Viewer",
					"Opens the Config Viewer to the entity's config.",
					"MAZ_EZM_fnc_showObjectConfig",
					"a3\3den\data\displays\display3den\entitymenu\findconfig_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DevToolsTree,
					"Function Viewer",
					"Opens the Function Viewer.",
					"MAZ_EZM_fnc_functionViewer",
					"a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_functions_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DevToolsTree,
					"GUI Editor",
					"Opens the GUI Editor.",
					"MAZ_EZM_fnc_openGUIEditor"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DevToolsTree,
					"Get Composition Data",
					"Copies Composition Data to Clipboard (Only works in SP).",
					"MAZ_EZM_fnc_getCompositionData"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_DevToolsTree,
					"Spawn Composition by Data",
					"Places Comp Based on Data.",
					"MAZ_EZM_fnc_createCompositionFromData"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Environment";

				MAZ_EnvironmentTree = [
					MAZ_zeusModulesTree,
					"Environment",
					"a3\modules_f_curator\data\portraitweather_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_EnvironmentTree,
					"Change Time",
					"Change the current time.",
					"MAZ_EZM_fnc_changeDateModule",
					"a3\modules_f_curator\data\portraitskiptime_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_EnvironmentTree,
					"Edit Weather Conditions",
					"Edit the current meteorological atmospheric environment conditions.",
					"MAZ_EZM_fnc_editWeatherConditionsModule",
					"a3\modules_f_curator\data\portraitweather_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Explosives";

				MAZ_ExplosivesTree = [
					MAZ_zeusModulesTree,
					"Explosives",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\destroy_ca.paa'
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_ExplosivesTree,
					"Create Minefield",
					"Create a minefield.",
					"MAZ_EZM_fnc_createMinefieldModule",
					"a3\ui_f_curator\data\cfgmarkers\minefieldap_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ExplosivesTree,
					"Create IED",
					"Create an IED.",
					"MAZ_EZM_fnc_createIEDModule",
					"a3\ui_f_curator\data\cfgmarkers\minefieldap_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Gameplay";

				MAZ_GameplayTree = [
					MAZ_zeusModulesTree,
					"Gameplay",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_GameplayTree,
					"Create Countdown",
					"Creates an on screen countdown for players of specified side.",
					"MAZ_EZM_fnc_createCountdownModule",
					"a3\ui_f\data\igui\cfg\actions\settimer_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Markers";

				[] call MAZ_EZM_fnc_drawEventhandlerAreaMarkers;
				
				MAZ_MarkersTree = [
					MAZ_zeusModulesTree,
					"Markers",
					"a3\3den\data\displays\display3den\panelright\submode_marker_icon_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_MarkersTree,
					"Create Area Marker",
					"Creates an area marker on the map position.",
					"MAZ_EZM_fnc_createAreaMarker",
					"a3\ui_f\data\map\markerbrushes\fdiagonal_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Messages";

				MAZ_MessagesTree = [
					MAZ_zeusModulesTree,
					"Messages",
					"a3\3den\data\cfg3den\comment\texture_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_MessagesTree,
					"Send Server Message",
					"Sends a server message to specific side.",
					"MAZ_EZM_fnc_sendMessageModule",
					"a3\3den\data\cfg3den\comment\texture_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_MessagesTree,
					"Send Subtitle Message",
					"Sends a subtitle message to specific side players.",
					"MAZ_EZM_fnc_sendSubtitleModule",
					"a3\3den\data\cfg3den\comment\texture_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Object Modifiers";

				MAZ_ObjectModTree = [
					MAZ_zeusModulesTree,
					"Object Modifiers",
					"a3\3den\data\displays\display3den\toolbar\widget_local_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Attach to Nearest",
					"Attaches the object to the nearest object.",
					"MAZ_EZM_fnc_attachToNearestModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Detach",
					"Detaches the object from anything it's attached to.",
					"MAZ_EZM_fnc_detachModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Edit Object Attributes",
					"Edit object attributes through an advanced menu.\nEdit textures, edit init fields, god mode, enable/disable sim, etc.",
					"MAZ_EZM_fnc_editObjectAttributesModule",
					"a3\3den\data\cfgwaypoints\scripted_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Replace w/ Simple Object",
					"Replaces the object it's placed on with a simple object to improve performance.",
					"MAZ_EZM_fnc_replaceWithSimpleObject",
					"a3\3den\data\cfgwaypoints\scripted_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Toggle Simulation",
					"Enables or disables simulation on the object.",
					"MAZ_EZM_fnc_toggleSimulationModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\danger_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Toggle Invincibility",
					"Makes the object god moded or un-god moded.",
					"MAZ_EZM_fnc_toggleInvincibleModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\kill_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Hide Object",
					"Hides the object.",
					"MAZ_EZM_fnc_hideObjectModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\scout_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Un-Hide Object",
					"Un-Hides the object.",
					"MAZ_EZM_fnc_unHideObjectModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\whiteboard_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ObjectModTree,
					"Un-Hide All Objects",
					"Un-Hides all hidden objects.",
					"MAZ_EZM_fnc_unHideObjectAllModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\whiteboard_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Player Modifiers";
				MAZ_PlayerModTree = [
					MAZ_zeusModulesTree,
					"Player Modifiers",
					"a3\ui_f\data\gui\rsc\rscdisplaymain\menu_singleplayer_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_PlayerModTree,
					"Change Side",
					"Change the side of the selected player.",
					"MAZ_EZM_fnc_changeSideModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;
				
				[
					MAZ_zeusModulesTree,
					MAZ_PlayerModTree,
					"Disarm",
					"Removes the weapons from a player.",
					"MAZ_EZM_fnc_disarmModule",
					'\a3\3den\data\displays\display3den\entitymenu\arsenal_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;
				
				[
					MAZ_zeusModulesTree,
					MAZ_PlayerModTree,
					"Heal / Revive",
					"Heal and/or revive the selected player.",
					"MAZ_EZM_fnc_healAndReviveModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\heal_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_PlayerModTree,
					"Force Eject",
					"Eject players from the selected vehicle.",
					"MAZ_EZM_fnc_forceEjectModule",
					'\A3\ui_f\data\IGUI\Cfg\actions\eject_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_PlayerModTree,
					"Mute (Disable All)",
					"Disables every player's voice chat.",
					"MAZ_EZM_fnc_muteServerModule",
					'\A3\ui_f\data\IGUI\RscIngameUI\RscDisplayChannel\MuteVON_crossed_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_PlayerModTree,
					"Un-Mute (Enable All)",
					"Enables every player's voice chat.",
					"MAZ_EZM_fnc_unmuteServerModule",
					'\A3\ui_f\data\IGUI\RscIngameUI\RscDisplayChannel\MuteVON_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Server Settings";

				MAZ_ServerSettingsTree = [
					MAZ_zeusModulesTree,
					"Server Settings",
					"a3\3den\data\displays\display3den\statusbar\server_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_ServerSettingsTree,
					"Change Side Relations",
					"Change the relations of different sides towards Independent factions.",
					"MAZ_EZM_fnc_changeSideRelationsModule",
					"a3\ui_f\data\gui\cfg\communicationmenu\attack_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ServerSettingsTree,
					"Disable Mortars",
					"Disable or enable mortars for all players.",
					"MAZ_EZM_fnc_disableMortarsModule",
					'\A3\ui_f\data\GUI\Cfg\CommunicationMenu\mortar_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;
				
				if(M9SD_serverEZM) then {
					[
						MAZ_zeusModulesTree,
						MAZ_ServerSettingsTree,
						"Gameplay Settings",
						"Toggle on/off certain scripts that affect gameplay.\nEx: Self-Revive",
						"JAM_EZM_fnc_moduleGameplaySettings",
						"\a3\3den\data\cfgwaypoints\scripted_ca.paa"
					] call MAZ_EZM_fnc_zeusAddModule;
				};
				
				[
					MAZ_zeusModulesTree,
					MAZ_ServerSettingsTree,
					"Set Respawn Timer",
					"Set the respawn timer.",
					"MAZ_EZM_fnc_setRespawnTimerModule",
					"a3\ui_f\data\igui\cfg\actions\settimer_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;
				
				[
					MAZ_zeusModulesTree,
					MAZ_ServerSettingsTree,
					"Set View Distance",
					"Sets the view distance for all players.",
					"MAZ_EZM_fnc_setViewDistance",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\scout_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;
				
				[
					MAZ_zeusModulesTree,
					MAZ_ServerSettingsTree,
					"Remove Team-Killers",
					"Removes the Team-Killer status from all players.",
					"MAZ_EZM_fnc_noTeamKillersModule",
					"a3\ui_f_curator\data\cfgmarkers\kia_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Sounds";

				MAZ_SoundsTree = [
					MAZ_zeusModulesTree,
					"Sounds",
					'\A3\ui_f\data\IGUI\RscIngameUI\RscDisplayChannel\MuteVON_ca.paa'
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_SoundsTree,
					"TBD",
					"TBD.",
					"MAZ_EZM_fnc_playSoundObjectModule",
					'\A3\ui_f\data\IGUI\RscIngameUI\RscDisplayChannel\MuteVON_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Special Effects";
				MAZ_SpecialFXTree = [
					MAZ_zeusModulesTree,
					"Special Effects",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\destroy_ca.paa'
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_SpecialFXTree,
					"Fire",
					"Creates a fire on the module position.",
					"MAZ_EZM_fnc_fireEffectModule",
					"a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_fire_in_flame_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_SpecialFXTree,
					"Smoke Pillar",
					"Creates a smoke pillar on the module position.",
					"MAZ_EZM_fnc_smokeEffectModule",
					"a3\modules_f_curator\data\portraitsmoke_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_SpecialFXTree,
					"Earthquake",
					"Creates an earthquake.",
					"MAZ_EZM_fnc_earthquakeEffectModule",
					"a3\modules_f\data\editterrainobject\icon_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_SpecialFXTree,
					"Toggle Lamps (Radius)",
					"Disables or enables lamps in a radius.",
					"MAZ_EZM_fnc_toggleLampsModule",
					"a3\3den\data\displays\display3den\toolbar\flashlight_off_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_SpecialFXTree,
					"EMP",
					"Deploys an EMP on the position.",
					"MAZ_EZM_fnc_EMPEffectModule",
					"a3\3den\data\displays\display3den\toolbar\flashlight_off_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Terrain Object Modifiers";
				MAZ_terrainObjectModTree = [
					MAZ_zeusModulesTree,
					"Terrain Object Modifiers",
					"a3\ui_f\data\igui\rscingameui\rscunitinfo\icon_terrain_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_terrainObjectModTree,
					"Edit Building Doors",
					"Allows you to open and close doors on buildings.",
					"MAZ_EZM_fnc_openDoorsModule",
					"\a3\ui_f\data\igui\cfg\actions\open_door_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_terrainObjectModTree,
					"God Mode Fences",
					"Allows you to god mode fences in a radius.",
					"MAZ_EZM_fnc_godModeFencesModule",
					"a3\modules_f\data\editterrainobject\texturechecked_wall_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_terrainObjectModTree,
					"Hide Terrain Objects (Radius)",
					"Hide terrain objects in a given radius.",
					"MAZ_EZM_fnc_hideTerrainRadiusModule",
					"a3\modules_f\data\hideterrainobjects\icon_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;
			
			comment "Teleportation";
				MAZ_TeleportTree = [
					MAZ_zeusModulesTree,
					"Teleportation",
					"a3\ui_f\data\igui\cfg\simpletasks\types\move_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_TeleportTree,
					"Teleport Self",
					"Teleport your character to the modules position.",
					"MAZ_EZM_fnc_teleportSelfModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_TeleportTree,
					"Teleport All Players",
					"Teleport all players to the modules position.",
					"MAZ_EZM_fnc_teleportAllPlayersModule",
					"a3\ui_f\data\gui\rsc\rscdisplaymain\menu_multiplayer_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_TeleportTree,
					"Teleport One Player",
					"Teleport specific player to the modules position.",
					"MAZ_EZM_fnc_teleportPlayerModule",
					"a3\ui_f\data\gui\rsc\rscdisplaymain\menu_singleplayer_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_TeleportTree,
					"Teleport Side",
					"Teleport specific side to the modules position.",
					"MAZ_EZM_fnc_teleportSideModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;
			
			comment "Utilities";
				MAZ_UtilitiesTree = [
					MAZ_zeusModulesTree,
					"Utilities",
					"a3\3den\data\cfgwaypoints\scripted_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_UtilitiesTree,
					"Add Objects to Interface",
					"Adds all objects to your zeus interface.",
					"MAZ_EZM_fnc_addObjectsToInterfaceModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_UtilitiesTree,
					"Add Objects to Interface (Radius)",
					"Adds all objects to your zeus interface within a radius.",
					"MAZ_EZM_fnc_addObjectsToInterfaceRadiusModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;
				
				[
					MAZ_zeusModulesTree,
					MAZ_UtilitiesTree,
					"Toggle Auto-Add to Interface",
					"Adds all objects to your zeus interface when you open it.",
					"MAZ_EZM_fnc_toggleAutoAddToInterface",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Vehicle Modifiers";
				MAZ_VehicleModTree = [
					MAZ_zeusModulesTree,
					"Vehicle Modifiers",
					"a3\ui_f\data\igui\cfg\vehicletoggles\engineiconon_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

				[
					MAZ_zeusModulesTree,
					MAZ_VehicleModTree,
					"Unflip Vehicle",
					"Unflip the vehicle the module is placed on.",
					"MAZ_EZM_fnc_unflipVehicleModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_VehicleModTree,
					"Rearm",
					"Rearm the vehicle.",
					"MAZ_EZM_fnc_rearmVehicleModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_VehicleModTree,
					"Refuel",
					"Refuel the vehicle.",
					"MAZ_EZM_fnc_refuelVehicleModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\refuel_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_VehicleModTree,
					"Repair",
					"Repair the vehicle.",
					"MAZ_EZM_fnc_repairVehicleModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Zeus Preview";
				[] call MAZ_EZM_fnc_zeusPreviewImage;
				[] call MAZ_EZM_fnc_addZeusPreviewEvents;
			
			comment "Better Civilians";
				
				MAZ_BetterCivsTree = [
					MAZ_UnitsTree_CIVILIAN,
					"Better Civilians",
					"a3\ui_f\data\gui\rsc\rscdisplaymain\menu_multiplayer_ca.paa"
				] call MAZ_EZM_fnc_zeusAddCategory;

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
					"MAZ_EZM_fnc_createBetterCivilianModule",
					"\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule_CIVILIAN;

				[
					MAZ_UnitsTree_CIVILIAN,
					MAZ_BetterCivsTree,
					MAZ_BetterCivsMenTree,
					"Journalist",
					"Creates a journalist with randomized clothing.",
					"MAZ_EZM_fnc_createBetterCivilianJournoModule",
					"\A3\ui_f\data\Map\VehicleIcons\iconMan_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule_CIVILIAN;

			comment "MDF";

				MAZ_MDFTree = [
					MAZ_UnitsTree_INDEP,
					"Malden Defense Force",
					"A3\Data_F_argo\logos\arma3_argo_icon_ca.paa"
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
						'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'
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
						"A-149 Gryphon",
						"Creates a MDF Gryphon.",
						"MAZ_EZM_MDF_fnc_createGryphonModule",
						"\A3\Air_F_Jets\Plane_Fighter_04\Data\UI\Fighter04_icon_ca.paa"
					] call MAZ_EZM_fnc_zeusAddModule_INDEP;

			comment "FIA+";

				private _UnitsTree_OPFOR = MAZ_UnitsTree_OPFOR;
				private _count = _UnitsTree_OPFOR tvCount [2];
				for "_i" from 0 to (_count - 1) do {
					_UnitsTree_OPFOR tvDelete [2,0];
				};

				MAZ_FIAPTree = 2;
				MAZ_UnitsTree_OPFOR tvSetText [[MAZ_FIAPTree],"FIA+"];
				MAZ_UnitsTree_OPFOR tvSetPictureRight [[MAZ_FIAPTree], "\a3\data_f\cfgfactionclasses_civ_ca.paa"];
				MAZ_UnitsTree_OPFOR tvSetTooltip [[MAZ_FIAPTree], "A remastered version of the FIA faction."];

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
						"Rhib Boat",
						"Creates a FIA Rhib Boats",
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
						""
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
						"Radioman",
						"Creates a FIA Radioman.",
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
						"Fuel Truck",
						"Creates a FIA Fuel Truck.",
						"MAZ_EZM_FIAP_fnc_createFuelTruckModule",
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

			comment "CTRG+";

				MAZ_CTRGPTree = 0;
				MAZ_UnitsTree_BLUFOR tvSetText [[MAZ_CTRGPTree],"CTRG+"];
				MAZ_UnitsTree_BLUFOR tvSetPictureRight [[MAZ_CTRGPTree], "\A3\Data_F_exp\Flags\flag_CTRG_CO.paa"];
				MAZ_UnitsTree_BLUFOR tvSetTooltip [[MAZ_CTRGPTree], "A remastered version of the CTRG faction."];

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

				MAZ_UnitsTree_BLUFOR tvSort [[MAZ_CTRGPTree]];
				
			comment "CSAT (Africans)";

				MAZ_AFRTree = [
					MAZ_UnitsTree_OPFOR,
					"CSAT (African)",
					""
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

				MAZ_UnitsTree_OPFOR tvSort [[]];

			comment "End";
			
			if (M9SD_serverEZM) then {
				comment "Switch to modules tab and expand respawn category:";
				comment "_zeusModulesTree tvSort [[0]];";
				if (count ((missionNamespace getVariable ['DEFAULTPLAYERSIDE', WEST]) call BIS_fnc_getRespawnPositions) == 0) then {
					_respawnIndex = switch (missionNamespace getVariable ['DEFAULTPLAYERSIDE', WEST]) do {
						case WEST: {1};
						case EAST: {4};
						case INDEPENDENT: {3};
						case CIVILIAN: {2};
					};
					ctrlActivate ((findDisplay 312) displayCtrl 152);
					_zeusModulesTree tvExpand [8];
					_zeusModulesTree tvSetCurSel [-1];
					_zeusModulesTree tvSetCurSel [8]; comment "Highlight Respawn Category";
					comment "Uncomment the following to auto-select the corresponding respawn type:";
					comment "_zeusModulesTree tvSetCurSel [8, _respawnIndex];";
				};
			};
		};
	};
	[] call _fnc_editInterface;
};

MAZ_EZM_editZeusLogic = {
	private _zeusLogic = objNull;
	private _zeusLogic = getAssignedCuratorLogic player;
	if (isNull _zeusLogic) exitWith {};
	player setVariable ["MAZ_EZM_ZeusLogic",_zeusLogic];

	if(!isNil "MAZ_EZM_zeusRespawnFix") then {
		player removeEventHandler ["Respawn",MAZ_EZM_zeusRespawnFix];
	};
	MAZ_EZM_zeusRespawnFix = player addEventhandler ["Respawn",{
		[] spawn {
			waitUntil {alive player && !isNull (findDisplay 46)};
			private _zeusLogic = player getVariable "MAZ_EZM_ZeusLogic";
			if(isNil "_zeusLogic") exitWith {
				["Error! Zeus Logic not found!","addItemFailed"] call MAZ_EZM_fnc_systemMessage;
			};
			[_zeusLogic] remoteExec ['unassignCurator',2];

			waitUntil{isNull (getAssignedCuratorUnit _zeusLogic)};
			["Curator unassigned."] call MAZ_EZM_fnc_systemMessage;

			["Attempting to assign..."] call MAZ_EZM_fnc_systemMessage;
			while{isNull (getAssignedCuratorUnit _zeusLogic)} do {
				[player,_zeusLogic] remoteExec ['assignCurator',2];
				sleep 0.1;
			};
			["Curator assigned! Press Y to open/close Zeus."] call MAZ_EZM_fnc_systemMessage;
		};
	}];
	[] call MAZ_EZM_fnc_addToInterface;

	if((_zeusLogic getVariable ["MAZ_zeusEH_modulePlaced",-200]) != -200) then {
		_zeusLogic removeEventHandler ['CuratorObjectPlaced',(_zeusLogic getVariable 'MAZ_zeusEH_modulePlaced')];
	};
	_zeusLogic setVariable [
		"MAZ_zeusEH_modulePlaced",
		_zeusLogic addEventHandler [
			'CuratorObjectPlaced',
			MAZ_EZM_fnc_runZeusModule
		]
	];

	_zeusLogic addEventHandler ["CuratorGroupPlaced", {
		params ["_curator", "_group"];
		_group deleteGroupWhenEmpty true;
		[units _group] call MAZ_EZM_fnc_addObjectToInterface;
	}];

	if((_zeusLogic getVariable ["MAZ_zeusEH_objectDblClicked",-200]) != -200) then {
		_zeusLogic removeEventHandler ['CuratorObjectDoubleClicked',(_zeusLogic getVariable 'MAZ_zeusEH_objectDblClicked')];
	};
	_zeusLogic setVariable [
		"MAZ_zeusEH_objectDblClicked",
		_zeusLogic addEventhandler ["CuratorObjectDoubleClicked",{
			params ["_curator", "_entity"];
			if(isPlayer _entity) exitWith {
				[_entity] spawn MAZ_EZM_createPlayerAttributesDialog;
				true
			};
			if((typeOf _entity) isKindOf "CAManBase" && !isPlayer _entity && alive _entity) exitWith {
				[_entity] spawn MAZ_EZM_createManAttributesDialog;
				true
			};
			if((typeOf _entity) isKindOf "LandVehicle" && alive _entity) exitWith {
				[_entity] spawn MAZ_EZM_createLandVehicleAttributesDialog;
				true
			};
			if(((typeOf _entity) isKindOf "Air" || (typeOf _entity) isKindOf "Ship") && alive _entity) exitWith {
				[_entity] spawn MAZ_EZM_createVehicleAttributesDialog;
				true
			};
			false
		}]
	];
	if((_zeusLogic getVariable ["MAZ_zeusEH_groupDblClicked",-200]) != -200) then {
		_zeusLogic removeEventHandler ['CuratorGroupDoubleClicked',(_zeusLogic getVariable 'MAZ_zeusEH_groupDblClicked')];
	};
	_zeusLogic setVariable [
		"MAZ_zeusEH_groupDblClicked",
		_zeusLogic addEventhandler ["CuratorGroupDoubleClicked",{
			params ["_curator", "_group"];
			[_group] spawn MAZ_EZM_createGroupAttributesDialog;
			true
		}]
	];

	if((_zeusLogic getVariable ["MAZ_zeusEH_markerDblClicked",-200]) != -200) then {
		_zeusLogic removeEventHandler ['CuratorMarkerDoubleClicked',(_zeusLogic getVariable 'MAZ_zeusEH_markerDblClicked')];
	};
	_zeusLogic setVariable [
		"MAZ_zeusEH_markerDblClicked",
		_zeusLogic addEventhandler ["CuratorMarkerDoubleClicked",{
			params ["_curator", "_marker"];
			[_marker] spawn MAZ_EZM_createMarkerAttributesDialog;
			true
		}]
	];
	if((_zeusLogic getVariable ["MAZ_zeusEH_markerPlaced",-200]) != -200) then {
		_zeusLogic removeEventHandler ['CuratorMarkerPlaced',(_zeusLogic getVariable 'MAZ_zeusEH_markerPlaced')];
	};
	_zeusLogic setVariable [
		"MAZ_zeusEH_markerPlaced",
		_zeusLogic addEventhandler ["CuratorMarkerPlaced",{
			params ["_curator", "_marker"];
			if(isNil "MAZ_EZM_markerColorDefault") then {
				MAZ_EZM_markerColorDefault = "Default";
			};
			_marker setMarkerColor MAZ_EZM_markerColorDefault;
		}]
	];

	if((_zeusLogic getVariable ["MAZ_zeusEH_waypointPlaced",-200]) != -200) then {
		_zeusLogic removeEventHandler ['CuratorWaypointPlaced',(_zeusLogic getVariable 'MAZ_zeusEH_waypointPlaced')];
	};
	_zeusLogic setVariable [
		"MAZ_zeusEH_waypointPlaced",
		_zeusLogic addEventhandler ["CuratorWaypointPlaced",{
			params ["_curator", "_group", "_waypointID"];
			private _waypointPos = getWPPos [_group,_waypointID];
			if((_waypointPos distance2D [0,0,0]) < 100) then {
				if(alive (leader _group)) then {
					[_group,_waypointID] setWPPos (getPos (leader _group));
				} else {
					private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
					[_group,_waypointID] setWPPos _pos;
				};
			};
		}]
	];
};

MAZ_EZM_addZeusKeybinds_312 = {
	waitUntil{!isNull(findDisplay 312)};

	if(!isNil "MAZ_EZM_closeZeusInterface") then {
		(findDisplay 312) displayRemoveEventHandler ["KeyDown",MAZ_EZM_closeZeusInterface];
	};
	if(!isNil "MAZ_EZM_changeCuratorSideEH") then {
		(findDisplay 312) displayRemoveEventHandler ["KeyDown",MAZ_EZM_changeCuratorSideEH];
	};

	if(!isNil "MAZ_EZM_remoteControlShortcutUpEH") then {
		(findDisplay 312) displayRemoveEventHandler ["MouseButtonUp",MAZ_EZM_remoteControlShortcutUpEH];
	};
	if(!isNil "MAZ_EZM_remoteControlShortcutDownEH") then {
		(findDisplay 312) displayRemoveEventHandler ["MouseButtonDown",MAZ_EZM_remoteControlShortcutDownEH];
	};
	
	if(!isNil "MAZ_EZM_mapClickDownEH") then {
		((findDisplay 312) displayCtrl 50) ctrlRemoveEventHandler ["MouseButtonDown",MAZ_EZM_mapClickDownEH];
	};
	if(!isNil "MAZ_EZM_mapClickUpEH") then {
		((findDisplay 312) displayCtrl 50) ctrlRemoveEventHandler ["MouseButtonUp",MAZ_EZM_mapClickUpEH];
	};
	if(!isNil "MAZ_EZM_mapMovingEH") then {
		((findDisplay 312) displayCtrl 50) ctrlRemoveEventHandler ["MouseMoving",MAZ_EZM_mapMovingEH];
	};
	if(!isNil "MAZ_EZM_deleteMarkerMapEH") then {
		(findDisplay 312) displayRemoveEventHandler ["KeyDown",MAZ_EZM_deleteMarkerMapEH];
	};
	if(!isNil "MAZ_EZM_mapDoubleClickEH") then {
		((findDisplay 312) displayCtrl 50) ctrlRemoveEventHandler ["MouseButtonDblClick",MAZ_EZM_mapDoubleClickEH];
	};

	if(!isNil "MAZ_EZM_rightClickContextMenuUpEH") then {
		(findDisplay 312) displayRemoveEventHandler ["MouseButtonUp",MAZ_EZM_rightClickContextMenuUpEH];
	};
	if(!isNil "MAZ_EZM_rightClickContextMenuDownEH") then {
		(findDisplay 312) displayRemoveEventHandler ["MouseButtonDown",MAZ_EZM_rightClickContextMenuDownEH];
	};

	if(!isNil "MAZ_EZM_deployFlaresOnAircraft") then {
		(findDisplay 312) displayRemoveEventHandler ["KeyDown",MAZ_EZM_deployFlaresOnAircraft];
	};

	MAZ_EZM_closeZeusInterface = (findDisplay 312) displayAddEventHandler ["KeyDown", {
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
		if(_key == 21 && _ctrl) then {
			(findDisplay 312) closeDisplay 0;
			["Zeus interface closed."] call MAZ_EZM_fnc_systemMessage;
		};
	}];
	MAZ_EZM_changeCuratorSideEH = (findDisplay 312) displayAddEventHandler ["KeyDown", {
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
		if(_key == 22 && _ctrl) then {
			[] spawn JAM_GUIfnc_groupMenuTeamSwitcher;
		};
	}];

	MAZ_EZM_remoteControlShortcutDownEH = (findDisplay 312) displayAddEventHandler ["MouseButtonDown",{
		params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		if(_button == 0 && _alt) then {
			if(isNil "MAZ_EZM_mousePressTime") then {
				MAZ_EZM_mousePressTime = time;
			};
		};
	}];
	MAZ_EZM_remoteControlShortcutUpEH = (findDisplay 312) displayAddEventHandler ["MouseButtonUp", {
		params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		
		if(_button == 0 && _alt) then {
			private _buttonHoldTime = time - MAZ_EZM_mousePressTime;
			MAZ_EZM_mousePressTime = nil;
			if(_buttonHoldTime < 0.1) then {
				private _logic = createVehicle ["Land_HelipadEmpty_F",[0,0,0],[],0,"CAN_COLLIDE"];
				[_logic,_targetObj,true] spawn MAZ_EZM_BIS_fnc_remoteControlUnit;
			};
		};
	}];

	MAZ_EZM_mapClickDownEH = ((findDisplay 312) displayCtrl 50) ctrlAddEventHandler ["MouseButtonDown",{
		params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		if(_button != 0) exitWith {};
		if((curatorMouseOver isEqualTo []) or (curatorMouseOver isEqualTo [''])) then {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			if(({(markerPos _x) distance2D _pos < 75} count allMapMarkers) != 0) then {
				private _closest = nil;
				{
					if(isNil "_closest" && ((markerPos _x) distance2D _pos < 75)) then {
						_closest = _x;
					};
					if(!isNil "_closest" && markerPos _x distance2D _pos < markerPos _closest distance2D _pos) then {
						_closest = _x;
					};
				}forEach allMapMarkers;
				if(!isNil "_closest") then {
					if((markerShape _closest == "ELLIPSE") || (markerShape _closest == "RECTANGLE")) then {
						_displayOrControl setVariable ["EZM_isMovingMarker",true];
						_displayOrControl setVariable ["EZM_movingMarker",_closest];
					};
				};
			};
		};
	}];
	MAZ_EZM_mapClickUpEH = ((findDisplay 312) displayCtrl 50) ctrlAddEventHandler ["MouseButtonUp",{
		params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		if(_button != 0) exitWith {};
		if(_displayOrControl getVariable ["EZM_isMovingMarker",false]) then {
			private _marker = _displayOrControl getVariable "EZM_movingMarker";
			if(!isNil "_marker") then {
				_marker setMarkerPos (getMarkerPos _marker);
			};
			_displayOrControl setVariable ["EZM_isMovingMarker",false];
			_displayOrControl setVariable ["EZM_movingMarker",nil];
		};
	}];
	MAZ_EZM_mapMovingEH = ((findDisplay 312) displayCtrl 50) ctrlAddEventHandler ["MouseMoving",{
		params ["_control", "_xPos", "_yPos", "_mouseOver"];
		if(_control getVariable ["EZM_isMovingMarker",false]) then {
			private _marker = _control getVariable "EZM_movingMarker";
			if(!isNil "_marker") then {
				_marker setMarkerPosLocal (_control ctrlMapScreenToWorld getMousePosition);
			};
		};
	}];
	MAZ_EZM_deleteMarkerMapEH = (findDisplay 312) displayAddEventHandler ["KeyDown",{
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
		if(!visibleMap) exitWith {};
		if(_key != 211) exitWith {};
		if((curatorMouseOver isEqualTo []) or (curatorMouseOver isEqualTo [''])) then {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			if(({(markerPos _x) distance2D _pos < 100} count allMapMarkers) != 0) then {
				private _closest = nil;
				{
					if(isNil "_closest" && ((markerPos _x) distance2D _pos < 100)) then {
						_closest = _x;
					};
					if(!isNil "_closest" && markerPos _x distance2D _pos < markerPos _closest distance2D _pos) then {
						_closest = _x;
					};
				}forEach allMapMarkers;
				if(!isNil "_closest") then {
					if((markerShape _closest == "ELLIPSE") || (markerShape _closest == "RECTANGLE")) then {
						deleteMarker _closest;
					};
				};
			};
		};
	}];
	MAZ_EZM_mapDoubleClickEH = ((findDisplay 312) displayCtrl 50) ctrlAddEventHandler ["MouseButtonDblClick",{
		params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
		if ((curatorMouseOver isEqualTo []) or (curatorMouseOver isEqualTo [''])) then {
			if(({(markerPos _x) distance2D _pos < 100} count allMapMarkers) != 0) then {
				private _closest = nil;
				{
					if(isNil "_closest" && ((markerPos _x) distance2D _pos < 100)) then {
						_closest = _x;
					};
					if(!isNil "_closest" && markerPos _x distance2D _pos < markerPos _closest distance2D _pos) then {
						_closest = _x;
					};
				}forEach allMapMarkers;
				if(!isNil "_closest") then {
					if((markerShape _closest == "ELLIPSE") || (markerShape _closest == "RECTANGLE")) then {
						[_closest] spawn MAZ_EZM_fnc_createEditAreaMarkerDialog;
					} else {
						[_closest] spawn MAZ_EZM_createMarkerAttributesDialog;
					};
				};
			};
		};
	}];

	MAZ_EZM_rightClickContextMenuDownEH = (findDisplay 312) displayAddEventHandler ["MouseButtonDown",{
		params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		if(_button == 1 && (!_ctrl && !_shift && !_alt)) then {
			
				MAZ_EZM_mousePressTimeContext = time;
			
			comment "detect mouse movement (panning camera)";
			
				JAM_EZM_mouseMovementContext = getMousePosition;
			
		};
	}];
	MAZ_EZM_rightClickContextMenuUpEH = (findDisplay 312) displayAddEventHandler ["MouseButtonUp", {
		params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
		
		if(_button == 1 && (!_ctrl && !_shift && !_alt)) then {
			if (isNil 'MAZ_EZM_mousePressTimeContext') then {MAZ_EZM_mousePressTimeContext = time;};
			private _buttonHoldTime = time - MAZ_EZM_mousePressTimeContext;
			MAZ_EZM_mousePressTimeContext = nil;
			if (_buttonHoldTime < 0.2) then {
			
				comment "Tweak amount of tolerance (for camera panning):";
				
				comment "systemchat 'holdtime good';";
				
				_wiggleRoom = 0.01;
			
				_mousePosLast = missionNamespace getvariable ['JAM_EZM_mouseMovementContext', getMousePosition];
				_mousePosCurrent = getMousePosition;
				
				_mousePosLast_x = _mousePosLast # 0;
				_mousePosLast_y = _mousePosLast # 1;
				
				_mousePosCurrent_x = _mousePosCurrent # 0;
				_mousePosCurrent_y = _mousePosCurrent # 1;
				
				_difference_x = _mousePosCurrent_x - _mousePosLast_x;
				_difference_y = _mousePosCurrent_y - _mousePosLast_y;
				
				_absoluteDifference_x = if (_difference_x < 0) then {_difference_x * -1} else {_difference_x};
				_absoluteDifference_y = if (_difference_y < 0) then {_difference_y * -1} else {_difference_y};
				
				comment "distance formula: d=√((x2−x1)^2+(y2−y1)^2)";
				
				_distanceTraveled = sqrt (((_difference_x)^2) + ((_difference_y)^2));
				
				comment "crudddd = [_mousePosLast, _mousePosCurrent, _mousePosLast_x, _mousePosLast_y, _mousePosCurrent_x, _mousePosCurrent_y, _difference_x, _difference_y, _absoluteDifference_x, _absoluteDifference_y];
				crudddd2 = [_absoluteDifference_x, _absoluteDifference_y];
				((_absoluteDifference_x <= _wiggleRoom) && (_absoluteDifference_y <= _wiggleRoom))";
				
				comment "crudddd3 = _distanceTraveled;
				systemchat str crudddd3;";
				
				if (_distanceTraveled <= _wiggleRoom) then 
				{
					
					[] call ZAM_fnc_createContextMenu;
				};
			} else {comment "systemchat 'holdtime bad';";};
		} else {
			private _isContextMenuOpenAlready = player getVariable ["EZM_isContextOpen",false];
			if(_isContextMenuOpenAlready) then {
				[] spawn ZAM_fnc_destroyContextMenu;
			};
		};
	}];

	MAZ_EZM_deployFlaresOnAircraft = (findDisplay 312) displayAddEventhandler ["KeyDown",{
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
		if(_key != 46 || (_shift || _ctrl || _alt)) exitWith {};
		if(!(curatorMouseOver isEqualTo []) && !(curatorMouseOver isEqualTo [''])) then {
			private _vehicle = curatorMouseOver select 1;
			if(typeOf _vehicle isKindOf "Air") then {
				private _driverVeh = driver _vehicle;
				if(!isPlayer _driverVeh && alive _driverVeh) then {
					_driverVeh spawn {
						for "_i" from 0 to 3 do {
							_this forceWeaponFire ["CMFlareLauncher", "AIBurst"];
							sleep 0.4;
						};
					};
				};
			};
		};
		private _objectsSelected = curatorSelected select 0;
		{
			if(typeOf _x isKindOf "Air") then {
				private _driverVeh = driver _x;
				if(!isPlayer _driverVeh && alive _driverVeh) then {
					_driverVeh spawn {
						for "_i" from 0 to 3 do {
							_this forceWeaponFire ["CMFlareLauncher", "AIBurst"];
							sleep 0.4;
						};
					};
				};
			};
		}forEach _objectsSelected;
	}];
};

MAZ_EZM_addZeusKeybinds_46 = {
	waitUntil{!isNull(findDisplay 46)};
	if(!isNil "MAZ_EZM_curatorHolster") then {
		(findDisplay 46) displayRemoveEventHandler ["KeyDown",MAZ_EZM_curatorHolster];
	};
	MAZ_EZM_curatorHolster = (findDisplay 46) displayAddEventHandler ["KeyDown", "if(_this select 1 == 35) then {
		player action ['SWITCHWEAPON',player,player,-1];
		waitUntil {currentWeapon player == '' or {primaryWeapon player == '' && handgunWeapon player == ''}};
	}"];
};

JAM_GUIfnc_groupMenuTeamSwitcher = {
	if (!isNull findDisplay 60490) exitWith {};
	with uiNamespace do 
	{
		disableSerialization;
		closeDialog 1;
		createDialog "RscDisplayDynamicGroups";
		showChat true;
		_display = findDisplay 60490;
		if (!isNull _display) then 
		{
			_bcknd1 = _display ctrlCreate ['RscText',-1];
			_bcknd1 ctrlSetPosition [0.345312 * safezoneW + safezoneX,0.093 * safezoneH + safezoneY,0.309375 * safezoneW,0.099 * safezoneH];
			_bcknd1 ctrlSetBackgroundColor [0,0,0,0.5];
			_bcknd1 ctrlCommit 0;
			_bcknd2 = _display ctrlCreate ['RscText',-1];
			_bcknd2 ctrlSetPosition [0.350469 * safezoneW + safezoneX,0.104 * safezoneH + safezoneY,0.299062 * safezoneW,0.077 * safezoneH];
			_bcknd2 ctrlSetBackgroundColor [0,0,0,0.5];
			_bcknd2 ctrlCommit 0;
			_ttile = _display ctrlCreate ["RscStructuredText", -1];
			_ttile ctrlSetPosition [0.360781 * safezoneW + safezoneX,0.104 * safezoneH + safezoneY,0.278437 * safezoneW,0.033 * safezoneH];
			_ttile ctrlSetStructuredText parseText ("<t size='" + (str (0.5 * safeZoneH)) + "' align='center'>CHANGE SIDE:</t>");
			_ttile ctrlSetBackgroundColor [0,0,0,0];
			_ttile ctrlCommit 0;
			_btn_west = _display ctrlCreate ['RscButtonMenu',-1];
			_btn_west ctrlSetPosition [0.360781 * safezoneW + safezoneX,0.137 * safezoneH + safezoneY,0.0515625 * safezoneW,0.033 * safezoneH];
			_btn_west ctrlSetBackgroundColor [0,0,0.5,0.8];
			_btn_west ctrlSetStructuredText parseText ("<t size='" + (str (0.5 * safeZoneH)) + "' align='center'>BLUFOR</t>");
			_btn_west ctrladdEventHandler ["ButtonClick", 
			{
				_side = west;
				_groupName = "Stryker 1-4";
				_groups = ["GetAllGroupsOfSide", [_side]] call BIS_fnc_dynamicGroups;
				EZM_curator_group = createGroup _side;
				EZM_curator_group deleteGroupWhenEmpty true;
				[player] join EZM_curator_group;
				EZM_curator_group selectLeader player;
				[EZM_curator_group, player] remoteExec ["selectLeader", groupOwner EZM_curator_group];					
				EZM_curator_group setGroupIdGlobal [_groupName];
				private _group = EZM_curator_group;
				private _leader = leader _group;
				private _data = [nil, _groupName, false]; comment " [<Insignia>, <Group Name>, <Private>] ";
				["RegisterGroup", [_group, _leader, _data]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["AddGroupMember", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SwitchLeader", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SetPrivateState", [EZM_curator_group,true]] remoteExecCall ['BIS_fnc_dynamicGroups'];	
				["SetName", [EZM_curator_group,_groupName]] remoteExecCall ['BIS_fnc_dynamicGroups'];
			}];
			_btn_west ctrlCommit 0;
			_btn_east = _display ctrlCreate ['RscButtonMenu',-1];
			_btn_east ctrlSetPosition [0.4175 * safezoneW + safezoneX,0.137 * safezoneH + safezoneY,0.0515625 * safezoneW,0.033 * safezoneH];
			_btn_east ctrlSetBackgroundColor [0.5,0,0,0.8];
			_btn_east ctrlSetStructuredText parseText ("<t size='" + (str (0.5 * safeZoneH)) + "' align='center'>OPFOR</t>");
			_btn_east ctrladdEventHandler ["ButtonClick", 
			{
				_side = east;
				_groupName = "Stryker 1-4";
				_groups = ["GetAllGroupsOfSide", [_side]] call BIS_fnc_dynamicGroups;
				EZM_curator_group = createGroup _side;
				EZM_curator_group deleteGroupWhenEmpty true;
				[player] join EZM_curator_group;
				EZM_curator_group selectLeader player;
				[EZM_curator_group, player] remoteExec ["selectLeader", groupOwner EZM_curator_group];					
				EZM_curator_group setGroupIdGlobal [_groupName];
				private _group = EZM_curator_group;
				private _leader = leader _group;
				private _data = [nil, _groupName, false]; comment " [<Insignia>, <Group Name>, <Private>] ";
				["RegisterGroup", [_group, _leader, _data]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["AddGroupMember", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SwitchLeader", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SetPrivateState", [EZM_curator_group,true]] remoteExecCall ['BIS_fnc_dynamicGroups'];	
				["SetName", [EZM_curator_group,_groupName]] remoteExecCall ['BIS_fnc_dynamicGroups'];
			}];
			_btn_east ctrlCommit 0;
			_btn_indep = _display ctrlCreate ['RscButtonMenu',-1];
			_btn_indep ctrlSetPosition [0.474219 * safezoneW + safezoneX,0.137 * safezoneH + safezoneY,0.0515625 * safezoneW,0.033 * safezoneH];
			_btn_indep ctrlSetBackgroundColor [0,0.5,0,0.8];
			_btn_indep ctrlSetStructuredText parseText ("<t size='" + (str (0.5 * safeZoneH)) + "' align='center'>INDEP</t>");
			_btn_indep ctrladdEventHandler ["ButtonClick", 
			{
				_side = independent;
				_groupName = "Stryker 1-4";
				_groups = ["GetAllGroupsOfSide",[_side]] call BIS_fnc_dynamicGroups;
				EZM_curator_group = createGroup _side;
				EZM_curator_group deleteGroupWhenEmpty true;
				[player] join EZM_curator_group;
				EZM_curator_group selectLeader player;
				[EZM_curator_group, player] remoteExec ["selectLeader", groupOwner EZM_curator_group];					
				EZM_curator_group setGroupIdGlobal [_groupName];
				private _group = EZM_curator_group;
				private _leader = leader _group;
				private _data = [nil, _groupName, false]; comment " [<Insignia>, <Group Name>, <Private>] ";
				["RegisterGroup", [_group, _leader, _data]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["AddGroupMember", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SwitchLeader", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SetPrivateState", [EZM_curator_group,true]] remoteExecCall ['BIS_fnc_dynamicGroups'];	
				["SetName", [EZM_curator_group,_groupName]] remoteExecCall ['BIS_fnc_dynamicGroups'];
			}];
			_btn_indep ctrlCommit 0;
			_btn_civ = _display ctrlCreate ['RscButtonMenu',-1];
			_btn_civ ctrlSetPosition [0.530937 * safezoneW + safezoneX,0.137 * safezoneH + safezoneY,0.0515625 * safezoneW,0.033 * safezoneH];
			_btn_civ ctrlSetBackgroundColor [0.4,0,0.4,0.8];
			_btn_civ ctrlSetStructuredText parseText ("<t size='" + (str (0.5 * safeZoneH)) + "' align='center'>CIV</t>");
			_btn_civ ctrladdEventHandler ["ButtonClick", 
			{
				_side = civilian;
				_groupName = "Stryker 1-4";
				_groups = ["GetAllGroupsOfSide",[_side]] call BIS_fnc_dynamicGroups;
				EZM_curator_group = createGroup _side;
				EZM_curator_group deleteGroupWhenEmpty true;
				[player] join EZM_curator_group;
				EZM_curator_group selectLeader player;
				[EZM_curator_group, player] remoteExec ["selectLeader", groupOwner EZM_curator_group];					
				EZM_curator_group setGroupIdGlobal [_groupName];
				private _group = EZM_curator_group;
				private _leader = leader _group;
				private _data = [nil, _groupName, false]; comment " [<Insignia>, <Group Name>, <Private>] ";
				["RegisterGroup", [_group, _leader, _data]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["AddGroupMember", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SwitchLeader", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SetPrivateState", [EZM_curator_group,true]] remoteExecCall ['BIS_fnc_dynamicGroups'];	
				["SetName", [EZM_curator_group,_groupName]] remoteExecCall ['BIS_fnc_dynamicGroups'];
			}];
			_btn_civ ctrlCommit 0;
			_btn_zeus = _display ctrlCreate ['RscButtonMenu',-1];
			_btn_zeus ctrlSetPosition [0.587656 * safezoneW + safezoneX,0.137 * safezoneH + safezoneY,0.0515625 * safezoneW,0.033 * safezoneH];
			_btn_zeus ctrlSetBackgroundColor [0.4,0.4,0.4,0.8];
			_btn_zeus ctrlSetStructuredText parseText ("<t size='" + (str (0.5 * safeZoneH)) + "' align='center'>ZEUS</t>");
			_btn_zeus ctrladdEventHandler ["ButtonClick", 
			{
				_side = sideLogic;
				_groupName = "Stryker 1-4";
				_groups = ["GetAllGroupsOfSide",[_side]] call BIS_fnc_dynamicGroups;
				EZM_curator_group = createGroup _side;
				EZM_curator_group deleteGroupWhenEmpty true;
				[player] join EZM_curator_group;
				EZM_curator_group selectLeader player;
				[EZM_curator_group, player] remoteExec ["selectLeader", groupOwner EZM_curator_group];					
				EZM_curator_group setGroupIdGlobal [_groupName];
				private _group = EZM_curator_group;
				private _leader = leader _group;
				private _data = [nil, _groupName, false]; comment " [<Insignia>, <Group Name>, <Private>] ";
				["RegisterGroup", [_group, _leader, _data]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["AddGroupMember", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SwitchLeader", [EZM_curator_group,player]] remoteExecCall ['BIS_fnc_dynamicGroups'];
				["SetPrivateState", [EZM_curator_group,true]] remoteExecCall ['BIS_fnc_dynamicGroups'];	
				["SetName", [EZM_curator_group,_groupName]] remoteExecCall ['BIS_fnc_dynamicGroups'];
			}];
			_btn_zeus ctrlCommit 0;
		};
	};
};

JAM_fnc_addZeusKeybinds_46 = {
	_d = displayNull;
	_d = findDisplay 46;
	if (isNull _d) exitWith {};
	
	comment "drunk teleportation";

	if (!isNil "JAM_kb_teleSelf46") then 
	{
		_d displayRemoveEventHandler ["keyDown", JAM_kb_teleSelf46];
	};
	JAM_kb_teleSelf46 = _d displayAddEventHandler ["KeyDown", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];
		_keyCode_keyPressed = _key;
		_keyCode_H = 35;
		if 
		(
			(_keyCode_keyPressed == _keyCode_H) && 
			(_ctrl) && 
			(not _shift) && 
			(not _alt)
		) then 
		{
			if !(visibleMap) then 
			{
				vehicle player setPos (screenToWorld [0.5,0.5]);
			};
		};
	}]; comment "Key: [[L CTRL] + [H]]";
};

JAM_fnc_addZeusKeybinds_12 = {
	_d = displayNull;
	_d = findDisplay 12;
	if (isNull _d) exitWith {};
	
	comment "drunk teleportation";

	if (!isNil "JAM_kb_teleSelf12") then 
	{
		_d displayRemoveEventHandler ["keyDown", JAM_kb_teleSelf12];
	};
	JAM_kb_teleSelf12 = _d displayAddEventHandler ["KeyDown", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];
		_keyCode_keyPressed = _key;
		_keyCode_H = 35;
		if 
		(
			(_keyCode_keyPressed == _keyCode_H) && 
			(_ctrl) && 
			(not _shift) && 
			(not _alt)
		) then 
		{
			if (visibleMap) then 
			{
				_zeusMapCtrl_IDC = 51;
				vehicle player setPos ((_displayorcontrol displayCtrl _zeusMapCtrl_IDC) ctrlMapScreenToWorld (getMousePosition));
			};
		};
	}]; comment "Key: [[L CTRL] + [H]]";
};

JAM_fnc_addZeusKeybinds = {
	_d = displayNull;
	_d = findDisplay 312;
	if (isNull _d) exitWith {};
	if (!isNil "JAM_kb_exitZeus") then 
	{
		_d displayRemoveEventHandler ["keyDown", JAM_kb_exitZeus];
	};
	JAM_kb_exitZeus = _d displayAddEventHandler ["KeyDown", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];
		_keyCode_keyPressed = _key;
		_keyCode_Y = 21;
		if 
		(
			(_keyCode_keyPressed == _keyCode_Y) && 
			(_ctrl) && 
			(not _shift) && 
			(not _alt)
		) then 
		{
			with uiNamespace do 
			{
				(findDisplay 312) closeDisplay 0;
			};
		};
	}]; comment "Key: [[L CTRL] + [Y]]";
	if (!isNil "JAM_kb_openGroups") then 
	{
		_d displayRemoveEventHandler ["keyDown", JAM_kb_openGroups];
	};
	JAM_kb_openGroups = _d displayAddEventHandler ["KeyDown", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];
		_keyCode_keyPressed = _key;
		_keyCode_U = 22;
		if 
		(
			(_keyCode_keyPressed == _keyCode_U) && 
			(_ctrl) && 
			(not _shift) && 
			(not _alt)
		) then 
		{
			[] spawn JAM_GUIfnc_groupMenuTeamSwitcher;
		};
	}]; comment "Key: [[L CTRL] + [U]]";
	if (!isNil "JAM_kb_teleSelf") then 
	{
		_d displayRemoveEventHandler ["keyDown", JAM_kb_teleSelf];
	};
	JAM_kb_teleSelf = _d displayAddEventHandler ["KeyDown", 
	{
		params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];
		_keyCode_keyPressed = _key;
		_keyCode_H = 35;
		if 
		(
			(_keyCode_keyPressed == _keyCode_H) && 
			(_ctrl) && 
			(not _shift) && 
			(not _alt)
		) then 
		{
			if (visibleMap) then 
			{
				_zeusMapCtrl_IDC = 50;
				vehicle player setPos ((_displayorcontrol displayCtrl _zeusMapCtrl_IDC) ctrlMapScreenToWorld (getMousePosition));
			} else 
			{
				vehicle player setPos (screenToWorld (getMousePosition));
			};
		};
	}]; comment "Key: [[L CTRL] + [H]]";
};

MAZ_EZM_fnc_initMainLoop = {
	MAZ_EZM_mainLoop_Active = true;
	if (!M9SD_serverEZM) then {
		["Enhanced Zeus Modules Lite Initialized!.","beep_target"] call MAZ_EZM_fnc_systemMessage;
	};
	
	if (M9SD_serverEZM) then {
		private _initKeybindsFnc = {
			waitUntil {!isNull findDisplay 46};
			[] spawn JAM_fnc_addZeusKeybinds_46;
			waitUntil {!isNull findDisplay 12};
			[] spawn JAM_fnc_addZeusKeybinds_12;
		};
		private _initKeybinds = [] spawn _initKeybindsFnc;
	};
	
	while {MAZ_EZM_mainLoop_Active} do {
		if (M9SD_serverEZM) then {
			[] spawn{
				while {(isNull (findDisplay 312))} do {
					JAM_zeus_prevAnim = animationState player;
					uiSleep 0.01;
				};
			};
		};
	
		waitUntil {uiSleep 0.01; (!isNull (findDisplay 312))};
		
		if (M9SD_serverEZM) then {
			if ((vehicle player == player) && (!(missionNamespace getvariable ['AR_active', false]))) then {
				private _fnc = {
					private _animBlacklist = [
						"pronebipod_centerleft",
						"pronebipod_centerright",


						"bipod_90_centerleft",
						"bipod_90_centerright",


						"bipod_150_centerleft",
						"bipod_150_centerright"
					];
					
					if (JAM_zeus_prevAnim in _animBlacklist) then {
						[PLAYER, ''] remoteExec ['switchMove'];
					} else {
						[PLAYER, JAM_zeus_prevAnim] remoteExec ['switchMove'];
					};
					
					comment "TODO: autorun";
				
					if (false) then {
						if (!isNil 'JAM_EH_zeusUnitAnims') then {
							player removeEventHandler ['AnimDone', JAM_EH_zeusUnitAnims];
						
						};
						
						JAM_EH_zeusUnitAnims = player addEventHandler ["AnimDone", {
							params ["_unit", "_anim"];
							systemChat _anim;
							[PLAYER, JAM_zeus_prevAnim] remoteExec ['switchMove'];
						}];
					};
				};
				if (!isNil 'JAM_zeus_prevAnim') then {
					[] call _fnc;
				} else {
					JAM_zeus_prevAnim = animationState player;
					[] call _fnc;
				};
			};			
		};

		[] spawn MAZ_EZM_editZeusLogic;
		[] spawn MAZ_EZM_addZeusKeybinds_312;
		if (M9SD_serverEZM) then {
			[] spawn JAM_fnc_addZeusKeybinds;
		};
		[] spawn JAM_MAZ_EZM_editZeusInterface; comment " (O_o) ";
		if (!M9SD_serverEZM) then {
			playSound "beep_target";
		};
		waitUntil {uiSleep 0.1; (isNull (findDisplay 312))};

		[] spawn MAZ_EZM_addZeusKeybinds_46;
	};
};

JAM_fnc_startEZM = {
	if (isNil "MAZ_EZM_mainLoop_Active") then {
		[] spawn MAZ_EZM_fnc_initMainLoop;

	};
};

if (M9SD_serverEZM) then {
	call JAM_fnc_startEZM;
} else {
	["Create Zeus Unit?",[
		[
			"TOOLBOX:YESNO",
			["Create Zeus Unit","Whether to create a new controllable unit for your player."],
			[true]
		]
	],{
		params ["_values","_args","_display"];
		_values params ["_createZeusUnit"];
		if(_createZeusUnit) then {
			[] spawn MAZ_EZM_createUnitForZeus;
		} else {
			call JAM_fnc_startEZM;
		};
		_display closeDisplay 1;
	},{
		params ["_values","_args","_display"];
		_display closeDisplay 2;
	},[]] call MAZ_EZM_fnc_createDialog;
};

comment "
	TODO M9-SD:
	- Civilian Interaction Modules:
		- Add module that puts unit in injured animation and adds hold action to save
		- Add module that puts unit in panic mode and adds hold action
		- Add add ambient civilian module (chris script)
	- Add module that toggles showing player fps
	- Add module that stops and thinks about why it doesnt stop and think
	- Add module that spawns a pack of dogs
	- Add module that gives a player support requesting capabilities
	- Add a module that gives a player a commandable/controllable dog
	- Integrate Shekel system modules for whitelisted users
	- Save/Load Mission modules
";

comment "
	Change Log:
 - Fixed action issue where restrained players could unrestrain themselves
 
";
