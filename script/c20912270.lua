--The Dragonic Sword Kriss Naga
function c20912270.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c20912270.cost)
	e1:SetTarget(c20912270.target)
	e1:SetOperation(c20912270.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c20912270.desop)
	c:RegisterEffect(e2)
	--Attach
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20912270,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,20912270)
	e3:SetCost(c20912270.atcost)
	e3:SetTarget(c20912270.attg)
	e3:SetOperation(c20912270.atop)
	c:RegisterEffect(e3)
end
function c20912270.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000)	end
end
function c20912270.filter(c,e,tp)
	return bit.band(c:GetRace(),RACE_WARRIOR)==RACE_WARRIOR and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912270.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13705773.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c20912270.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c20912270.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c20912270.eqlimit(e,c)
	return e:GetOwner()==c
end
function c20912270.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c20912270.eqlimit)
		c:RegisterEffect(e1)
	end
end
function c20912270.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	if c:IsReason(REASON_DESTROY) and tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c20912270.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c20912270.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c20912270.filter2(c)
	return c:IsType(TYPE_EQUIP)
end
function c20912270.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c20912270.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c20912270.filter2,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20912270,1))
	local g1=Duel.SelectTarget(tp,c20912270.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20912270,2))
	local g2=Duel.SelectTarget(tp,c20912270.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,2,0,0)
end
function c20912270.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end
