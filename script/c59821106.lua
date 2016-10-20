--Idol's Call
function c59821106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59821106,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(c59821106.condition)
	e1:SetCost(c59821106.cost)
	e1:SetTarget(c59821106.target)
	e1:SetOperation(c59821106.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(59821106,ACTIVITY_CHAIN,c59821106.chainfilter)
end
function c59821106.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc,seq=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return not (re:IsActiveType(TYPE_SPELL) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and loc==LOCATION_SZONE and (seq==6 or seq==7) and rc:IsSetCard(0xa1a2))
end
function c59821106.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(59821106,tp,ACTIVITY_CHAIN)==0
end
function c59821106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(59821106,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c59821106.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c59821106.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa1a2)
end
function c59821106.thfilter(c)
	return c:IsLevelBelow(4) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa1a2) and c:IsAbleToHand()
end
function c59821106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,59821106)==0 end
	Duel.RegisterFlagEffect(tp,59821106,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c59821106.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821106.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821106,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(59821106,1)) then
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end
