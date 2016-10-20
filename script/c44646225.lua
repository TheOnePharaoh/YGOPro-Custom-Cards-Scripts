--Tasty Tuning
function c44646225.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44646225,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c44646225.recon)
	e2:SetTarget(c44646225.retg)
	e2:SetOperation(c44646225.reop)
	c:RegisterEffect(e2)
	--salvate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44646225,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c44646225.condition)
	e3:SetTarget(c44646225.target)
	e3:SetOperation(c44646225.operation)
	c:RegisterEffect(e3)
end
function c44646225.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c44646225.recon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_SYNCHRO and eg:GetFirst():IsControler(tp) and eg:IsExists(c44646225.filter,1,nil)
end
function c44646225.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,300)
end
function c44646225.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,300,REASON_EFFECT)
	Duel.Recover(1-tp,300,REASON_EFFECT)
end
function c44646225.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c44646225.filter2(c)
	return c:IsCode(44646214) and c:IsAbleToHand()
end
function c44646225.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44646225.filter2,tp,LOCATION_GRAVE,0,1,nil) end
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
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c44646225.operation(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown()then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44646225.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end