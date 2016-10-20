--Never Ending Promises
function c59821130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,59821130+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c59821130.condition)
	e1:SetTarget(c59821130.target)
	e1:SetOperation(c59821130.activate)
	c:RegisterEffect(e1)
end
function c59821130.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_FUSION)
end
function c59821130.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_SYNCHRO)
end
function c59821130.cfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ)
end
function c59821130.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c59821130.cfilter1,tp,LOCATION_MZONE,0,1,nil)
	 and Duel.IsExistingMatchingCard(c59821130.cfilter2,tp,LOCATION_MZONE,0,1,nil)
	 and Duel.IsExistingMatchingCard(c59821130.cfilter3,tp,LOCATION_MZONE,0,1,nil)
end
function c59821130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND+LOCATION_ONFIELD,0)*500
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c59821130.costfilter(c)
	return c:IsSetCard(0xa1a2) and not c:IsCode(59821130) and c:IsAbleToGrave()
end
function c59821130.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)	
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	local dg=Duel.GetMatchingGroup(c59821130.costfilter,tp,LOCATION_DECK,0,nil)
	local dt=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	if dg:GetCount()>0 and dt:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_TOGRAVE)
		local des=dg:Select(tp,1,1,nil)
		Duel.SendtoGrave(des,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Destroy(dt,REASON_EFFECT)
	end
end
