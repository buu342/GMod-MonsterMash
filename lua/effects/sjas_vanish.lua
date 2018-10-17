function EFFECT:Init(data)

	self.Position = data:GetOrigin()	

	local em = ParticleEmitter(self.Position)
	local smokeparticles = {
		Model("particle/particle_smokegrenade"),
		Model("particle/particle_noisesphere")
	};

      local r = 2
      for i=1, 20 do
         local prpos = VectorRand() * r
         prpos.z = prpos.z + 32
         local p = em:Add(table.Random(smokeparticles), self.Position + prpos)
         if p then
            local gray = math.random(75, 200)
            p:SetColor(gray, gray, gray)
            p:SetStartAlpha(255)
            p:SetEndAlpha(0)
            p:SetVelocity(VectorRand() * math.Rand(900, 1300))
            p:SetLifeTime(0)
            
            p:SetDieTime(math.Rand(1,2))

            p:SetStartSize(math.random(32, 64))
            p:SetEndSize(math.random(1, 40))
            p:SetRoll(math.random(-180, 180))
            p:SetRollDelta(math.Rand(-0.1, 0.1))
            p:SetAirResistance(600)

            p:SetCollide(true)
            p:SetBounce(0.4)

            p:SetLighting(false)
         end
      end

      em:Finish()
	
end


function EFFECT:Think()
	
end


function EFFECT:Render()

end