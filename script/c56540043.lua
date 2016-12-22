function c56540043.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c56540043.target)
	e1:SetOperation(c56540043.operation)
	c:RegisterEffect(e1)
end
function c56540043.filter1(c,e,tp)
	local lv1=c:GetLevel()
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	 and Duel.IsExistingMatchingCard(c56540043.filter2,c:GetControler(),LOCATION_GRAVE,0,1,nil,lv1)
end
function c56540043.filter2(c,lv1)
	local lv2=c:GetLevel()
	return c:IsAbleToDeck() and c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) 
	 and Duel.IsExistingMatchingCard(c56540043.filter3,c:GetControler(),LOCATION_GRAVE,0,1,c,lv1-lv2)
end
function c56540043.filter3(c,lv)
	return c:IsAbleToDeck() and c:GetLevel()==lv and not c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER)
end
function c56540043.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c56540043.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c56540043.filter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c56540043.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c56540043.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tg1=g1:GetFirst() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c56540043.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tg1:GetLevel())   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SelectMatchingCard(tp,c56540043.filter3,tp,LOCATION_GRAVE,0,1,1,nil,tg1:GetLevel()-g2:GetFirst():GetLevel())
	g2:Merge(g3)
	Duel.SendtoDeck(g2,POS_FACEUP,2,REASON_EFFECT)
	if tg1 and Duel.SpecialSummonStep(tg1,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
	end
end