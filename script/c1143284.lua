--ANTI-MATTER Dark Being, Dourghrr
function c1143284.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf75),4,2)
	c:EnableReviveLimit()
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1143284,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1143284.atttg)
	e1:SetOperation(c1143284.attop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1143284,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1143284.tgcost)
	e2:SetTarget(c1143284.tgtg)
	e2:SetOperation(c1143284.tgop)
	c:RegisterEffect(e2)
	--self xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143284,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,1143284)
	e3:SetCondition(c1143284.xyzcon)
	e3:SetTarget(c1143284.xyztg)
	e3:SetOperation(c1143284.xyzop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c1143284.atkval)
	c:RegisterEffect(e4)
	if not c1143284.global_check then
		c1143284.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143284))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143284.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c1143284.matfilter(c)
	return c:IsSetCard(0xaf75) and c:GetLevel()==4
end
function c1143284.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143284.matfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c1143284.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c1143284.matfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c1143284.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c1143284.tgfilter(c)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsSetCard(0xaf75)
	end
end
function c1143284.desfilter(c)
	return c1143284.tgfilter(c) and c:IsDestructable()
end
function c1143284.filter(c)
	return c:IsSetCard(0xaf75) and c:IsAbleToDeck()
end
function c1143284.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c1143284.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143284.desfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1143284.desfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143284.filter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c1143284.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c1143284.thfilter(c)
	return c:IsSetCard(0xaf75) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(6) and c:IsAbleToHand()
end
function c1143284.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c1143284.filter,tp,LOCATION_REMOVED,0,nil)
	local count=g:GetCount()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	Duel.SendtoDeck(g,nil,count,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	if Duel.Recover(tp,count*300,REASON_EFFECT)>0 and Duel.IsExistingTarget(c1143284.thfilter,tp,LOCATION_DECK,0,1,nil)then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local g2=Duel.SelectTarget(tp,c1143284.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
function c1143284.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1143284.xyzfilter1(c,e,tp)
	return c:IsCode(1143284) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c1143284.xyzfilter2(c)
	return c:IsSetCard(0xaf75) and c:GetLevel()==4
end
function c1143284.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143284.xyzfilter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c1143284.xyzfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c1143284.xyzfilter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c1143284.xyzfilter2,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c1143284.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end
