--Earthbound Immortal Itzpezpalotl
function c53704343.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53704343,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c53704343.sccon)
	e2:SetOperation(c53704343.scop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53704343,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c53704343.cost)
	e3:SetTarget(c53704343.target)
	e3:SetOperation(c53704343.operation)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c53704343.sdcon)
	c:RegisterEffect(e4)
	--battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--direct atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
	--shuffle to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(53704343,3))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c53704343.tdtg)
	e7:SetOperation(c53704343.tdop)
	c:RegisterEffect(e7)
end
function c53704343.sccon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x21)
end
function c53704343.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
end
function c53704343.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c53704343.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c53704343.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53704343.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53704343.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53704343.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c53704343.sdcon(e)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return ((f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup()))
end
function c53704343.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c53704343.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c53704343.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c53704343.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c53704343.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c53704343.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end