--Hydrush Evaporation
function c83070015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(8307)
	e2:SetCondition(c83070015.ctcon)
	e2:SetOperation(c83070015.ctop)
	c:RegisterEffect(e2)
	--to deck & draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83070015,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,83070015)
	e3:SetCost(c83070015.spcost)
	e3:SetTarget(c83070015.sptg)
	e3:SetOperation(c83070015.spop)
	c:RegisterEffect(e3)
end
function c83070015.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c83070015.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1837,1)
end
function c83070015.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1837,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1837,3,REASON_COST)
end
function c83070015.filter(c)
	return c:IsSetCard(0x837) and c:IsAbleToDeck()
end
function c83070015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c83070015.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c83070015.filter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c83070015.tgfilter(c,e)
	return not c:IsRelateToEffect(e)
end
function c83070015.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:IsExists(c83070015.tgfilter,1,nil,e) then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
