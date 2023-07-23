local MainModule = {}

MainModule.MainModule = script
MainModule.PrepareWeapon = script.Parent:WaitForChild('Prepare_Weapon')
MainModule.HandleWeapon = script.Parent:WaitForChild('Handle_Weapon')
MainModule.HandleActions = script.Parent:WaitForChild('Handle_Actions')
MainModule.TableModule = script.Parent:WaitForChild('Table_Module')
MainModule.HandleAnimations = script.Parent:WaitForChild('Handle_Animations')

MainModule.PlayerFolder = script.Parent.Parent:WaitForChild('Player')
MainModule.PlayerPreferences = require( MainModule.PlayerFolder:WaitForChild('Player_Preferences') )

--> Player Services.

MainModule.Players = game:GetService('Players')
MainModule.LocalPlayer = MainModule.Players.LocalPlayer
MainModule.PlayerService = require( MainModule.LocalPlayer:WaitForChild('PlayerScripts'):WaitForChild('PlayerModule'):WaitForChild('ControlModule') )
MainModule.Character = MainModule.LocalPlayer.Character or MainModule.LocalPlayer.CharacterAdded:Wait()
MainModule.Humanoid = MainModule.Character:WaitForChild('Humanoid')

--> Roblox Services

MainModule.Workspace = game:GetService('Workspace')
MainModule.Replicated = game:GetService('ReplicatedStorage')
MainModule.TweenService = game:GetService('TweenService')
MainModule.ContextActionService = game:GetService('ContextActionService')
MainModule.UserInputService = game:GetService('UserInputService')
MainModule.Teams = game:GetService('Teams')
MainModule.EveryFrame = game:GetService('RunService')
MainModule.CurrentCamera = MainModule.Workspace.CurrentCamera

--> Engine Services.

MainModule.Engine = MainModule.Replicated:WaitForChild('Battlefield_Engine')

MainModule.ArmModel = MainModule.Engine:WaitForChild('ArmModel')
MainModule.WeaponModels = MainModule.Engine:WaitForChild('Weapon_Models')
MainModule.Modules = MainModule.Engine:WaitForChild('Modules')

MainModule.SwayLibrary = require( MainModule.Modules:WaitForChild('SwayLibrary') )
MainModule.RaycastLibrary = require( MainModule.Modules:WaitForChild('RaycastLibrary') )
MainModule.Utility = require( MainModule.Modules:WaitForChild('Utility') )

--> Character Parts.

MainModule.PrimaryPart = MainModule.Character.PrimaryPart
MainModule.Head = MainModule.Character:WaitForChild('Head')
MainModule.UpperTorso = MainModule.Character:WaitForChild('UpperTorso')

MainModule.RightUpperArm = MainModule.Character:WaitForChild('RightUpperArm')
MainModule.RightLowerArm = MainModule.Character:WaitForChild('RightLowerArm')
MainModule.RightHand = MainModule.Character:WaitForChild('RightHand')

MainModule.LeftUpperArm = MainModule.Character:WaitForChild('LeftUpperArm')
MainModule.LeftLowerArm = MainModule.Character:WaitForChild('LeftLowerArm')
MainModule.LeftHand = MainModule.Character:WaitForChild('LeftHand')

MainModule.LowerTorso = MainModule.Character:WaitForChild('LowerTorso')

MainModule.RightUpperLeg = MainModule.Character:WaitForChild('RightUpperLeg')
MainModule.RightLowerLeg = MainModule.Character:WaitForChild('RightLowerLeg')
MainModule.RightFoot = MainModule.Character:WaitForChild('RightFoot')

MainModule.LeftUpperLeg = MainModule.Character:WaitForChild('LeftUpperLeg')
MainModule.LeftLowerLeg = MainModule.Character:WaitForChild('LeftLowerLeg')
MainModule.LeftFoot = MainModule.Character:WaitForChild('LeftFoot')

MainModule.PlayerSpeed = MainModule.PrimaryPart.AssemblyLinearVelocity

--> Function SetWeapon()

MainModule.MainCF = CFrame.new()
MainModule.WeaponCF = CFrame.new()
MainModule.LeftArmCF = CFrame.new()
MainModule.RightArmCF = CFrame.new()

MainModule.WeaponBoobleCF = CFrame.new()
MainModule.RecoilCF = CFrame.new()
MainModule.AimCF = CFrame.new()
MainModule.BarrelAttCF = CFrame.new()

MainModule.DefaultSensibility = 50

MainModule.ToolEquip = false

MainModule.WeaponTool = nil
MainModule.WeaponData = nil
MainModule.AnimData = nil
MainModule.WeaponInHand = nil
MainModule.Viewmodel = nil

MainModule.AnimPart = nil
MainModule.LeftArm = nil
MainModule.RightArm = nil
MainModule.LeftArmWeld = nil
MainModule.RightArmWeld = nil
MainModule.WeaponWeld = nil

--MainModule.WeaponSpread = nil
MainModule.WeaponRecoil = nil

MainModule.AimPart = nil

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

--> Sway Module

MainModule.RecoilSway = MainModule.SwayLibrary.New(Vector3.zero)
MainModule.RecoilSway.Damper = 0.1
MainModule.RecoilSway.Speed = 20

MainModule.ViewSway = MainModule.SwayLibrary.New(Vector3.zero)
MainModule.ViewSway.Damper = 0.4
MainModule.ViewSway.Speed = 20

MainModule.ViewmodelSway = MainModule.SwayLibrary.New(Vector3.zero)
MainModule.ViewmodelSway.Damper = 0.95
MainModule.ViewmodelSway.Speed = 10

--> Dynamic Weapon Movement

MainModule.AimVector = Vector2.new()

--> Player Actions
MainModule.ActionMouse1Down = false
MainModule.ActionAim = false
MainModule.ActionShoot = false
MainModule.ActionReload = false
MainModule.ActionSprint = false
MainModule.ActionPlayerMove = false

--> Raycast Handler.

MainModule.DeltaTime = nil
MainModule.FramesPerSecond = nil

MainModule.Raycast_Workspace = MainModule.Workspace:FindFirstChild('Raycast_Workspace') or Instance.new('Folder', MainModule.Workspace)
MainModule.Raycast_Workspace.Name = 'Raycast_Workspace'

MainModule.Raycast = MainModule.RaycastLibrary.new()

MainModule.SimulatedBullet = Instance.new('Part')
MainModule.SimulatedBullet.Name = 'Bullet-' .. MainModule.LocalPlayer.Name
MainModule.SimulatedBullet.Material = Enum.Material.Plastic
MainModule.SimulatedBullet.CanCollide = false
MainModule.SimulatedBullet.Anchored = true
MainModule.SimulatedBullet.Transparency = 1
MainModule.SimulatedBullet.Size = Vector3.new(0.1, 0.1, 0.1)

MainModule.RaycastParameters = RaycastParams.new()
MainModule.RaycastParameters.IgnoreWater = true
MainModule.RaycastParameters.FilterType = Enum.RaycastFilterType.Exclude
MainModule.RaycastParameters.FilterDescendantsInstances = {}

MainModule.RaycastBehavior = MainModule.RaycastLibrary.newBehavior()
MainModule.RaycastBehavior.RaycastParams = MainModule.RaycastParameters
MainModule.RaycastBehavior.MaxDistance = 1000
MainModule.RaycastBehavior.HighFidelityBehavior = MainModule.RaycastLibrary.HighFidelityBehavior.Default

MainModule.RaycastBehavior.CosmeticBulletTemplate = MainModule.SimulatedBullet

MainModule.RaycastBehavior.CosmeticBulletContainer = MainModule.Raycast_Workspace
MainModule.RaycastBehavior.Acceleration = Vector3.new(0, -MainModule.Workspace.Gravity, 0)
MainModule.RaycastBehavior.AutoIgnoreContainer = false

MainModule.MuzzleRaycastParams = RaycastParams.new()
MainModule.MuzzleRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
MainModule.MuzzleRaycastParams.FilterDescendantsInstances = {MainModule.Character, MainModule.Workspace.ray, MainModule.Viewmodel, MainModule.CurrentCamera, MainModule.Workspace:FindFirstChild('Raycast_Workspace')}
MainModule.MuzzleRaycastParams.IgnoreWater = true

MainModule.MuzzleRaycastHit = nil

return MainModule
