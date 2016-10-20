--Arcana Force XVI The Tower
function c123209.initial_effect(c)
	--cannot change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(123209,0))
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c123209.cointg)
	e2:SetOperation(c123209.coinop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c123209.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123209.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123209.arcanareg(c,res)
end
function c123209.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123209,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c123209.con)
	e1:SetTarget(c123209.distg)
	e1:SetOperation(c123209.disop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	e2:SetCondition(c123209.econ)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c123209.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123209.disfilter(c)
	return c:IsSetCard(0x5) and c:IsDestructable()
end
function c123209.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c123209.disfilter,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(c123209.disfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c123209.disop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c123209.disfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c123209.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==0
end
