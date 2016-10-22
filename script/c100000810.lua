function c100000810.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--hint
	local e4=Effect.CreateEffect(c)
	e4:SetHintTiming(TIMING_STANDBY_PHASE,0)
	e4:SetTarget(c100000810.tgtg1)
	e4:SetOperation(c100000810.tgop2)
	c:RegisterEffect(e4)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c100000810.tgcon)
	e2:SetCost(c100000810.tgcost)
	e2:SetTarget(c100000810.tgtg2)
	e2:SetOperation(c100000810.tgop2)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000810,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c100000810.thtg)
	e3:SetOperation(c100000810.thop)
	c:RegisterEffect(e3)
end
function c100000810.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY
		and Duel.IsExistingMatchingCard(c100000810.filtertog,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100000810,0)) then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:GetHandler():RegisterFlagEffect(100000810,RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100000810,1))
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function c100000810.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100000810.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100000810)==0 end
	e:GetHandler():RegisterFlagEffect(100000810,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100000810.filtertog(c)
	return c:IsSetCard(0x109) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c100000810.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000810.filtertog,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100000810.tgop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(100000810)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100000810.filtertog,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then end
		Duel.SendtoGrave(g,REASON_EFFECT)
end
function c100000810.filterd(c)
	return c:IsFaceup() and c:IsCode(100000802) and c:IsAbleToDeck()
end
function c100000810.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
return Duel.IsExistingMatchingCard(c100000810.filterd,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c100000810.thop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTODECK)
	local g=Duel.SelectMatchingCard(tp,c100000810.filterd,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.SendtoDeck(g,nil,REASON_EFFECT,nil)
			Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
end