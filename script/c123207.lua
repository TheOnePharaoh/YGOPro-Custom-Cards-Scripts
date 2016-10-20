--Arcana Force XI The Justice
function c123207.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123207,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c123207.cointg)
	e1:SetOperation(c123207.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c123207.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123207.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123207.arcanareg(c,res)
end
function c123207.arcanareg(c,coin)
	--coin effect 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c123207.con)
	e1:SetOperation(c123207.negop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	-- 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PHASE+PHASE_DRAW)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c123207.con2)
	e2:SetOperation(c123207.recop)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c123207.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123207.negop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end	
function c123207.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffectLabel(36690018)==0
end	
function c123207.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,500,REASON_EFFECT)
end
