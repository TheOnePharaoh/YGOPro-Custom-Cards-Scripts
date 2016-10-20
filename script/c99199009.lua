--The Future Gear Chronos the Almighty
function c99199009.initial_effect(c)
	c:SetSPSummonOnce(99199009)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xff15),3,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99199009.splimit)
	c:RegisterEffect(e1)
	--aclimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c99199009.accon)
	e2:SetValue(c99199009.aclimit)
	c:RegisterEffect(e2)
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199009,0))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99199009.coincon)
	e3:SetTarget(c99199009.cointg)
	e3:SetOperation(c99199009.coinop)
	c:RegisterEffect(e3)
end
function c99199009.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c99199009.accon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c99199009.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c99199009.coincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c99199009.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c99199009.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==3 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif c1+c2+c3==2 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	elseif c1+c2+c3==1 then
		local g=Duel.GetMatchingGroup(c99199009.thfilter,tp,LOCATION_MZONE,0,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c99199009.thfilter(c)
	return c:IsSetCard(0xff15) and not c:IsCode(99199009) and c:IsAbleToHand()
end