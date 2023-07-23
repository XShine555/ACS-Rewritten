
local MainModule = require( script.Parent:WaitForChild('Main_Module') )
local PrepareWeapon = require( MainModule.PrepareWeapon )
local HandleActions = require( MainModule.HandleActions )
local HandleWeapons = require( MainModule.HandleWeapon )
local Utility = MainModule.Utility


MainModule.Character.ChildAdded:Connect(function(Tool)
	
	if Tool:IsA('Tool') and (Tool:FindFirstChild('Preferences') or Tool:FindFirstChild('Animations') ) then
		PrepareWeapon.SetWeapon(Tool)		
	end
	
end)

MainModule.Character.ChildRemoved:Connect(function(Tool)

	if Tool:IsA('Tool') and (Tool:FindFirstChild('Preferences') or Tool:FindFirstChild('Animations') ) then
		PrepareWeapon.UnsetWeapon()
	end

end)

MainModule.Humanoid.Died:Connect(function()
	PrepareWeapon.UnsetWeapon()
end)

MainModule.Humanoid.StateChanged:Connect(function(Last, New)
	
	--> We Check if Player is Landed to Apply a different Sway.
	
	if MainModule.WeaponInHand then
	
		if New == Enum.HumanoidStateType.Landed then
			
			MainModule.ViewmodelSway:Impulse( Vector3.new(0, 1, 0) )
			
		elseif New == Enum.HumanoidStateType.Freefall then
			
			MainModule.ViewmodelSway:Impulse( Vector3.new(0, -1, 0) )
			
		end
		
	end
	
end)

MainModule.Humanoid.Running:Connect(function(PlayerSpeed)
	
	MainModule.PlayerSpeed = PlayerSpeed
	
	if ( PlayerSpeed >= 0.1 ) then
		MainModule.ActionPlayerMove = true
	else
		MainModule.ActionPlayerMove = false
	end
	
end)

local function WalkSway()
	
	local Tick = tick()
	
	--> Multiplier, Math.Sin(), Math.Cos().
	
	local Sway = Vector3.new(
		(0.1 / 10) * math.sin(Tick * 1.5),
		(0.1 / 10) * math.cos(Tick * 2.5),
		0
	)
	
	if MainModule.ActionPlayerMove then
		
		Sway = Vector3.new(
			-(0.4 / 100) * MainModule.PlayerSpeed * math.sin(Tick * 8),
			-(0.4 / 100) * MainModule.PlayerSpeed * math.sin(Tick * 16),
			0
		)
		
	end
	
	MainModule.ViewmodelSway:Impulse(Sway * MainModule.DeltaTime * 60)

end

local function ViewmodelSway()
	
	local Mouse = MainModule.UserInputService:GetMouseDelta()
	local AxisX, AxisY = Mouse.X, Mouse.Y
	
	local SwayDamper, MaximumAngleAxisX, MaximumAngleAxisY = MainModule.AnimData.SwayDamper, MainModule.AnimData.MaximumSwayAngle_AxisX, MainModule.AnimData.MaximumSwayAngle_AxisY
	
	if MainModule.ActionAim then
		MaximumAngleAxisX, MaximumAngleAxisY = MainModule.AnimData.MaximumSwayAngle_AxisX_Aim, MainModule.AnimData.MaximumSwayAngle_AxisY_Aim
	end
	
	local Impulse = Vector3.new(
		math.clamp(AxisX * SwayDamper, -MaximumAngleAxisX * MainModule.DeltaTime, MaximumAngleAxisX * MainModule.DeltaTime),
		math.clamp(AxisY * SwayDamper, -MaximumAngleAxisY * MainModule.DeltaTime, MaximumAngleAxisY * MainModule.DeltaTime),
		0
	)
	
	MainModule.ViewmodelSway:Impulse(Impulse)
	
	local SwayPosition = MainModule.ViewmodelSway.Position
	
	return CFrame.Angles(SwayPosition.Y, -SwayPosition.X, SwayPosition.X / 2 )
	
end

local function AdditionalSway()
	
	--> First we check if has the AimVector Unit has passed the limit (AnimData).
	
	if MainModule.AimVector.Magnitude > (MainModule.AimVector.Unit * MainModule.AnimData.AdditionalMaximumAngle).Magnitude then
		MainModule.AimVector = MainModule.AimVector.Unit * MainModule.AnimData.AdditionalMaximumAngle
	end
	
	--> We set the CFrame of the Weapon (This is the Additional Sway not the Main CFrame).
	
	local Offset = CFrame.new(
		MainModule.AimVector.X * MainModule.AnimData.MaxAimVectorX,
		MainModule.AimVector.Y * -MainModule.AnimData.MaxAimVectorY,
		0
	)
	
	--> If the Magnitude is higher than 5 then we apply the Additional Sway.
	
	if MainModule.AimVector.Magnitude > MainModule.AnimData.AdditionalDamper then
		MainModule.AimVector = Utility.Anim(MainModule.AnimData.AdditionalTime, MainModule.DeltaTime, MainModule.AimVector, MainModule.AimVector.Unit * MainModule.AnimData.AdditionalDamper)
	end
	
	return Offset
	
end

local function RenderWeaponRecoil()
	
	local RecoilForce = MainModule.WeaponData.RecoilForce
	
	local Recoil, View = MainModule.RecoilSway.Position, MainModule.ViewSway.Position
	
	local FinalRecoil = CFrame.new() --> We create a New CFrame To Adjust It When The Player Stops Shooting.
	
	if MainModule.ActionShoot then
		
		FinalRecoil = MainModule.RecoilCF * RecoilForce * Utility.CFrameAn(Recoil)
		
	end
	
	MainModule.RecoilCF = Utility.Anim( -4, MainModule.DeltaTime, MainModule.RecoilCF, FinalRecoil )
	
	MainModule.CurrentCamera.CFrame = Utility.Anim( -4, MainModule.DeltaTime, MainModule.CurrentCamera.CFrame, MainModule.CurrentCamera.CFrame * Utility.CFrameAn(View) )

end

MainModule.EveryFrame.PreRender:Connect(function(DeltaTime)
	
	if MainModule.Viewmodel and MainModule.LeftArm and MainModule.RightArm and MainModule.WeaponInHand then
		
		--> Some Variables that needs to be updated every frame for other Modules.
		
		MainModule.DeltaTime = DeltaTime
		
		MainModule.FramesPerSecond = (1 / DeltaTime) --> Gives FPS based on Delta Time.
		
		--> We update AnimPart (This keeps the Weapon in the Camera) Every frame.
		
		MainModule.AnimPart.CFrame = MainModule.CurrentCamera.CFrame * MainModule.MainCF * MainModule.BarrelAttCF
		
		RenderWeaponRecoil()
		
		local Sway, AdditionalSway = ViewmodelSway(), AdditionalSway()
		
		--> Prevent Weapon Collisions.
		
		local MuzzleLookVector = MainModule.WeaponInHand.Handle.Muzzle.WorldCFrame.LookVector
		
		MainModule.MuzzleRaycastHit = MainModule.Workspace:Raycast(MainModule.WeaponInHand.Handle.Position, MuzzleLookVector * MainModule.AnimData.WeaponRaycastSize, MainModule.MuzzleRaycastParams)
		
		if MainModule.AimPart and MainModule.ActionAim and (not MainModule.MuzzleRaycastHit or MainModule.BipodActive) then
			
			local MainCFrame = MainModule.MainCF * CFrame.new(0, 0, -0.5) * MainModule.RecoilCF * Sway:Inverse() * MainModule.AimPart.CFrame:toObjectSpace(MainModule.CurrentCamera.CFrame)
			
			MainModule.MainCF = Utility.Anim( -MainModule.WeaponData.AimTime, DeltaTime, MainModule.MainCF, MainCFrame )
			
		else
			
			MainModule.AimVector = MainModule.AimVector - (MainModule.UserInputService:GetMouseDelta() * 0.1)
			
			local MainCFrame = MainModule.AnimData.MainCFrame * AdditionalSway * MainModule.RecoilCF * Sway:Inverse()
			
			if MainModule.MuzzleRaycastHit and not MainModule.BipodActive then
				
				local RaycastAdjust = CFrame.new(0, 0, ( ( (MainModule.WeaponInHand.Handle.Position - MainModule.MuzzleRaycastHit.Position).Magnitude / MainModule.AnimData.WeaponRaycastSize ) - 1 ) * -5)
				
				MainModule.MainCF = Utility.Anim( -MainModule.WeaponData.AimTime, DeltaTime, MainModule.MainCF, MainCFrame * RaycastAdjust )
				
			else
				
				MainModule.MainCF = Utility.Anim( -MainModule.WeaponData.AimTime, DeltaTime, MainModule.MainCF, MainCFrame)
				
			end
			
		end
		
		WalkSway()
		
	end
	
end)
