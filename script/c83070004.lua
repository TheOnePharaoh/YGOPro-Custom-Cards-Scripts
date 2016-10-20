--Hydrush Lightning
function c83070004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83070004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c83070004.condition)
	e1:SetCost(c83070004.cost)
	e1:SetTarget(c83070004.target)
	e1:SetOperation(c83070004.activate)
	c:RegisterEffect(e1)
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83070005,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c83070004.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c83070004.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x837) and c:IsType(TYPE_SPELL)
end
function c83070004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c83070004.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c83070004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c83070004.filter(c,e,tp)
	return c:GetCode()==83070004 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c83070004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c83070004.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c83070004.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c83070004.cfilter,tp,LOCATION_SZONE,0,1,nil) then return end
	local sc=Duel.GetFirstMatchingCard(c83070004.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if sc~=nil then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(sc,8307,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			Duel.Destroy(sc,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
		Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,tp,0)
	end
end
function c83070004.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(1-tp)
	Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,1-tp,0)
end
