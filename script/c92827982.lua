--Vocaloid Avanna
function c92827982.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92827982,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c92827982.condition)
	e1:SetCost(c92827982.cost)
	e1:SetTarget(c92827982.target)
	e1:SetOperation(c92827982.operation)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
end
function c92827982.filter(c,ec,tp)
	return c~=ec and c:IsSetCard(0x0dac405) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
		and c:IsReason(REASON_BATTLE)
end
function c92827982.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c92827982.filter,1,nil,e:GetHandler(),tp)
end
function c92827982.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c92827982.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c92827982.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
