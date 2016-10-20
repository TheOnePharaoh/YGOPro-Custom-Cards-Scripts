--The Tsuiho Movement
function c816000005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetCountLimit(1,81600005+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c816000005.condition)
	e1:SetTarget(c816000005.target)
	e1:SetOperation(c816000005.activate)
	c:RegisterEffect(e1)
	--add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(816000005,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c816000005.thtg)
	e2:SetOperation(c816000005.thop)
	c:RegisterEffect(e2)
end
function c816000005.cfilter(c)
	return c:IsSetCard(0x330) and c:IsType(TYPE_MONSTER)
end
function c816000005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c816000005.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function c816000005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350) 
		and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c816000005.activate(e,tp,eg,ep,ev,re,r,rp)
	local dice=Duel.TossDice(tp,1)
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	if dice==1 then
		local g=Duel.GetDecktopGroup(tp,1)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif dice==2 then
		Duel.SortDecktop(tp,tp,2)
		Duel.BreakEffect()
		local g=Duel.GetDecktopGroup(tp,1)
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	elseif dice==3 then
		Duel.SortDecktop(tp,tp,3)
		Duel.BreakEffect()
		local g=Duel.GetDecktopGroup(tp,1)
		Duel.DisableShuffleCheck()
		if Duel.Remove(g,POS_FACEUP,REASON_COST)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif dice==4 then
		Duel.SortDecktop(tp,tp,4)
		Duel.BreakEffect()
		local g=Duel.GetDecktopGroup(tp,2)
		Duel.DisableShuffleCheck()
		if Duel.Remove(g,POS_FACEUP,REASON_COST)>1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif dice==5 then
		Duel.SortDecktop(tp,tp,5)
		Duel.BreakEffect()
		local g=Duel.GetDecktopGroup(tp,1)
		Duel.DisableShuffleCheck()
		if Duel.Remove(g,POS_FACEUP,REASON_COST)>0 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	else
		Duel.SortDecktop(tp,tp,6)
		Duel.BreakEffect()
		local g=Duel.GetDecktopGroup(tp,2)
		Duel.DisableShuffleCheck()
		if Duel.Remove(g,POS_FACEUP,REASON_COST)>1 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end
function c816000005.afilter(c)
	return c:IsSetCard(0x330) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:GetCode()~=816000005
end
function c816000005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c816000005.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c816000005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c816000005.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
