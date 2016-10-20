--Sun Ji, The Destiny Bearing Taoist Dragon
function c53789782.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c53789782.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0x0cab90),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c53789782.splimit)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--spsummon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c53789782.retreg)
	c:RegisterEffect(e3)
	--skip BP
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(53789782,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(c53789782.spiritcon)
	e5:SetOperation(c53789782.spiritop)
	c:RegisterEffect(e5)
	--activate limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c53789782.aclimit1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_CHAIN_NEGATED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c53789782.aclimit2)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,1)
	e8:SetCondition(c53789782.econ)
	e8:SetValue(c53789782.elimit)
	c:RegisterEffect(e8)
end
function c53789782.splimit(e,se,sp,st)
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then 
		return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	return true
end
function c53789782.ffilter(c)
	return c:IsType(TYPE_SPIRIT)
end
function c53789782.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(53789782,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c53789782.retcon)
	e1:SetTarget(c53789782.rettg)
	e1:SetOperation(c53789782.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c53789782.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c53789782.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c53789782.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c53789782.spiritcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c53789782.spiritop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=tp then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c53789782.bpcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c53789782.bpcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c53789782.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(53789782,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c53789782.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(53789782)
end
function c53789782.econ(e)
	return e:GetHandler():GetFlagEffect(53789782)~=0
end
function c53789782.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end