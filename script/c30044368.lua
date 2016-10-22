--Predator Plant Cardenal Trapper
function c30044368.initial_effect(c)
		--ind
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(c30044368.indval)
		c:RegisterEffect(e1)
		--counter
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetOperation(c30044368.ctop)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EVENT_FLIP)
		c:RegisterEffect(e3)
end
function c30044368.indval(e,c)
	return c:GetLevel()==1
end
function c30044368.ctop(e,tp,eg,ep,ev,re,r,rp)
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
				e1:SetCondition(c30044368.lvcon)
				e1:SetValue(1)
				tc:RegisterEffect(e1)
			end
		end
		tc=eg:GetNext()
	end
end
function c30044368.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end