--Re-equip
function c20912286.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,20912286+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c20912286.cost)
	e1:SetTarget(c20912286.target)
	e1:SetOperation(c20912286.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(20912286,ACTIVITY_SPSUMMON,c20912286.counterfilter)
end
function c20912286.counterfilter(c)
	return c:IsSetCard(0xd0a2)
end
function c20912286.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(20912286,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c20912286.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c20912286.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xd0a2)
end
function c20912286.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c20912286.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c20912286.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c20912286.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20912286.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20912286.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct==3 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end