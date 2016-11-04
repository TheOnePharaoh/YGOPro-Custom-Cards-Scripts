--Offerings of the Dragonsbane - Eternal Inferno
function c66660016.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66660016,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e1:SetLabel(1,66660016)
	e1:SetCost(c66660016.cost)
	e1:SetTarget(c66660016.target)
	e1:SetOperation(c66660016.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66660016,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e2:SetLabel(1,66660016)
	e2:SetCost(c66660016.cost2)
	e2:SetTarget(c66660016.target2)
	e2:SetOperation(c66660016.activate2)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66660016,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,66660016)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c66660016.rmcost)
	e3:SetTarget(c66660016.rmtg)
	e3:SetOperation(c66660016.rmop)
	c:RegisterEffect(e3)
end
function c66660016.cfilter2(c)
	return c:IsRace(RACE_FIEND)
end
function c66660016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c66660016.cfilter2,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c66660016.cfilter2,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c66660016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c66660016.nfilter(c,e)
	return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT and not (c:IsImmuneToEffect(e) or c:IsDisabled())
end
function c66660016.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(c66660016.nfilter,tp,0,LOCATION_MZONE,nil,e)
	local tc=ng:GetFirst()
	while tc do
		--disable
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=ng:GetNext()
	end
end
function c66660016.cfilter(c,def)
	return c:IsRace(RACE_DRAGON) and c:IsAttackAbove(def)
end
function c66660016.filter(c,atk)
	return c:IsFaceup() and c:IsDestructable() and (not atk or c:Is
DefenseBelow(atk))
end
function c66660016.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c66660016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if g:GetCount()==0 then return false end
		local mg,mdef=g:GetMinGroup(Card.Get
Defense)
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c66660016.cfilter,1,nil,mdef)
	end
	local g=Duel.GetMatchingGroup(c66660016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local mg,mdef=g:GetMinGroup(Card.Get
Defense)
	local rg=Duel.SelectReleaseGroup(tp,c66660016.cfilter,1,1,nil,mdef)
	e:SetLabel(rg:GetFirst():GetAttack())
	Duel.Release(rg,REASON_COST)
end
function c66660016.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==0 end
	local dg=Duel.GetMatchingGroup(c66660016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c66660016.activate2(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c66660016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	Duel.Destroy(dg,REASON_EFFECT)
end
function c66660016.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c66660016.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66660016.filter1(c,tp)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and (c:IsAbleToDeck() or c:IsAbleToGrave())
		and Duel.IsExistingTarget(c66660016.filter2,tp,LOCATION_REMOVED,0,1,nil)
end
function c66660016.filter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and (c:IsAbleToDeck() or c:IsAbleToGrave())
end
function c66660016.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c66660016.filter1,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c66660016.filter1,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c66660016.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c66660016.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		if tc==g:GetFirst() then
			sg:AddCard(g:GetNext())
		else
			sg:AddCard(g:GetFirst())
		end
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		sg:RemoveCard(tc)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end 