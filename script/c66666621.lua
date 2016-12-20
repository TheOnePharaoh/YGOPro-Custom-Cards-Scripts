--Aetherial Girl Iona
function c66666621.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,66666621)
	e2:SetDescription(aux.Stringid(66666621,1))
	e2:SetTarget(c66666621.rmtg)
	e2:SetOperation(c66666621.rmop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66666621,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,66666721)
	e3:SetTarget(c66666621.target)
	e3:SetOperation(c66666621.operation)
	c:RegisterEffect(e3)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c66666621.splimit)
	c:RegisterEffect(e6)
end

function c66666621.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c66666621.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil)and e:GetHandler():IsDestructable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c66666621.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

function c66666621.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x144) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c66666621.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66666621.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666621.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c66666621.sumfilter,tp,LOCATION_MZONE,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c66666621.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c66666621.sumfilter(c)
	return c:IsSetCard(0x144) and c:IsSummonable(true,nil)
end
function c66666621.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c66666621.sumfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
