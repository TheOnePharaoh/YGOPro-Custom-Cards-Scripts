--Bloody Rose Dance
function c59821034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59821034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c59821034.target)
	e1:SetOperation(c59821034.activate)
	c:RegisterEffect(e1)
end
function c59821034.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c59821034.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c59821034.cfilter,tp,LOCATION_MZONE,0,nil)
		e:SetLabel(ct)
		return Duel.IsExistingMatchingCard(c59821034.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,c)
	end
	local ct=e:GetLabel()
	local sg=Duel.GetMatchingGroup(c59821034.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,ct,0,0)
end
function c59821034.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c59821034.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c59821034.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
