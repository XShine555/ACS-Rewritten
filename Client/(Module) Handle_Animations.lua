local AnimationHandler = {}

local MainModule = require( script.Parent:WaitForChild('Main_Module') )

AnimationHandler.AnyAnimation = false

function AnimationHandler.EquipAnim()
	
	pcall(function()
		MainModule.AnimData.EquipAnim({
			MainModule.RightArmWeld,
			MainModule.LeftArmWeld,
			MainModule.WeaponWeld,
			MainModule.WeaponInHand,
			MainModule.Viewmodel
		})
	end)
	
end


function AnimationHandler.IdleAnim()
	
	AnimationHandler.AnyAnimation = true
	
	pcall(function()
		MainModule.AnimData.IdleAnim({
			MainModule.RightArmWeld,
			MainModule.LeftArmWeld,
			MainModule.WeaponWeld,
			MainModule.WeaponInHand,
			MainModule.Viewmodel
		})
	end)
	
	AnimationHandler.AnyAnimation = false
	
end

function AnimationHandler.SprintAnim()
	
	pcall(function()
		MainModule.AnimData.SprintAnim({
			MainModule.RightArmWeld,
			MainModule.LeftArmWeld,
			MainModule.WeaponWeld,
			MainModule.WeaponInHand,
			MainModule.Viewmodel
		})
	end)
	
end

function AnimationHandler.ReloadAnim()
	
	pcall(function()
		MainModule.AnimData.ReloadAnim({
			MainModule.RightArmWeld,
			MainModule.LeftArmWeld,
			MainModule.WeaponWeld,
			MainModule.WeaponInHand,
			MainModule.Viewmodel
		})
	end)
	
end

function AnimationHandler.TacticalReloadAnim()
	
	pcall(function()
		MainModule.AnimData.TacticalReloadAnim({
			MainModule.RightArmWeld,
			MainModule.LeftArmWeld,
			MainModule.WeaponWeld,
			MainModule.WeaponInHand,
			MainModule.Viewmodel
		})
	end)
	
end

return AnimationHandler
