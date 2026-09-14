-- Script Map Dumper untuk Delta Executor
local function dumpMapFeatures()
    local results = {}
    local counts = {}

    -- Fungsi rekursif untuk membaca isi map
    local function scan(parent)
        for _, child in ipairs(parent:GetChildren()) do
            local className = child.ClassName
            
            -- Hitung jumlah dan simpan nama objek unik
            counts[className] = (counts[className] or 0) + 1
            
            if not results[className] then
                results[className] = {}
            end
            
            -- Batasi maksimal 50 sampel nama objek per kategori agar file tidak terlalu besar
            if #results[className] < 50 then
                table.insert(results[className], child.Name)
            end
            
            -- Lanjut scan anak dari objek ini (jika ada)
            if #child:GetChildren() > 0 then
                scan(child)
            end
        end
    end

    -- Mulai scan dari Workspace
    scan(workspace)

    -- Format hasil ke dalam teks
    local output = "=== LAPORAN FITUR & OBJEK MAP ROBLOX ===\n\n"
    
    output ..= "REKAPITULASI JUMLAH:\n"
    for class, count in pairs(counts) do
        output ..= string.format("- %s: %d objek\n", class, count)
    end
    
    output ..= "\n\nDETAIL CONTOH OBJEK:\n"
    for class, names in pairs(results) do
        output ..= string.format("\n[%s]\n", class)
        output ..= table.concat(names, ", ") .. "\n"
    end

    -- Simpan ke file nono.txt menggunakan fungsi executor (Delta support writefile)
    local success, err = pcall(function()
        writefile("nono.txt", output)
    end)

    if success then
        print("Berhasil! Cek file nono.txt di folder workspace executor kamu.")
    else
        warn("Gagal menyimpan file: " .. tostring(err))
    end
end

dumpMapFeatures()
