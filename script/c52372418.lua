--Vocaloid Kid Emergency Portal
function c52372418.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,52372418)
	e1:SetTarget(c52372418.target)
	e1:SetOperation(c52372418.activate)
	c:RegisterEffect(e1)
end
function c52372418.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsLevelBelow(3) and c:IsSetCard(0x0dac405) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52372418.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c52372418.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c52372418.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>3 then ct=3 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c52372418.filter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c52372418.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 or ft<sg:GetCount() then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
