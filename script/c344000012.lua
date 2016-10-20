--Panzer I
function c344000012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c344000012.spcon)
	e1:SetOperation(c344000012.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function c344000012.cfilter(c)
	return c:IsSetCard(0x444a) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c344000012.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c344000012.cfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c344000012.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g1=Duel.SelectMatchingCard(tp,c344000012.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g1,REASON_COST+REASON_DISCARD)
end
