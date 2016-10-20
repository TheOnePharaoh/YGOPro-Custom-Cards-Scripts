--Evil HERO Land Breaker
function c888000015.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,37195861,75434695,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000015.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000015,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c888000015.condition)
	e2:SetOperation(c888000015.operation)
	c:RegisterEffect(e2)
end
c888000015.dark_calling=true
function c888000015.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c888000015.filter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x8)
end
function c888000015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=0
		local g=Duel.GetMatchingGroup(c888000015.filter,tp,LOCATION_MZONE,0,tc)
		local bc=g:GetFirst()
		while bc do
			atk=atk+bc:GetAttack()
			bc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
		local res=Duel.TossCoin(tp,1)
    	if res==1 then
        else
     	   local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_ATTACK)
			e2:SetProperty(EFFECT_FLAG_OATH)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetTarget(c888000015.ftarget)
			e2:SetLabel(c:GetFieldID())
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
    	end
	end
end
function c888000015.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
