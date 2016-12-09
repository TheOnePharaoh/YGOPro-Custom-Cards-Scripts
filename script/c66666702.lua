--Seafarer's Final Voyage
function c66666702.initial_effect(c)
	--from grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666702,0))
	e2:SetCountLimit(1,66666702)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c66666702.settg)
	e2:SetOperation(c66666702.setop)
	c:RegisterEffect(e2)
end

function c66666702.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSetCard(0x669)
end
function c66666702.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c66666702.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c66666702.setfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sfc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.SelectTarget(tp,c66666702.setfilter,tp,LOCATION_GRAVE,0,sfc,sfc,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,sfc,0,0)
end
function c66666702.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SSet(tp,tc)
	Duel.ConfirmCards(1-tp,tc)
end