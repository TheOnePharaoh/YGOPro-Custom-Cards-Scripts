--Toon Galaco
function c57888892.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c57888892.pencon)
	e2:SetCost(c57888892.pencost)
	e2:SetTarget(c57888892.pentg)
	e2:SetOperation(c57888892.penop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c57888892.splimit2)
	e3:SetCondition(c57888892.splimcon)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(57888892,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c57888892.atktg)
	e4:SetOperation(c57888892.atkop)
	c:RegisterEffect(e4)
	--to defense
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(c57888892.poscon)
	e5:SetOperation(c57888892.posop)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c57888892.thcon)
	e6:SetTarget(c57888892.thtg)
	e6:SetOperation(c57888892.thop)
	c:RegisterEffect(e6)
	--direct attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	e7:SetCondition(c57888892.dircon)
	c:RegisterEffect(e7)
	--spsummon condition
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(c57888892.splimit1)
	c:RegisterEffect(e8)
	--cannot attack
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	e9:SetOperation(c57888892.atklimit)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e11)
	--summon limit
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e12:SetCondition(c57888892.sumcon)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e13)
end
function c57888892.sumcon(e,c)
	if not c then return true end
	return false
end
function c57888892.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c57888892.penfilter4(c)
    return c:IsType(TYPE_PENDULUM)
end
function c57888892.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c57888892.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c57888892.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c57888892.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c57888892.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c57888892.splimit2(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x62) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c57888892.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c57888892.atkfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888892.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c57888892.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c57888892.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
end
function c57888892.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c57888892.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c57888892.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c57888892.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsType(TYPE_TOON) and Duel.GetAttackTarget()==nil
end
function c57888892.thafilter(c)
	return c:IsSetCard(0x62) and c:IsAbleToHand()
end
function c57888892.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57888892.thafilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c57888892.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c57888892.thafilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c57888892.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888892.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888892.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c57888892.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c57888892.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c57888892.splimit1(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_HAND) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c57888892.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end