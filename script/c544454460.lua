--Malefic Rainbow Dragon
function c544454460.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454460.spcon)
	e1:SetOperation(c544454460.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c544454460.descon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c544454460.destarget)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetDescription(aux.Stringid(544454460,0))
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c544454460.atcon)
	e4:SetCost(c544454460.atcost)
	e4:SetOperation(c544454460.atop)
	c:RegisterEffect(e4)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetDescription(aux.Stringid(544454460,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c544454460.tdcon)
	e5:SetCost(c544454460.tdcost)
	e5:SetTarget(c544454460.tdtg)
	e5:SetOperation(c544454460.tdop)
	c:RegisterEffect(e5)
	--cannot trigger
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c544454460.spop1)
	c:RegisterEffect(e6)
end
function c544454460.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23)
end
function c544454460.spfilter(c)
	return c:IsCode(79856792) and c:IsAbleToRemoveAsCost()
end
function c544454460.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454460.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(c544454460.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c544454460.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c544454460.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function c544454460.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c544454460.destarget(e,c)
	return c:IsSetCard(0x23) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
function c544454460.spop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(544454460,RESET_EVENT+0xfc0000+RESET_PHASE+PHASE_END,0,1)
end
function c544454460.atcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(544454460)~=0 then return false end
	local phase=Duel.GetCurrentPhase()
	return phase~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c544454460.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x23) and c:IsAbleToGraveAsCost()
end
function c544454460.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c544454460.afilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(c544454460.afilter,tp,LOCATION_HAND,0,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c544454460.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c544454460.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(544454460)==0
end
function c544454460.cfilter(c)
	return c:IsSetCard(0x23) and c:IsAbleToRemoveAsCost()
end
function c544454460.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c544454460.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c544454460.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c544454460.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c544454460.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
