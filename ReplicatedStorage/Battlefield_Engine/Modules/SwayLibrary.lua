local Sway = {}

--- Creates a new spring
-- @param initial A number or Vector3 (anything with * number and addition/subtraction defined)
function Sway.New(Init)
	
	local Target = Init or 0

	return setmetatable({
		_Time = tick(),
		_Position = Target,
		_Velocity = 0 * Target,
		_Target = Target,
		_Damper = 1,
		_Speed = 1,
	}, Sway)
	
end

function Sway:Impulse(Vel)
	self.Velocity = self.Velocity + Vel
end

function Sway:__index(Index)
	
	if Sway[Index] then
		return Sway[Index]
	elseif Index == 'Position' then
		local Position, _ = self:_positionVelocity( tick() ); return Position
	elseif Index == 'Velocity' then
		local _, Velocity = self:_positionVelocity( tick() ); return Velocity
	elseif Index == 'Target' then
		return self._Target
	elseif Index == 'Damper' then
		return self._Damper
	elseif Index == 'Speed' then
		return self._Speed
	else
		error( ('%q Is not a valid member of Sway'):format( tostring(Index) ), 2)
	end
	
end

function Sway:__newindex(Index, Val)
	
	local Tick = tick()

	if Index == 'Value' or Index == 'Position' or Index == 'p' then
		local _, Velocity = self:_positionVelocity(Tick)
		self._Position = Val
		self._Velocity = Velocity
	elseif Index == 'Velocity' or Index == 'v' then
		local Position, _ = self:_positionVelocity(Tick)
		self._Position = Position
		self._Velocity = Val
	elseif Index == 'Target' or Index == 't' then
		local Position, Velocity = self:_positionVelocity(Tick)
		self._Position = Position
		self._Velocity = Velocity
		self._Target = Val
	elseif Index == 'Damper' then
		local Position, Velocity = self:_positionVelocity(Tick)
		self._Position = Position
		self._Velocity = Velocity
		self._Damper = math.clamp(Val, 0, 1)
	elseif Index == 'Speed' then
		local Position, Velocity = self:_positionVelocity(Tick)
		self._Position = Position
		self._Velocity = Velocity
		self._Speed = Val < 0 and 0 or Val
	else
		error( ('%q Is not a valid member of Sway'):format( tostring(Index) ), 2)
	end

	self._Time = Tick
	
end

function Sway:_positionVelocity(Now)
	
	local Position = self._Position
	local Velocity = self._Velocity
	local Target = self._Target
	local Damper = self._Damper
	local Speed = self._Speed

	local Time = Speed * (Now - self._Time)
	local Damper2 = Damper^2

	local Sqrt, Cos, Sin
		
	if Damper2 < 1 then
		
		Sqrt = math.sqrt(1 - Damper2)
		local Exp = math.exp(-Damper*Time)/Sqrt
		Cos, Sin = Exp * math.cos(Sqrt * Time), Exp * math.sin(Sqrt * Time)
		
	elseif Damper2 == 1 then
		
		Sqrt = 1
		local Exp = math.exp(-Damper * Time) / Sqrt
		Cos, Sin = Exp, Exp * Time
		
	else
		
		Sqrt = math.sqrt(Damper2 - 1)
		local U, V = math.exp( (-Damper + Sqrt) * Time ) / (2 * Sqrt), math.exp( (-Damper - Sqrt) * Time ) / (2 * Sqrt)
		Cos, Sin = U + V, U - V
		
	end

	local A0 = Sqrt * Cos + Damper * Sin
	local A1 = 1 - (Sqrt * Cos + Damper * Sin)
	local A2 = Sin / Speed

	local B0 = -Speed * Sin
	local B1 = Speed * Sin
	local B2 = Sqrt*Cos - Damper * Sin

	return
		A0*Position + A1*Target + A2*Velocity,
		B0*Position + B1*Target + B2*Velocity
end

return Sway
