--Evil HERO Blaze Burner
function c888000010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x8),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000010.splimit)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000010,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c888000010.drcon)
	e2:SetTarget(c888000010.drtg)
	e2:SetOperation(c888000010.drop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c888000010.indesval)
	c:RegisterEffect(e3)
end
c888000010.dark_calling=true
function c888000010.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c888000010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c888000010.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_EP)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetCondition(c888000010.becon)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c888000010.becon(e)
	return e:GetHandler():IsAttackable()
end
function c888000010.indesval(e,re)
	return re:IsActiveType(TYPE_TRAP)
end
