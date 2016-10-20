--Mechquipped Angelic Drago
function c19007860.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c19007860.ovfilter,aux.Stringid(19007860,0),2,c19007860.xyzop)
	c:EnableReviveLimit()
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(c19007860.extratarget))
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19007860,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c19007860.condition)
	e2:SetCost(c19007860.cost)
	e2:SetTarget(c19007860.target)
	e2:SetOperation(c19007860.operation)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x1073)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19007860,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c19007860.spcon)
	e4:SetCost(c19007860.spcost)
	e4:SetTarget(c19007860.sptg)
	e4:SetOperation(c19007860.spop)
	c:RegisterEffect(e4)
end
function c19007860.ovfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_XYZ) and c:GetCode()~=19007860
end
function c19007860.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(19007860,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c19007860.extratarget(c)
	return c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790)
end
function c19007860.condition(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0xda3791) or d:IsSetCard(0xda3790) or d:IsCode(15914410) or d:IsCode(41309158)
end
function c19007860.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c19007860.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ta=Duel.GetAttacker()
	local td=Duel.GetAttackTarget()
	if chkc then return chkc==ta end
	if chk==0 then return ta:IsOnField() and ta:IsCanBeEffectTarget(e)
		and td:IsOnField() and td:IsCanBeEffectTarget(e) end
	local g=Group.FromCards(ta,td)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,td,1,0,0)
end
function c19007860.operation(e,tp,eg,ep,ev,re,r,rp)
	local ta=Duel.GetAttacker()
	local td=Duel.GetAttackTarget()
	if ta:IsRelateToEffect(e) and Duel.NegateAttack() and td:IsFaceup() and td:IsRelateToEffect(e) then
		Duel.ChangePosition(td,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
function c19007860.spcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c19007860.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c19007860.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c19007860.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c19007860.spfilter2(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19007860.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19007860.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c19007860.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c19007860.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c19007860.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
