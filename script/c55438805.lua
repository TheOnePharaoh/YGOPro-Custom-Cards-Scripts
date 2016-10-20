--T.M. Conquer of the Light
function c55438805.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,55438799,55438795,55438796,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c55438805.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c55438805.spcon)
	e2:SetOperation(c55438805.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c55438805.atkup)
	c:RegisterEffect(e4)
	--banish
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438805,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c55438805.remcon)
	e5:SetTarget(c55438805.remtg)
	e5:SetOperation(c55438805.remop)
	c:RegisterEffect(e5)
	--special summon1
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(55438805,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,55438805)
	e6:SetTarget(c55438805.target1)
	e6:SetOperation(c55438805.operation1)
	c:RegisterEffect(e6)
	--special summon2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(55438805,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCountLimit(1,55438805)
	e7:SetCondition(c55438805.condition)
	e7:SetTarget(c55438805.target2)
	e7:SetOperation(c55438805.operation2)
	c:RegisterEffect(e7)
end
function c55438805.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c55438805.atkup(e,c)
	return Duel.GetMatchingGroupCount(c55438805.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
end
function c55438805.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c55438805.spfilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsAbleToRemoveAsCost() 
end
function c55438805.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c55438805.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,55438799)
		and Duel.IsExistingMatchingCard(c55438805.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,55438795)
		and Duel.IsExistingMatchingCard(c55438805.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,55438796)
end
function c55438805.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c55438805.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,55438799)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c55438805.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,55438795)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c55438805.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,55438796)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c55438805.remcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c55438805.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsAbleToRemove() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
end
function c55438805.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c55438805.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438805.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(11) and not c:IsCode(55438805) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438805.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438805.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438805.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438805.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438805.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438805.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438805.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438805.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end