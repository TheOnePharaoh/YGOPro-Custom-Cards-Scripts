--The Future Gear Chain Dragon
function c99199020.initial_effect(c)
	c:SetSPSummonOnce(99199020)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199020.splimit)
	e2:SetCondition(c99199020.splimcon)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c99199020.thtg)
	e3:SetOperation(c99199020.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c99199020.condition)
	c:RegisterEffect(e4)
	--extra summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e5:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e5:SetCondition(c99199020.fscon)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff15))
	c:RegisterEffect(e5)
	--scale
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_CHANGE_LSCALE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c99199020.sccon)
	e6:SetValue(4)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e7)
end
function c99199020.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xff15)
end
function c99199020.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199020.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199020.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c99199020.filter(c)
	return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and not c:IsCode(99199020) and c:IsAbleToHand()
end
function c99199020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199020.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99199020.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99199020.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99199020.fscon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsSetCard(0xff15)
end
