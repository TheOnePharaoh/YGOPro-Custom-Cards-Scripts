--My True Self - Song of Self Confession
function c11111124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c11111124.cost)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c11111124.splimit)
	c:RegisterEffect(e2)
	--reveal
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e3)
	--leave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c11111124.leave)
	c:RegisterEffect(e4)
end
function c11111124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c11111124.splimit(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c11111124.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetPreviousControler()==tp and c:IsStatus(STATUS_ACTIVATED) then
		Duel.Damage(tp,2000,REASON_EFFECT)
	end
end