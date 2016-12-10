--Utopian Destiny
function c25667892.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c25667892.tg)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c25667892.destg)
	e3:SetValue(1)
	e3:SetOperation(c25667892.desop)
	c:RegisterEffect(e3)
end
function c25667892.tg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x7f)
end
function c25667892.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c25667892.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if eg:GetCount()~=1 then return false end
		local tc=eg:GetFirst()
		return tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:IsSetCard(0x7f) and tc:IsReason(REASON_BATTLE+REASON_EFFECT)
			and Duel.IsExistingMatchingCard(c25667892.rfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	return Duel.SelectYesNo(tp,aux.Stringid(25667892,0))
end
function c25667892.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c25667892.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end