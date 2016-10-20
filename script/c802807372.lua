--Assault Mode Activate II
function c802807372.initial_effect(c)
--バスター・モードII
function c802807372.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c802807372.cost)
	e1:SetTarget(c802807372.target)
	e1:SetOperation(c802807372.activate)
	c:RegisterEffect(e1)
end
c802807372.list={[44508094]=61257789,[70902743]=77336644,[6021033]=1764972,[31924889]=14553285,[23693634]=38898779,[95526884]=37169670,[5717743]=86221218,[58431891]=86221220,[24696097]=7041324,[73580471]=92834757,[9012916]=92834758,[25862681]=92834759,[2403771]=24108326}
function c802807372.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c802807372.filter1(c,e,tp)
	local code=c:GetCode()
	local tcode=c802807372.list[code]
	return tcode and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c802807372.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tcode,e,tp)
end
function c802807372.filter2(c,tcode,e,tp)
	return c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c802807372.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c802807372.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c802807372.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c802807372.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local tcode=c802807372.list[code]
	local tc=Duel.SelectMatchingCard(tp,c802807372.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tcode,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK)>0 then
		tc:CompleteProcedure()
	end
end
end
