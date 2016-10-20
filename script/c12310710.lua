--Iron Golem
--lua script by SGJin
function c12310710.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--Change battle positions (Wind blade attack)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310710,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c12310710.cost)
	e1:SetTarget(c12310710.tg)
	e1:SetOperation(c12310710.op)
	c:RegisterEffect(e1)
	--to Defense mode at End Phase  (Stumbling Iron Golem)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12310710.poscon)
	e2:SetOperation(c12310710.posop)
	c:RegisterEffect(e2)
	--Chance to Drop Humanity
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310710,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c12310710.thcon)
	e4:SetTarget(c12310710.thtg)
	e4:SetOperation(c12310710.thop)
	c:RegisterEffect(e4)
end
function c12310710.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12310710.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c12310710.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
function c12310710.poscon(e)
	local c=e:GetHandler()
	return c:GetOverlayCount()==0 and c:IsAttackPos()
end
function c12310710.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c12310710.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12310710.filter(c)
	return c:IsCode(12310712) and c:IsAbleToHand()
end
function c12310710.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310710.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12310710.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310710.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
