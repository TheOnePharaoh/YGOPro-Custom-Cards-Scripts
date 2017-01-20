--Dark Side of the Glade
function c77777887.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77777887.target)
	e1:SetOperation(c77777887.activate)
	c:RegisterEffect(e1)
end
function c77777887.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_MONSTER) end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
  local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g2,g2:GetCount(),0,0)
end
function c77777887.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c77777887.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
  local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
  local count=0
	if g:GetCount()>0 then
		count = count + Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
  if g2:GetCount()>0 then
		count = count + Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
	end
  if count>0 and Duel.IsExistingMatchingCard(c77777887.filter2,tp,0,LOCATION_ONFIELD,1,nil) then
    local g2=Duel.GetMatchingGroup(c77777887.filter2,tp,0,LOCATION_ONFIELD,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			local sg=g2:Select(tp,1,1,nil)
			Duel.Destroy(sg,REASON_EFFECT)
    end
  end
end
