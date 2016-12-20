--Aetherial Girl Alice
function c66666601.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,66666601)
	e2:SetTarget(c66666601.pentg)
	e2:SetOperation(c66666601.penop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66666601,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c66666601.cost)
	e3:SetCountLimit(1,66666603)
	e3:SetTarget(c66666601.target)
	e3:SetOperation(c66666601.operation)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66666601,2))
	e4:SetCost(c66666601.discost)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,66666603)
	e4:SetTarget(c66666601.thtg)
	e4:SetOperation(c66666601.thop)
	c:RegisterEffect(e4)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c66666601.splimit)
	c:RegisterEffect(e6)
end

function c66666601.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c66666601.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c66666601.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function c66666601.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c66666601.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end

function c66666601.penfilter(c)
	return c:IsSetCard(0x144) and c:IsType(TYPE_PENDULUM) and not c:IsCode(66666601) and not c:IsForbidden()
end

function c66666601.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c66666601.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666601.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66666601.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66666601.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c66666601.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.CheckReleaseGroup(tp,c66666601.cfilter,1,c) end
	local g=Duel.SelectReleaseGroup(tp,c66666601.cfilter,1,1,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end

function c66666601.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666601.stfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66666601.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66666601.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c66666601.filter(c)
	return c:IsSetCard(0x144) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c66666601.cfilter(c)
	return c:IsSetCard(0x144) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c66666601.stfilter(c)
	return c:IsSetCard(0x144) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsAbleToHand()
end