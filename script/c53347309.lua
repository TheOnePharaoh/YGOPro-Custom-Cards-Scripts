--Lightray White Dragon
--lua script by SGJin
function c53347309.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c53347309.spcondition)
	c:RegisterEffect(e1)
	--Self Protection
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53347309,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)--Once per turn
	e2:SetCondition(c53347309.effcondition)
	e2:SetCost(c53347309.effcost)
	e2:SetTarget(c53347309.efftarget)
	e2:SetOperation(c53347309.effoperation)
	c:RegisterEffect(e2)
end
--5 Different Light monsters Removed from play reqired to Sp.Summon 
	function c53347309.spcondition(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(Card.IsAttribute,c:GetControler(),LOCATION_REMOVED,0,nil,ATTRIBUTE_LIGHT)
	local ct=g:GetClassCount(Card.IsCode)-- count different cards
	return ct>4 --5 different cards required
end
--Targed by card effect Condition
function c53347309.effcondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg:IsContains(c) and Duel.IsChainNegatable(ev)
end
--Light Monster for effect Cost 
function c53347309.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
end
--Remove cost from play
function c53347309.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53347309.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c53347309.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--Protection Effect Negate
function c53347309.efftarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
--Protection Effect Destroy
function c53347309.effoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end