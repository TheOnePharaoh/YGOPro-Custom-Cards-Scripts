--Shinigami, Tsuiho Demise Reaper 
function c816000006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x330),4,3)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c816000006.bancost)
	e1:SetTarget(c816000006.bantg)
	e1:SetOperation(c816000006.banop)
	c:RegisterEffect(e1)
	--end turn/order and banish deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(816000004,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c816000006.etcon)
	e2:SetTarget(c816000006.ettg)
	e2:SetOperation(c816000006.etop)
	c:RegisterEffect(e2)
	--selfbanish
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c816000006.sbop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_ADJUST)
	c:RegisterEffect(e4)
end
function c816000006.bancost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c816000006.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c816000006.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		local code=tc:GetCode()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(EFFECT_FORBIDDEN)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0xff,0xff)
		e2:SetTarget(c816000006.tg)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		e2:SetLabel(code)
		c:RegisterEffect(e2)
	end
end
function c816000006.tg(e,c)
	return c:IsCode(e:GetLabel()) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function c816000006.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c816000006.ettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c816000006.etop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	Duel.SortDecktop(tp,tp,5)
	Duel.BreakEffect()
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c816000006.sbop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()==0 then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	end
end
