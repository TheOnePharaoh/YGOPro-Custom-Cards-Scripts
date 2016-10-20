--The Symbol of Purity and Holyness
function c59821115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c59821115.target)
	e1:SetOperation(c59821115.activate)
	c:RegisterEffect(e1)
end
function c59821115.filter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c59821115.filter2(c)
	return c:IsAbleToRemove()
end
function c59821115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821115.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c59821115.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c59821115.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821115.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local dg=Duel.GetMatchingGroup(c59821114.filter2,tp,0,LOCATION_ONFIELD,nil)
		if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821115,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
