-- Script untuk Membuat Karakter Kebal Permanen (God Mode Client-Side)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fungsi untuk mengunci atau mencegah karakter menerima damage/status mati lokal
local function enableGodMode()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	
	if humanoid then
		-- Cara 1: Mengunci Health agar tidak bisa berkurang lewat perubahan manual
		humanoid.HealthChanged:Connect(function(health)
			if health < humanoid.MaxHealth then
				humanoid.Health = humanoid.MaxHealth
			end
		end)
		
		-- Memastikan HP selalu penuh
		humanoid.Health = humanoid.MaxHealth
		print("God Mode (Kebal Permanen) berhasil diaktifkan untuk: " .. LocalPlayer.Name)
	end
end

-- Jalankan saat pertama kali dieksekusi
enableGodMode()

-- Otomatis pasang ulang jika karakter respawn (mati lalu hidup lagi)
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	task.wait(1) -- Tunggu karakter selesai dimuat
	enableGodMode()
end)
