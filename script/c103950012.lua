--Ancient Twister
function c103950012.initial_effect(c)
	
	--Destroy 1 Spell/Trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950012,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c103950012.destgt)
	e1:SetOperation(c103950012.desop)
	c:RegisterEffect(e1)
	
	--Destroy 1 card in your Spell/Trap zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950012,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c103950012.dszcon)
	e2:SetCost(c103950012.dszcost)
	e2:SetTarget(c103950012.dsztgt)
	e2:SetOperation(c103950012.dszop)
	c:RegisterEffect(e2)
end

--Destroy 1 Spell/Trap filter
function c103950012.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

--Destroy 1 Spell/Trap target
function c103950012.destgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c103950012.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c103950012.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

--Destroy 1 Spell/Trap operation
function c103950012.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--Destroy 1 card in your Spell/Trap zone condition
function c103950012.dszcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end

--Destroy 1 card in your Spell/Trap zone cost
function c103950012.dszcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

--Destroy 1 card in your Spell/Trap zone filter
function c103950012.dszfilter(c)
	return c:GetSequence()~=5 and c:IsDestructable()
end

--Destroy 1 card in your Spell/Trap zone target
function c103950012.dsztgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) end
	if chk==0 then return Duel.IsExistingTarget(c103950012.dszfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c103950012.dszfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

--Destroy 1 card in your Spell/Trap zone operation
function c103950012.dszop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end