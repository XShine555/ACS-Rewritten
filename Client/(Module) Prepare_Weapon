local WeaponModule = {}

local MainModule = require( script.Parent:WaitForChild('Main_Module') )
local HandleActions = require( MainModule.HandleActions )
local HandleAnimations = require( MainModule.HandleAnimations )
local TableModule = require( MainModule.TableModule )

function WeaponModule.SetWeapon(Tool)
	
	if ( MainModule.Character and MainModule.Humanoid.Health > 0 and Tool ~= nil and Tool:FindFirstChild('Preferences') ) then
		
		--> We Setup the Weapon and the Variables...
		
		MainModule.ToolEquip = true
		MainModule.UserInputService.MouseIconEnabled = false
		MainModule.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
		
		MainModule.WeaponTool = Tool
		MainModule.WeaponData = require( Tool:WaitForChild("Preferences") )
		MainModule.AnimData = require( Tool:WaitForChild("Animations") )
		MainModule.WeaponInHand = MainModule.WeaponModels:WaitForChild(Tool.Name):Clone()
		MainModule.WeaponInHand.PrimaryPart = MainModule.WeaponInHand:WaitForChild("Handle")
		
		MainModule.Viewmodel = MainModule.ArmModel:WaitForChild("Viewmodel"):Clone()
		MainModule.Viewmodel.Name = "Viewmodel"
		
		MainModule.AnimPart = Instance.new("Part", MainModule.Viewmodel)
		MainModule.AnimPart.Name = 'AnimPart'
		MainModule.AnimPart.Size = Vector3.new(0.1, 0.1, 0.1)
		MainModule.AnimPart.Anchored = true
		MainModule.AnimPart.CanCollide = false
		MainModule.AnimPart.Transparency = 1
		
		MainModule.Viewmodel.PrimaryPart = MainModule.AnimPart

		MainModule.LeftArmWeld = Instance.new("Motor6D", MainModule.AnimPart)
		MainModule.LeftArmWeld.Name = "LeftArm"
		MainModule.LeftArmWeld.Part0 = MainModule.AnimPart

		MainModule.RightArmWeld = Instance.new("Motor6D", MainModule.AnimPart)
		MainModule.RightArmWeld.Name = "RightArm"
		MainModule.RightArmWeld.Part0 = MainModule.AnimPart

		MainModule.WeaponWeld = Instance.new("Motor6D", MainModule.AnimPart)
		MainModule.WeaponWeld.Name = "Handle"
		
		MainModule.Viewmodel.Parent = MainModule.CurrentCamera

		MainModule.MainCF = MainModule.AnimData.MainCFrame
		MainModule.WeaponCF = MainModule.AnimData.WeaponCFrame

		MainModule.LeftArmCF = MainModule.AnimData.LeftArmCFrame
		MainModule.RightArmCF = MainModule.AnimData.RightArmCFrame
		
		MainModule.LeftArm = MainModule.Viewmodel:WaitForChild("Left Arm")
		MainModule.LeftArmWeld.Part1 = MainModule.LeftArm
		MainModule.LeftArmWeld.C0 = CFrame.new()
		MainModule.LeftArmWeld.C1 = CFrame.new(1, -1, -5) * CFrame.Angles( math.rad(0),math.rad(0),math.rad(0) ):inverse()

		MainModule.RightArm = MainModule.Viewmodel:WaitForChild("Right Arm")
		MainModule.RightArmWeld.Part1 = MainModule.RightArm
		MainModule.RightArmWeld.C0 = CFrame.new()
		MainModule.RightArmWeld.C1 = CFrame.new(-1, -1, -5) * CFrame.Angles( math.rad(0),math.rad(0),math.rad(0) ):inverse()
		MainModule.WeaponWeld.Part0 = MainModule.RightArm

		MainModule.LeftArm.Anchored = false
		MainModule.RightArm.Anchored = false

		TableModule.NormalFov = MainModule.WeaponData.Normal
		TableModule.ExtraFov = MainModule.WeaponData.Extra
		
		--> Bind the Actions...
		
		MainModule.ContextActionService:BindAction("Fire", HandleActions.HandleAction, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
		MainModule.ContextActionService:BindAction("Aim", HandleActions.HandleAction, true, Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2) 
		MainModule.ContextActionService:BindAction("Reload", HandleActions.HandleAction, true, Enum.KeyCode.R, Enum.KeyCode.ButtonB)
		MainModule.ContextActionService:BindAction("CycleAimpart", HandleActions.HandleAction, false, Enum.KeyCode.T)

		MainModule.ContextActionService:BindAction("CycleLaser", HandleActions.HandleAction, true, Enum.KeyCode.H)
		MainModule.ContextActionService:BindAction("CycleLight", HandleActions.HandleAction, true, Enum.KeyCode.J)

		MainModule.ContextActionService:BindAction("CycleFiremode", HandleActions.HandleAction, false, Enum.KeyCode.V)
		
		MainModule.ContextActionService:BindAction("Distance+", HandleActions.HandleAction, false, Enum.KeyCode.LeftBracket)
		MainModule.ContextActionService:BindAction("Distance-", HandleActions.HandleAction, false, Enum.KeyCode.RightBracket)
		
		MainModule.ContextActionService:BindAction('BarrelAct', HandleActions.HandleAction, false, Enum.KeyCode.B)
		
		--MainModule.WeaponSpread = math.min(MainModule.WeaponData.MinSpread * TableModule.MinSpread, MainModule.WeaponData.MaxSpread * TableModule.MaxSpread)
		MainModule.WeaponRecoil = math.min(MainModule.WeaponData.MinRecoilPower * TableModule.MinRecoilPower, MainModule.WeaponData.MaxRecoilPower * TableModule.MaxRecoilPower)
		
		MainModule.AimPart = MainModule.WeaponInHand:FindFirstChild("AimPart")
		
		--> Find Laser/Flashlight Attachments...
		
		local FoundFlashlight = MainModule.WeaponInHand:FindFirstChild('FlashlightAttachment')
		local FoundLaser = MainModule.WeaponInHand:FindFirstChild('LaserAttachment')
		
		if ( FoundFlashlight ) then
			MainModule.FlashlightAttachment = true
		end
		
		if ( FoundLaser ) then
			MainModule.LaserAttachment = true
		end
		
		--> Weld the Weapon...
		
		local Handle = MainModule.WeaponInHand:WaitForChild('Handle')
		
		for _, Part in MainModule.WeaponInHand:GetChildren() do
			
			--> We Check if the Weapon is Anchored or CanCollide.
			
			if Part:IsA('BasePart') then
				
				if Part.Anchored then
					Part.Anchored = false
				end
				
				if Part.CanCollide then
					Part.CanCollide = false
				end
				
				if not MainModule.AnimData.NeedWeld then
					break
				end
				
				if Part.Name ~= 'Handle' then
					
					if Part.Name ~= 'Bolt' and Part.name ~= 'Lid' then
						
						MainModule.Utility.Weld(Handle, Part)
						
					else
						
						MainModule.Utility.WeldComplex(Handle, Part)
						
					end
					
				end
				
			end
			
		end
		
		--> Now We Loop For The Nodes.
		
		if MainModule.WeaponInHand:FindFirstChild('Nodes') and MainModule.WeaponInHand.Nodes:IsA('Folder') then
			
			for _, Part in MainModule.WeaponInHand.Nodes:GetChildren() do

				if Part:IsA('BasePart') then

					MainModule.Utility.Weld(Handle, Part)
					Part.Anchored = false
					Part.CanCollide = false

				end

			end
			
		end
		
		--> Support For KeyFrame Animations.
		
		for AnimationName, AnimationInstance in MainModule.AnimData.Animations do
			
			MainModule.AnimData.Loaded[AnimationName] = MainModule.Viewmodel.Humanoid.Animator:LoadAnimation(AnimationInstance)
			
		end
		
		MainModule.WeaponWeld.Part1 = MainModule.WeaponInHand:WaitForChild("Handle")
		MainModule.WeaponWeld.C1 = MainModule.WeaponCF
		
		MainModule.WeaponInHand.Parent = MainModule.Viewmodel
		
		HandleAnimations.EquipAnim()
		
	end
	
end

function WeaponModule.UnsetWeapon()
	
	MainModule.ToolEquip = false
	
	MainModule.ContextActionService:UnbindAction("Fire")
	MainModule.ContextActionService:UnbindAction("Aim")
	MainModule.ContextActionService:UnbindAction("Reload")
	MainModule.ContextActionService:UnbindAction("CycleLaser")
	MainModule.ContextActionService:UnbindAction("CycleLight")
	MainModule.ContextActionService:UnbindAction("CycleFiremode")
	MainModule.ContextActionService:UnbindAction("CycleAimpart")
	MainModule.ContextActionService:UnbindAction("Distance+")
	MainModule.ContextActionService:UnbindAction("Distance-")
	MainModule.ContextActionService:UnbindAction('BarrelAct')
	
	MainModule.ActionMouse1Down = false
	MainModule.ActionAim = false
	
	MainModule.UserInputService.MouseIconEnabled = true
	MainModule.UserInputService.MouseDeltaSensitivity = 1
	MainModule.CurrentCamera.CameraType = Enum.CameraType.Custom
	MainModule.LocalPlayer.CameraMode = Enum.CameraMode.Classic
	
	if ( MainModule.WeaponInHand ) then
		
		--> Main Viewmodel
		MainModule.Viewmodel:Destroy()
		MainModule.Viewmodel = nil
		MainModule.WeaponInHand = nil
		MainModule.WeaponTool = nil
		MainModule.LeftArm = nil
		MainModule.RightArm = nil
		MainModule.LeftArmWeld = nil
		MainModule.RightArmWeld = nil
		MainModule.WeaponData = nil
		MainModule.AnimData = nil
		
		--> Attachments
		MainModule.SightAttachment = nil
		MainModule.ReticleAttachment = nil
		MainModule.BarrelAttachment = nil
		MainModule.UnderBarrelAttachment = nil
		MainModule.MiscAttachment = nil
		MainModule.LaserAttachment = nil
		MainModule.FlashlightAttachment = nil
		MainModule.BipodAttachment = nil
		MainModule.SupressorAttachment = nil
		
		MainModule.FlashlightActive = false
		MainModule.LaserActive = false
		MainModule.BipodActive = false
		
		MainModule.ActionReload = false
		
	end
	
end

return WeaponModule
