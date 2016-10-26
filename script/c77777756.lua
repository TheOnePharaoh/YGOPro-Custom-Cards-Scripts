--Surprise Present
function c77777756.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)	
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777756)
	e1:SetTarget(c77777756.target)
	e1:SetOperation(c77777756.activate)
	c:RegisterEffect(e1)		
end

function c77777756.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c77777756.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	Duel.BreakEffect()
	tc:CancelToGrave()
	Duel.SendtoDeck(tc,1-tp,0,REASON_EFFECT)
end