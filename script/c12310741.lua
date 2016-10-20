--Lordran - Land of the Ancient Lords
--lua script by SGJin
function c12310741.initial_effect(c)
	c:EnableCounterPermit(0x10cb)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetOperation(c12310741.ctop)
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310741,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c12310741.desreptg)
	e3:SetOperation(c12310741.desrepop)
	c:RegisterEffect(e3)
	--damage reduce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c12310741.rdcon)
	e4:SetOperation(c12310741.rdop)
	c:RegisterEffect(e4)
	--Drops Humanities
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12310741,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c12310741.thcon)
	e5:SetCost(c12310741.thcost)
	e5:SetTarget(c12310741.thtg)
	e5:SetOperation(c12310741.thop)
	c:RegisterEffect(e5)
end
function c12310741.ctfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_DESTROY)
end
function c12310741.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c12310741.ctfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x10cb,ct)
	end
end
function c12310741.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x10cb)>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(12310741,0))
end
function c12310741.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x10cb,1,REASON_EFFECT)
end
function c12310741.rdcon(e)
	return e:GetHandler():GetCounter(0x10cb)>=2
end
function c12310741.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
	Duel.ChangeBattleDamage(1-tp,ev/2)
end
function c12310741.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x10cb)>=4
end
function c12310741.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x10cb,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x10cb,3,REASON_COST)
end
function c12310741.filter(c)
	local code=c:GetCode()
	return (code==12310712 or code==12310713 or code==12310730) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12310741.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310741.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c12310741.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12310741.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
