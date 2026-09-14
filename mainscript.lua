local success, result = pcall(function()
    local output = "=== DUMP MODULE SCRIPT & KONFIGURASI ===\n\n"
    
    local function scanModules(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("ModuleScript") then
                output ..= "Path: " .. child:GetFullName() .. "\n"
                local successReq, modData = pcall(require, child)
                if successReq and type(modData) == "table" then
                    output ..= "  [Tabel Data Ditemukan]\n"
                    for k, v in pairs(modData) do
                        if type(v) ~= "function" then
                            output ..= string.format("    -> %s = %s\n", tostring(k), tostring(v))
                        end
                    end
                end
                output ..= "\n-----------------------------------\n"
            end
        end
    end

    scanModules(ReplicatedStorage)
    scanModules(game:GetService("ServerScriptService")) -- Jika executor mendukung read/access
    
    return output
end)

if success and result and writefile then
    writefile("modules_dump.txt", result)
    print("Dump ModuleScript selesai! Cek file modules_dump.txt")
end
