--Panticle Zero - Terra God
function c80106530.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c80106530.spcon)
	e2:SetOperation(c80106530.spop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c80106530.immfilter)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c80106530.tgfilter)
	c:RegisterEffect(e4)
	--chain attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80106530,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLED)
	e5:SetCondition(c80106530.atcon)
	e5:SetCost(c80106530.spcost)
	e5:SetOperation(c80106530.atop)
	c:RegisterEffect(e5)
	--salvate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80106530,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c80106530.thcon)
	e6:SetCost(c80106530.thcost)
	e6:SetTarget(c80106530.thtg)
	e6:SetOperation(c80106530.thop)
	c:RegisterEffect(e6)
end
function c80106530.otfilter(c,tp)
	return c:IsSetCard(0xca00) and (c:IsControler(tp) or c:IsFaceup())
end
function c80106530.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local rg=Duel.GetReleaseGroup(tp)
	return (g:GetCount()>0 or rg:GetCount()>0) and g:FilterCount(c80106530.otfilter,nil)==g:GetCount()
end
function c80106530.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Release(g,REASON_COST)
	local atk=0
	local tc=g:GetFirst()
	while tc do
		local batk=tc:GetTextAttack()
		if batk>0 then
			atk=atk+batk
		end
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c80106530.immfilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c80106530.tgfilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c80106530.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetFlagEffect(80106530)==0
		and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c80106530.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c80106530.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c80106530.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c80106530.thfilter(c)
	return c:IsSetCard(0xca00) and not c:IsCode(80106530) and c:IsAbleToRemoveAsCost()
end
function c80106530.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80106530.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80106530.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80106530.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c80106530.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
