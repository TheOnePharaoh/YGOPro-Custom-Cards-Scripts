--Arcana Force IX The Hermit
function c123205.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123205,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c123205.cointg)
	e1:SetOperation(c123205.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c123205.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123205.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123205.arcanareg(c,res)
end
function c123205.arcanareg(c,coin)
	-- coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(c123205.macon)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c123205.aclimit)
	e2:SetCondition(c123205.con)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c123205.macon(e)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123205.con(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=0x08 and ph<=0x20 and e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function c123205.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP+TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
