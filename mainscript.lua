local fileName = "weapon_dump.txt"
writefile(fileName, "=== WEAPON CONFIG DUMP START ===\n\n")

local function appendLog(text)
    appendfile(fileName, text .. "\n")
end

-- Fokuskan pencarian ke area penyimpanan script/modul game
local targets = {
    {name = "ReplicatedStorage", service = game:GetService("ReplicatedStorage")},
    {name = "ReplicatedFirst", service = game:GetService("ReplicatedFirst")},
    {name = "Players (LocalPlayer Tools)", service = game:GetService("Players").LocalPlayer}
}

local function scanModules(parent, indent)
    indent = indent or ""
    local success, children = pcall(function() return parent:GetChildren() end)
    if not success then return end
    
    for _, child in ipairs(children) do
        -- Cari yang berpotensi menyimpan data senjata (ModuleScript, LocalScript, RemoteEvent, Folder senjata)
        local className = child.ClassName
        if className == "ModuleScript" or className == "LocalScript" or className == "RemoteEvent" or className == "Folder" then
            local line = string.format("%s- [%s] %s", indent, className, child.Name)
            appendLog(line)
            
            -- Jika namanya mencurigakan (mengandung kata weapon, gun, ammo, combat, config), beri tanda khusus
            local lowerName = child.Name:lower()
            if lowerName:find("weapon") or lowerName:find("gun") or lowerName:find("ammo") or lowerName:find("config") or lowerName:find("combat") or lowerName:find("shoot") then
                appendLog(indent .. "   ^ [TARGET POTENSIAL]")
            end
        end
        
        if #indent < 15 then
            scanModules(child, indent .. "  ")
        end
    end
end

for _, target in ipairs(targets) do
    appendLog("========================================")
    appendLog("SERVICE: " .. target.name)
    appendLog("========================================")
    pcall(function()
        scanModules(target.service, "")
    end)
    appendLog("\n")
end

appendfile(fileName, "=== DUMP SELESAI ===")
print("Selesai! Cek file " .. fileName .. " di folder workspace executor.")
