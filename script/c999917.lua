--Eternal Dragon's Offering
function c999917.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1045))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1045))
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetTarget(c999917.distarget)
	c:RegisterEffect(e4)
	--disable effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c999917.disop)
	c:RegisterEffect(e5)
	--disable trap monster
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c999917.distarget)
	c:RegisterEffect(e6)
	--maintain
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetOperation(c999917.mtop)
	c:RegisterEffect(e7)
	local e8=e2:Clone()
	e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e8)
end
function c999917.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_TRAP) and c:IsStatus(STATUS_ACTIVATED)
end
function c999917.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) and re:GetHandler()~=e:GetHandler() then
		Duel.NegateEffect(ev)
	end
end
function c999917.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>800 and Duel.SelectYesNo(tp,aux.Stringid(999917,0)) then
		Duel.PayLPCost(tp,800)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
