--Sword Art Champion Sakuragi
function c20912293.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912293,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c20912293.spcon)
	e2:SetCost(c20912293.spcost)
	e2:SetTarget(c20912293.sptg)
	e2:SetOperation(c20912293.spop)
	c:RegisterEffect(e2)
end
function c20912293.spcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsSetCard(0xd0a2)
end
function c20912293.costfilter(c)
	return c:IsSetCard(0xd0a2) and c:IsType(TYPE_EQUIP) or c:IsCode(20912295) and c:IsAbleToGraveAsCost()
end
function c20912293.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.IsExistingMatchingCard(c20912293.costfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.PayLPCost(tp,800)
	local sg=Duel.SelectMatchingCard(tp,c20912293.costfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c20912293.spefilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a2) and c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912293.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c20912293.spefilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c20912293.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20912293.spefilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	end
end