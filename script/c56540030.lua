function c56540030.initial_effect(c)
--spsummon
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(56540030,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(EVENT_ATTACK_ANNOUNCE)
e1:SetRange(LOCATION_HAND)
e1:SetCost(c56540030.cost)
e1:SetCondition(c56540030.spcon)
e1:SetTarget(c56540030.sptg)
e1:SetOperation(c56540030.spop)
c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c56540030.efcon)
	e2:SetOperation(c56540030.efop)
	c:RegisterEffect(e2)
end
function c56540030.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c56540030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c56540030.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c56540030.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,POS_FACEUP,1,REASON_COST)
end
function c56540030.spcon(e,tp,eg,ep,ev,re,r,rp)
local at=Duel.GetAttacker()
return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c56540030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c56540030.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if c and Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP) then
Duel.Remove(Duel.GetAttacker(),POS_FACEUP,REASON_EFFECT)
end
end
function c56540030.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c56540030.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(56540030,0))
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c56540030.efilter)
			rc:RegisterEffect(e1)
end
function c56540030.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end