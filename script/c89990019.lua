--Nexomystis
function c89990019.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,89990031,89990007,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--shuffle grave to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,89990019+EFFECT_COUNT_CODE_DUEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c89990019.cost)
	e2:SetTarget(c89990019.target)
	e2:SetOperation(c89990019.operation)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40854197,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c89990019.retcon)
	e3:SetTarget(c89990019.rettg)
	e3:SetOperation(c89990019.retop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
end
function c89990019.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c89990019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c89990019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c89990019.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c89990019.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c89990019.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c89990019.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c89990019.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c89990019.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c89990019.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToDeck() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
