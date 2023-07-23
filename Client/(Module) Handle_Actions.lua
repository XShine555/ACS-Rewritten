local HandleActions = {}

local MainModule = require( script.Parent:WaitForChild('Main_Module') )
local HandleWeapon = require( MainModule.HandleWeapon )
local HandleAnimations = require( MainModule.HandleAnimations )

function HandleActions.CheckSprintAnimation()
	
	if MainModule.ActionSprint then
		
		HandleAnimations.SprintAnim()
		
	else
		
		HandleAnimations.IdleAnim()
		
	end
	
end

function HandleActions.HandleAction(Name, State, Object)
	
	if Name == 'Fire' then
		
		if State == Enum.UserInputState.Begin then
			
			HandleWeapon.Shoot()
			
		elseif State == Enum.UserInputState.End then
			
			MainModule.ActionMouse1Down = false
			
		end
		
	end
	
	if Name == 'Reload' and State == Enum.UserInputState.Begin then
		
		HandleWeapon.Reload()
	
	end
	
	if Name == 'Aim' and State == Enum.UserInputState.Begin then
		
		MainModule.ActionAim = not MainModule.ActionAim
		
		HandleWeapon.Aim()
		
	end
	
	if Name == 'Sprint' and State == Enum.UserInputState.Begin and MainModule.ActionPlayerMove then
		
		MainModule.ActionSprint = true
		
		MainModule.TweenService:Create(MainModule.Humanoid, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {WalkSpeed = 24}):Play()
		
		if not (MainModule.ActionReload) then
			
			HandleAnimations.SprintAnim()
			
		end
		
	elseif Name == 'Sprint' and State == Enum.UserInputState.End then
		
		MainModule.ActionSprint = false
		
		MainModule.TweenService:Create(MainModule.Humanoid, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {WalkSpeed = 12}):Play()
		
		if not (MainModule.ActionReload) then
			
			HandleAnimations.IdleAnim()
			
		end
		
	end
	
	if Name == 'CycleFiremode' and State == Enum.UserInputState.Begin then
		
		HandleWeapon.CycleFiremode()
		
	end
	
	if Name == 'BarrelAct' and State == Enum.UserInputState.Begin then
		
		if MainModule.UnderAttHit or MainModule.BipodActive then
			
			MainModule.BipodActive = not MainModule.BipodActive
			
		end
		
	end
	
end

MainModule.ContextActionService:BindAction('Sprint', HandleActions.HandleAction, false, Enum.KeyCode.LeftShift)

return HandleActions
