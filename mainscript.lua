-- Script Map Dumper dengan Header Status & Validasi Output
local success, result = pcall(function()
    local results = {}
    local counts = {}
    local totalScanned = 0

    local function scan(parent)
        for _, child in ipairs(parent:GetChildren()) do
            totalScanned = totalScanned + 1
            local className = child.ClassName
            counts[className] = (counts[className] or 0) + 1
            
            if not results[className] then
                results[className] = {}
            end
            
            if #results[className] < 30 then
                table.insert(results[className], child.Name)
            end
            
            if #child:GetChildren() > 0 then
                scan(child)
            end
        end
    end

    scan(workspace)

    -- Header status penanda
    local output = string.format("=== STATUS: %s ===\n", totalScanned > 0 and "BERHASIL" : "KOSONG")
    output ..= string.format("Total Objek Ditemukan: %d\n\n", totalScanned)
    
    if totalScanned == 0 then
        output ..= "[!] PERINGATAN: Workspace kosong atau terbaca 0 objek. Kemungkinan game memproteksi isi map (Anti-Dump).\n"
    else
        output ..= "REKAPITULASI JUMLAH:\n"
        for class, count in pairs(counts) do
            output ..= string.format("- %s: %d objek\n", class, count)
        end
        
        output ..= "\n\nDETAIL CONTOH OBJEK:\n"
        for class, names in pairs(results) do
            output ..= string.format("\n[%s]\n", class)
            output ..= table.concat(names, ", ") .. "\n"
        end
    end

    return output
end)

if success and result then
    if setclipboard then
        setclipboard(result)
        print("Selesai! Cek hasil status di clipboard (Paste di catatan).")
    elseif toclipboard then
        toclipboard(result)
        print("Selesai! Disalin ke clipboard.")
    else
        warn("Executor tidak support clipboard otomatis.")
    end
    print(result)
else
    local errOutput = "=== STATUS: GAGAL TOTAL ===\nError Script: " .. tostring(result)
    if setclipboard then setclipboard(errOutput) end
    warn(errOutput)
end
