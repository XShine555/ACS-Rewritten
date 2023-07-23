local Utility = {}

--> Fix to Jitter, FPS Unlockers...

function Utility.Time(Value : IntValue, DeltaTime : IntValue)
	
	return 1 - math.exp(Value * DeltaTime)
	
end

--> Shortcuts.

function Utility.Anim( Duration : IntValue, DeltaTime : IntValue, ToAnim : CFrame, ... : CFrame )
	
	return ToAnim:Lerp( ..., Utility.Time(Duration, DeltaTime) )
	
end

function Utility.CFrameAn(Vector)
	
	return CFrame.Angles(Vector.X, Vector.Y, Vector.Z)
	
end

function Utility.FindHumanoid(Humanoid)
	
	return Humanoid:FindFirstChild('Humanoid')
	
end

--> General Utilities.

function Utility.Weld(Part, Part1, C0, C1)
	
	local Weld = Instance.new('Motor6D', Part)
	Weld.Part0, Weld.Part1 = Part, Part1
	Weld.Name = Part1.Name
	Weld.C0 = C0 or (Part.CFrame:Inverse() * Part1.CFrame)
	Weld.C1 = C1 or CFrame.new()
	
end

function Utility.WeldComplex(Part, Part1)
	
	local Weld = Instance.new('Motor6D')
	Weld.Name = Part1.Name
	Weld.Part0, Weld.Part1 = Part, Part1
	
	local PartPosition = CFrame.new(Part.Position)
	local C0, C1 = Part.CFrame:Inverse() * PartPosition, Part1.CFrame:Inverse() * PartPosition
	
	Weld.C0, Weld.C1 = C0, C1
	Weld.Parent = Part
	
	return Weld
	
end

function Utility.PlayAnimation(Anim : Animation)
	
	Anim:Play()
	
	Anim.Stopped:Wait()
	
end

return Utility
