--The Great Knight Kryos
function c8722160.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),4,2)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c8722160.indes)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8722160,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c8722160.target)
	e2:SetOperation(c8722160.operation)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8722160,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c8722160.negcon)
	e3:SetCost(c8722160.negcost)
	e3:SetTarget(c8722160.negtg)
	e3:SetOperation(c8722160.negop)
	c:RegisterEffect(e3)
end
function c8722160.indes(e,c)
	return not c:IsRace(RACE_DRAGON)
end
function c8722160.efilter(c)
	return c:IsSetCard(0xb1b32) and c:IsType(TYPE_MONSTER)
end
function c8722160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8722160.efilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c8722160.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c8722160.efilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.Overlay(c,g)
	end
end
function c8722160.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c8722160.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c8722160.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c8722160.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(8722160,RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,0,0)
end