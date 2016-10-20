--Pursuers
--lua script by SGJin
function c12310708.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c12310708.cost)
	e1:SetTarget(c12310708.target)
	e1:SetOperation(c12310708.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(c12310708.cost)
	e2:SetTarget(c12310708.target2)
	e2:SetOperation(c12310708.activate2)
	c:RegisterEffect(e2)
end
function c12310708.cfilter(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsDiscardable()
end
function c12310708.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310708.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c12310708.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c12310708.filter(c,tp,ep)
	return c:IsFaceup() and c:IsAttackAbove(1000) and ep~=tp and c:IsAbleToRemove()
end
function c12310708.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c12310708.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetLevel()*200)
end
function c12310708.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackAbove(1000) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
	end
end
function c12310708.filter2(c,tp)
	return c:IsFaceup() and c:IsAttackAbove(1000) and c:GetSummonPlayer()~=tp
		and c:IsAbleToRemove()
end
function c12310708.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12310708.filter2,1,nil,tp) end
	local g=eg:Filter(c12310708.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c12310708.filter3(c,e,tp)
	return c:IsFaceup() and c:IsAttackAbove(1000) and c:GetSummonPlayer()~=tp
		and c:IsRelateToEffect(e) and c:IsAbleToRemove()
end
function c12310708.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c12310708.filter3,nil,e,tp)
	local sum=0
	local tc=g:GetFirst()
	while tc do
		local lv=tc:GetLevel()
		sum=sum+lv
		tc=g:GetNext()
	end
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	Duel.Damage(1-tp,sum*200,REASON_EFFECT)
end
