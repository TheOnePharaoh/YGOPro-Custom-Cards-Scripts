--Divine Reborn
function c11478414.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11478414)
	e1:SetTarget(c11478414.target)
	e1:SetOperation(c11478414.activate)
	c:RegisterEffect(e1)
end
function c11478414.filter(c,e,tp,lp)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0xf2002) 
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return lp>c:GetLevel()*300
end
function c11478414.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lp=Duel.GetLP(tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c11478414.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,lp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c11478414.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lp=Duel.GetLP(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c11478414.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,lp)
	local tc=tg:GetFirst()
	if tc then
		Duel.PayLPCost(tp,tc:GetLevel()*300)
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
