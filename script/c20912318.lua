--Sword Art Champion Grienhart
function c20912318.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd0a2),aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912318,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c20912318.condition)
	e1:SetTarget(c20912318.target)
	e1:SetOperation(c20912318.operation)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912318,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c20912318.excost)
	e2:SetOperation(c20912318.exop)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e3:SetCondition(c20912318.sumcon)
	c:RegisterEffect(e3)
end
function c20912318.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c20912318.filter(c,e,tp,ec)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd0a2) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c20912318.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c20912318.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c20912318.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c20912318.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
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
function c20912318.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c20912318.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2)
end
function c20912318.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	if ct>3 then ct=3 end
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c20912318.desfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c20912318.desfilter,tp,LOCATION_SZONE,0,1,ct,nil)
	Duel.Destroy(g,REASON_COST+REASON_EFFECT)
	e:SetLabel(g:GetCount())
end
function c20912318.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local ct=e:GetLabel()
	if g:GetCount()<ct then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,ct,ct,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c20912318.sumcon(e)
	return e:GetHandler():GetEquipCount()>0
end