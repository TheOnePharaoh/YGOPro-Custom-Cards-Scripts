--Arcana Force II The High Priestess
function c123203.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123203,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c123203.cointg)
	e1:SetOperation(c123203.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c123203.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123203.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123203.arcanareg(c,res)
end
function c123203.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123203,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c123203.efilter)
	e1:SetValue(c123203.evalue)
	e1:SetCondition(c123203.econ)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(123203,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c123203.evalue2)
	e2:SetCondition(c123203.econ2)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c123203.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123203.efilter(e,c)
	return c:IsSetCard(0x5) and c:IsFaceup()
end
function c123203.evalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c123203.econ2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function c123203.evalue2(e,re,rp)
	return rp==e:GetHandlerPlayer()
end
