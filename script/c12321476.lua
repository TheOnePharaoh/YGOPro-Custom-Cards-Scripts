--Vocaloid Kid Kagamine Rin
function c12321476.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12321476,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12321476.tdcon)
	e1:SetTarget(c12321476.tdtg)
	e1:SetOperation(c12321476.tdop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
	--be synchro material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c12321476.atkcon)
	e3:SetOperation(c12321476.atkop)
	c:RegisterEffect(e3)
end
function c12321476.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c12321476.filter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function c12321476.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c12321476.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c12321476.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c12321476.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12321476.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	end
end
function c12321476.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c12321476.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	rc:RegisterEffect(e2)
end
