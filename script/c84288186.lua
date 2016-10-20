--PALLETE - Last Requiem
function c84288186.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c84288186.condition)
	e1:SetCost(c84288186.cost)
	e1:SetTarget(c84288186.target)
	e1:SetOperation(c84288186.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c84288186.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c84288186.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_MACHINE) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_MACHINE)
	Duel.Release(g,REASON_COST)
end
function c84288186.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c84288186.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
