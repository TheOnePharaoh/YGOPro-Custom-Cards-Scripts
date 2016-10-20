--Jiang Shi, The Twilight Taoist Dragon
function c53789781.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c53789781.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0x0cab90),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c53789781.splimit)
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
	e3:SetOperation(c53789781.retreg)
	c:RegisterEffect(e3)
	--cannot search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53789781,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c53789781.spiritcon)
	e4:SetOperation(c53789781.spiritop)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(53789781,2))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,53789781)
	e5:SetCondition(c53789781.negcon)
	e5:SetTarget(c53789781.negtg)
	e5:SetOperation(c53789781.negop)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(53789781,3))
	e6:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_SPSUMMON)
	e6:SetCountLimit(1,53789781)
	e6:SetCondition(c53789781.discon)
	e6:SetTarget(c53789781.distg)
	e6:SetOperation(c53789781.disop)
	c:RegisterEffect(e6)
end
function c53789781.splimit(e,se,sp,st)
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then 
		return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	return true
end
function c53789781.ffilter(c)
	return c:IsType(TYPE_SPIRIT)
end
function c53789781.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(53789781,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c53789781.retcon)
	e1:SetTarget(c53789781.rettg)
	e1:SetOperation(c53789781.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c53789781.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c53789781.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c53789781.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c53789781.spiritcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c53789781.spiritop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c53789781.sumcon)
	e1:SetLabel(Duel.GetTurnCount())
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	end
end
function c53789781.sumcon(e)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()~=e:GetOwnerPlayer()
end
function c53789781.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c53789781.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c53789781.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c53789781.displfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c53789781.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c53789781.displfilter,1,nil,1-tp)
end
function c53789781.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c53789781.displfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c53789781.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c53789781.displfilter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
