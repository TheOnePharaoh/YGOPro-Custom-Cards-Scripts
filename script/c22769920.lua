--Sudden Attack
function c22769920.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c22769920.condition)
	e1:SetCost(c22769920.cost)
	e1:SetTarget(c22769920.target)
	e1:SetOperation(c22769920.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22769920,0))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,22769920)
	e4:SetCondition(aux.exccon)
	e4:SetCost(c22769920.drcost)
	e4:SetTarget(c22769920.drtg)
	e4:SetOperation(c22769920.drop)
	c:RegisterEffect(e4)
end
function c22769920.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c22769920.costfilter(c)
	return c:IsSetCard(0xaa12) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c22769920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(c22769920.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c22769920.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c22769920.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22769920.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c22769920.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22769920.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c22769920.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end