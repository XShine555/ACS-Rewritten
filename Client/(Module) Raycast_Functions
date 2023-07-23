local Raycast_Functions = {}

local MainModule = require( script.Parent.Parent:WaitForChild('Main_Module') )
local TableModule = require( MainModule.TableModule )

local function HandleRaycastHit(Cast, RaycastResult, SegmentVelocity, Bullet)
	
	local HitPart = RaycastResult.Instance
	local HitPosition = RaycastResult.Position
	local HitNormal = RaycastResult.Normal
	
	if HitPart and HitPart.Parent then
		
		local Humanoid = HitPart.Parent:FindFirstChildOfClass("Humanoid")
		
		--> Send Damage To The Server.
		
		if Humanoid then
			MainModule.Replicated:WaitForChild('Event'):FireServer(Humanoid, MainModule.WeaponData.TorsoDamage[1])
		end
		
	end
	
end

local function HandleRaycastUpdate(Cast, SegmentPosition, SegmentDirection, Lenght, SegmentVelocity, Bullet)
	
	if not Bullet then
		
		return
			
	end
	
	local BulletLenght = Bullet.Size.Z / 2
	local BulletCFrame = CFrame.new(SegmentPosition, SegmentPosition + SegmentDirection)
	
	Bullet.CFrame = BulletCFrame * CFrame.new(0, 0, -(Lenght - BulletLenght) )
	
end

local function RaycastFinished(Cast)
	
	local Bullet = Cast.RayInfo.CosmeticBulletObject
	
	if Bullet then
		
		Bullet:Destroy()
		
	end
	
end

MainModule.Raycast.RayHit:Connect(HandleRaycastHit)
MainModule.Raycast.LengthChanged:Connect(HandleRaycastUpdate)
MainModule.Raycast.CastTerminating:Connect(RaycastFinished)

function Raycast_Functions.CreateBullet()

	local MuzzleCFrame, PlayerVel = MainModule.WeaponInHand.Handle.Muzzle.WorldCFrame, (MainModule.PrimaryPart.AssemblyLinearVelocity / MainModule.FramesPerSecond)

	local Direction = MuzzleCFrame.LookVector + (MuzzleCFrame.UpVector * (((MainModule.WeaponData.BulletDrop * MainModule.WeaponData.DistanceIncrement/4)/MainModule.WeaponData.MuzzleVelocity))/2)

	local Velocity = Direction * MainModule.WeaponData.MuzzleVelocity * TableModule.MuzzleVelocity
	
	local SimulateBullet = MainModule.Raycast:Fire(MainModule.WeaponInHand.Handle.Muzzle.WorldPosition, Direction, Velocity + PlayerVel, MainModule.RaycastBehavior)

end

return Raycast_Functions
