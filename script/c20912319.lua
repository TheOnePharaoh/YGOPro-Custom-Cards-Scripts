--Sword Art Champion Samus the Noble
function c20912319.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd0a2),aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912319,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c20912319.condition)
	e1:SetTarget(c20912319.target)
	e1:SetOperation(c20912319.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1)
	e2:SetCondition(c20912319.gmcon)
	e2:SetTarget(c20912319.gmtg)
	e2:SetOperation(c20912319.gmop)
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c20912319.desreptg)
	e3:SetOperation(c20912319.desrepop)
	c:RegisterEffect(e3)
end
function c20912319.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c20912319.filter(c,e,tp,ec)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd0a2) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c20912319.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c20912319.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c20912319.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c20912319.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20912318,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		if ft>2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20912318,1)) then
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c20912319.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<g:GetCount() then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=g:GetNext()
	end
	Duel.EquipComplete()
end
function c20912319.gmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c20912319.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c20912319.gmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912319.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c20912319.gmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20912319.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c20912319.repfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c20912319.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c20912319.repfilter,1,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(20912319,2)) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:FilterSelect(tp,c20912319.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c20912319.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end