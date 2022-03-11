MAZ_EZM_LiteVersion = "V1.6D";
MAZ_EZM_autoAdd = profileNamespace getVariable ['MAZ_EZM_autoAddVar',true];

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
		_combo lbAdd ".   ";
		_combo lbAdd ".    ";

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

	MAZ_EZM_fnc_createZeusSidesRow = {
		params ["_display","_defaultValue","_settings"];
		private _rowControlGroup = [_display] call MAZ_EZM_fnc_createRowBase;

		_rowControlGroup ctrlSetPositionH (["H",2.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat);

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

		private _logic = _display ctrlCreate ["RscActivePicture",IDC_SIDES_CIVILIAN,_sidesGroup];
		_logic ctrlSetText "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\side_civ_ca.paa";
		_logic ctrlSetPosition [(["W",11.5] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",0.25] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["W",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat),(["H",2] call MAZ_EZM_fnc_convertToGUI_GRIDFormat)];
		_logic ctrlCommit 0;

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
					private _phi = _i * _intervals;
					drawIcon3D ["\a3\ui_f\data\map\markers\military\dot_ca.paa", _color, [_radius * cos _phi + (_center # 0),_radius * sin _phi + (_center # 1),0], 0.5, 0.5, 0];
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

		IDCS_ROW_COLOR = [IDC_ROW_COLOR_RED,IDC_ROW_COLOR_GREEN,IDC_ROW_COLOR_BLUE,IDC_ROW_COLOR_ALPHA];
		IDCS_ROW_COLOR_EDIT = [IDC_ROW_COLOR_RED_EDIT,IDC_ROW_COLOR_GREEN_EDIT,IDC_ROW_COLOR_BLUE_EDIT,IDC_ROW_COLOR_ALPHA_EDIT];
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
						"WIP : Edit Unit's skills.", 
						{
							params ["_display","_args"];
							_display closeDisplay 0;
							[_args] spawn MAZ_EZM_createSkillsDialog;
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
		_attributes params ["_name","_skill","_form","_beh","_sped","_stance"];
		_group setGroupIdGlobal [_name];
		_group setFormation _form;
		_group setBehaviour _beh;
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
					"Skill:",
					[skill (leader _group),0,1,true]
				],
				[
					"ICONS",
					"Formation:",
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
					"Stance:",
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

	MAZ_EZM_openVehicleGarageAttribs = {
		params ["_vehicle"];

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
	systemChat "[ Enhanced Zeus Modules ] : Curator unassigned.";

	systemChat "[ Enhanced Zeus Modules ] : Attempting assign...";
	while{isNull (getAssignedCuratorUnit _zeusLogic)} do {
		[player,(allCurators select _zeusIndex)] remoteExec ['assignCurator',2];
		sleep 0.1;
	};

	waitUntil{getAssignedCuratorLogic player == _zeusLogic};
	systemChat "[ Enhanced Zeus Modules ] : Curator assigned.";
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
		"ModuleObjectiveRaceStart_F"
	];
	if(_entityType in _objectiveModules) exitWith {
		[_entity] spawn {
			params ["_entity"];
			waitUntil {dialog};
			[player] joinSilent (createGroup [sideLogic,true]);
			closeDialog 2;
			waitUntil {!dialog};
			playSound "addItemFailed";
			systemChat "[ Enhanced Zeus Modules ] : You must be side LOGIC to edit an objective! You've been changed to this side, re-open the module.";
		};
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
				_parentTree tvSetPictureColor [_tvModulePath, [0,0.75,0.75,1]];
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

JAM_GUIfnc_setZeusTransparency = {
	params [['_alpha', 1]];
	with uiNamespace do 
	{
		((findDisplay 312) displayCtrl 16304) ctrlSetBackgroundColor [0.18, 0.19, 0.21, _alpha]; 
		((findDisplay 312) displayCtrl 16304) ctrlCommit 0;

		((findDisplay 312) displayCtrl 15505) ctrlSetBackgroundColor [0.18, 0.19, 0.21, _alpha]; 
		((findDisplay 312) displayCtrl 15505) ctrlCommit 0;

		((findDisplay 312) displayCtrl 16105) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha];  
		((findDisplay 312) displayCtrl 16105) ctrlSetText format ['EZM Lite %1',missionNamespace getVariable ['MAZ_EZM_LiteVersion','']];
		((findDisplay 312) displayCtrl 16105) ctrlSetTextColor [0,0.9,0.9,1];
		((findDisplay 312) displayCtrl 16105) ctrlCommit 0; 

		((findDisplay 312) displayCtrl 16104) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha];  
		((findDisplay 312) displayCtrl 16104) ctrlSetTextColor [0,0.9,0.9,1];
		((findDisplay 312) displayCtrl 16104) ctrlCommit 0; 

		((findDisplay 312) displayCtrl 15513) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha];  
		((findDisplay 312) displayCtrl 15513) ctrlCommit 0; 

		((findDisplay 312) displayCtrl 16306) ctrlSetTextColor [0,0,0,1]; 
		((findDisplay 312) displayCtrl 16306) ctrlCommit 0; 

		((findDisplay 312) displayCtrl 15715) ctrlSetTextColor [0,0.75,0.75,1];
		((findDisplay 312) displayCtrl 15715) ctrlCommit 0; 

		((findDisplay 312) displayCtrl 15508) ctrlSetBackgroundColor [0.18, 0.19, 0.21, _alpha];  
		((findDisplay 312) displayCtrl 15508) ctrlCommit 0;

		((findDisplay 312) displayCtrl 15506) ctrlSetBackgroundColor [0.21, 0.22, 0.25, _alpha];  
		((findDisplay 312) displayCtrl 15506) ctrlCommit 0;

		((findDisplay 312) displayCtrl 15518) ctrlSetBackgroundColor [0.18, 0.19, 0.21, _alpha]; 
		((findDisplay 312) displayCtrl 15518) ctrlCommit 0;

		((findDisplay 312) displayCtrl 280) ctrlSetBackgroundColor [0.25, 0.27, 0.29, _alpha * 0.5]; 
		((findDisplay 312) displayCtrl 280) ctrlCommit 0;

		((findDisplay 312) displayCtrl 283) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha]; 
		((findDisplay 312) displayCtrl 283) ctrlCommit 0; 

		((findDisplay 312) displayCtrl 646) ctrlSetBackgroundColor [0.13, 0.13, 0.15, _alpha]; 
		((findDisplay 312) displayCtrl 646) ctrlCommit 0; 

		((findDisplay 312) displayCtrl 152) ctrlSetTextColor [0,0.75,0.75,1]; 
		((findDisplay 312) displayCtrl 152) ctrlAddEventHandler ["MouseButtonClick",{
			params ["_control"];
			_control spawn {
				uiSleep 0.1;
				_this ctrlSetTextColor [0,0.75,0.75,1]; 
				_this ctrlCommit 0; 
			};
		}];
		((findDisplay 312) displayCtrl 152) ctrlCommit 0; 

		((findDisplay 312) displayCtrl 15515) ctrlSetTextColor [0,0.5,0.5,1];
		((findDisplay 312) displayCtrl 15515) ctrlCommit 0;
	};
};

MAZ_EZM_fnc_initFunction = {

		MAZ_EZM_fnc_getScreenPosition = {
			params [["_screenPos",getMousePosition,[[]],2]];

			if(visibleMap) then {
				private _ctrlMap  = findDisplay 312 displayCtrl 50;
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
				playSound "addItemFailed";
				systemChat "[ Enhanced Zeus Modules ] : Already selecting a second position!";
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
				systemChat "[ Enhanced Zeus Modules ] : Selection cancelled.";
				playSound "addItemFailed";
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
				_sound1 = 'vr_shutdown';
				playSound 
				[
					_sound1,
					true
				];
				playSound 
				[
					_sound1,
					false
				];
				sleep 6.5;
				titleFadeOut 1;
			};
		};

		MAZ_EZM_fnc_autoResupplyAI = {
			params ["_unit"];
			_unit setUnitPos "UP";
			_unit addEventHandler ["Reloaded", { 
				params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"]; 
				_oldMagazine params ["_type","_count"];
				_unit addMagazine _type;
			}];
		};

	comment "AI Modifiers";

		MAZ_EZM_fnc_setAmbientAnimationModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};
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
				if(_anim == "") then {
					[_args,"AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove"];
					_args setBehaviour "AWARE";
					[_args,"Move"]remoteExec ["enableAI",0];
					[_args,"Anim"]remoteExec ["enableAI",0];
					systemChat "[ Enhanced Zeus Modules ] : Animation reset.";
				} else {
					(group _args) setBehaviour "CARELESS";
					[_args,"Move"]remoteExec ["disableAI",0];
					[_args,"Anim"]remoteExec ["disableAI",0];
					[_args,_anim] remoteExec ['switchMove',0];
					_args setVariable ["MAZ_EZM_animDone",
						_args addEventhandler ["AnimDone",{
							params ["_unit","_anim"];
							[_args,_anim] remoteExec ['switchMove',0];
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
					systemChat "[ Enhanced Zeus Modules ] : Animation set.";
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
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};
			if((behaviour _entity) == "CARELESS") then {
				[group _entity,"AWARE"] remoteExec ['setBehaviour'];
				systemChat format ["[ Enhanced Zeus Modules ] : %1's group is now aware.",name _entity];
				playSound 'addItemOk';
			} else {
				[group _entity,"CARELESS"] remoteExec ['setBehaviour'];
				systemChat format ["[ Enhanced Zeus Modules ] : %1's group is now careless.",name _entity];
				playSound 'addItemOk';
			};
		};

		MAZ_EZM_fnc_easyModeModule = {
			params ["_entity"];
			if(isNil "MAZ_EZM_EZMode") then {
				MAZ_EZM_EZMode = false;
			};
			if(MAZ_EZM_EZMode) then {
				MAZ_EZM_EZMode = false;
				playSound "addItemOk";
				systemChat "[ Enhanced Zeus Modules ] : EZ Mode turned off.";
			} else {
				MAZ_EZM_EZMode = true;
				playSound "addItemOk";
				systemChat "[ Enhanced Zeus Modules ] : EZ Mode turned on.";
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
			if(isNull _entity || !((typeOf _entity) isKindOf "CAManBase")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};
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
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};
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
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};
			[_entity] spawn {
				_object =  _this select 0;
				_groupUnderCursor = group _object;
				if (local (leader _groupUnderCursor)) then
				{
					
					private _outsidePos = [getPos (leader _groupUnderCursor), [3,15], 2, 0] call MAZ_EZM_fnc_getSafePos;

					{
						_x setUnitPos "AUTO";
						_x forceSpeed -1;
						_x doWatch objNull;
						_x doMove _outsidePos;
					} forEach(units _groupUnderCursor);
				};
				[getAssignedCuratorLogic _object,"AI are leaving the building"] call BIS_fnc_showCuratorFeedbackMessage;
				playSound 'addItemOk';
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

			systemChat "[ Enhanced Zeus Modules ] : Units have their lasers/lights turned on.";
			playSound 'addItemOk';
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

			systemChat "[ Enhanced Zeus Modules ] : Units have their lasers/lights turned off.";
			playSound 'addItemOk';
		};

		MAZ_EZM_fnc_makeHostageModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};

			[_entity,true] remoteExec ["setCaptive",0];
			[_entity,"Move"]remoteExec ["disableAI",0];
			[_entity,"Acts_AidlPsitMstpSsurWnonDnon_loop"] remoteExec["switchMove",0];
			private _holdActionIndex = [
				_entity,											
				"Free Hostage",										
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",	
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_secure_ca.paa",	
				"_this distance _target < 3",						
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

			systemChat "[ Enhanced Zeus Modules ] : Unit is now a hostage, they can be freed by scrolling on them.";
			playSound 'addItemOk';
		};

		MAZ_EZM_fnc_makeHVTModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};

			[[_entity],{
				params ["_nearestMan"];
				_nearestMan addEventHandler ["Killed",{
					params ["_unit", "_killer", "_instigator", "_useEffects"];
					["TaskSucceeded",["",format ["%1 was killed by %2",name _unit,name _killer]]] remoteExec ['BIS_fnc_showNotification',0];
				}];
			}] remoteExec ['spawn',0,_entity];
			systemChat "[ Enhanced Zeus Modules ] : HVT created, all players will be notified of their death.";
			playSound 'addItemOk';
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
						systemChat "[ Enhanced Zeus Modules ] : Difficulty set to EASY.";
					};
					case "medium": {
						[[], {
							{
								_x setSkill 0.5;
							} forEach allUnits;
						}] remoteExec ["spawn"];
						systemChat "[ Enhanced Zeus Modules ] : Difficulty set to MEDIUM.";
					};
					case "hard": {
						[[], {
							{
								_x setSkill 1;
							} forEach allUnits;
						}] remoteExec ["spawn"];
						systemChat "[ Enhanced Zeus Modules ] : Difficulty set to HARD.";
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
				[[_value],{
					params ["_mode"];
					{
						_x setUnitPos _mode;
					}forEach allunits;
				}] remoteExec ['spawn'];
				systemChat format ["[ Enhanced Zeus Modules ] : All units stance mode set to %1.",_value];
				playSound 'addItemOk';
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

		MAZ_EZM_fnc_toggleSurrenderModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};

			private _isSurrendered = _entity getVariable ['EZM_isSurrendered',false];
			if(_isSurrendered) then {
				[_entity,"AmovPercMstpSnonWnonDnon"] remoteExec ["switchMove"];
				[_entity,false] remoteExec ["setCaptive",0];
				_entity setVariable ['EZM_isSurrendered',false,true];
				
				systemChat "[ Enhanced Zeus Modules ] : Unit is no longer surrendered.";
				playSound "addItemOk";
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

				systemChat "[ Enhanced Zeus Modules ] : Unit is now surrendered.";
				playSound "addItemOk";
			};
		};

		MAZ_EZM_fnc_suppressiveFireModule = {
			params ["_entity"];
			if(!(_entity isKindOf "CAManBase") && !(_entity isKindOf "StaticMGWeapon")) exitWith {playSound "addItemFailed"; systemChat "[ Enhanced Zeus Modules ] : Object is not a man!"};
			if(_entity isKindOf "StaticMGWeapon") then {
				if(gunner _entity == objNull) exitWith {playSound "addItemFailed"; systemChat "[ Enhanced Zeus Modules ] : No gunner!"};
				_entity = gunner _entity;
			};
			if(_entity getVariable ["MAZ_EZM_isSuppressing",false]) exitWith {playSound "addItemFailed"; systemChat "[ Enhanced Zeus Modules ] : Unit is already suppressing!"};
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
			[[_arsenalObject],{
				params ["_closestObject"];
				{
					_x addCuratorEditableObjects [[_closestObject],true];
				} foreach allCurators;
			}] remoteExec ["Spawn",2];
			
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

			systemChat "[ Enhanced Zeus Modules ] : Full Arsenal Created.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_createAIOArsenalModule = {
			params ["_entity"];
			if (isNull _entity) exitWith {
				systemChat "[ Enhanced Zeus Modules ] : No object provided!";
				playSound ['addItemFailed', false];
			};
			["AmmoboxInit",[_entity,true]] call BIS_fnc_arsenal;
			M9SD_fnc_addSmallArsenalActions = {
				params [['_supplyCrate', objNull]];
				if (isNull _supplyCrate) exitWith {0 = ['null supply crate'] spawn M9SD_fnc_errorMessage_AIOArsenal;}; 
				if (_supplyCrate getVariable ['M9SD_hasArsenalActions', false]) exitWith {0 = ['Object already has AIO Arsenal actions enabled.'] spawn M9SD_fnc_errorMessage_AIOArsenal;};
				_supplyCrate setVariable ['M9SD_hasArsenalActions', true, true];
				if (isNil 'M9SD_AIOArsenal_JIPCount') then 
				{
					M9SD_AIOArsenal_JIPCount = 0;
				};
				M9SD_AIOArsenal_JIPCount = M9SD_AIOArsenal_JIPCount + 1;
				publicVariable 'M9SD_AIOArsenal_JIPCount';
				private _uniqueJIP = format ['M9SD_JIP_AIOArsenalActions_%1', M9SD_AIOArsenal_JIPCount];
				[[_supplyCrate, _uniqueJIP],
				{
					if (!hasInterface) exitWith {};
					params [['_supplyCrate', objNull], ['_uniqueJIP', '']];
					if (isNull _supplyCrate) exitWith {remoteExec ['', _uniqueJIP]};
					_supplyCrate addAction 
					[
						"<t color='#FFFFFF' size='1.4'><img image='a3\ui_f\data\logos\a_64_ca.paa'></img><t color='#ffd700' size='1.4' font='puristaBold'> Full Arsenal</t>", 
						{
							playSound ['beep_target', true];
							playSound ['beep_target', false];
							['Preload'] call BIS_fnc_arsenal;
							comment "['Open', [true]] call BIS_fnc_arsenal; <-- WTF IS THE DIFFERENCE?";
							['Open', true] spawn BIS_fnc_arsenal;
							0 = [] spawn 
							{
								for '_i' from 1 to 12 do 
								{
									(format ['arsenalNotification%1', _i]) cutFadeOut 0;
								};
								'arsenalNotification1' cutText ["<br/><t color='#ffd700' size='2.1' shadow='2' font='puristaMedium'>AIO Arsenal</t>", "PLAIN DOWN", -1, true, true];
								uiSleep 1;
								if !(isNull findDisplay -1) then 
								{
									'arsenalNotification2' cutFadeOut 0;
									'arsenalNotification2' cutText ["<br/><br/><br/><t color='#00a6ff' size='1.4' shadow='2' font='puristaSemiBold'>by <t color='#00c9ff'>M9-SD</t>", "PLAIN DOWN", -1, true, true];
								};
								uiSleep 7;
								'arsenalNotification1' cutFadeOut 2.1;
								'arsenalNotification2' cutFadeOut 2.1;
							};
							private _arsenalAnims = 
							[
								{player playActionNow "Salute";},
								{[player, 'acts_civilidle_1'] remoteExec ['switchMove'];},
								{[player, 'acts_civilListening_2'] remoteExec ['switchMove'];},
								{[player, 'acts_commenting_on_fight_loop'] remoteExec ['switchMove'];},
								{[player, 'acts_gallery_visitor_01'] remoteExec ['switchMove'];},
								{[player, 'acts_gallery_visitor_02'] remoteExec ['switchMove'];},
								{[player, 'acts_hilltop_calibration_loop'] remoteExec ['switchMove'];},
								{[player, 'acts_kore_talkingoverradio_loop'] remoteExec ['switchMove'];},
								{[player, 'acts_staticPose_photo'] remoteExec ['switchMove'];},
								{player playActionNow 'gear';},
								{[player, 'Acts_Taking_Cover_From_Jets'] remoteExec ['switchMove'];},
								{[player, 'Acts_standingSpeakingUnarmed'] remoteExec ['switchMove'];},
								{player playMoveNow 'acts_Mentor_Freeing_Player';},
								{[player, 'acts_kore_talkingOverRadio_In'] remoteExec ['switchMove'];},
								{[player, 'acts_kore_idleNoWeapon_In'] remoteExec ['switchMove'];},
								{[player, 'Acts_JetsOfficerSpilling'] remoteExec ['switchMove'];},
								{player playMoveNow 'Acts_Hilltop_Calibration_Pointing_Left';},
								{player playMoveNow 'Acts_Hilltop_Calibration_Pointing_Right';},
								{[player, 'Acts_Grieving'] remoteExec ['switchMove'];}
							];
							private _arsenalAnimsAdd = switch (currentWeapon player) do 
							{
								case '': {[]};
								case (primaryWeapon player): 
								{
									[
										{[player, 'acts_briefing_SA_loop'] remoteExec ['switchMove'];},
										{[player, 'acts_getAttention_loop'] remoteExec ['switchMove'];},
										{[player, 'acts_millerIdle'] remoteExec ['switchMove'];},
										{player playMoveNow 'Acts_SupportTeam_Right_ToKneelLoop';},
										{player playMoveNow 'Acts_SupportTeam_Left_ToKneelLoop';},
										{player playMoveNow 'Acts_SupportTeam_Front_ToKneelLoop';},
										{player playMoveNow 'Acts_SupportTeam_Back_ToKneelLoop';},
										{[player, 'Acts_starGazer'] remoteExec ['switchMove'];},
										{player playMoveNow 'acts_RU_briefing_Turn';},
										{player playMoveNow 'acts_RU_briefing_point';},
										{player playMoveNow 'acts_RU_briefing_point_tl';},
										{player playMoveNow 'acts_RU_briefing_move';},
										{[player, 'acts_rifle_operations_zeroing'] remoteExec ['switchMove'];},
										{player playMoveNow 'acts_rifle_operations_right';},
										{player playMoveNow 'acts_rifle_operations_left';},
										{player playMoveNow 'acts_rifle_operations_front';},
										{player playMoveNow 'acts_rifle_operations_checking_chamber';},
										{player playMoveNow 'acts_rifle_operations_barrel';},
										{player playMoveNow 'acts_rifle_operations_back';},
										{player playMoveNow 'acts_pointing_up';},
										{player playMoveNow 'acts_pointing_down';},
										{player playMoveNow 'acts_peering_up';},
										{player playMoveNow 'acts_peering_down';},
										{player playMoveNow 'acts_peering_front';},
										{[player, 'Acts_Helping_Wake_Up_1'] remoteExec ['switchMove'];}
									]
								};
								case (handgunWeapon player): 
								{
									[
										{[player, 'acts_examining_device_player'] remoteExec ['switchMove'];},
										{[player, 'acts_executioner_standingloop'] remoteExec ['switchMove'];},
										{player playMoveNow 'Acts_ViperMeeting_A_End';},
										{player playMoveNow 'Acts_UGV_Jamming_Loop';},
										{player playMoveNow 'Acts_starterPistol_Fire';}
									]
								};
								default {[]};
							};
							_arsenalAnims = _arsenalAnims + _arsenalAnimsAdd;
							private _playAnim = selectRandom _arsenalAnims;
							call _playAnim;
							if !(isNil "M9SD_EH_ResetPlayerAnimsOnArsenalClosed") then 
							{
								(findDisplay 46) displayRemoveEventHandler ['keyDown', M9SD_EH_ResetPlayerAnimsOnArsenalClosed];
							};
							M9SD_EH_ResetPlayerAnimsOnArsenalClosed = (findDisplay 46) displayAddEventHandler ['keyDown', 
							{
								params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
								private _w = 17;
								private _a = 30;
								private _s = 31;
								private _d = 32;
								private _keys = [_w, _a, _s, _d];
								if (_key in _keys) then 
								{
									comment 
									"
									playSound ['addItemOK', true];
									playSound ['addItemOK', false];
									";
									if !(isNil "M9SD_EH_ResetPlayerAnimsOnArsenalClosed") then 
									{
										(findDisplay 46) displayRemoveEventHandler ['keyDown', M9SD_EH_ResetPlayerAnimsOnArsenalClosed];
									};
									player enableSimulation true;
									player playActionNow '';
									player playMoveNow '';
									player switchMove '';
									if (isMultiplayer) then {[player, ''] remoteExec ['switchMove']};
									'arsenalNotification1' cutFadeOut 0;
									'arsenalNotification2' cutFadeOut 0;
									comment 
									"
									playSound ['hintCollapse', true];
									playSound ['hintCollapse', false];
									";
								};
							}];
							playSound ['hintExpand', true];
							playSound ['hintExpand', false];
						}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
					];
					_supplyCrate addAction 
					[
						"<t color='#FFFFFF' size='1.4'><img image='\A3\ui_f\data\map\diary\icons\taskCustom_ca.paa'></img><t color='#ffd700' size='1.4' font='puristaBold'> Copy Loadout</t>", 
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
					_supplyCrate addAction 
					[
						"<t color='#FFFFFF' size='1.4'><img image='a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_gear_ca.paa'></img><t color='#ffd700' size='1.4' font='puristaBold'> Empty Loadout</t>", 
						{
							playSound ['beep_target', true];
							playSound ['beep_target', false];
							player playmovenow 'AinvPknlMstpSnonWnonDnon_1';
							removeAllWeapons player;
							removeAllItems player;
							removeAllAssignedItems player;
							removeUniform player;
							removeVest player;
							removeBackpack player;
							removeHeadgear player;
							removeGoggles player;
							0 = [] spawn 
							{
								for '_i' from 1 to 12 do 
								{
									(format ['arsenalNotification%1', _i]) cutFadeOut 0;
								};
								'arsenalNotification4' cutFadeOut 0; 
								'arsenalNotification4' cutText ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>Loadout removed.</t>", "PLAIN DOWN", -1, true, true];
								uiSleep 3.5;
								'arsenalNotification4' cutFadeOut 0.35;
							};
							playSound ['hintExpand', true];
							playSound ['hintExpand', false];
						}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
					];
					_supplyCrate addAction 
					[
						"<t color='#FFFFFF' size='1.4'><img image='a3\3den\data\displays\Display3DEN\ToolBar\save_ca.paa'></img><t color='#ffd700' size='1.4' font='puristaBold'> Save Respawn Loadout</t>", 
						{
							playSound ['beep_target', true];
							playSound ['beep_target', false];
							player playActionNow 'putdown';
							[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_saveInventory;
							if (!isNil "M9SD_EH_arsenalRespawnLoadout") then 
							{
								player removeEventHandler ["Respawn", M9SD_EH_arsenalRespawnLoadout];
							};
							M9SD_EH_arsenalRespawnLoadout = player addEventHandler
							[
								"Respawn",
								{
									0 = [] spawn 
									{
										waitUntil {(alive player)};
										sleep 0.07;
										[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_loadInventory;
									};
								}
							];
							0 = [] spawn 
							{
								for '_i' from 1 to 12 do 
								{
									(format ['arsenalNotification%1', _i]) cutFadeOut 0;
								};
								'arsenalNotification6' cutFadeOut 0; 
								'arsenalNotification6' cutText ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>Respawn loadout set.</t>", "PLAIN DOWN", -1, true, true];
								uiSleep 3.5;
								'arsenalNotification6' cutFadeOut 0.35;
							};
							playSound ['hintExpand', true];
							playSound ['hintExpand', false];
						}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
					];
					_supplyCrate addAction 
					[
						"<t color='#FFFFFF' size='1.4'><img image='a3\3den\data\displays\Display3DEN\ToolBar\open_ca.paa'></img><t color='#ffd700' size='1.4' font='puristaBold'> Load Respawn Loadout</t>", 
						{
							playSound ['beep_target', true];
							playSound ['beep_target', false];
							player playActionNow 'putdown';
							if (isNil 'M9SD_EH_arsenalRespawnLoadout') then 
							{
								playSound ['AddItemFailed', true];
								playSound ['AddItemFailed', false];
								0 = [] spawn 
								{
									for '_i' from 1 to 12 do 
									{
										(format ['arsenalNotification%1', _i]) cutFadeOut 0;
									};
									'arsenalNotification12' cutFadeOut 0; 
									'arsenalNotification12' cutText ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>ERROR:<br/>No respawn loadout saved.</t>", "PLAIN DOWN", -1, true, true];
									uiSleep 3.5;
									'arsenalNotification12' cutFadeOut 0.35;
								};
							} else 
							{
								[player, [missionnamespace, "M9SD_arsenalRespawnLoadout"]] call BIS_fnc_loadInventory;
								0 = [] spawn 
								{
									for '_i' from 1 to 12 do 
									{
										(format ['arsenalNotification%1', _i]) cutFadeOut 0;
									};
									'arsenalNotification12' cutFadeOut 0; 
									'arsenalNotification12' cutText ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>Respawn loadout applied.</t>", "PLAIN DOWN", -1, true, true];
									uiSleep 3.5;
									'arsenalNotification12' cutFadeOut 0.35;
								};
								playSound ['hintExpand', true];
								playSound ['hintExpand', false];
							};
						}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
					];
					_supplyCrate addAction 
					[
						"<t color='#FFFFFF' size='1.4'><img image='\a3\3den\data\Cfg3DEN\History\deleteItems_ca.paa'></img><t color='#ffd700' size='1.4' font='puristaBold'> Delete Respawn Loadout</t>", 
						{
							playSound ['beep_target', true];
							playSound ['beep_target', false];
							player playActionNow 'putdown';
							if (!isNil "M9SD_EH_arsenalRespawnLoadout") then 
							{
								player removeEventHandler ["Respawn", M9SD_EH_arsenalRespawnLoadout];
							};
							0 = [] spawn 
							{
								for '_i' from 1 to 12 do 
								{
									(format ['arsenalNotification%1', _i]) cutFadeOut 0;
								};
								'arsenalNotification5' cutFadeOut 0; 
								'arsenalNotification5' cutText ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>Respawn loadout disabled.</t>", "PLAIN DOWN", -1, true, true];
								uiSleep 3.5;
								'arsenalNotification5' cutFadeOut 0.35;
							};
							playSound ['hintExpand', true];
							playSound ['hintExpand', false];
						}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
					];
					_supplyCrate addAction 
					[
						"<t color='#FFFFFF' size='1.4'><img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\heal_ca.paa'></img><t color='#ffd700' size='1.4' font='puristaBold'> Heal</t>", 
						{
							playSound ['beep_target', true];
							playSound ['beep_target', false];
							player playActionNow 'Medic';
							[player] call BIS_fnc_reviveEhRespawn;
							player setDamage 0;
							player setUnconscious false;
							player setCaptive false;
							0 = [] spawn 
							{
								for '_i' from 1 to 12 do 
								{
									(format ['arsenalNotification%1', _i]) cutFadeOut 0;
								};
								'arsenalNotification3' cutFadeOut 0; 
								'arsenalNotification3' cutText ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>Healing...</t>", "PLAIN DOWN", -1, true, true];
								uiSleep 6.33;
								playSound ['hintCollapse', true];
								playSound ['hintCollapse', false];
								'arsenalNotification3' cutFadeOut 0; 
								'arsenalNotification3' cutText ["<t color='#ffd700' font='puristaMedium' shadow='2' size='1.4'>Healed.</t>", "PLAIN DOWN", -1, true, true];
								uiSleep 3.33;
								'arsenalNotification3' cutFadeOut 0.35;
							};
							playSound ['hintExpand', true];
							playSound ['hintExpand', false];
						}, nil, 7777, true, true, "", "(_this == vehicle _this)", 7
					];
				}] remoteExec ['spawn', 0, _uniqueJIP];
			};
			[_entity] call M9SD_fnc_addSmallArsenalActions;
			M9SD_fnc_smallArsenalMarkers = {
				params [['_supplyCrate', objNull]];
				if (isNull _supplyCrate) exitWith {0 = ['null supply crate'] spawn M9SD_fnc_errorMessage_AIOArsenal;};
				if (_supplyCrate getVariable ['M9SD_hasMarkers', false]) exitWith {0 = ['Object already has AIO Arsenal markers enabled.'] spawn M9SD_fnc_errorMessage_AIOArsenal;};
				_supplyCrate setVariable ['M9SD_hasMarkers', true, true];
				if (isNil 'M9SD_smallArsenals') then 
				{
					M9SD_smallArsenals = [];
				};
				M9SD_smallArsenals pushBackUnique _supplyCrate;
				publicVariable 'M9SD_smallArsenals'; 
				[M9SD_smallArsenals,
				{
					if (!hasInterface) exitWith {};
					waitUntil { !isNil { player } && { !isNull player } };
					waitUntil { !isNull (findDisplay 46) };
					if (isNil 'M9SD_smallArsenals') then 
					{
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
					if (not (isNil 'M9SD_EH_drawSmallArsenal3D')) then 
					{
						removeMissionEventHandler ['Draw3D', M9SD_EH_drawSmallArsenal3D];
					};
					M9SD_EH_drawSmallArsenal3D = addMissionEventHandler ['Draw3D', 
					{
						if (count M9SD_smallArsenals == 0) exitWith {};
						{
							if (!isNull _x) then 
							{
								if (_x in [cursorTarget, cursorObject]) then 
								{
									if ((_x distance (vehicle player)) <= 28) then 
									{
										private _position = getPos _x;
										_position set [2, (_position # 2) + M9SD_smallArsenalIcons_offset];
										drawIcon3D 
										[
											M9SD_smallArsenalIcons_texture,
											[1,1,1,1],
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
											'',
											[1,0.9,0,1],
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
						} forEach M9SD_smallArsenals;
					}];
					waitUntil {!isNull (findDisplay 12 displayCtrl 51)};
					if (!isNil "M9SD_EH_drawSmallArsenal2D") then 
					{
						(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw", M9SD_EH_drawSmallArsenal2D];
					};
					M9SD_EH_drawSmallArsenal2D = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw", 
					{
						if (count M9SD_smallArsenals == 0) exitWith {};
						{
							if (!isNull _x) then 
							{
								private _iconPath = 'a3\ui_f\data\logos\a_64_ca.paa';
								private _pos = _x modelToWorldVisual [0,0,0];
								private _color = [1, 0.9, 0, 1];
								_iconText = if ((((_this select 0) ctrlMapWorldToScreen (_x modelToWorldVisual [0,0,0])) distance2D getMousePosition) > 0.02) then {""} else {'Virtual Arsenal'};
								_this select 0 drawIcon
								[
									_iconPath,
									_color,
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
								_color = [1,1,1,1];
								_this select 0 drawIcon
								[
									_iconPath,
									_color,
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
						} foreach M9SD_smallArsenals;
					}];
				}] remoteExec ['spawn', 0, 'M9SD_JIP_smallArsenalIcons'];
				comment "
				M9SD_smallArsenals = [];
				publicVariable 'M9SD_smallArsenals';
				remoteExec ['', 'M9SD_JIP_smallArsenalIcons'];
				";
			};
			[_entity] call M9SD_fnc_smallArsenalMarkers;
			private _objType = typeOf _entity;
			private _objName = if (isPlayer _entity) then {name _entity} else {getText (configFile >> 'cfgVehicles' >> _objType >> 'displayName')};
			if (_objName == '') then {_objName = _objType;};
			systemChat format ["[ Enhanced Zeus Modules ] : AIO Arsenal created on %1.",_objName];
			playSound ['addItemOk', false];
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
			playSound "addItemOk";
			systemChat "[ Enhanced Zeus Modules ] : Automated Helicopter Crashes disabled.";
		};

		MAZ_EZM_fnc_createRandomConvoyModule = {
			if(worldName != "Altis") exitWith {playSound "addItemFailed";systemChat "[ Enhanced Zeus Modules ] : Currently only configured for Altis! You can create your own by contacting Expung3d!"};
			MAZ_EZM_autoConvoy = true;
			publicVariable 'MAZ_EZM_autoConvoy';
			[] call MAZ_EZM_fnc_newConvoyMission;
		};

		MAZ_EZM_fnc_turnOffRandomConvoyModule = {
			if(worldName != "Altis") exitWith {playSound "addItemFailed";systemChat "[ Enhanced Zeus Modules ] : Currently only configured for Altis!"};
			MAZ_EZM_autoConvoy = false;
			publicVariable 'MAZ_EZM_autoConvoy';
			playSound "addItemOk";
			systemChat "[ Enhanced Zeus Modules ] : Automated Convoy Missions disabled.";
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
				if(!(toUpper _town in _locationNames) && ((toUpper _town) != "NONE" && (toUpper _town) != "")) exitWith {playSound "addItemFailed"; systemChat "[ Enhanced Zeus Modules ] : No such town!"};
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
			copyToClipboard (str _side);
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

			[[_units],{
				params ["_objs"];
				{
					_x addCuratorEditableObjects [_objs,true];
				} foreach allCurators;
			}] remoteExec ["Spawn",2];

			["TaskAssignedIcon",["A3\UI_F\Data\Map\Markers\Military\warning_CA.paa",_townAlert]] remoteExec ['BIS_fnc_showNotification',0];

			true
		};

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
			systemChat format ["[ Enhanced Zeus Modules ] : %1 empty groups deleted.",_totalEmptyGroupsDeleted];
			playSound 'addItemOk';
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
				systemChat format ["[ Enhanced Zeus Modules ] : %1 dead objects and clutter deleted.",_clutterDeleted];
				systemChat format ["[ Enhanced Zeus Modules ] : %1 empty groups deleted.",_totalEmptyGroupsDeleted];
				playSound 'addItemOk';
			};
		};

		MAZ_EZM_fnc_deleteMinesModule = {
			params ["_entity"];
			private _numOfMines = 0;
			{
				deleteVehicle _x;
				_numOfMines = _numOfMines + 1;
			} forEach allMines;
			systemChat format ["[ Enhanced Zeus Modules ] : %1 mines deleted.",_numOfMines];
			playSound 'addItemOk';
		};

		MAZ_EZM_fnc_deleteMarkersModule = {
			private _numOfMarkers = 0;
			{
				deleteMarker _x;
				_numOfMarkers = _numOfMarkers + 1;
			}forEach allMapMarkers;
			systemChat format ["[ Enhanced Zeus Modules ] : %1 map markers deleted.",_numOfMines];
			playSound 'addItemOk';
		};

		MAZ_EZM_fnc_deleteEverythingModule = {
			[] spawn {
				systemChat "[ Enhanced Zeus Modules ] : Filtering map objects...";
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
				systemChat "[ Enhanced Zeus Modules ] : Map objects filtered.";

				{
					deleteVehicle _x;
				} forEach _goodObjects;
				systemChat "[ Enhanced Zeus Modules ] : Map objects deleted.";
				playSound 'addItemOk';
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
				{
					deleteVehicle _x;
				} forEach nearestObjects [_args,[],_values # 0];
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
			
			systemChat "[ Enhanced Zeus Modules ] : Protection zones removed.";
			playSound 'addItemOk';
		};

	comment "Create/Delete Ships";

		MAZ_EZM_fnc_createCarrierModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {playSound "addItemFailed"; systemChat "[ Enhanced Zeus Modules ] : No boat selected!";};
			if !(_entity isKindOf "Ship") exitWith {playSound "addItemFailed"; systemChat "[ Enhanced Zeus Modules ] : Object is not a boat!";};
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
			playSound "addItemOk";
			systemChat "[ Enhanced Zeus Modules ] : USS Freedom Carrier deployed!";
		};

		MAZ_EZM_fnc_createDestroyerModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {playSound "addItemFailed"; systemChat "[ Enhanced Zeus Modules ] : No boat selected!";};
			if !(_entity isKindOf "Ship") exitWith {playSound "addItemFailed"; systemChat "[ Enhanced Zeus Modules ] : Object is not a boat!";};
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
			playSound "addItemOk";
			systemChat "[ Enhanced Zeus Modules ] : USS Liberty Destroyer deployed!";
		};

		MAZ_EZM_fnc_deleteAllCarriersModule = {
			private _data = (getArray (configfile >> 'CfgVehicles' >> 'Land_Carrier_01_base_F' >> 'multiStructureParts'));
			{
				_x params ['_class','_pos'];
				{
					deleteVehicle _x;
				} foreach allMissionObjects _class;
			} foreach _data;

			systemChat "[ Enhanced Zeus Modules ] : All Aircraft Carriers are deleted.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_deleteAllDestroyersModule = {
			private _data = (getArray (configfile >> 'CfgVehicles' >> 'Land_Destroyer_01_base_F' >> 'multiStructureParts'));
			{
				_x params ['_class','_pos'];
				{
					deleteVehicle _x;
				} foreach allMissionObjects _class;
			} foreach _data;

			systemChat "[ Enhanced Zeus Modules ] : All Destroyers are deleted.";
			playSound "addItemOk";
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

				[[_mines],
				{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [_objs,true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

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
				[[_iedObject],{
					params ["_iedObject"];
					{
						_x addCuratorEditableObjects [[_iedObject],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];
				systemChat "[ Enhanced Zeus Modules ] : IED created.";
				playSound 'addItemOk';
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
					["High Command"]
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
					playSound "addItemFailed";
					systemChat "[ Enhanced Zeus Modules ] : Message too long! Cannot send, max characters is 300.";
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
					["High Command"]
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
					playSound "addItemFailed";
					systemChat "[ Enhanced Zeus Modules ] : Message too long! Cannot send, max characters is 300.";
				};
				_message = [_message] call MAZ_EZM_fnc_checkForBlacklistedWords;
				[
					_sender,
					_message
				] remoteExec ['BIS_fnc_showSubtitle',_targets];
				_display closeDisplay 1;
			},{
				params ["_values","_args","_display"];
				_display closeDisplay 2;
			},[]] call MAZ_EZM_fnc_createDialog;
		};

	comment "Object Modifiers";

		MAZ_EZM_fnc_attachToNearestModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object selected.";playSound "addItemFailed";};

			private _nearestObjects = nearestObjects [_entity,["AllVehicles"],50];
			_nearestObjects = (_nearestObjects - [_entity]);
			_nearestObject = _nearestObjects select 0;
			if(isNil "_nearestObject") exitWith {systemChat "[ Enhanced Zeus Modules ] : No near objects.";playSound "addItemFailed";};
			[_entity,_nearestObject] call BIS_fnc_attachToRelative;

			systemChat "[ Enhanced Zeus Modules ] : Object attached.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_detachModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object selected.";playSound "addItemFailed";};

			{detach _x;} foreach attachedObjects _entity;
			{detach _x;} foreach attachedObjects attachedTo _entity;

			systemChat "[ Enhanced Zeus Modules ] : Object detached.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_editObjectAttributesModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {
				playSound "addItemFailed";
				systemChat "[ Enhanced Zeus Modules ] : Place the module onto an object!";
			};
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
							systemChat "[ Enhanced Zeus Modules ] : Invalid Object selected, try again."; 
							playSound "addItemFailed";
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
								systemChat "[ Enhanced Zeus Modules ] : There are more textures on this object than shown.";
								playSound 'addItemFailed';
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
					systemChat '[ Enhanced Zeus Modules ] : Object Attributes Menu opened.'; 
					playSound 'addItemOk';
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
					systemChat "[ Enhanced Zeus Modules ] : Object attributed applied.";
					playSound 'addItemOk';
					with uiNamespace do {objEditDisplay closeDisplay 0;};
				};
			};
			[_entity] call MAZ_EZM_editObjAtribsMenu;
		};

		MAZ_EZM_fnc_toggleSimulationModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object selected.";playSound "addItemFailed";};

			if(simulationEnabled _entity) then {
				[_entity,false] remoteExec ["enableSimulationGlobal",2];
				systemChat "[ Enhanced Zeus Modules ] : Simulation disabled.";
			} else {
				[_entity,true] remoteExec ["enableSimulationGlobal",2];
				systemChat "[ Enhanced Zeus Modules ] : Simulation enabled.";
			};
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_toggleInvincibleModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object selected.";playSound "addItemFailed";};

			if(isDamageAllowed _entity) then {
				[_entity,false] remoteExec ["allowDamage",0];
				systemChat "[ Enhanced Zeus Modules ] : Object is god moded.";
			} else {
				[_entity,true] remoteExec ["allowDamage",0];
				systemChat "[ Enhanced Zeus Modules ] : Object is no longer god moded.";
			};
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_hideObjectModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object selected.";playSound "addItemFailed";};

			[_entity,true] remoteExec ["hideObjectGlobal",2];
			if(isNil "MAZ_EZM_hiddenObjects") then {
				MAZ_EZM_hiddenObjects = [_entity];
			} else {
				MAZ_EZM_hiddenObjects pushBack _entity;
			};

			systemChat "[ Enhanced Zeus Modules ] : Object is hidden.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_unHideObjectModule = {
			params ["_entity"];
			if(_entity isEqualTo objNull) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object selected.";playSound "addItemFailed";};

			[_entity,false] remoteExec ["hideObjectGlobal",2];
			MAZ_EZM_hiddenObjects = (MAZ_EZM_hiddenObjects - [_entity]);

			systemChat "[ Enhanced Zeus Modules ] : Object is no longer hidden.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_unHideObjectAllModule = {
			params ["_entity"];
			if(isNil "MAZ_EZM_hiddenObjects") exitWith {};
			{
				[_x,false] remoteExec ['hideObjectGlobal',2];
			}forEach MAZ_EZM_hiddenObjects;
			MAZ_EZM_hiddenObjects = [];

			systemChat "[ Enhanced Zeus Modules ] : All hidden objects are revealed.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_replaceWithSimpleObject = {
			params ["_object"];
			if(isPlayer _object  || (typeOf _object) isKindOf "CAManBase") exitWith {playSound "addItemFailed";systemChat "[ Enhanced Zeus Modules ] : Not an object!";};
			private _typeOf = typeOf _object;
			private _objPos = getPosASL _object;
			private _vectorDir = vectorDir _object;
			private _vectorUp = vectorUp _object;

			deleteVehicle _object;
			private _newSimpleObj = createSimpleObject [_typeOf,_objPos];
			_newSimpleObj setVectorDirAndUp [_vectorDir,_vectorUp];
			private _logic = createVehicle ["Land_HelipadEmpty_F",_objPos,[],0,"CAN_COLLIDE"];
			[[_logic],{
				params ["_objs"];
				{
					_x addCuratorEditableObjects [[_objs],true];
				} foreach allCurators;
			}] remoteExec ["Spawn",2];
			[_newSimpleObj,_logic] call BIS_fnc_attachToRelative;
			[_newSimpleObj,_logic] spawn {
				params ["_newSimpleObj","_logic"];
				[[_newSimpleObj,_logic],{
					params ["_newSimpleObj","_logic"];
					waitUntil {isNull _logic};
					deleteVehicle _newSimpleObj;
				}] remoteExec ["Spawn",_logic];
			};
			playSound "addItemOk";
			systemChat "[ Enhanced Zeus Modules ] : Object replaced with simple objects.";
		};

	comment "Player Modifiers";

		MAZ_EZM_fnc_disarmModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};
			_entity remoteExec ['removeAllWeapons'];

			systemChat "[ Enhanced Zeus Modules ] : Weapons have been removed from the unit.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_healAndReviveModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};

			if(isPlayer _entity) then {
				[[],{
					player setDamage 0;
					["#rev",1,player] call BIS_fnc_reviveOnState;
				}] remoteExec ['spawn',_entity];
			} else {
				_entity setDamage 0; 
			};

			systemChat "[ Enhanced Zeus Modules ] : The unit has been healed, and revived if possible.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_changeSideModule = {
			params ["_entity"];
			if(isNull _entity || !((typeOf _entity) isKindOf "Man")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Unit is not suitable!"; playSound 'addItemFailed';};
			["Change Unit Side",[
				[
					"SIDES",
					"New Side",
					(side _entity)
				]
			],{
				params ["_values","_args","_display"];
				private _grp = (createGroup (_values # 0));

				if((typeOf _args) isKindOf "Man") then {
					private _count = {alive _x} count (units (group _args)); 
					if(_count > 1 && !isPlayer _args) then {
						private _leader = leader (group _args);
						(units (group _args)) joinSilent _grp;
						_grp selectLeader _leader;
						systemChat "[ Enhanced Zeus Modules ] : Unit group side is changed.";
					} else {
						[_args] joinSilent _grp;
						systemChat "[ Enhanced Zeus Modules ] : Unit side is changed.";
					};
				};
				if((typeOf _args) isKindOf "LandVehicle" || (typeOf _args) isKindOf "Air" || (typeOf _args) isKindOf "Ship") then {
					(crew _args) joinSilent _grp;
					systemChat "[ Enhanced Zeus Modules ] : Vehicle crew side is changed.";
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
			if(isNull _entity) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object!"; playSound 'addItemFailed';};

			{
				moveOut _x;
			} foreach (crew _entity);

			systemChat "[ Enhanced Zeus Modules ] : Units have been ejected from the vehicle.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_muteServerModule = {
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

			systemChat "[ Enhanced Zeus Modules ] : All players have been muted.";
			playSound "addItemOk";
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

			systemChat "[ Enhanced Zeus Modules ] : All players have been unmuted.";
			playSound "addItemOk";
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
				systemChat "[ Enhanced Zeus Modules ] : Respawn timer applied.";
				playSound "addItemOk";
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
				playSound "addItemOK";
				systemChat "[ Enhanced Zeus Modules ] : Mortars have been re-enabled.";
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
				playSound "addItemOK";
				systemChat "[ Enhanced Zeus Modules ] : Mortars have been disabled.";
				MAZ_EZM_mortarsDisabled = true;
				publicVariable 'MAZ_EZM_mortarsDisabled';
			};
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

			[[_smokeNfire],{
				params ["_objs"];
				{
					_x addCuratorEditableObjects [[_objs],true];
				} foreach allCurators;
			}] remoteExec ["Spawn",2];

			if !(_entity isEqualTo objNull) then {_smokeNfire attachTo [_entity,[0,0,0]]};
			[_smokeNfire,_light] spawn {
				params ["_entity","_light"];
				waitUntil{sleep 1; isNull _entity};
				deleteVehicle _light;
			};

			systemChat "[ Enhanced Zeus Modules ] : Fire created.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_smokeEffectModule = {
			params ["_entity"];
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			private _smokeNfire = createVehicle ["test_EmptyObjectForSmoke",_pos,[],0,"CAN_COLLIDE"];

			[[_smokeNfire],{
				params ["_objs"];
				{
					_x addCuratorEditableObjects [[_objs],true];
				} foreach allCurators;
			}] remoteExec ["Spawn",2];

			if !(_entity isEqualTo objNull) then {_smokeNfire attachTo [_entity,[0,0,0]]};

			systemChat "[ Enhanced Zeus Modules ] : Smoke pillar created.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_earthquakeEffectModule = {
			[4] remoteExec ['BIS_fnc_earthquake'];
			systemChat "[ Enhanced Zeus Modules ] : Yo momma farded.";
			playSound "addItemOk";
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

					_positions pushBack _position;
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

				if(isNull _building) exitWith {playSound "AddItemFailed"; systemChat "[ Enhanced Zeus Modules ] : No near buildings!"};
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

				playSound "addItemOk";
				systemChat format ["[ Enhanced Zeus Modules ] : %1 fences replaced!",_count];
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

			systemChat "[ Enhanced Zeus Modules ] : Teleported.";
			playSound "addItemOk";
		};

		MAZ_EZM_fnc_teleportAllPlayersModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
			{
				_x setPos _pos;
			}forEach allPlayers;

			systemChat "[ Enhanced Zeus Modules ] : All players teleported.";
			playSound "addItemOk";
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
				systemChat "[ Enhanced Zeus Modules ] : Filtering map objects...";
				private _goodObjects = [];
				{
					if(!(typeOf _x in JAM_zeus_objBlacklist)) then {
						_goodObjects pushBack _x;
					};
					sleep 0.00001;
				}forEach allMissionObjects "All";
				systemChat "[ Enhanced Zeus Modules ] : Map objects filtered.";
				[[_goodObjects],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [_objs,true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];
				systemChat "[ Enhanced Zeus Modules ] : Map objects added.";
				playSound 'addItemOk';
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
				private _objects = [_args,_radius] call JAM_fnc_getEditableObjs_radius;
				if(_isGlobal) then {
					[[_objects],{
						params ["_objs"];
						
						{
							_x addCuratorEditableObjects [_objs,true];
						} foreach allCurators;
					}] remoteExec ["Spawn",2];
				} else {
					[[_objects,getAssignedCuratorLogic player],{
						params ["_objs","_curator"];
					
						_curator addCuratorEditableObjects [_objs,true];
					}] remoteExec ["Spawn",2];
				};
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
				playSound "AddItemOk";
				systemChat "[ Enhanced Zeus Modules ] : Automatic adding to interface disabled!";
			} else {
				MAZ_EZM_autoAdd = true;
				profileNamespace setVariable ['MAZ_EZM_autoAddVar',true];
				playSound "AddItemOk";
				systemChat "[ Enhanced Zeus Modules ] : Automatic adding to interface enabled!";
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

		MAZ_EZM_fnc_editVehicleAttributesModule = {
			params ["_entity"];
			if(!((typeOf _entity) isKindOf "LandVehicle" || (typeOf _entity) isKindOf "Air" || (typeOf _entity) isKindOf "Ship")) exitWith {systemChat "[ Enhanced Zeus Modules ] : Object selected is not a vehicle."; playSound "addItemFailed";};
			if(isNil "MAZ_EZM_getAllTextureTypes") then {
				MAZ_EZM_getAllTextureTypes = {
					params ["_veh"];
					private _objectType = "";
					if(typeName _veh == "STRING") then {
						_objectType = _veh;
					};
					if(typeName _veh == "OBJECT") then {
						_objectType = typeOf _veh;
					};
					_return = [];
					{
						vehicleEditDisplayName = getText (_x >> "displayName");
						_textures = getArray (_x >> "textures");
						_return pushBack [vehicleEditDisplayName,_textures];
					}forEach configProperties [configFile >> "CfgVehicles" >> _objectType >> "textureSources","isClass _x",true];
					_return
				};
			};
			if(isNil "MAZ_EZM_changeAttributesMenu") then {
				MAZ_EZM_changeAttributesMenu = {
					params ["_veh"];
					private _displayText = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
					_veh setVariable ['oldTextures',getObjectTextures _veh,true];
					player setVariable ['vehicleEditing',_veh];
					uiNamespace setVariable ['vehicleName',_displayText];
					with uiNamespace do {
						createDialog "RscDisplayEmpty";
						showchat true;
						vehicleEditDisplay = findDisplay -1;


						vehicleEditDisplay displayAddEventHandler ["unload", {
							private _editingVehicle = player getVariable 'vehicleEditing';
							private _oldTextures = _editingVehicle getVariable 'oldTextures';
							if(!isNil "_oldTextures") then {
								{
									[_editingVehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_editingVehicle];
								}forEach _oldTextures;
								systemChat "[ Enhanced Zeus Modules ] : Vehicle changes NOT applied.";
								player setVariable ['vehicleEditing',nil];
							};
						}];

						vehicleEditLabel = vehicleEditDisplay ctrlCreate ["RscStructuredText", 1100];
						vehicleEditLabel ctrlSetStructuredText parseText format ["Editing Vehicle (%1)",vehicleName];
						vehicleEditLabel ctrlSetPosition [0.396875 * safezoneW + safezoneX, 0.32 * safezoneH + safezoneY, 0.20625 * safezoneW, 0.022 * safezoneH];
						vehicleEditLabel ctrlSetTextColor [1,1,1,1];
						vehicleEditLabel ctrlSetBackgroundColor [0.1,0.5,0,1];
						vehicleEditLabel ctrlCommit 0;

						vehicleEditBackground = vehicleEditDisplay ctrlCreate ["RscPicture", 1200];
						vehicleEditBackground ctrlSetText "#(argb,8,8,3)color(0,0,0,0.6)";
						vehicleEditBackground ctrlSetPosition [0.396875 * safezoneW + safezoneX, 0.346 * safezoneH + safezoneY, 0.20625 * safezoneW, 0.363 * safezoneH];
						vehicleEditBackground ctrlCommit 0;

						vehicleEditFrame = vehicleEditDisplay ctrlCreate ["RscFrame", 1800];
						vehicleEditFrame ctrlSetPosition [0.396875 * safezoneW + safezoneX, 0.346 * safezoneH + safezoneY, 0.20625 * safezoneW, 0.363 * safezoneH];
						vehicleEditFrame ctrlCommit 0;

						vehicleEditTextures = vehicleEditDisplay ctrlCreate ["RscFrame", 1801];
						vehicleEditTextures ctrlSetPosition [0.402031 * safezoneW + safezoneX, 0.357 * safezoneH + safezoneY, 0.195937 * safezoneW, 0.132 * safezoneH];
						vehicleEditTextures ctrlCommit 0;

						vehicleEditTexturesList = vehicleEditDisplay ctrlCreate ["RscListbox", 1500];
						vehicleEditTexturesList ctrlSetPosition [0.402031 * safezoneW + safezoneX, 0.357 * safezoneH + safezoneY, 0.195937 * safezoneW, 0.132 * safezoneH];
						vehicleEditTexturesList ctrlAddEventHandler ["LBSelChanged", {
							params ["_control", "_selectedIndex"];
							[_control,_selectedIndex,player getVariable 'vehicleEditing'] call MAZ_EZM_editTextureClick;
						}];
						vehicleEditTexturesList ctrlCommit 0;

						vehicleEditAttributes = vehicleEditDisplay ctrlCreate ["RscFrame", 1802];
						vehicleEditAttributes ctrlSetPosition [0.402031 * safezoneW + safezoneX, 0.5 * safezoneH + safezoneY, 0.195937 * safezoneW, 0.132 * safezoneH];
						vehicleEditAttributes ctrlCommit 0;

						vehicleEditAttributesList = vehicleEditDisplay ctrlCreate ["RscListbox", 1501];
						vehicleEditAttributesList ctrlSetPosition [0.402031 * safezoneW + safezoneX, 0.5 * safezoneH + safezoneY, 0.195937 * safezoneW, 0.132 * safezoneH];
						vehicleEditAttributesList ctrlAddEventHandler ["LBDblClick", {
							params ["_control", "_selectedIndex"];
							[_control,_selectedIndex] call MAZ_EZM_editAtribsDblClick;
						}];
						vehicleEditAttributesList ctrlCommit 0;

						vehicleEditCancel = vehicleEditDisplay ctrlCreate ["RscButtonMenu", 2400];
						vehicleEditCancel ctrlSetStructuredText parseText "<t size='0.1'>&#160;</t><br/><t align='center'>Cancel</t>";
						vehicleEditCancel ctrlSetPosition [0.443281 * safezoneW + safezoneX, 0.654 * safezoneH + safezoneY, 0.04125 * safezoneW, 0.033 * safezoneH];
						vehicleEditCancel ctrlSetTextColor [0.8,0,0,1];
						vehicleEditCancel ctrlSetBackgroundColor [0,0,0,0.8];
						vehicleEditCancel ctrlSetFont "PuristaSemiBold";
						vehicleEditCancel ctrlAddEventHandler ["ButtonClick",{
							(uiNamespace getVariable 'vehicleEditDisplay') closeDisplay 0;
							private _veh = player getVariable 'vehicleEditing';
							private _oldTextures = _veh getVariable 'oldTextures';
							{
								[_veh,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_veh];
							}forEach _oldTextures;
						}];
						vehicleEditCancel ctrlCommit 0;

						vehicleEditApply = vehicleEditDisplay ctrlCreate ["RscButtonMenu", 2401];
						vehicleEditApply ctrlSetStructuredText parseText "<t size='0.1'>&#160;</t><br/><t align='center'>Apply</t>";
						vehicleEditApply ctrlSetPosition [0.515469 * safezoneW + safezoneX, 0.654 * safezoneH + safezoneY, 0.04125 * safezoneW, 0.033 * safezoneH];
						vehicleEditApply ctrlSetTextColor [0,0.8,0,1];
						vehicleEditApply ctrlSetBackgroundColor [0,0,0,0.8];
						vehicleEditApply ctrlSetFont "PuristaSemiBold";
						vehicleEditApply ctrlAddEventHandler ["ButtonClick",{
							[
								uiNamespace getVariable 'vehicleEditTexturesList',
								uiNamespace getVariable 'vehicleEditAttributesList',
								player getVariable 'vehicleEditing'
							] call MAZ_EZM_confirmVehEdit;
						}];
						vehicleEditApply ctrlCommit 0;
					};
					[uiNamespace getVariable 'vehicleEditTexturesList',_veh] call MAZ_EZM_populateVehicleTextures;
					[uiNamespace getVariable 'vehicleEditAttributesList',_veh] call MAZ_EZM_populateVehicleAtribs;
					systemChat "[ Enhanced Zeus Modules ] : Vehicle editor opened.";
				};
			};
			if(isNil "MAZ_EZM_populateVehicleTextures") then {
				MAZ_EZM_populateVehicleTextures = {
					params ["_listBox","_veh"];
					private _vehTextures = [_veh] call MAZ_EZM_getAllTextureTypes;
					private _litleBirds = ["B_Heli_Light_01_F","B_Heli_Light_01_dynamicLoadout_F"];
					if(typeOf _veh in _litleBirds) then {_vehTextures = ["C_Heli_Light_01_civil_F"] call MAZ_EZM_getAllTextureTypes;};
					{
						_listbox lbAdd (_x select 0);
					} forEach _vehTextures;
				};
			};
			if(isNil "MAZ_EZM_populateVehicleAtribs") then {
				MAZ_EZM_populateVehicleAtribs = {
					params ["_listBox","_veh"];
					private _objectOptions = [_veh] call BIS_fnc_getVehicleCustomization;
					_objectOptions = _objectOptions select 1;
					if(count _objectOptions == 0) exitWith {};
					for "_i" from 0 to (count _objectOptions -1) step 2 do {
						private _lbIndex = _listBox lbAdd (_objectOptions select _i);
						private _settingIndex = _i + 1;
						private _atrib = (_objectOptions select _settingIndex);
						private _string = str _atrib;
						_listbox lbSetData [_lbIndex,_string];
						if(_atrib == 0) then {
							_listBox lbSetColor [_lbIndex,[0.8,0,0,1]];
						} else {
							_listBox lbSetColor [_lbIndex,[0,0.8,0,1]];
						};
					};
				};
			};
			if(isNil "MAZ_EZM_editTextureClick") then {
				MAZ_EZM_editTextureClick = {
					params ["_listBox","_index","_veh"];
					private _allVehTextures = [_veh] call MAZ_EZM_getAllTextureTypes;
					private _litleBirds = ["B_Heli_Light_01_F","B_Heli_Light_01_dynamicLoadout_F"];
					if(typeOf _veh in _litleBirds) then {_allVehTextures = ["C_Heli_Light_01_civil_F"] call MAZ_EZM_getAllTextureTypes;};
					private _vehTexturesSelected = _allVehTextures select _index;
					private _vehTextures = _vehTexturesSelected select 1;
					{
						_veh setObjectTexture [_forEachIndex,_x];
					} forEach _vehTextures;
				};
			};
			if(isNil "MAZ_EZM_editAtribsDblClick") then {
				MAZ_EZM_editAtribsDblClick = {
					params ["_listBox","_index"];
					private _data = _listBox lbData _index;
					switch (_data) do {
						case "0": {
							_listBox lbSetData [_index,"1"];
							_listBox lbSetColor [_index,[0,0.8,0,1]];
						};
						case "1": {
							_listBox lbSetData [_index,"0"];
							_listBox lbSetColor [_index,[0.8,0,0,1]];
						};
					};
				};
			};
			if(isNil "MAZ_EZM_confirmVehEdit") then {
				MAZ_EZM_confirmVehEdit = {
					params ["_textures","_atribs","_veh"];
					private _indexTextures = lbCurSel _textures;
					if(_indexTextures == -1) exitWith {systemChat '[ Enhanced Zeus Modules ] : Choose a texture!'; playSound 'addItemFailed';};
					private _allVehTextures = [_veh] call MAZ_EZM_getAllTextureTypes;
					private _litleBirds = ["B_Heli_Light_01_F","B_Heli_Light_01_dynamicLoadout_F"];
					if(typeOf _veh in _litleBirds) then {_allVehTextures = ["C_Heli_Light_01_civil_F"] call MAZ_EZM_getAllTextureTypes;};
					private _vehTexturesSelected = _allVehTextures select _indexTextures;
					private _vehTextures = _vehTexturesSelected select 1;

					private _objectOptions = [_veh] call BIS_fnc_getVehicleCustomization;
					_objectOptions = _objectOptions select 1;
					if(count _objectOptions == 0) then {_objectOptions = []} else {
						private _atribSettings = [];

						for "_i" from 0 to ((count _objectOptions) / 2) do {
							private _data = _atribs lbData _i;
							_atribSettings pushBack (parseNumber _data);
						};

						{
							private _index = ((_forEachIndex * 2) + 1);
							_objectOptions set [_index,_x];
						}forEach _atribSettings;
					};

					[
						_veh,
						false, 
						_objectOptions
					] call BIS_fnc_initVehicle; 
					{
						[_veh,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_veh];
					} forEach _vehTextures;
					player setVariable ['vehicleEditing',nil];
					_veh setVariable ['oldTextures',nil,true];
					(uiNamespace getVariable 'vehicleEditDisplay') closeDisplay 0;
					systemChat '[ Enhanced Zeus Modules ] : Vehicle attributes applied!'; 
					playSound 'addItemOk';
				};
			};

			[_entity] call MAZ_EZM_changeAttributesMenu;
			systemChat '[ Enhanced Zeus Modules ] : Select a texture and double click the attributes you want.'; 
			playSound 'addItemOk';
		};

		MAZ_EZM_fnc_unflipVehicleModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object!"; playSound 'addItemFailed';};

			_entity setVectorUp surfaceNormal getPos _entity;
			_entity setPosATL [getPosATL _entity select 0, getPosATL _entity select 1, 0.2];

			systemChat "[ Enhanced Zeus Modules ] : Vehicle unflipped.";
			playSound 'addItemOk';
		};

		MAZ_EZM_fnc_rearmVehicleModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object!"; playSound 'addItemFailed';};
			[[_entity],{
				params ["_entity"];
				[[_entity],{
					params ["_entity"];
					_entity setVehicleAmmo 1;
				}] remoteExec ['spawn',owner _entity];

			}] remoteExec ['spawn',2];

			systemChat "[ Enhanced Zeus Modules ] : Vehicle rearmed.";
			playSound 'addItemOk';
		};

		MAZ_EZM_fnc_refuelVehicleModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object!"; playSound 'addItemFailed';};
			[_entity,1] remoteExec ['setFuel'];

			systemChat "[ Enhanced Zeus Modules ] : Vehicle refueled.";
			playSound 'addItemOk';
		};

		MAZ_EZM_fnc_repairVehicleModule = {
			params ["_entity"];
			if(isNull _entity) exitWith {systemChat "[ Enhanced Zeus Modules ] : No object!"; playSound 'addItemFailed';};
			[_entity,{
				_this setDamage 0;
			}] remoteExec ['spawn',_entity];

			systemChat "[ Enhanced Zeus Modules ] : Vehicle repaired.";
			playSound 'addItemOk';
		};

	comment "Auto-Add to Interface";
		MAZ_EZM_addToInterface = {
			[] spawn {
				if(!MAZ_EZM_autoAdd) exitWith {};
				systemChat "[ Enhanced Zeus Modules ] : Filtering map objects...";
				private _goodObjects = [];
				{
					if(!(typeOf _x in JAM_zeus_objBlacklist)) then {
						_goodObjects pushBack _x;
					};
					sleep 0.001;
				}forEach allMissionObjects "All";
				systemChat "[ Enhanced Zeus Modules ] : Map objects filtered.";
				[[_goodObjects],
				{
					params ["_objs"];
					
					{
						_x addCuratorEditableObjects [_objs,true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];
				systemChat "[ Enhanced Zeus Modules ] : Map objects added.";
				playSound 'addItemOk';
			};
		};

	comment "Faction Functions";

		MAZ_EZM_fnc_removeAllClothing = {
			params ["_unit"];
			_unit setUnitLoadout [[],[],[],[],[],[],"","",["","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];
		};

	comment "Better Civilians";

		MAZ_EZM_fnc_createBetterCivilianModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

			private _grp = createGroup [civilian,true];
			private _unit = _grp createUnit ["C_man_1",_pos,[],0,"CAN_COLLIDE"];
			_grp setBehaviour "SAFE";
			_unit setRank "PRIVATE";

			[[_unit],{
				params ["_objs"];
				{
					_x addCuratorEditableObjects [[_objs],true];
				} foreach allCurators;
			}] remoteExec ["Spawn",2];

			private _civilianUniforms = ["U_C_ArtTShirt_01_v6_F","U_C_ArtTShirt_01_v1_F","U_C_Man_casual_2_F","U_C_ArtTShirt_01_v2_F","U_C_ArtTShirt_01_v4_F","U_C_Man_casual_3_F","U_C_Man_casual_1_F","U_C_ArtTShirt_01_v5_F","U_C_ArtTShirt_01_v3_F","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Uniform_Farmer_01_F","U_C_FormalSuit_01_black_F","U_C_FormalSuit_01_blue_F","U_C_FormalSuit_01_gray_F","U_C_FormalSuit_01_khaki_F","U_C_FormalSuit_01_tshirt_black_F","U_C_FormalSuit_01_tshirt_gray_F","U_BG_Guerilla2_2","U_BG_Guerilla2_1","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_C_HunterBody_grn","U_C_E_LooterJacket_01_F","U_I_L_Uniform_01_tshirt_black_F","U_I_L_Uniform_01_tshirt_skull_F","U_I_L_Uniform_01_tshirt_sport_F","U_Marshal","U_C_Mechanic_01_F","U_C_Uniform_Scientist_02_formal_F","U_C_Man_casual_6_F","U_C_Man_casual_4_F","U_C_Man_casual_5_F","U_C_Poor_1"];
			private _civilianHeadgear = ["H_Booniehat_khk","H_Booniehat_oli","H_Booniehat_mcamo","H_Booniehat_tan","H_Booniehat_dgtl","H_Cap_red","H_Cap_blu","H_Cap_oli","H_Cap_tan","H_Cap_blk","H_Cap_blk_CMMG","H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_Cap_grn","H_Cap_grn_BI","H_Cap_blk_ION","H_Cap_usblack","H_Cap_surfer","H_Bandanna_surfer","H_Bandanna_khk","H_Bandanna_cbr","H_Bandanna_sgg","H_Bandanna_sand","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_camo","H_Bandanna_mcamo","H_Watchcap_blk","H_Watchcap_cbr","H_Watchcap_khk","H_Watchcap_camo","H_StrawHat","H_StrawHat_dark","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_grey","H_Hat_checker","H_Hat_tan","H_Hat_Safari_sand_F","H_Hat_Safari_olive_F","H_HeadSet_black_F","H_Hat_Tinfoil_F","H_Booniehat_mgrn"];
			private _civilianGoggles = ["H_WirelessEarpiece_F","G_Spectacles","G_Spectacles_Tinted","G_Shades_Black","G_Shades_Green","G_Shades_Red","G_Squares","G_Squares_Tinted","G_Sport_BlackWhite","G_Sport_Blackyellow","G_Sport_Greenblack","G_Sport_Checkered","G_Sport_Red","G_Shades_Blue","G_Sport_Blackred","G_Respirator_white_F","G_Respirator_yellow_F","G_Respirator_blue_F","G_WirelessEarpiece_F","G_RegulatorMask_F"];
			
			removeUniform _unit;
			removeHeadgear _unit;
			removeGoggles _unit;
			_unit forceAddUniform (selectRandom _civilianUniforms);
			_unit addHeadgear (selectRandom _civilianHeadgear);
			_unit addGoggles (selectRandom _civilianGoggles);
		};

		MAZ_EZM_fnc_createBetterCivilianJournoModule = {
			private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

			private _grp = createGroup [civilian,true];
			private _unit = _grp createUnit ["C_journalist_F",_pos,[],0,"CAN_COLLIDE"];
			_grp setBehaviour "SAFE";
			_unit setRank "PRIVATE";

			[[_unit],{
				params ["_objs"];
				{
					_x addCuratorEditableObjects [[_objs],true];
				} foreach allCurators;
			}] remoteExec ["Spawn",2];

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
		};

	comment "MDF";

		comment "Anti-Air";

			MAZ_EZM_MDF_fnc_createCheetahModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_APC_Tracked_01_AA_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[
					_vehicle,
					["Sand",1], 
					["showCamonetTurret",1,"showCamonetHull",1,"showBags",0]
				] call BIS_fnc_initVehicle;

				private _driver = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_driver moveInDriver _vehicle;

				private _gunner = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_gunner moveInGunner _vehicle;

				private _commander = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_commander moveInCommander _vehicle;

				private _grp = createGroup [independent,true];
				[_driver,_gunner,_commander] joinSilent _grp;
				_grp selectLeader _commander;

				_vehicle
			};

		comment "APCs";

			MAZ_EZM_MDF_fnc_createGorgonModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_APC_Wheeled_03_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[
					_vehicle,
					["Guerilla_02",1], 
					["showCamonetHull",0,"showBags",1,"showBags2",1,"showTools",1,"showSLATHull",1]
				] call BIS_fnc_initVehicle;

				private _driver = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_driver moveInDriver _vehicle;

				private _gunner = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_gunner moveInGunner _vehicle;

				private _commander = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_commander moveInCommander _vehicle;

				private _grp = createGroup [independent,true];
				[_driver,_gunner,_commander] joinSilent _grp;
				_grp selectLeader _commander;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createRhinoModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_AFV_Wheeled_01_cannon_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[
					_vehicle,
					["Sand",1], 
					["showCamonetHull",1,"showCamonetTurret",0,"showSLATHull",1]
				] call BIS_fnc_initVehicle;

				private _driver = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_driver moveInDriver _vehicle;

				private _gunner = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_gunner moveInGunner _vehicle;

				private _commander = [] call MAZ_EZM_MDF_fnc_createCrewmanModule;
				_commander moveInCommander _vehicle;

				private _grp = createGroup [independent,true];
				[_driver,_gunner,_commander] joinSilent _grp;
				_grp selectLeader _commander;

				_vehicle
			};


		comment "Cars";

			MAZ_EZM_MDF_fnc_createOffroadModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[
					_vehicle,
					["Guerilla_03",1], 
					["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",1,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0,"hidePolice",1,"HideServices",1,"BeaconsStart",0,"BeaconsServicesStart",0]
				] call BIS_fnc_initVehicle;
				
				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				private _grp = createGroup [independent,true];
				[_driver,_gunner] joinSilent _grp;
				_grp selectLeader _driver;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createOffroadHMGModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_armed_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[
					_vehicle,
					["Guerilla_03",1], 
					["Hide_Shield",0,"Hide_Rail",1,"HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",0,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0]
				] call BIS_fnc_initVehicle;
				
				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				private _gunner = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_gunner moveInGunner _vehicle;

				private _grp = createGroup [independent,true];
				[_driver,_gunner] joinSilent _grp;
				_grp selectLeader _driver;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createOffroadATModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_G_Offroad_01_AT_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[
					_vehicle,
					["Guerilla_03",1], 
					["HideDoor1",0,"HideDoor2",0,"HideDoor3",0,"HideBackpacks",1,"HideBumper1",1,"HideBumper2",0,"HideConstruction",0]
				] call BIS_fnc_initVehicle;
				
				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				private _gunner = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_gunner moveInGunner _vehicle;

				private _grp = createGroup [independent,true];
				[_driver,_gunner] joinSilent _grp;
				_grp selectLeader _driver;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakAmmoModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_ammo_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_repair_green_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakFuelModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_fuel_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_fuel_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakMedicalModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_medical_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakRepairModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_box_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_repair_green_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakTransportModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_transport_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createZamakTransportCoveredModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Truck_02_covered_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				{
					[_vehicle,[_forEachIndex,_x]] remoteExec ['setObjectTexture',0,_vehicle];
				}forEach ["a3\soft_f_beta\truck_02\data\truck_02_kab_blue_co.paa","a3\soft_f_beta\truck_02\data\truck_02_kuz_olive_co.paa","a3\soft_f_beta\truck_02\data\truck_02_int_co.paa"];

				private _driver = [] call MAZ_EZM_MDF_fnc_createRiflemanModule;
				_driver moveInDriver _vehicle;

				_vehicle
			};

		comment "Drones";

			MAZ_EZM_MDF_fnc_createGreyhawkModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_UAV_02_dynamicLoadout_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

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

		comment "Helicopters";

			MAZ_EZM_MDF_fnc_createHummingbirdModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_Heli_Light_01_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_vehicle,[0,"A3\air_f\heli_light_01\data\skins\Heli_light_01_ext_digital_co.paa"]] remoteExec ['setObjectTexture',0,_vehicle];
				
				private _driver = [] call MAZ_EZM_MDF_fnc_createHeliPilotModule;
				_driver moveInDriver _vehicle;

				private _coPilot = [] call MAZ_EZM_MDF_fnc_createHeliPilotModule;
				_coPilot moveinturret [_vehicle, [0]];

				private _grp = createGroup [independent,true];
				[_driver,_coPilot] joinSilent _grp;
				_grp selectLeader _driver;

				_vehicle
			};

			MAZ_EZM_MDF_fnc_createPawneeModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["B_Heli_Light_01_dynamicLoadout_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_vehicle,[0,"A3\air_f\heli_light_01\data\skins\Heli_light_01_ext_digital_co.paa"]] remoteExec ['setObjectTexture',0,_vehicle];
				
				private _driver = [] call MAZ_EZM_MDF_fnc_createHeliPilotModule;
				_driver moveInDriver _vehicle;

				private _coPilot = [] call MAZ_EZM_MDF_fnc_createHeliPilotModule;
				_coPilot moveinturret [_vehicle, [0]];

				private _grp = createGroup [independent,true];
				[_driver,_coPilot] joinSilent _grp;
				_grp selectLeader _driver;

				_vehicle
			};

		comment "Men";

			MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit = {
				params ["_unit"];
				sleep 2;
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

				switch (uniform _unit) do {
					case "U_I_CombatUniform_shortsleeve": {
						[_unit,[0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]] remoteExec ['setObjectTexture',0,_unit];
					};
					case "U_I_CombatUniform": {
						[_unit,[0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]] remoteExec ['setObjectTexture',0,_unit];
					};
					case "U_BG_Guerilla1_1": {
						[_unit,[1,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]] remoteExec ['setObjectTexture',0,_unit];
					};
				};
			};

			MAZ_EZM_MDF_fnc_loopCheckForMDFTexture = {
				params ["_unit"];
				while {alive _unit} do {
					switch (uniform _unit) do {
						case "U_I_CombatUniform_shortsleeve": {
							if((getObjectTextures _unit # 0) != "A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa") then {
								[_unit,[0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]] remoteExec ['setObjectTexture',0,_unit];
							};
						};
						case "U_I_CombatUniform": {
							if((getObjectTextures _unit # 0) != "A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa") then {
								[_unit,[0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]] remoteExec ['setObjectTexture',0,_unit];
							};
						};
						case "U_BG_Guerilla1_1": {
							if((getObjectTextures _unit # 1) != "A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa") then {
								[_unit,[1,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"]] remoteExec ['setObjectTexture',0,_unit];
							};
						};
					};
					sleep 1;
				};
			};

			MAZ_EZM_MDF_fnc_createAmmoBearerModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				_unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["FirstAidKit",4],["200Rnd_65x39_cased_Box",1,200],["NLAW_F",1,1],["HandGrenade",2,1],["MiniGrenade",2,1],["1Rnd_HE_Grenade_shell",6,1],["20Rnd_762x51_Mag",3,20]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createAutoriflemanModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_AR_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 1 do {
					_unit addMagazine "200Rnd_65x39_cased_Box";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "LMG_Mk200_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addWeapon "hgun_ACPC2_F";
				_unit addMagazine "200Rnd_65x39_cased_Box";

				_unit
			};

			MAZ_EZM_MDF_fnc_createMedicModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Medic_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit addBackpack "B_AssaultPack_cbr";
				_unit addItemToBackpack "Medikit";
				for "_i" from 0 to 4 do {
					_unit addItemToBackpack "FirstAidKit";
				};

				_unit
			};

			MAZ_EZM_MDF_fnc_createCrewmanModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_crew_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				removeHeadgear _unit;
				_unit addHeadgear "H_HelmetCrew_I";
				removeVest _unit;
				_unit addVest "V_TacVest_brn";

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20C_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createEngineerModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_engineer_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				_unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["ToolKit",1],["MineDetector",1],["DemoCharge_Remote_Mag",2,1],["SatchelCharge_Remote_Mag",1,1]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createExplosivesSpecModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_exp_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				_unit setUnitLoadout [[],[],[],[],[],["B_Carryall_khk",[["ToolKit",1],["MineDetector",1],["APERSBoundingMine_Range_Mag",3,1],["ClaymoreDirectionalMine_Remote_Mag",2,1],["SLAMDirectionalMine_Wire_Mag",2,1],["DemoCharge_Remote_Mag",1,1]]],"","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createGrenadierModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_GL_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				for "_i" from 0 to 5 do {
					_unit addMagazine "1Rnd_HE_Grenade_shell";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "1Rnd_Smoke_Grenade_shell";
				};
				_unit addWeapon "arifle_Mk20_GL_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createHeliCrewModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_crew_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				removeHeadgear _unit;
				_unit addHeadgear "H_CrewHelmetHeli_B";
				removeVest _unit;
				_unit addVest "V_TacVest_brn";

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20C_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createHeliPilotModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_crew_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				removeHeadgear _unit;
				_unit addHeadgear "H_PilotHelmetHeli_B";
				removeVest _unit;
				_unit addVest "V_TacVest_brn";

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20C_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createMarksmanModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_M_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "20Rnd_762x51_Mag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "srifle_DMR_03_tan_F";
				_unit addPrimaryWeaponItem "optic_hamr";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createMissileSpecAAModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit addBackpack "B_Kitbag_cbr";
				for "_i" from 0 to 1 do {
					_unit addMagazine "Titan_AA";
				};
				_unit addWeapon "launch_B_Titan_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createPilotModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				_unit setUnitLoadout [["SMG_01_F","","","optic_Aco_smg",["30Rnd_45ACP_Mag_SMG_01",30],[],""],[],[],["U_I_pilotCoveralls",[["30Rnd_45ACP_Mag_SMG_01",3,30],["SmokeShellOrange",2,1]]],[],[],"H_PilotHelmetFighter_I","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]];
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				_unit
			};

			MAZ_EZM_MDF_fnc_createRiflemanModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createRiflemanATModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_LAT_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				_unit addBackpack "B_AssaultPack_cbr";

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "NLAW_F";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";
				_unit addWeapon "launch_NLAW_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createRiflemanLATModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_LAT2_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;
				_unit addBackpack "B_AssaultPack_cbr";

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "MRAWS_HEAT_F";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";
				_unit addWeapon "launch_MRAWS_sand_rail_F";
				_unit addMagazine "MRAWS_HEAT_F";

				_unit
			};

			MAZ_EZM_MDF_fnc_createSquadLeadModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_SL_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";

				_unit addBackpack "B_RadioBag_01_black_F";
				[_unit,{
					(unitbackpack _this) setObjectTexture [0,"A3\characters_f_exp\Syndikat\Data\U_I_C_Soldier_Para_4_F_2_co.paa"];
				}] remoteExec ['spawn',0,_unit];

				_unit
			};

			MAZ_EZM_MDF_fnc_createSurvivorModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				[_unit] call MAZ_EZM_fnc_removeAllClothing;
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				removeVest _unit;
				removeHeadgear _unit;
			};

			MAZ_EZM_MDF_fnc_createUAVOpModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;

				private _grp = createGroup [independent,true];
				private _unit = _grp createUnit ["I_Soldier_F",_pos,[],0,"CAN_COLLIDE"];
				_grp setBehaviour "SAFE";
				_unit setRank "PRIVATE";
				_unit setUnitPos "UP";

				[[_unit],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

				_unit setUnitLoadout [[],[],[],[],[],[],"","",[],["ItemMap","I_UavTerminal","ItemRadio","ItemCompass","ItemWatch",""]];
				
				[_unit] call MAZ_EZM_MDF_fnc_addMDFUniformToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_addMDFIdentitiesToUnit;
				[_unit] spawn MAZ_EZM_MDF_fnc_loopCheckForMDFTexture;
				[_unit] call MAZ_EZM_fnc_autoResupplyAI;

				for "_i" from 0 to 4 do {
					_unit addMagazine "30Rnd_556x45_Stanag";
				};
				for "_i" from 0 to 2 do {
					_unit addItem "FirstAidKit";
				};
				for "_i" from 0 to 1 do {
					_unit addMagazine "9Rnd_45ACP_Mag";
				};
				_unit addWeapon "arifle_Mk20_plain_F";
				_unit addPrimaryWeaponItem "optic_holosight";
				_unit addPrimaryWeaponItem "acc_flashlight";
				_unit addWeapon "hgun_ACPC2_F";
				_unit addBackpack "I_UAV_01_backpack_F";

				_unit
			};

		comment "Planes";

			MAZ_EZM_MDF_fnc_createGryphonModule = {
				private _pos = [] call MAZ_EZM_fnc_getScreenPosition;
				private _vehicle = createVehicle ["I_Plane_Fighter_04_F",_pos,[],0,"CAN_COLLIDE"];
				[[_vehicle],{
					params ["_objs"];
					{
						_x addCuratorEditableObjects [[_objs],true];
					} foreach allCurators;
				}] remoteExec ["Spawn",2];

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
				
				private _driver = [] call MAZ_EZM_MDF_fnc_createPilotModule;
				_driver moveInDriver _vehicle;

				_vehicle
			};

	comment "End";

};
[] call MAZ_EZM_fnc_initFunction;

MAZ_EZM_editZeusInterface = {
	if (isNull (findDisplay 312)) exitWith {};
	private _fnc_editInterface = {
		disableSerialization;
		with uiNamespace do {
			private _display = displayNull;
			_display = findDisplay 312;
			if(isNull _display) exitWith {};

			comment "Transparency & Function Defines";

				_display displayAddEventHandler ['KeyDown', {
					if (_this select 1 == 14) then{
						private _display = findDisplay 312;
						[_display] spawn {
							params [['_display', displayNull]];
							uiSleep 0.01;
							if (isNull _display) exitWith {};
							private _ctrl = _display displayCtrl 15717;
							_ctrl ctrlSetTextColor [0,0.6,0.6,0.7];
						};
					};
				}];

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
					_functionArray = missionNamespace getVariable ['MAZ_zeusModulesWithFunction', []];
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
								_img params ["_width","_height"];
								with uiNamespace do {
									{
										_x ctrlShow true;
									} forEach MAZ_zeusPreviewCtrls;

									MAZ_ctrl_previewBackground ctrlSetPositionY _mouseY;
									MAZ_ctrl_previewBackground ctrlCommit 0;

									MAZ_ctrl_previewFrame ctrlSetPositionY _mouseY;
									MAZ_ctrl_previewFrame ctrlCommit 0;

									MAZ_ctrl_previewImage ctrlSetPositionY (_mouseY + 0.019);
									MAZ_ctrl_previewImage ctrlSetText _img;
									MAZ_ctrl_previewImage ctrlCommit 0;
								};
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
						MAZ_ctrl_previewBackground ctrlSetPosition [0.685624 * safezoneW + safezoneX, 0.841 * safezoneH + safezoneY, 0.154687 * safezoneW, 0.143 * safezoneH];
						MAZ_ctrl_previewBackground ctrlCommit 0;
						MAZ_ctrl_previewImage = _display ctrlCreate ['RscPicture', 1201];
						MAZ_ctrl_previewImage ctrlSetText '#(argb,8,8,3)color(0,0,0,0)';
						MAZ_ctrl_previewImage ctrlSetPosition [0.690781 * safezoneW + safezoneX, 0.852 * safezoneH + safezoneY, 0.144375 * safezoneW, 0.121 * safezoneH];
						MAZ_ctrl_previewImage ctrlCommit 0;
						MAZ_ctrl_previewFrame = _display ctrlCreate ['RscFrame', 1800];
						MAZ_ctrl_previewFrame ctrlSetPosition [0.685625 * safezoneW + safezoneX, 0.841 * safezoneH + safezoneY, 0.154687 * safezoneW, 0.143 * safezoneH];
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

			comment "Define Trees";
				MAZ_UnitsTree_BLUFOR	 = (_display displayCtrl 270);
				MAZ_UnitsTree_OPFOR		 = (_display displayCtrl 271);
				MAZ_UnitsTree_INDEP		 = (_display displayCtrl 272);
				MAZ_UnitsTree_CIVILIAN	 = (_display displayCtrl 273);
				MAZ_UnitsTree_EMPTY      = (_display displayCtrl 274);
				
				MAZ_GroupsTree_BLUFOR	 = (_display displayCtrl 275);
				MAZ_GroupsTree_OPFOR	 = (_display displayCtrl 276);
				MAZ_GroupsTree_INDEP	 = (_display displayCtrl 277);
				MAZ_GroupsTree_CIVILIAN  = (_display displayCtrl 278);

				MAZ_zeusModulesTree 	 = (_display displayCtrl 280);

				for '_n' from 0 to 32 do {
					MAZ_UnitsTree_BLUFOR tvCollapse [_n];
					MAZ_UnitsTree_OPFOR tvCollapse [_n];
					MAZ_UnitsTree_INDEP tvCollapse [_n];
				};

				MAZ_UnitsTree_BLUFOR ctrlSetEventHandler ["TreeSelChanged","[(_this select 1)] call MAZ_EZM_fnc_updateModuleSelection"];
				MAZ_UnitsTree_OPFOR ctrlSetEventHandler ["TreeSelChanged","[(_this select 1)] call MAZ_EZM_fnc_updateModuleSelection"];
				MAZ_UnitsTree_INDEP ctrlSetEventHandler ["TreeSelChanged","[(_this select 1)] call MAZ_EZM_fnc_updateModuleSelection"];
				MAZ_UnitsTree_CIVILIAN ctrlSetEventHandler ["TreeSelChanged","[(_this select 1)] call MAZ_EZM_fnc_updateModuleSelection"];
				MAZ_UnitsTree_EMPTY ctrlSetEventHandler ["TreeSelChanged","[(_this select 1)] call MAZ_EZM_fnc_updateModuleSelection"];
				MAZ_zeusModulesTree ctrlSetEventHandler ["TreeSelChanged","[(_this select 1)] call MAZ_EZM_fnc_updateModuleSelection"];

			comment "Add Divider";

				[MAZ_zeusModulesTree,"------------------------------------------------------","",[0,0.75,0.75,1]] call MAZ_EZM_fnc_zeusAddCategory;
				MAZ_EZMLabelTree = [MAZ_zeusModulesTree,"Enhanced Zeus Modules (Lite)",'\a3\ui_f_curator\Data\Displays\RscDisplayCurator\modeModules_ca.paa',[0,0.75,0.75,1]] call MAZ_EZM_fnc_zeusAddCategory;
				MAZ_zeusModulesTree tvSetPictureRightColor [[MAZ_EZMLabelTree], [0,0.75,0.75,1]];
				[
					MAZ_zeusModulesTree,
					MAZ_EZMLabelTree,
					format ["ZAM Edition - %1",missionNamespace getVariable ['MAZ_EZM_LiteVersion','']],
					"Originally created by: M9-SD & GamesByChris\nAdapted by: Expung3d to enhance Public Zeus.",
					"MAZ_EZM_fnc_hiddenEasterEggModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[MAZ_zeusModulesTree,"------------------------------------------------------","",[0,0.75,0.75,1]] call MAZ_EZM_fnc_zeusAddCategory;
			
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

			comment "Arsenal";

				MAZ_ArsenalTree = [
					MAZ_zeusModulesTree,
					"Arsenal Creator",
					'\A3\ui_f\data\Logos\a_64_ca.paa'
				] call MAZ_EZM_fnc_zeusAddCategory;
				
				[
					MAZ_zeusModulesTree,
					MAZ_ArsenalTree,
					"Create Full Arsenal",
					"Creates a full arsenal at the module's position.",
					"MAZ_EZM_fnc_createArsenalModule",
					'\A3\ui_f\data\Logos\a_64_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_ArsenalTree,
					"[ M9-SD ] AIO Arsenal",
					"Creates M9-SD's All-in-One Arsenal on the object.",
					"MAZ_EZM_fnc_createAIOArsenalModule",
					'\A3\ui_f\data\Logos\a_64_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Automatic Missions";

				MAZ_AutoMissionTree = [
					MAZ_zeusModulesTree,
					"Automatic Missions",
					"a3\ui_f\data\map\markers\military\objective_ca.paa",
					[1,1,1,1],
					"Automated Missions - Only configured for Altis"
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
					"Delete Radius",
					"Deletes all objects in a radius.",
					"MAZ_EZM_fnc_deleteRadiusModule",
					"a3\3den\data\displays\display3den\panelleft\entitylist_delete_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_CleanUpTree,
					"Remove Protection Zones",
					"Deletes all protection zones.",
					"MAZ_EZM_fnc_deleteProtectionZonesModule"
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
					"Edit Vehicle Attributes",
					"Edit the vehicle's appearance through a menu.",
					"MAZ_EZM_fnc_editVehicleAttributesModule",
					"a3\3den\data\cfgwaypoints\scripted_ca.paa"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_VehicleModTree,
					"Unflip Vehicle",
					"BROKEN\nUnflip the vehicle the module is placed on.",
					"MAZ_EZM_fnc_unflipVehicleModule"
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_VehicleModTree,
					"Rearm",
					"BROKEN\nRearm the vehicle.",
					"MAZ_EZM_fnc_rearmVehicleModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_VehicleModTree,
					"Refuel",
					"BROKEN\nRefuel the vehicle.",
					"MAZ_EZM_fnc_refuelVehicleModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\refuel_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

				[
					MAZ_zeusModulesTree,
					MAZ_VehicleModTree,
					"Repair",
					"BROKEN\nRepair the vehicle.",
					"MAZ_EZM_fnc_repairVehicleModule",
					'\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa'
				] call MAZ_EZM_fnc_zeusAddModule;

			comment "Zeus Preview";
				[] call MAZ_EZM_fnc_zeusPreviewImage;
				[] call MAZ_EZM_fnc_addZeusPreviewEvents;
			
			comment "Better Civilians";
				
				MAZ_BetterCivsTree = [
					MAZ_UnitsTree_CIVILIAN,
					"[EZM]  Better Civilians",
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

			comment "End";
		};
	};
	[] call _fnc_editInterface;
};

MAZ_EZM_editZeusLogic = {
	private _zeusLogic = objNull;
	private _zeusLogic = getAssignedCuratorLogic player;
	player setVariable ["MAZ_EZM_ZeusLogic",_zeusLogic];
	if (isNull _zeusLogic) exitWith {};

	if(!isNil "MAZ_EZM_zeusRespawnFix") then {
		player removeEventHandler ["Respawn",MAZ_EZM_zeusRespawnFix];
	};
	MAZ_EZM_zeusRespawnFix = player addEventhandler ["Respawn",{
		[] spawn {
			waitUntil {alive player && !isNull (findDisplay 46)};
			private _zeusLogic = player getVariable "MAZ_EZM_ZeusLogic";
			if(isNil "_zeusLogic") exitWith {
				playSound "addItemFailed";
				systemChat "[ Enhanced Zeus Modules ] : Error! Zeus Logic not found!";
			};
			[_zeusLogic] remoteExec ['unassignCurator',2];

			waitUntil{isNull (getAssignedCuratorUnit _zeusLogic)};
			systemChat "[ Enhanced Zeus Modules ] : Curator unassigned.";

			systemChat "[ Enhanced Zeus Modules ] : Attempting assign...";
			while{isNull (getAssignedCuratorUnit _zeusLogic)} do {
				[player,_zeusLogic] remoteExec ['assignCurator',2];
				sleep 0.1;
			};
			systemChat "[ Enhanced Zeus Modules ] : Curator assigned! Press Y to open/close Zeus.";
		};
	}];

	[] call MAZ_EZM_addToInterface;

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
		_units = units _group;
		{
			[_x, [_units, true]] remoteExec ['addCuratorEditableObjects'];
		} forEach allCurators;
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
};

MAZ_EZM_addZeusKeybinds_312 = {
	waitUntil{!isNull(findDisplay 312)};
	if(!isNil "MAZ_EZM_closeZeusInterface") then {
		(findDisplay 312) displayRemoveEventHandler ["KeyDown",MAZ_EZM_closeZeusInterface];
	};
	if(!isNil "MAZ_EZM_teleportPlayerToScreenPos") then {
		(findDisplay 312) displayRemoveEventHandler ["KeyDown",MAZ_EZM_teleportPlayerToScreenPos];
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
	if(!isNil "MAZ_EZM_mapDoubleClickEH") then {
		((findDisplay 312) displayCtrl 50) ctrlRemoveEventHandler ["MouseButtonDblClick",MAZ_EZM_mapDoubleClickEH];
	};
	MAZ_EZM_closeZeusInterface = (findDisplay 312) displayAddEventHandler ["KeyDown", {
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
		if(_key == 21 && _ctrl) then {
			(findDisplay 312) closeDisplay 0;
			systemChat "[ Enhanced Zeus Modules ] : Zeus interface closed.";
		};
	}];
	MAZ_EZM_teleportPlayerToScreenPos = (findDisplay 312) displayAddEventHandler ["KeyDown", {
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
		private _return = false;
		if(_key == 57) then {
			private _pos = screenToWorld [0.5,0.5];
			player setPosATL _pos;
			playSound "addItemOk";
			_return = true;
		};
		_return
	}];
	MAZ_EZM_changeCuratorSideEH = (findDisplay 312) displayAddEventHandler ["KeyDown", {
		params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
		if(_key == 22 && _ctrl) then {
			[] call MAZ_EZM_changeUnitSideMenuZeus;
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

				};
				[_closest] spawn MAZ_EZM_createMarkerAttributesDialog;
			};
		};
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

MAZ_EZM_changeUnitSideMenuZeus = {
	with uiNamespace do {
		createDialog "RscDisplayEmpty";
		showchat true;
		changeSideDisplayZeus = findDisplay -1;

		zeusSideLabel = changeSideDisplayZeus ctrlCreate ["RscStructuredText", 1100];
		zeusSideLabel ctrlSetStructuredText parseText "Change Zeus Side";
		zeusSideLabel ctrlSetPosition [0.381406 * safezoneW + safezoneX, 0.407 * safezoneH + safezoneY, 0.237187 * safezoneW, 0.022 * safezoneH];
		zeusSideLabel ctrlSetTextColor [1,1,1,1];
		zeusSideLabel ctrlSetBackgroundColor [0,0.5,0.5,1];
		zeusSideLabel ctrlCommit 0;

		zeusSideBG = changeSideDisplayZeus ctrlCreate ["RscPicture", 1200];
		zeusSideBG ctrlSetText "#(argb,8,8,3)color(0,0,0,0.6)";
		zeusSideBG ctrlSetPosition [0.381406 * safezoneW + safezoneX, 0.434 * safezoneH + safezoneY, 0.237187 * safezoneW, 0.077 * safezoneH];
		zeusSideBG ctrlCommit 0;

		zeusSide = changeSideDisplayZeus ctrlCreate ["RscFrame", 1800];
		zeusSide ctrlSetPosition [0.381406 * safezoneW + safezoneX, 0.434 * safezoneH + safezoneY, 0.237187 * safezoneW, 0.077 * safezoneH];
		zeusSide ctrlCommit 0;

		zeusSideBLU = changeSideDisplayZeus ctrlCreate ["RscButtonMenu", 2400];
		zeusSideBLU ctrlSetStructuredText parseText "<t size='0.7'>&#160;</t><br/><t align='center'>WEST</t>";
		zeusSideBLU ctrlSetPosition [0.386562 * safezoneW + safezoneX, 0.445 * safezoneH + safezoneY, 0.04125 * safezoneW, 0.055 * safezoneH];
		zeusSideBLU ctrlSetTextColor [1,1,1,1];
		zeusSideBLU ctrlSetBackgroundColor [0,0.3,0.6,0.75];
		zeusSideBLU ctrlSetFont "PuristaSemiBold";
		zeusSideBLU ctrlAddEventHandler ["ButtonClick",{
			[west] call MAZ_EZM_joinSideZeus;
		}];
		zeusSideBLU ctrlCommit 0;

		zeusSideOPF = changeSideDisplayZeus ctrlCreate ["RscButtonMenu", 2401];
		zeusSideOPF ctrlSetStructuredText parseText "<t size='0.7'>&#160;</t><br/><t align='center'>EAST</t>";
		zeusSideOPF ctrlSetPosition [0.432969 * safezoneW + safezoneX, 0.445 * safezoneH + safezoneY, 0.04125 * safezoneW, 0.055 * safezoneH];
		zeusSideOPF ctrlSetTextColor [1,1,1,1];
		zeusSideOPF ctrlSetBackgroundColor [0.5,0,0,0.75];
		zeusSideOPF ctrlSetFont "PuristaSemiBold";
		zeusSideOPF ctrlAddEventHandler ["ButtonClick",{
			[east] call MAZ_EZM_joinSideZeus;
		}];
		zeusSideOPF ctrlCommit 0;

		zeusSideIND = changeSideDisplayZeus ctrlCreate ["RscButtonMenu", 2402];
		zeusSideIND ctrlSetStructuredText parseText "<t size='0.7'>&#160;</t><br/><t align='center'>INDEP</t>";
		zeusSideIND ctrlSetPosition [0.479375 * safezoneW + safezoneX, 0.445 * safezoneH + safezoneY, 0.04125 * safezoneW, 0.055 * safezoneH];
		zeusSideIND ctrlSetTextColor [1,1,1,1];
		zeusSideIND ctrlSetBackgroundColor [0,0.5,0,0.75];
		zeusSideIND ctrlSetFont "PuristaSemiBold";
		zeusSideIND ctrlAddEventHandler ["ButtonClick",{
			[independent] call MAZ_EZM_joinSideZeus;
		}];
		zeusSideIND ctrlCommit 0;

		zeusSideCIV = changeSideDisplayZeus ctrlCreate ["RscButtonMenu", 2403];
		zeusSideCIV ctrlSetStructuredText parseText "<t size='0.7'>&#160;</t><br/><t align='center'>CIV</t>";
		zeusSideCIV ctrlSetPosition [0.525781 * safezoneW + safezoneX, 0.445 * safezoneH + safezoneY, 0.04125 * safezoneW, 0.055 * safezoneH];
		zeusSideCIV ctrlSetTextColor [1,1,1,1];
		zeusSideCIV ctrlSetBackgroundColor [0.4,0,0.5,0.75];
		zeusSideCIV ctrlSetFont "PuristaSemiBold";
		zeusSideCIV ctrlAddEventHandler ["ButtonClick",{
			[civilian] call MAZ_EZM_joinSideZeus;
		}];
		zeusSideCIV ctrlCommit 0;

		zeusSideLogic = changeSideDisplayZeus ctrlCreate ["RscButtonMenu", 2404];
		zeusSideLogic ctrlSetStructuredText parseText "<t size='0.7'>&#160;</t><br/><t align='center'>Logic</t>";
		zeusSideLogic ctrlSetPosition [0.572187 * safezoneW + safezoneX, 0.445 * safezoneH + safezoneY, 0.04125 * safezoneW, 0.055 * safezoneH];
		zeusSideLogic ctrlSetTextColor [1,1,1,1];
		zeusSideLogic ctrlSetBackgroundColor [1,1,1,0.3];
		zeusSideLogic ctrlSetFont "PuristaSemiBold";
		zeusSideLogic ctrlAddEventHandler ["ButtonClick",{
			[sideLogic] call MAZ_EZM_joinSideZeus;
		}];
		zeusSideLogic ctrlCommit 0;
	};
};

MAZ_EZM_joinSideZeus = {
	params ["_sideToJoin"];
	private _grp = createGroup [_sideToJoin,true];
	[player] joinSilent _grp;
	_grp selectLeader player;
	private _groupName = "[High Comm] - (Zeus)";
	_grp setGroupIdGlobal [_groupName];
	private _leader = leader _grp;
	private _data = [nil,_groupName,false];
	["RegisterGroup",[_grp,_leader,_data]] remoteExecCall ["BIS_fnc_dynamicGroups"];
	["AddGroupMember",[_grp,player]] remoteExecCall ["BIS_fnc_dynamicGroups"];
	["SwitchLeader",[_grp,player]] remoteExecCall ["BIS_fnc_dynamicGroups"];
	["SetPrivateState",[_grp,true]] remoteExecCall ["BIS_fnc_dynamicGroups"];
	["SetName",[_grp,_groupName]] remoteExecCall ["BIS_fnc_dynamicGroups"];
	systemChat "[ Enhanced Zeus Modules ] : Your side has been changed.";
	playSound 'addItemOk';
};

MAZ_EZM_fnc_initMainLoop = {
	MAZ_EZM_mainLoop_Active = true;
	systemChat "[ Enhanced Zeus Modules ] : Enhanced Zeus Modules Lite Initialized!";
	playSound "beep_target";
	while {MAZ_EZM_mainLoop_Active} do {
		waitUntil {uiSleep 0.01; (!isNull (findDisplay 312))};

		[] spawn MAZ_EZM_editZeusLogic;
		[] spawn MAZ_EZM_addZeusKeybinds_312;
		[] spawn MAZ_EZM_editZeusInterface;
		playSound "beep_target";
		waitUntil {uiSleep 0.1; (isNull (findDisplay 312))};

		[] spawn MAZ_EZM_addZeusKeybinds_46;
	};
};

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
		if(isNil "MAZ_EZM_mainLoop_Active") then {
			[] spawn MAZ_EZM_fnc_initMainLoop;
		};
	};
	_display closeDisplay 1;
},{
	params ["_values","_args","_display"];
	_display closeDisplay 2;
},[]] call MAZ_EZM_fnc_createDialog;

comment "
	Change Log:
 - Added more filters to the messages filter
 - Added EDC Compatibility
 - Added Advanced Damage to vehicles
 - Added Automated Respawns on Vehicles
 - Added Auto-Garrison Town
 - Added Percent to Slider Dialogs
 - Added support for all vanilla maps with automated helicrashes
 - Added New Convoy to automated convoys
 - Added combat animations (ambient animations that cancel when taking fire)
 - Changed positions of automated helicrashes
 - Changed reinforcements waypoint from MOVE/SENTRY to Seek and Destroy
 - Fixed issue where extra long dialogs would extend beyond the screen
 - Fixed issue where shortened dialogs didn't have a scrollbar
 - Fixed typo where some animation display names had a ; instead of a : separator
 - Adjusted vertical spacing of icons
";

comment "
Factions to Add:
 - Scimitar
 - FIA+
 - CTRG

Modules:
 - Speak
 - Pylon Editor
 - Artillery Supports

";
