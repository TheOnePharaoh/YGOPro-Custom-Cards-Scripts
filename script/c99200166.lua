--Sector 01. The Dark Android Battlefield
function c99200166.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pay to act trap
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c99200166.actarget)
	e2:SetCost(c99200166.costchk)
	e2:SetOperation(c99200166.costop)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c99200166.tg)
	e3:SetValue(200)
	c:RegisterEffect(e3)
	--Def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c99200166.tg)
	e4:SetValue(200)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLED)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c99200166.thcon)
	e5:SetTarget(c99200166.thtg)
	e5:SetOperation(c99200166.thop)
	c:RegisterEffect(e5)
	--effect indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(1)
	e6:SetCondition(c99200166.edcon)
	c:RegisterEffect(e6)
end
function c99200166.actarget(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_TRAP)
end
function c99200166.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c99200166.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c99200166.tg(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c99200166.thcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return a:IsRace(RACE_MACHINE)
		and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99200166.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3790) and c:IsAbleToHand()
end
function c99200166.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99200166.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99200166.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99200166.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99200166.edfilter(c)
	return c:IsFaceup() and c:IsCode(99200163)
end
function c99200166.edcon(e)
	return Duel.IsExistingMatchingCard(c99200166.edfilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end