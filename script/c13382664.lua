--Requiem of Destruction
function c13382664.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13382664.target)
	e1:SetOperation(c13382664.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13382664,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,13382664)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c13382664.sgcost)
	e2:SetTarget(c13382664.sgtg)
	e2:SetOperation(c13382664.sgop)
	c:RegisterEffect(e2)
end
function c13382664.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c13382664.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402)
end
function c13382664.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13382664.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c13382664.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c13382664.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13382664.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c13382664.cfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	local g=Duel.GetMatchingGroup(c13382664.filter,tp,0,LOCATION_MZONE,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c13382664.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13382664.enfilter(c)
	return c:IsSetCard(0x0dac405) and not c:IsCode(13382664) and c:IsAbleToGrave()
end
function c13382664.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c13382664.enfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c13382664.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13382664.enfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end