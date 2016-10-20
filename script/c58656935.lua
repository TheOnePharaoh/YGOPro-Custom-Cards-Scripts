--Accel Vocaloid Chaos Harbinger
function c58656935.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(58656935,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c58656935.spcon)
	e4:SetCost(c58656935.spcost)
	e4:SetTarget(c58656935.sptg)
	e4:SetOperation(c58656935.spop)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(58656935,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c58656935.atkcon)
	e5:SetOperation(c58656935.atkop)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(58656935,2))
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c58656935.discon)
	e6:SetCost(c58656935.discost)
	e6:SetTarget(c58656935.distg)
	e6:SetOperation(c58656935.disop)
	c:RegisterEffect(e6)
end
function c58656935.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c58656935.spfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c58656935.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58656935.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c58656935.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c58656935.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c58656935.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function c58656935.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c58656935.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)*800
	if atk>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c58656935.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainDisablable(ev)
end
function c58656935.disfilter(c,tpe)
	return c:IsType(tpe) and c:IsDiscardable()
end
function c58656935.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c58656935.disfilter,tp,LOCATION_HAND,0,1,nil,rtype) end
	Duel.DiscardHand(tp,c58656935.disfilter,1,1,REASON_COST+REASON_DISCARD,nil,rtype)
end
function c58656935.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c58656935.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
end
