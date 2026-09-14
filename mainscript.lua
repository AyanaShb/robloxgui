-- Letakkan skrip ini di ServerScriptService atau jalankan melalui Command Bar Roblox Studio
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local searchKeywords = {
    "firerate", "rate", "cooldown", "delay", "rpm", 
    "automatic", "speed", "shoot", "interval"
}

local function searchTable(tbl, path)
    for key, value in pairs(tbl) do
        local currentPath = path .. "." .. tostring(key)
        local keyLower = string.lower(tostring(key))
        
        -- Cek apakah nama key mengandung kata kunci pencarian
        for _, keyword in ipairs(searchKeywords) do
            if string.find(keyLower, keyword) then
                print(string.format("[DUMP FOUND] Path: %s | Nilai: %s (Tipe: %s)", currentPath, tostring(value), typeof(value)))
                break
            end
        end
        
        -- Rekursif jika value berupa table/ModuleScript yang mereturn table
        if type(value) == "table" then
            searchTable(value, currentPath)
        end
    end
end

-- Cari di dalam folder Scripts atau ReplicatedStorage
local targetFolder = ReplicatedStorage:FindFirstChild("Scripts") or ReplicatedStorage

print("--- MEMULAI PENCARIAN VARIABEL FIRE RATE ---")
for _, obj in ipairs(targetFolder:GetDescendants()) do
    if obj:IsA("ModuleScript") then
        local success, data = pcall(function()
            return require(obj)
        end)
        
        if success and type(data) == "table" then
            searchTable(data, obj.Name)
        end
    end
end
print("--- PENCARIAN SELESAI ---")
