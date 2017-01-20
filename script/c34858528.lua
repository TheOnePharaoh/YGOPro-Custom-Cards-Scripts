--Gentle Guardian Goddess
function c34858528.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,34858502),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c34858528.target)
	e2:SetOperation(c34858528.operation)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c34858528.desreptg)
	e3:SetOperation(c34858528.desrepop)
	c:RegisterEffect(e3)
end
function c34858528.rfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c34858528.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
	and Duel.IsExistingMatchingCard(c34858528.rfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local g=Duel.SelectMatchingCard(tp,c34858528.rfilter,tp,LOCATION_MZONE,0,1,1,c)
	e:SetLabelObject(g:GetFirst())
	Duel.HintSelection(g)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
	return true
end
function c34858528.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c34858528.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) or c:IsCode(34858512) or c:IsCode(34858525) or c:IsCode(34858526) or c:IsCode(34858527) or c:IsCode(34858528) or c:IsCode(34858529)
end
function c34858528.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) end
	local rec=Duel.GetMatchingGroupCount(c34858528.filter,tp,LOCATION_ONFIELD,0,nil)*500
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	if rec>0 then Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec) end
end
function c34858528.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local rec=Duel.GetMatchingGroupCount(c34858528.filter,tp,LOCATION_ONFIELD,0,nil)*1000
	Duel.Recover(p,rec,REASON_EFFECT)
end