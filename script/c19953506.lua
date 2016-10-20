--Combined Power
function c19953506.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c19953506.condition)
	e1:SetTarget(c19953506.target)
	e1:SetOperation(c19953506.operation)
	c:RegisterEffect(e1)
	--atk change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19953506,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c19953506.spcon)
	e2:SetTarget(c19953506.sptg)
	e2:SetOperation(c19953506.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26842483,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c19953506.discon)
	e3:SetTarget(c19953506.distg)
	e3:SetOperation(c19953506.disop)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c19953506.mtop)
	c:RegisterEffect(e4)
end
function c19953506.cfilter1(c,tpe)
	return c:IsFaceup() and c:IsType(tpe)
end
function c19953506.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19953506.cfilter1,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(c19953506.cfilter1,tp,LOCATION_MZONE,0,1,nil,TYPE_XYZ)
end
function c19953506.filter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c19953506.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19953506.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19953506.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c19953506.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c19953506.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c19953506.cfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c19953506.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c19953506.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19953506.tgfilter,1,nil,nil,1-tp) and Duel.IsExistingMatchingCard(c19953506.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c19953506.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c19953506.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c19953506.tgfilter,nil,e,1-tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c19953506.discon(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c19953506.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c19953506.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c19953506.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>500 and Duel.SelectYesNo(tp,aux.Stringid(19953506,0)) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
