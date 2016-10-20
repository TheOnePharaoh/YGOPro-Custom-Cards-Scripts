--T.M. Saint Pegasi
function c55438804.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,55438799,aux.FilterBoolFunction(Card.IsFusionSetCard,0xd70),2,true,true)
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
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c55438804.atkop)
	c:RegisterEffect(e4)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c55438804.atkup)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(55438804,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(c55438804.thcon)
	e5:SetTarget(c55438804.thtg)
	e5:SetOperation(c55438804.thop)
	c:RegisterEffect(e5)
	--special summon1
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(55438804,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,55438804)
	e6:SetTarget(c55438804.target1)
	e6:SetOperation(c55438804.operation1)
	c:RegisterEffect(e6)
	--special summon2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(55438804,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCountLimit(1,55438804)
	e7:SetCondition(c55438804.condition)
	e7:SetTarget(c55438804.target2)
	e7:SetOperation(c55438804.operation2)
	c:RegisterEffect(e7)
end
function c55438804.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c55438804.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c55438804.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c55438804.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c55438804.atkup(e,c)
	return Duel.GetMatchingGroupCount(c55438804.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
end
function c55438804.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION and ep~=tp
end
function c55438804.thfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c55438804.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438804.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c55438804.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55438804.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c55438804.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438804.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(11) and not c:IsCode(55438804) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438804.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438804.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438804.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438804.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438804.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438804.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438804.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438804.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end