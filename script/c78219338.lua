--Quick Maintenance
function c78219338.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78219338,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,78219338+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c78219338.activate)
	c:RegisterEffect(e1)
end
function c78219338.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c78219338.drcon1)
	e1:SetOperation(c78219338.drop1)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c78219338.regcon)
	e2:SetOperation(c78219338.regop)
	e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c78219338.drcon2)
	e3:SetOperation(c78219338.drop2)
	e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
end
function c78219338.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ad30)
end
function c78219338.cfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c78219338.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78219338.cfilter,1,nil,tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c78219338.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,78219338)
	Duel.Draw(tp,1,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c78219304.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()==0 then return end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x1115,1)
	end
end
function c78219338.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78219338.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,78219338)==0 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c78219338.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,78219338,RESET_CHAIN,0,1)
end
function c78219338.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,78219338)>0
end
function c78219338.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,78219338)
	Duel.Hint(HINT_CARD,0,78219338)
	Duel.Draw(tp,1,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c78219304.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()==0 then return end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x1115,1)
	end
end