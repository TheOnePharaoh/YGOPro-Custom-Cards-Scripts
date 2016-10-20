--Specialized Modification
function c44646214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCost(c44646214.cost)
	e1:SetTarget(c44646214.target)
	e1:SetOperation(c44646214.activate)
	c:RegisterEffect(e1)
end
c44646214.list={[67152331]=54759291,[88111148]=75963559,[7615134]=13739085,[49427055]=44646216,[89457697]=44646220,[13382661]=44646221,[29340156]=44646223,[89200699]=44646222,[34602088]=44646219,[44646215]=44646228}
function c44646214.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c44646214.filter1(c,e,tp)
	local code=c:GetCode()
	local tcode=c44646214.list[code]
	return tcode and c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(c44646214.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tcode,e,tp)
end
function c44646214.filter2(c,tcode,e,tp)
	return c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c44646214.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c44646214.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c44646214.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c44646214.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local tcode=c44646214.list[code]
	local tc=Duel.GetFirstMatchingCard(c44646214.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tcode,e,tp)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
		tc:CompleteProcedure()
	end
end
