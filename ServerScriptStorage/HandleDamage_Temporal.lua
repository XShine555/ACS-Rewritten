local Event = game:GetService('ReplicatedStorage'):WaitForChild('Event')

Event.OnServerEvent:Connect(function(Player, DamagedPlayer, DamageToSend)
    
	DamagedPlayer:TakeDamage(DamageToSend)
    
end)
