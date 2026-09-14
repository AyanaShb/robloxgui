local success, result = pcall(function()
    local output = "=== DAFTAR SERVICE FITUR & GAMEPLAY ===\n\n"
    
    local featureServices = {
        "Players", "Workspace", "ReplicatedStorage", "StarterGui", 
        "StarterPack", "Lighting", "SoundService", "TweenService", 
        "PathfindingService", "UserInputService", "RunService", "Teams"
    }

    for _, name in ipairs(featureServices) do
        local successService, service = pcall(game.GetService, game, name)
        if successService and service then
            output ..= string.format("[%s] (Total Anak: %d)\n", name, #service:GetChildren())
            
            local count = 0
            for _, child in ipairs(service:GetChildren()) do
                if count < 8 then
                    output ..= string.format("   -> %s (%s)\n", child.Name, child.ClassName)
                    count = count + 1
                else
                    output ..= "   -> ... (dan lainnya)\n"
                    break
                end
            end
            output ..= "\n"
        end
    end

    return output
end)

if success and result then
    if writefile then
        local writeSuccess, writeErr = pcall(function()
            writefile("dump.txt", result)
        end)
        
        if writeSuccess then
            print("Berhasil! File disimpan sebagai dump.txt di folder workspace executor.")
        else
            warn("Gagal membuat file: " .. tostring(writeErr))
            if setclipboard then setclipboard(result) end
        end
    else
        if setclipboard then setclipboard(result) end
        print("Fungsi writefile tidak didukung, disalin ke clipboard.")
    end
else
    warn("Gagal mendump service: " .. tostring(result))
end
