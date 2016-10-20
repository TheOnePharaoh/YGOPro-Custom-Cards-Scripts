--Harmonic Ascend
function c99199032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99199032.condition)
	e1:SetTarget(c99199032.target)
	e1:SetOperation(c99199032.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(99199032,ACTIVITY_CHAIN,c99199032.chainfilter)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99199032,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(2,99199032)
	e2:SetCost(c99199032.descost)
	e2:SetTarget(c99199032.destg)
	e2:SetOperation(c99199032.desop)
	c:RegisterEffect(e2)
end
function c99199032.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc,seq=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return not (re:IsActiveType(TYPE_SPELL) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and loc==LOCATION_SZONE and (seq==6 or seq==7) and rc:IsSetCard(0xff15))
end
function c99199032.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(99199032,tp,ACTIVITY_CHAIN)==0
end
function c99199032.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xff15)
end
function c99199032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199032.cfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99199032.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99199032,0))
	local g=Duel.SelectMatchingCard(tp,c99199032.cfilter,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()<3 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(99199032,1))
	local sg=g:Select(1-tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	g:Sub(sg)
	Duel.SendtoExtraP(g,POS_FACEUP,REASON_EFFECT)
end
function c99199032.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c99199032.desfilter(c)
	return c:GetSequence()==6 or c:GetSequence()==7 and c:IsDestructable()
end
function c99199032.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c99199032.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c99199032.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c99199032.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99199032.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end