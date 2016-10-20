--Tempest of the Black Art
function c77628932.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),aux.NonTuner(Card.IsSetCard,0xba003),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77628932.splimit)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628932,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c77628932.damcon)
	e2:SetTarget(c77628932.damtg)
	e2:SetOperation(c77628932.damop)
	c:RegisterEffect(e2)
end
function c77628932.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c77628932.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c77628932.damfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
end
function c77628932.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77628932.damfilter,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*400)
	end
end
function c77628932.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77628932.damfilter,tp,0,LOCATION_GRAVE,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*400,REASON_EFFECT)
	end
end