Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) -- Alle 500 Millisekunden überprüfen

        -- Hol dir den Spielerped und dessen Position
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local radius = 100.0
        
        -- Hole alle NPCs in der Nähe
        for ped in EnumeratePeds() do
            if not IsPedAPlayer(ped) then
                -- Aggressives Verhalten deaktivieren
                SetPedFleeAttributes(ped, 0, false)         -- NPCs fliehen nicht
                SetPedCombatAttributes(ped, 46, true)       -- NPCs sind nicht kampfbereit
                SetPedAlertness(ped, 0)                     -- Wachsamkeit auf Null setzen
                SetPedCanBeTargetted(ped, false)            -- Nicht als Ziel markiert
                SetPedCanRagdollFromPlayerImpact(ped, false)-- Kein Ragdoll-Effekt durch Spieler
                SetPedHearingRange(ped, 0.0)                -- Gehör auf Null setzen
                SetPedSeeingRange(ped, 0.0)                 -- Sichtweite auf Null setzen
                SetBlockingOfNonTemporaryEvents(ped, true)  -- Reagiert nicht auf Ereignisse
                SetPedIsDrunk(ped, false)                   -- NPCs sind nicht betrunken
                DisablePedPainAudio(ped, true)              -- Schmerzgeräusche deaktivieren
                
                -- Deaktiviert Kampfmodi der NPCs
                SetPedCombatAbility(ped, 0)                 -- Kampffähigkeit auf Null setzen
                SetPedCombatRange(ped, 0)                   -- Kampfentfernung auf Null
                SetPedCombatMovement(ped, 0)                -- Keine Kampfbewegungen
            end
        end
    end
end)

-- EnumeratePeds Funktion für Ped-Iteration
function EnumeratePeds()
    return coroutine.wrap(function()
        local handle, ped = FindFirstPed()
        if not handle or handle == -1 then
            EndFindPed(handle)
            return
        end
        
        local success
        repeat
            coroutine.yield(ped)
            success, ped = FindNextPed(handle)
        until not success

        EndFindPed(handle)
    end)
end
