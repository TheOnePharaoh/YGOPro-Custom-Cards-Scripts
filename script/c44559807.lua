--Returnee of the Heroes
function c44559807.initial_effect(c)
	c:SetUniqueOnField(1,0,44559807)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCountLimit(1,44559807)
	e1:SetTarget(c44559807.acttg)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--check id
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(44559807)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c44559807.mtcon)
	e4:SetOperation(c44559807.mtop)
	c:RegisterEffect(e4)
	--dig
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1e0)
	e5:SetCountLimit(1,44559807)
	e5:SetTarget(c44559807.drtg)
	e5:SetOperation(c44559807.drop)
	c:RegisterEffect(e5)
end
function c44559807.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if c44559807.drcost(e,tp,eg,ep,ev,re,r,rp,0) and c44559807.drtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c44559807.drop)
		c44559807.drcost(e,tp,eg,ep,ev,re,r,rp,1)
		c44559807.drtg(e,tp,eg,ep,ev,re,r,rp,1,chkc)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c44559807.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(44559807)==0 end
	e:GetHandler():RegisterFlagEffect(44559807,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c44559807.tdfilter(c)
	return c:IsSetCard(0x2016) or c:IsSetCard(0x2017) or c:IsCode(44559811) or c:IsCode(44559832) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c44559807.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c44559807.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c44559807.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c44559807.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c44559807.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end

function c44559807.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c44559807.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>1000 and Duel.SelectYesNo(tp,aux.Stringid(44559807,0)) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end