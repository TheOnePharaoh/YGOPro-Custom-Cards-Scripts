--Unholy Strength
function c77628944.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,77628944+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c77628944.condition)
	e1:SetTarget(c77628944.target)
	e1:SetOperation(c77628944.activate)
	c:RegisterEffect(e1)
end
function c77628944.grafilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER)
end
function c77628944.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77628944.grafilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c77628944.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c77628944.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77628944.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77628944.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77628944.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77628944.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(77628944,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(77628944,0))
		e2:SetCategory(CATEGORY_TOGRAVE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetLabelObject(tc)
		e2:SetCondition(c77628944.shcon)
		e2:SetTarget(c77628944.shtg)
		e2:SetOperation(c77628944.shop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c77628944.shcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(77628944)~=0
end
function c77628944.shfilter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c77628944.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628944.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c77628944.shop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77628944.shfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end