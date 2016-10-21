--Strong Lizardfolk - Tribe Berserker
function c20162006.initial_effect(c)
	c:SetUniqueOnField(1,0,20162006)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xab90),aux.NonTuner(Card.IsRace,RACE_REPTILE),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20162006,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c20162006.cost)
	e2:SetTarget(c20162006.target)
	e2:SetOperation(c20162006.operation)
	c:RegisterEffect(e2)
end
function c20162006.costfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c20162006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20162006.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local rt=Duel.GetTargetCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if rt>10 then rt=10 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,c20162006.costfilter,tp,LOCATION_ONFIELD,0,1,rt,e:GetHandler())
	Duel.SendtoDeck(cg,nil,1,REASON_EFFECT+REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c20162006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local eg=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_HAND,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,ct,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c20162006.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.SendtoDeck(rg,nil,1,REASON_EFFECT)
	end
end