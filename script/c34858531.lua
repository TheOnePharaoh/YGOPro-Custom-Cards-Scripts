--J'Arc
function c34858531.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
   
	--Prevent Battle Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c34858531.tg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c34858531.thcon)
	e3:SetCost(c34858531.thcos)
	e3:SetTarget(c34858531.thtg)
	e3:SetOperation(c34858531.thop)
	c:RegisterEffect(e3)
	--Fairy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_RACE)
	e4:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE)
	e4:SetValue(RACE_FAIRY)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c34858531.spcon)
	e5:SetOperation(c34858531.spop)
	e5:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e6)
	--diaable
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c34858531.condition)
	e7:SetTarget(c34858531.target)
	e7:SetOperation(c34858531.operation)
	c:RegisterEffect(e7)
end
function c34858531.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsType(TYPE_PENDULUM)
end
function c34858531.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return (c:GetSequence()==6 or c:GetSequence()==7)
	and Duel.GetTurnPlayer()==tp
	and Duel.GetFlagEffect(tp,34858531)==0
end
function c34858531.thcos(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,34858531)==0 end
	Duel.RegisterFlagEffect(tp,34858531,RESET_PHASE+PHASE_END,0,1)
end 
function c34858531.thfilter(c)
	return c:IsAbleToHand() and (c:IsType(TYPE_PENDULUM) and not c:IsCode(34858531))
end
function c34858531.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(c34858531.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(tp,CATEGORY_TOGRAVE,c,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(tp,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(tp,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end 
function c34858531.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c34858531.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
			local tg=g:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
		end
	end
end 
function c34858531.spfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsType(TYPE_PENDULUM)
end
function c34858531.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c34858531.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c34858531.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c34858531.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c34858531.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c34858531.filter(c)
	return c:IsFaceup() 
end
function c34858531.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c34858531.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c34858531.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c34858531.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c34858531.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end