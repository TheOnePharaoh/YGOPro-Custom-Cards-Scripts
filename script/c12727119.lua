--Sacred Nasca Lines
function c12727119.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c12727119.tg)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--Def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c12727119.tg)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x21))
	e4:SetValue(c12727119.efilter)
	c:RegisterEffect(e4)
	--Search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12727119,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PREDRAW)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c12727119.condition)
	e5:SetTarget(c12727119.target)
	e5:SetOperation(c12727119.operation)
	c:RegisterEffect(e5)
	--effect indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(1)
	e6:SetCondition(c12727119.edcon)
	c:RegisterEffect(e6)
end
function c12727119.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function c12727119.tg(e,c)
	return c:IsSetCard(0x21)
end
function c12727119.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c12727119.filter(c)
	return c:IsSetCard(0x21)  and c:IsAbleToHand()
end
function c12727119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12727119.filter,tp,LOCATION_DECK,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12727119.operation(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown()then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12727119.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12727119.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21)
end
function c12727119.edcon(e)
	return Duel.IsExistingMatchingCard(c12727119.cfilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end