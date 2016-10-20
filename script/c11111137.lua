--Vocaloid Hoshine Stella
function c11111137.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111137,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c11111137.ntcon)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111137,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c11111137.sptg)
	e2:SetOperation(c11111137.spop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
end
function c11111137.nmfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:GetLevel()==3
end
function c11111137.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11111137.nmfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c11111137.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x0dac405) and not c:IsCode(11111137) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11111137.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11111137.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c11111137.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11111137.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11111137.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		end
	end
end