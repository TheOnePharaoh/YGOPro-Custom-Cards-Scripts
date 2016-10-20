--Emergency Backup
function c22769923.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c22769923.condition)
	e1:SetTarget(c22769923.target)
	e1:SetOperation(c22769923.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(22769923,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,22769923)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c22769923.tdcost)
	e2:SetTarget(c22769923.tdtg)
	e2:SetOperation(c22769923.tdop)
	c:RegisterEffect(e2)
end
function c22769923.cfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
end
function c22769923.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22769923.cfilter,1,nil,tp)
end
function c22769923.filter(c,e,tp)
	return c:IsSetCard(0xaa12) and c:GetLevel()==10 and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22769923.xyzfilter(c,mg)
	if c.xyz_count~=2 then return false end
	return c:IsXyzSummonable(mg)
end
function c22769923.mfilter1(c,exg)
	return exg:IsExists(c22769923.mfilter2,1,nil,c)
end
function c22769923.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c22769923.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c22769923.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and mg:GetCount()>1
		and Duel.IsExistingMatchingCard(c22769923.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c22769923.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c22769923.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	local exg2=exg:Filter(c22769923.mfilter2,nil,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c22769923.mfilter1,1,1,tc1,exg2)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c22769923.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22769923.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c22769923.filter2,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c22769923.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c22769923.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22769923.tdfilter(c)
	return c:IsSetCard(0xaa12) or c:IsSetCard(0xaa13) or c:IsSetCard(0xaa14) and c:IsAbleToDeck()
end
function c22769923.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE)
end
function c22769923.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22769923.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22769923.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c22769923.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c22769923.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c22769923.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local g=Duel.GetMatchingGroup(c22769923.atkfilter,tp,LOCATION_MZONE,0,nil)
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end