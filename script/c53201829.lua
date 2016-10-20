--Scan and Kaboom!
function c53201829.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetCost(c53201829.cost)
	e1:SetTarget(c53201829.target)
	e1:SetOperation(c53201829.operation)
	c:RegisterEffect(e1)
end
function c53201829.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac405)
end
function c53201829.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c53201829.costfilter,2,nil) end
	local g=Duel.SelectReleaseGroup(tp,c53201829.costfilter,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c53201829.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  end
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c53201829.filter(c)
	return c:IsType(TYPE_TUNER)
end
function c53201829.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53201829.filter,tp,0,LOCATION_HAND,nil)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DESTROY)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
