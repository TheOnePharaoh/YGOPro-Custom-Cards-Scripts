--Kuan Ti, Serenity God of the Sky Nirvana
function c44559830.initial_effect(c)
	c:SetUniqueOnField(1,0,44559830)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c44559830.tgvalue)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c44559830.descost)
	e4:SetTarget(c44559830.destg)
	e4:SetOperation(c44559830.desop)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c44559830.distg)
	c:RegisterEffect(e5)
end
function c44559830.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c44559830.costfilter(c)
	return c:IsSetCard(0x2016) or c:IsSetCard(0x2017) or c:IsCode(44559811) or c:IsCode(44559832) and c:IsAbleToDeckAsCost()
end
function c44559830.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559830.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c44559830.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c44559830.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c44559830.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c44559830.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA and not c:IsType(TYPE_FUSION)
end
