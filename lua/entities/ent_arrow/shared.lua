ENT.Type = "anim"
ENT.PrintName		= "Arrow"
ENT.Author			= "Buu342"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()
end

/*---------------------------------------------------------
PhysicsUpdate
---------------------------------------------------------*/
function ENT:PhysicsUpdate()
end

/*---------------------------------------------------------
PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound("weapons/baseball_hitworld"..math.random(1,3)..".wav")
	end
end
