-- Script untuk mendump seluruh struktur hirarki LocalPlayer hingga ke akar terdalam ke file .txt
local OutputFile = "LocalPlayer_Deep_Dump.txt"

if not writefile then
    warn("Fungsi writefile tidak didukung oleh executor ini.")
    return
end

local player = game.Players.LocalPlayer
local dumpLines = {}

-- Fungsi rekursif untuk menelusuri setiap objek hingga ke akar terdalam
local function recursiveScan(parent, indentLevel)
    local indent = string.rep("    ", indentLevel)
    for _, child in ipairs(parent:GetChildren()) do
        local line = indent .. "- " .. child.Name .. " (" .. child.ClassName .. ")"
        table.insert(dumpLines, line)
        
        -- Lanjutkan rekursi jika objek memiliki anak (children)
        if #child:GetChildren() > 0 then
            recursiveScan(child, indentLevel + 1)
        end
    end
end

table.insert(dumpLines, "=== DEEP DUMP STRUKTUR: " .. player.Name .. " ===")
recursiveScan(player, 0)

-- Simpan hasil dump ke dalam file txt di folder workspace executor
local success, err = pcall(function()
    writefile(OutputFile, table.concat(dumpLines, "\n"))
end)

if success then
    print("Berhasil! Struktur LocalPlayer tersimpan di workspace/" .. OutputFile)
else
    warn("Gagal menyimpan file: " .. tostring(err))
end
