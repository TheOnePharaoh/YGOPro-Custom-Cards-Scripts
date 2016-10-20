--ZERO POINT, ANTI-MATTER ORIGIN
function c1143238.initial_effect(c)
	c:SetUniqueOnField(1,0,1143238)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1143238.target)
	e1:SetOperation(c1143238.activate)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1143238,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c1143238.thtg)
	e2:SetOperation(c1143238.thop)
	c:RegisterEffect(e2)
	--destroy and banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143238,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCondition(c1143238.descon)
	e3:SetTarget(c1143238.destg)
	e3:SetOperation(c1143238.desop)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143238,4))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c1143238.sumcon)
	e4:SetTarget(c1143238.sumtg)
	e4:SetOperation(c1143238.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
	if not c1143238.global_check then
		c1143238.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143238))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143238.thfilter(c)
	return c:IsSetCard(0xaf75) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1143238.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143238.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c1143238.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1143238.thfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1143238.remfilter(c)
	return c:IsSetCard(0xaf75) and not c:IsCode(1143238) and c:IsAbleToDeck()
end
function c1143238.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c1143238.remfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143238.remfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c1143238.remfilter,tp,LOCATION_ONFIELD,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c1143238.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=dg:Select(tp,1,ct,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	end
end
function c1143238.consfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75)
end
function c1143238.descon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ or eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) and eg:IsExists(c1143238.consfilter,1,nil)
end
function c1143238.desfilter(c)
	return c:IsFaceup()
end
function c1143238.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1143238.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143238.desfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_SZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1143238.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_SZONE+LOCATION_GRAVE)
end
function c1143238.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_SZONE,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(1143238,2),aux.Stringid(1143238,3))
		else
			op=2
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=nil
		if op==0 then
			g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_SZONE,1,1,nil)
		elseif op==1 then
			g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		else
			g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_SZONE+LOCATION_GRAVE,1,1,nil)
		end
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c1143238.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c1143238.sumfilter(c,e,tp)
	return c:IsSetCard(0xaf75) and c:IsLevelbelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c1143238.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143238.sumfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_REMOVED)
end
function c1143238.sumop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c1143238.sumfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 or (ft>1 and tg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end

