--Loli Yumiko
function c56540056.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c56540056.target)
	e1:SetOperation(c56540056.operation)
	c:RegisterEffect(e1)
end
function c56540056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c56540056.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND)
	Duel.SendtoDeck(g,POS_FACEUP,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.BreakEffect()
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
end