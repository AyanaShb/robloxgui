-- Nama File Output
local fileName = "dump_detail.txt"
writefile(fileName, "=== DETAILED MODULE CONFIG DUMP ===\n\n")

local function appendLog(text)
    appendfile(fileName, text .. "\n")
end

-- Fungsi untuk membaca isi tabel secara rekursif (Nama Key, Tipe Data, dan Nilai Defaultnya)
local function dumpTable(tbl, indent)
    indent = indent or ""
    local success, err = pcall(function()
        for key, value import in pairs(tbl) do
            local valType = type(value)
            
            if valType == "table" then
                appendLog(string.format("%s[Table] %s:", indent, tostring(key)))
                -- Batasi kedalaman agar tidak terjadi infinite loop akibat circular reference
                if #indent < 12 then
                    dumpTable(value, indent .. "  ")
                end
            elseif valType == "function" then
                appendLog(string.format("%s[Function] %s", indent, tostring(key)))
            else
                -- Mencatat Nilai Default (Angka, Boolean, String, dll)
                appendLog(string.format("%s[Value] %s = %s (%s)", indent, tostring(key), tostring(value), valType))
            end
        end
    end)
end

-- Cari ModuleScript yang berkaitan dengan senjata di ReplicatedStorage
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function scanAndDumpModules(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("ModuleScript") then
            local lowerName = child.Name:lower()
            -- Saring modul yang berpotensi menyimpan data senjata/config
            if lowerName:find("weapon") or lowerName:find("gun") or lowerName:find("config") or lowerName:find("stats") or lowerName:find("combat") then
                appendLog("========================================")
                appendLog("MODULE: " .. child:GetFullName())
                appendLog("========================================")
                
                -- Memuat module (require) untuk mendapatkan tabel aslinya
                local success, moduleData = pcall(function()
                    return require(child)
                end)
                
                if success then
                    if type(moduleData) == "table" then
                        dumpTable(moduleData, "  ")
                    else
                        appendLog("  (Module mereturn tipe data: " .. type(moduleData) .. ")")
                    end
                else
                    appendLog("  [GAGAL REQUIRE MODUL]: " .. tostring(moduleData))
                end
                appendLog("\n")
            end
        end
        
        -- Telusuri folder di dalam ReplicatedStorage secara rekursif
        if #child:GetChildren() > 0 then
            pcall(function()
                scanAndDumpModules(child)
            end)
        end
    end
end

print("Memulai dump detail modul...")
scanAndDumpModules(ReplicatedStorage)
appendLog("=== DUMP DETAIL SELESAI ===")
print("Selesai! Cek file " .. fileName .. " di folder workspace executor.")
