--Vocaloid Pendulum GIveaway
function c9234500.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_END_PHASE)
	e1:SetCountLimit(1,9234500)
	e1:SetCondition(c9234500.condition)
	e1:SetTarget(c9234500.target)
	e1:SetOperation(c9234500.activate)
	c:RegisterEffect(e1)
end
function c9234500.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c9234500.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9234500.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9234500.filter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c9234500.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c9234500.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9234500.filter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingTarget(c9234500.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c9234500.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c9234500.filter,tp,0,LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9234500.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
