--Gaping Dragon
--lua script by SGJin
function c12310735.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Special Summon cant be negated
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--Summon Success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c12310735.sumsuc)
	c:RegisterEffect(e3)
	--Destroys 2 Spell / Trap cards (Stomach Acid Attack)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310735,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c12310735.descost)
	e4:SetTarget(c12310735.destg)
	e4:SetOperation(c12310735.desop)
	c:RegisterEffect(e4)
	--Drops Humanity
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12310735,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c12310735.thcon)
	e5:SetTarget(c12310735.thtg)
	e5:SetOperation(c12310735.thop)
	c:RegisterEffect(e5)
end
function c12310735.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c12310735.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>=1000 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c12310735.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c12310735.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c12310735.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310735.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12310735.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c12310735.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c12310735.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12310735.filter(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310735.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310735.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12310735.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310735.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
