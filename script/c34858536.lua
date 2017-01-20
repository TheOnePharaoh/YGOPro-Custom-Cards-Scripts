--Golden Warrior of Miracle
function c34858536.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--cannot negate summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--cannot negate effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c34858536.sumsuc)
	c:RegisterEffect(e4)
	--special summon rule
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(c34858536.spcon)
	e5:SetOperation(c34858536.spop)
	c:RegisterEffect(e5)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_ADD_TYPE)
	e6:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE)
	e6:SetValue(TYPE_PENDULUM)
	c:RegisterEffect(e6)
	--prevent destroy battle
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--prevent target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c34858536.efilter)
	c:RegisterEffect(e8)
	--copy spell/trap effect
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(34858536,0))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCost(c34858536.scost)
	e9:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e9:SetTarget(c34858536.starget)
	e9:SetOperation(c34858536.soperation)
	c:RegisterEffect(e9)
	--Monster Clone
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(34858536,1))
	e10:SetType(EFFECT_TYPE_QUICK_O)
    e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(c34858536.mcost)
	e10:SetOperation(c34858536.moperation)
	c:RegisterEffect(e10)
	--return
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_TO_GRAVE)
	e11:SetCost(c34858536.rtcost)
	e11:SetTarget(c34858536.rttg)
	e11:SetOperation(c34858536.rtop)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e12)
	local e13=e11:Clone()
	e13:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e13)
	local e19=e11:Clone()
	e19:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e19)
	--spsummon condition
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e14:SetCode(EFFECT_SPSUMMON_CONDITION)
	e14:SetValue(c34858536.splimit)
	c:RegisterEffect(e14)
	--negate battled monster's effect
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e15:SetCode(EVENT_BE_BATTLE_TARGET)
	e15:SetOperation(c34858536.negop1)
	c:RegisterEffect(e15)
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e16:SetCode(EVENT_ATTACK_ANNOUNCE)
	e16:SetOperation(c34858536.negop2)
	c:RegisterEffect(e16)
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e17:SetCode(EVENT_BATTLE_END)
	e17:SetCondition(c34858536.negcon)
	e17:SetOperation(c34858536.negop3)
	c:RegisterEffect(e17)
	--activate limit
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetRange(LOCATION_MZONE)
	e18:SetCode(EFFECT_CANNOT_ACTIVATE)
	e18:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e18:SetTargetRange(0,1)
	e18:SetCondition(c34858536.actcon)
	e18:SetValue(1)
	c:RegisterEffect(e18)
end
function c34858536.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c34858536.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c34858536.spfilter(c,code)
	return c:IsFaceup() and (c:IsCode(34858501) or c:IsCode(34858504) or c:IsCode(34858506) or c:IsCode(34858516) or c:IsCode(34858517) or c:IsCode(34858518) or c:IsCode(34858531)) and c:IsAbleToRemoveAsCost() 
end
function c34858536.spcon(e,c)
	if c==nil then return true end 
	local g=Duel.GetMatchingGroup(c34858536.spfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=3
end
function c34858536.spfilter2(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsAbleToRemoveAsCost() 
end
function c34858536.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c34858536.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,34858501)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c34858536.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,34858504)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c34858536.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,34858506)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=Duel.SelectMatchingCard(tp,c34858536.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,34858516)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g5=Duel.SelectMatchingCard(tp,c34858536.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,34858517)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g6=Duel.SelectMatchingCard(tp,c34858536.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,34858518)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g7=Duel.SelectMatchingCard(tp,c34858536.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,34858531)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	g1:Merge(g5)
	g1:Merge(g6)
	g1:Merge(g7)
	if g1:GetCount()<3 then return false end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(g1:GetCount()*1000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENCE)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetValue(g1:GetCount()*1000)
	c:RegisterEffect(e2)
	if g1:GetCount()>6 then
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c34858536.efilter)
	c:RegisterEffect(e3)
	end
end
function c34858536.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c34858536.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and Duel.IsExistingMatchingCard(c34858536.sfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
        local tc=Duel.SelectMatchingCard(tp,c34858536.sfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
        local te,eg,ep,ev,re,r,rp=tc:GetFirst():CheckActivateEffect(false,true,true)
        e:SetLabelObject(tc:GetFirst())
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,500)
end
function c34858536.sfilter(c,e,tp,eg,ep,ev,re,r,rp)
	return (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_QUICKPLAY or c:GetType()==TYPE_TRAP or c:GetType()==TYPE_COUNTER) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil
end
function c34858536.starget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,1,true)
	end
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	local te,eg,ep,ev,re,r,rp=tc:CheckActivateEffect(false,true,true)
	local tg=te:GetTarget()
        e:SetLabelObject(te)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c34858536.soperation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
        if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c34858536.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and Duel.IsExistingMatchingCard(c34858536.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
        local tc=Duel.SelectMatchingCard(tp,c34858536.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
        e:SetLabelObject(tc:GetFirst())
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
    Duel.PayLPCost(tp,500)
end
function c34858536.mfilter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsType(TYPE_EFFECT) and not c:IsHasEffect(EFFECT_FORBIDDEN) and c:IsAbleToRemoveAsCost()
end
function c34858536.moperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local atk=tc:GetTextAttack()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(atk)
        c:RegisterEffect(e1)
	end
end
function c34858536.rtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c34858536.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c34858536.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(4000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENCE)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetValue(4000)
	c:RegisterEffect(e2)
	end
end
function c34858536.negop1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		a:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		a:RegisterEffect(e2)
	end
end
function c34858536.negop2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e2)
	end
end
function c34858536.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c34858536.negop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e2)
end
function c34858536.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end