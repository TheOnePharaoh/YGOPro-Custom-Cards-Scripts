--Accel Support
function c13382668.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13382668)
	e1:SetCost(c13382668.cost)
	e1:SetTarget(c13382668.target)
	e1:SetOperation(c13382668.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(13382668,ACTIVITY_SPSUMMON,c13382668.counterfilter)
end
function c13382668.counterfilter(c)
	return c:IsType(TYPE_SYNCHRO) or c:GetSummonLocation()~=LOCATION_EXTRA
end
function c13382668.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(13382668,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13382668.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c13382668.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end
function c13382668.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13382669,0x55,0x4011,1200,0,3,RACE_MACHINE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c13382668.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,13382669,0x55,0x4011,1200,0,3,RACE_MACHINE,ATTRIBUTE_LIGHT) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,13382669)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e2:SetValue(c13382668.synlimit)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c13382668.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x0dac402)
end
