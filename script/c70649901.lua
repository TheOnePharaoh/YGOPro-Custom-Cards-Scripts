--ADE Aztaroth
function c70649901.initial_effect(c)
	--self destruct
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70649901,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(c70649901.descon)
	e1:SetTarget(c70649901.destg)
	e1:SetOperation(c70649901.desop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70649901,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c70649901.thcon)
	e2:SetTarget(c70649901.thtg)
	e2:SetOperation(c70649901.thop)
	c:RegisterEffect(e2)
end
function c70649901.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_NORMAL)~=0
		and e:GetHandler():GetTurnID()==Duel.GetTurnCount()
end
function c70649901.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c70649901.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c70649901.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c70649901.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a214) and not c:IsCode(70649901) and c:IsAbleToHand()
end
function c70649901.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70649901.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c70649901.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c70649901.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
