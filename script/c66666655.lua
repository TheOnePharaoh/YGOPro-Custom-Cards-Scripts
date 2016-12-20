--Ignis, Daughter of Combustion
function c66666655.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666655,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
--	e2:SetCost(c66666655.cost)
	e2:SetCountLimit(1,66666655)
	e2:SetTarget(c66666655.target)
	e2:SetOperation(c66666655.operation)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c66666655.splimit)
	c:RegisterEffect(e3)
	--tuner
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66666655,2))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
--	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c66666655.tnrtarget)
	e4:SetOperation(c66666655.tnrop)
	c:RegisterEffect(e4)
	--SS from grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66666655,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c66666655.sptg)
	e5:SetOperation(c66666655.spop)
	c:RegisterEffect(e5)
	

end
function c66666655.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x29b) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c66666655.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x29b) and c:IsDestructable()
end
function c66666655.dkfilter(c)
	return c:IsSetCard(0x29b) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c66666655.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		
end
function c66666655.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666655.dkfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66666655.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66666655.dkfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
			if not Duel.IsExistingMatchingCard(c66666655.filter,tp,LOCATION_ONFIELD,0,1,nil)then return end
			local g=Duel.GetMatchingGroup(c66666655.filter,tp,LOCATION_ONFIELD,0,nil)
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,c66666655.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end

function c66666655.tnrfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x29b) and c:GetLevel()>0 and not c:IsType(TYPE_TUNER)
end
function c66666655.tnrtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c66666655.tnrfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666655.tnrfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666655.tnrfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66666655.tnrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c66666655.tnrfilter(tc) then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end


function c66666655.spfilter(c,e,tp)
	return c:IsSetCard(0x29b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(66666655)
end
function c66666655.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66666655.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c66666655.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c66666655.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c66666655.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end