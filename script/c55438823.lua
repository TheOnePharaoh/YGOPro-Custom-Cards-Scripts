--Twilight Magus Angelic Priest El Vanna
function c55438823.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--atk & def down
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e2:SetCountLimit(1)
	e2:SetCondition(c55438823.atkcon)
	e2:SetCost(c55438823.atkcost)
	e2:SetTarget(c55438823.atktg)
	e2:SetOperation(c55438823.atkop)
	c:RegisterEffect(e2)
	--set atk&def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(c55438823.value)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SET_DEFENSE)
	e4:SetValue(c55438823.value)
	c:RegisterEffect(e4)
	--cannot be effect target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--special summon1
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(55438823,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,55438823)
	e6:SetTarget(c55438823.target1)
	e6:SetOperation(c55438823.operation1)
	c:RegisterEffect(e6)
	--special summon2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(55438823,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCountLimit(1,55438823)
	e7:SetCondition(c55438823.condition)
	e7:SetTarget(c55438823.target2)
	e7:SetOperation(c55438823.operation2)
	c:RegisterEffect(e7)
end
function c55438823.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c55438823.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
end
function c55438823.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438823.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c55438823.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c55438823.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c55438823.atkop(e,tp,eg,ep,ev,re,r,rp)
	local cc=e:GetLabelObject()
	local atk=cc:GetAttack()
	local def=cc:GetDefense()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-atk)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-def)
		tc:RegisterEffect(e2)
	end
end
function c55438823.value(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,0)*400
end
function c55438823.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438823.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(9) and not c:IsCode(55438823) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438823.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438823.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438823.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438823.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438823.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438823.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438823.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438823.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
