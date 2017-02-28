--Void
function c34858538.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c34858538.spcon)
	e2:SetOperation(c34858538.spop)
	c:RegisterEffect(e2)
	--cannot negate summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--cannot negate effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e5)
	--summon success
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c34858538.sumsuc)
	c:RegisterEffect(e6)
	--atk/def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SET_BASE_ATTACK)
	e7:SetValue(4000)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_SET_BASE_DEFENSE)
	e8:SetValue(4000)
	c:RegisterEffect(e8)
	--immune
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	--prevent destroy battle
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e10:SetValue(c34858538.indes)
	c:RegisterEffect(e10)
	--damage val
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e11:SetValue(c34858538.indes)
	c:RegisterEffect(e11)
	--control
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCategory(CATEGORY_CONTROL)
	e12:SetCountLimit(1)
	e12:SetTarget(c34858538.cttar)
	e12:SetOperation(c34858538.ctop)
	c:RegisterEffect(e12)
	--return
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_LEAVE_FIELD)
	e13:SetCondition(c34858538.recon)
	e13:SetOperation(c34858538.reop)
	c:RegisterEffect(e13)
	--remove
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e14:SetCondition(c34858538.rmcon)
	e14:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e14)
end
function c34858538.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c34858538.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(c:GetControler(),nil,3,nil)
end
function c34858538.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),nil,3,3,nil)
	Duel.Release(g,REASON_COST)
end
function c34858538.vfilter(c)
	return c:IsFaceup()
end
function c34858538.indes(e,c)
	return not c:IsCode(34858536)
end
function c34858538.filter(c)
	return c:IsControlerCanBeChanged()
end
function c34858538.cttar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c34858538.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c34858538.filter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c34858538.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c34858538.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(500)
		tc:RegisterEffect(e2)
	end
	Duel.GetControl(tc,tp)
end
function c34858538.recon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_BATTLE)==0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c34858538.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=1
	if Duel.GetCurrentPhase==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
	count=2
	end
	c:RegisterFlagEffect(34858538,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,count)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,count)
	e1:SetCountLimit(1)
	e1:SetOperation(c34858538.spop2)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function c34858538.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	ct=ct+1
	c:SetTurnCounter(ct)
	if c:GetFlagEffect(34858538)~=0 and ct==1 then
		Duel.SpecialSummon(c,1,tp,tp,true,true,POS_FACEUP)
	end
end
function c34858538.rmcon(e)
	local c=e:GetHandler()
	return (c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE))
end
