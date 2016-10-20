--Dark Android Disposal
function c99200168.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99200168.condition)
	e1:SetCost(c99200168.cost)
	e1:SetTarget(c99200168.target)
	e1:SetOperation(c99200168.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99200168,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,99200168)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c99200168.descost)
	e2:SetTarget(c99200168.destg)
	e2:SetOperation(c99200168.desop)
	c:RegisterEffect(e2)
end
function c99200168.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99200168.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3790) and c:IsDiscardable()
end
function c99200168.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99200168.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c99200168.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c99200168.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c99200168.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c99200168.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99200168.desfilter(c)
	return c:IsDestructable()
end
function c99200168.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3790) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c99200168.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99200168.confilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c99200168.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c99200168.desfilter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99200168.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c99200168.confilter,tp,LOCATION_MZONE,0,e:GetHandler())
	local g=Duel.GetMatchingGroup(c99200168.desfilter,tp,0,LOCATION_SZONE,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
