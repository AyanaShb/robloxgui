-- Script Rapid Fire berdasarkan key yang ditemukan di dump (AtkSpeed / FireSpeedRate)
local function setRapidFire()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_CODE_APP)
    
    -- Cari nilai terkait kecepatan tembak (AtkSpeed atau FireSpeedRate)
    -- Ubah tipe data sesuai dengan struktur game (biasanya Float)
    gg.searchNumber("1.0", gg.TYPE_FLOAT)
    gg.refineNumber("1.0", gg.TYPE_FLOAT)
    
    local results = gg.getResults(100)
    print("Ditemukan " .. #results .. " potensi offset AtkSpeed / FireSpeedRate.")
    
    -- Modifikasi nilai untuk mempercepat rate of fire (contoh ubah ke 2.0 atau lebih tinggi)
    for i, v in ipairs(results) do
        v.value = "2.0"
        v.freeze = true
    end
    gg.setValues(results)
    print("Fitur Rapid Fire aktif dan nilai telah dibekukan.")
end

setRapidFire()
