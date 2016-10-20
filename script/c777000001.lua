--Ｓｐ天よりの宝札
function c777000001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c777000001.cost)
	e1:SetTarget(c777000001.target)
	e1:SetOperation(c777000001.operation)
	c:RegisterEffect(e1)
end
function c777000001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc:IsCanRemoveCounter(tp,0x91,5,REASON_COST) end	 
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	tc:RemoveCounter(tp,0x91,5,REASON_COST)	
end
function c777000001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct1) and Duel.IsPlayerCanDraw(1-tp) 
		and (ct1<6 or ct2<6) end
	if ct1<6 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,6-ct1)
	end
	if ct2<6 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,6-ct2)
	end
end
function c777000001.operation(e,tp,eg,ep,ev,re,r,rp)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht<6 then 
		Duel.Draw(tp,6-ht,REASON_EFFECT)
	end
	ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ht<6 then 
		Duel.Draw(1-tp,6-ht,REASON_EFFECT)
	end
end
