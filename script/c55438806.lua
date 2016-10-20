--T.M. Twin Light Dragon
function c55438806.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c55438806.ffilter,3,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c55438806.atkup)
	c:RegisterEffect(e3)
	--atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55438806,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c55438806.atkcost)
	e1:SetOperation(c55438806.atkop)
	c:RegisterEffect(e1)
	--Negate summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e5:SetDescription(aux.Stringid(55438806,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SUMMON)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c55438806.discon)
	e5:SetTarget(c55438806.distg)
	e5:SetOperation(c55438806.disop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(55438806,2))
	e6:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetDescription(aux.Stringid(55438806,3))
	e7:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e7)
	--special summon1
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(55438806,4))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_REMOVE)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1,55438806)
	e8:SetTarget(c55438806.target1)
	e8:SetOperation(c55438806.operation1)
	c:RegisterEffect(e8)
	--special summon2
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(55438806,5))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetCountLimit(1,55438806)
	e9:SetCondition(c55438806.condition)
	e9:SetTarget(c55438806.target2)
	e9:SetOperation(c55438806.operation2)
	c:RegisterEffect(e9)
end
function c55438806.ffilter(c)
	return c:IsSetCard(0xd70) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c55438806.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c55438806.atkup(e,c)
	return Duel.GetMatchingGroupCount(c55438806.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
end
function c55438806.csfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:GetBaseAttack()>0 and c:IsAbleToRemoveAsCost()
end
function c55438806.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438806.csfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c55438806.csfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetBaseAttack())
end
function c55438806.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c55438806.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c55438806.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c55438806.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function c55438806.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438806.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(11) and not c:IsCode(55438806) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438806.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438806.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438806.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438806.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438806.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438806.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438806.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438806.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end