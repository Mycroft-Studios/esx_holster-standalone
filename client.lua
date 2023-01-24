-- Author: Otacon & Mycroft
-- Origonal Github: https://github.com/Dr-Otacon/esx_holster

----------GANG ANIMATION WEAPONS----------
local weaponsFull = {
	'WEAPON_KNIFE',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_COMBATPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_GUSENBERG',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_DBSHOTGUN',
	'WEAPON_DOUBLEACTION',
}

------HOLSTER WEAPONS-----------
local weaponsHolster = {
	'WEAPON_PISTOL',
	'WEAPON_COMBATPISTOL',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_DOUBLEACTION',
	'WEAPON_REVOLVER',
	'WEAPON_FLAREGUN',
}

-----TRUNK WEAPONS-------
local weaponsLarge = {
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_CARBINERIFLE",
	"WEAPON_SMG",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_GUSENBERG",
	"WEAPON_MG",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SNIPERRIFLE",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_COMBATPDW",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_MUSKET",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_SMG_MK2",
	"WEAPON_SPECIALCARBINE_MK2",
}

--- Variables ------
local holstered  = true
local hasWeapon				= false
local currWeapon 	    	= joaat("WEAPON_UNARMED")
local animateTrunk 			= false
local hasWeaponH  			= false
local hasWeaponL      		= false
local weaponL         		= joaat("WEAPON_UNARMED")
local has_weapon_on_back 	= false
local racking         		= false
local holster 				= 0
local blocked 				= false
local sex 					= 0
local handOnHolster 		= false
local holsterHold			= false
local ped					= nil


--- VISUAL WEAPONS ----

local SETTINGS = {
	back_bone = 24816,
	x = 0.3,  --- Neagtive up; positive down
	y = -0.15,   --- negative is away from body   - positive is in body 
	z = -0.10,   -- positive left --- negative right
	x_rotation = 180.0,
	y_rotation = 145.0,
	z_rotation = 0.0,
	compatable_weapon_hashes = {
			-- assault rifles:
			["w_sg_pumpshotgunmk2"] = joaat("WEAPON_PUMPSHOTGUN_MK2"),
			["w_ar_carbineriflemk2"] = joaat("WEAPON_CARBINERIFLE_MK2"),
			["w_ar_assaultrifle"] = joaat("WEAPON_ASSAULTRIFLE"),
			["w_sg_pumpshotgun"] = joaat("WEAPON_PUMPSHOTGUN"),
			["w_ar_carbinerifle"] = joaat("WEAPON_CARBINERIFLE"),
			["w_ar_assaultrifle_smg"] = joaat("WEAPON_COMPACTRIFLE"),
			["w_sb_smg"] = joaat("WEAPON_SMG"),
			["w_sb_pdw"] = joaat("WEAPON_COMBATPDW"),
			["w_mg_mg"] = joaat("WEAPON_MG"),
			["w_sb_gusenberg"] = joaat("WEAPON_GUSENBERG"),
			["w_ar_advancedrifle"] = joaat("WEAPON_ADVANCEDRIFLE"),
			["w_sr_sniperrifle"] = joaat("WEAPON_SNIPERRIFLE"),
			["w_ar_assaultriflemk2"] = joaat("WEAPON_ASSAULTRIFLE_MK2"),
			["w_mg_combatmgmk2"] = joaat("WEAPON_COMBATMG_MK2"),
			["w_ar_musket"] = joaat("WEAPON_MUSKET"),
			["w_ar_specialcarbine"] = joaat("WEAPON_SPECIALCARBINE"),
			["w_sb_smgmk2"] = joaat("WEAPON_SMG_MK2"),
			["w_ar_specialcarbinemk2"] = joaat("WEAPON_SPECIALCARBINE_MK2"),
	}
}

local attached_weapons = {}
-------END VISUAL WEAPONS

-- selects which holster
RegisterCommand("holster", function(source, args, raw)
	-- No Holster
    if args[1] == '0' then
		holster = 0
		Config.Notification('No Holster')
	-- Chain 8
    elseif args[1] == '1' then
		holster = 1
		Config.Notification('Holster Chain 8')
	-- Chain 6
    elseif args[1] == '2' then
		holster = 2
		Config.Notification('Holster Chain 6')
	-- T-shirt 15
    elseif args[1] == '3' then
		holster = 3
		Config.Notification('Holster T-Shirt 15')
		elseif args[1] == '4' then
		holster = 4
		Config.Notification('Holster Chain 1')
    else
        Config.Notification('Incorrect use: /holster 0,1,2,3')
    end
end, false)

-- for different holsters for males and females
RegisterCommand("sex", function(source, args, raw)
    if args[1] == 'm' then
		sex = 0
		Config.Notification('Holster set to Male')
    elseif args[1] == 'f' then
		sex = 1
		Config.Notification('holster set to Female')
	else
        Config.Notification('Incorrect use: /sex m,f')
    end
end, false)


 -- MAIN FUNCTION
 CreateThread(function()
	local newWeapon = joaat("WEAPON_UNARMED")
	while true do
		Wait(500)
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(ped, true) then
			newWeapon = GetSelectedPedWeapon(ped)
			if newWeapon ~= currWeapon then
				if checkWeaponLarge(ped, newWeapon) then
					if hasWeaponL then
						holsterWeaponL(ped, currWeapon)
					elseif holster >= 1 and holster <= 4 then
						if hasWeapon then
							if hasWeaponH then
								holsterWeaponH(ped, currWeapon)
							else
								holsterWeapon(ped, currWeapon)
							end
						end
					else
						if hasWeapon then
							holsterWeapon(ped, currWeapon)
						end
					end
					drawWeaponLarge(ped, newWeapon)
				elseif holster >= 1 and holster <= 4 then
					if hasWeaponL then
						holsterWeaponL()
					elseif hasWeaponH then
						holsterWeaponH(ped, currWeapon)
					elseif hasWeapon then
						holsterWeapon(ped, currWeapon)
					end
					if checkWeaponHolster(ped, newWeapon) then
						drawWeaponH(ped, newWeapon)
					else
						drawWeapon(ped, newWeapon)
					end
				else
					if hasWeaponL then
						holsterWeaponL()
					elseif hasWeapon then
						holsterWeapon(ped, currWeapon)
					end
					drawWeapon(ped, newWeapon)
				end
				currWeapon = newWeapon
			end
		else
			hasWeapon = false
			hasWeaponH = false
		end
		if racking then
			rackWeapon()
		end
	end
end)

-----------------LARGE WEAPON STUFF ------------------------------
function drawWeaponLarge(ped, newWeapon)
	------Check if weapon is on back -------
	if has_weapon_on_back and newWeapon == weaponL then
		drawWeaponOnBack()
		has_weapon_on_back = false
		return
	end

	local door = isNearDoor()
	if door == 'driver' or door == 'passenger' then
		blocked = true
		BlockInputs()
		local coordA = GetEntityCoords(ped)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorOpen(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorOpen(vehicle, 1, false, false)
			end
		end
		removeWeaponOnBack()
		startAnim("mini@repair", "fixing_a_ped")
		SetCurrentPedWeapon(ped, newWeapon, true)
		blocked = false
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorShut(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorShut(vehicle, 1, false, false)
			end
		end
		weaponL = newWeapon
		hasWeaponL = true
	elseif not isNearTrunk() then
		SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
		Config.Notification('You need to be at a trunk to draw that weapon!')
	else
		blocked = true
		BlockInputs()
		removeWeaponOnBack()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		local coordA = GetEntityCoords(ped)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			SetVehicleDoorShut(vehicle, 5, false, false)
		end
		weaponL = newWeapon
		hasWeaponL = true
	end
end


--- Checks if large weapon
function checkWeaponLarge(ped, newWeapon)
	for i = 1, #weaponsLarge do
		if joaat(weaponsLarge[i]) == newWeapon then
			return true
		end
	end
	return false
end

--- Starts animation for trunk
function startAnim(lib, anim)
	RequestAnimDict(lib)
	while not HasAnimDictLoaded( lib) do
		Wait(1)
	end
	TaskPlayAnim(ped, lib ,anim ,8.0, -8.0, -1, 0, 0, false, false, false )
	Wait(4000)
	ClearPedTasksImmediately(ped)
end



--------------START WEAPON ON BACK-------------------------

--- Pulls weapon from back and puts in hands
function holsterWeaponL()
	SetCurrentPedWeapon(ped, weaponL, true)
	pos = GetEntityCoords(ped, true)
	rot = GetEntityHeading(ped)
	blocked = true
	BlockInputs()
	TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", pos, 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
	Wait(500)
	SetCurrentPedWeapon(ped, joaat('WEAPON_UNARMED'), true)
	placeWeaponOnBack()
	Wait(1500)
	ClearPedTasks(ped)
	blocked = false
	SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
	hasWeaponL = false
end

--- Pulls weapon from back and puts in hands
function drawWeaponOnBack()
	pos = GetEntityCoords(ped, true)
	rot = GetEntityHeading(ped)
	blocked = true
	BlockInputs()
	loadAnimDict( "reaction@intimidation@1h" )
	TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", pos, 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
	removeWeaponOnBack()
	SetCurrentPedWeapon(ped, weaponL, true)
	Wait(2000)
	ClearPedTasks(ped)
	blocked = false
	hasWeaponL = true
end

--- Removes model of weapon from back
function removeWeaponOnBack()
	has_weapon_on_back = false
end

-- Places model of weapon on back
function placeWeaponOnBack()
	has_weapon_on_back = true
end

--Command to rack weapon in vehicle
RegisterCommand('rack', function()
	SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
	racking = true
end, false)

function rackWeapon()
	local door = isNearDoor()
	if (door == 'driver' or door == 'passenger') then
		blocked = true
		BlockInputs()
		local coordA = GetEntityCoords(ped)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorOpen(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorOpen(vehicle, 1, false, false)
			end
		end
		removeWeaponOnBack()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorShut(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorShut(vehicle, 1, false, false)
			end
		end
		WeaponL = joaat("WEAPON_UNARMED")
		
	elseif isNearTrunk() then
		blocked = true
		BlockInputs()
		removeWeaponOnBack()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		local coordA = GetEntityCoords(ped)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			SetVehicleDoorShut(vehicle, 5, false, false)
		end
		WeaponL = joaat("WEAPON_UNARMED")
		hasWeaponL = false
	else
		Config.Notification('You need to be at a trunk to put away your weapon!')
	end
	racking = false
end

-------------END WEAPON ON BACK--------------
-------------WEAPON ON BACK VISUAL-----------

CreateThread(function()
  while true do
		local me = PlayerPedId()
		Wait(200)
      ---------------------------------------
      -- attach if player has large weapon --
      ---------------------------------------
      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
          if weaponL == wep_hash and has_weapon_on_back and HasPedGotWeapon(me, wep_hash, false) then
              if not attached_weapons[wep_name] then
                  AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
              end
          end
      end
      --------------------------------------------
      -- remove from back if equipped / dropped --
      --------------------------------------------
      for name, attached_object in pairs(attached_weapons) do
          -- equipped? delete it from back:
          if not has_weapon_on_back then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
      end
  Wait(0)
  end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(joaat(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end
	AttachEntityToEntity(attached_weapons[attachModel].handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end

--------END WEAPON ON BACK VISUAL -----------------------------

--- Checks if player is near trunk
function isNearTrunk()
	local coordA = GetEntityCoords(ped)
	local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
	local vehicle = getVehicleInDirection(coordA, coordB)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
		local lTail = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_l"))
		local rTail = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_r"))
		local playerpos = GetEntityCoords(ped)
		local distanceToTrunk = #(trunkpos - playerpos)
		local distanceToLeftT = #(lTail - playerpos)
		local distanceToRightT = #(rTail - playerpos)
		if distanceToTrunk < 1.5 then
			SetVehicleDoorOpen(vehicle, 5, false, false)
			return true
		elseif distanceToLeftT < 1.5 and distanceToRightT < 1.5 then
			SetVehicleDoorOpen(vehicle, 5, false, false)
			return true
		else
			return
		end
	end
end

function isNearDoor()
	local coordA = GetEntityCoords(ped)
	local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
	local vehicle = getVehicleInDirection(coordA, coordB)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		local dDoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_f"))
		local pDoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_pside_f"))
		local playerpos = GetEntityCoords(ped)
		local distanceToDriverDoor = GetDistanceBetweenCoords(dDoor, playerpos, 1)
		local distanceToPassengerDoor = GetDistanceBetweenCoords(pDoor, playerpos, 1)
		if distanceToDriverDoor < 2.0 then
			return 'driver'
		elseif distanceToPassengerDoor < 2.0 then
			return 'passenger'
		else
			return
		end
	end
end

-- Gets vehicle for trunk
function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, ped, 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

------------- START WEAPON HOLSTER -----------------------

function checkWeaponHolster(ped, newWeapon)
	for i = 1, #weaponsHolster do
		if joaat(weaponsHolster[i]) == newWeapon then
			return true
		end
	end
	return false
end

-- Puts weapons in holster
function holsterWeaponH(ped, currentWeapon)
	blocked = true
	BlockInputs()
	SetCurrentPedWeapon(ped, currentWeapon, true)
	loadAnimDict("reaction@intimidation@cop@unarmed")
	TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
	addWeaponHolster()
	Wait(200)
	SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
	Wait(1000)
	ClearPedTasks(ped)
	hasWeapon = false
	hasWeaponH = false
	blocked = false
end

--Draws Weapons from holster
function drawWeaponH(ped, newWeapon)
	blocked = true
	BlockInputs()
	loadAnimDict("rcmjosh4")
  loadAnimDict("weapons@pistol@")
	loadAnimDict("reaction@intimidation@cop@unarmed")
	if not handOnHolster then
		SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
		TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
		Wait(300)
	end
	while holsterHold do
		Wait(1)
	end
	TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
	SetCurrentPedWeapon(ped, newWeapon, true)
	removeWeaponHolster()
	if not handOnHolster then
		Wait(300)
	end
  ClearPedTasks(ped)
	hasWeaponH = true
	hasWeapon = true
	handOnHolster = false
	blocked = false
end

-- Sets ped to have holster without weapon
function removeWeaponHolster()
	if holster == 1 then
		SetPedComponentVariation(ped, 7, 2, 0, 0)
	elseif holster == 2 then
		SetPedComponentVariation(ped, 7, 5, 0, 0)
	elseif holster == 3 then
		if sex == 0 then
			SetPedComponentVariation(ped, 8, 18, 0, 1)
		else
			SetPedComponentVariation(ped, 8, 10, 0, 1)
		end
	elseif holster == 4 then
		SetPedComponentVariation(ped, 7, 3, 0, 0)
	end
end

-- Sets ped to have holster with weapon
function addWeaponHolster()
	if holster == 1 then
		SetPedComponentVariation(ped, 7, 8, 0, 0)
	elseif holster == 2 then
		SetPedComponentVariation(ped, 7, 6, 0, 0)
	elseif holster == 3 then
		if sex == 0 then
			SetPedComponentVariation(ped, 8, 16, 0, 1)
		else
			SetPedComponentVariation(ped, 8, 9, 0, 1)
		end
	elseif holster == 4 then
		SetPedComponentVariation(ped, 7, 1, 0, 0)
	end
end

------------- START GANG WEAPON ------------------------

-- Holsters all other weapons
function holsterWeapon(ped, currentWeapon)
	if checkWeaponLarge(ped, currentWeapon) then
		placeWeaponOnBack()
	elseif checkWeapon(ped, currentWeapon) then
		SetCurrentPedWeapon(ped, currentWeapon, true)
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
		BlockInputs()
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
		Wait(500)
		SetCurrentPedWeapon(ped, joaat('WEAPON_UNARMED'), true)
		Wait(1500)
		ClearPedTasks(ped)
		blocked = false
	end
	hasWeapon = false
end

--Draws all other weapons
function drawWeapon(ped, newWeapon)
	if newWeapon == joaat("WEAPON_UNARMED") then
		return
	end
	if checkWeapon(ped, newWeapon) then
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
		BlockInputs()
		loadAnimDict( "reaction@intimidation@1h" )
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
		SetCurrentPedWeapon(ped, newWeapon, true)
		Wait(600)
		ClearPedTasks(ped)
		blocked = false
	else
		SetCurrentPedWeapon(ped, newWeapon, true)
	end
	handOnHolster = false
	hasWeapon = true

end

function checkWeapon(ped, newWeapon)
	for i = 1, #weaponsFull do
		if joaat(weaponsFull[i]) == newWeapon then
			return true
		end
	end
	return false
end

---------HOLSTER ANIMATION --------------------

RegisterCommand("holster", function()
	local ped = PlayerPedId()
	if ( DoesEntityExist( ped ) and not IsEntityDead( ped )) and not IsPedInAnyVehicle(ped, true) then
		loadAnimDict( "move_m@intimidation@cop@unarmed" )
		if ( IsEntityPlayingAnim( ped, "move_m@intimidation@cop@unarmed", "idle", 3 ) ) then
			ClearPedSecondaryTask(ped)
			SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
			handOnHolster = false
		else
			TaskPlayAnim(ped, "move_m@intimidation@cop@unarmed", "idle", 8.0, 2.5, -1, 49, 0, 0, 0, 0 )
			SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true)
			handOnHolster = true
			holsterHold = true
			Wait(1000)
			holsterHold = false
		end    
	end
end)

RegisterKeyMapping("holster", "Holster Weapons", "keyboard", "z")

--------- BLOCKS PLAYER ACTIONS -----------------
function BlockInputs()
CreateThread(function()
    while blocked do
		local Sleep = 0
        DisableControlAction(1, 25, true )
        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
        DisableControlAction(1, 23, true)
		DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
		DisableControlAction(1, 182, true)  -- Disables L
		DisablePlayerFiring(ped, true) -- Disable weapon firing
		Wait(Sleep)
    end
end)
--------- BLOCKS PLAYER ACTIONS -----------------

--Loads Animation Dictionary
function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(5)
	end
end
