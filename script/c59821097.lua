--Aquarius Water
function c59821097.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821097,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e1:SetCountLimit(1,59821097)
	e1:SetCost(c59821097.cost1)
	e1:SetTarget(c59821097.target1)
	e1:SetOperation(c59821097.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821097,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e2:SetCountLimit(1,59821097)
	e2:SetCost(c59821097.cost2)
	e2:SetTarget(c59821097.target2)
	e2:SetOperation(c59821097.activate2)
	c:RegisterEffect(e2)
end
function c59821097.costfilter1(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c59821097.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821097.costfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c59821097.costfilter2,1,1,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c59821097.filter1(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c59821097.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c59821097.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821097.filter1,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c59821097.filter1,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c59821097.limit(g:GetFirst()))
end
function c59821097.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c59821097.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c59821097.costfilter2(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c59821097.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821097.costfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c59821097.costfilter1,1,1,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c59821097.filter2(c)
	return c:IsSetCard(0xa1a2) and c:IsXyzSummonable(nil)
end
function c59821097.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821097.filter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c59821097.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821097.filter2,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
