local ModuleWeapon = {}

local MainModule = require( script.Parent:WaitForChild('Main_Module') )
local Raycast_Functions = require( script:WaitForChild('Raycast_Functions') )
local TableModule = require( MainModule.TableModule )
local HandleAnimations = require( MainModule.HandleAnimations )

local function MathRecoil(Min, Max, Accuracy)
	
	local Inverse = 1 / (Accuracy or 1)
	
	return (math.random(Min * Inverse, Max * Inverse) / Inverse)
	
end

local function Recoil()
	
	local Recoil, View = MainModule.WeaponData.WeaponRecoil, MainModule.WeaponData.ViewRecoil
	
	local Gvr = ( math.random( Recoil.Upper[1], Recoil.Upper[2] ) / 10 ) * TableModule.WeaponRecoilModifier.Upper
	local Gdr = ( math.random(-1, 1) * math.random( Recoil.Tilt[1], Recoil.Tilt[2] ) / 10 ) * TableModule.WeaponRecoilModifier.Tilt
	local Glr = ( math.random( Recoil.Left[1], Recoil.Left[2] ) ) * TableModule.WeaponRecoilModifier.Left
	local Grr = ( math.random( Recoil.Right[1], Recoil.Right[2] ) ) * TableModule.WeaponRecoilModifier.Right
	local Ghr = ( math.random(-Grr, Glr) / 10)	
	
	if not MainModule.BipodActive then
		
		local Vr = ( math.random( View.Upper[1], View.Upper[2] ) / 2 ) * TableModule.ViewRecoilModifier.Upper
		local Lr = ( math.random( View.Left[1], View.Left[2] ) ) * TableModule.ViewRecoilModifier.Left
		local Rr = ( math.random( View.Right[1], View.Right[2] ) ) * TableModule.ViewRecoilModifier.Right
		local Hr = ( math.random(-Rr, Lr) / 2)
		local Tr = ( math.random( View.Tilt[1], View.Tilt[2] ) / 2 ) * TableModule.ViewRecoilModifier.Tilt
		
		local ViewVector = Vector3.new( math.rad(Vr * MathRecoil( 1, 1, 0.1) ), math.rad(Hr * MathRecoil( 1, 1, 0.1) ), math.rad(Tr * MathRecoil( 1, 1, 0.1) ) )
		
		MainModule.ViewSway:Impulse(ViewVector)
		
		if MainModule.ActionAim then
			
			local AimRecoilReduction = MainModule.WeaponData.AimRecoilReduction * TableModule.AimRecoilReduction
			
			Gvr *= MainModule.WeaponRecoil / AimRecoilReduction
			Ghr *= MainModule.WeaponRecoil / AimRecoilReduction
			Gdr *= MainModule.WeaponRecoil / AimRecoilReduction
			
			local RecoilVector = Vector3.new(Gvr, Ghr, Gdr)

			MainModule.RecoilSway:Impulse(RecoilVector)
			
		elseif MainModule.ActionPlayerMove then
			
			Gvr *= MainModule.WeaponRecoil * MainModule.WeaponData.RecoilMoveAddition
			Ghr *= MainModule.WeaponRecoil * MainModule.WeaponData.RecoilMoveAddition
			Gdr *= MainModule.WeaponRecoil * MainModule.WeaponData.RecoilMoveAddition

			local RecoilVector = Vector3.new(Gvr, Ghr, Gdr)

			MainModule.RecoilSway:Impulse(RecoilVector)
			
		else
			
			Gvr *= MainModule.WeaponRecoil
			Ghr *= MainModule.WeaponRecoil 
			Gdr *= MainModule.WeaponRecoil
		
			local RecoilVector = Vector3.new(Gvr, Ghr, Gdr)

			MainModule.RecoilSway:Impulse(RecoilVector)
			
		end
		
	else

		local BarrelLeanRecoilReduction = MainModule.WeaponData.BarrelLeanRecoilReduction * TableModule.BarrelLeanRecoilReduction

		Gvr *= MainModule.WeaponRecoil / BarrelLeanRecoilReduction
		Ghr *= MainModule.WeaponRecoil / BarrelLeanRecoilReduction
		Gdr *= MainModule.WeaponRecoil / BarrelLeanRecoilReduction

		local RecoilVector = Vector3.new(Gvr, Ghr, Gdr)

		MainModule.RecoilSway:Impulse(RecoilVector)
		
	end
	
end

local function RenderEffects()
	
	if MainModule.SupressorAttachment then
		
		MainModule.WeaponInHand.Handle.Muzzle.Supressor:Play()
		
	else
		
		MainModule.WeaponInHand.Handle.Muzzle.Fire:Play()
		
	end
	
	if MainModule.FlashlightAttachment then
		
		MainModule.WeaponInHand.Handle.Muzzle['Smoke']:Emit(10)
		
	else
		
		MainModule.WeaponInHand.Handle.Muzzle["FlashFX[Flash]"]:Emit(10)
		
		MainModule.WeaponInHand.Handle.Muzzle["Smoke"]:Emit(10)
		
	end
	
	if MainModule.WeaponInHand:FindFirstChild('Bolt') and MainModule.AnimData.BoltCFrame then
		
		local TweenInf = TweenInfo.new(30 / MainModule.WeaponData.ShootRate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true, 0)
		
		if MainModule.WeaponData.AmmoInMagazine >= 1 then
			
			MainModule.TweenService:Create( MainModule.WeaponInHand.Handle.Bolt, TweenInf, { C0 = MainModule.AnimData.BoltCFrame:Inverse() } ):Play()
			
		else
			
			MainModule.TweenService:Create( MainModule.WeaponInHand.Handle.Bolt, TweenInf, {C0 = MainModule.AnimData.BoltCFrame} ):Play()
			
		end
		
	end
	
	MainModule.WeaponRecoil = math.min(MainModule.WeaponData.MaxRecoilPower * TableModule.MaxRecoilPower, MainModule.WeaponRecoil + MainModule.WeaponData.RecoilPowerStepAmount * TableModule.RecoilPowerStepAmount)

end

local function Fire()
	
	MainModule.WeaponData.AmmoInMagazine -= 1
	
	task.defer(Recoil)
	
	RenderEffects()
	
	task.defer(Raycast_Functions.CreateBullet)
	
end

function ModuleWeapon.Shoot()
	
	if MainModule.WeaponData and MainModule.WeaponData.Type == 'Weapon' and not MainModule.ActionShoot then
		
		local FireMode = MainModule.WeaponData.ShootType
		
		if MainModule.ActionReload or FireMode == 'Safemode' or MainModule.ActionSprint then
			return
		end
		
		if MainModule.WeaponData.AmmoInMagazine < 1 then
			MainModule.WeaponInHand.Handle.Click:Play()
			MainModule.ActionMouse1Down = false
			return
		end
		
		MainModule.ActionMouse1Down = true
		
		MainModule.ActionShoot = true
		
		local ShootRate = (60 / MainModule.WeaponData.ShootRate)
		
		--> This Will Keep The ShootRate With All Types Of Frame Rate. (Pretty Useful)
		
		local Accumulator, Frame = 0, 0;
		
		task.delay(0, function()
			
			if FireMode == 'Semi-Automatic' then
				
				Fire()
				
				while MainModule.ActionShoot do
					
					Accumulator += Frame
					
					--> Simple Cooldown For All Types Of Frame Rates.					

					if Accumulator >= ShootRate then
						break
					end
					
					Frame = MainModule.EveryFrame.PreRender:Wait()
					
				end
				
			elseif FireMode == '2-Burst' then
				
				local ShootCount = 1
				
				Fire()
				
				while MainModule.ActionMouse1Down and ShootCount < 2 do
					
					if MainModule.WeaponData.AmmoInMagazine < 1 then
						break
					end
					
					Accumulator += Frame
					
					while Accumulator >= ShootRate do
						
						Fire()
						
						Accumulator -= ShootRate
						
						ShootCount += 1
						
					end
					
					Frame = MainModule.EveryFrame.PreRender:Wait()
					
				end
				
				
			elseif FireMode == '3-Burst' then
				
				local ShootCount = 1

				Fire()

				while MainModule.ActionMouse1Down and ShootCount < 3 do
					
					if MainModule.WeaponData.AmmoInMagazine < 1 then
						break
					end
					
					Accumulator += Frame

					while Accumulator >= ShootRate do

						Fire()

						Accumulator -= ShootRate

						ShootCount += 1

					end

					Frame = MainModule.EveryFrame.PreRender:Wait()

				end
				
			elseif FireMode == 'Automatic' then
				
				Fire()
				
				while MainModule.ActionMouse1Down do
					
					if MainModule.WeaponData.AmmoInMagazine < 1 then
						break
					end
					
					Accumulator += Frame

					while Accumulator >= ShootRate do

						Fire()

						Accumulator -= ShootRate

					end

					Frame = MainModule.EveryFrame.PreRender:Wait()
					
				end
				
			end
			
			MainModule.ActionShoot = false
			
		end)
		
	end
	
end

function ModuleWeapon.Reload()
	
	if MainModule.WeaponData and MainModule.WeaponData.Type == 'Weapon' then
		
		--> We Check The Neccesary Parameters.
		
		if MainModule.WeaponData.StoredAmmo < 1 then
			return
		end
		
		if MainModule.WeaponData.IncludeChamberedBullet and MainModule.WeaponData.AmmoInMagazine >= MainModule.WeaponData.Ammo + 1 then
			return
		end
		
		MainModule.ActionMouse1Down = false
		MainModule.ActionSprint = false
		MainModule.Humanoid.WalkSpeed = 12
		MainModule.ActionReload = true
		
		if MainModule.WeaponData.AmmoInMagazine < 1 then
			HandleAnimations.TacticalReloadAnim()
		else
			HandleAnimations.ReloadAnim()
		end
		
		--> We Check The States Of The Magazine.
		
		local NewRefill = math.min(MainModule.WeaponData.Ammo - MainModule.WeaponData.AmmoInMagazine, MainModule.WeaponData.StoredAmmo)
		
		if MainModule.WeaponData.IncludeChamberedBullet and MainModule.WeaponData.StoredAmmo >= NewRefill + 1 and MainModule.WeaponData.AmmoInMagazine >= 1 then
			NewRefill += 1
		end
		
		MainModule.WeaponData.AmmoInMagazine += NewRefill
		MainModule.WeaponData.StoredAmmo -= NewRefill
		
		MainModule.ActionReload = false
		
		local _HandleActions = require( MainModule.HandleActions )
		
		_HandleActions.CheckSprintAnimation()
		
	end
		
end

function ModuleWeapon.Aim()
	
	if ( MainModule.WeaponData and MainModule.WeaponInHand ) then
		
		if MainModule.ActionAim then
			
			MainModule.UserInputService.MouseDeltaSensitivity = (MainModule.DefaultSensibility/100)
			
			MainModule.WeaponInHand.Handle.AimUp:Play()
			
		else
			
			MainModule.UserInputService.MouseDeltaSensitivity = 1

			MainModule.WeaponInHand.Handle.AimDown:Play()
			
		end
		
	end
	
end

function ModuleWeapon.CycleFiremode()
	
	if ( MainModule.WeaponData and MainModule.WeaponInHand ) then
		
		local AvailableFiremodes = MainModule.WeaponData.AvailableFiremodes
		local Firemode = MainModule.WeaponData.ShootType
		
		local NewFiremode = table.find(AvailableFiremodes, Firemode) + 1
		
		if ( NewFiremode > #AvailableFiremodes ) then
			
			NewFiremode = 1
			
		end 
		
		MainModule.WeaponData.ShootType = AvailableFiremodes[NewFiremode]
		
		MainModule.WeaponInHand.Handle.SafetyClick:Play()
		
	end
	
end

return ModuleWeapon
