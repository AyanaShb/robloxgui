-- Script Debug & Dump Module/Table Senjata ke File TXT
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local function dumpTable(t, indent, visited)
    visited = visited or {}
    if type(t) ~= "table" then return tostring(t) end
    if visited[t] then return "[Cyclic Reference]" end
    visited[t] = true
    
    indent = indent or 0
    local formatting = string.rep("  ", indent)
    local result = "{\n"
    
    for k, v in pairs(t) do
        local keyStr = tostring(k)
        local valType = type(v)
        if valType == "table" then
            result = result .. formatting .. "  [" .. keyStr .. "] = " .. dumpTable(v, indent + 1, visited) .. ",\n"
        elseif valType == "function" then
            result = result .. formatting .. "  [" .. keyStr .. "] = [Function],\n"
        else
            result = result .. formatting .. "  [" .. keyStr .. "] = " .. tostring(v) .. ",\n"
        end
    end
    
    result = result .. formatting .. "}"
    return result
end

task.spawn(function()
    pcall(function()
        local dumpOutput = "=== D3D WEAPON & MODULE DEBUG DUMP ===\n\n"
        
        -- 1. Cek Character / Backpack untuk Tool Aktif
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        
        local toolsToScan = {}
        if char then
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("Tool") then table.insert(toolsToScan, v) end
            end
        end
        if backpack then
            for _, v in ipairs(backpack:GetChildren()) do
                if v:IsA("Tool") then table.insert(toolsToScan, v) end
            end
        end
        
        if #toolsToScan == 0 then
            dumpOutput = dumpOutput .. "Peringatan: Tidak ada Tool/Senjata yang ditemukan di Character atau Backpack. Pegang senjatanya terlebih dahulu!\n\n"
        else
            for _, tool in ipairs(toolsToScan) do
                dumpOutput = dumpOutput .. "--------------------------------------------------\n"
                dumpOutput = dumpOutput .. "TOOL FOUND: " .. tool.Name .. " (Path: " .. tool:GetFullName() .. ")\n"
                dumpOutput = dumpOutput .. "--------------------------------------------------\n"
                
                -- Cari ModuleScript di dalam Tool
                for _, desc in ipairs(tool:GetDescendants()) do
                    if desc:IsA("ModuleScript") then
                        dumpOutput = dumpOutput .. "-> ModuleScript: " .. desc.Name .. " (" .. desc:GetFullName() .. ")\n"
                        pcall(function()
                            local success, moduleData = pcall(require, desc)
                            if success and type(moduleData) == "table" then
                                dumpOutput = dumpOutput .. "   Data Table:\n" .. dumpTable(moduleData, 1) .. "\n"
                            else
                                dumpOutput = dumpOutput .. "   Data: " .. tostring(moduleData) .. "\n"
                            end
                        end)
                    end
                end
            end
        end
        
        -- 2. Scan Garbage Collector (getgc) untuk mencari tabel yang mengandung kata kunci senjata
        dumpOutput = dumpOutput .. "\n\n=== GC SCANNING (FIRE_RATE / AMMO / COOLDOWN) ===\n"
        if getgc then
            local count = 0
            for _, obj in pairs(getgc(true)) do
                if type(obj) == "table" then
                    pcall(function()
                        local hasMatch = false
                        for k, _ in pairs(obj) do
                            local sKey = tostring(k):lower()
                            if sKey:find("rpm") or sKey:find("firerate") or sKey:find("ammo") or sKey:find("cooldown") or sKey:find("reload") then
                                hasMatch = true
                                break
                            end
                        end
                        
                        if hasMatch and count < 30 then -- Batasi 30 tabel pertama agar tidak terlalu besar
                            count = count + 1
                            dumpOutput = dumpOutput .. "\n[Match Table #" .. count .. "]:\n"
                            dumpOutput = dumpOutput .. dumpTable(obj, 1) .. "\n"
                        end
                    end)
                end
            end
        else
            dumpOutput = dumpOutput .. "Executor tidak mendukung fungsi getgc().\n"
        end
        
        -- Simpan ke File
        if writefile then
            writefile("Weapon_Dump_Debug.txt", dumpOutput)
            print("[D3D Debug] Berhasil! File tersimpan sebagai 'Weapon_Dump_Debug.txt'")
        else
            print("[D3D Debug] Gagal menyimpan file karena writefile tidak disupport executor.")
        end
    end)
end)
