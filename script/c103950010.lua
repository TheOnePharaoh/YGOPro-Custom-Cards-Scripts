--Dragon of Darkness
function c103950010.initial_effect(c)

	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950010,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(c103950010.desreptg)
	e1:SetOperation(c103950010.desrepop)
	c:RegisterEffect(e1)
	
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950010,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c103950010.atkcon)
	e2:SetOperation(c103950010.atkop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end

--Filter for destruction replace
function c103950010.spfilter1(c)
	return not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
--Destruction replace target
function c103950010.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res = Duel.IsExistingMatchingCard(c103950010.spfilter1,tp,LOCATION_ONFIELD,0,1,c) 
		return not c:IsReason(REASON_REPLACE) and res and c:IsOnField() and c:IsFaceup()
	end
	if Duel.SelectYesNo(tp,aux.Stringid(103950010,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c103950010.spfilter1,tp,LOCATION_ONFIELD,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
--Destruction replace operation
function c103950010.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
	if e:GetHandler():GetFlagEffect(103950010) == 0 then
		e:GetHandler():RegisterFlagEffect(103950010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

--ATK gain condition condition
function c103950010.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(103950010)~=0
end
--ATK gain operation
function c103950010.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end