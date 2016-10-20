--Toon Lily
function c57888891.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetTarget(c57888891.cbtg)
	e1:SetOperation(c57888891.cbop)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c57888891.splimit2)
	e2:SetCondition(c57888891.splimcon)
	c:RegisterEffect(e2)
	--change battle target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(57888891,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetLabel(1)
	e3:SetCondition(c57888891.cbcon)
	e3:SetOperation(c57888891.cbop)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c57888891.dircon)
	c:RegisterEffect(e4)
	--spsummon condition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(c57888891.splimit1)
	c:RegisterEffect(e5)
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetOperation(c57888891.atklimit)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
	--tohand
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(57888891,1))
	e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetCondition(c57888891.thcon)
	e9:SetTarget(c57888891.thtg)
	e9:SetOperation(c57888891.thop)
	c:RegisterEffect(e9)
	--place pcard
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCountLimit(1)
	e10:SetCondition(c57888891.pencon)
	e10:SetCost(c57888891.pencost)
	e10:SetTarget(c57888891.pentg)
	e10:SetOperation(c57888891.penop)
	c:RegisterEffect(e10)
	--summon limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e11:SetCondition(c57888891.sumcon)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e12)
end
function c57888891.sumcon(e,c)
	if not c then return true end
	return false
end
function c57888891.splimit2(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x62) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c57888891.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c57888891.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bt=Duel.GetAttackTarget()
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and bt and bt:IsFaceup() and bt:IsType(TYPE_TOON)
		and bt:GetControler()==e:GetHandlerPlayer() and Duel.SelectYesNo(tp,aux.Stringid(57888891,1)) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c57888891.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=Duel.GetAttackTarget()
	return bt and bt:IsFaceup() and bt:IsType(TYPE_TOON) and bt:GetControler()==e:GetHandlerPlayer()
end
function c57888891.cbop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.ChangeAttackTarget(nil)
	end
end
function c57888891.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c57888891.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c57888891.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c57888891.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c57888891.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c57888891.splimit1(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_HAND) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c57888891.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c57888891.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c57888891.thfilter(c)
	return c:IsType(TYPE_TOON) and c:IsAbleToHand()
end
function c57888891.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57888891.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c57888891.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c57888891.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c57888891.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c57888891.penfilter4(c)
    return c:IsType(TYPE_PENDULUM)
end
function c57888891.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c57888891.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c57888891.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c57888891.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c57888891.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end