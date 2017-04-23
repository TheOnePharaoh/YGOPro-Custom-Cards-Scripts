--Vocaloid Kid Kanino Pan
function c11251892.initial_effect(c)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(2)
	e1:SetCondition(c11251892.condtion)
	e1:SetValue(c11251892.val)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
	--suicide
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11251892,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetTarget(c11251892.destg)
	e3:SetOperation(c11251892.desop)
	c:RegisterEffect(e3)
end
function c11251892.condtion(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and not bc:IsRace(RACE_MACHINE)
end
function c11251892.val(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c11251892.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local a=Duel.GetAttacker()
		if a==c then a=Duel.GetAttackTarget() end
		return a and a:IsRace(RACE_MACHINE)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c11251892.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToBattle() then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
