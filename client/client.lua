ESX = exports["es_extended"]:getSharedObject()

ESXcheck = false
displayText = false

CreateThread(function()

  local blip = AddBlipForCoord(Config.CardCenter.Cords)

  SetBlipSprite (blip, 744)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.8)
  SetBlipColour (blip, 46)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName('STRING')
  AddTextComponentSubstringPlayerName(Config.CardCenter.Name)
  EndTextCommandSetBlipName(blip)

end)  

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Config.Pedlocation) do
			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(v.Cords - pos)
			if dist < 40 and pedspawned == false then
				TriggerEvent('Esx:pedspawn',v.Cords,v.h)
				pedspawned = true
			end
			if dist >= 35 then
				pedspawned = false
				DeletePed(npc)
			end
		end
	end
  
end)

RegisterNetEvent('Esx:pedspawn')
AddEventHandler('Esx:pedspawn',function(coords,heading)

  local hash = Config.Postalped[math.random(#Config.Postalped)]
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		Wait(10)
	end
	while not HasModelLoaded(hash) do 
		Wait(10)
	end
  pedspawned = true
	npc = CreatePed(5, hash, coords, heading, false, false)
	FreezeEntityPosition(npc, true)
  SetBlockingOfNonTemporaryEvents(npc, true)
  SetEntityInvincible(npc, true)

end)
 
function idcarid()
  TriggerServerEvent('Esx:id')
end  

function drivelicense()
  TriggerServerEvent('Esx:drive')
end

function weaponlicense()
  TriggerServerEvent('Esx:weapon')
end
 

function idcarmenu()

  local Elements = {
    {
     unselectable=true,
     icon="fa-solid fa-basket-shopping",
     title="Card Center",
    },
    {
     icon = 'fa-solid fa-address-card',
     title="ID card",
     description="Get ID card /2000$"
    },
    {
      icon = 'fa-solid fa-address-card',
      title="driver license",
      description="Get driver license /5000$"
    },
    {
      icon = 'fa-solid fa-address-card',
      title="weapon license",
      description="Get weapon license /5000$"
    },
  }
  ESX.OpenContext("right" , Elements,
    function(menu,element)  
    if element.title == "ID card" then
      idcarid()
      ESX.CloseContext()
    elseif element.title == "driver license" then 
      drivelicense()
    elseif element.title == "weapon license" then 
      weaponlicense()
    end
    ESX.CloseContext()
  end, function(menu) 
  end)

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, Config.CardCenter.Marker)

        if distance < 3.0 then
            if not displayText then
              ESX.TextUI('press [E] to open the menu',"info")
                displayText = true
            end

            if distance < 3.0 then
                if IsControlJustReleased(0, 38) then 
                    idcarmenu()
                end
            end
        else
            if displayText then
                ESX.HideUI()
                displayText = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        if ESXcheck then
          ESXcheck = false
        end
    end
end)

RegisterNetEvent("Esx:client:id")
AddEventHandler("Esx:client:id", function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height)
    local Player, Distance = ESX.Game.GetClosestPlayer()
    if not ESXcheck then
      ESXcheck = true
        TriggerServerEvent("Esx:server:id", command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, Player ~= -1 and Distance <= 3)
    end
end)

RegisterNetEvent("Esx:client:weapon")
AddEventHandler("Esx:client:weapon", function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height)
    local Player, Distance = ESX.Game.GetClosestPlayer()
    if not ESXcheck then
      ESXcheck = true
        TriggerServerEvent("Esx:server:weapon", command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, Player ~= -1 and Distance <= 3)
    end
end)

RegisterNetEvent("Esx:client:drivers")
AddEventHandler("Esx:client:drivers", function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height)
    local Player, Distance = ESX.Game.GetClosestPlayer()
    if not ESXcheck then
        ESXcheck = true
        TriggerServerEvent("Esx:server:drivers", command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, Player ~= -1 and Distance <= 3)
    end
end)

RegisterNetEvent("Esx:client:showanim")
AddEventHandler("Esx:client:showanim", function()
    local playerPed = PlayerPedId()
    local animDict = 'paper_1_rcm_alt1-8'
    local animName = 'player_one_dual-8'
    ESX.Streaming.RequestAnimDict(animDict, function()
        local propName = 'prop_franklin_dl'
        local propHash = GetHashKey(propName)
        RequestModel(propHash)
        while not HasModelLoaded(propHash) do
            Citizen.Wait(0)
        end
        local prop = CreateObject(propHash, GetEntityCoords(playerPed), true, true, true)
        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, 0.02, -0.03, -90.0, 170.0,  78.999001, true, true, false, true, 1, true)
        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 0, 0.0, false, false, false)
        Citizen.Wait(3000)
        ClearPedTasks(playerPed)
        DeleteObject(prop)
        RemoveAnimDict(animDict)
    end)
end)
