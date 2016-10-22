--Predator Plant Hydra Crusher
function c21125830.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
		aux.AddFusionProcCodeFun(c,69105797,c21125830.ffilter,1,true,false)
		e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(c21125830.atkfilter)
		c:RegisterEffect(e1)
		--counter
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(c21125830.ctop)
		c:RegisterEffect(e2)
end

function c21125830.ffilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c21125830.atkfilter(e,c)
	return c:GetCounter(0x1041)>0
end
function c21125830.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsControler(1-tp) then
		tc:AddCounter(0x1041,1)
			if tc:GetLevel()>1 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetCondition(c21125830.lvcon)
				e1:SetValue(1)
				tc:RegisterEffect(e1)
			end
		end
		tc=eg:GetNext()
	end
end
function c21125830.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end